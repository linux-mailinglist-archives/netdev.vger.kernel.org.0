Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8850BCF0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449611AbiDVQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449068AbiDVQ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:29:30 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9D5EBCF;
        Fri, 22 Apr 2022 09:26:32 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h27so14908076lfj.13;
        Fri, 22 Apr 2022 09:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W3ErJKSyUTgCN7lxhUsHpBZ8kXzxl1Rq4h0+SNf6uoY=;
        b=Ia0j6KGxWiQ7sqdpSo46uRPYP0MGBWqmGDErUg8qWvJliL+Iao9XN3Co/DGRdNrZ+F
         dqi7SP6C+gK6MVeonXKINF/p0Ty9rShxMSTxTrH4tJ0Lpb+6QyWzc2NxAl593aN2yZ4u
         D5w44oaLVC6G7Lo3aJCFWg7IWSxyV5sbF8927WkrQHujA6aLpZOr7ooghtqN/HDvT6Ua
         Tr/XGmCIfHucgWgjiDviYO+/0dUXSS8JbfeETVCkqR+Vp7pg4vnRX9KTzGNkH211S43I
         krhswQ4Y2wXJH+8/2ejGZdVBqAaueCumvDkB3uEuTHsqS+ebaNINs9pBgQtYe/RUBXaR
         VAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W3ErJKSyUTgCN7lxhUsHpBZ8kXzxl1Rq4h0+SNf6uoY=;
        b=7t8K3cJKIsi/95j60gwZLtvQm+30lfDjPdQYxh3NOI0dBddWc/gXCwMehDeFvVMnMH
         z7HoBAy1kj3JM8oilXoiBi9s7tHJpSyOMHkU2nE9QOgIrERcedp18JyYuxbMLx2HsgMV
         AgZHA40hMdMQNdjfi7r1fYs/IGz6uYNh5PaJuaLN2Y7AfUeVOmtGE8usnARq+n7ugSSY
         lznDyUTWPGWozqJBM37I7Whv2EvrKQF5hRIiTqR97IN7w7vm3rMxc/isrc5njRf2CTnY
         oRYtU9+cOeUzXOxdoZTdWpyFaRlGsWGZPyMDOj8eyHHoew3Nd80iqA47LVVuCgy7S99v
         slfg==
X-Gm-Message-State: AOAM5302sQFCPExWvRxXBfMTVbpR3d8WZlA5c+67SbQ/x+Qr3omHmaA3
        uU/q378h5iD1DQYSTfNn7R2slW0X+JRz6PZ1rl8=
X-Google-Smtp-Source: ABdhPJx5lev57lC8P2TC16HcJcGi6BTAZ/DAoOM7RfmEuXR34RWx9GJGZMhbVLdVgat+bJow2ck/NvNl2R2+Ok08Jhw=
X-Received: by 2002:a19:7b17:0:b0:46e:cb82:fe24 with SMTP id
 w23-20020a197b17000000b0046ecb82fe24mr3642082lfc.194.1650644790219; Fri, 22
 Apr 2022 09:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1650575919.git.peilin.ye@bytedance.com> <950bfd124e4f87bd9e1acbf6303545875c3681fe.1650575919.git.peilin.ye@bytedance.com>
In-Reply-To: <950bfd124e4f87bd9e1acbf6303545875c3681fe.1650575919.git.peilin.ye@bytedance.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 22 Apr 2022 09:25:53 -0700
Message-ID: <CALDO+SZNeBrupoCigpM9g5TEGAgEi6k8+usXc0O8RqkLmeO99Q@mail.gmail.com>
Subject: Re: [PATCH net 2/3] ip6_gre: Make o_seqno start from 0 in native mode
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "xeb@mail.ru" <xeb@mail.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 3:08 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> For IP6GRE and IP6GRETAP devices, currently o_seqno starts from 1 in
> native mode.  According to RFC 2890 2.2., "The first datagram is sent
> with a sequence number of 0."  Fix it.
>
> It is worth mentioning that o_seqno already starts from 0 in collect_md
> mode, see the "if (tunnel->parms.collect_md)" clause in __gre6_xmit(),
> where tunnel->o_seqno is passed to gre_build_header() before getting
> incremented.
>
> Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

LGTM
Acked-by: William Tu <u9012063@gmail.com>
