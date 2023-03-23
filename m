Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125446C70C6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjCWTJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjCWTJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:09:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E778D12CCF
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 12:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679598548; x=1711134548;
  h=from:to:cc:subject:date:message-id;
  bh=zxTTfTI4qg6ZVwwLZgnncDX/a+8Pj547zJ83B28w+0c=;
  b=nNuG84uZoc73dgxiCDZLZCQdcwvnk1P55kxJmxRdYPhEjuknbjF5Vv4j
   quphShUOTOgaYU0jUlGrGBujs4hFJZIwS97kTCwM2iAaAUhJPbhnPfyqc
   Ig/C7CYY4M/wIAQQg+VqorfGcvM03GtduSVtwjdE2S1dp38cmXGYyrTAY
   id/VLfq/wB4S9itlSpw0cwg/Koqq7cJLyiU6B5qthqQQCpR+a2FHBcgmF
   ghSX4xp38Ut2JV05Bea4sSH4vUwqoabqXoiJWuxf6qXpF/j+95IisK4Zt
   ESF+z2eZERwuUBoEeQlSGUfmyKn+BgKaxe/p1kmsjJafZfeXG6CwkFNzb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="402177116"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="402177116"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 12:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="632558034"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="632558034"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2023 12:08:25 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net-next v3] tools: ynl: add the Python requirements.txt file
Date:   Thu, 23 Mar 2023 20:08:02 +0100
Message-Id: <20230323190802.32206-1-michal.michalik@intel.com>
X-Mailer: git-send-email 2.9.5
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a good practice to state explicitly which are the required Python
packages needed in a particular project to run it. The most commonly
used way is to store them in the `requirements.txt` file*.

*URL: https://pip.pypa.io/en/stable/reference/requirements-file-format/

Currently user needs to figure out himself that Python needs `PyYAML`
and `jsonschema` (and theirs requirements) packages to use the tool.
Add the `requirements.txt` for user convenience.

How to use it:
1) (optional) Create and activate empty virtual environment:
  python3.X -m venv venv3X
  source ./venv3X/bin/activate
2) Install all the required packages:
  pip install -r requirements.txt
    or
  python -m pip install -r requirements.txt
3) Run the script!

The `requirements.txt` file was tested for:
* Python 3.6
* Python 3.8
* Python 3.10

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
---
v3:
- let pip figure out dependencies on it's own (remove explicit deps)
- use semver to loosen the version requirements (ex. use `==4.*` to match
  any version with the 4.x.y API compatibility, so `<5.0.0`)
- change target tree `net` -> `net-next`
v2:
- add `Fixes:` tag
- fix spelling in commit message
---
 tools/net/ynl/requirements.txt | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/net/ynl/requirements.txt

diff --git a/tools/net/ynl/requirements.txt b/tools/net/ynl/requirements.txt
new file mode 100644
index 0000000..0db6ad0
--- /dev/null
+++ b/tools/net/ynl/requirements.txt
@@ -0,0 +1,2 @@
+jsonschema==4.*
+PyYAML==6.*
-- 
2.9.5

base-commit: fcb3a4653bc5fb0525d957db0cc8b413252029f8
