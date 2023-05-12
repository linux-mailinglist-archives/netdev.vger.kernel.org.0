Return-Path: <netdev+bounces-2017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB3D6FFF8A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA1E41C210F8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFCAA51;
	Fri, 12 May 2023 04:09:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EE2A4A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:09:47 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F7459C4;
	Thu, 11 May 2023 21:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683864585; x=1715400585;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ij2TBovyX1fbUGAzCKCpJn+xp0fp35Qx/066/MjPBlg=;
  b=mJSgBztLpJ+vPETvyFkfop9chIicPHY0WlMvleGgjo3r7KNPeLY9WfsP
   DlxqB+ahxXX1J8XHPrJjpDRuqoA1O11/a7Mu4fyUCa+jL2WQZbhLSXQ1j
   ZgOQXUwavCjE83b4T9vew0B4bKgEMSwxQ0e5ySmAAHXCWE8+M7z8IEdBO
   PHuKShAaVC3vAWbCbabxAWFDv4I5QDJ8HWc+fCeOOYCSakEshKEbfjBCO
   AkF68fF2+/YFUu7ydzh8aBlucR2qdJ75H+9upueOxnS62EWhvALNgUtx/
   ERd6OIXd6cgupWOUPoJPuHbZTTK13tViwVIUAK63QQKXjzvaSK8weIWy3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416324517"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="416324517"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 21:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="732872157"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="732872157"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2023 21:09:35 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxK63-0004UL-0Y;
	Fri, 12 May 2023 04:09:35 +0000
Date: Fri, 12 May 2023 12:09:12 +0800
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
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Dan Carpenter <error27@gmail.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Greg Ungerer <gerg@linux-m68k.org>, Peter De Schrijver <p2@mind.be>,
	Simon Horman <simon.horman@corigine.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>, Sam Creasey <sammy@sammy.net>,
	Donald Becker <becker@scyld.com>
Subject: Re: [PATCH 04/10] net: ethernet: 8390: Replace GPL boilerplate with
 SPDX identifier
Message-ID: <202305121107.Au46XZCK-lkp@intel.com>
References: <20230511133406.78155-5-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-5-bagasdotme@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bagas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ac9a78681b921877518763ba0e89202254349d1b]

url:    https://github.com/intel-lab-lkp/linux/commits/Bagas-Sanjaya/agp-amd64-Remove-GPL-distribution-notice/20230511-214307
base:   ac9a78681b921877518763ba0e89202254349d1b
patch link:    https://lore.kernel.org/r/20230511133406.78155-5-bagasdotme%40gmail.com
patch subject: [PATCH 04/10] net: ethernet: 8390: Replace GPL boilerplate with SPDX identifier
reproduce:
        scripts/spdxcheck.py

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305121107.Au46XZCK-lkp@intel.com/

spdxcheck warnings: (new ones prefixed by >>)
   include/net/bonding.h: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_audio.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_blowfish.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_cmx.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_core.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_dtmf.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_tones.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/bonding/bond_main.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/net/bonding/bonding_priv.h: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/8390.h: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/apne.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/axnet_cs.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/hydra.c: 1:28 Invalid License ID: GPL-1.0-only
>> drivers/net/ethernet/8390/lib8390.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/mac8390.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/ne.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/ne2k-pci.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/pcnet_cs.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/smc-ultra.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/ethernet/8390/wd.c: 1:28 Invalid License ID: GPL-1.0-or-later

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

