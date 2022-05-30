Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290145384CC
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiE3PZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbiE3PYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:24:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC01CC605;
        Mon, 30 May 2022 07:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653920737; x=1685456737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qa66nN8IHyybRSUPiNIjAkNufZbxITgV0L9y8AsjeHI=;
  b=fL8+57KS9STNQ8MQVO1DWL17X2fwwiNGtuI1sjKw71qp73CVlebZuwEY
   2GSYdAT/YVliJzcJWmBtTXFcnJT0myLqpxpuWggveSzCZmq2uB1+5yGxK
   i8RPxvtNnkmGUqzR4ZftloEULEtlPgFVtfVQGaG5woKNyNjF+G0q/0vQp
   sl96J7ac6ic/BbJ2MWTOGnrX3HAmSrE3mUwU6nl2Wyc/ZPurR9ehlsIyY
   AmWw7UwCV66cc37R6kmUtE5WLGNOaLIOh3fg9bTGQ6fcYMDfufD3Wkd+d
   4atSGh1IMfX2u8kh/JPycGQ70MaMwrLFc/lpkxb1SB3TBORhlMSRzMyrG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="254888820"
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="254888820"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 07:25:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="605212357"
Received: from rli9-dbox.sh.intel.com (HELO rli9-dbox) ([10.239.159.142])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 07:25:30 -0700
Date:   Mon, 30 May 2022 22:23:53 +0800
From:   Philip Li <philip.li@intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     menglong8.dong@gmail.com, kuba@kernel.org, kbuild-all@lists.01.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
Message-ID: <YpTTedzTnj3s1hdo@rli9-dbox>
References: <20220530081201.10151-3-imagedong@tencent.com>
 <202205301730.inNRSOxX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202205301730.inNRSOxX-lkp@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 06:01:36PM +0800, kernel test robot wrote:
> Hi,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220530-161614
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
> config: nios2-defconfig (https://download.01.org/0day-ci/archive/20220530/202205301730.inNRSOxX-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/73e3b002fb9086fc734ba4dcc3041f9bb56eb1a2
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220530-161614
>         git checkout 73e3b002fb9086fc734ba4dcc3041f9bb56eb1a2
>         # save the config file
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 ARCH=nios2 
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):

Kindly ignore this report, the report itself has issue with empty
warnings here. We will check and resolve this.

> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
