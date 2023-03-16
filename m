Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57F6BDD32
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjCPXu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPXuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:50:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B672D56;
        Thu, 16 Mar 2023 16:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679010652; x=1710546652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HYh2yjwxxolCh/KcrNvRu0dI0MlLh3G+ulItT32xy3w=;
  b=R4e5UE61YVWrdYSwnNseilpRPqHF417yOaewHZ8XHKOHLWPunGU9+Jdf
   r06AfBFAD9z+feER2dphpR3nj47+wQoGxett4QYrMPXIaQ7akABtlhS6U
   9erL9xFPz2bWTyRa7ExzUb2S1T8mQ2H4MVoctRgBr3q4npwfx6eewi/A8
   2ORYMJUxs7gOVwWYJKplSQT2zVHJoMfnnkHwHJZW4KRej9QezHM0mKSvx
   zQ6omlSfN7B9bh+kX+R/JY6vivXOX4/+5hbrpPWe0CD33WtDgM3xCxLov
   C95cX+qnUGulnSjcNzgxkUIwQfOSbWl46OIvVFamGmO0zrBDvImTufyUA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317795084"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="317795084"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 16:50:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657367445"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657367445"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 16:50:47 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcxMs-0008ta-26;
        Thu, 16 Mar 2023 23:50:46 +0000
Date:   Fri, 17 Mar 2023 07:50:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        davem@davemloft.net
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <202303170733.ZQbJFE5x-lkp@intel.com>
References: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230316-214315
patch link:    https://lore.kernel.org/r/20230316131526.283569-2-aleksandr.mikhalitsyn%40canonical.com
patch subject: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
config: s390-buildonly-randconfig-r002-20230312 (https://download.01.org/0day-ci/archive/20230317/202303170733.ZQbJFE5x-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/41687b4ae0dcef1fdffd656e533f9f35214043d0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230316-214315
        git checkout 41687b4ae0dcef1fdffd656e533f9f35214043d0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303170733.ZQbJFE5x-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
>> ERROR: modpost: "pidfd_create" [net/unix/unix.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
