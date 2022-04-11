Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B984FC2B6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiDKQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiDKQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:52:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2224133E96
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:50:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bh17so32108045ejb.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v+zwLXFhR2dMJ6NpRl+pViRh/y7wZXwNVIAUNJxKb2I=;
        b=lR8fxn4meehoiM/9wwWplVK53B12SAcY32v/3Ik2QYwgkdNzm/6rmJza2vQjAA4n1e
         p/03QiYs/XmDHnfQ32hY8f1iEl0Phh+dA+8xxYPcUiYJcGAKH7z84gnJTH/OPwrSwIgH
         eb/iRcRR+uzHEcLCocZhTYicSI5q10OdDqYDEEh+ScXcQLKw0xIsxwK9a/iVeVCkYP13
         KI1eYPuQ8Sw1af3pAet9hD1syDUN2BMaO2XJGGc4GsRyQhp026I5+sE6BOtyOhHJjoTs
         29POnOJFJvd5HuUcUjzJS5602E0OAD32epUZQXrqfKxxwPbJuie9lsP876QZR8qgRz7g
         V++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v+zwLXFhR2dMJ6NpRl+pViRh/y7wZXwNVIAUNJxKb2I=;
        b=KwLW5yVZK5BNuJiQ/2dg4sDRbOguPTMi4DFuVLLBIg0v7zhDyR+QIOAWgJ1gphX28S
         ChsTAM3MzeCv3yMEWrJdvpcBUdb2H7RQEi+QrQAsZ3rtK0KqIn46bRRyxLbS6u7A/pQq
         P4xoDCSsGOe3bz6yv9YVXyRxK2yUjqsf2IoRghq7yUraQF9NqpcdEdcbbqz6Lhnwk7QJ
         jgL38EhjiGfjg+TwNmdoSXXjCv6uhJkXUxk4p5hc8BIY/Bh/X6ji/N6Z0NYldOKsnItw
         RmenNTOK6RCZk72O1B3z5OTLeqFuP2aayqW+tAUdI/lJeRpmlsJu1ZutWrLxCncwDvNF
         Tn4Q==
X-Gm-Message-State: AOAM532GbeW87Wed/D1wfhgFw9zeuFklj/GipuyskRfKjnP1SrYHSKdt
        eYcYJdMp7GeUo/bhmsmfenccShrD4ZE=
X-Google-Smtp-Source: ABdhPJyhdE2pJubud2D7ypOnhk+l3aSPuL65/JRdsHMUhTN6C7x7PmdVbRtmKImqGfdDKf5QKk7KRQ==
X-Received: by 2002:a17:906:7714:b0:6ba:8a6a:b464 with SMTP id q20-20020a170906771400b006ba8a6ab464mr30183298ejm.613.1649695832501;
        Mon, 11 Apr 2022 09:50:32 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090600d600b006dfbc46efabsm12200208eji.126.2022.04.11.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 09:50:31 -0700 (PDT)
Date:   Mon, 11 Apr 2022 19:50:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220411165030.f65ztltftgxkltmr@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org>
 <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
 <20220411154911.3mjcprftqt6dpqou@skbuf>
 <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
 <20220411162016.sau3gertosgr6mtu@skbuf>
 <686bf021-e6a4-c77a-33c9-5b01481e12f4@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686bf021-e6a4-c77a-33c9-5b01481e12f4@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 06:27:54PM +0200, Nicolas Dichtel wrote:
> Same here. Some complex path are called (eg. dev_change_rx_flags =>
> ops->ndo_change_rx_flags() => vlan_dev_change_rx_flags => dev_set_allmulti =>
> __dev_set_allmulti => etc).
> Maybe you made an audit to check that other flags cannot be changed. But, if it
> changes in the future, we will miss them here.

I guess I just don't see what other dev->flags that aren't masked out
from netdev notifier calls may or should change during the call to
__dev_set_allmulti(), regardless of the complexity or depth of the
call path.

And the commit that added the __dev_notify_flags() call said "dev:
always advertise rx_flags changes via netlink" (i.e. the function was
called for its rtmsg_ifinfo() part, not for its call_netdevice_notifiers()
part).

There *was* no call to dev_notify_flags prior to that commit, and it
didn't give a reason for voluntarily going through the netdev notifiers,
either.

> Did you see a bug? What is the issue?

I didn't see any bug, as mentioned I was trying to follow how
dev->gflags is used (see title) and stumbled upon this strange pattern
while doing so. dev->gflags is not updated from dev_set_allmulti()
almost by definition, otherwise in-kernel drivers wouldn't have a way to
update IFF_ALLMULTI without user space becoming aware of it.

The reason for emailing you to was to understand the intention, I do
understand that the code has went through changes since 2013 and that
a more in-depth audit is still needed before making any change.
