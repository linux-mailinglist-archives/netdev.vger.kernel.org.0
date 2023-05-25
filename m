Return-Path: <netdev+bounces-5412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C3C71133E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A5F32815E7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F8120985;
	Thu, 25 May 2023 18:11:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF7A1F95C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:06 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C8B6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038260; x=1716574260;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=cByck31W3YaXvHnlpZ2zJ0Eljrt+n0ZikTpZykjq5tY=;
  b=TKKqHmGIEAgNuUP7/0zcMd4puR6jKP8CjFJj+xLOColI+wiP0m4bmxtb
   X1d4mfGj5YQDKKVoqlpeK9vUpr7rye1ENL8Uc6k0RDBEArZVt/MfiBIK8
   TrLvS9PTBAM/vtO1/S6Wb8eeWgg5Qrjexq+xUWzL5mqz4K4MGdzggDVdL
   ZCGZCVznICaLUQzHobiWgXuwo672mInhSGUVmlJBhxqifjiH+HwmTRGoP
   xNlMC5QgkGf60Vw7nCJDT7TUyIxsXSZB+dlTPyK0Z01pEgf3C1flGyBcO
   uExxoIUe4DGsowXOZmrqUdVXov2YcS4gonhAY+rFhLpr0yt/rX0DVlfTA
   A==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="214918630"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:10:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:10:59 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:10:58 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next v2 0/8] Introduce new dcb-rewr subcommand
Date: Thu, 25 May 2023 20:10:20 +0200
Message-ID: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIykb2QC/2WNwQ6CMBBEf4Xs2ZrSCqgn/8NwaMti90BLtogYw
 r9buHqcmTd5KyRkwgT3YgXGmRLFkIM6FeC8CS8U1OUMSiotq1KKzlnB+GFR6YttjK11gxYybk1
 CYdkE5/fDYCjs9cjY03IYnkAjx/eESgRcJmjz7ClNkb+Hfy4P6F81l0KKqzadK/ub1lX9GMhxd
 J7Gs4sDtNu2/QBdVc1IygAAAA==
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
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

Patch #1 Adds a new field 'attr' to the dcb_app_table struct, which is
         used to distinguish app and rewrite tables.

Patch #2 Modifies existing dcb-app print functions for reuse by
         dcb-rewr.

Patch #3 Modifies existing dcb-app function dcb_app_table_remove_replaced 
         for reuse by dcb-rewr

Patch #4 Modifies existing dcb-app function dcb_app_parse_mapping_cb for
         reuse by dcb-rewr.

Patch #5 Adds the new dcb-rewr subcommand with initial support for
         prio-pcp and prio-dscp rewrite.

Patch #6 Adds the dcb-rewr.8 manpage
Patch #7 Adds references to dcb-apptrust and dcb-rewr in the dcb.8
         manpage.

Patch #8 Cleans up the dcb-app.8 manpage.

[1] https://elixir.bootlin.com/linux/v6.4-rc1/source/net/dcb/dcbnl.c#L181
[2] https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c#L380

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
Changes in v2:
- Got rid of patch #1 that introduced dcb_app.h - expose in individual patches. 
- Changed to callbacks for printing APP and rewrite entries. Also fixed %d to be %u.
- Changed to callbacks for removing replaced table entries for APP and rewrite.
- Changed to callbacks for pushing APP and rewrite entries to the table.
- Got rid of extra spaces in dcb-rewr helps, and reordered some parameters for dcb_parse_mapping.
- Rephrased 'that that' sentence in dcb-app.8 and dcb-rewr.8
- Link to v1: https://lore.kernel.org/r/20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com

---
Daniel Machon (8):
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
 dcb/dcb.h           |  58 +++++++++
 dcb/dcb_app.c       | 167 +++++++++++++-----------
 dcb/dcb_rewr.c      | 355 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8  |  10 +-
 man/man8/dcb-rewr.8 | 206 ++++++++++++++++++++++++++++++
 man/man8/dcb.8      |   4 +-
 8 files changed, 727 insertions(+), 80 deletions(-)
---
base-commit: 9c7bdc9f3328fb3fd5e7b77eb7b86f6c62538143
change-id: 20230510-dcb-rewr-534b7ab637eb

Best regards,
-- 
Daniel Machon <daniel.machon@microchip.com>


