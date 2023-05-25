Return-Path: <netdev+bounces-5244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDBB710621
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE532814A2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738C4BA2F;
	Thu, 25 May 2023 07:20:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609411FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:20:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94999C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684999218; x=1716535218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y44wrsoclZnjzQBsy7pj7qFBkQDy0CbnXmzxIMQVF2I=;
  b=O18pCLxpFgQVDsjrsvX7Ma5Nlcx8PGXziNQUZV86jm9eMgzBoOZxysiR
   OVzlGaFd+kJqsqfwT4Xoys3OJO/0lat68WNM1kI8j93tcWjqztx8Dh9kq
   cbWFzuClndZFVGXDy9wn58o98tBYQ25QKZqeShlW7DRk1q6phvzEBEb9m
   0VngEWwkBqbOoXxYTKirAktx9Q9i64tNLoqRqNylOpy4UpIstFMkLWIl+
   6ZqY2DgI61A9S2Io1v/x0FkxJLvmu3ja3vmNV9QdCfvggBkRwnh8ln7mB
   OFIckc6Pj/Ym3a59rRIFwxCy9/evjy/fgEtDzZx6zmei5PeKZT9WPzBD8
   w==;
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="217202886"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 00:20:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 00:20:17 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 00:20:16 -0700
Date: Thu, 25 May 2023 07:20:16 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Stephen Hemminger <stephen@networkplumber.org>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Message-ID: <ZG8MMOrqY27xr7wV@DEN-LT-70577>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
 <20230522143341.71a53a58@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230522143341.71a53a58@hermes.local>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 > On Mon, 22 May 2023 20:41:06 +0200
> Daniel Machon <daniel.machon@microchip.com> wrote:
> 
> > +int dcb_app_print_pid_dec(__u16 protocol)
> >  {
> > -     return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> > +     return print_uint(PRINT_ANY, NULL, "%d", protocol);
> >  }
> 
> Should be %u for unsigned value.

Thanks Stephen,
Will make sure to change that in v2.

/Daniel


