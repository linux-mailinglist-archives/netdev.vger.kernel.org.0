Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE4B4EEAC7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344804AbiDAJ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243756AbiDAJ41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:56:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E22FDE0E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 02:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648806877; x=1680342877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N0t/gYCPU1lfHu2t+uGQ3fv8XBPNNozD5tqSJJ/Coeg=;
  b=YSXSaecmHxxzB2wCPsqWXVRl5OTt9gRJRYhugzt4GodB4t6WiHUZRtrz
   dK17l37HUC3gCUw3woedFCkUoMQ4+zpaUeysx6/kc2nEFTbX2fZqAdnTG
   pKcksGCVWfMAgJlwSfz3Fls/GPfBrwp5PMbGTAzUx7D1bGbTItlRQTsNT
   qj2p6Q34R9uTO8X4guOEfLs3CljV/wQeKCuOczgUWkKWOv6BpsrqZ2UCh
   4NDEAH+Vf5NsAb+gA/0fRAs+n82YaMEZxINYtdWM5Oap2dVw21uywtLum
   unjZ+l8HpwHdoW6tJwGZFoBCIvCSN4FIyEz8bsUJbBylvjmfuz+/IKtNR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="240031593"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="240031593"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 02:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="567348996"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 01 Apr 2022 02:54:36 -0700
Date:   Fri, 1 Apr 2022 11:54:35 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Kallol Biswas [C]" <kallol.biswas@nutanix.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: bug in i40e-2.14.13 driver ??
Message-ID: <YkbL2//e9S13PmF9@boxer>
References: <SJ0PR02MB8862A7F336A45D8E8B0090C4FEE19@SJ0PR02MB8862.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR02MB8862A7F336A45D8E8B0090C4FEE19@SJ0PR02MB8862.namprd02.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 06:17:14PM +0000, Kallol Biswas [C] wrote:
> Hi,
>      We have been getting a NULL pointer dereference in intel i40e driver.

Hi,
nice investigation! However, are there any chances that you could check on
your side if this reported issue also occurs on recent kernel with in tree
driver?

Thanks,
MF

