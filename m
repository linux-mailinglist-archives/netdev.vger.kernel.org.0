Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E80B59235C
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiHNQLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 12:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiHNQLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 12:11:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC861AF0EF;
        Sun, 14 Aug 2022 08:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660492208; x=1692028208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l8q2uJASo+mAw7kilK4iHdZM4BYU3gWbDOJqH1aJatA=;
  b=Bjqzfk8XjFYOcv8d9psK9w0waiMfQNAdyYnYxHNuxk3EdUSMjJQAc4xk
   Mb7rpvy3tKGnSwxL5INnkNCF+AfO1uC8mxlfMzu1BjJj7uqU7WtdnoVuW
   OJ72H0nGPEtA7isb5ZkyioYhrxYe+JIzefIEvc5bNz34jY+MT8LUx/XJ6
   FDWafX5WQRQch7GiaUmvswhx3UlYrQxnt8oDcCvArRmHzKMUd2YLEpnin
   zEZy1xuXE1wOmrmfF+f2E1PjIYHtJa+uaGxR9URXDmHEmLfGP4b0PGeSV
   ITZL7OwI3W+idZdsvTUIHrWtB9gpHHSNZ4xxfOXwbdYXXVtD9PBJQkz/D
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="292630808"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="292630808"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 08:50:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="674589370"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 14 Aug 2022 08:50:02 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNFsI-0000FL-0d;
        Sun, 14 Aug 2022 15:50:02 +0000
Date:   Sun, 14 Aug 2022 23:49:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/6] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Message-ID: <202208142332.WUqM9sfv-lkp@intel.com>
References: <20220726201600.1715505-5-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726201600.1715505-5-dima@arista.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 058affafc65a74cf54499fb578b66ad0b18f939b]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-crypto-Introduce-crypto_pool/20220727-041830
base:   058affafc65a74cf54499fb578b66ad0b18f939b
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20220814/202208142332.WUqM9sfv-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a4ee3ecdaada036ed6747ed86eaf7270d3f27bab
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-crypto-Introduce-crypto_pool/20220727-041830
        git checkout a4ee3ecdaada036ed6747ed86eaf7270d3f27bab
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/tcp_ipv4.c:1174:5: warning: no previous prototype for '__tcp_md5_do_add' [-Wmissing-prototypes]
    1174 | int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
         |     ^~~~~~~~~~~~~~~~


vim +/__tcp_md5_do_add +1174 net/ipv4/tcp_ipv4.c

  1172	
  1173	/* This can be called on a newly created socket, from other files */
> 1174	int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
  1175			     int family, u8 prefixlen, int l3index, u8 flags,
  1176			     const u8 *newkey, u8 newkeylen, gfp_t gfp)
  1177	{
  1178		/* Add Key to the list */
  1179		struct tcp_md5sig_key *key;
  1180		struct tcp_sock *tp = tcp_sk(sk);
  1181		struct tcp_md5sig_info *md5sig;
  1182	
  1183		key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index, flags);
  1184		if (key) {
  1185			/* Pre-existing entry - just update that one.
  1186			 * Note that the key might be used concurrently.
  1187			 * data_race() is telling kcsan that we do not care of
  1188			 * key mismatches, since changing MD5 key on live flows
  1189			 * can lead to packet drops.
  1190			 */
  1191			data_race(memcpy(key->key, newkey, newkeylen));
  1192	
  1193			/* Pairs with READ_ONCE() in tcp_md5_hash_key().
  1194			 * Also note that a reader could catch new key->keylen value
  1195			 * but old key->key[], this is the reason we use __GFP_ZERO
  1196			 * at sock_kmalloc() time below these lines.
  1197			 */
  1198			WRITE_ONCE(key->keylen, newkeylen);
  1199	
  1200			return 0;
  1201		}
  1202	
  1203		md5sig = rcu_dereference_protected(tp->md5sig_info,
  1204						   lockdep_sock_is_held(sk));
  1205	
  1206		key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
  1207		if (!key)
  1208			return -ENOMEM;
  1209		if (!tcp_alloc_md5sig_pool()) {
  1210			sock_kfree_s(sk, key, sizeof(*key));
  1211			return -ENOMEM;
  1212		}
  1213	
  1214		memcpy(key->key, newkey, newkeylen);
  1215		key->keylen = newkeylen;
  1216		key->family = family;
  1217		key->prefixlen = prefixlen;
  1218		key->l3index = l3index;
  1219		key->flags = flags;
  1220		memcpy(&key->addr, addr,
  1221		       (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6) ? sizeof(struct in6_addr) :
  1222									 sizeof(struct in_addr));
  1223		hlist_add_head_rcu(&key->node, &md5sig->head);
  1224		return 0;
  1225	}
  1226	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
