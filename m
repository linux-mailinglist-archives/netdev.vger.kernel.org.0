Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DF24D6B01
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiCKXz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 18:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiCKXz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 18:55:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD40E6DBC;
        Fri, 11 Mar 2022 14:23:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so9322725pjd.1;
        Fri, 11 Mar 2022 14:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRfHmLV6jC//S0JUnsW7EkyoAJl8Vb/or5+A/gBKAzM=;
        b=KwPsT2XsrHShv56NDjUu3yvGQa1JlqCIdWproXqbg0elY5sxpXeo0jGIjpog1jChpi
         l3dl2QAURioV1sWFgBC6rU++phG9LloQXtBVTzFVf9zjriVpimSq1gB881YT5sdLGfCm
         f7MOSPCElXan/sdrSTwGt4sjsY7A1JBpgzh2Flwbq5F3z1mBemRaxQcxwKye6b8vOiDm
         OTYLAvOcQTstwGN+sfa4LteZ6Tt4VPiJQdOYRdYfTwvbqxgiv7ZaD8cKJd+yD9V/BrFk
         EEvv3Yxg92wD1nDc+lrdjhYVextf5yiEEd8VD6rbYEpvf3mCVrrOlr9zk2ldJeVW9BIl
         kIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRfHmLV6jC//S0JUnsW7EkyoAJl8Vb/or5+A/gBKAzM=;
        b=DW76xWJ0v2gdlCWZsCsOdD3LHfjp2VFmjucyvToYxBG5cPAGANISPku+fkOQDIzPuH
         C+6qKtvSJLO+NLBNIIAjbGRrwM62gIZ4bi8FnOd6ZssUr0q4d3y11WZtArWIeblRJVOj
         LAlzaam0RJ/YFfztOAPGHKw+qCBIHTqn8DMArIzOc33NdrmTH/rww7kMoNLi9IuRMTiQ
         uCJtt2t0Jmdjc9dlsszsKEka/8ZboHTUcmvOSpNmHiDJ2c/rnP+gT6YcyN2yVgf1Ke90
         i97+J79M20PP2UIJMqeORG/I1wBXh42x7F6IRmRSDtYf7+6IbDVMkHdtCPpCPnVQPRlI
         hX0g==
X-Gm-Message-State: AOAM531GXcfAy3vSVuC1FvD7iprLxvaPGA4JNx97Ywpl6LQAe+eue8Bh
        +9o1Vm22AFSgTrYcchnSKxVU+MK/cvRPEGcLWQU=
X-Google-Smtp-Source: ABdhPJx1WAK57P7gss50W9Beemu0j3TP092wJbDltjPnhLzW3G3PvAU64j0v2RUJlFUyoFI9PzM7BBFicNEKCvBtXJY=
X-Received: by 2002:a17:902:e80d:b0:151:e043:a2c3 with SMTP id
 u13-20020a170902e80d00b00151e043a2c3mr12518835plg.64.1647037404220; Fri, 11
 Mar 2022 14:23:24 -0800 (PST)
MIME-Version: 1.0
References: <20220311032828.702392-1-imagedong@tencent.com>
 <20220310195429.4ba93edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CADxym3YybdOPMwHr3TOf0vxAN5W8mMdeQmQiQq_nr-1SSF5jMA@mail.gmail.com>
In-Reply-To: <CADxym3YybdOPMwHr3TOf0vxAN5W8mMdeQmQiQq_nr-1SSF5jMA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Mar 2022 14:23:13 -0800
Message-ID: <CAADnVQ+XOqPXVaVVQ0HDtBob6Kv48AqEQrn8mS4rPyiNUGQXBw@mail.gmail.com>
Subject: Re: [PATCH] net: skb: move enum skb_drop_reason to uapi
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Thu, Mar 10, 2022 at 8:58 PM Menglong Dong <menglong8.dong@gmail.com> wrote:
>
> On Fri, Mar 11, 2022 at 11:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 11 Mar 2022 11:28:28 +0800 menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > Move the definition of 'enum skb_drop_reason' in 'skbuff.h' to the uapi
> > > header 'net_dropmon.h', therefore some users, such as eBPF program, can
> > > make use of it.
> >
> > BPF does not need an enum definition to be part of the uAPI to make use
> > of it. BTF should encode the values, and CO-RE can protect from them
> > changing, AFAIU. I think we need a better example user / justification.
>
> There is something wrong with my description, it's not the eBPF, but the user
> program that loads eBPF.
>
> In my case, I'll pass the packet info (protocol, ip, port, etc) and drop reason
> to user space by eBPF that is attached on the kfree_skb() tracepoint.
>
> In the user space, I'll custom the description for drop reasons and convert them
> from int to string. Therefore, I need to use 'enum skb_drop_reason' in my
> user space code.

As Jakub said there is no reason to expose this in uapi.

> For now, I copied the definition of 'enum skb_drop_reason' to my code,
> and I think it's better to make them uapi, considering someone else may
> use it this way too.

No. Please use CO-RE and vmlinux.h instead.
