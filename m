Return-Path: <netdev+bounces-2129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B04B7006CA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5993B1C211B9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0A8D510;
	Fri, 12 May 2023 11:27:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E82B7F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:27:50 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA111BB
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:27:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f423ac6e2dso44246185e9.2
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683890867; x=1686482867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0MO8n0AWS/ztJyQBnj244iKl58C77Zq7y48ei4159sU=;
        b=avuXv7yVdq3gkTqcAlTosK4b9MsHOSDgjHwW4NyH8/FD3FStACglRUeK4QpEU4FAP2
         6/Qt2Br+17l7PT0sLlZZMQr7jW6yxsHSH+4HVUaWpaxJUZWm83Nx1UY1d08PtxIaTj08
         NgmwpJijbeOjfzv/RnruLRtEGpBHgbuC5NgF8yG5fJyr58krpz7JATtibrxH4oCTAY2e
         WSHJo8uoZH8mBehwVBezczfFNXdvoBtm6o4XLOLMCstJ/HVNdFUbe+EjguPPaUFtW17Y
         N1CXDaLMnFx3AHiKAvabsS0vx1BtLOnuHiMS9JVzSjSTiKFxQSyRX7nVPF3V0beMbKlB
         ebOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683890867; x=1686482867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MO8n0AWS/ztJyQBnj244iKl58C77Zq7y48ei4159sU=;
        b=Pd8aPYJ2aQwncGZv8F+62X30yHz9uKZBd/BNr4RNaMdSc/Deg+yFw/FkRnah65xzJM
         UctZKB7s3iNzOdGBSsm0gDXo4AMnI+giExzfh6bWNGcYfUkmb5Krp4WWGwQnJNBjCA7E
         HTIMivbghH/by/wMYiqd0g3iqGBduoVJoc2e0vnpgZI3WIlWS/RT255l2gRE/qhQxwkk
         gh2T4bcD1T0WAbhOuqsQQGKfKrFdB4QOCUQuDufHX+02pNWkY1yoF1RCF/3i+H77hdSf
         5WRBiggDdtlftjhyBZ2eQmDR3Hsdtg81AZdhaonA83GnNbah35RAXdWxGHHTC0hSCvoa
         /IKg==
X-Gm-Message-State: AC+VfDyII0nr5ev3IXCv5s3QZ0M9CM6JOsB54jR06ewrePMsY0oc9nEW
	/MiH7K859yyuLPqPje3YLm2q9g==
X-Google-Smtp-Source: ACHHUZ49zMy6r+ZsdMp5ufDLYezgCJT/Iu9DlKq1htf46lbhRfTh/RmSNTiSnwac4sit0WjxY6xyOQ==
X-Received: by 2002:adf:e787:0:b0:2f0:6192:92db with SMTP id n7-20020adfe787000000b002f0619292dbmr16034921wrm.46.1683890866990;
        Fri, 12 May 2023 04:27:46 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r9-20020a5d4e49000000b003047ea78b42sm22763420wrt.43.2023.05.12.04.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 04:27:46 -0700 (PDT)
Date: Fri, 12 May 2023 13:27:45 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, me@pmachata.org, jmaloy@redhat.com,
	parav@nvidia.com, Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2 v2] Add MAINTAINERS file
Message-ID: <ZF4isc8xGwht6zpC@nanopsycho>
References: <20230511160002.25439-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511160002.25439-1-stephen@networkplumber.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 11, 2023 at 06:00:02PM CEST, stephen@networkplumber.org wrote:
>Record the maintainers of subsections of iproute2.
>The subtree maintainers are based off of most recent current
>patches and maintainer of kernel portion of that subsystem.
>
>Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
>Acked-by: Petr Machata <me@pmachata.org> # For DCB
>Acked-by: Parav Pandit <parav@nvidia.com>

Acked-by: Jiri Pirko <jiri@nvidia.com>