> 
> [  105.551413] BUG: kernel NULL pointer dereference, address: 000000000000000a
> 
> PID: 369    TASK: ffff980d62d70000  CPU: 16  COMMAND: "kworker/16:1"
> #0 [ffffb0354e26fb00] machine_kexec at ffffffffae059db5
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/kernel/machine_kexec_64.c: 441
> #1 [ffffb0354e26fb50] __crash_kexec at ffffffffae12584d
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/kernel/kexec_core.c: 957
> #2 [ffffb0354e26fc18] crash_kexec at ffffffffae126ab9
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/include/linux/compiler.h: 292
> #3 [ffffb0354e26fc30] oops_end at ffffffffae02a3da
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/kernel/dumpstack.c: 334
> #4 [ffffb0354e26fc50] no_context at ffffffffae065ff8
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/mm/fault.c: 848
> #5 [ffffb0354e26fcc0] do_page_fault at ffffffffae066ad1
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/mm/fault.c: 1552
> #6 [ffffb0354e26fcf0] page_fault at ffffffffae801119
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/entry/entry_64.S: 1203
>     [exception RIP: i40e_detect_recover_hung+116]
>     RIP: ffffffffc07ae0d4  RSP: ffffb0354e26fda0  RFLAGS: 00010202
>     RAX: ffff980d64e6a000  RBX: ffff980d5b788c00  RCX: ffff980d6f426e08
>     RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffff980d5b788800
>     RBP: 000000000000003c   R8: 0000000065303469   R9: 8080808080808080
>     R10: 0000000000000000  R11: 0000000000000000  R12: ffff980d62d86000
>     R13: 00000000ffffffff  R14: 0000000000000000  R15: ffff980d64e6a848
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>     /home/mockbuild/rpmbuild/BUILD/i40e-2.14.13/src/i40e_virtchnl_pf.c: 7253
> #7 [ffffb0354e26fdc8] i40e_service_task at ffffffffc078ff9b [i40e]
>     /home/mockbuild/rpmbuild/BUILD/i40e-2.14.13/src/i40e_ethtool.c: 5000
> #8 [ffffb0354e26fe78] process_one_work at ffffffffae09818b
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/kernel/workqueue.c: 2271
> #9 [ffffb0354e26feb8] worker_thread at ffffffffae098ca9
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/include/linux/compiler.h: 266
> #10 [ffffb0354e26ff10] kthread at ffffffffae09e378
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/kernel/kthread.c: 268
> #11 [ffffb0354e26ff50] ret_from_fork at ffffffffae8001ff
>     /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244.x86_64/arch/x86/entry/entry_64.S: 352
> 
> -------------------------------------------
> 
> movzwl 0xa(%rdx),%edx fails as RDX: 0000000000000000  (offset 0xa from 0) causes NULL pointer dereference
> 4:27
> mov    0xe8(%rbx),%rdx program rdx, and %rbx is ffff980d5b788c00
> x/x 0xffff980d5b788ce8
> 0xffff980d5b788ce8:     0x00000000, so %rdx gets programmed with 0.
> 
> crash> i40e_vsi.state ffff980d62d86000
>   state = {0}
> crash> i40e_vsi.netdev ffff980d62d86000
>   netdev = 0xffff980d62d87000
> crash> num_queue_pairs
> crash: command not found: num_queue_pairs
> crash> i40e_vsi.num_queue_pairs ffff980d62d86000
>   num_queue_pairs = 64
> All Tx rings
> crash> x/64g 0xffff980d61f11800
> 0xffff980d61f11800:     0xffff980d61f11c00      0xffff980d61f12000
> 0xffff980d61f11810:     0xffff980d61f12400      0xffff980d61f12800
> 0xffff980d61f11820:     0xffff980d61f12c00      0xffff980d61f13000
> 0xffff980d61f11830:     0xffff980d61f13400      0xffff980d61f13800
> 0xffff980d61f11840:     0xffff980d61f13c00      0xffff980d61f14000
> 0xffff980d61f11850:     0xffff980d61f14400      0xffff980d61f14800
> 0xffff980d61f11860:     0xffff980d61f14c00      0xffff980d61f15000
> 0xffff980d61f11870:     0xffff980d61f15400      0xffff980d61f15800
> 0xffff980d61f11880:     0xffff980d61f15c00      0xffff980d61f16000
> 0xffff980d61f11890:     0xffff980d61f16400      0xffff980d61f16800
> 0xffff980d61f118a0:     0xffff980d61f16c00      0xffff980d61f17000
> 0xffff980d61f118b0:     0xffff980d61f17400      0xffff980d61f17800
> 0xffff980d61f118c0:     0xffff980d61f17c00      0xffff980d5b790000
> 0xffff980d61f118d0:     0xffff980d5b790400      0xffff980d5b790800
> 0xffff980d61f118e0:     0xffff980d5b790c00      0xffff980d5b791000
> 0xffff980d61f118f0:     0xffff980d5b791400      0xffff980d5b791800
> 0xffff980d61f11900:     0xffff980d5b791c00      0xffff980d5b792000
> 0xffff980d61f11910:     0xffff980d5b792400      0xffff980d5b792800
> 0xffff980d61f11920:     0xffff980d5b792c00      0xffff980d5b793000
> 0xffff980d61f11930:     0xffff980d5b793400      0xffff980d5b793800
> 0xffff980d61f11940:     0xffff980d5b793c00      0xffff980d5b794000
> 0xffff980d61f11950:     0xffff980d5b794400      0xffff980d5b794800
> 0xffff980d61f11960:     0xffff980d5b794c00      0xffff980d5b795000
> 0xffff980d61f11970:     0xffff980d5b795400      0xffff980d5b795800
> 0xffff980d61f11980:     0xffff980d5b795c00      0xffff980d5b796000
> 0xffff980d61f11990:     0xffff980d5b796400      0xffff980d5b796800
> 0xffff980d61f119a0:     0xffff980d5b796c00      0xffff980d5b797000
> 0xffff980d61f119b0:     0xffff980d5b797400      0xffff980d5b797800
> 0xffff980d61f119c0:     0xffff980d5b797c00      0xffff980d5b788000
> 0xffff980d61f119d0:     0xffff980d5b788400      0xffff980d5b788800
> 0xffff980d61f119e0:     0xffff980d5b788c00      0xffff980d5b789000
> 0xffff980d61f119f0:     0xffff980d5b789400      0xffff980d5b789800crash> struct i40e_ring.q_vector 0xffff980d5b788400  q_vector = 0xffff980d61c92800
> crash> struct i40e_ring.q_vector 0xffff980d5b788400  
> q_vector = 0xffff980d61c92800
> 
> crash> struct i40e_ring.q_vector 0xffff980d5b788c00
>   q_vector = 0x0
> 
> So q_vector is not set after around 60 queues, yet in the driver we do a deference
> i40e_force_wb():
> (q_vector->reg_idx) and die.
> 
> Gdb macro:
> define print_i40e_q_vector
>     set $vsi = (struct i40e_vsi *)$arg0
> 
>     set $q_vectors = $vsi->num_q_vectors
> 
>     printf "vsi %p q_vectors %d", $vsi, $q_vectors
>     set $index = 0
> 
>     while $index < $q_vectors
> 
>         set $q_vector = (struct i40e_q_vector *)$vsi->q_vectors[$index]
> 
>         printf "num_ringpairs %d\n", $q_vector->num_ringpairs
> 
>         set $index += 1
>     end
> 
> 
> end
> 
> Ouput:
> 
> crash> print_i40e_q_vector 0xffff980d62d86000
> vsi 0xffff980d62d86000 q_vectors 64num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 1
> num_ringpairs 0
> num_ringpairs 0
> num_ringpairs 0
> num_ringpairs 0
> 
> 
> Source code:
> 
> static void i40e_vsi_map_rings_to_vectors(struct i40e_vsi *vsi)
> {
>   int qp_remaining = vsi->num_queue_pairs;
>   int q_vectors = vsi->num_q_vectors;
>   int num_ringpairs;
>   int v_start = 0;
>   int qp_idx = 0;
> 
>   /* If we don't have enough vectors for a 1-to-1 mapping, we'll have to
>    * group them so there are multiple queues per vector.
>    * It is also important to go through all the vectors available to be
>    * sure that if we don't use all the vectors, that the remaining vectors
>    * are cleared. This is especially important when decreasing the
>    * number of queues in use.
>    */
>   for (; v_start < q_vectors; v_start++) {
>     struct i40e_q_vector *q_vector = vsi->q_vectors[v_start];
> 
>     num_ringpairs = DIV_ROUND_UP(qp_remaining, q_vectors - v_start);
> 
>     q_vector->num_ringpairs = num_ringpairs;
>     q_vector->reg_idx = q_vector->v_idx + vsi->base_vector - 1;
> 
>     q_vector->rx.count = 0;
>     q_vector->tx.count = 0;
>     q_vector->rx.ring = NULL;
>     q_vector->tx.ring = NULL;
> 
>     while (num_ringpairs--) {
>       i40e_map_vector_to_qp(vsi, v_start, qp_idx);
>       qp_idx++;
>       qp_remaining--;
>     }
>   }
> }
> 
> How in the above for loop 
>     num_ringpairs = DIV_ROUND_UP(qp_remaining, q_vectors - v_start);
> evaluates to 0, is not clear.
> 
> Have we seen this problem before? If so, is there are fix?
> 
> Nucleodyne@Nutanix
> 408-718-8164
> 
> Nucleodyne@Nutanix
> 408-718-8164
> 
