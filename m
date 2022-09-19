Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C575BD0C6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 17:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiISPWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 11:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiISPWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 11:22:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9403C2601;
        Mon, 19 Sep 2022 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663600907; x=1695136907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kNwt2uWdXdRdyeI/mYyCWyWe8TGe7zKp/jgzp6dU+WE=;
  b=R9x6p/0jSdFBti7lQd3p4EbT15K/C6SK3IXurKmYE13r5QuQmKBj5X4g
   fbTATmso9a31DHcLRNYiA8kE5PCdR61ilN44xhzWnZaqbeLhvwD87x27o
   GNh73RRoiugtaS2jXT9kT8zczssrCQn7TV4YKMNF4UBeqMYFbWenOHYxg
   SEtg977DZmI90yH1HVIN2XVmDzJpGIuU78wE7ujWJj6TxDXO4O7iNEFpr
   6e7IokDEu8z8W5TKnkYBjxS7UT7Ky30K53iGeJZCYk7d9KHiHTbPjClyw
   evXimCY8w5rdYBsghyoRyIm7p4xe3rzzBNBTUvjT6KrcRcbIsF6F++EO1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="300803312"
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="300803312"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 08:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="760908006"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 19 Sep 2022 08:21:43 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oaIad-00023N-0K;
        Mon, 19 Sep 2022 15:21:43 +0000
Date:   Mon, 19 Sep 2022 23:20:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Li Zhong <floridsleeves@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, jgg@ziepe.ca,
        william.xuanziyang@huawei.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net,
        Li Zhong <floridsleeves@gmail.com>
Subject: Re: [PATCH v1] net/8021q/vlan: check the return value of
 vlan_vid_add()
