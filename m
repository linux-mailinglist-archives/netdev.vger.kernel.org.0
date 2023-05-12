Return-Path: <netdev+bounces-2028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E57B700018
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF4B82819EF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4DA111D;
	Fri, 12 May 2023 06:01:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D678111C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:01:51 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748A649C1;
	Thu, 11 May 2023 23:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683871310; x=1715407310;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iHUv69UyfzxQ3VeWTpR1GT/N/Rvib8OFJmndtMsMloI=;
  b=JX1mw3b71sLSdr9ly2Mb0WnPc/pORFHg1MRXpmHVJrYGOgpzH1AioToF
   17OX0p3qn0VsG7nQ3wqTRVHtO36opQNXchEgXrH8j3nMgnpPaG//qLkA+
   T+f4TPBgU7XY7zdStW8pJ0q4Mj3VaxOEjknU1ffLkE++m38FJMzWiPNKu
   lEDdCOrt0QAOI5qOs4sTLftNZS6rOh7i432LNJ/M2R3IldUOlrzqKavgf
   Tejv4PsgIixKsySmMBIZiouCApjaOJ+Evo6PGhXy0X+HGi0H4CZE+4bK3
   Th25m5OQIP9mVYhB7I4D0kruxj808UbyVBFrs1FBKBkI1bCPLh1LwhS0C
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="353840859"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353840859"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 23:01:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="730683054"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730683054"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2023 23:01:38 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxLqU-0004a2-04;
	Fri, 12 May 2023 06:01:38 +0000
Date: Fri, 12 May 2023 14:00:44 +0800
From: kernel test robot <lkp@intel.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Pavel Machek <pavel@ucw.cz>, Tom Rix <trix@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Eric Dumazet <edumazet@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Dan Carpenter <error27@gmail.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Simon Horman <simon.horman@corigine.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>, Sam Creasey <sammy@sammy.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jay Vosburgh <j.vosburgh@gmail.com>, Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH 10/10] include: synclink: Replace GPL license notice with
 SPDX identifier
Message-ID: <202305121302.dCL8lmbx-lkp@intel.com>
References: <20230511133406.78155-11-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-11-bagasdotme@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bagas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ac9a78681b921877518763ba0e89202254349d1b]

url:    https://github.com/intel-lab-lkp/linux/commits/Bagas-Sanjaya/agp-amd64-Remove-GPL-distribution-notice/20230511-214307
base:   ac9a78681b921877518763ba0e89202254349d1b
patch link:    https://lore.kernel.org/r/20230511133406.78155-11-bagasdotme%40gmail.com
patch subject: [PATCH 10/10] include: synclink: Replace GPL license notice with SPDX identifier
reproduce:
        scripts/spdxcheck.py

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305121302.dCL8lmbx-lkp@intel.com/

spdxcheck warnings: (new ones prefixed by >>)
   drivers/pcmcia/cirrus.h: 1:44 Invalid License ID: MPL
   drivers/pcmcia/pd6729.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/watchdog/ibmasr.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/watchdog/sb_wdog.c: 1:28 Invalid License ID: GPL-1.0
   fs/udf/ecma_167.h: 1:44 Invalid License ID: GPL-1.0-only
   fs/udf/osta_udf.h: 1:44 Invalid License ID: GPL-1.0-only
>> include/linux/synclink.h: 1:28 Invalid License ID: GPL-1.0-or-later
   include/net/bonding.h: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_audio.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_blowfish.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_cmx.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_core.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_dtmf.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_tones.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/bonding/bond_main.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/bonding/bonding_priv.h: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/8390.h: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/apne.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/axnet_cs.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/hydra.c: 1:28 Invalid License ID: GPL-1.0-only
   drivers/net/ethernet/8390/lib8390.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/mac8390.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/ne.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/ne2k-pci.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/pcnet_cs.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/smc-ultra.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/8390/wd.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/i825xx/82596.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/i825xx/lasi_82596.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/ethernet/i825xx/lib82596.c: 1:28 Invalid License ID: GPL-1.0-or-later

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

