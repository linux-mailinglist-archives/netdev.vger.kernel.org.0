Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CA2B0DD4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKLTYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgKLTYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:33 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD43C0613D1;
        Thu, 12 Nov 2020 11:24:33 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n89so6716911otn.3;
        Thu, 12 Nov 2020 11:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pyygADvlYnDAE/SLOEy+iJcSOimwmvVHIgq+I1eabP4=;
        b=Xsvg6V7eFMnJ0VYg99zwP9gL09s0smyfT/jltTfoW+WVAp4qL9PlEq9VE/Hi/s54o9
         6PpEHSSOvqSmLAXWur+pB1lkWZWyT/bERvoD4/t5oTxhoPxmRaG9c1o8vdnPuwjZKIQk
         v2Fve/cEiQCbrAKCU484ZvIaHer0DdjkLPEgESBuG+yHvZPoQPGT8SDkgyGa422zuMfE
         IxLC1OTnOmIQ/fZasET8bm3GGJRPY7xlMFWV3U22j8/giOPEhaMCXz5yOsvRbRIIsqp1
         kcDv/H85d/ajcCRExGoaN3DHaVwBcGrfLsn5X5o/zCJAficNnJekEvZeogW1aWgDtYk9
         /7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pyygADvlYnDAE/SLOEy+iJcSOimwmvVHIgq+I1eabP4=;
        b=BXIB4oph4hHgjKzHwS47qg/JMsy8WzR5BnosASnjmqxaF57S+yqMeUYkeuIvmF7tDc
         Q4lip4H6XIY33/HPC1NOfucOim2IHRRb+LpdlY7fA+Yw6bUwwhGZud1iuB+46RyV1Dbn
         1DREB4Tei/zgZEKH29JZOh8fO/soYoiXm7dqVDAGfe3xkQ0FiXeQz5E2ZSKx++dByD/t
         tXpufBu+0FSbHr+UFRhalcGsggZQ2cayp23Eovm32pDPMSGb+bsO5we/sCN9jLbWQN7b
         KrRW+BFanVxhcgNGDvv0ax39B25ckHdjgeVjS+2yUX4t1S9PkAYcOlFG55dAis1PLsAb
         Vhrg==
X-Gm-Message-State: AOAM530BGFEJVcbvxSY7WO1qH/bJVmuoTTmoLNoRq9dhdmZoDoDBgAu1
        +wiRiT7/GqAuJzSMc7LBVEA=
X-Google-Smtp-Source: ABdhPJzoEnU6LSFTpRjLf9fuQA3aQD6P1EJnzbi/QKdszpfMzoIlclznFwGNYDBDX1NvGuL3jxPekQ==
X-Received: by 2002:a05:6830:23a3:: with SMTP id m3mr597721ots.135.1605209073323;
        Thu, 12 Nov 2020 11:24:33 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e47sm1422514ote.50.2020.11.12.11.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:24:32 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:24:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5fad8bea8ae69_2a6120824@john-XPS-13-9370.notmuch>
In-Reply-To: <20201111031213.25109-4-alexei.starovoitov@gmail.com>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-4-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 3/3] selftests/bpf: Add asm tests for pkt vs
 pkt_end comparison.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add few assembly tests for packet comparison.
> 
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  .../testing/selftests/bpf/verifier/ctx_skb.c  | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)

Acked-by: John Fastabend <john.fastabend@gmail.com>
