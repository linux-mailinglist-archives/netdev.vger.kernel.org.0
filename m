Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59235526BF
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiFTVyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 17:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiFTVyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 17:54:20 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED218193F9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655762059; x=1687298059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0JR6eZaYO0lwUct58e6J+5/K6jVC4SVMcnGGDo8RHkE=;
  b=gMP/cMW85EoqpWn29Dq2JU8UB4Bp5cvmWP1a/exqLVry3XOllqSUfYHs
   nlOjwvocED+tAnFS2Uun8Zr+UuLcE5xqHBXLkLrN9sKi891rW/ksdvy61
   7fR9BwpfkRsj+ms0zpqs9ju6JS5KRTzmUSevxE3syW6NgQMfPPsbLwb14
   w=;
X-IronPort-AV: E=Sophos;i="5.92,207,1650931200"; 
   d="scan'208";a="99846558"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 20 Jun 2022 21:54:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 3D20881B35;
        Mon, 20 Jun 2022 21:54:02 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 21:54:01 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.51) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 21:53:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <lkp@intel.com>
CC:     <aams@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kbuild-all@lists.01.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 6/6] af_unix: Remove unix_table_locks.
Date:   Mon, 20 Jun 2022 14:53:46 -0700
Message-ID: <20220620215346.97665-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <202206210532.q32y1W52-lkp@intel.com>
References: <202206210532.q32y1W52-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.51]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   kernel test robot <lkp@intel.com>
Date:   Tue, 21 Jun 2022 05:39:37 +0800
> Hi Kuniyuki,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220621-025503
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
> config: arc-defconfig (https://download.01.org/0day-ci/archive/20220621/202206210532.q32y1W52-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/f2cd3aee6929543114a0728717969d9bb2f6fa90
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220621-025503
>         git checkout f2cd3aee6929543114a0728717969d9bb2f6fa90
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    net/unix/diag.c: In function 'unix_lookup_by_ino':
> >> net/unix/diag.c:247:46: error: 'unix_table_locks' undeclared (first use in this function); did you mean 'unix_state_lock'?
>      247 |                                 spin_unlock(&unix_table_locks[i]);
>          |                                              ^~~~~~~~~~~~~~~~
>          |                                              unix_state_lock
>    net/unix/diag.c:247:46: note: each undeclared identifier is reported only once for each function it appears in

I'm sorry, CONFIG_UNIX_DIAG was not set in my .config.
I'll respin v3.

Best regards,
Kuniyuki


> vim +247 net/unix/diag.c
> 
> 22931d3b906cd0 Pavel Emelyanov   2011-12-15  235  
> a50feb1de03567 Kuniyuki Iwashima 2022-06-20  236  static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  237  {
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  238  	struct sock *sk;
> afd20b9290e184 Kuniyuki Iwashima 2021-11-24  239  	int i;
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  240  
> 614d83f20d005b Kuniyuki Iwashima 2022-06-20  241  	for (i = 0; i < UNIX_HASH_SIZE; i++) {
> a50feb1de03567 Kuniyuki Iwashima 2022-06-20  242  		spin_lock(&net->unx.table.locks[i]);
> 868a38bbd9ad2a Kuniyuki Iwashima 2022-06-20  243  		sk_for_each(sk, &net->unx.table.buckets[i]) {
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  244  			if (ino == sock_i_ino(sk)) {
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  245  				sock_hold(sk);
> a50feb1de03567 Kuniyuki Iwashima 2022-06-20  246  				spin_unlock(&net->unx.table.locks[i]);
> afd20b9290e184 Kuniyuki Iwashima 2021-11-24 @247  				spin_unlock(&unix_table_locks[i]);
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  248  				return sk;
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  249  			}
> 868a38bbd9ad2a Kuniyuki Iwashima 2022-06-20  250  		}
> a50feb1de03567 Kuniyuki Iwashima 2022-06-20  251  		spin_unlock(&net->unx.table.locks[i]);
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  252  	}
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  253  	return NULL;
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  254  }
> 5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  255  
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
