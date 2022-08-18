Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6C0598C4A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345576AbiHRTBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345561AbiHRTBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:01:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBD260519;
        Thu, 18 Aug 2022 12:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660849268; x=1692385268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/uzU0E8lxeXRnqHNkzeua+Yt6mytWG/uTafpsWnGjCw=;
  b=K7SfhjC2OR/h5CDmakVMGzbc9TaJDc50aVWeu+S9OSLYDwuTyAn/KWDA
   ExhmQzG4/OQ/l5G7Wgs9kpaNZG+IVVxS0mfBeFQp0PbLcbY2kHDSk/0Gi
   KxvnFPL5WdpolKuy4mye1+hW3arrzYQ/+9hp4uCcKnlRkUFBBl0vOaf1T
   Z6dXYovIWUvdZL/SF5xBHaispVgZjV4hLSX9qxybiWpqJUYy97V9C78lt
   2d1s0nQcT2Kr6H9QMb1i9dvFBZj7PiroQAPkMO1xyRQ4BrqUbYVNaBmP2
   a7TTdKIu9NyJgxEW/h2K4+zOT0Yo6HgJ6QTVxlDPzTQ4HrZffWvxzqolY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294123575"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294123575"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 12:01:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="711062157"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2022 12:01:03 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOklK-0000Qd-1w;
        Thu, 18 Aug 2022 19:01:02 +0000
Date:   Fri, 19 Aug 2022 03:00:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/31] net/tcp: Add tcp_parse_auth_options()
Message-ID: <202208190256.Kj0PqjuN-lkp@intel.com>
References: <20220818170005.747015-13-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818170005.747015-13-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on e34cfee65ec891a319ce79797dda18083af33a76]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Add-TCP-AO-support/20220819-010628
base:   e34cfee65ec891a319ce79797dda18083af33a76
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220819/202208190256.Kj0PqjuN-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c206ead11e78dec4ec0058427d494521f9d53c3f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Add-TCP-AO-support/20220819-010628
        git checkout c206ead11e78dec4ec0058427d494521f9d53c3f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/tcp_ipv4.c:665:7: warning: "CONFIG_TCP_MD5SIG" is not defined, evaluates to 0 [-Wundef]
     665 | #elif CONFIG_TCP_MD5SIG
         |       ^~~~~~~~~~~~~~~~~


vim +/CONFIG_TCP_MD5SIG +665 net/ipv4/tcp_ipv4.c

   649	
   650	/*
   651	 *	This routine will send an RST to the other tcp.
   652	 *
   653	 *	Someone asks: why I NEVER use socket parameters (TOS, TTL etc.)
   654	 *		      for reset.
   655	 *	Answer: if a packet caused RST, it is not for a socket
   656	 *		existing in our system, if it is matched to a socket,
   657	 *		it is just duplicate segment or bug in other side's TCP.
   658	 *		So that we build reply only basing on parameters
   659	 *		arrived with segment.
   660	 *	Exception: precedence violation. We do not implement it in any case.
   661	 */
   662	
   663	#ifdef CONFIG_TCP_AO
   664	#define OPTION_BYTES MAX_TCP_OPTION_SPACE
 > 665	#elif CONFIG_TCP_MD5SIG
   666	#define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
   667	#else
   668	#define OPTION_BYTES sizeof(__be32)
   669	#endif
   670	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
