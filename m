Return-Path: <netdev+bounces-5068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB3670F94D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FC821C20DA5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAFC18C0E;
	Wed, 24 May 2023 14:54:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4B760875
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:54:42 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D65170A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:54:19 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d3578c25bso1133189b3a.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684940045; x=1687532045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuxm9M1T3VcSvc5bTzwUGDZCKtGjaiDhJDWNan/MCa8=;
        b=Ivj1gErGOAs0CsMEmRVCQZq3pnia3PQNEWq1PjGjMt4PKgdmLMHr38KozFdZOqen1v
         DCSNXgshzAAG4PTXvZm6rsJSKth8Zg78NLZ99htWzKr0z2k6CFDmAaxmoIP1N35tczkM
         wxT6kdTUb9HlIT/cLOdadD/ILbDe/OxT0/tVOEpjNFrXM7eeNfzvlQtUVF9kd1nxmFYH
         eJacO5abhAMaKenGcxZ6cNrPV+w2JwrfUZuCiBat0TEEY9Q2C8Na7aVlAlY8GB+1mxci
         wry3jkNre1koSM0WkDatTlYH58J0VjmgiZG/dOh2buajWDqg3ppPf+UBvi31sW9iJzGx
         MHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684940045; x=1687532045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuxm9M1T3VcSvc5bTzwUGDZCKtGjaiDhJDWNan/MCa8=;
        b=GSHKsL/QHwvJasW7fVaWRMO05Gy/slUf5sucw72/STgMZzEvVTF44JL7okTgIPZG/R
         rTKtA1smvDfMGuqa/CEGx8+2cDaqdCGpux5zaSKmUDjJ+CLipN9dl018EqIrtL1IlOYC
         Uh95EEsvjsGQ6ZyIP74cmd7dvAiFM9npSps284ffxnh//tCIqdtnh8HQg+2XmzKffmWB
         sVt3gEv2gZlq1yOiUgTGdfZmDXUoFzR+i1RsNLMPV7QrFaQVAAiudDWi0glbDBYh07/c
         D7HynUvk1znqf956eG+WkgJSSIU6JzAFuUITtAPRorYhXR6W9OI2xj6ajomnWPEQJDj4
         JD7g==
X-Gm-Message-State: AC+VfDxenUM1JNEQhPSxgwV69dbDs8E5kREJmEWJJb/Bbjrk45vwxmu/
	OqfR9Sg4V8wvNoAJvTD2ZxJwiw==
X-Google-Smtp-Source: ACHHUZ51qbwXblR3G0pv9Jz0roNc8j1oL351D2D/C8WQgTfKRJyqNp2N2Tg6lfArSVtLtCqSTOb3uw==
X-Received: by 2002:a17:902:d345:b0:1a2:6257:36b9 with SMTP id l5-20020a170902d34500b001a2625736b9mr18031174plk.31.1684940045181;
        Wed, 24 May 2023 07:54:05 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y18-20020a170902b49200b001aaef9d0102sm8812715plr.197.2023.05.24.07.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:54:05 -0700 (PDT)
Date: Wed, 24 May 2023 07:54:02 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li
 <longli@microsoft.com>, Michael Kelley <mikelley@microsoft.com>, "David S.
 Miller" <davem@davemloft.net>, Steen Hegelund
 <steen.hegelund@microchip.com>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <20230524075402.3a0e36bc@hermes.local>
In-Reply-To: <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
References: <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 24 May 2023 02:57:10 -0700
Shradha Gupta <shradhagupta@linux.microsoft.com> wrote:

> @@ -1034,7 +1035,9 @@ struct net_device_context {
>  
>  	u32 tx_table[VRSS_SEND_TAB_SIZE];
>  
> -	u16 rx_table[ITAB_NUM];
> +	u16 *rx_table;
> +
> +	int rx_table_sz;
Size should never be negative, use u32 or u16 here?