Message-ID: <202209192322.WqMpsD4X-lkp@intel.com>
References: <20220919074600.1576168-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919074600.1576168-1-floridsleeves@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Li,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on net-next/master linus/master v6.0-rc6 next-20220919]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Li-Zhong/net-8021q-vlan-check-the-return-value-of-vlan_vid_add/20220919-154737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 96628951869c0dedf0377adca01c8675172d8639
config: x86_64-randconfig-a005-20220919 (https://download.01.org/0day-ci/archive/20220919/202209192322.WqMpsD4X-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c44a44ed52c467523d28a7764ee01e23d3928945
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Li-Zhong/net-8021q-vlan-check-the-return-value-of-vlan_vid_add/20220919-154737
        git checkout c44a44ed52c467523d28a7764ee01e23d3928945
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/8021q/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/8021q/vlan.c:385:7: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
                   int err = vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
                       ^
   1 warning generated.


vim +385 net/8021q/vlan.c

   359	
   360	static int vlan_device_event(struct notifier_block *unused, unsigned long event,
   361				     void *ptr)
   362	{
   363		struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
   364		struct net_device *dev = netdev_notifier_info_to_dev(ptr);
   365		struct vlan_group *grp;
   366		struct vlan_info *vlan_info;
   367		int i, flgs;
   368		struct net_device *vlandev;
   369		struct vlan_dev_priv *vlan;
   370		bool last = false;
   371		LIST_HEAD(list);
   372		int err;
   373	
   374		if (is_vlan_dev(dev)) {
   375			int err = __vlan_device_event(dev, event);
   376	
   377			if (err)
   378				return notifier_from_errno(err);
   379		}
   380	
   381		if ((event == NETDEV_UP) &&
   382		    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
   383			pr_info("adding VLAN 0 to HW filter on device %s\n",
   384				dev->name);
 > 385			int err = vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
   386	
   387			if (err)
   388				return notifier_from_errno(err);
   389		}
   390		if (event == NETDEV_DOWN &&
   391		    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
   392			vlan_vid_del(dev, htons(ETH_P_8021Q), 0);
   393	
   394		vlan_info = rtnl_dereference(dev->vlan_info);
   395		if (!vlan_info)
   396			goto out;
   397		grp = &vlan_info->grp;
   398	
   399		/* It is OK that we do not hold the group lock right now,
   400		 * as we run under the RTNL lock.
   401		 */
   402	
   403		switch (event) {
   404		case NETDEV_CHANGE:
   405			/* Propagate real device state to vlan devices */
   406			vlan_group_for_each_dev(grp, i, vlandev)
   407				vlan_stacked_transfer_operstate(dev, vlandev,
   408								vlan_dev_priv(vlandev));
   409			break;
   410	
   411		case NETDEV_CHANGEADDR:
   412			/* Adjust unicast filters on underlying device */
   413			vlan_group_for_each_dev(grp, i, vlandev) {
   414				flgs = vlandev->flags;
   415				if (!(flgs & IFF_UP))
   416					continue;
   417	
   418				vlan_sync_address(dev, vlandev);
   419			}
   420			break;
   421	
   422		case NETDEV_CHANGEMTU:
   423			vlan_group_for_each_dev(grp, i, vlandev) {
   424				if (vlandev->mtu <= dev->mtu)
   425					continue;
   426	
   427				dev_set_mtu(vlandev, dev->mtu);
   428			}
   429			break;
   430	
   431		case NETDEV_FEAT_CHANGE:
   432			/* Propagate device features to underlying device */
   433			vlan_group_for_each_dev(grp, i, vlandev)
   434				vlan_transfer_features(dev, vlandev);
   435			break;
   436	
   437		case NETDEV_DOWN: {
   438			struct net_device *tmp;
   439			LIST_HEAD(close_list);
   440	
   441			/* Put all VLANs for this dev in the down state too.  */
   442			vlan_group_for_each_dev(grp, i, vlandev) {
   443				flgs = vlandev->flags;
   444				if (!(flgs & IFF_UP))
   445					continue;
   446	
   447				vlan = vlan_dev_priv(vlandev);
   448				if (!(vlan->flags & VLAN_FLAG_LOOSE_BINDING))
   449					list_add(&vlandev->close_list, &close_list);
   450			}
   451	
   452			dev_close_many(&close_list, false);
   453	
   454			list_for_each_entry_safe(vlandev, tmp, &close_list, close_list) {
   455				vlan_stacked_transfer_operstate(dev, vlandev,
   456								vlan_dev_priv(vlandev));
   457				list_del_init(&vlandev->close_list);
   458			}
   459			list_del(&close_list);
   460			break;
   461		}
   462		case NETDEV_UP:
   463			/* Put all VLANs for this dev in the up state too.  */
   464			vlan_group_for_each_dev(grp, i, vlandev) {
   465				flgs = dev_get_flags(vlandev);
   466				if (flgs & IFF_UP)
   467					continue;
   468	
   469				vlan = vlan_dev_priv(vlandev);
   470				if (!(vlan->flags & VLAN_FLAG_LOOSE_BINDING))
   471					dev_change_flags(vlandev, flgs | IFF_UP,
   472							 extack);
   473				vlan_stacked_transfer_operstate(dev, vlandev, vlan);
   474			}
   475			break;
   476	
   477		case NETDEV_UNREGISTER:
   478			/* twiddle thumbs on netns device moves */
   479			if (dev->reg_state != NETREG_UNREGISTERING)
   480				break;
   481	
   482			vlan_group_for_each_dev(grp, i, vlandev) {
   483				/* removal of last vid destroys vlan_info, abort
   484				 * afterwards */
   485				if (vlan_info->nr_vids == 1)
   486					last = true;
   487	
   488				unregister_vlan_dev(vlandev, &list);
   489				if (last)
   490					break;
   491			}
   492			unregister_netdevice_many(&list);
   493			break;
   494	
   495		case NETDEV_PRE_TYPE_CHANGE:
   496			/* Forbid underlaying device to change its type. */
   497			if (vlan_uses_dev(dev))
   498				return NOTIFY_BAD;
   499			break;
   500	
   501		case NETDEV_NOTIFY_PEERS:
   502		case NETDEV_BONDING_FAILOVER:
   503		case NETDEV_RESEND_IGMP:
   504			/* Propagate to vlan devices */
   505			vlan_group_for_each_dev(grp, i, vlandev)
   506				call_netdevice_notifiers(event, vlandev);
   507			break;
   508	
   509		case NETDEV_CVLAN_FILTER_PUSH_INFO:
   510			err = vlan_filter_push_vids(vlan_info, htons(ETH_P_8021Q));
   511			if (err)
   512				return notifier_from_errno(err);
   513			break;
   514	
   515		case NETDEV_CVLAN_FILTER_DROP_INFO:
   516			vlan_filter_drop_vids(vlan_info, htons(ETH_P_8021Q));
   517			break;
   518	
   519		case NETDEV_SVLAN_FILTER_PUSH_INFO:
   520			err = vlan_filter_push_vids(vlan_info, htons(ETH_P_8021AD));
   521			if (err)
   522				return notifier_from_errno(err);
   523			break;
   524	
   525		case NETDEV_SVLAN_FILTER_DROP_INFO:
   526			vlan_filter_drop_vids(vlan_info, htons(ETH_P_8021AD));
   527			break;
   528		}
   529	
   530	out:
   531		return NOTIFY_DONE;
   532	}
   533	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
