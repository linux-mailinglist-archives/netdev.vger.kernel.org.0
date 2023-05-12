Return-Path: <netdev+bounces-2014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2156FFF71
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57F4A1C21117
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E37818;
	Fri, 12 May 2023 03:52:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5867DA3B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:52:43 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8614EC8;
	Thu, 11 May 2023 20:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683863561; x=1715399561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pmopDKLIc4zl+fq5xL7xMuzECz1xDAHg5SvtSuERXKQ=;
  b=ksKXnU4Wo2S3a+v+vaGt23Edy4Z4y+YaDzkjtwOr5+S4zAh69CtbqzSu
   quA2Q/JTH83NxFO+ArVr5bqSpX1Vv76PM3KBbYBqKmpPixE2Nw4Tg75MT
   adHjeuRTkX5cETaL820k/Uw3+wctM3ODenFahk5BE2ebhe/lHuw3ysMXR
   i8bZcSGHYnjxTI31KjL2DAaq/JnEiAAkycLRraoOsitBNNQloZN9ekkeM
   RxuyJetCYqpI1+aLWq/aopdnBcZxTVkyiGhwUfMfm6yKCJ9qZLbaa/y6u
   xZVW9gp93PWGl8SG+7+CVkI95xUqmj6lFJRrDIjQZmD91dr+Hpt34pprn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="437027746"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437027746"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 20:52:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="769629426"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="769629426"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2023 20:52:35 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxJpa-0004TA-28;
	Fri, 12 May 2023 03:52:34 +0000
Date: Fri, 12 May 2023 11:52:21 +0800
From: kernel test robot <lkp@intel.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: oe-kbuild-all@lists.linux.dev, Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>, Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH 03/10] net: bonding: Add SPDX identifier to remaining
 files
Message-ID: <202305121116.pEUebm1s-lkp@intel.com>
References: <20230511133406.78155-4-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-4-bagasdotme@gmail.com>
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
patch link:    https://lore.kernel.org/r/20230511133406.78155-4-bagasdotme%40gmail.com
patch subject: [PATCH 03/10] net: bonding: Add SPDX identifier to remaining files
reproduce:
        scripts/spdxcheck.py

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305121116.pEUebm1s-lkp@intel.com/

spdxcheck warnings: (new ones prefixed by >>)
>> include/net/bonding.h: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_audio.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_blowfish.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_cmx.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_core.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_dtmf.c: 1:28 Invalid License ID: GPL-1.0-or-later
   drivers/isdn/mISDN/dsp_tones.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/bonding/bond_main.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/net/bonding/bonding_priv.h: 1:28 Invalid License ID: GPL-1.0-or-later

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

