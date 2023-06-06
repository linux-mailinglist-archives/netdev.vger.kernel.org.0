Return-Path: <netdev+bounces-8300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 816107238CC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 988221C20E57
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CBE6119;
	Tue,  6 Jun 2023 07:20:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C583FFF
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:27 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0EC10C3
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036007; x=1717572007;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=7CGM+YlefiDiU7wDx+zR7zWdKjiwdRj3CjNeznWW+tw=;
  b=ApjCqYbAGEMKMscoyYgflGnGSoC0gMSCvbU+D5IjaYXDold9HUSacixM
   317LE/GSQ2I3UUbe0jNSIg6gB6TdRN5zy0Y1beZZ5iYx9PiJCcu/3FJSL
   BVqseArtPmPpUVp4cj0u6DgynRnYeDNNIjrYGH8KPoPWb3dohVXoQjr5K
   H5C8XIoZUu8DeqPPhf6XnkGp9+tx3RoXZPSLmu1/uDuV0UK0OfEdw9y0B
   DioxhiPGfHqB81LKnT7BuQYQgdvOO89M8qkToQOA1PMjCycvq0G+C2VWc
   ZdsqPirRbe4k5rBtC3SDMf3jqiFOseDwBS6/CkVf1zr59v571zmInUdGU
   w==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="216378673"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:06 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:05 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next v3 00/12] Introduce new dcb-rewr subcommand
Date: Tue, 6 Jun 2023 09:19:35 +0200
Message-ID: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAfefmQC/3WNyw6CMBBFf4V0bU0f8tCV/2FctGWws6AlU0QM4
 d8tLDUu75175iwsASEkdikWRjBhwhhy0IeCOW/CAzi2OTMllBalFLx1lhO8iJf6ZGtjK12DZXl
 uTQJuyQTnN6A3GLZ6IOhw3g03hgPF5wiKB5hHds9nj2mM9N79k9xHv6pJcsEbbVonu7PWZXXt0
 VF0Hoeji/3+aFL/YJXhc6cbqJpGyhq+4XVdP7JLiKsHAQAA
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>, Petr Machata
	<me@pmachata.org>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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

Patch  #1 Adds a new field 'attr' to the dcb_app_table struct, which is
          used to distinguish app and rewrite tables.

Patch  #2 Replaces uses of %d with %u for unsigned int.

Patch  #3 Moves colon out of callback functions.

Patch  #4 Renames protocl print functions from _key to _pid

Patch  #5 Modifies the _print_filtered() function for dcb-rewr reuse, by
          introducing new callbacks.

Patch  #6 Modifies existing dcb-app function dcb_app_table_remove_replaced 
          for reuse by dcb-rewr

Patch  #7 Expose dcb-app functions required by dcb-rewr.

Patch  #8 Adds the new dcb-rewr subcommand with initial support for
          prio-pcp and prio-dscp rewrite.

Patch  #9 Introduces symbol for max DSCP value and updates accordingly.

Patch #10 Adds the dcb-rewr.8 manpage
Patch #11 Adds references to dcb-apptrust and dcb-rewr in the dcb.8
          manpage.

Patch #12 Cleans up the dcb-app.8 manpage.

[1] https://elixir.bootlin.com/linux/v6.4-rc1/source/net/dcb/dcbnl.c#L181
[2] https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c#L380

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
Changes in v3:
- Split #2 into four patches (%d->%u, :, renaming, prototype change).
- Moved publication of functions in #3 to patches where they are used.
- Added new patch #7 that exposes dcb-app functions required by dcb-rewr.
- Got rid of #4 and copied over dcb_app_parse_mapping_cb to dcb-rewr instead.
- Added new patch #9 for DCB_APP_MAX_DSCP
- Link to v2: https://lore.kernel.org/r/20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com

Changes in v2:
- Got rid of patch #1 that introduced dcb_app.h - expose in individual patches. 
- Changed to callbacks for printing APP and rewrite entries. Also fixed %d to be %u.
- Changed to callbacks for removing replaced table entries for APP and rewrite.
- Changed to callbacks for pushing APP and rewrite entries to the table.
- Got rid of extra spaces in dcb-rewr helps, and reordered some parameters for dcb_parse_mapping.
- Rephrased 'that that' sentence in dcb-app.8 and dcb-rewr.8
- Link to v1: https://lore.kernel.org/r/20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com

---
Daniel Machon (12):
      dcb: app: add new dcbnl attribute field
      dcb: app: replace occurrences of %d with %u for printing unsigned int
      dcb: app: move colon printing out of callbacks
      dcb: app: rename dcb_app_print_key_*() functions
      dcb: app: modify dcb_app_print_filtered() for dcb-rewr reuse
      dcb: app: modify dcb_app_table_remove_replaced() for dcb-rewr reuse
      dcb: app: expose functions required by dcb-rewr
      dcb: rewr: add new dcb-rewr subcommand
      dcb: rewr: add symbol for max DSCP value
      man: dcb-rewr: add new manpage for dcb-rewr
      man: dcb: add additional references under 'SEE ALSO'
      man: dcb-app: clean up a few mistakes

 dcb/Makefile        |   3 +-
 dcb/dcb.c           |   4 +-
 dcb/dcb.h           |  54 ++++++++
 dcb/dcb_app.c       | 154 +++++++++++-----------
 dcb/dcb_rewr.c      | 363 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8  |  10 +-
 man/man8/dcb-rewr.8 | 206 +++++++++++++++++++++++++++++
 man/man8/dcb.8      |   4 +-
 8 files changed, 718 insertions(+), 80 deletions(-)
---
base-commit: e0c7a04f1dfd7ca05e0725663489c6406d169b9c
change-id: 20230510-dcb-rewr-534b7ab637eb

Best regards,
-- 
Daniel Machon <daniel.machon@microchip.com>


