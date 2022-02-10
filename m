Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF04B14ED
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245528AbiBJSGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:06:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245504AbiBJSGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:06:40 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A188125CD
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:06:41 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id f13so3418644uab.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QLAfKqmhSBus4Fd9PwOHU5Gpom66QCfywDWDrHdXm0I=;
        b=E1HaE37yDHuRfjmHQaBH0z3g8JL0XisVYmChbS9IzmugVv3n3pW65RdfySSHe+ytZi
         9IFmm0+FzPdULbDNITcsTXApIIjIr0M6PDTufNwROmfpqQ45r5EQFTrFu7fiLBuTK4ze
         sQ4OGDvMZxIow/kSnMZkThIeRK/Mqpnk6F5LsNGdXjckZm9ie7W3BOcTjEfEbA8uYDpE
         O5X4zh2F6aaaK7bBFQs4PhiOvWA/1EVuYqaej3yZjeK7iVWmKSOlGwffcfu+I6Nj1RCL
         7sXecrQAQLL7zTBfzAJX7j0oqvB90KO5Zb8oBQgBLpuU0vMTeAu15pdEAUVe1vKavek+
         sSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QLAfKqmhSBus4Fd9PwOHU5Gpom66QCfywDWDrHdXm0I=;
        b=ss9QKVYOvzFi5QK76bww7U7GuWVcC48DWoR0UHeXaWY2LFdZOniJoSY97pGMJYbNu2
         +gEZggPrkO3f9lNnWw/hwu0nhbBAhL1ZERojQ+5xYvvg2v5nBtC2p9r6yYAQt3t4m87r
         otD7KuFlnxFTSKfXXZm851ezPchoXIIPSIsmcJ3Vcp4bM4p/hBF039V06w4fKOLdxWdN
         0hDjPD9eJz9r2TKFjspOUnqa1J9Z9gHkOHtD2SLOzFiW3T0MAOc4WYlLrEdf0DCxobW1
         UMjsF5IAPwXKV+B7AnUPzmrMciS7QMFefImGTBigG9OgbGk0Tg6AWs2GrU1jwNPC0i2r
         Pf3g==
X-Gm-Message-State: AOAM5324+vhNANmk1tSazgnAUZkSccP2xCA4R0tsND4rAHBTm6wrpQpQ
        pxSgfeXB9wj/A/1MUc4gko+wcH8Qw9cgTNLBpO5kWA==
X-Google-Smtp-Source: ABdhPJyL0ZNYGrR3MjeCiFh0aRSXwUGHcPfhFv1tsW1Cy0Yjm2/GJR4EmgQGi8kwNeTXmb1sUpyY0g/NxVDJGvCs1wY=
X-Received: by 2002:a9f:35d0:: with SMTP id u16mr2723403uad.87.1644516400582;
 Thu, 10 Feb 2022 10:06:40 -0800 (PST)
MIME-Version: 1.0
References: <20220208025511.1019-1-lina.wang@mediatek.com> <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
 <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
 <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
 <5ca86c46109794a627e6e2a62b140963217984a0.camel@mediatek.com> <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
In-Reply-To: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 10 Feb 2022 10:06:28 -0800
Message-ID: <CANP3RGeCRz5Ea6tbX4qGnYNzP_sq0K3mGKdpzP0OrcL=C6ejgQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix wrong network header length
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "lina.wang" <lina.wang@mediatek.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, zhuoliang@mediatek.com,
        chao.song@mediatek.com
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

> I'm wondering why don't you simply enable UDP_GRO on the relevant
> socket?

Oh this is simple.
We don't control the socket.  Apps do.  ie. the entirety of the rest
of the internet.
