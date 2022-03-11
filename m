Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2E4D5A25
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiCKE7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiCKE72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:59:28 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B55F213D;
        Thu, 10 Mar 2022 20:58:25 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id r13so16699796ejd.5;
        Thu, 10 Mar 2022 20:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyE9IcY/AL9lvvlSStbY/lLOPYuMFGZEROA9x6xbLGI=;
        b=PsuYdL/+Ispy6VwTl/mQFpUDlSYHVjfBN0IUuF5kQujsjD4rot6zOwROwQai0h7cXE
         rNp4ZrNCo+BNN7dHZl820+1VTComRjrs1dw0EK4DR/xSlMM8hOdr6QeRtf1t2G6z3NXe
         gC0BZnxkhFtSF4gCeQkNqfJhYe90FeD8h/loAWx7ciGfkHVU2f8Q5ZP9N7yML9broSl3
         SdZ4JvkBpIvkgNi4qmxUSTobIrAYtYkARSNkIP/R9Cr8967y4lkVpyQkATULC4cAQTyu
         A/C37H2UGyBmUkt5Iz8SREf7yy1mymS1hMpLE68p3wmiJkbjoCqn6ES7FrBwiKPe2o16
         2ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyE9IcY/AL9lvvlSStbY/lLOPYuMFGZEROA9x6xbLGI=;
        b=lN/oWs0EPNU8VwwSlYpcZmn1n2rltaomUyOh/mLf9AXT77dNJyCO67sHcFiHu8hgHO
         R5XMfjI2Dw0tWTigoL3/Bb8t2vrd4eh2d9djaBRqEcuYe5mFgQf8WkGVw7WLAPbTK+8/
         uqSLbv/ys4t5B4QNwL4pljk6yFQxQl8Qm9gimFZ3fQ5wwqyNm+/qLcaxgkq51YkoKwUN
         Mo9muHgr8opy4pS4EZL0YucUBBQeMiTdkmiDIXr6BSDC0RrJz0lr0e3B6s8wmRwuMRo/
         dcZGBORAZOYvi6a6r6xWCk2eoKSOhhpJN2uflJ3BYloR3GE1t3srT1T/33P53DgpCgMl
         WsJQ==
X-Gm-Message-State: AOAM531QNptyNg4LJT6WSPp6i57fID68jbFD6+/UnwPSzfGKaPLNWxOB
        dhypIGmUQUYnWZOZVSbUuwVC8lg3JvjW1bYs96s=
X-Google-Smtp-Source: ABdhPJx4jo/HcQhkdwEHWAn2U1prIfLz9M5lp3VyDorElOSP4hYvzjWz0BBM+zkK42cgxU1gNkhOTJ8HAnX/46FFmPQ=
X-Received: by 2002:a17:907:3f9b:b0:6da:6f2b:4b1c with SMTP id
 hr27-20020a1709073f9b00b006da6f2b4b1cmr6923862ejc.765.1646974704368; Thu, 10
 Mar 2022 20:58:24 -0800 (PST)
MIME-Version: 1.0
References: <20220311032828.702392-1-imagedong@tencent.com> <20220310195429.4ba93edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310195429.4ba93edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 11 Mar 2022 12:58:13 +0800
Message-ID: <CADxym3YybdOPMwHr3TOf0vxAN5W8mMdeQmQiQq_nr-1SSF5jMA@mail.gmail.com>
Subject: Re: [PATCH] net: skb: move enum skb_drop_reason to uapi
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
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

On Fri, Mar 11, 2022 at 11:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 11 Mar 2022 11:28:28 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Move the definition of 'enum skb_drop_reason' in 'skbuff.h' to the uapi
> > header 'net_dropmon.h', therefore some users, such as eBPF program, can
> > make use of it.
>
> BPF does not need an enum definition to be part of the uAPI to make use
> of it. BTF should encode the values, and CO-RE can protect from them
> changing, AFAIU. I think we need a better example user / justification.

There is something wrong with my description, it's not the eBPF, but the user
program that loads eBPF.

In my case, I'll pass the packet info (protocol, ip, port, etc) and drop reason
to user space by eBPF that is attached on the kfree_skb() tracepoint.

In the user space, I'll custom the description for drop reasons and convert them
from int to string. Therefore, I need to use 'enum skb_drop_reason' in my
user space code.

For now, I copied the definition of 'enum skb_drop_reason' to my code,
and I think it's better to make them uapi, considering someone else may
use it this way too.

Thanks
Menglong Dong
