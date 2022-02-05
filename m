Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5424AA74F
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379574AbiBEH0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiBEH0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:26:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5245C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 23:26:30 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c24so18088285edy.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 23:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzrkbFxcqi8SuTu2Hx73Mhzv8KbasIqXzzy/tzWkoII=;
        b=YTJDbVo0Z2wcxSd7R5THmeL0dJei3Tqp+8Vl4HgsTFFjcwq7YuHWzajnXJlpZItATK
         VE7O7fZqs8YoBzhD5zvzSzvbSk7n4SPeA20z7IzgMZYuCbJTesZk5gG2lui0vBRkNUpl
         lZUz2LSwTjLjLYet8pZnF4gjfCqwPuk30mPNbGLVakm+xVkLFsP5QFBeN01uVfuqI8Qb
         dFf4HhToQptIE1S2wG4WK+lUKpwjkW9yGX0dBx5V7Htxd4MuXJQ4PDzz9+vbrw3GS7oe
         BzGD7+GVYuqwfEri66kVBIVgj5kTf+U9mW39kQ/DADrvdPQCSzHrvlYovx2dKCoZdoLo
         wibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rzrkbFxcqi8SuTu2Hx73Mhzv8KbasIqXzzy/tzWkoII=;
        b=im5er+HkKQBZuYWDUsTDe2tDAJMpNHrcOjFs2elPoma+BQVymv5Axlm01KBkK3SzQr
         K5PhrD64KEk17I7/LU4WXR6ezv4XIxYah1C83OM9ANZuBFVlrBeMUtlrlHS7SE+2ixgq
         1WzPalu9w5KQrS2e2nW7Hh+K5Vb5YfMWD2KfWxMelVC68Qoc+krZhy84d6qNqLBi0KaM
         i1n11nEXCiy5lcVBVdIPnNyPnEAnurcuJFCWG6XqNvFFXQZV6ogUPTGVSmxFAD7utRFJ
         uxcxoyWdBqtRl8BepbRWylEp+2q0F70VROxfrO7ge7ssJHVJe4pr1+uuqj6ZTLg6w/GD
         cOVQ==
X-Gm-Message-State: AOAM530SKU+pa/lgpXVUctmBg5Q3Ku6X3N89bNrmU0f84ExSTMv8yXOK
        EROHQ6XKEEWGN27JpKM8dD4E/0w/JJdV09lPltw=
X-Google-Smtp-Source: ABdhPJzzFFKDRHAdYfjwIFcToKa7bUsuCDAf70ZxZjbwgnJA4jPsagsU724kMtIS3aUCsg1g21UbQNIvbbO90xsKlUo=
X-Received: by 2002:aa7:dcd5:: with SMTP id w21mr3049915edu.97.1644045989034;
 Fri, 04 Feb 2022 23:26:29 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
 <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com>
In-Reply-To: <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 5 Feb 2022 15:25:52 +0800
Message-ID: <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 9:12 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-01-26 14:52, Cong Wang wrote:
> > You really should just use eBPF, with eBPF code you don't even need
> > to send anything to upstream, you can do whatever you want without
> > arguing with anyone. It is a win-win.
>
> Cong,
>
> This doesnt work in some environments. Example:
>
> 1) Some data centres (telco large and medium sized enteprises that
> i have personally encountered) dont allow for anything that requires
> compilation to be introduced (including ebpf).
> They depend on upstream - if something is already in the kernel and
> requires a script it becomes an operational issue which is a simpler
> process.
> This is unlike large organizations who have staff of developers
> dedicated to coding stuff. Most of the folks i am talking about
> have zero developers in house. But even if they did have a few,
> introducing code into the kernel that has to be vetted by a
> multitude of internal organizations tends to be a very
> long process.
Yes, really agree with that.
> 2) In some cases adding new code voids the distro vendor's
> support warranty and you have to pay the distro vendor to
> vet and put your changes via their regression testing.
> Most of these organizations are tied to one or other distro
> vendor and they dont want to mess with the warranty or pay
> extra fees which causes more work for them (a lot of them
> have their own vetting process after the distro vendors vetting).
>
> I am not sure what the OP's situation is - but what i described
> above is _real_. If there is some extension to existing features like
> skbedit and there is a good use case IMO we should allow for it.
>
> cheers,
> jamal



-- 
Best regards, Tonghao
