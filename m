Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC85B3C6D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiIIPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIIPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:54:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1E92ED4B
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662738880; x=1694274880;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h2W3vEBrf7Q1t2AnBMyNQy74+gAmaDt/5/Vqnjtidnc=;
  b=O3JOJJCidb6NUZZFuNSX18s33lHcPSl0+4paZylWizVOk0dvdSsVQ5kz
   Qe0KEXavhDOEqxgjY8XHaOgBudJGDdJ+jfKKqUwAt7wBvY/OT4Mhl+Zoi
   U2NRAaWBoAaMq75eV5i+Jad37VDtVSJcbnSVIQUt3MTB7iVYDJPv2XzQ/
   +LEBdW1B+OySqjg6q+N7ogk1rT1FcWwBv3AM1k2IyCdWVHNRDiiZsfkMa
   iC/cFFUC86Gw00FspoJmg+PHi9KZOcLipG3ovTZI8WBa15DHBwhcIt+fC
   Lcnf6Cid3gpZh8DGY04QY0v+GT4v6i2Wpmodrz4DTtrCgbVYfqN8ViGfA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="298307215"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="298307215"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 08:54:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="943819109"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 09 Sep 2022 08:54:37 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWgKy-0001OB-2h;
        Fri, 09 Sep 2022 15:54:36 +0000
Date:   Fri, 9 Sep 2022 23:53:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lasse Johnsen <lasse@timebeat.app>, netdev@vger.kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     kbuild-all@lists.01.org,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-ID: <202209092314.pShH7HvH-lkp@intel.com>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lasse,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lasse-Johnsen/igc-ptp-Add-1-step-functionality-to-igc-driver/20220909-062001
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9f8f1933dce555d3c246f447f54fca8de8889da9
config: openrisc-randconfig-s052-20220909 (https://download.01.org/0day-ci/archive/20220909/202209092314.pShH7HvH-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/148cdacbd4f77d88190d8fbeb4a95fedeb645f6b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lasse-Johnsen/igc-ptp-Add-1-step-functionality-to-igc-driver/20220909-062001
        git checkout 148cdacbd4f77d88190d8fbeb4a95fedeb645f6b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/net/ethernet/intel/igc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/intel/igc/igc_main.c:1264:44: sparse: sparse: invalid assignment: |=
>> drivers/net/ethernet/intel/igc/igc_main.c:1264:44: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/intel/igc/igc_main.c:1264:44: sparse:    right side has type int

vim +1264 drivers/net/ethernet/intel/igc/igc_main.c

  1182	
  1183	static int igc_tx_map(struct igc_ring *tx_ring,
  1184			      struct igc_tx_buffer *first,
  1185			      const u8 hdr_len)
  1186	{
  1187		struct sk_buff *skb = first->skb;
  1188		struct igc_tx_buffer *tx_buffer;
  1189		union igc_adv_tx_desc *tx_desc;
  1190		u32 tx_flags = first->tx_flags;
  1191		skb_frag_t *frag;
  1192		u16 i = tx_ring->next_to_use;
  1193		unsigned int data_len, size;
  1194		dma_addr_t dma;
  1195		u32 cmd_type;
  1196	
  1197		cmd_type = igc_tx_cmd_type(skb, tx_flags);
  1198		tx_desc = IGC_TX_DESC(tx_ring, i);
  1199	
  1200		igc_tx_olinfo_status(tx_ring, tx_desc, tx_flags, skb->len - hdr_len);
  1201	
  1202		size = skb_headlen(skb);
  1203		data_len = skb->data_len;
  1204	
  1205		dma = dma_map_single(tx_ring->dev, skb->data, size, DMA_TO_DEVICE);
  1206	
  1207		tx_buffer = first;
  1208	
  1209		for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
  1210			if (dma_mapping_error(tx_ring->dev, dma))
  1211				goto dma_error;
  1212	
  1213			/* record length, and DMA address */
  1214			dma_unmap_len_set(tx_buffer, len, size);
  1215			dma_unmap_addr_set(tx_buffer, dma, dma);
  1216	
  1217			tx_desc->read.buffer_addr = cpu_to_le64(dma);
  1218	
  1219			while (unlikely(size > IGC_MAX_DATA_PER_TXD)) {
  1220				tx_desc->read.cmd_type_len =
  1221					cpu_to_le32(cmd_type ^ IGC_MAX_DATA_PER_TXD);
  1222	
  1223				i++;
  1224				tx_desc++;
  1225				if (i == tx_ring->count) {
  1226					tx_desc = IGC_TX_DESC(tx_ring, 0);
  1227					i = 0;
  1228				}
  1229				tx_desc->read.olinfo_status = 0;
  1230	
  1231				dma += IGC_MAX_DATA_PER_TXD;
  1232				size -= IGC_MAX_DATA_PER_TXD;
  1233	
  1234				tx_desc->read.buffer_addr = cpu_to_le64(dma);
  1235			}
  1236	
  1237			if (likely(!data_len))
  1238				break;
  1239	
  1240			tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type ^ size);
  1241	
  1242			i++;
  1243			tx_desc++;
  1244			if (i == tx_ring->count) {
  1245				tx_desc = IGC_TX_DESC(tx_ring, 0);
  1246				i = 0;
  1247			}
  1248			tx_desc->read.olinfo_status = 0;
  1249	
  1250			size = skb_frag_size(frag);
  1251			data_len -= size;
  1252	
  1253			dma = skb_frag_dma_map(tx_ring->dev, frag, 0,
  1254					       size, DMA_TO_DEVICE);
  1255	
  1256			tx_buffer = &tx_ring->tx_buffer_info[i];
  1257		}
  1258	
  1259		/* write last descriptor with RS and EOP bits */
  1260		cmd_type |= size | IGC_TXD_DCMD;
  1261		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
  1262	
  1263		if (first->tx_flags & IGC_TX_FLAGS_ONESTEP_SYNC)
