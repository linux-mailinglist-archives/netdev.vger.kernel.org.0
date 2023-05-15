Return-Path: <netdev+bounces-2692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD5D7031F1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CBB71C2092D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9330EE56A;
	Mon, 15 May 2023 15:56:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AEFC8CE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:56:34 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76406FF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:56:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso10765499b3a.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684166192; x=1686758192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcLsr78EN7rEqPNewa0hKsosvcKEefYu9hxdkOGF9BE=;
        b=t42S/uV9vuqdYs8egpECgEbmFeiZUT1aZki0nf0JVuoyYW8YQ7ZKnF2tqrcnyPr7tN
         zKTZqCG0Ct6pqg1xPsUsNSrKV9UO2Um2lH0gXMV11EOx/I/8jhZJK6Lx5NN95JSiZJ6b
         hKquYr4POpSLvb2pLTFcUZSWmnOc8FXSNtE1WSU+rmUg84cp/rpLx01Q/xH6q9lYzj0z
         KSh34pKnJ2NZkAPs6J8I6z5ExFaC6N7NdxyXlvT0abEj7yn1hKx0Ad1eYnBvRURXkW+A
         rDnVClHXDXjhlVLZ2QcNaeczaVVU4FQqLaerj4haqy82hiXNY4PIaxvptlhxqB0TlHbi
         lcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684166192; x=1686758192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OcLsr78EN7rEqPNewa0hKsosvcKEefYu9hxdkOGF9BE=;
        b=WrOQ3aEzmUjtOzA7tgacvfmrUafPrDmkaoxqz2aehuXYB+92JMcYYjgd0MrlbGQe7O
         J4Yj8fzE6ajYR9MtcHPMIbuFD0S8GKcQUI0YqFB2+hlnIT/p1knpNYlsj0M1FTaigngq
         8GiacoDKm+A7ox+0EZJDQGcuxnMPN+YVN5szMiT+538dVmT1fj05LqslqQBQa4bluawv
         wVHqKw264DMzC6vWFUrmUciC580KEJZXFSRySgK4zYdQx4wOkoPQwj1/9zgZDVhrlfyI
         tEMpNgy0hd6GKj09ntSBYQAvSUopM/19+2Qo2YGCsJNX/GczC1kyyeRGqX14XlP4HHDA
         r00A==
X-Gm-Message-State: AC+VfDzghcZP5KMsU+d47CZiTLouNjkd3JGtQZZW/CFxCmURR80Icjrl
	aXkVtx7GUtrLrT9F6PMxjOR/ng==
X-Google-Smtp-Source: ACHHUZ7guiwS0vhMsPKfkgMtXN5vJAa+blVOCmLC7VwtpLIKmYcJEPs7xTmp7MUXux4OuVm25d2WCg==
X-Received: by 2002:a05:6a00:b55:b0:648:c1be:496 with SMTP id p21-20020a056a000b5500b00648c1be0496mr26608014pfo.22.1684166192018;
        Mon, 15 May 2023 08:56:32 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f3-20020aa78b03000000b0064385a057dfsm11989225pfd.181.2023.05.15.08.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:56:31 -0700 (PDT)
Date: Mon, 15 May 2023 08:56:27 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Johannes Nixdorf <jnixdorf-oss@avm.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Roopa Prabhu
 <roopa@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides
 FDB entries
Message-ID: <20230515085627.5897dab1@hermes.local>
In-Reply-To: <20230515085046.4457-2-jnixdorf-oss@avm.de>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
	<20230515085046.4457-2-jnixdorf-oss@avm.de>
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

On Mon, 15 May 2023 10:50:46 +0200
Johannes Nixdorf <jnixdorf-oss@avm.de> wrote:

> +static struct ctl_table br_sysctl_table[] = {
> +	{
> +		.procname     = "bridge-fdb-max-entries-default",


That name is too long.

Also, all the rest of bridge code does not use sysctl's.  Why is this
special and why should the property be global and not per bridge?

NAK

