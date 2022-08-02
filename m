Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6899587741
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 08:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiHBGuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 02:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiHBGuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 02:50:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA12735;
        Mon,  1 Aug 2022 23:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659423013; x=1690959013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Em4r8waKeUhhrtXpfrHO7VA66HUnkdX4I+KJBKy59zY=;
  b=i9m2hzue420/jzXqaKcUqPJ/s+kZH3bwfmekhGRIv6N8j20sJGYxf4wU
   1BbpCPgCdoyf19YUMSsFaYZiZmfvv+7TFDio7pUuBHMpJAOsm70klRZTH
   ghRS3YTdQcFqtH+ZcaaCcEJErb34r4Zvn0bHsqsCTsiUi/vxEY16p1Ucq
   uZ3Ku4T17Oqj5mvZGHTpJw6dcoDIxtcAj8wZbGf4+c9SCaklW4lOi9YJR
   UR2Dn/WhxcLqnmENkGHTSfsDBHO/fKAfd5JJfKljvDQuwUK0dG6jK+AZz
   1z74Z9a9cuSxLu5rVP2yBBwK7L8+1i04wwBFOMbb2pIuz7Lvahk6r+I3V
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="351045286"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="351045286"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 23:50:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="744561851"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2022 23:50:08 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIljD-000Fn7-39;
        Tue, 02 Aug 2022 06:50:07 +0000
Date:   Tue, 2 Aug 2022 14:49:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gautam Menghani <gautammenghani201@gmail.com>,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     kbuild-all@lists.01.org,
        Gautam Menghani <gautammenghani201@gmail.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] selftests/net: Refactor xfrm_fill_key() to use array of
 structs
Message-ID: <202208021442.LI0ioKrz-lkp@intel.com>
References: <20220731170316.71542-1-gautammenghani201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220731170316.71542-1-gautammenghani201@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gautam,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on klassert-ipsec-next/master]
[also build test WARNING on klassert-ipsec/master net-next/master net/master linus/master v5.19 next-20220728]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Menghani/selftests-net-Refactor-xfrm_fill_key-to-use-array-of-structs/20220801-010446
base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/deea0844458f9991c45aff2949b7180a95105752
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Gautam-Menghani/selftests-net-Refactor-xfrm_fill_key-to-use-array-of-structs/20220801-010446
        git checkout deea0844458f9991c45aff2949b7180a95105752
        make O=/tmp/kselftest headers
        make O=/tmp/kselftest -C tools/testing/selftests

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> ipsec.c:83:1: warning: useless storage class specifier in empty declaration
      83 | };
         | ^
   ipsec.c: In function 'xfrm_fill_key':
>> ipsec.c:812:13: warning: unused variable 'i' [-Wunused-variable]
     812 |         int i = 0;
         |             ^

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
