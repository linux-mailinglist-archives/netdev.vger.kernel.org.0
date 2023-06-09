Return-Path: <netdev+bounces-9498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE4272971F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE55E1C21142
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07C88F59;
	Fri,  9 Jun 2023 10:40:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53511113
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:40:56 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A466B1FCC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686307255; x=1717843255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JqaHtGJhKuFLAH1DYpbSeoCEG/jKnRs6acRP1ONua54=;
  b=j6au2LZQaD+sWCEwQGD5CLYvh+WLGUqdE+K42zn1EK/weDgtfnwc23ku
   oNRTkXzgKn6W8w1/1a8VNAPt7Cq4bA686IdIVnnWYPjU+0dkbqEgYC7gt
   TYcaisK54nPnOb4S1PoD7ILjhasbQjjFy2x4XVd6vOw6acxdMTM+yZDIt
   QW9RwhRM/4LqyyyGSttK9Hj0xSF2OSmJaIcE9Ol+PkGYhLPU8/ZiJ77WH
   cMi8rOaKXch5COK+vcvnMy37TgC3GP0w1jOkAmb/Tqol0VH6mtrms/M+6
   o4QxxlkMyFYNwc4iNQp1XTzR7AFVXL7e8OA0hLyGP3QshHm6Xdo3PmNXp
   g==;
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="217042063"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jun 2023 03:40:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 9 Jun 2023 03:40:54 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 9 Jun 2023 03:40:53 -0700
Date: Fri, 9 Jun 2023 10:40:53 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Message-ID: <20230609104053.rxedc4grgm6sxecd@DEN-LT-70577>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-7-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608180618.574171-7-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Add in the functions that will allow a VF created on the primary interface
> of a bond to "fail-over" to another PF interface in the bond and continue
> to Tx and Rx.
> 
> Add in an ordered take-down path for the bonded interface.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

If you need to respin anyway: s/aggreagte/aggregate/, s/pinter/pointer/
Otherwise dont bother.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


