Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147A53501C2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhCaN5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbhCaN4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:56:41 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E42C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:56:41 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id d12so20040335oiw.12
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1nl+n3ykQPtE+4YeQ7Kc4gISHOOu6sfkyWYJgsj9ocI=;
        b=dG4jre12jnWNU4f1o2wsgkr6gfWZIuZn1ky6FyuJ6aEr5pRdJU+ZY+fivcG8TnwTRH
         jSNmYO1HDMuTFjcoA0OA+EIM2jfa1OvkdXSc1sPG4xXJ66de0mOt1PziI8Cto3ci0viz
         d9AOAXWRjqjpC0NTXyIMDKRiZm0ms2v2tyf2dviwgKZJ7BIFpo/jOicqIpFbi2x372Fg
         LPlXrSQPpEhYyYbaRCCMrL3fi9PmUbeZ0p1HAfSVwtd0XL2L4oFf5TFMUwHgilSv4ZXz
         R9xuH+zp0pLO1HVqr83B1FPCBLnUQXeJI53O9F0eeJSs5V7nBITkNkgwJtZ1zxgbAhs0
         RmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1nl+n3ykQPtE+4YeQ7Kc4gISHOOu6sfkyWYJgsj9ocI=;
        b=XQxDyK+mJuE4se6a57Zgyl68T5+xQqtYXc4uxHVmEV+uB7bCj2ENCm44ynzc5sJWiE
         I/7WAaDuL1GBvg/odG8Uahf5Sz4IXkxo9R2P6gCwJ/+Uk1Zmrg91YvQxuGbemU5iRQk0
         xW3/hUjdZENG2vOvUq7PL1cQQvdyFn3vUG91UD8QyihhBxRMGxijsvOR3uQ/vde3addu
         DKS4/RSYZdYPnrCcP9M0gZHEkf1UOx+m10KLwwxLC5XDNZ524HcZj1KFS2bIFjAcsVDD
         CbYgtD8v1d/ulAmu9aTtGA3AAK5320PVIzE59iIxlWMzmqAD2GJDPqoHIw+2dE57lEjt
         OTZw==
X-Gm-Message-State: AOAM533TlrVDkZFqz/Zl0+aeMU3Aber56pmtQh8Nth4LFW6hzR+eH+Mf
        aXYZAqmfTJYr4atlGAach4QfBB0FriZbrrDtTNIUl5DJwQ==
X-Google-Smtp-Source: ABdhPJxT1jiuxJTTHX/qmSJNNcFrUqkN6VPgEWxC9pm0ge5LWltRyFQRw74avpIOUsMzHuTQJgfn6xw31o8X0HTeih4=
X-Received: by 2002:aca:ab44:: with SMTP id u65mr2257325oie.122.1617199000403;
 Wed, 31 Mar 2021 06:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
 <20180430125030.GB10066@lunn.ch> <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
 <YEemYTQ9EhQQ9jyH@lunn.ch> <20fd4a9ce09117e765dbf63f1baa9da5c834a64b.camel@canoga.com>
 <YEf8dFUCB+/vMkU8@lunn.ch> <9d866ab9d2f324f34804b3c74e350138d5413706.camel@canoga.com>
 <YEjM2T8rI05F/Fbr@lunn.ch> <497bb0d287474ba1dbaded0c5068569203a8691a.camel@canoga.com>
In-Reply-To: <497bb0d287474ba1dbaded0c5068569203a8691a.camel@canoga.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 31 Mar 2021 08:56:28 -0500
Message-ID: <CAFSKS=OvPO=0bYm6o2L=2BH8eQDKtzPw+qA2Phx2sk59BGRnRA@mail.gmail.com>
Subject: Re: DSA
To:     "Wyse, Chris" <cwyse@canoga.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "drichards@impinj.com" <drichards@impinj.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[snip]

I'm using an i210 w/ mdio to connect to cascaded mv88e6390 switches on
an Intel platform. I have patches based on patches sent in 2014 that
allow use of mdio and configuration with device-tree. I'd like to get
them upstreamed but there are some unresolved problems. For one I have
no way of testing external mdio connected phys since my board only
connects to a switch. Second it's not clear what the "correct" mode
configured in the EEPROM should be SGMII, 1000BASE_KX or SERDES. Based
on 2014 mailing list discussion I'm using SGMII in the EEPROM
configuration but it ends up having to change the link mode to
E1000_CTRL_EXT_LINK_MODE_PCIE_SERDES when a phy is not detected or it
won't link with the mv88e6390. I think there may be push back from
upstream in changing the behavior of various modes even if external
mdio is enabled in the EEPROM due to fear that vendors may have
enabled it for no reason (needs more investigation). I've also had to
add a hack to the mv88e6xxx driver to stop calling
phylink_helper_basex_speed, otherwise it always tries to use
2500base-x which doesn't work with the i210. I posted to the ML about
this but no one bothered to reply.

My Intel Atom platform happens to be using u-boot rather than UEFI so
I'm able to apply DT overlays based on detected PCI subsystem VID/ID
before the linux kernel is started.

I'm on #linuxswitch on Freenode if there is anything you want to
discuss off the list. If any of you have interest in getting these
patches upstream it would be great to work with someone on it.

You can find what I have here:
https://github.com/gmccollister/linux/tree/net-i210-mv88e6390

Regards,
George McCollister
