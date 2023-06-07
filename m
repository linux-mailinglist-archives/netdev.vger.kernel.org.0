Return-Path: <netdev+bounces-8760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E42972592B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 346DE281221
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DA58F49;
	Wed,  7 Jun 2023 09:02:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF956AB9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:02:10 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805782688
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686128511; x=1717664511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SEWl3JxeEFCwELHcRYCNeieOLfdoHetTojgx5uBYZXg=;
  b=xDhgzzI+AbYNjR3l8Vo8cKpS9v5IzT7McRe9vdna1eqzhs3rtFUqamIO
   Y937rLOzd/Uv4ZnYXcjkoMqs8J2nwiorSKl8QtJSrWXBrijzZdTJLPmAr
   g+4uTeHDirFWHyygce0VkC1uBVYfYYQO/fjiG1+HTheXutWHM1+llIxy6
   1MJVW4SWIfowKEpvUWA4+PI7/KCwQUplmGpHRmmh0DLXgwlPUKevaOdYZ
   rAIlWmztMnOj/i6hFwecUlvgpeiD+Fsvxzt+F8v4TYu/iIi2PwnEZNiD7
   LyfHF60b2ocvfPe/B+7OFIkA0TknLb+X7KcLhA9fNmh1NMfxCo1ka/IOS
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="215001366"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 02:01:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 02:01:08 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 02:01:06 -0700
Date: Wed, 7 Jun 2023 09:01:05 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 09/10] ice: enforce no DCB config changing when in
 bond
Message-ID: <20230607090105.gje6m2bekytaeeav@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-10-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-10-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> To support SRIOV LAG, the driver cannot allow changes to an interface's DCB
> configuration when in a bond.  This would break the ability to modify
> interfaces Tx scheduling for fail-over interfaces.
> 
> Block kernel generated DCB config events when in a bond.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

