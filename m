Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF559B8B8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 07:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiHVFZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 01:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHVFZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 01:25:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C5C1181F
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 22:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661145933; x=1692681933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nHAi7YdppK2/sOZImzhRrJerAaYf/M5+7ZfQuaZGDQo=;
  b=CbzYqTxFuHQIpbJ2yy2o0djHTDPFWn6MW9w0f56joveO/dlW9LUDMdRN
   GWz6X5tTZhOiAqb1rXyWjAON2L2ASahpKQhDoJKtSf0ua+IxNaNTlZZ+B
   QyRYcWdThZa0dKLuYRbuVsxqvYSsLubaWrEBrJJ+3XiyBSLxyZXaOpAkg
   98TtsbwTJM/CmWhah0GSjaBWhHie+bDmk02pp8+xKWxCw/6NW7OIgrlSr
   1167lXH2w3h4ARkSwy0bB2vqvxZHoDlkXkvF+mynAFFXh8Jz/XME0kk/X
   yjpVpk4iyie1LMqhGduqGenTHfBN41Zsrx8Fre+deHu3vXnmj6rg1ZP8q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="273079407"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="273079407"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 22:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="559603852"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 21 Aug 2022 22:25:31 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oPzwI-0004y8-30;
        Mon, 22 Aug 2022 05:25:30 +0000
Date:   Mon, 22 Aug 2022 13:25:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kirill Tkhai <tkhai@ya.ru>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Kirill Tkhai <tkhai@ya.ru>
Subject: Re: [PATCH] af_unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of
 receive queue skbs
Message-ID: <202208221324.VmNeMI4S-lkp@intel.com>
References: <9293c7ee-6fb7-7142-66fe-051548ffb65c@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9293c7ee-6fb7-7142-66fe-051548ffb65c@ya.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kirill,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on net-next/master linus/master horms-ipvs/master v6.0-rc2 next-20220819]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kirill-Tkhai/af_unix-Add-ioctl-SIOCUNIXGRABFDS-to-grab-files-of-receive-queue-skbs/20220815-045608
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 777885673122b78b2abd2f1e428730961a786ff2
config: i386-randconfig-s003 (https://download.01.org/0day-ci/archive/20220822/202208221324.VmNeMI4S-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/0b4bc309fb3cdc6e470ee5c28e33f2909bfb8266
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kirill-Tkhai/af_unix-Add-ioctl-SIOCUNIXGRABFDS-to-grab-files-of-receive-queue-skbs/20220815-045608
        git checkout 0b4bc309fb3cdc6e470ee5c28e33f2909bfb8266
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/entry/ fs/cifs/ net/unix/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> net/unix/af_unix.c:3130:69: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected int [noderef] __user *ufd @@     got int * @@
   net/unix/af_unix.c:3130:69: sparse:     expected int [noderef] __user *ufd
   net/unix/af_unix.c:3130:69: sparse:     got int *
   net/unix/af_unix.c:159:13: sparse: sparse: context imbalance in 'unix_table_double_lock' - wrong count at exit
   net/unix/af_unix.c:178:28: sparse: sparse: context imbalance in 'unix_table_double_unlock' - unexpected unlock
   net/unix/af_unix.c:1290:13: sparse: sparse: context imbalance in 'unix_state_double_lock' - wrong count at exit
   net/unix/af_unix.c:1308:17: sparse: sparse: context imbalance in 'unix_state_double_unlock' - unexpected unlock
   net/unix/af_unix.c:1609:18: sparse: sparse: context imbalance in 'unix_stream_connect' - different lock contexts for basic block
   net/unix/af_unix.c:1972:25: sparse: sparse: context imbalance in 'unix_dgram_sendmsg' - unexpected unlock
   net/unix/af_unix.c:3325:20: sparse: sparse: context imbalance in 'unix_get_first' - wrong count at exit
   net/unix/af_unix.c:3356:34: sparse: sparse: context imbalance in 'unix_get_next' - unexpected unlock
   net/unix/af_unix.c:3386:42: sparse: sparse: context imbalance in 'unix_seq_stop' - unexpected unlock
   net/unix/af_unix.c:3489:34: sparse: sparse: context imbalance in 'bpf_iter_unix_hold_batch' - unexpected unlock

vim +3130 net/unix/af_unix.c

  3081	
  3082	static int unix_ioc_grab_fds(struct sock *sk, struct unix_ioc_grab_fds __user *uarg)
  3083	{
  3084		int i, todo, skip, count, all, err, done = 0;
  3085		struct unix_sock *u = unix_sk(sk);
  3086		struct unix_ioc_grab_fds arg;
  3087		struct sk_buff *skb = NULL;
  3088		struct scm_fp_list *fp;
  3089	
  3090		if (copy_from_user(&arg, uarg, sizeof(arg)))
  3091			return -EFAULT;
  3092	
  3093		skip = arg.in.nr_skip;
  3094		todo = arg.in.nr_grab;
  3095	
  3096		if (skip < 0 || todo <= 0)
  3097			return -EINVAL;
  3098		if (mutex_lock_interruptible(&u->iolock))
  3099			return -EINTR;
  3100	
  3101		all = atomic_read(&u->scm_stat.nr_fds);
  3102		err = -EFAULT;
  3103		/* Set uarg->out.nr_all before the first file is received. */
  3104		if (put_user(all, &uarg->out.nr_all))
  3105			goto unlock;
  3106		err = 0;
  3107		if (all <= skip)
  3108			goto unlock;
  3109		if (all - skip < todo)
  3110			todo = all - skip;
  3111		while (todo) {
  3112			spin_lock(&sk->sk_receive_queue.lock);
  3113			if (!skb)
  3114				skb = skb_peek(&sk->sk_receive_queue);
  3115			else
  3116				skb = skb_peek_next(skb, &sk->sk_receive_queue);
  3117			spin_unlock(&sk->sk_receive_queue.lock);
  3118	
  3119			if (!skb)
  3120				goto unlock;
  3121	
  3122			fp = UNIXCB(skb).fp;
  3123			count = fp->count;
  3124			if (skip >= count) {
  3125				skip -= count;
  3126				continue;
  3127			}
  3128	
  3129			for (i = skip; i < count && todo; i++) {
> 3130				err = receive_fd_user(fp->fp[i], &arg.in.fds[done], 0);
  3131				if (err < 0)
  3132					goto unlock;
  3133				done++;
  3134				todo--;
  3135			}
  3136			skip = 0;
  3137		}
  3138	unlock:
  3139		mutex_unlock(&u->iolock);
  3140	
  3141		/* Return number of fds (non-error) if there is a received file. */
  3142		if (done)
  3143			return done;
  3144		if (err < 0)
  3145			return err;
  3146		return 0;
  3147	}
  3148	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
