Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E82F6C9096
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjCYTwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 15:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCYTwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 15:52:16 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B898F4C01;
        Sat, 25 Mar 2023 12:52:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso4791644pjb.3;
        Sat, 25 Mar 2023 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679773935;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5gYAwyA52lJdi82C8jPAWHJNufj9DPpB37puTNEGOE=;
        b=fABRXbYgMCUvuvMTo+XCocOqukvX3lWhgG4i+CB+phD6KVhOSmQKvP+c3o7oJVu6no
         bG/idSqa9ggk465dxs/D2b5iOXfqypcIpLdhXH91ISfad96bIEw46JJSeOVJXlqsHZpV
         1LWPRXXc5j+w8TuU78LM6G4eaPSuuVbImBa41pcDbJx1gHesvh6rxk1prHrPufx+paKC
         ASyDGMoZMav/6Rghwidpp5hxQ7R4J+1JCOXf/5DJZHnoS+yoDTtjUZvUXL7ToRlPe6Xd
         rXpfYodLBmq+B2HXavPGPJavgQ1sSFqbu01ZIndYo8ZU522cbTWMcNY5gZJl4bPlgBo7
         n5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679773935;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z5gYAwyA52lJdi82C8jPAWHJNufj9DPpB37puTNEGOE=;
        b=3phiiczUtQ1pyInb18RlngIIqJ3rpSmBoA0HmdDvbbYBUilA6qMQ5jRiYsUhi7lF3w
         RGA8SPE0k1A6a31jnlWSsRFlFWVmJEPaOSKUMHvhjFVV5Xlwywu4QhhvIMqiCo/iS+go
         AQ7NwUPCLK0oEqGlYUXchg8qs5pmMQTE9Ck+C4rR7qLS4SQz5DmQhA/X+WrR4xC3zX00
         GGPMVmF3DhYOFwJYsgXDLDy99twGJv4j2yn6o1LbrF5VWM7Y1EV95Nf4Ai107CD+hq1a
         +RP/FomydoCTOcHOSFli24cDglPdDEpAww8HM+ns7gLDgRBxmyUcpN0a+SEkmSqqfPx5
         W4zw==
X-Gm-Message-State: AAQBX9dQmRvZ7wUDm/un9pMfb6FniueyWku+vOjDsdqqM6unfCS9Sdtj
        vpQB2lUPFSNJVkmoOx/jdw8=
X-Google-Smtp-Source: AKy350ZlN8R3SKJ7v+hs1AkKVZmcj9zfPcqjUVRGh7WExkCj5alattBsyLJh19oSVQ6TyxvLlwJq5w==
X-Received: by 2002:a17:902:c406:b0:1a2:333f:e19f with SMTP id k6-20020a170902c40600b001a2333fe19fmr2898613plk.11.1679773935013;
        Sat, 25 Mar 2023 12:52:15 -0700 (PDT)
Received: from localhost ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id b20-20020a170902d89400b001a217a7a11csm3568399plz.131.2023.03.25.12.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 12:52:14 -0700 (PDT)
Date:   Sat, 25 Mar 2023 12:52:12 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Farbod Shahinfar <farbod.shahinfar@polimi.it>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>
Message-ID: <641f50ecdfe64_1711f620870@john.notmuch>
In-Reply-To: <DB9P251MB038942715458FA2A2F76FD4585849@DB9P251MB0389.EURP251.PROD.OUTLOOK.COM>
References: <DB9P251MB038942715458FA2A2F76FD4585849@DB9P251MB0389.EURP251.PROD.OUTLOOK.COM>
Subject: RE: Kernel panic on bpf_skb_pull_data
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Farbod Shahinfar wrote:
> Hello everyone,
> 
> I am performing some test with BPF SK_SKB and I have encountered a scenario resulting in kernel panic. I use a BPF_SK_SKB_STREAM_PARSER program to parse a request which might be spanning multiple TCP segments. If the end of request is detected in the parser program it returns skb->len, passing the request to the BPF_SK_SKB_STREAM_VERDICT program, and otherwise it returns 0, waiting for more data to be received. You can find the BPF program attached (bpf_test.c). Is there an assumption that the program violates?
> 
> To reproduce the crashing scenario, I use the python script attached (client.py) which sends data in chunks toward the bpf program. Usually, the kernel crashes on the 3rd segment.
> 
> To provide more information, I have attached some crash logs. I have tested this on kernel version 6.1.0 (slightly modified) and version 6.2.8 (unmodified, obtained from kernel.org). It seems that the panic happens when invoking the bpf_skb_pull_data.
> 
> Is this a known issue or is there any information that I can provide to help resolve it?
> 
> Sincerely,
> Farbod Shahinfar
> 
> PhD student at Politecnico di Milano
> https://fshahinfar1.github.io/
> 

I believe I have a fix here for this. I'll check Monday and resend
last set of fixes

Thanks,
John
