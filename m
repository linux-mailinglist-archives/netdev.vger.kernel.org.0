Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DFE6BC5B1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCPFep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCPFen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:34:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3A526CF6;
        Wed, 15 Mar 2023 22:34:41 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a2so585844plm.4;
        Wed, 15 Mar 2023 22:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678944881;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls/1C1fjTBcCa/C3j0TCtienks5q/TNfZn8b1BGjZZ4=;
        b=npFB/vNSfQ/bWzzysfNIFzNRN2KCnSwZgiD8fuyoNs50IXpxajLX16LqTvGuNB3SAE
         dDIuYQtu18aSC8Qhl7QBza62vPR2mkwwd/lUwU4h6jVN6qwsvRyY/2PFxG9FwqtOSA8R
         HOG8NW4xvS3E1S1zBk90MHyUN5/Jl9TRKPKHrrOavGRc+lHdSyiujm6DPaxBp8bY2iKl
         u3XV+6UFiqURHscxBS/sO66qhk4uzEaD4EnXN4hcoq4xMKClVCLJg2sUkVLb3lZ1kWfk
         tcq0rPXFb28xOullG9dQhDliyjMW/jxwtIaOd00OdM5V5EEVOQR1ELLXxHuvqTuFlJlj
         pcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678944881;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ls/1C1fjTBcCa/C3j0TCtienks5q/TNfZn8b1BGjZZ4=;
        b=hiC+wjJL+zkBO/ieHmhptC5V3jcVY14Lo+GcLptdeflvP5ALql8p7udvHxA4i7p0Mm
         nnU4686LXkktvpemh6vhqWmLbdpFNm894vNQvB3zga7piDotSN1ROmzAKIRYldZT9PNP
         TE2kANhWwlNUzn4QvPTCDDWG9lE83EucDmqf26MBtyERvUm3ssYjIX5OXLF3HLpUNB2x
         3YsRiN60oGfoK8BCAj1L8Sy6zHQCg9jlw06wf6OlM9K7ab/Nk0zzIauioAogI+oEWOQc
         qvXBSouCGX12jogDSFiVOVv/2Z7UN2DO4ZFNc7OmJxj9a7ze8bpNrhnCmXh7y//rbfOO
         jITg==
X-Gm-Message-State: AO0yUKXrq9JKD0i9pFzXDQdJaKHeS0rbILbJYnXD+1Hl0Ohvd73Oe2dR
        tWdlwL/pays4UFZGhaBnOUc=
X-Google-Smtp-Source: AK7set/VVVu8swVlM2DaluN5K9HyfErbJ2rMBGYGQKP/G9NszeAc78z5M7B8IhNzVVJxyKH6phZ8AA==
X-Received: by 2002:a17:902:db07:b0:19c:be57:9c82 with SMTP id m7-20020a170902db0700b0019cbe579c82mr2225682plx.65.1678944881263;
        Wed, 15 Mar 2023 22:34:41 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id li3-20020a170903294300b0019a83f2c99bsm4593759plb.28.2023.03.15.22.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 22:34:40 -0700 (PDT)
Date:   Wed, 15 Mar 2023 22:34:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <6412aa6f8fbcb_8961e2089@john.notmuch>
In-Reply-To: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH bpf-next 0/2] bpf: Add detection of kfuncs.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Allow BPF programs detect at load time whether particular kfunc exists.
> 
> Alexei Starovoitov (2):
>   bpf: Allow ld_imm64 instruction to point to kfunc.
>   selftests/bpf: Add test for bpf_kfunc_exists().
> 
>  kernel/bpf/verifier.c                              |  7 +++++--
>  tools/lib/bpf/bpf_helpers.h                        |  3 +++
>  .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.1
> 

For the series

Acked-by: John Fastabend <john.fastabend@gmail.com>
