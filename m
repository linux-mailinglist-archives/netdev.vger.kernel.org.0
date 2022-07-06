Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA6568E89
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiGFQBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiGFQBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:01:18 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2778D21810
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:01:17 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id k14so18830088qtm.3
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 09:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=hXDY2u6jMg7vkEvggtI5AB4RBXe4Hbw6rSIH74WebXE=;
        b=fFIEN8uCmrBxStKbvR2C6opnu9SDffnpYZ+kJERJiNZersQBDv+uoadi13EglEGxWg
         HoFTNiT4e6IHnxvBchc3s4ewz2IbR9r7iiFfrVUD52TAoDdPaXCKU+vxV6I/v3ItbvSj
         spKsCGG/3NLbXVr3k6P9DPEvh5mzv1l0in1zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=hXDY2u6jMg7vkEvggtI5AB4RBXe4Hbw6rSIH74WebXE=;
        b=mNX1nnelqXBpNxdEs19kCcF6B6W+y+kYpuz7JvekNmag3EocY5BfpO3M3tmQVRdBB1
         wAcUVbIHcKQsKFqVBCJlqD1K3yjebisPlhhpUrcnc1GvTITGVDMP5NPcSyT/bRiVvhBs
         NYcUiiED3kXO8jRXYlr3MmmIpEGz2bb8OFPASXW5DooyEEgCxzIboEm5Hnl2UHvQ/6gP
         DzrCmqUnI9pI5wzVwLsqhDCs47Fnse43NWb6iqrQNz2HnYNP+ul0Y0hs2s4LTbgx0ztR
         0WKa6dW0fBQ/4Qp1XMfXtgPerElCZWTRnabvqpo4dpGyQSEz9KJkcvfb8mMdzdvnjROY
         zStQ==
X-Gm-Message-State: AJIora87ZFzU7iWdKd2CnQKfXQUuC4awXFaNucI5vo9sWc0Hr67Axzs4
        RwFMU4pVUv3nKH0rkXXIgLcVAw==
X-Google-Smtp-Source: AGRyM1tbV9pEZEk3QSLJdDZqYDNgt+v0pheI01GB3Bv4jXB/ILGSjVhSfmfEpc4K/E6wOBk9JjZ31Q==
X-Received: by 2002:a05:6214:1ccd:b0:46e:7427:2626 with SMTP id g13-20020a0562141ccd00b0046e74272626mr38233187qvd.101.1657123275539;
        Wed, 06 Jul 2022 09:01:15 -0700 (PDT)
Received: from macbook-air.local (weaver.eece.maine.edu. [130.111.218.23])
        by smtp.gmail.com with ESMTPSA id bp32-20020a05620a45a000b006a67d257499sm26186666qkb.56.2022.07.06.09.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:01:15 -0700 (PDT)
From:   Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@maine.edu>
Date:   Wed, 6 Jul 2022 12:01:11 -0400 (EDT)
To:     Andrew Kilroy <andrew.kilroy@arm.com>
cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/8] perf evsel: Do not request ptrauth sample field if
 not supported
In-Reply-To: <20220704145333.22557-3-andrew.kilroy@arm.com>
Message-ID: <d67dff7-73c3-e5a-eb7b-f132e8f565cc@maine.edu>
References: <20220704145333.22557-1-andrew.kilroy@arm.com> <20220704145333.22557-3-andrew.kilroy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022, Andrew Kilroy wrote:

> A subsequent patch alters perf to perf_event_open with the
> PERF_SAMPLE_ARCH_1 bit on.
> 
> This patch deals with the case where the kernel does not know about the
> PERF_SAMPLE_ARCH_1 bit, and does not know to send the pointer
> authentication masks.  In this case the perf_event_open system call
> returns -EINVAL (-22) and perf exits with an error.
> 
> This patch causes userspace process to re-attempt the perf_event_open
> system call but without asking for the PERF_SAMPLE_ARCH_1 sample
> field, allowing the perf_event_open system call to succeed.

So in this case you are leaking ARM64-specific info into the generic 
perf_event_open() call?  Is there any way the kernel could implement this 
without userspace having to deal with the issue?

There are a few recent ARM64 perf_event related patches that are pushing 
ARM specific interfaces into the generic code, with the apparent 
assumption that it will just be implemented in the userspace perf tool.  
However there are a number of outside-the-kernel codebases that also use 
perf_event_open() and it seems a bit onerous if all of them have to start 
adding a lot of extra ARM64-specific code, especially because as far as I 
can tell there haven't been any documentation patches included for the 
Makefile.

The other recent change that's annoying for userspace is the addition of 
the ARM-specific /proc/sys/kernel/perf_user_access that duplicates 
functionality found in /sys/devices/cpu/rdpmc

Vince Weaver
vincent.weaver@maine.edu
