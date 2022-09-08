Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796415B24AF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiIHRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiIHRe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:34:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462D426A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662658465; x=1694194465;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VgzmDo79W8qIfxTllA4oWWA+30kdllMT7dJGKF8QaOM=;
  b=NpXNgu8ag1FwWsYSSEZ0ctX07GsOAqkjzL+Tz3s7uYa+UD6NPy1ZPCzj
   TMAIlLhQMEXVf3sXU/F/zbUPTavmHheMbi9kvkT8GGr3cPKpPgswY/gv4
   c3k4wlIitxkez2Hyw6J1EbhwMXn4Vs/CqcEmTJcuJqpLsvbAaai+EstOv
   /ZR6fQ1zaRFrYMvbxab0Mdt/IwDiTOibryVJEmqcTUDmOAjSRtlGgV6k6
   Slk7VNrc9PLTJXm1TwYz63axHDmAGxZXyYwtLbx/eamam6cq5ThrHBTpD
   jmu3FGuGw/MZDkH4BmrTnSQUH+wXZCW2FXvpXqI5XpJsTqvV5fOm9JQDI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277005532"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="277005532"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:34:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="683317123"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 08 Sep 2022 10:34:22 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWLPy-0000Bd-0l;
        Thu, 08 Sep 2022 17:34:22 +0000
Date:   Fri, 9 Sep 2022 01:34:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Subject: Re: [net-next PATCH v2 4/4] Documentation: networking: TC queue
 based filtering
Message-ID: <202209090101.Eze9wDA6-lkp@intel.com>
References: <166260025920.81018.12730039389826735230.stgit@anambiarhost.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166260025920.81018.12730039389826735230.stgit@anambiarhost.jf.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Amritha,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Amritha-Nambiar/Extend-action-skbedit-to-RX-queue-mapping/20220908-091523
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2018b22a759e26a4c7e3ac6c60c283cfbd2c9c93
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/1c8a93c17a4a1a9ba7be2aba8b1886d12ea14d8c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Amritha-Nambiar/Extend-action-skbedit-to-RX-queue-mapping/20220908-091523
        git checkout 1c8a93c17a4a1a9ba7be2aba8b1886d12ea14d8c
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/networking/tc-queue-filters.rst:12: WARNING: Unexpected indentation.
>> Documentation/networking/tc-queue-filters.rst:14: WARNING: Block quote ends without a blank line; unexpected unindent.
>> Documentation/networking/tc-queue-filters.rst: WARNING: document isn't included in any toctree

vim +12 Documentation/networking/tc-queue-filters.rst

     9	
    10	On the transmit side:
    11	1. TC filter directing traffic to a set of queues is achieved
  > 12	   using the action skbedit priority for Tx priority selection,
    13	   the priority maps to a traffic class (set of queues).
  > 14	2. TC filter directs traffic to a transmit queue with the action
    15	   skbedit queue_mapping $tx_qid.
    16	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
