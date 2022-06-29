Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30218560A36
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiF2TV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiF2TV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:21:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB402EA23;
        Wed, 29 Jun 2022 12:21:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eq6so23531076edb.6;
        Wed, 29 Jun 2022 12:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PjH9DrncQjphXUiAsRmBLYPPYTi+A1PhhVz0t7N/Nc=;
        b=QxViXKRsnIoBrQZXPt9bhi+0m5dJVacZbOdR3YnN2c3JNScZa3mSLvAZw+lEd6zAiG
         o8K5oZqjoWaX3BRmawxjXcSU9Rln3RkkGpC7Wv8RFURpc7LA4vHyab6d73w6HzbZ/Wd9
         +uBVbM28LoSdzbjUaV3lRg7NEyLjpQhWmw3SOP2wOVl9Chp7OcCjtmr1umyr01M6oreQ
         ih/ar34l82ZFVSKMbjO7LS9JrL0zAWsd5E3LkGiKkdNUx88F4L7ZqYmWry2H7NqBFfOl
         qtOICQV9eG7IU9Dm83/ldMx12JtAbmpnjWNm3nTJLLwNzZvyFJflB3VOQVXVg6t6uW6a
         Cdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PjH9DrncQjphXUiAsRmBLYPPYTi+A1PhhVz0t7N/Nc=;
        b=3aDcOK5MEi1LKAWBgUiTU4FaLxQAcfgCLxSrLIPdsnMDxRLGSsFw//kEILBbCucYh8
         6l374f19XkDWzJ6QMq9hyzkxUhoyEgc6VzAjiAt2eyOBz41LKVLkNjWdVv3dR/N13vB0
         /YbNlXEgPWEt0EGGrypYpJr8b6RhRRpYRrnluqxTdYtHUON2GhHgVB6SWGIyRocIRaqi
         HpSmGQMC++6KzupZggclIWKfgqCeLVhNF4hM+g/ivtR0xyvqb50KdTlpujFZn0HucXPq
         DD33buew6aPKC8tha8ZynRWrhr8nZCghJ+CefTIpX5rcnzzN6hP+OV3LXXkdZTR0MEsr
         bA6Q==
X-Gm-Message-State: AJIora8NDOO991M0PMJ5E3n4ENjcrWBWe+tgm6Y9ZBw/98ekM9+lyAaF
        6/reNP3Yr80mLVcfuO96F7i/bZld75dJmcXYgMI1wJGC
X-Google-Smtp-Source: AGRyM1ulpK6b/agsTb0936XMKMX/ktiuX2mSZ33MXBLtuzmaRJLPMF7QRlCuqC7DE2m2RuQRXAg9tHJCudxY4w7LPqE=
X-Received: by 2002:a05:6402:3487:b0:435:b0d2:606e with SMTP id
 v7-20020a056402348700b00435b0d2606emr6522763edc.66.1656530516219; Wed, 29 Jun
 2022 12:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <YryIdu0jdTF+fIiW@playground>
In-Reply-To: <YryIdu0jdTF+fIiW@playground>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Jun 2022 12:21:44 -0700
Message-ID: <CAADnVQ+8dqkrp_tH4PfeY9wOA60QAHS2xo4xt5F09Q-UUBHeQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btf: Fix required space error
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Wed, Jun 29, 2022 at 10:14 AM Jules Irenge <jbi.octave@gmail.com> wrote:
>
> This patch fixes error reported ny Checkpatch at bpf_log()

Please do not send patches suggested by checkpatch.
checkpatch is not an authoritative tool.
It's merely suggesting things.
