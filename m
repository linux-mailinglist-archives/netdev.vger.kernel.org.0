Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942CC55C3B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbiF0QPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiF0QPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:15:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E29186F7;
        Mon, 27 Jun 2022 09:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656346542; x=1687882542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FfYp8PDWCWRcFUvO4auSfa7g+b3nSackCxZ92UfjdwY=;
  b=dUO9lvHIF9gzAji1CvTSh06N00Hw6IoyGXQX7pJb6vKPeSzVllkkU5sT
   K4NEE9xBUbrawHEuQRm6e6sEG0Y/QCtFGS2AFVb6jioHefZ0bIRiJDHMT
   /cVTS0qqxWUmv1p1f/VoPmiPuncT0FNq9cD3mX54EyLELkpyknsBP1yLk
   dFZhJ5uldAI/HFUB6u+5REO/6/GAkOAhpqSIzEtJ7C2u1Om3kbnZRJIVg
   /WhbrqPzWtDXDZHYE2jVGB5X+AuJ6h8O3QHNin48lXTOCiQh9caFjus4M
   OMSdHQRo9AhMtCMJd0b89w22glY/VBnIWN4IUsWL9VrEsnMovd3mFUQnn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="270227848"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="270227848"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 09:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="646486809"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jun 2022 09:15:37 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o5rOj-0008jp-0h;
        Mon, 27 Jun 2022 16:15:37 +0000
