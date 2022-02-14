Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475774B4E99
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiBNLcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:32:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352668AbiBNLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:31:52 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB066C946
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:16:49 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d10so36621593eje.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2RgNpTio3f/m7dwocv4BhJx72BQspzNQNdo1pztTa+g=;
        b=g4eAF15fR8tZ8DfrcD3yGx2dV0T4akhEXA1Lgdx0BAoZ7e8+03dVGHQQu92BaOXmHV
         ZLkCP6GRHPeNtNPCDH1DgYjUK3KlMw4AxeJ8cGgaAexpXTzJZ1WSKFPZMgZC1WZhsxZ2
         cMtoMJYHxPxuyldc5gMX9U49yC+sfdeJN2L0JbGU8D2DDeFUQLjriQSYYLM2WnYwRk/4
         gYUqAdeDi67+/9hdFy72mYxyS7PRRrPhHVNtnQjdAoprStM1Xz8EuHPmug4si7XuXhl1
         JVfo23Ytbq0+9OSiPpBvwGBZa3VcjY2wy3Y10SKGr9vM8BsIbbLRiV8b/f7r7iC8Pc/3
         UMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RgNpTio3f/m7dwocv4BhJx72BQspzNQNdo1pztTa+g=;
        b=7FcQiRIi5ared0NJnq7xWK8iZPjTWGCc8IeiD9DwvuRu8AgQP0xQwkqCaOFrF/BzEb
         Ftx2HyFlXTWJti5PxaWikXWlbtVtRNgB/KMyPharHDjTG15gMzaiDcXAVCFG0WxtlP5L
         ykBBy2eMA2J09tyF5Ggblpr/R1TbbalDlSpXi0p4xD/U3oiR+V/doWBGhe0fLzQWT8rS
         etRTmQoAc19oHRePAvNC2xCEeYCROuYv19AzzO2QGtuPPbgCNWZ1F05cREsfIi8DlAJr
         t5tB2MTb2idozpwxLUT+0V/UburU7wHfSecajiXjIApG4QZ/CSuvcxVSzhgL5JhgkkF8
         pVyQ==
X-Gm-Message-State: AOAM531o5aGxTeiwesoGOzkcF6IjbO2BSQEEV4M5EGkpMrKncHw7UZqc
        j9WAsUvewnn2JSUldOLkdDCZ96J1b0xfHAnNAvc=
X-Google-Smtp-Source: ABdhPJw10YYnD9dtnNn9oa5fgLOy2GW//SUW5nu8ZbrfVZk/BCCnfvscNEiDx7STHYfkvCb8bk7IAvImZHoJqhyC3T0=
X-Received: by 2002:a17:907:c07:: with SMTP id ga7mr11373590ejc.536.1644837407510;
 Mon, 14 Feb 2022 03:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
 <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com> <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
 <CAMDZJNUbpK_Fn6eFoSHFg7Mei5aMoop01MmgoKuf+XDr_LXaqA@mail.gmail.com> <20220209072645.126734ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209072645.126734ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 14 Feb 2022 19:16:11 +0800
Message-ID: <CAMDZJNW0tcue5kt-GgontVTo-yBEEBPD98xnhtOu2XjCy9WR9g@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
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

On Wed, Feb 9, 2022 at 11:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 9 Feb 2022 22:17:24 +0800 Tonghao Zhang wrote:
> > > > This doesnt work in some environments. Example:
> > > >
> > > > 1) Some data centres (telco large and medium sized enteprises that
> > > > i have personally encountered) dont allow for anything that requires
> > > > compilation to be introduced (including ebpf).
> > > > They depend on upstream - if something is already in the kernel and
> > > > requires a script it becomes an operational issue which is a simpler
> > > > process.
> > > > This is unlike large organizations who have staff of developers
> > > > dedicated to coding stuff. Most of the folks i am talking about
> > > > have zero developers in house. But even if they did have a few,
> > > > introducing code into the kernel that has to be vetted by a
> > > > multitude of internal organizations tends to be a very
> > > > long process.
> > > Yes, really agree with that.
> > Hi Jakub, do you have an opinion?
>
> I think the patches are perfectly acceptable, nothing changed.
Hi Jakub
Will we apply this patchset ? We waited for  Cong to answer Jamal's
comment for a long time.


-- 
Best regards, Tonghao
