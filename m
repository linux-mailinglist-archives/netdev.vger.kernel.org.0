Return-Path: <netdev+bounces-9749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F146872A715
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 02:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 739FD281AB1
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 00:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD111112;
	Sat, 10 Jun 2023 00:42:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BA8A49
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:42:17 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0111130F7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:42:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b026657a6fso13137295ad.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 17:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686357735; x=1688949735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qr3yEV1soWi1gc8DHuUD+x+zy0RKq6vG+LCf3xgHYRw=;
        b=ZoYZRkp+AbWR5SUXQ7jn/rzH8p/VvFAOUQ9B2wTRhMLy4X7AZKYkkf1cSRVooHP5AB
         Kw3HUmv94Pfcp7MgPGvUxqAw0IxZ1/SCOucalZK08MrwzZWoyt2yt02ezlvoYcvqUu+W
         5eRBWQR6hEo6e6eW3XLJxP3LZAFLa+ilhF0iBtsjBM4F62Jn8LpZ/csDiWLH/EAdEE9N
         IdbNaNzXhypt7UmbBpgG2XHeZ6quCpPPf2j/FxxP2g9A9x4yRMaM2GzVS949qi1QKs73
         K5C4q8n2VkI1O0lkfp9Tk4e1iVGWBl6aQ0nOQAXWJL43FvSuap3NqJd84PrukUk8UAUN
         YVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686357735; x=1688949735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qr3yEV1soWi1gc8DHuUD+x+zy0RKq6vG+LCf3xgHYRw=;
        b=C/BzwS7/JUilLz6m+dIdF53D972/8cPyx65IfbBaDrbWijsq6tK832ZOijDDWV93di
         JvIc2FQETMVs6aSp+yeyqm/igwq6885IenrAhkfcW+qthvwE+T3ikpHRvve5P1qNjbxV
         RZfAxlSvJY8zYMVy4zCAVMOf9/tyNCnx53trSJTNf3FM7CGhYcgYVcjenrugWmLzkP07
         gfIkhp1crr3HIzP4teca1y1dPlRH/mJRBG8F/SY6TahF+Xz69YMQRhqVsqTSvHKUiZy+
         TdVSiCfSwSy2ZQWMAlOZp+aEGuHwM51y1GPLR2q/GsH5yoNUfrxxhrPVK6Q3La9HkW9w
         RPYg==
X-Gm-Message-State: AC+VfDzVbFUgs4zPrbtm7L/0lCrjyqmEwqeHo+MOushN2qIdPxOs7c7T
	kBDqewCkNoFO993I6CSrCzGn8g==
X-Google-Smtp-Source: ACHHUZ5IhSso0bOtusmTE/lqsPIV2RXa3cQeHWkoTI+wACv6ja4w9ti+4Fl2lMP+xGcVmCiOYHwFcQ==
X-Received: by 2002:a17:903:50d:b0:1ae:14d:8d0a with SMTP id jn13-20020a170903050d00b001ae014d8d0amr414970plb.29.1686357735452;
        Fri, 09 Jun 2023 17:42:15 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001aaf5dcd762sm3770306plf.214.2023.06.09.17.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:42:15 -0700 (PDT)
Date: Fri, 9 Jun 2023 17:42:13 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com, edumazet@google.com
Subject: Re: [PATCH net-next v3] tcp: enforce receive buffer memory limits
 by allowing the tcp window to shrink
Message-ID: <20230609174213.0759cac8@hermes.local>
In-Reply-To: <20230609204706.2044591-1-mfreemon@cloudflare.com>
References: <20230609204706.2044591-1-mfreemon@cloudflare.com>
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

On Fri,  9 Jun 2023 15:47:06 -0500
Mike Freemon <mfreemon@cloudflare.com> wrote:

> +	{
> +		.procname	= "tcp_shrink_window",
> +		.data		= &init_net.ipv4.sysctl_tcp_shrink_window,
> +		.maxlen		= sizeof(u8),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dou8vec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
> +	},

NAK on introducing another sysctl.

