Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA3F29A841
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896080AbgJ0Jvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896042AbgJ0Jvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 05:51:43 -0400
Received: from mail.kernel.org (ip5f5ad5af.dynamic.kabel-deutschland.de [95.90.213.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7F6238E6;
        Tue, 27 Oct 2020 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603792301;
        bh=k2p7k6YrutH2g/MqEvjL1yqH8huj2qjYzbjROOMuBD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA5JisO8GsOPtW3h9IImBLoj7Z5OhDiq3AzadWYu95GsRb7fIQvWdMgABnbXuIz2O
         De6cGCqlsV3BqYw9B519R7CX0fyRHvSoDFR4OcBZ7JYG1UlzpLpaYoMsBlSBp8DbMP
         qoCiBg84n7E8liqnOeIdsswEyY7KYUcX+8QWhamU=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kXLdj-003FF9-FH; Tue, 27 Oct 2020 10:51:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 16/32] ice: docs fix a devlink info that broke a table
Date:   Tue, 27 Oct 2020 10:51:20 +0100
Message-Id: <84ae28bda1987284033966b7b56a4b27ae40713b.1603791716.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603791716.git.mchehab+huawei@kernel.org>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 410d06879c01 ("ice: add the DDP Track ID to devlink info")
added description for a new devlink field, but forgot to add
one of its columns, causing it to break:

	.../Documentation/networking/devlink/ice.rst:15: WARNING: Error parsing content block for the "list-table" directive: uniform two-level bullet list expected, but row 11 does not contain the same number of items as row 1 (3 vs 4).

	.. list-table:: devlink info versions implemented
	    :widths: 5 5 5 90
...
	    * - ``fw.app.bundle_id``
	      - 0xc0000001
	      - Unique identifier for the DDP package loaded in the device. Also
	        referred to as the DDP Track ID. Can be used to uniquely identify
	        the specific DDP package.

Add the type field to the ``fw.app.bundle_id`` row.

Fixes: 410d06879c01 ("ice: add the DDP Track ID to devlink info")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/devlink/ice.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index b165181d5d4d..a432dc419fa4 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -70,6 +70,7 @@ The ``ice`` driver reports the following versions
         that both the name (as reported by ``fw.app.name``) and version are
         required to uniquely identify the package.
     * - ``fw.app.bundle_id``
+      - running
       - 0xc0000001
       - Unique identifier for the DDP package loaded in the device. Also
         referred to as the DDP Track ID. Can be used to uniquely identify
-- 
2.26.2

