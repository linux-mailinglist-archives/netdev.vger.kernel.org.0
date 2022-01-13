Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449C548DA29
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 15:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiAMOwB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 09:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiAMOwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 09:52:00 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2B7C06161C;
        Thu, 13 Jan 2022 06:51:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 696502000F;
        Thu, 13 Jan 2022 14:51:56 +0000 (UTC)
Date:   Thu, 13 Jan 2022 15:51:54 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>
Subject: Re: [wpan-next v2 19/27] net: ieee802154: Full PAN management
Message-ID: <20220113155154.243c36ad@xps13>
In-Reply-To: <202201130436.44AM2OXA-lkp@intel.com>
References: <20220112173312.764660-20-miquel.raynal@bootlin.com>
        <202201130436.44AM2OXA-lkp@intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


lkp@intel.com wrote on Thu, 13 Jan 2022 04:46:11 +0800:

> Hi Miquel,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.16 next-20220112]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Miquel-Raynal/IEEE-802-15-4-scan-support/20220113-013731
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git daadb3bd0e8d3e317e36bc2c1542e86c528665e5
> config: riscv-randconfig-r042-20220112 (https://download.01.org/0day-ci/archive/20220113/202201130436.44AM2OXA-lkp@intel.com/config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 244dd2913a43a200f5a6544d424cdc37b771028b)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/9c8fbd918a704432bbf6cdce1d111e9002c756b4
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Miquel-Raynal/IEEE-802-15-4-scan-support/20220113-013731
>         git checkout 9c8fbd918a704432bbf6cdce1d111e9002c756b4
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/ieee802154/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> net/ieee802154/nl802154.c:1613:8: error: implicit declaration of function 'nl802154_prepare_wpan_dev_dump' [-Werror,-Wimplicit-function-declaration]  
>            err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);
>                  ^
> >> net/ieee802154/nl802154.c:1637:2: error: implicit declaration of function 'nl802154_finish_wpan_dev_dump' [-Werror,-Wimplicit-function-declaration]  
>            nl802154_finish_wpan_dev_dump(rdev);

These two helpers were defined within the experimental section. I will
move them out of this section now that they have other users than
experimental code.

>            ^
>    net/ieee802154/nl802154.c:1637:2: note: did you mean 'nl802154_prepare_wpan_dev_dump'?
>    net/ieee802154/nl802154.c:1613:8: note: 'nl802154_prepare_wpan_dev_dump' declared here
>            err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);
>                  ^
>    2 errors generated.
> 
> 
> vim +/nl802154_prepare_wpan_dev_dump +1613 net/ieee802154/nl802154.c
> 
>   1605	
>   1606	static int nl802154_dump_pans(struct sk_buff *skb, struct netlink_callback *cb)
>   1607	{
>   1608		struct cfg802154_registered_device *rdev;
>   1609		struct cfg802154_internal_pan *pan;
>   1610		struct wpan_dev *wpan_dev;
>   1611		int err;
>   1612	
> > 1613		err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);  
>   1614		if (err)
>   1615			return err;
>   1616	
>   1617		spin_lock_bh(&rdev->pan_lock);
>   1618	
>   1619		if (cb->args[2])
>   1620			goto out;
>   1621	
>   1622		cb->seq = rdev->pan_generation;
>   1623	
>   1624		ieee802154_for_each_pan(pan, rdev) {
>   1625			err = nl802154_send_pan_info(skb, cb, cb->nlh->nlmsg_seq,
>   1626						     NLM_F_MULTI, rdev, wpan_dev, pan);
>   1627			if (err < 0)
>   1628				goto out_err;
>   1629		}
>   1630	
>   1631		cb->args[2] = 1;
>   1632	out:
>   1633		err = skb->len;
>   1634	out_err:
>   1635		spin_unlock_bh(&rdev->pan_lock);
>   1636	
> > 1637		nl802154_finish_wpan_dev_dump(rdev);  
>   1638	
>   1639		return err;
>   1640	}
>   1641	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


Thanks,
Miquèl
