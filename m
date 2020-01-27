Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1D2149E55
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 03:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgA0CwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 21:52:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:58540 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0CwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 21:52:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 18:51:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,368,1574150400"; 
   d="scan'208";a="228844970"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2020 18:51:42 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivuV3-000DLD-Tb; Mon, 27 Jan 2020 10:51:41 +0800
Date:   Mon, 27 Jan 2020 10:51:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     kbuild-all@lists.01.org, michal.kalderon@marvell.com,
        ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 net-next 09/13] qed: FW 8.42.2.0 HSI changes
Message-ID: <202001271024.5l3jC1ND%lkp@intel.com>
References: <20200123105836.15090-10-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123105836.15090-10-michal.kalderon@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.5-rc7 next-20200121]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Michal-Kalderon/qed-Utilize-FW-8-42-2-0/20200125-055253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9bbc8be29d66cc34b650510f2c67b5c55235fe5d
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-153-g47b6dfef-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/qlogic/qed/qed_debug.c:1897:29: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1897:58: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1899:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1899:22: sparse:    expected unsigned int [assigned] [usertype] addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1899:22: sparse:    got restricted __le32 [addressable] [usertype] grc_addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1901:33: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2030:65: sparse: sparse: incorrect type in argument 4 (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2030:65: sparse:    expected unsigned int [usertype] param_val
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2030:65: sparse:    got restricted __le32 [addressable] [usertype] timestamp
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:5067:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7992:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7992:46: sparse:    expected unsigned int [usertype]
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7992:46: sparse:    got restricted __be32 [assigned] [usertype] val

vim +5067 drivers/net/ethernet/qlogic/qed/qed_debug.c

c965db44462919 Tomer Tayar     2016-09-07  5013  
c965db44462919 Tomer Tayar     2016-09-07  5014  /* Performs FW Asserts Dump to the specified buffer.
c965db44462919 Tomer Tayar     2016-09-07  5015   * Returns the dumped size in dwords.
c965db44462919 Tomer Tayar     2016-09-07  5016   */
c965db44462919 Tomer Tayar     2016-09-07  5017  static u32 qed_fw_asserts_dump(struct qed_hwfn *p_hwfn,
c965db44462919 Tomer Tayar     2016-09-07  5018  			       struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
c965db44462919 Tomer Tayar     2016-09-07  5019  {
c965db44462919 Tomer Tayar     2016-09-07  5020  	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
be086e7c53f1fa Mintz, Yuval    2017-03-11  5021  	struct fw_asserts_ram_section *asserts;
c965db44462919 Tomer Tayar     2016-09-07  5022  	char storm_letter_str[2] = "?";
c965db44462919 Tomer Tayar     2016-09-07  5023  	struct fw_info fw_info;
be086e7c53f1fa Mintz, Yuval    2017-03-11  5024  	u32 offset = 0;
c965db44462919 Tomer Tayar     2016-09-07  5025  	u8 storm_id;
c965db44462919 Tomer Tayar     2016-09-07  5026  
c965db44462919 Tomer Tayar     2016-09-07  5027  	/* Dump global params */
c965db44462919 Tomer Tayar     2016-09-07  5028  	offset += qed_dump_common_global_params(p_hwfn,
c965db44462919 Tomer Tayar     2016-09-07  5029  						p_ptt,
c965db44462919 Tomer Tayar     2016-09-07  5030  						dump_buf + offset, dump, 1);
c965db44462919 Tomer Tayar     2016-09-07  5031  	offset += qed_dump_str_param(dump_buf + offset,
c965db44462919 Tomer Tayar     2016-09-07  5032  				     dump, "dump-type", "fw-asserts");
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5033  
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5034  	/* Find Storm dump size */
c965db44462919 Tomer Tayar     2016-09-07  5035  	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++) {
be086e7c53f1fa Mintz, Yuval    2017-03-11  5036  		u32 fw_asserts_section_addr, next_list_idx_addr, next_list_idx;
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5037  		struct storm_defs *storm = &s_storm_defs[storm_id];
be086e7c53f1fa Mintz, Yuval    2017-03-11  5038  		u32 last_list_idx, addr;
c965db44462919 Tomer Tayar     2016-09-07  5039  
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5040  		if (dev_data->block_in_reset[storm->block_id])
c965db44462919 Tomer Tayar     2016-09-07  5041  			continue;
c965db44462919 Tomer Tayar     2016-09-07  5042  
c965db44462919 Tomer Tayar     2016-09-07  5043  		/* Read FW info for the current Storm */
d52c89f120de84 Michal Kalderon 2018-06-05  5044  		qed_read_storm_fw_info(p_hwfn, p_ptt, storm_id, &fw_info);
c965db44462919 Tomer Tayar     2016-09-07  5045  
be086e7c53f1fa Mintz, Yuval    2017-03-11  5046  		asserts = &fw_info.fw_asserts_section;
be086e7c53f1fa Mintz, Yuval    2017-03-11  5047  
c965db44462919 Tomer Tayar     2016-09-07  5048  		/* Dump FW Asserts section header and params */
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5049  		storm_letter_str[0] = storm->letter;
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5050  		offset += qed_dump_section_hdr(dump_buf + offset,
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5051  					       dump, "fw_asserts", 2);
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5052  		offset += qed_dump_str_param(dump_buf + offset,
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5053  					     dump, "storm", storm_letter_str);
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5054  		offset += qed_dump_num_param(dump_buf + offset,
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5055  					     dump,
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5056  					     "size",
be086e7c53f1fa Mintz, Yuval    2017-03-11  5057  					     asserts->list_element_dword_size);
c965db44462919 Tomer Tayar     2016-09-07  5058  
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5059  		/* Read and dump FW Asserts data */
c965db44462919 Tomer Tayar     2016-09-07  5060  		if (!dump) {
be086e7c53f1fa Mintz, Yuval    2017-03-11  5061  			offset += asserts->list_element_dword_size;
c965db44462919 Tomer Tayar     2016-09-07  5062  			continue;
c965db44462919 Tomer Tayar     2016-09-07  5063  		}
c965db44462919 Tomer Tayar     2016-09-07  5064  
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5065  		fw_asserts_section_addr = storm->sem_fast_mem_addr +
c965db44462919 Tomer Tayar     2016-09-07  5066  			SEM_FAST_REG_INT_RAM +
be086e7c53f1fa Mintz, Yuval    2017-03-11 @5067  			RAM_LINES_TO_BYTES(asserts->section_ram_line_offset);
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5068  		next_list_idx_addr = fw_asserts_section_addr +
be086e7c53f1fa Mintz, Yuval    2017-03-11  5069  			DWORDS_TO_BYTES(asserts->list_next_index_dword_offset);
c965db44462919 Tomer Tayar     2016-09-07  5070  		next_list_idx = qed_rd(p_hwfn, p_ptt, next_list_idx_addr);
da09091732aecc Tomer Tayar     2017-12-27  5071  		last_list_idx = (next_list_idx > 0 ?
da09091732aecc Tomer Tayar     2017-12-27  5072  				 next_list_idx :
da09091732aecc Tomer Tayar     2017-12-27  5073  				 asserts->list_num_elements) - 1;
be086e7c53f1fa Mintz, Yuval    2017-03-11  5074  		addr = BYTES_TO_DWORDS(fw_asserts_section_addr) +
be086e7c53f1fa Mintz, Yuval    2017-03-11  5075  		       asserts->list_dword_offset +
be086e7c53f1fa Mintz, Yuval    2017-03-11  5076  		       last_list_idx * asserts->list_element_dword_size;
be086e7c53f1fa Mintz, Yuval    2017-03-11  5077  		offset +=
be086e7c53f1fa Mintz, Yuval    2017-03-11  5078  		    qed_grc_dump_addr_range(p_hwfn, p_ptt,
be086e7c53f1fa Mintz, Yuval    2017-03-11  5079  					    dump_buf + offset,
be086e7c53f1fa Mintz, Yuval    2017-03-11  5080  					    dump, addr,
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5081  					    asserts->list_element_dword_size,
d52c89f120de84 Michal Kalderon 2018-06-05  5082  						  false, SPLIT_TYPE_NONE, 0);
c965db44462919 Tomer Tayar     2016-09-07  5083  	}
c965db44462919 Tomer Tayar     2016-09-07  5084  
c965db44462919 Tomer Tayar     2016-09-07  5085  	/* Dump last section */
da09091732aecc Tomer Tayar     2017-12-27  5086  	offset += qed_dump_last_section(dump_buf, offset, dump);
7b6859fbdcc4a5 Mintz, Yuval    2017-05-18  5087  
c965db44462919 Tomer Tayar     2016-09-07  5088  	return offset;
c965db44462919 Tomer Tayar     2016-09-07  5089  }
c965db44462919 Tomer Tayar     2016-09-07  5090  

:::::: The code at line 5067 was first introduced by commit
:::::: be086e7c53f1fac51eed14523b28f2214b548dd2 qed*: Utilize Firmware 8.15.3.0

:::::: TO: Mintz, Yuval <Yuval.Mintz@cavium.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