Date:   Tue, 28 Jun 2022 00:15:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     HighW4y2H3ll <huzh@nyu.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        HighW4y2H3ll <huzh@nyu.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix buffer overflow in hinic_devlink.c:hinic_flash_fw
Message-ID: <202206280043.B60ScXNe-lkp@intel.com>
References: <20220617050101.37620-1-huzh@nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617050101.37620-1-huzh@nyu.edu>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi HighW4y2H3ll,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on horms-ipvs/master]
[also build test WARNING on linus/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/HighW4y2H3ll/Fix-buffer-overflow-in-hinic_devlink-c-hinic_flash_fw/20220617-130659
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: arm64-randconfig-r022-20220627 (https://download.01.org/0day-ci/archive/20220628/202206280043.B60ScXNe-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/821efd063fed15fd0bab30b29df0af61d5ba4cac
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review HighW4y2H3ll/Fix-buffer-overflow-in-hinic_devlink-c-hinic_flash_fw/20220617-130659
        git checkout 821efd063fed15fd0bab30b29df0af61d5ba4cac
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/huawei/hinic/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/huawei/hinic/hinic_devlink.c: In function 'hinic_flash_fw':
>> drivers/net/ethernet/huawei/hinic/hinic_devlink.c:176:25: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]
     176 |                         memset(fw_update_msg->data, 0, MAX_FW_FRAGMENT_LEN);
         |                         ^~~~~~


vim +/memset +176 drivers/net/ethernet/huawei/hinic/hinic_devlink.c

5e126e7c4e5275 Luo bin 2020-07-15  123  
5e126e7c4e5275 Luo bin 2020-07-15  124  static int hinic_flash_fw(struct hinic_devlink_priv *priv, const u8 *data,
5e126e7c4e5275 Luo bin 2020-07-15  125  			  struct host_image_st *host_image)
5e126e7c4e5275 Luo bin 2020-07-15  126  {
5e126e7c4e5275 Luo bin 2020-07-15  127  	u32 section_remain_send_len, send_fragment_len, send_pos, up_total_len;
5e126e7c4e5275 Luo bin 2020-07-15  128  	struct hinic_cmd_update_fw *fw_update_msg = NULL;
5e126e7c4e5275 Luo bin 2020-07-15  129  	u32 section_type, section_crc, section_version;
5e126e7c4e5275 Luo bin 2020-07-15  130  	u32 i, len, section_len, section_offset;
5e126e7c4e5275 Luo bin 2020-07-15  131  	u16 out_size = sizeof(*fw_update_msg);
5e126e7c4e5275 Luo bin 2020-07-15  132  	int total_len_flag = 0;
5e126e7c4e5275 Luo bin 2020-07-15  133  	int err;
5e126e7c4e5275 Luo bin 2020-07-15  134  
5e126e7c4e5275 Luo bin 2020-07-15  135  	fw_update_msg = kzalloc(sizeof(*fw_update_msg), GFP_KERNEL);
5e126e7c4e5275 Luo bin 2020-07-15  136  	if (!fw_update_msg)
5e126e7c4e5275 Luo bin 2020-07-15  137  		return -ENOMEM;
5e126e7c4e5275 Luo bin 2020-07-15  138  
5e126e7c4e5275 Luo bin 2020-07-15  139  	up_total_len = host_image->image_info.up_total_len;
5e126e7c4e5275 Luo bin 2020-07-15  140  
5e126e7c4e5275 Luo bin 2020-07-15  141  	for (i = 0; i < host_image->section_type_num; i++) {
5e126e7c4e5275 Luo bin 2020-07-15  142  		len = host_image->image_section_info[i].fw_section_len;
5e126e7c4e5275 Luo bin 2020-07-15  143  		if (host_image->image_section_info[i].fw_section_type ==
5e126e7c4e5275 Luo bin 2020-07-15  144  		    UP_FW_UPDATE_BOOT) {
5e126e7c4e5275 Luo bin 2020-07-15  145  			up_total_len = up_total_len - len;
5e126e7c4e5275 Luo bin 2020-07-15  146  			break;
5e126e7c4e5275 Luo bin 2020-07-15  147  		}
5e126e7c4e5275 Luo bin 2020-07-15  148  	}
5e126e7c4e5275 Luo bin 2020-07-15  149  
5e126e7c4e5275 Luo bin 2020-07-15  150  	for (i = 0; i < host_image->section_type_num; i++) {
5e126e7c4e5275 Luo bin 2020-07-15  151  		section_len =
5e126e7c4e5275 Luo bin 2020-07-15  152  			host_image->image_section_info[i].fw_section_len;
5e126e7c4e5275 Luo bin 2020-07-15  153  		section_offset =
5e126e7c4e5275 Luo bin 2020-07-15  154  			host_image->image_section_info[i].fw_section_offset;
5e126e7c4e5275 Luo bin 2020-07-15  155  		section_remain_send_len = section_len;
5e126e7c4e5275 Luo bin 2020-07-15  156  		section_type =
5e126e7c4e5275 Luo bin 2020-07-15  157  			host_image->image_section_info[i].fw_section_type;
5e126e7c4e5275 Luo bin 2020-07-15  158  		section_crc = host_image->image_section_info[i].fw_section_crc;
5e126e7c4e5275 Luo bin 2020-07-15  159  		section_version =
5e126e7c4e5275 Luo bin 2020-07-15  160  			host_image->image_section_info[i].fw_section_version;
5e126e7c4e5275 Luo bin 2020-07-15  161  
5e126e7c4e5275 Luo bin 2020-07-15  162  		if (section_type == UP_FW_UPDATE_BOOT)
5e126e7c4e5275 Luo bin 2020-07-15  163  			continue;
5e126e7c4e5275 Luo bin 2020-07-15  164  
5e126e7c4e5275 Luo bin 2020-07-15  165  		send_fragment_len = 0;
5e126e7c4e5275 Luo bin 2020-07-15  166  		send_pos = 0;
5e126e7c4e5275 Luo bin 2020-07-15  167  
5e126e7c4e5275 Luo bin 2020-07-15  168  		while (section_remain_send_len > 0) {
5e126e7c4e5275 Luo bin 2020-07-15  169  			if (!total_len_flag) {
5e126e7c4e5275 Luo bin 2020-07-15  170  				fw_update_msg->total_len = up_total_len;
5e126e7c4e5275 Luo bin 2020-07-15  171  				total_len_flag = 1;
5e126e7c4e5275 Luo bin 2020-07-15  172  			} else {
5e126e7c4e5275 Luo bin 2020-07-15  173  				fw_update_msg->total_len = 0;
5e126e7c4e5275 Luo bin 2020-07-15  174  			}
5e126e7c4e5275 Luo bin 2020-07-15  175  
5e126e7c4e5275 Luo bin 2020-07-15 @176  			memset(fw_update_msg->data, 0, MAX_FW_FRAGMENT_LEN);
5e126e7c4e5275 Luo bin 2020-07-15  177  
5e126e7c4e5275 Luo bin 2020-07-15  178  			fw_update_msg->ctl_info.SF =
5e126e7c4e5275 Luo bin 2020-07-15  179  				(section_remain_send_len == section_len) ?
5e126e7c4e5275 Luo bin 2020-07-15  180  				true : false;
5e126e7c4e5275 Luo bin 2020-07-15  181  			fw_update_msg->section_info.FW_section_CRC = section_crc;
5e126e7c4e5275 Luo bin 2020-07-15  182  			fw_update_msg->fw_section_version = section_version;
5e126e7c4e5275 Luo bin 2020-07-15  183  			fw_update_msg->ctl_info.flag = UP_TYPE_A;
5e126e7c4e5275 Luo bin 2020-07-15  184  
5e126e7c4e5275 Luo bin 2020-07-15  185  			if (section_type <= UP_FW_UPDATE_UP_DATA_B) {
5e126e7c4e5275 Luo bin 2020-07-15  186  				fw_update_msg->section_info.FW_section_type =
5e126e7c4e5275 Luo bin 2020-07-15  187  					(section_type % 2) ?
5e126e7c4e5275 Luo bin 2020-07-15  188  					UP_FW_UPDATE_UP_DATA :
5e126e7c4e5275 Luo bin 2020-07-15  189  					UP_FW_UPDATE_UP_TEXT;
5e126e7c4e5275 Luo bin 2020-07-15  190  
5e126e7c4e5275 Luo bin 2020-07-15  191  				fw_update_msg->ctl_info.flag = UP_TYPE_B;
5e126e7c4e5275 Luo bin 2020-07-15  192  				if (section_type <= UP_FW_UPDATE_UP_DATA_A)
5e126e7c4e5275 Luo bin 2020-07-15  193  					fw_update_msg->ctl_info.flag = UP_TYPE_A;
5e126e7c4e5275 Luo bin 2020-07-15  194  			} else {
5e126e7c4e5275 Luo bin 2020-07-15  195  				fw_update_msg->section_info.FW_section_type =
5e126e7c4e5275 Luo bin 2020-07-15  196  					section_type - 0x2;
5e126e7c4e5275 Luo bin 2020-07-15  197  			}
5e126e7c4e5275 Luo bin 2020-07-15  198  
5e126e7c4e5275 Luo bin 2020-07-15  199  			fw_update_msg->setion_total_len = section_len;
5e126e7c4e5275 Luo bin 2020-07-15  200  			fw_update_msg->section_offset = send_pos;
5e126e7c4e5275 Luo bin 2020-07-15  201  
5e126e7c4e5275 Luo bin 2020-07-15  202  			if (section_remain_send_len <= MAX_FW_FRAGMENT_LEN) {
5e126e7c4e5275 Luo bin 2020-07-15  203  				fw_update_msg->ctl_info.SL = true;
5e126e7c4e5275 Luo bin 2020-07-15  204  				fw_update_msg->ctl_info.fragment_len =
5e126e7c4e5275 Luo bin 2020-07-15  205  					section_remain_send_len;
5e126e7c4e5275 Luo bin 2020-07-15  206  				send_fragment_len += section_remain_send_len;
5e126e7c4e5275 Luo bin 2020-07-15  207  			} else {
5e126e7c4e5275 Luo bin 2020-07-15  208  				fw_update_msg->ctl_info.SL = false;
5e126e7c4e5275 Luo bin 2020-07-15  209  				fw_update_msg->ctl_info.fragment_len =
5e126e7c4e5275 Luo bin 2020-07-15  210  					MAX_FW_FRAGMENT_LEN;
5e126e7c4e5275 Luo bin 2020-07-15  211  				send_fragment_len += MAX_FW_FRAGMENT_LEN;
5e126e7c4e5275 Luo bin 2020-07-15  212  			}
5e126e7c4e5275 Luo bin 2020-07-15  213  
5e126e7c4e5275 Luo bin 2020-07-15  214  			memcpy(fw_update_msg->data,
5e126e7c4e5275 Luo bin 2020-07-15  215  			       data + UPDATEFW_IMAGE_HEAD_SIZE +
5e126e7c4e5275 Luo bin 2020-07-15  216  			       section_offset + send_pos,
5e126e7c4e5275 Luo bin 2020-07-15  217  			       fw_update_msg->ctl_info.fragment_len);
5e126e7c4e5275 Luo bin 2020-07-15  218  
5e126e7c4e5275 Luo bin 2020-07-15  219  			err = hinic_port_msg_cmd(priv->hwdev,
5e126e7c4e5275 Luo bin 2020-07-15  220  						 HINIC_PORT_CMD_UPDATE_FW,
5e126e7c4e5275 Luo bin 2020-07-15  221  						 fw_update_msg,
5e126e7c4e5275 Luo bin 2020-07-15  222  						 sizeof(*fw_update_msg),
5e126e7c4e5275 Luo bin 2020-07-15  223  						 fw_update_msg, &out_size);
5e126e7c4e5275 Luo bin 2020-07-15  224  			if (err || !out_size || fw_update_msg->status) {
5e126e7c4e5275 Luo bin 2020-07-15  225  				dev_err(&priv->hwdev->hwif->pdev->dev, "Failed to update firmware, err: %d, status: 0x%x, out size: 0x%x\n",
5e126e7c4e5275 Luo bin 2020-07-15  226  					err, fw_update_msg->status, out_size);
5e126e7c4e5275 Luo bin 2020-07-15  227  				err = fw_update_msg->status ?
5e126e7c4e5275 Luo bin 2020-07-15  228  					fw_update_msg->status : -EIO;
5e126e7c4e5275 Luo bin 2020-07-15  229  				kfree(fw_update_msg);
5e126e7c4e5275 Luo bin 2020-07-15  230  				return err;
5e126e7c4e5275 Luo bin 2020-07-15  231  			}
5e126e7c4e5275 Luo bin 2020-07-15  232  
5e126e7c4e5275 Luo bin 2020-07-15  233  			send_pos = send_fragment_len;
5e126e7c4e5275 Luo bin 2020-07-15  234  			section_remain_send_len = section_len -
5e126e7c4e5275 Luo bin 2020-07-15  235  						  send_fragment_len;
5e126e7c4e5275 Luo bin 2020-07-15  236  		}
5e126e7c4e5275 Luo bin 2020-07-15  237  	}
5e126e7c4e5275 Luo bin 2020-07-15  238  
5e126e7c4e5275 Luo bin 2020-07-15  239  	kfree(fw_update_msg);
5e126e7c4e5275 Luo bin 2020-07-15  240  
5e126e7c4e5275 Luo bin 2020-07-15  241  	return 0;
5e126e7c4e5275 Luo bin 2020-07-15  242  }
5e126e7c4e5275 Luo bin 2020-07-15  243  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
