Return-Path: <netdev+bounces-9491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D5872963F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650921C210DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BE714A96;
	Fri,  9 Jun 2023 10:05:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492ED1427F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:05:22 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2A49CC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686305120; x=1717841120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=208JrvbaaxChpCfucfGSQ5QQQG848qUVAhbDtruTYHc=;
  b=CgLbeIibEzd8Hs3esUzE3J7LPSDHCbNKlFnxFKdcQqSXY155Pd+808IZ
   8vem2Vl2UM8aPs2PRoib5GOWloEYTW+OWJ6JhUieKhTSIFO6MubsftQSL
   5q/lBP7Z59Q4/Z8KEw3VaAC5SqVPtr31T7O7GVOcFKfuZ3VjDh1uDzeaB
   +V87rulVHZMI3ZIPO2NSgJHfdJCeswQEIaoomIAc0ByJmTFQ5TGaNwDat
   SiSttu9QDNg9yNKb5h28kZmACB0oHHiClQrPTQICloKRaN5dmUj2r0kmd
   QOP4PD/dBVxWy9wLi3yjd/4VUub4OZ4CweUeGcgEjxBOAHTaBzkevDlJF
   w==;
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="156246743"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jun 2023 03:05:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 9 Jun 2023 03:05:19 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 9 Jun 2023 03:05:18 -0700
Date: Fri, 9 Jun 2023 10:05:18 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iwl-next v3 03/10] ice: changes to the interface with the
 HW and FW for SRIOV_VF+LAG
Message-ID: <20230609100518.johck646sge472k3@DEN-LT-70577>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-4-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608180618.574171-4-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Add defines needed for interaction with the FW admin queue interface
> in relation to supporting LAG and SRIOV VFs interacting.
> 
> Add code, or make non-static previously static functions, to access
> the new and changed admin queue calls for LAG.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Nice, thanks for including my changes.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


