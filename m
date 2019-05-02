Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07F211A5A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEBNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:36:40 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:39454 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBNgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:36:40 -0400
Received: by mail-it1-f194.google.com with SMTP id t200so3392950itf.4;
        Thu, 02 May 2019 06:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZaRquiiRZ727WpMV1CUt4EPSYYxBfbOwZ0lGxB9EFk=;
        b=ZBQqCTAdJE4vcfm0ykvp8iCpcPnxzEbpJwwRGCR6EC/Uam4tWku1vfHeokv79O99c5
         bIjaiFJX9J29WNxUvZzoyvDjCcyctYPGaQF7biMiFRA6C3VpDe0GagQ8rS40kaz+NJz6
         kBAFWLCBhFjyLt1yJU1MBpNryQJQuwGByTGxyxPxTKOC/IqhWtnYSDpmRHWtNeXtYRla
         DEj4Ngm/8bBOKrlN4xP3nzWwb8tKtj6mHpQTXxQtD4Mn/m8xkYswuF5F4eYy38QzI/7x
         FHgWuIkYrigNRMJ/p8u/QPE+yWXK6NnQ+FYT/KXq/iMOyQ+pHCRSb7gUbTnpzXGYPeah
         CQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZaRquiiRZ727WpMV1CUt4EPSYYxBfbOwZ0lGxB9EFk=;
        b=tQu2bB+65acFSkfB7WSHvf59eXn/LYyDb48blobzxhQdVvgQvtgGSGfdTM8FhiXGES
         u48rjh4jjrN6R/fDi6DMmX/s83XLBxV4xspIsX8V4SDopgr0OcUZotjZTR+5AY7u4RUY
         REbEN8e3ALauztFp6b/gVLevRHGnNS/uyhfApu70Io/a64d4Yz5l2V0ZicNj1GMIC1Is
         ob793zPiLeu6SAlX618Zcc4eJB0VkhOR+cyXFuXbcU6Wul2oEjafj1zmOQSOn+CThVtv
         tjPft5JFqBLXOgRk1FBuxky3L/w8ArJn0In3PEzI1BJvJFICY0fSKAmRB9nOulDrrqrX
         6C5A==
X-Gm-Message-State: APjAAAUJOeKdthPuaa1EKO3kDboKi4HBRxfWOWc5Tym4W4N78SHRV2tV
        YkCUI3ZcPPWZz41o5ApMj/hVyHmZ
X-Google-Smtp-Source: APXvYqwm9IjiZs6Lz5yoewhDGoaiApoU5Pw/01eOgwsSySEguTS9TbsOdCVlfXoFVOrN4Sbd1CuSiQ==
X-Received: by 2002:a24:7405:: with SMTP id o5mr2378800itc.24.1556804199466;
        Thu, 02 May 2019 06:36:39 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:7d41:7f77:8419:85e7? ([2601:282:800:fd80:7d41:7f77:8419:85e7])
        by smtp.googlemail.com with ESMTPSA id t196sm4830473ita.4.2019.05.02.06.36.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:36:38 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] genetlink: do not validate dump requests if
 there is no policy
To:     Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1556798793.git.mkubecek@suse.cz>
 <0a54a4db49c20e76a998ea3e4548b22637fbad34.1556798793.git.mkubecek@suse.cz>
 <031933f3fc4b26e284912771b480c87483574bea.camel@sipsolutions.net>
 <20190502131023.GD21672@unicorn.suse.cz>
 <ab9b48a0e21d0a9e5069045c23db36f43e4356e3.camel@sipsolutions.net>
 <20190502133231.GF21672@unicorn.suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd3b0c89-2475-166d-e2b8-1479af7b79bc@gmail.com>
Date:   Thu, 2 May 2019 07:36:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190502133231.GF21672@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 7:32 AM, Michal Kubecek wrote:
> Wouldn't it mean effecitvely ending up with only one command (in
> genetlink sense) and having to distinguish actual commands with
> atributes? Even if I wanted to have just "get" and "set" command, common
> policy wouldn't allow me to say which attributes are allowed for each of
> them.

yes, I have been stuck on that as well.

There are a number of RTA attributes that are only valid for GET
requests or only used in the response or only valid in NEW requests.
Right now there is no discriminator when validating policies and the
patch set to expose the policies to userspace
