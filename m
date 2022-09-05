Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775695AD82D
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIERMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiIERMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:12:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A8162A92
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662397963; x=1693933963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xu226FYnnpgDCFZ+ujR4rYnxLI08NOVz/3ZednLXJhs=;
  b=BMrMMidnXzNaxK0Y+6rDaZvJP7uzCNZNvHPn8VNvzEmlRpCWMTlfOW+m
   JY53/hIMoIRTr8sSL6Fpq7v10MrUq5dQ0hEYGIrD882sV0Z/w0aXh+gjB
   xeRspn0CXA+FvYPbgbMKSZoHgvf22vlUn1zkQa/iJz7J2YwZo8wszpnXh
   1NmUIE6T1hWnsM4VSUIhhxZDpJWPD8E7qBKBDKIs8j9qyZIgPtwav0xU/
   1Vlw/UaAltaFm2h4BFEJYkImcRcAA+MErXqhpZVYMVNNV4uYnLoGJkilP
   I0lGtVTI+Q/tSH5I+z33wrYQtPmCoU8qGXT3MTIJKrGoskb+imUnnce1M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="276822318"
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="276822318"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 10:12:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="702950738"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Sep 2022 10:12:40 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oVFeK-0004N3-0c;
        Mon, 05 Sep 2022 17:12:40 +0000
Date:   Tue, 6 Sep 2022 01:12:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: mv88e6xxx: Add functionality
 for handling RMU frames.
Message-ID: <202209060019.VUMe4qJF-lkp@intel.com>
References: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattias,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mattias-Forsblad/net-dsa-mv88e6xxx-qca8k-Add-RMU-support/20220905-212125
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5f3c5193479e5b9d51b201245febab6fbda4c477
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220906/202209060019.VUMe4qJF-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/50e5d9b5948e53c773edc3c710020e01f6045f9f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-dsa-mv88e6xxx-qca8k-Add-RMU-support/20220905-212125
        git checkout 50e5d9b5948e53c773edc3c710020e01f6045f9f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/dsa/mv88e6xxx/rmu.c: In function 'mv88e6xxx_decode_frame2reg_handler':
>> drivers/net/dsa/mv88e6xxx/rmu.c:239:33: warning: variable 'tagger_data' set but not used [-Wunused-but-set-variable]
     239 |         struct dsa_tagger_data *tagger_data;
         |                                 ^~~~~~~~~~~


vim +/tagger_data +239 drivers/net/dsa/mv88e6xxx/rmu.c

   236	
   237	void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
   238	{
 > 239		struct dsa_tagger_data *tagger_data;
   240		struct dsa_port *dp = dev->dsa_ptr;
   241		struct dsa_switch *ds = dp->ds;
   242		struct mv88e6xxx_chip *chip;
   243		int source_device;
   244		u8 *dsa_header;
   245		u16 format;
   246		u16 code;
   247		u8 seqno;
   248	
   249		tagger_data = ds->tagger_data;
   250	
   251		if (mv88e6xxx_validate_mac(ds, skb))
   252			return;
   253	
   254		/* Decode Frame2Reg DSA portion */
   255		dsa_header = skb->data - 2;
   256	
   257		source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
   258		ds = dsa_switch_find(ds->dst->index, source_device);
   259		if (!ds) {
   260			net_dbg_ratelimited("RMU: Didn't find switch with index %d", source_device);
   261			return;
   262		}
   263	
   264		chip = ds->priv;
   265		seqno = dsa_header[3];
   266		if (seqno != chip->rmu.inband_seqno) {
   267			net_dbg_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
   268					    seqno, chip->rmu.inband_seqno);
   269			return;
   270		}
   271	
   272		/* Pull DSA L2 data */
   273		skb_pull(skb, MV88E6XXX_DSA_HLEN);
   274	
   275		format = get_unaligned_be16(&skb->data[0]);
   276		if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
   277		    format != MV88E6XXX_RMU_RESP_FORMAT_2) {
   278			net_dbg_ratelimited("RMU: received unknown format 0x%04x", format);
   279			return;
   280		}
   281	
   282		code = get_unaligned_be16(&skb->data[4]);
   283		if (code == MV88E6XXX_RMU_RESP_ERROR) {
   284			net_dbg_ratelimited("RMU: error response code 0x%04x", code);
   285			return;
   286		}
   287	
   288		if (code == MV88E6XXX_RMU_RESP_CODE_GOT_ID)
   289			mv88e6xxx_prod_id_handler(ds, skb);
   290		else if (code == MV88E6XXX_RMU_RESP_CODE_DUMP_MIB)
   291			mv88e6xxx_mib_handler(ds, skb);
   292	
   293		dsa_switch_inband_complete(ds, NULL);
   294	}
   295	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
