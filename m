Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72F4D1F88
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiCHR6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349066AbiCHR5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:57:49 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C8B5640F;
        Tue,  8 Mar 2022 09:56:53 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q11so7295541iod.6;
        Tue, 08 Mar 2022 09:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDmh/IPdiE6PDYt50/XDSAtdMd5j4O+8jOvE+X7FizM=;
        b=pl3lhgeIJgpj5x6BRQw9o3peqLm7daSHSNxf/Fa8KzmsVUnf+EK4Fb2Xnji9OA/mGW
         4cmXcurgXk8JuMZRAlTBBQVRlQrGkbeScu6SNVnmioD/g48cRL1HqYQZSTWKsJ3nGVee
         75jcEuA2gA53H+Q/C9bsUUNpy8jBARW9fbqjWGJBLPWdFkP+B055e9uvHycruE8dpOZX
         Fn0u5Cj8HDsgndaCYPhQTbCDIoB0ypZtpOIZ7/ogdFzMtqe43Jx7ofP4sZ+0rJlcd0Tb
         BjVtMoh+ZiUePy3ola9V5OnElHNGMyeV49lbmqlk9+Yuxct/4sM7CV+nYK1bS0Kt+8kC
         oWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDmh/IPdiE6PDYt50/XDSAtdMd5j4O+8jOvE+X7FizM=;
        b=XmNhy6ZVjnwCI9QrTQ+Uc6g7wP5xMCVubMZ9rXBW3t80k7XVp7/9AQkprpSQ/mOk4H
         Oc2pfXuqe5ekjEA9ER7ouXhGXCvm4UMQxQsXlWILIwXIq72lHElFwpGe0v/Ad8sRH0le
         AQXQ5u7cKpI8ca3TQpiFYd6LetM86PV7R7qW166q/V79Igx/OwDpO7kibORYZBX6aTSW
         MaNhYlwqPqvN77HWIcuSbmGvmTjjP1wemPzY0r8udJlghUJ0MdBiKoF+6qfc6Euzp1Pp
         OEowcs5IQv8EWudduoZCpMsPwLesxtQmCA9w25YL1SlK2y4GyRK9b1b4CcISV+ZWNIOD
         cYYw==
X-Gm-Message-State: AOAM532oFjShSQbmDODhPW/DhAwI2vLE8bn1jCP2HdUbTWP2eIw83jJT
        B0C7q0n5sWCEUGFcpav/NFAJtwfiMowVX3LpaE8=
X-Google-Smtp-Source: ABdhPJzuGnyLNfiPQyraQlj9o6c7SuW4tSYhCspuwiA1tY6yJSZW1/8OpYX6Qk/Qlx/dAKihASupSLf1gbeaFrG9PYc=
X-Received: by 2002:a05:6602:1605:b0:644:d491:1bec with SMTP id
 x5-20020a056602160500b00644d4911becmr15407360iow.63.1646762212570; Tue, 08
 Mar 2022 09:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20220306121535.156276-1-falakreyaz@gmail.com> <CAEf4BzYmVo9rw1Ys0ZufQFA=f7sy+dP=d9L9rmGS5L91qV1K+A@mail.gmail.com>
 <YiczXPnQakMwNEbX@baaz>
In-Reply-To: <YiczXPnQakMwNEbX@baaz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Mar 2022 09:56:41 -0800
Message-ID: <CAEf4BzZabPo=r4BGbVnzyC5G37DbdFGp8f67ZdV8WLiE-pOT+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: fix broken bpf programs due to
 function inlining
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Tue, Mar 8, 2022 at 2:43 AM Muhammad Falak R Wani
<falakreyaz@gmail.com> wrote:
>
> On Mon, Mar 07, 2022 at 10:11:36PM -0800, Andrii Nakryiko wrote:
> > On Sun, Mar 6, 2022 at 4:15 AM Muhammad Falak R Wani
> > <falakreyaz@gmail.com> wrote:
> > >
> > > commit: "be6bfe36db17 block: inline hot paths of blk_account_io_*()"
> > > inlines the function `blk_account_io_done`. As a result we can't attach a
> > > kprobe to the function anymore. Use `__blk_account_io_done` instead.
> > >
> > > Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> > > ---
> > >  samples/bpf/task_fd_query_kern.c | 2 +-
> > >  samples/bpf/tracex3_kern.c       | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
> > > index c821294e1774..186ac0a79c0a 100644
> > > --- a/samples/bpf/task_fd_query_kern.c
> > > +++ b/samples/bpf/task_fd_query_kern.c
> >
> > samples/bpf/task_fd_query_user.c also needs adjusting, no? Have you
> > tried running those samples?
> Aplologies, I ran the `tracex3` program, but missed to verify `task_fd_query`. Should I send a V2
> where I modify only the `tracex3` ?

No, send a patch fixing everything in one patch
