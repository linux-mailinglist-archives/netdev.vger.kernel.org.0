Return-Path: <netdev+bounces-9501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4C0729746
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CC43281871
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97986BA2D;
	Fri,  9 Jun 2023 10:45:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B83D79FB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:45:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E18448D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686307514; x=1717843514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c814UuxtwJhYnMbTZs0+0xa7I8Uix8yXpZ8014/KywA=;
  b=2s86fKQUpulcqeWVZgzuYa1UsnN/klJpVZjlRiAjfZ6ZrrgpbTyEhKOT
   9wEBkNaCF1Rwezc0gOfbpOYAx0GDw5v2fyCTjmAYB2b9xyNAJbUM/VbLl
   qOQXqRNP51ljMqVH3AHMTA+3rutqo4iFgLk/UCHRbUPdrpKih1Vto4ovg
   R82Pp4RG0j0AT9Uxa+vBLV0RSf7tgEpmDVUKTHSJo9Sddh1dj7hcTXZ8V
   xeIUQ41Irb5rteBNbMoHUE7laq4LRU+DXjXhF8MVniCyQnvr3767mWE/k
   ruvW547Zu4Gy/qOxuF3Dhwo6LZUr0mwcq2Jp5sY347QfJn8AnhBFu2524
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="217652859"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jun 2023 03:45:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 9 Jun 2023 03:45:13 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 9 Jun 2023 03:45:12 -0700
Date: Fri, 9 Jun 2023 10:45:12 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>, Jacob Keller
	<jacob.e.keller@intel.com>
Subject: Re: [PATCH iwl-next v3 01/10] ice: Correctly initialize queue
 context values
Message-ID: <20230609104512.syus4hoqq6bsdrjc@DEN-LT-70577>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-2-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608180618.574171-2-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> The ice_alloc_lan_q_ctx function allocates the queue context array for a
> given traffic class. This function uses devm_kcalloc which will
> zero-allocate the structure. Thus, prior to any queue being setup by
> ice_ena_vsi_txq, the q_ctx structure will have a q_handle of 0 and a q_teid
> of 0. These are potentially valid values.
> 
> Modify the ice_alloc_lan_q_ctx function to initialize every member of the
> q_ctx array to have invalid values. Modify ice_dis_vsi_txq to ensure that
> it assigns q_teid to an invalid value when it assigns q_handle to the
> invalid value as well.
> 
> This will allow other code to check whether the queue context is currently
> valid before operating on it.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


