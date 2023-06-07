Return-Path: <netdev+bounces-8753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AC572586A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0482128128A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6E18BE7;
	Wed,  7 Jun 2023 08:48:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844006FB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:48:19 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9359F1712
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686127697; x=1717663697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fLHBK9PmihZK5WV+yHKsWwDeQtTTMPDtL/lE06zSvGQ=;
  b=aPpWTxFIozCra2dYLdf9ZdIH+l376aQrE37lm/I+ZaXcqfpCLSbuUW1j
   ArRKUAKDpTCnEFE5ahAavpRexCs7ZfljrabXH+TAsccpmqdEatHhTLNAK
   XDU6T/aTHWsO8BTGWdiaOnv/1bUFprX+2r15Vyh7d2ELA9JVLixI/lNmT
   uEsYvzMDe4M52PJSdSQL0HLHQmpjVk3IZj1S3UANkpIeeU/qOaKSaCDj7
   P9PrQL2ZcGcxf411kZ9bPIbHe4HvAaqDXsChpzM+bqy0Jl7NPpHq54A3/
   5Tso9n+MfWrZsivFwbhaT4D9HJ8gtl34nl/yvvMaen5TtaKxIlqXnrjfi
   g==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="155909736"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 01:48:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 01:48:15 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 01:48:14 -0700
Date: Wed, 7 Jun 2023 08:48:13 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 07/10] ice: support non-standard teardown of bond
 interface
Message-ID: <20230607084813.qc3mtpxlavputju7@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-8-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-8-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Code for supporting removal of the PF driver (NETDEV_UNREGISTER) events for
> both when the bond has the primary interface as active and when failed over
> to thew secondary interface.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


