Return-Path: <netdev+bounces-10553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F0272EFE6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF102812C8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A73537335;
	Tue, 13 Jun 2023 23:19:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3A11ED52
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:19:26 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959C19A5;
	Tue, 13 Jun 2023 16:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698364; x=1718234364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4YUc8eMzQy16ISjWd8qD4X/ti5WdyqeoNpQ/wqfutZE=;
  b=L/fZXcD1yg7S3FINJgyb/X14YTm9EQtvTYEDwXN2dk8eHa+yhE8FwIR/
   UIXzxtXK/UJ8QOgJVP/7yu1auWCFjaLPflQUqKGz1F/YBQA9CnQN0Sr5Y
   dLJvuDGwspA8h1stIomGmvKvdK5gifLId7t+ILXFZujAxCyyIZDt2Y+eS
   yBhLapflFjP+sOqJY1CmLw0Vc4kKGenQcWhaQw1eTxBTIVy+K3nFl6p4c
   poB+VATu7Gd29My2/Pp3eDqyLWto0fXjIQjqAyc9YD1WaFH6SxfySUXsx
   xfjLXHyAGTnDBTqznWnPx5OSYDSfuYn69uvhIDuuz9qivKpTUD0hU8hOK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357352750"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="357352750"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:19:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="777011273"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="777011273"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jun 2023 16:19:22 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	chuck.lever@oracle.com
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Subject: [PATCH net-next] tools: ynl-gen: generate docs for <name>_max/_mask enums
Date: Wed, 14 Jun 2023 01:17:09 +0200
Message-Id: <20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Including ynl generated uapi header files into source kerneldocs
(rst files in Documentation/) produces warnings during documentation
builds (i.e. make htmldocs)

Prevent warnings by generating also description for enums where rander_max
was selected.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 include/uapi/linux/netdev.h       |  1 +
 tools/include/uapi/linux/netdev.h |  1 +
 tools/net/ynl/ynl-gen-c.py        | 11 ++++++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..d78f7ae95092 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -24,6 +24,7 @@
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
  *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_MASK: valid values mask
  */
 enum netdev_xdp_act {
 	NETDEV_XDP_ACT_BASIC = 1,
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 639524b59930..d78f7ae95092 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -24,6 +24,7 @@
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
  *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_MASK: valid values mask
  */
 enum netdev_xdp_act {
 	NETDEV_XDP_ACT_BASIC = 1,
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 0b5e0802a9a7..0d396bf98c27 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2011,6 +2011,7 @@ def render_uapi(family, cw):
         # Write kdoc for enum and flags (one day maybe also structs)
         if const['type'] == 'enum' or const['type'] == 'flags':
             enum = family.consts[const['name']]
+            name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
 
             if enum.has_doc():
                 cw.p('/**')
@@ -2022,10 +2023,18 @@ def render_uapi(family, cw):
                     if entry.has_doc():
                         doc = '@' + entry.c_name + ': ' + entry['doc']
                         cw.write_doc_line(doc)
+                if const.get('render-max', False):
+                    if const['type'] == 'flags':
+                        doc = '@' + c_upper(name_pfx + 'mask') + ': valid values mask'
+                        cw.write_doc_line(doc)
+                    else:
+                        doc = '@' + c_upper(name_pfx + 'max') + ': max valid value'
+                        cw.write_doc_line(doc)
+                        doc = '@__' + c_upper(name_pfx + 'max') + ': do not use'
+                        cw.write_doc_line(doc)
                 cw.p(' */')
 
             uapi_enum_start(family, cw, const, 'name')
-            name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
             for entry in enum.entries.values():
                 suffix = ','
                 if entry.value_change:
-- 
2.37.3


