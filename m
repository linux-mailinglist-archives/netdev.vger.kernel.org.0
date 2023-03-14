Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AB66B8A68
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCNFdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCNFdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:33:49 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22979547C;
        Mon, 13 Mar 2023 22:33:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p6so15467233plf.0;
        Mon, 13 Mar 2023 22:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678771997;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36ibrafmLpamZn+W+iBl+mMmpgPiNGrxdApXdvo3HNs=;
        b=kEZacOCLw56Qx213qJtO/0Hfid7kZe5TD11t8CLWcXyf3P/+WQObxCS1umZRuOS5Py
         VSgddGfoMr2vHu1Z2ePfK4tUZT8b9U3oeSm54QE5Af4JomfBlMNRILr3M5mpoRySVu6B
         w0U8UJ2zuPj25uWJMR5REelIUvpGOtH96c7JTTmFEJ08obA63Hlo9u20r4/RP384qn8E
         rfhIOcj39DNbcXHyZeDzA197oYAShCzXZ/K6tmn7bZQLd4Xp8MojV4CYfzr3ECiPYT/5
         UeFnNosMVU58ntnDH+8+vsUWOn0M+rr2GDPdniLWsT5D8F4dCJgI0oT/g2m8ZcK8TJv4
         +8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678771997;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=36ibrafmLpamZn+W+iBl+mMmpgPiNGrxdApXdvo3HNs=;
        b=xGxjuZYFRHi2a7lCOoRVSSXenwJ7YL9Gjzcm/17IZzJA6uOc/8j2FfUmrnQiKDZG1N
         ay9/n2fJAE/mqEAs5TqiVmGR7GpGIV+e7noaWHpUVv3fZeuTYx6eBK3ENZf07i85t1ID
         oMuI1O/Poo5claAQTpwlyZj+Rr+lFgfL4fUO73j5EnpXK5oJL+TRhlAKeyf2xOFqz+AI
         jGsMn7P9wbVrl2rnZrCWlUAWQm5vFbpe8kKL3vf9qTR/PT1rU7Ozeew3DFqsAutN863+
         cqw+kEw9YOImZSAu2j1KhS8sJajrYTweQNwabxDkOMvEIqt62bqx7M5HIqIn5HCoEWu/
         +CyQ==
X-Gm-Message-State: AO0yUKUpfj0vzNZrxEPSyhInvOd7Pu0GeyqXu6NGOiLKgrgvh6ZDzRSv
        3khxeXpFlRBYmpC2Bq/o5Nn91H/jZN9mhA==
X-Google-Smtp-Source: AK7set/cVq6J2rVydtId3Xw4lHsQcjcUS9ABzRALL8cCvtd3DNkC4zAt3av49kKoXtGXxdmfT0gzbQ==
X-Received: by 2002:a17:902:7c0a:b0:1a0:4d34:f6a4 with SMTP id x10-20020a1709027c0a00b001a04d34f6a4mr4298519pll.55.1678771997056;
        Mon, 13 Mar 2023 22:33:17 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id km15-20020a17090327cf00b00194c2f78581sm746498plb.199.2023.03.13.22.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 22:33:16 -0700 (PDT)
Date:   Mon, 13 Mar 2023 22:33:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <6410071b7186f_425812083@john.notmuch>
In-Reply-To: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH bpf-next 0/3] bpf: Allow helpers access ptr_to_btf_id.
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
> Allow code like:
> bpf_strncmp(task->comm, 16, "foo");
> 
> Alexei Starovoitov (3):
>   bpf: Fix bpf_strncmp proto.
>   bpf: Allow helpers access trusted PTR_TO_BTF_ID.
>   selftests/bpf: Add various tests to check helper access into
>     ptr_to_btf_id.
> 
>  kernel/bpf/helpers.c                          |  2 +-
>  kernel/bpf/verifier.c                         | 15 ++++++++
>  .../selftests/bpf/progs/task_kfunc_failure.c  | 36 +++++++++++++++++++
>  .../selftests/bpf/progs/task_kfunc_success.c  |  4 +++
>  4 files changed, 56 insertions(+), 1 deletion(-)
> 
> -- 
> 2.34.1
> 

For the series,

Acked-by: John Fastabend <john.fastabend@gmail.com>
