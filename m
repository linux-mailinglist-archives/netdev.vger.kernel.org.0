Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD04E2B34C1
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 13:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgKOMAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 07:00:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbgKOMAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 07:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605441606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vyCE5epD7jmlT7JbAJbfq3WgVxdvsnKs6lzVfZu/MEg=;
        b=JgMd+zDQsgojqdqy8MnjLr60vEDqrSrUtK6IB72nGgrZ/r+/mg3Y8gXcw/m3up4GAWhHU/
        ZBfAFC6Lhm7+vr00apUjqVGVZFHGPpvQCEiWwjlEQVEanM4DBo5N9dj9BGqen5rU6tKhBM
        rOIUEpmnrj32dFPl2KWHtX0Ddi484fo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-38U1cBMHPLG5WfNT68cXxA-1; Sun, 15 Nov 2020 07:00:04 -0500
X-MC-Unique: 38U1cBMHPLG5WfNT68cXxA-1
Received: by mail-wr1-f69.google.com with SMTP id f4so9094176wru.21
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 04:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vyCE5epD7jmlT7JbAJbfq3WgVxdvsnKs6lzVfZu/MEg=;
        b=VmWcMCUyvSZOLfT7HXfsk8zN28zRlh1B2uSclAzWgetaHCBsE1C5biZhV7Bjku/PU3
         3W7K0A5hStVKRCX2ZhxqnHJy0zc4rM0Ng2cylQRjfdlz4aH4u1fezzSc/Vvh/e63WR2Q
         Ndg9kZH6C4Ujq3IMLwyg18dVJQlRvg0Zc3pPNumfKDLjl0u80iLxc7igaBx5J+CC9Ji8
         150TwYq80z3SW/hTx+nmkc88PHByYoTfAR4i1nOyBNrWwJkIlBQmSZMzozoJSZokBfoH
         456U5O6SH6kl7XCDCTjRxMuY6PHqq+bZAUP+xs0aDZODtTcJU3G49W0LkbEt6GZY4z0y
         otUA==
X-Gm-Message-State: AOAM530CDCPgC5xz73OrcJCtkay5Ifi/PcPpknncfnlC05XLPq4OCDnz
        Ege9gS7lt/6jZZqEHglYk5zDj2ygQxP2ZrCA27OCvIlr9cvBth+w+YAH7DqPMm3WDcN/Bnyf9xz
        axIuBPPNTmRB7b9xO
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr10494650wmj.69.1605441602891;
        Sun, 15 Nov 2020 04:00:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxp01lXIK15RyTUq33lQVrzH8oZwcj5w/D5dctxHl0W+aNgAMzfkcxzH1BP9/LDZBGbsAeF9A==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr10494641wmj.69.1605441602764;
        Sun, 15 Nov 2020 04:00:02 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c17sm18433728wro.19.2020.11.15.04.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 04:00:01 -0800 (PST)
Date:   Sun, 15 Nov 2020 12:59:59 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201115115959.GD11274@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109225153.GL2366@linux.home>
 <20201110115407.GA5635@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110115407.GA5635@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:54:07AM +0000, Tom Parkin wrote:
> On  Mon, Nov 09, 2020 at 23:51:53 +0100, Guillaume Nault wrote:
> > BTW, shouldn't we have an "UNBRIDGE" command to remove the bridge
> > between two channels?
> 
> I'm not sure of the usecase for it to be honest.  Do you have
> something specific in mind?

I don't know if there'd be a real production use case. I proposed it
because, in my experience, the diffucult part of any new feature is
the "undo" operation. That's where many race conditions are found.

Having a way to directly revert a BRIDGE operation might help testing
the undo path (otherwise it's just triggered as a side effect of
closing a file descriptor). I personally find that having symmetrical
"do" and "undo" operations helps me thinking precisely about how to
manage concurency. But that's probably a matter of preference. And that
can even be done without exposing the "undo" operation to user space
(it's just more difficult to test).

Anyway, that was just a suggestion. I have no strong opinion.

> Thanks very much for your review and comments, it's much appreciated
> :-)

Thanks! :)

