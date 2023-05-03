Return-Path: <netdev+bounces-210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7776F5E85
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 018E01C20FF3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBC3DF5A;
	Wed,  3 May 2023 18:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558FEDF41
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:50:29 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A12D7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:50:07 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6433c243282so953990b3a.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 11:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683139807; x=1685731807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ktsayltn6lefFtlFSAVZI4oVcXyqI0TOiJ/+G5BCoc=;
        b=JfVJbErIHzTCDfoCBHH8jVTz065sPxgIUPLVnqfy82umYUB+KbeeXfadQ7KHt+LEZf
         CVdSdnQh1+Xb5gpYhB5yJM9p7Dcd1onHaYNyZS8t2o3ivP8UgGyJEk422TmRSm+atVgd
         oQmm+fB+L9nlJkrvFCiQXnU5CsWHjGBST+y1kaq6l6MKAzNCVKqA9SAKWBvapM7EPFC7
         SPWnSexs5eCYo8kSWljJH1pxG/aacXDsTMcmcX17iPLRE2poIGPZhv+MhEnC8s6Cld6g
         5Zj/YdPEqaGd040N9SDSZ4Ywd51zFQXsg1VUvwrsUAMeJ9b/HU3BVejCj69j9yoAcLMv
         3TRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683139807; x=1685731807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ktsayltn6lefFtlFSAVZI4oVcXyqI0TOiJ/+G5BCoc=;
        b=gEQ+W3ME3QEIUZlJFQlPRbw8wxQZgoTN2zVT2Ov7LRUtpDPxojwq4NSVn26P44t9oy
         0gus3/nvheNdJZKLNPg76EqtpNcfInQCVvOEdowdt0hCmQquAeAIuQtk46AmGsdHtYi+
         KGACO0ArpsaGY46lqApcvV2N8hOYShQcyrhwu+FL5pN5SMN8QKtkE8zxaUgwX9Ul440f
         Q8ojCgflYZ5RqePOddMCCUEc1yPRP3lOMj3oYoIwikoyNICg9lg5/3wRZC+H2nOmntPK
         ttKuJN/bNZS/caHitjyF8BM83+PKLR/zbpsl3PEDFmkRtfrKnECX1R5sFeNoXe7Mo4Ys
         OIFA==
X-Gm-Message-State: AC+VfDzeh1X/0JEB+Ne73kC0XUEZe6BBp4/rYQ78Hm4HYveO2TMVieU9
	1rxRS9uJK0MpDaD11l8ENN9sdg==
X-Google-Smtp-Source: ACHHUZ4kjrelujB/Nl2ZwPLKzrCg2qTLBjm+gtmV7OcXyAKlsQ4oDlxK2QQWy0dd77bLtNyZv5noog==
X-Received: by 2002:a05:6a00:9aa:b0:63b:89a9:529f with SMTP id u42-20020a056a0009aa00b0063b89a9529fmr28345346pfg.14.1683139807160;
        Wed, 03 May 2023 11:50:07 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t4-20020a655544000000b005143448896csm125185pgr.58.2023.05.03.11.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 11:50:06 -0700 (PDT)
Date: Wed, 3 May 2023 11:50:05 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Max Tottenham <mtottenh@akamai.com>
Cc: <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [RFC PATCH iproute2] Add ability to specify eBPF pin path
Message-ID: <20230503115005.05ceddab@hermes.local>
In-Reply-To: <20230503173348.703437-2-mtottenh@akamai.com>
References: <20230503173348.703437-1-mtottenh@akamai.com>
	<20230503173348.703437-2-mtottenh@akamai.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 3 May 2023 13:33:49 -0400
Max Tottenham <mtottenh@akamai.com> wrote:

> +	fprintf(stderr, "About to bpf_object__open_file()\n");

Please do not add your debug code

