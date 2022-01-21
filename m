Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1344964EA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351964AbiAUSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbiAUSUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:20:46 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0082C06173B;
        Fri, 21 Jan 2022 10:20:45 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i65so9599776pfc.9;
        Fri, 21 Jan 2022 10:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eTTHLn/QL6hBXwekrEmJFRvAs3c8dv9CM6a//b0IQ40=;
        b=lK0DzbBTAOKBMCJriRopWo1+oKYSfGQGO4eJKOHZ7SSsnKWn4GZ4rRUYjBO93LsFQ2
         2tQ2WsYdbGCnP3rPcmGHuHw6ieozSPWVK5FHZxpnXME3LvXZObJKnHVrzapt1EItgXyL
         kf0pCRkCDbLg2ZVWcVRGXGvNg1wRLpnge+HpilOdjxTxnCg5v4fvlTIiU5BTuMG+sUE1
         qwbFAxutyDa5JrBk89UUnpOp53n002FpZ3pvQ8aDvOWR7WhIyRgbiDsfaGg5gL2/357X
         Joz8952W4IheW90dQy3Mz1uBxtGkv4yWa/SbO3HQQK1zREy6oxyFr3SrrJkP4pjp7A4I
         w1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTTHLn/QL6hBXwekrEmJFRvAs3c8dv9CM6a//b0IQ40=;
        b=AiX5Axlr7s7rNIFIQfnihuhXrFfDcPEzCxJT9jJJK2y0q+SlO1FOXu2P0J9D1BJzrS
         DiCm6zA4XSG8tFbf/qGf7eTwLZKb5zBwp/mf3opNaQVeoxCn9T22cQFWXqLOn7AHmmOR
         ndQ7ovXQkVghyUYUhjK1ia3Il3pv1SUMyeZcbNKQxbemYQMxzpxK3kig5P3nj4WWuIiC
         LGseGrLzLGhJ+PTN699xplnBL9kH50HEFr0+AO1TL4NlbkOk2OB7ugLftVK9lp0qbyYg
         xi0F4jGO3i9nOzEu14yxdkQD76R6dLvY4J7VRaZUSFVh9qFFozVa527nrmcP9Rh9FvZm
         rc1w==
X-Gm-Message-State: AOAM533nPTfcWPZemRCqnLThtsvg8y6AQCvGg6AdArl9zDToNQhBmRPG
        1ZzTf6vRPZEGGP8AtdOqieoLZbPf+8lxy8GXlJk=
X-Google-Smtp-Source: ABdhPJzAfAVSPVkTqjMd/5uEfuxQzpOM9q4MYZ2XJYO0Wx/eTtQn94zDBJmWUHZKZhHOse8ibWcWRr6JojJ0+k8+oDg=
X-Received: by 2002:a63:8242:: with SMTP id w63mr2475787pgd.95.1642789245459;
 Fri, 21 Jan 2022 10:20:45 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
 <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com> <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com>
In-Reply-To: <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 10:20:34 -0800
Message-ID: <CAADnVQL0nq_jHY7Js3FN2bFBy4eo-7=4cfurkt5xQmU_yJGCvA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 10:15 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 5:44 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > This patch series is a refinement of the RFC patchset [1], focusing
> > > on support for attach by name for uprobes and uretprobes.  Still
> > > marked RFC as there are unresolved questions.
> > >
> > > Currently attach for such probes is done by determining the offset
> > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > attach, making use of uprobe opts to specify a name string.
> > >
> > > uprobe attach is done by specifying a binary path, a pid (where
> > > 0 means "this process" and -1 means "all processes") and an
> > > offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> > > and that name is searched for in symbol tables.  If the binary
> > > is a program, relative offset calcuation must be done to the
> > > symbol address as described in [2].
> >
> > I think the pid discussion here and in the patches only causes
> > confusion. I think it's best to remove pid from the api.
>
> It's already part of the uprobe API in libbpf
> (bpf_program__attach_uprobe), but nothing really changes there.
> API-wise Alan just added an optional func_name option. I think it
> makes sense overall.

Technically it can be deprecated.
So "it's already part of api" isn't really an excuse to keep
confusing the users.
