Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF1678C1B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjAWXii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjAWXig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:38:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23311E2AC;
        Mon, 23 Jan 2023 15:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674517111; x=1706053111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o7TzXEnFFmyZw/tGiAmP08geD+UsWfsqawGFdCPzVsI=;
  b=Wy3Cxh3yAyGqtAtzKG/6VeU1KbSPhqkrc4AMVagboEMo8UNQvRG3O4Y5
   tZkxG+JDAhRBWL4eN0MWiiPVkbB8ggnpAovcx4J2unwOfPhtVSLOwMujo
   6AeiQo+hKW8mGB+U9L46Hz8jL287AECKEPpphdr6BA5eXS11adQlCNP/W
   vwsG0aW2TeMDXDcSpUyaThorrtodHu64MsZ1pHV8AMiEVHNIxdo3z2AQ0
   AEuF3c9XIxsiJTDLoYy1YVUhVw0gJGMdmxSsQTA3gA+37u59JO/Pmd7wF
   A2EasyJ9GLGTHalLmFoJp1XPmDjZ6QO7xT9TwvWVrsRWCBlQ4OqHS9h9z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="323881133"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="323881133"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 15:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="639380551"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="639380551"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 23 Jan 2023 15:38:27 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pK6OQ-0005x9-1G;
        Mon, 23 Jan 2023 23:38:26 +0000
Date:   Tue, 24 Jan 2023 07:38:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Keeping <john@metanate.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, John Keeping <john@metanate.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: support CQM RSSI notification with older
 firmware
Message-ID: <202301240736.ApaNwujP-lkp@intel.com>
References: <20230123113924.2472721-1-john@metanate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123113924.2472721-1-john@metanate.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main horms-ipvs/master linus/master v6.2-rc5 next-20230123]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Keeping/brcmfmac-support-CQM-RSSI-notification-with-older-firmware/20230123-194055
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20230123113924.2472721-1-john%40metanate.com
patch subject: [PATCH] brcmfmac: support CQM RSSI notification with older firmware
config: sparc-randconfig-s051-20230123 (https://download.01.org/0day-ci/archive/20230124/202301240736.ApaNwujP-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/9e64c42d8517fca7356a698629cec1cdb79ce104
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Keeping/brcmfmac-support-CQM-RSSI-notification-with-older-firmware/20230123-194055
        git checkout 9e64c42d8517fca7356a698629cec1cdb79ce104
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/wireless/broadcom/brcm80211/brcmfmac/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:6500:24: sparse: sparse: cast to restricted __be32

vim +6500 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c

  6486	
  6487	static s32 brcmf_notify_rssi(struct brcmf_if *ifp,
  6488				     const struct brcmf_event_msg *e, void *data)
  6489	{
  6490		struct brcmf_cfg80211_vif *vif = ifp->vif;
  6491		struct brcmf_rssi_be *info = data;
  6492		s32 rssi, snr = 0, noise = 0;
  6493		s32 low, high, last;
  6494	
  6495		if (e->datalen >= sizeof(*info)) {
  6496			rssi = be32_to_cpu(info->rssi);
  6497			snr = be32_to_cpu(info->snr);
  6498			noise = be32_to_cpu(info->noise);
  6499		} else if (e->datalen >= sizeof(rssi)) {
> 6500			rssi = be32_to_cpu(*(s32 *)data);
  6501		} else {
  6502			brcmf_err("insufficient RSSI event data\n");
  6503			return 0;
  6504		}
  6505	
  6506		low = vif->cqm_rssi_low;
  6507		high = vif->cqm_rssi_high;
  6508		last = vif->cqm_rssi_last;
  6509	
  6510		brcmf_dbg(TRACE, "rssi=%d snr=%d noise=%d low=%d high=%d last=%d\n",
  6511			  rssi, snr, noise, low, high, last);
  6512	
  6513		vif->cqm_rssi_last = rssi;
  6514	
  6515		if (rssi <= low || rssi == 0) {
  6516			brcmf_dbg(INFO, "LOW rssi=%d\n", rssi);
  6517			cfg80211_cqm_rssi_notify(ifp->ndev,
  6518						 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
  6519						 rssi, GFP_KERNEL);
  6520		} else if (rssi > high) {
  6521			brcmf_dbg(INFO, "HIGH rssi=%d\n", rssi);
  6522			cfg80211_cqm_rssi_notify(ifp->ndev,
  6523						 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
  6524						 rssi, GFP_KERNEL);
  6525		}
  6526	
  6527		return 0;
  6528	}
  6529	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
