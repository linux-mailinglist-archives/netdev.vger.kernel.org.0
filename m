Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43E35AF775
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiIFV4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIFV4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:56:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2834A8E99C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662501373; x=1694037373;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=05yZEohN9E3brzcorgubAKstcMweEBs9ZDYUboK4ivM=;
  b=GQVzYF6GczpdQZQM/cpwKanSEjxphDkdrc7xPh9MPWUV0SW4Fm9Gmcsk
   JRMvurwUALG8RmT0a732W0Aes/M3JZ9sQoumclnT56uBMnUMxwhSherg2
   VOvjUK7FF5hVMypCqth34eMPDmojqbla8zmSnU9WMzC0LuK9hYsRNb8Yb
   Fk6I6IrO0Y1XVKhRkuabnxv12wkVsZdwF4K3kOuFXVx9y93n1v+Uqe7R/
   3+RkptxPT9wy4uWUV8nmwhXE/59GLZqaIoVh9eLNpYYxhsLhZ+Gk3b7zE
   Vq4ufgPX0WiwS0yjySG3WxwUiYjD/s/AjqsPIvOXmYc0tsynCyUcgCqwO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="383012339"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="383012339"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:56:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="682562893"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2022 14:56:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2022-09-06 (i40e, iavf)
Date:   Tue,  6 Sep 2022 14:56:03 -0700
Message-Id: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Stanislaw adds support for new device id for i40e.

Jaroslaw tidies up some code around MSI-X configuration by adding/
reworking comments and introducing a couple of macros for i40e.

Michal resolves some races around reset and close by deferring and deleting
some pending AdminQ operations and reworking filter additions and deletions
during these operations for iavf.

The following are changes since commit 03fdb11da92fde0bdc0b6e9c1c642b7414d49e8d:
  net: moxa: fix endianness-related issues from 'sparse'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jaroslaw Gawin (1):
  i40e: add description and modify interrupts configuration procedure

Michal Jaron (1):
  iavf: Fix race between iavf_close and iavf_reset_task

Stanislaw Grzeszczak (1):
  i40e: Add basic support for I710 devices

 drivers/net/ethernet/intel/i40e/i40e.h        |  14 ++
 drivers/net/ethernet/intel/i40e/i40e_common.c |   3 +
 drivers/net/ethernet/intel/i40e/i40e_devids.h |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  35 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 177 ++++++++++++++----
 5 files changed, 175 insertions(+), 58 deletions(-)

-- 
2.35.1

