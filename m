Return-Path: <netdev+bounces-8907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E69C7263DF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE011C20CA0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8941ACD6;
	Wed,  7 Jun 2023 15:13:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CDB1ACC0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:13:39 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8C419BC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:13:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-652328c18d5so3476998b3a.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 08:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686150817; x=1688742817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2uGRMARKjNW5QR9jkfSRANUJFMEEQqCOCNW3U06d0M=;
        b=ROMI65cx21RocDVrGyn6TmISXBM81Q6AEnR9yc+hoxeeW//A0Bt9hj50OdjaF4+wK4
         e5vjYC9WILB2hPDni6knM+y6rjV3SBWHAcBTOwlYeOmFlM5MMn0ejG7ACN36qXvvGB5S
         KYzA8Dijdn9ya+bLSxxDkCzQ6xFV7sBvbFM6rluC0Pd+QB99ByomwU1GtD5oi+o1gnUY
         hXWgUSXzDtZWSwh59ESOEOpTOMD9rlYz0KrvpOQrDvSLH+MrjeWk8zc3fz5HrGKMTesU
         JK/oCvaFUoDkmGer023zH1e+fCM8XcBkDWwgo8JJx1T2sA60tpRlIfzajaaDATiCAoO0
         qfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686150817; x=1688742817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2uGRMARKjNW5QR9jkfSRANUJFMEEQqCOCNW3U06d0M=;
        b=c6yqy7pyrPUMB0c1vNybXm6nKPKbA65u+VRa2VIHeX96uGIN/pNGb4s2H4U0eKf65r
         lsCnjMowp/BmNRKcjsfTOsY8kQ5irxNsnYz7zKdmG7w6jeOxp0ywHCJZrUgWx4PDAk+6
         uyaJLXHseUv8dGkqzamvuMkYzTRUTGzmpuiVQZ7QluMMTd7RUnXCBzJx2R8UFa929Krw
         Boybw8GiypRdCSmUnTHEdJFwxOdgT/WX1mASUbewKTtZdl1tEt7zfoc1pwJWROC1+2hU
         mYlpJmHVFXKw64h1WN1vrLbY0Dx6rpmvlhGLaOjrsz8cWlmy99y+oyJAQMCZRSdT0ucR
         TCqg==
X-Gm-Message-State: AC+VfDzt0MFv0TzVrmy01OoR+xt48GRc4f1pS/0KjUUKrKpw+pW/ZrM9
	wL3tMJ4JdL4TJ1rH2mytLpE1JQ==
X-Google-Smtp-Source: ACHHUZ77cH1gEATDCXjTbf+7gQlepIWmWPQCwdkQKwvoriCFmxguDjdvA8m8am+MB1jwoLz1A46bEA==
X-Received: by 2002:a05:6a20:258b:b0:10e:e1f9:d197 with SMTP id k11-20020a056a20258b00b0010ee1f9d197mr1375354pzd.38.1686150817353;
        Wed, 07 Jun 2023 08:13:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d2-20020a654242000000b00530621e5ee4sm8482257pgq.9.2023.06.07.08.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:13:37 -0700 (PDT)
Date: Wed, 7 Jun 2023 08:13:35 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] tc/taprio: print the offload xstats
Message-ID: <20230607081335.7b799b9c@hermes.local>
In-Reply-To: <20230607125441.3819767-1-vladimir.oltean@nxp.com>
References: <20230607125441.3819767-1-vladimir.oltean@nxp.com>
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

On Wed,  7 Jun 2023 15:54:41 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> +static int taprio_print_xstats(struct qdisc_util *qu, FILE *f,
> +			       struct rtattr *xstats)
> +{
> +	struct rtattr *st[TCA_TAPRIO_OFFLOAD_STATS_MAX + 1], *nla;
> +
> +	if (!xstats)
> +		return 0;
> +
> +	parse_rtattr_nested(st, TCA_TAPRIO_OFFLOAD_STATS_MAX, xstats);
> +
> +	nla = st[TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS];
> +	if (nla)
> +		print_lluint(PRINT_ANY, "window-drops", " Window drops: %llu",
> +			     rta_getattr_u64(nla));
> +
> +	nla = st[TCA_TAPRIO_OFFLOAD_STATS_TX_OVERRUNS];
> +	if (nla)
> +		print_lluint(PRINT_ANY, "tx-overruns", " Transmit overruns: %llu",
> +			     rta_getattr_u64(nla));
> +

Ok, but the choice of wording here is off. It makes taprio stats different
in style than other qdisc. The convention in other qdisc is not to use upper case,
and use a one word key.

In other words, not "window-drops", " Window drops: %llu" but instead
      "window_drops", " window_drops %llu",