> 1264			tx_desc->read.cmd_type_len |= IGC_ADVTXD_ONESTEP;
  1265	
  1266		netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
  1267	
  1268		/* set the timestamp */
  1269		first->time_stamp = jiffies;
  1270	
  1271		skb_tx_timestamp(skb);
  1272	
  1273		/* Force memory writes to complete before letting h/w know there
  1274		 * are new descriptors to fetch.  (Only applicable for weak-ordered
  1275		 * memory model archs, such as IA-64).
  1276		 *
  1277		 * We also need this memory barrier to make certain all of the
  1278		 * status bits have been updated before next_to_watch is written.
  1279		 */
  1280		wmb();
  1281	
  1282		/* set next_to_watch value indicating a packet is present */
  1283		first->next_to_watch = tx_desc;
  1284	
  1285		i++;
  1286		if (i == tx_ring->count)
  1287			i = 0;
  1288	
  1289		tx_ring->next_to_use = i;
  1290	
  1291		/* Make sure there is space in the ring for the next send. */
  1292		igc_maybe_stop_tx(tx_ring, DESC_NEEDED);
  1293	
  1294		if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more()) {
  1295			writel(i, tx_ring->tail);
  1296		}
  1297	
  1298		return 0;
  1299	dma_error:
  1300		netdev_err(tx_ring->netdev, "TX DMA map failed\n");
  1301		tx_buffer = &tx_ring->tx_buffer_info[i];
  1302	
  1303		/* clear dma mappings for failed tx_buffer_info map */
  1304		while (tx_buffer != first) {
  1305			if (dma_unmap_len(tx_buffer, len))
  1306				igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
  1307	
  1308			if (i-- == 0)
  1309				i += tx_ring->count;
  1310			tx_buffer = &tx_ring->tx_buffer_info[i];
  1311		}
  1312	
  1313		if (dma_unmap_len(tx_buffer, len))
  1314			igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
  1315	
  1316		dev_kfree_skb_any(tx_buffer->skb);
  1317		tx_buffer->skb = NULL;
  1318	
  1319		tx_ring->next_to_use = i;
  1320	
  1321		return -1;
  1322	}
  1323	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
