Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3F55102F4
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352851AbiDZQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352848AbiDZQQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:16:29 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB889A9B4;
        Tue, 26 Apr 2022 09:13:21 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id 125so20589920iov.10;
        Tue, 26 Apr 2022 09:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJMkcDCTGhP0ayLvd0I+jpervcoFaZO0k/SeCGEUu1Q=;
        b=XU1+nhwpmvJ3MqLwmBtfHMGKM229bJRwaYofoSwWpdy4yH9uxRaeueEEENLI4HlY1o
         3F8legZsN6VbCvwyUS0mQHlWV3OPuoEorU7g+9SOsmlTwIqY7eZYTJQOYXXrJK5UQWdC
         B35NtUasCtsyIbbFIbm7MGNrBfEqQKu3cmiAktqgQVh0EkSrpv0Zxw4jY6M1Fdv9X8Wi
         G7GpVPAgih6vW/6KjgRa+P0ZRFX52EKQRi24yUj7eIMv51fIFE7eYsXhf82zclwFss+u
         IEVFZvdL7Wb5RH1e7fEavvQws3aEJNpDstJNLlS96diKmVpU3DzpsWz+P3MBNTdVg1gw
         ZlEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJMkcDCTGhP0ayLvd0I+jpervcoFaZO0k/SeCGEUu1Q=;
        b=P2P0gPrPxP2VS5ldyvDO9AERbnupWxr7hWosGnWnQWXK6Ytv6jHCdhvD+qFZgxeAmJ
         yP0WT7RFRuT1WuvCdkb2ICRoUIWJDoM5XrWYPLtnzciAIyzdlwfILSGCbIAsQ75pv6mh
         JwtJAhBgpYdvgubkGQ62zjUawCLbiHJ+qYfgMyhsqBUB27FNbVAblHxIvfM8xUP/ZFaT
         oioMbqjKtj6EU7xjSyUDb/JDGo6Sy3JbobslxR1KZU7Ci8dChJPOE4xFh6Rp+OBZG4+0
         k7HcJSe53V0aXSMBbemLwyMw90/Qf6BFKhEEmWHSIWDDAfvZEKl1OjQ3iRlKRLfr8hro
         9VIQ==
X-Gm-Message-State: AOAM530PGj2/4P/YxSDNs2jKO2Tkccb0vjXE3qLR8pfOiiiYO4U0U2cr
        iL3i6VAxp7QlIIN2xKMjYnkNjDhTJF16/Q6KUDM=
X-Google-Smtp-Source: ABdhPJw8r05wZcaVMjTSP8BXPs9EmptOK3ZOn2VSK5Mlwly8qpWo7cIa2/v3dQx+F8pSPSC/tb6TF4727jy6q92o4QE=
X-Received: by 2002:a05:6e02:1846:b0:2cc:58e5:cd38 with SMTP id
 b6-20020a056e02184600b002cc58e5cd38mr10008604ilv.87.1650989600731; Tue, 26
 Apr 2022 09:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-2-laoar.shao@gmail.com>
 <CAEf4Bza_8d_K22DFRzGHYAQdz_y1+9b_bfSc0t0EkdM4nyy7Hw@mail.gmail.com>
In-Reply-To: <CAEf4Bza_8d_K22DFRzGHYAQdz_y1+9b_bfSc0t0EkdM4nyy7Hw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 27 Apr 2022 00:12:44 +0800
Message-ID: <CALOAHbDPE6iSGVR1pyNkY-N3RtoGYaptqcn+Nse-T88sWcD5Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] libbpf: Define DEFAULT_BPFFS
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 2:45 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Apr 23, 2022 at 7:01 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Let's use a macro DEFAULT_BPFFS instead of the hard-coded "/sys/fs/bpf".
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h | 2 +-
> >  tools/lib/bpf/libbpf.c      | 2 +-
> >  tools/lib/bpf/libbpf.h      | 6 ++++--
> >  3 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 44df982d2a5c..9161ebcd3466 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -137,7 +137,7 @@ struct bpf_map_def {
> >
> >  enum libbpf_pin_type {
> >         LIBBPF_PIN_NONE,
> > -       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> > +       /* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */
>
> how is this improving things? now I need to grep some more to find out
> what's the value of DEFAULT_BPFFS is
>

The new added one also uses the "/sys/fs/bpf", so I defined a macro
for them, then they can be kept the same.
I won't change it if you object to it.

[snip]

-- 
Regards
Yafang
