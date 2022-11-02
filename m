Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC0615E7C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiKBI50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKBI5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:57:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277951D66F;
        Wed,  2 Nov 2022 01:57:24 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2LPB4YpzzmVJP;
        Wed,  2 Nov 2022 16:57:18 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:57:22 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:57:21 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH net] net/sonic: use dma_mapping_error() for error check
To:     kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Finn Thain <fthain@linux-m68k.org>
CC:     <oe-kbuild-all@lists.linux.dev>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1667221322-8317-1-git-send-email-zhangchangzhong@huawei.com>
 <202211020656.lUqIfDPj-lkp@intel.com>
Message-ID: <66483ea1-2cde-c573-3316-264f9af23cf5@huawei.com>
Date:   Wed, 2 Nov 2022 16:57:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <202211020656.lUqIfDPj-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/2 7:04, kernel test robot wrote:
> Hi Zhang,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on net/master]
> 

Sorry, my fault! I forgot to check my kernel config when building.

Thanks,
Changzhong

> url:    https://github.com/intel-lab-lkp/linux/commits/Zhang-Changzhong/net-sonic-use-dma_mapping_error-for-error-check/20221031-204340
> patch link:    https://lore.kernel.org/r/1667221322-8317-1-git-send-email-zhangchangzhong%40huawei.com
> patch subject: [PATCH net] net/sonic: use dma_mapping_error() for error check
> config: mips-jazz_defconfig
> compiler: mipsel-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/837273d17ba29bbc661c5c82432e83ce4198200a
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Zhang-Changzhong/net-sonic-use-dma_mapping_error-for-error-check/20221031-204340
>         git checkout 837273d17ba29bbc661c5c82432e83ce4198200a
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from drivers/net/ethernet/natsemi/jazzsonic.c:228:
>    drivers/net/ethernet/natsemi/sonic.c: In function 'sonic_send_packet':
>    drivers/net/ethernet/natsemi/sonic.c:295:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
>      295 |         if (dma_mapping_error(lp->device, laddr))
>          |         ^~
>    drivers/net/ethernet/natsemi/sonic.c:297:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
>      297 |                 dev_kfree_skb_any(skb);
>          |                 ^~~~~~~~~~~~~~~~~
>    drivers/net/ethernet/natsemi/sonic.c:279:23: warning: unused variable 'flags' [-Wunused-variable]
>      279 |         unsigned long flags;
>          |                       ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:278:13: warning: unused variable 'entry' [-Wunused-variable]
>      278 |         int entry;
>          |             ^~~~~
>    In file included from include/linux/kref.h:16,
>                     from include/linux/mm_types.h:8,
>                     from include/linux/buildid.h:5,
>                     from include/linux/module.h:14,
>                     from drivers/net/ethernet/natsemi/jazzsonic.c:23:
>    drivers/net/ethernet/natsemi/sonic.c: At top level:
>    include/linux/spinlock.h:379:1: error: expected identifier or '(' before 'do'
>      379 | do {                                                            \
>          | ^~
>    drivers/net/ethernet/natsemi/sonic.c:301:9: note: in expansion of macro 'spin_lock_irqsave'
>      301 |         spin_lock_irqsave(&lp->lock, flags);
>          |         ^~~~~~~~~~~~~~~~~
>    include/linux/spinlock.h:381:3: error: expected identifier or '(' before 'while'
>      381 | } while (0)
>          |   ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:301:9: note: in expansion of macro 'spin_lock_irqsave'
>      301 |         spin_lock_irqsave(&lp->lock, flags);
>          |         ^~~~~~~~~~~~~~~~~
>    drivers/net/ethernet/natsemi/sonic.c:303:9: warning: data definition has no type or storage class
>      303 |         entry = (lp->eol_tx + 1) & SONIC_TDS_MASK;
>          |         ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:303:9: error: type defaults to 'int' in declaration of 'entry' [-Werror=implicit-int]
>    drivers/net/ethernet/natsemi/sonic.c:303:18: error: 'lp' undeclared here (not in a function); did you mean 'up'?
>      303 |         entry = (lp->eol_tx + 1) & SONIC_TDS_MASK;
>          |                  ^~
>          |                  up
>    drivers/net/ethernet/natsemi/sonic.c:305:34: error: expected ')' before numeric constant
>      305 |         sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:306:34: error: expected ')' before numeric constant
>      306 |         sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:307:34: error: expected ')' before numeric constant
>      307 |         sonic_tda_put(dev, entry, SONIC_TD_PKTSIZE, length); /* length of packet */
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:308:34: error: expected ')' before numeric constant
>      308 |         sonic_tda_put(dev, entry, SONIC_TD_FRAG_PTR_L, laddr & 0xffff);
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:309:34: error: expected ')' before numeric constant
>      309 |         sonic_tda_put(dev, entry, SONIC_TD_FRAG_PTR_H, laddr >> 16);
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:310:34: error: expected ')' before numeric constant
>      310 |         sonic_tda_put(dev, entry, SONIC_TD_FRAG_SIZE, length);
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:311:34: error: expected ')' before numeric constant
>      311 |         sonic_tda_put(dev, entry, SONIC_TD_LINK,
>          |                                  ^
>          |                                  )
>    drivers/net/ethernet/natsemi/sonic.c:314:30: error: expected ')' before '->' token
>      314 |         sonic_tda_put(dev, lp->eol_tx, SONIC_TD_LINK, ~SONIC_EOL &
>          |                              ^~
>          |                              )
>    In file included from include/linux/skbuff.h:45,
>                     from include/net/net_namespace.h:43,
>                     from include/linux/netdevice.h:38,
>                     from drivers/net/ethernet/natsemi/jazzsonic.c:33:
>    include/net/net_debug.h:123:2: error: expected identifier or '(' before '{' token
>      123 | ({                                                                      \
>          |  ^
>    drivers/net/ethernet/natsemi/sonic.c:317:9: note: in expansion of macro 'netif_dbg'
>      317 |         netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
>          |         ^~~~~~~~~
>>> drivers/net/ethernet/natsemi/jazzsonic.c:59:1: error: expected identifier or '(' before 'do'
>       59 | do {                                                                    \
>          | ^~
>    drivers/net/ethernet/natsemi/sonic.c:319:9: note: in expansion of macro 'SONIC_WRITE'
>      319 |         SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
>          |         ^~~~~~~~~~~
>>> drivers/net/ethernet/natsemi/jazzsonic.c:61:3: error: expected identifier or '(' before 'while'
>       61 | } while (0)
>          |   ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:319:9: note: in expansion of macro 'SONIC_WRITE'
>      319 |         SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
>          |         ^~~~~~~~~~~
>    drivers/net/ethernet/natsemi/sonic.c:321:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
>      321 |         lp->tx_len[entry] = length;
>          |           ^~
>    drivers/net/ethernet/natsemi/sonic.c:322:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
>      322 |         lp->tx_laddr[entry] = laddr;
>          |           ^~
>    drivers/net/ethernet/natsemi/sonic.c:323:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
>      323 |         lp->tx_skb[entry] = skb;
>          |           ^~
>    drivers/net/ethernet/natsemi/sonic.c:325:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
>      325 |         lp->eol_tx = entry;
>          |           ^~
>    drivers/net/ethernet/natsemi/sonic.c:327:9: warning: data definition has no type or storage class
>      327 |         entry = (entry + 1) & SONIC_TDS_MASK;
>          |         ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:327:9: error: type defaults to 'int' in declaration of 'entry' [-Werror=implicit-int]
>    drivers/net/ethernet/natsemi/sonic.c:327:9: error: redefinition of 'entry'
>    drivers/net/ethernet/natsemi/sonic.c:303:9: note: previous definition of 'entry' with type 'int'
>      303 |         entry = (lp->eol_tx + 1) & SONIC_TDS_MASK;
>          |         ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:327:17: error: initializer element is not constant
>      327 |         entry = (entry + 1) & SONIC_TDS_MASK;
>          |                 ^
>    drivers/net/ethernet/natsemi/sonic.c:328:9: error: expected identifier or '(' before 'if'
>      328 |         if (lp->tx_skb[entry]) {
>          |         ^~
>    drivers/net/ethernet/natsemi/sonic.c:335:32: error: expected declaration specifiers or '...' before '&' token
>      335 |         spin_unlock_irqrestore(&lp->lock, flags);
>          |                                ^
>    drivers/net/ethernet/natsemi/sonic.c:335:43: error: unknown type name 'flags'
>      335 |         spin_unlock_irqrestore(&lp->lock, flags);
>          |                                           ^~~~~
>    drivers/net/ethernet/natsemi/sonic.c:337:9: error: expected identifier or '(' before 'return'
>      337 |         return NETDEV_TX_OK;
>          |         ^~~~~~
>    drivers/net/ethernet/natsemi/sonic.c:338:1: error: expected identifier or '(' before '}' token
>      338 | }
>          | ^
>    cc1: some warnings being treated as errors
> 
> 
> vim +59 drivers/net/ethernet/natsemi/jazzsonic.c
> 
> ^1da177e4c3f41 drivers/net/jazzsonic.c Linus Torvalds 2005-04-16  57  
> ^1da177e4c3f41 drivers/net/jazzsonic.c Linus Torvalds 2005-04-16  58  #define SONIC_WRITE(reg,val)						\
> ^1da177e4c3f41 drivers/net/jazzsonic.c Linus Torvalds 2005-04-16 @59  do {									\
> efcce839360fb3 drivers/net/jazzsonic.c Finn Thain     2005-08-20  60  	*((volatile unsigned int *)dev->base_addr+(reg)) = (val);		\
> ^1da177e4c3f41 drivers/net/jazzsonic.c Linus Torvalds 2005-04-16 @61  } while (0)
> ^1da177e4c3f41 drivers/net/jazzsonic.c Linus Torvalds 2005-04-16  62  
> 
