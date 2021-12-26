Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7DF47F4EA
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 03:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhLZCSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 21:18:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:8365 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhLZCSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Dec 2021 21:18:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640485112; x=1672021112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F8a1db9CnJlauaxlB9/rliJQ6nfO5YgXrbHPnMlTle4=;
  b=RPM4AYQJCjri88X4GqtY/X2VCOiO79dIMsV/4r7y1HI6nu1ecFqxgEQZ
   jWiorARRn/C0TX3QiTm13Yjrk6azCenN4pl/hMUIXPSQo8P8ST8ZYAK3x
   rGXWZQsVSf/JmFz5321wFcZafm54Lnt72O5pWRMPVcFi6Um1WnFFZVnoJ
   a67XQ/qORjadEufOs1JgrcfgSDjisx60Ib/gig8SUkrFVzAEj21+tNbW0
   1mZdE0WEGAl697Op5e0NdxcRr2uo9UYw6nrhEoV85R9KhNTXBnUV2My7Q
   WAUQr6n37OKqiWpl+yfugPfw5oFf+tet0HlS5gDours7Pdxp9scto9Z2E
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10208"; a="238616990"
X-IronPort-AV: E=Sophos;i="5.88,236,1635231600"; 
   d="scan'208";a="238616990"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2021 18:18:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,236,1635231600"; 
   d="scan'208";a="553078834"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 25 Dec 2021 18:18:28 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n1J7D-0004vt-1o; Sun, 26 Dec 2021 02:18:27 +0000
Date:   Sun, 26 Dec 2021 10:18:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yan Yan <evitayan@google.com>, steffen.klassert@secunet.com
Cc:     kbuild-all@lists.01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org, nharold@google.com,
        benedictwong@google.com, maze@google.com, lorenzo@google.com,
        Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v1 2/2] xfrm: Fix xfrm migrate issues when address family
 changes
Message-ID: <202112261010.hDTqK3oK-lkp@intel.com>
References: <20211223004555.1284666-3-evitayan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223004555.1284666-3-evitayan@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on klassert-ipsec-next/master]
[also build test WARNING on klassert-ipsec/master net-next/master net/master v5.16-rc6 next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Yan-Yan/Fix-issues-in-xfrm_migrate/20211223-084725
base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20211226/202112261010.hDTqK3oK-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/11348c1b6c9b3af9e634611c97eabadb35dffcef
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Yan-Yan/Fix-issues-in-xfrm_migrate/20211223-084725
        git checkout 11348c1b6c9b3af9e634611c97eabadb35dffcef
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/gpio/ kernel/bpf/ net/key/ net/sched/ net/xfrm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/xfrm/xfrm_state.c: In function 'xfrm_state_clone2':
>> net/xfrm/xfrm_state.c:1594:10: warning: returning 'int' from a function with return type 'int *' makes pointer from integer without a cast [-Wint-conversion]
    1594 |   return err;
         |          ^~~
   net/xfrm/xfrm_state.c: In function 'xfrm_state_migrate':
>> net/xfrm/xfrm_state.c:1675:31: warning: ordered comparison of pointer with integer zero [-Wextra]
    1675 |  if (xfrm_state_clone2(x, xc) < 0)
         |                               ^


vim +1594 net/xfrm/xfrm_state.c

  1588	
  1589	static int *xfrm_state_clone2(struct xfrm_state *orig,
  1590				      struct xfrm_state *x)
  1591	{
  1592		int err = xfrm_init_state(x);
  1593		if (err < 0)
> 1594			return err;
  1595	
  1596		x->props.flags = orig->props.flags;
  1597		x->props.extra_flags = orig->props.extra_flags;
  1598	
  1599		x->if_id = orig->if_id;
  1600		x->tfcpad = orig->tfcpad;
  1601		x->replay_maxdiff = orig->replay_maxdiff;
  1602		x->replay_maxage = orig->replay_maxage;
  1603		memcpy(&x->curlft, &orig->curlft, sizeof(x->curlft));
  1604		x->km.state = orig->km.state;
  1605		x->km.seq = orig->km.seq;
  1606		x->replay = orig->replay;
  1607		x->preplay = orig->preplay;
  1608	
  1609		return 0;
  1610	}
  1611	
  1612	struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
  1613					           u32 if_id)
  1614	{
  1615		unsigned int h;
  1616		struct xfrm_state *x = NULL;
  1617	
  1618		spin_lock_bh(&net->xfrm.xfrm_state_lock);
  1619	
  1620		if (m->reqid) {
  1621			h = xfrm_dst_hash(net, &m->old_daddr, &m->old_saddr,
  1622					  m->reqid, m->old_family);
  1623			hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
  1624				if (x->props.mode != m->mode ||
  1625				    x->id.proto != m->proto)
  1626					continue;
  1627				if (m->reqid && x->props.reqid != m->reqid)
  1628					continue;
  1629				if (if_id != 0 && x->if_id != if_id)
  1630					continue;
  1631				if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
  1632						     m->old_family) ||
  1633				    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
  1634						     m->old_family))
  1635					continue;
  1636				xfrm_state_hold(x);
  1637				break;
  1638			}
  1639		} else {
  1640			h = xfrm_src_hash(net, &m->old_daddr, &m->old_saddr,
  1641					  m->old_family);
  1642			hlist_for_each_entry(x, net->xfrm.state_bysrc+h, bysrc) {
  1643				if (x->props.mode != m->mode ||
  1644				    x->id.proto != m->proto)
  1645					continue;
  1646				if (if_id != 0 && x->if_id != if_id)
  1647					continue;
  1648				if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
  1649						     m->old_family) ||
  1650				    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
  1651						     m->old_family))
  1652					continue;
  1653				xfrm_state_hold(x);
  1654				break;
  1655			}
  1656		}
  1657	
  1658		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
  1659	
  1660		return x;
  1661	}
  1662	EXPORT_SYMBOL(xfrm_migrate_state_find);
  1663	
  1664	struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
  1665					      struct xfrm_migrate *m,
  1666					      struct xfrm_encap_tmpl *encap)
  1667	{
  1668		struct xfrm_state *xc;
  1669	
  1670		xc = xfrm_state_clone1(x, encap);
  1671		if (!xc)
  1672			return NULL;
  1673	
  1674		xc->props.family = m->new_family;
> 1675		if (xfrm_state_clone2(x, xc) < 0)
  1676			goto error;
  1677	
  1678		memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
  1679		memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
  1680	
  1681		/* add state */
  1682		if (xfrm_addr_equal(&x->id.daddr, &m->new_daddr, m->new_family)) {
  1683			/* a care is needed when the destination address of the
  1684			   state is to be updated as it is a part of triplet */
  1685			xfrm_state_insert(xc);
  1686		} else {
  1687			if (xfrm_state_add(xc) < 0)
  1688				goto error;
  1689		}
  1690	
  1691		return xc;
  1692	error:
  1693		xfrm_state_put(xc);
  1694		return NULL;
  1695	}
  1696	EXPORT_SYMBOL(xfrm_state_migrate);
  1697	#endif
  1698	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
