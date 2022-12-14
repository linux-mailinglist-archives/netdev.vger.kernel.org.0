Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31CE64D452
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiLOAGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiLOAF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:05:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F316A775
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671062296; x=1702598296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9U0lkejOwgiiskF+7B12IRhT7/vXHfFDyb1tg564vqI=;
  b=GiE22uBj5CEsaRcYJxgQ5lO9u1s6YmIUJU77i46eIjYVuNwYYdZ4oLjR
   MdIZbXbG1h5r3AP197zUYVAuetDHID8qZMVE4/Eq4F565xp76t51yMkXu
   5JEHm7t2nbSzrv9NrPZ42V9XF85EMElm+u22DixRJDgYg1KASBK1Ji4Fs
   lUTa9g+lPJrgfXaceWciUien0Jw1gwUBINt/C7aUIQeyKjG3BFZlwzq4w
   FcIG/doH09dDw64bkmjI6RuzLI9opuAeZlAux4Arg/g0jnae6wU4yCK5p
   GKy5WwBAXdjKYSKXOJVX17mXfHfc7RvPAwYMguShRbQPpxazZ1FPUKqtq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301951799"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="301951799"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 15:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="773503921"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="773503921"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2022 15:57:25 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v1 0/3] add netlink support for rss get
Date:   Wed, 14 Dec 2022 15:54:15 -0800
Message-Id: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add netlink based handler to fetch RSS information
using "ethtool -x <eth> [context %d]" command.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

Sudheer Mogilappagari (3):
  update UAPI header copies for RSS_GET support
  refactor functions that print rss information
  netlink: add netlink handler for get rss (-x)

 Makefile.am                  |   2 +-
 common.c                     |  43 ++++++++
 common.h                     |   7 ++
 ethtool.c                    |  44 +-------
 netlink/desc-ethtool.c       |  11 ++
 netlink/extapi.h             |   2 +
 netlink/rss.c                | 198 +++++++++++++++++++++++++++++++++++
 uapi/linux/ethtool_netlink.h |  14 +++
 8 files changed, 280 insertions(+), 41 deletions(-)
 create mode 100644 netlink/rss.c

-- 
2.31.1

