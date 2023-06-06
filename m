Return-Path: <netdev+bounces-8426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C02CA724027
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF77B281560
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FE914264;
	Tue,  6 Jun 2023 10:54:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29706468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:54:22 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BE6E5E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686048860; x=1717584860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2mgkjY4JRZMn/4ypVV5YelTdREnMl+I1l887OEPTrBQ=;
  b=EMYrASxOicmg9Iw2uCaOz8Icmt22qNeMcwJdSU4AcpmuO4DhldE+L9tJ
   HGJkr5glkI0FyTMjDdrLjCotHjRR9cCSMcinlDVRwpxWvUtxQLfZ1i3rG
   dLgGxxuxlcWr4pk7SeW5dKwzm8F/ms58LEkfWXVxfzeA1CYbvSsr75TRd
   d3mZHnYPUvp4r6hRovpJcwdj9UfJEt8+4qAzEmLVAADwDcylnpI7KJ7S7
   WXXafl0scGoN5CR7r30isOIzK7V2XLsCOgL9nM++MCiY+trr6UJnNqiGd
   yXkBmSwtB6N1hIIiSQy5FfaObIBX/j/YAbr6k4VigRpb/oFC1eH9uwgT1
   g==;
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="228631386"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 03:54:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 03:54:19 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 03:54:18 -0700
Date: Tue, 6 Jun 2023 10:54:18 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 05/10] ice: process events created by lag netdev
 event handler
Message-ID: <20230606105418.m2sqt4gol6sg77oj@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-6-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-6-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +/**
> + * ice_lag_add_prune_list - Add 's event_pf's VSI to primary's prune list

Adds?

Other than that:

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

> + * @lag: lag info struct
> + * @event_pf: PF struct for VSI we are adding to primary's prune list
> + */
> +static void ice_lag_add_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
> +{
> +} 

