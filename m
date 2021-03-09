Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC377331BA7
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 01:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhCIA3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 19:29:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:45376 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCIA3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 19:29:00 -0500
IronPort-SDR: v7A1Gm6nxvuCPkh7UEvwysR4htVqzCk0bXvZCbjeVjjOcdVMf0TvEPOEREcXhMCGHQSqa9Q2pF
 37VNLYFpQI+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188236873"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="188236873"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 16:29:00 -0800
IronPort-SDR: VTEJmat5VXYS+m1Ajl4Dv3Lq5/oqf3HP6Bhj+b5k4Q4gdaCLcDrKBpb1ZSwgF32wdIMngXnJ1o
 /1J57wmWZtOw==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="403011972"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.213.162.252])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 16:28:59 -0800
Date:   Mon, 8 Mar 2021 16:28:58 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        alice.michael@intel.com, alan.brady@intel.com
Subject: [RFC net-next] iavf: refactor plan proposal
Message-ID: <20210308162858.00004535@intel.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We plan to refactor the iavf module and would appreciate community and
maintainer feedback on our plans.  We want to do this to realize the
usefulness of the common code module for multiple drivers.  This
proposal aims to avoid disrupting current users.

The steps we plan are something like:
1) Continue upstreaming of the iecm module (common module) and
   the initial feature set for the idpf driver[1] utilizing iecm.
2) Introduce the refactored iavf code as a "new" iavf driver with the
   same device ID, but Kconfig default to =n to enable testing. 
	a. Make this exclusive so if someone opts in to "new" iavf,
	   then it disables the original iavf (?) 
	b. If we do make it exclusive in Kconfig can we use the same
	   name? 
3) Plan is to make the "new" iavf driver the default iavf once
   extensive regression testing can be completed. 
	a. Current proposal is to make CONFIG_IAVF have a sub-option
	   CONFIG_IAVF_V2 that lets the user adopt the new code,
	   without changing the config for existing users or breaking
	   them.

We are looking to make sure that the mode of our refactoring will meet
the community's expectations. Any advice or feedback is appreciated.

Thanks,
Jesse, Alice, Alan

[1]
https://lore.kernel.org/netdev/20200824173306.3178343-1-anthony.l.nguyen@intel.com/
