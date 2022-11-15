Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA45628DE6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiKOADc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKOADb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:03:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A27D5E;
        Mon, 14 Nov 2022 16:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668470609; x=1700006609;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m6wPyFnyfKLUmf/g0Fl+gz9xCoPSxKkLJzIQHX9qDOY=;
  b=LfUn6VRkj0Df1NU4JJPnIvUoB/a0DeyOqnJ/Re6ER/1Pam5jzd+CMoEq
   kYCZvf4Uuervgky6O2wNFZDRirbHBfo5rL7s2wUADkfvSQXZI7Gz8ogWM
   v77PqPi6N1ChB7as5QlkmSBSyWFmSvqoY1pEcD0+I1ASiWq7y7zes/liD
   8m1MqbY6QC8ms1BIPt5n68iQvzoxUi3BeMpXHYeIMk7bjj7NSgMfvHok5
   /wEzgU+l1YlvQ+zaFOMtaPeohO3g6NhhuyN5BDEJ0/L9kHep8NTKb22Z1
   iAWaUtDHE8ZgpWGNWXwhGHyXx3vQfcZadv/koi5FpRhRYtXMgBzoDGFzi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310824662"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310824662"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:03:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669870395"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669870395"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2022 16:03:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-11-14 (i40e)
Date:   Mon, 14 Nov 2022 16:03:22 -0800
Message-Id: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Sylwester removes attempted allocation of Rx buffers when AF_XDP is in Tx
only mode.

Bartosz adds helper to calculate Rx buffer length so that it can be
used when interface is down; before value has been set in struct.

The following are changes since commit ed1fe1bebe18884b11e5536b5ac42e3a48960835:
  net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Bartosz Staszewski (1):
  i40e: fix xdp_redirect logs error message when testing with MTU=1500

Sylwester Dziedziuch (1):
  i40e: Fix failure message when XDP is configured in TX only mode

 drivers/net/ethernet/intel/i40e/i40e_main.c | 48 +++++++++++++++------
 1 file changed, 34 insertions(+), 14 deletions(-)

-- 
2.35.1

