Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89A8534E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfHGS6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:58:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38884 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388681AbfHGS6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:58:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id u190so3031901qkh.5
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=WVunkXsG8XZbeEnoVNwmkqXUjwY5REKBxuYmjRJ7pSE=;
        b=prb0fQ20nSpHlLj8xDJX8RhqslqANtDYyEEqkcOeSONQfdbEfz9AngQjh+CA9AsxjG
         FSqn6q2hYJAwaLQtm3gHuomPLEd0B/2gHo1I/6T5bXitAkplZp6K3HizdxGpiDFBlR4y
         OcrTrh5WrViowoYDhWrkFvhTk5G2zWAWtXLAsHtgAkTMs1+dhH4NPriFZsn4KcZpEUwg
         /yNQRPboCVKOtmAHazRVM7kVrZJC0X6ee3miASFXezi7yn7n8ADbCBYn31OndYWZYeKJ
         04NNddmML8rww8+uiQqMnLBqtSmBiQSKREZYRgsIJXypWk7moxUb92eeQhNeeVupXg+a
         CANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WVunkXsG8XZbeEnoVNwmkqXUjwY5REKBxuYmjRJ7pSE=;
        b=nhHlUqjUaW8jRdZkP64vFiC6HYiq57h3lEBtJHAyQr6ok0G+hqrE05vugpOKdno3WK
         iTRixoAHOqlz/u8lL+PbvW7pdsqqu26s5qh/nIG0d6nkz4E1VpQ3yuQNZlZw/3UHwgCm
         SrO4mv30wmIRf0Pl6EQ8eTejHGECmo02MX+h9imKwPrPZkt6mAGuDkkGB/j3EfAHUggn
         JaFYcVjFI1hxYqxqdo/nRJmo9rojOOdA95TgkYFpsRQau6ALNjVhLfI1woaTAoMG/9Dt
         BZVNkgdG2dFUhVLx8yqedbqJy6HRJCFmywxJdSkc0oaDNczIYbQyaG84hCdnomH9pTe/
         H+WQ==
X-Gm-Message-State: APjAAAWmXUNhHK9rLVgTSaPfsnREG6AlsjN9ULwzgEBCu5VCe/KgQCTP
        Hg7DHWmiKgnBWsP6dqvSWPx0YQ==
X-Google-Smtp-Source: APXvYqz0QRm9BhUU0/fw0PPzRk3NX71ISJm9q8YNi3vplPmYN6yBJFp4uRPri0xc1KWdKw5UzpnzoA==
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr9936845qki.169.1565204304694;
        Wed, 07 Aug 2019 11:58:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y42sm57763692qtc.66.2019.08.07.11.58.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 11:58:24 -0700 (PDT)
Date:   Wed, 7 Aug 2019 11:57:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190807115755.26804e42@cakuba.netronome.com>
In-Reply-To: <153eb34b-05dd-4a85-88d8-e5723f41bbe3@gmail.com>
References: <20190806164036.GA2332@nanopsycho.orion>
        <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
        <20190806180346.GD17072@lunn.ch>
        <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
        <20190807025933.GF20422@lunn.ch>
        <153eb34b-05dd-4a85-88d8-e5723f41bbe3@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 21:10:40 -0600, David Ahern wrote:
> On 8/6/19 8:59 PM, Andrew Lunn wrote:
> > However, zoom out a bit, from networking to the whole kernel. In
> > general, across the kernel as a whole, resource management is done
> > with cgroups. cgroups is the consistent operational model across the
> > kernel as a whole.
> > 
> > So i think you need a second leg to your argument. You have said why
> > devlink is the right way to do this. But you should also be able to
> > say to Tejun Heo why cgroups is the wrong way to do this, going
> > against the kernel as a whole model. Why is networking special?
> >   
> 
> So you are saying mlxsw should be using a cgroups based API for its
> resources? netdevsim is for testing kernel APIs sans hardware. Is that
> not what the fib controller netdevsim is doing? It is from my perspective.

Why would all the drivers have to pay attention to resource limits?
Shouldn't we try to implement that at a higher layer?

> I am not the one arguing to change code and functionality that has
> existed for 16 months. I am arguing that the existing resource
> controller satisfies all existing goals (testing in kernel APIs) and
> even satisfies additional ones - like a consistent user experience
> managing networking resources. ie.., I see no reason to change what exists.

Please don't use the netdevsim code as an argument that something
already exists. The only legitimate use of that code is to validate
the devlink resource API and that the notifier can fail the insertion.

We try to encourage adding tests and are generally more willing to
merge test code. Possible abuse of that for establishing precedents 
is worrying.
