Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E587451FCDB
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiEIMdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbiEIMdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:33:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6817F273F48;
        Mon,  9 May 2022 05:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652099360; x=1683635360;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qMvEPRtoB+d3/whBmM3c2zEnnc5nXdnRsTyVqxph14o=;
  b=l8IF8etC+HnM3NycSrq2EyBFo0nnIvGjH1fmlyBsQclF4RUmeRDMc0Hh
   JaatiTlRh3iOWZLvbBWT3DAoUzzq6/AC+nG6P7YOx8B1rLhWjpo6J5ufq
   Kork1mcj3jjL9tMl1EueOnbEYt8mGReqTcaaMVv4bzwW8FkNPxC/2Qm+M
   7RGw+sO/nv40UFfIiJ4WLYgrhUW3ro4OZjc8jDxz9NkIwypsJnCWic+It
   tfdJdIakkP+4yt7QTjKhMCV72AfibfBmppE03BSTQVlymB8ngJZ5h6Pxe
   fspPJ0ZuZe7rs3YU34S8QOTtcm6OBuIhbmPrDwhddRpLhhWZ9JZlh4C1N
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="269172496"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="269172496"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 05:29:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="738142548"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 09 May 2022 05:29:11 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1no2Vi-000GVC-Dp;
        Mon, 09 May 2022 12:29:10 +0000
Date:   Mon, 9 May 2022 20:28:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Cindy Lu <lulu@redhat.com>, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v1] vdpa: Do not count the pages that were already pinned
 in the vhost-vDPA
Message-ID: <202205092058.if9wModg-lkp@intel.com>
References: <20220509071426.155941-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509071426.155941-1-lulu@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cindy,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on mst-vhost/linux-next]
[also build test ERROR on linux/master linus/master v5.18-rc6]
[cannot apply to next-20220506]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Cindy-Lu/vdpa-Do-not-count-the-pages-that-were-already-pinned-in-the-vhost-vDPA/20220509-152644
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: x86_64-randconfig-a014-20220509 (https://download.01.org/0day-ci/archive/20220509/202205092058.if9wModg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/4225cc2a756b75d1e0ff7ca2a593bada42def380
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cindy-Lu/vdpa-Do-not-count-the-pages-that-were-already-pinned-in-the-vhost-vDPA/20220509-152644
        git checkout 4225cc2a756b75d1e0ff7ca2a593bada42def380
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "interval_tree_remove" [drivers/vhost/vhost_vdpa.ko] undefined!
>> ERROR: modpost: "interval_tree_insert" [drivers/vhost/vhost_vdpa.ko] undefined!
>> ERROR: modpost: "interval_tree_iter_first" [drivers/vhost/vhost_vdpa.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
