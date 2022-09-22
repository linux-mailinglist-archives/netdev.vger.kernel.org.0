Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6355E7028
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiIVXRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIVXRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:17:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF7F113B47
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:17:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 198so14978803ybc.1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ltvo+eX9rE+c0NV1lZABXc8Rw7KZVJC/HotMsWSe1sU=;
        b=i0sbUit0suIbQV6JAFWuT5EeaXJ3F6mcM41f55BTweSAeQKXMze47AStQfYDF0saAG
         KcGwo9vXVCU72wer8p+msjXBmEi35vi3DKKSOB/jkuAobE2RXsHmi9cBpZgJYYGXfUOJ
         RLLasZHrJ3ELhJaxWf7Z0GaIks7/5hjw8+sCMT7SRBcmZvi1GFfyliixpuMayVxzK59g
         yCpKTw7kIsXDezBSu5Im8LolpSaSfAr6b+rp8jrAPTUnDivbVjADDqWBnWpGN/Y7ERsP
         UmNQPQ6oh9Nv0vEKWrp632FhNb6wkbsrjsLZSKHuwMaRz1T/nIyr0Dkm6XMB3i6yVhei
         8NiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ltvo+eX9rE+c0NV1lZABXc8Rw7KZVJC/HotMsWSe1sU=;
        b=H2Bzv9IGw5MpnMNjk3fBgMUpUGbAXu5H7/kiGwnOpGCE4oeM4Y5C5muIa9h1FkydQi
         2JjgOCNw2FuKtsciW+ibJpms4XKUyefFYU/efhhk8Hd8tlxpbejAJyQrB5uWvoYlKyYA
         2FNJVCmLirV8v4CBm7SajosvGn4j4R3IlQVa/wL0y9V3yONiodwMHUWU1h962bEEDuxJ
         yNSAsB8Q6czwFxg4NjK8dMFPUL1WO1leSp/b4Fg9AaGdaJeqaHut0SqAvZ0XvbAOTCMx
         QKtYvDba70Hhi61+5Me5EX3Bz0yG0UqQVCi9LHNmy+Gecf2/TzwI3D5ycNxIi6P7vDuw
         oncg==
X-Gm-Message-State: ACrzQf0N2nz0R6qcTncFgT945vrFxopX66zDiLQuzq5UWld3ynNlopXD
        mll8/lyGqrH2dDXwqPujzhOnlWK8CAfeCB08zc1FFg==
X-Google-Smtp-Source: AMsMyM7DkBYfH2lrqlsX1Hbkrn9tS6IhOw/beAWQW02qM/X0R2qbERTFaNA0lP3H24W8LEYugI6gO53VFQNw94Bm8cI=
X-Received: by 2002:a25:404:0:b0:6b0:21b0:44cc with SMTP id
 4-20020a250404000000b006b021b044ccmr6237457ybe.407.1663888657007; Thu, 22 Sep
 2022 16:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
 <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net> <20220921074854.48175d87@kernel.org>
 <2338579f-689f-4891-ec58-22ac4046dd5a@iogearbox.net> <20220922082349.18fb65d6@kernel.org>
 <20220922140620.1c032401@kernel.org>
In-Reply-To: <20220922140620.1c032401@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Sep 2022 16:17:25 -0700
Message-ID: <CANn89i+2461VjtW3+_0za87Nq6S3kNsDxU4oDT9YncW6uQ85kA@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net: Fix return value of qdisc ingress handling
 on success
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 2:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Sep 2022 08:23:49 -0700 Jakub Kicinski wrote:
> > What I meant is we don't merge fixes into net-next directly.
> > Perhaps that's my personal view, not shared by other netdev maintainers.
>
> FWIW I've seen Eric posting a fix against net-next today
> so I may indeed be the only one who thinks this way :)

If you refer to the TCP fix, this is because the blamed patch is in
net-next only.

These are very specific changes that are unlikely to cause real issues.
Only packetdrill tests were unhappy with the glitches.
