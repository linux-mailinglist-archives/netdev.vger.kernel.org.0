Return-Path: <netdev+bounces-4395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B19070C56A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 462A62810D6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AEB14ABA;
	Mon, 22 May 2023 18:41:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F013AE5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:33 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA78C4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780888; x=1716316888;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=k4gd/E8pszlGgvqWTI2++7nwlDWh91eHybv8asyoTfI=;
  b=ZDzehHOogQQNwY8r1mjm3dNdWuNQbK0bL0BEPFOqtXtHtCu3ilAb4GJP
   z06ek98Mx6wadLy2azph2+izRGvqrqebVP+A/JMpKxN7NDGY5getVahg0
   mtfE4VHSKsNjRws0Narr+gOZGFtKlLKOZ8eeI58OAhX0P4F8VUJ2i5DAf
   UqYTXPhl221/Bmrfh5a2hAFy9fuGkHcBMB5wq1GRYMk51tIiO1DnE/u3X
   T6URqQYOdY2YqigEZdWwivuy7pj1BHeim9KqzE0eJC8prXwLcV2zXJDVK
   yBuhJMDGJeUXY/w3Qj8H8WsO78Olo8X3EfcHLvWw0T4YyQVGSqCbYVRs1
   g==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214969705"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:25 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:24 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next 0/9] Introduce new dcb-rewr subcommand
Date: Mon, 22 May 2023 20:41:03 +0200
Message-ID: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD+3a2QC/x2NQQ6CQAxFr0K6tskwI5J4FeOiHap0YSEdVBLC3
 R1cvp/38zYo4ioFrs0GLh8tOlmF9tRAHsmegjpUhhhiCl0bcMiMLl/HLp25J76kXhiqzlQE2cn
 yeBxepHbMs8tD13/hBjr79F4kosm6wH3ff3ksj6KAAAAA
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

========================================================================               
Introduction:
========================================================================

This series introduces a new DCB subcommand: rewr, which is used to
configure the in-kernel DCB rewrite table [1].

Rewrite support is added as a separate DCB subcommand, rather than an
APP opt-in flag or similar. This goes in line with what we did to dcbnl,
where rewrite is a separate object.  Obviously this requires a bit more
code to implement the new command, but much of the existing dcb-app code
(especially the bookkeeping code) can be reused. In some cases a little
adaptation is needed.

========================================================================
dcb-rewr parameters:
========================================================================

Initially, I have only made support for the prio-pcp and prio-dscp
parameters, as DSCP and PCP  are the only selectors that currently have
a user [2] and to be honest, I am not even sure it makes sense to add
dgram, stream, ethtype rewrite support - At least the rewriter of Sparx5
does not support this. Any input here is much appreciated!

Examples:

Rewrite DSCP to 63 for packets with priority 1
$ dcb rewr add dev eth0 prio-dscp 1:63

Rewrite PCP 7 and DEI to 1 for packets with priority 1
$ dcb rewr add dev eth0 prio-pcp 1:7de

A new manpage has been added, to cover the new dcb-rewr subcommand, and
its parameters. Also I took the liberty to clean up a few things in the
dcb-app manpage.

========================================================================               
Patch overview:
========================================================================

Patch #1 Exposes dcb-app and dcb-rewr shared functions in a new header
         file dcb_app.h.

Patch #2 Adds a new field 'attr' to the dcb_app_table struct, which is
         used to distinguish app and rewrite tables.

Patch #3 Modifies existing dcb-app print functions for reuse by
         dcb-rewr.

Patch #4 Modifies existing dcb-app function dcb_app_table_remove_replaced 
         for reuse by dcb-rewr

Patch #5 Modifies existing dcb-app function dcb_app_parse_mapping_cb for
         reuse by dcb-rewr.

Patch #6 Adds the new dcb-rewr subcommand with initial support for
         prio-pcp and prio-dscp rewrite.

Patch #7 Adds the dcb-rewr.8 manpage
Patch #8 Adds references to dcb-apptrust and dcb-rewr in the dcb.8
         manpage.

Patch #9 Cleans up the dcb-app.8 manpage.

[1] https://elixir.bootlin.com/linux/v6.4-rc1/source/net/dcb/dcbnl.c#L181
[2] https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c#L380

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
Daniel Machon (9):
      dcb: app: expose dcb-app functions in new header
      dcb: app: add new dcbnl attribute field
      dcb: app: modify dcb-app print functions for dcb-rewr reuse
      dcb: app: modify dcb_app_table_remove_replaced() for dcb-rewr reuse
      dcb: app: modify dcb_app_parse_mapping_cb for dcb-rewr reuse
      dcb: rewr: add new dcb-rewr subcommand
      man: dcb-rewr: add new manpage for dcb-rewr
      man: dcb: add additional references under 'SEE ALSO'
      man: dcb-app: clean up a few mistakes

 dcb/Makefile        |   3 +-
 dcb/dcb.c           |   4 +-
 dcb/dcb.h           |  10 +-
 dcb/dcb_app.c       | 165 +++++++++++++-------------
 dcb/dcb_app.h       |  61 ++++++++++
 dcb/dcb_rewr.c      | 332 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8  |  10 +-
 man/man8/dcb-rewr.8 | 206 ++++++++++++++++++++++++++++++++
 man/man8/dcb.8      |   4 +-
 9 files changed, 702 insertions(+), 93 deletions(-)
---
base-commit: 9c7bdc9f3328fb3fd5e7b77eb7b86f6c62538143
change-id: 20230510-dcb-rewr-534b7ab637eb

Best regards,
-- 
Daniel Machon <daniel.machon@microchip.com>


