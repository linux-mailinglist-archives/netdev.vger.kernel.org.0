Return-Path: <netdev+bounces-165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9CA6F5938
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2862F1C20F0D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1667D532;
	Wed,  3 May 2023 13:44:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F04A11
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:44:18 +0000 (UTC)
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7491A5;
	Wed,  3 May 2023 06:44:17 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38e12d973bfso2781147b6e.0;
        Wed, 03 May 2023 06:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683121456; x=1685713456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjViOKUqR5+zd+e+boxAGQ/v0HwnUIz4DBo4X82113w=;
        b=HR7zgFMFTTNnVpWPqdJybt7c9zzQUToaSdsco4xAcpGkIeA7qI/Jts41BLLiUZyGre
         XaclE5AJ41XlU8oI1vZ1tfRVpJqtRKszoIJ/fdqmhrhOQVAsZMYnyr9402a7E/3L0zoi
         kZqnJ7eO/hwA/2vmPtO9Xzhkd438Gnk2aWsOjrE2Iil42czqQOHGjj0XoToMd144+M2m
         9hDV8RLbgy9ZsAjgtoo31JUeOqECtG3C3pC5TwEjL8x6KcEEsGhGizZOIG9lGTEFWQxG
         pTILjW0V109gJXcaUsccEP52B/VbdayCPx/4S0b78Js91sYBgSjFDGnhYJcBezcydbMY
         RLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683121456; x=1685713456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjViOKUqR5+zd+e+boxAGQ/v0HwnUIz4DBo4X82113w=;
        b=M5VM5DMQuUWqj4T9qHRoOVZ7XaeqC8IdqWm7gpLqMbkC7Zn+iPAIR5aAEQkS2OnbeE
         O3AUPo9YLrpFiyHRbCspM+//KS2N5VAgUx2CfdikLj6uSqRuogihyMzmCEtznFCrwFKA
         0wjfbPvjykM//VXX3S+kyp2XVszF7kRSj8+SAC/4i02cb/0FCnVHJXvfJsup2qFRkLwJ
         Gbn0BTBzx0w18bOXviKJ/GW9136Ts6Nkl+KTe1frPZ5UDu1Ttdsucp+xLaTpK6RN3bHZ
         bUu61M9g03IeRSSpm+jwvSJsoye46W0A6M+5ZhH+1/0zP++AJOr9DvzO73VlEUcT/Tsc
         s2aw==
X-Gm-Message-State: AC+VfDxVlfkE4XRRlAJ6mkkHpOzWa8wsH2IvR6wO9gGRZWDnt77xQ9VD
	gbRap1zG4ArzjkDT+7VaUhc=
X-Google-Smtp-Source: ACHHUZ6aIab0/wls6IKL28j7/hMjuI302RELiMLfNoSp86ZYdie6RfJzVs/EUTT7uwvGN5Wi1qSCCw==
X-Received: by 2002:a05:6808:3290:b0:38c:c177:a6bb with SMTP id cg16-20020a056808329000b0038cc177a6bbmr54145oib.23.1683121456428;
        Wed, 03 May 2023 06:44:16 -0700 (PDT)
Received: from t14s.localdomain ([177.92.48.92])
        by smtp.gmail.com with ESMTPSA id ca16-20020a056808331000b003924c15cf58sm592578oib.20.2023.05.03.06.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 06:44:16 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
	id 54CAD59F01D; Wed,  3 May 2023 10:44:13 -0300 (-03)
Date: Wed, 3 May 2023 10:44:13 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc: Simon Horman <simon.horman@corigine.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH net v4] sctp: fix a potential OOB access in
 sctp_sched_set_sched()
Message-ID: <ZFJlLaj6Qqa7Pc28@t14s.localdomain>
References: <ZFJX3KLkcu4nON7l@t14s.localdomain>
 <20230503133752.4176720-1-Ilia.Gavrilov@infotecs.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503133752.4176720-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 01:37:59PM +0000, Gavrilov Ilia wrote:
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to OOB access.
> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thx!

