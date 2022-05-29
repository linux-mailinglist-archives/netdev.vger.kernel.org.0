Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E0536FE4
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 08:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiE2GOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 02:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiE2GOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 02:14:32 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C066AE3
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 23:14:31 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id s23so8546167iog.13
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 23:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SklogaAzXUkW7XblYEY2z3Xb63cjlrOukechF5Y/9c4=;
        b=rjcVhljMeom0aUCe/aeEAF7zfEo5OTKdwfusO7ekc3Z0uOmVJf3jj8/oRVHGe+e0cz
         sabioEgvRnMO2A5NJjwJi0aa2qkHj0fTj07UFXA3A0YBYesr0rBaeDBQHf7/vKniDO2i
         e/uYfC6bFzbDdxeDXDAcljuec08VYAvZ51AdrD08GldZV2D7ldxm52hes6rI8X9eYJi6
         W9pV+YyIItWBmbllnsuB0yIzUQd107nydEjUSs1N0h88FcAUH9c4ptiJURMCRVVnxDPh
         r3JuG+vj1SuWh+tUHg1ZoiTnXMvAPs6i3rWOGGcOVD9q/DhNWd20aNDN65b3246v++4E
         VyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SklogaAzXUkW7XblYEY2z3Xb63cjlrOukechF5Y/9c4=;
        b=IhFlFC0wxnCpo/YHtNqD0qje3tysNKdHx8y+ZX2J4xKSCZFeGxeRWPrIP8ZpI3On4U
         7Zu9TqoLYwymomyF3enNG0ekwG3B0nevFHDbxR4d4YAvqqjyl3F2GfP4FfgR3ygzFZm7
         dK+Qr9S6V/IOvPM2eh544TFFZhEK9kLECHTyV2jwzyfHzK/ZjzEnN/hWU2pJ31tkrwFj
         k87bj+4b/OQkipDdK3T8IMd3sNcp7fJFDwLSKE45Ip5+o5/drM4VSzImS7boQ+wljFOS
         sCMXibS+542jibcl1eBAgiNk7SV+C4u9o6XwuB0rIWxQY0RIt3iD5PM/Gvni8eYXIOXP
         ZvKA==
X-Gm-Message-State: AOAM532YYUh4JMaF9D0oQ9CMJVyHXfUlyEn4EsZ7FSnGcZFwe/UD/tmI
        xOrRVGMM2B2d+Z6fkX03gs3oj3kW4MG0hEb5zihbcg==
X-Google-Smtp-Source: ABdhPJzxGIVoXCq8Hs2iO0/cC3zHrMT9bVINgDKcLSakVgn0bAqH6utIIDJfV/zvsKCGwDFPbj2miwdIjclR/+ccbE8=
X-Received: by 2002:a05:6638:2581:b0:330:b843:5543 with SMTP id
 s1-20020a056638258100b00330b8435543mr9131867jat.198.1653804870355; Sat, 28
 May 2022 23:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com>
 <CKBUCV5XNA5W.1WFEM5DTPSCHV@enhorning>
In-Reply-To: <CKBUCV5XNA5W.1WFEM5DTPSCHV@enhorning>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sat, 28 May 2022 23:14:19 -0700
Message-ID: <CANP3RGcBjYL0hpd-J_GvXCJsbOg3ztS5yhXr4S8M5G5_F1ZwLQ@mail.gmail.com>
Subject: Re: REGRESSION?? ping ipv4 sockets and binding to 255.255.255.255
 without IP_TRANSPARENT
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 28, 2022 at 6:07 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
> I confirm that, indeed, it was unintended.

Good to hear this.

> Nothing about the behaviour of broadcast and multicast bind addresses is
> mentioned in the commit message or linked Mac OS X documentation
> (although it would be interesting to test how Mac OS X behaves - anyone
> with a Mac around here that can do that?)

I think sending with ping multicast/broadcast source is unlikely to get replies
due to valid worries that it is an attempt at a multiplication DoS attack.
(send one unicast packet to target, get target to reply with broadcast 'storm')

> I agree, it doesn't make sense to be able to do that. That's probably
> why the check was done that way in the first place. I think the previous
> behaviour should be restored. Not by reverting (part of) the patch,
> because honestly the original code sucked, but by rewriting it properly.

I'm failing to see a way to write it in a more obvious way...

ipv4_is_zeroaddr() should probably be tree-wide renamed to ipv4_addr_any()
to match ipv6_addr_any() which now saves the same purpose.
[since it's just a check for 0.0.0.0/32 now after Dave Taht's commit]

Then the following:

if (ipv4_is_zeronet(addr) || ipv4_is_lbcast(addr))
return RTN_BROADCAST;

is more immediately weird.

Why do we classify INADDR_ANY as broadcast?
It should either be classified as a new RTN_ADDR_ANY or as RTN_LOCAL,
with the understanding that in practice 0.0.0.0/32 just means "don't care
assign something for me".

I guess one could do:

 if (!ipv4_addr_any() && (!inet_can_nonlocal_bind(net, isk) &&
                    chk_addr_ret != RTN_LOCAL) ||
                   chk_addr_ret == RTN_MULTICAST
                   chk_addr_ret == RTN_BROADCAST))
                        return -EADDRNOTAVAIL;

But that's not really any more meaningfully readable than the old code.

> And more importantly I think that test cases for that should be added in
> the kernel (this has been in two released minor versions before even
> being caught...)
>
> I should be able to roll up a patch inside a few days, if this sounds
> like a good approach to everyone.
