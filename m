Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1F100F9E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfKSABr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:01:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:10625 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfKSABr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 19:01:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 16:01:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="407569542"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 18 Nov 2019 16:01:45 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iWqxl-000GaJ-2t; Tue, 19 Nov 2019 08:01:45 +0800
Date:   Tue, 19 Nov 2019 08:01:39 +0800
From:   kbuild test robot <lkp@intel.com>
To:     sunil.kovvuri@gmail.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        davem@davemloft.net, Linu Cherian <lcherian@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Vamsi Attunuru <vamsi.attunuru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 02/15] octeontx2-af: Add support for importing firmware
 data
Message-ID: <201911190755.klynO0gk%lkp@intel.com>
References: <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on next-20191118]
[cannot apply to v5.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/sunil-kovvuri-gmail-com/octeontx2-af-SSO-TIM-HW-blocks-and-other-config-support/20191118-002309
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 19b7e21c55c81713c4011278143006af9f232504
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-32-g233d4e1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected struct rvu_fwdata *fwdata @@    got void struct rvu_fwdata *fwdata @@
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse:    expected struct rvu_fwdata *fwdata
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse:    got void [noderef] <asn:2> *
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got [noderef] <asn:2> *addr @@
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse:    expected void volatile [noderef] <asn:2> *addr
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse:    got struct rvu_fwdata *fwdata
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got [noderef] <asn:2> *addr @@
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse:    got struct rvu_fwdata *fwdata

vim +722 drivers/net/ethernet/marvell/octeontx2/af/rvu.c

   712	
   713	static int rvu_fwdata_init(struct rvu *rvu)
   714	{
   715		u64 fwdbase;
   716		int err;
   717	
   718		/* Get firmware data base address */
   719		err = cgx_get_fwdata_base(&fwdbase);
   720		if (err)
   721			goto fail;
 > 722		rvu->fwdata = ioremap_wc(fwdbase, sizeof(struct rvu_fwdata));
   723		if (!rvu->fwdata)
   724			goto fail;
   725		if (!is_rvu_fwdata_valid(rvu)) {
   726			dev_err(rvu->dev,
   727				"Mismatch in 'fwdata' struct btw kernel and firmware\n");
 > 728			iounmap(rvu->fwdata);
   729			rvu->fwdata = NULL;
   730			return -EINVAL;
   731		}
   732		return 0;
   733	fail:
   734		dev_info(rvu->dev, "Unable to fetch 'fwdata' from firmware\n");
   735		return -EIO;
   736	}
   737	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
