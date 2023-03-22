Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF76C4C0E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCVNlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCVNlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:41:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BAC279AF;
        Wed, 22 Mar 2023 06:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679492508; x=1711028508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D22wytD9rbU2KaRKdwdHM/avd+nOb5IHbZpOTnO3+xQ=;
  b=H3WOBlIz36TXX2RwJq6w/sWofKQPkUdeGJtLHjaNvanBbGlq8Rmy0ExI
   CDMrgznn8myzWBEhYMAny/+J5mcwQ6Q5LIsTYan2wsLt9Thywr0OkVqg6
   tqwL/ekTkj7U3YQvHKdrFQx02Z0+4+tymFWY0IqbQmbhadFsgPet917p4
   jVO8/JRHBjCLE49ZfI/JnobYFsu+35OPpbeGkZfclzk1xepWS1u4V+DCq
   cRD1CDeKNZ0aAmA3cS4D5XmTmc3RcNx4BsLibvSHrj6RgNad6JpaDcsyI
   4w3AjQV2yoBTFE2kKjElo7ByXSoanbzVkV2tZYaOzGeuzIwBQGTcCvAJ3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="336717234"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="336717234"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 06:41:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="675269882"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="675269882"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 22 Mar 2023 06:41:44 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peyih-000DLu-01;
        Wed, 22 Mar 2023 13:41:39 +0000
Date:   Wed, 22 Mar 2023 21:41:01 +0800
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
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <202303222101.avwNiFWQ-lkp@intel.com>
References: <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230322-024808
patch link:    https://lore.kernel.org/r/20230321183342.617114-2-aleksandr.mikhalitsyn%40canonical.com
patch subject: [PATCH net-next v2 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20230322/202303222101.avwNiFWQ-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/491b69039f4479e1e0fb3af635c96989cdd23734
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230322-024808
        git checkout 491b69039f4479e1e0fb3af635c96989cdd23734
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303222101.avwNiFWQ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "pidfd_create" [net/unix/unix.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
