Return-Path: <netdev+bounces-2011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA1A6FFF4A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14EA91C210FA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A16818;
	Fri, 12 May 2023 03:29:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4D810
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:29:42 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4108A468A;
	Thu, 11 May 2023 20:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683862181; x=1715398181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OvzogAHeqtJArkfFrwuVlPlMN6TAJPqwHgCuw/bj4WA=;
  b=c6LQ9iptNz7poXlfU857/mw5migFLWOgH3Q5k3sLB8MBuokCIU48J0qg
   TaJiVwdjJt2KX3zGarfCYhQcHxy3tkyIPYNG4zoFFPtL36rT1SAClG7Uk
   D2S5DKA22Y4RDL04unylJosz5ud/jytAM45+R1bUIyeAPbw+lYkAFo2bE
   ejnB8ed3h1dVRCqXqhp/HxCFrLWTKu90SodyC5tNA6SV3CBwt8oFKVLOI
   SZUE8Kfsihpa98FK1IZ4FjxvkYcApRuuSr2W/7dCn+FJxW/LjRkFA+qVJ
   rjKA9kFp3L/MpaR3yJqvaPlbuq+C2j/652WDX0PuQDMyj6+p+VidEuLhE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335209095"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="335209095"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 20:29:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="844244718"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="844244718"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 11 May 2023 20:29:34 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxJTK-0004S8-0W;
	Fri, 12 May 2023 03:29:34 +0000
Date: Fri, 12 May 2023 11:28:55 +0800
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
Subject: Re: [PATCH 02/10] mISDN: Replace GPL notice boilerplate with SPDX
 identifier
Message-ID: <202305121151.UPlaFk6c-lkp@intel.com>
References: <20230511133406.78155-3-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-3-bagasdotme@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bagas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ac9a78681b921877518763ba0e89202254349d1b]

url:    https://github.com/intel-lab-lkp/linux/commits/Bagas-Sanjaya/agp-amd64-Remove-GPL-distribution-notice/20230511-214307
base:   ac9a78681b921877518763ba0e89202254349d1b
patch link:    https://lore.kernel.org/r/20230511133406.78155-3-bagasdotme%40gmail.com
patch subject: [PATCH 02/10] mISDN: Replace GPL notice boilerplate with SPDX identifier
reproduce:
        scripts/spdxcheck.py

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305121151.UPlaFk6c-lkp@intel.com/

spdxcheck warnings: (new ones prefixed by >>)
>> drivers/isdn/mISDN/dsp_audio.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/isdn/mISDN/dsp_blowfish.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/isdn/mISDN/dsp_cmx.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/isdn/mISDN/dsp_core.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/isdn/mISDN/dsp_dtmf.c: 1:28 Invalid License ID: GPL-1.0-or-later
>> drivers/isdn/mISDN/dsp_tones.c: 1:28 Invalid License ID: GPL-1.0-or-later

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

