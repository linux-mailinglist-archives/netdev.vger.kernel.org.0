Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94E435E3CD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDMQY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:24:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:10663 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231969AbhDMQY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 12:24:57 -0400
IronPort-SDR: RPZ/jslSmFUv/O/neq5BV1KVttHx1cgAvs7NegU9Z3YmsugUbG7aK0JenIDAy+w5X021NWrVdq
 ZyZu5w/BC+xg==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="214930983"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="214930983"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 09:18:14 -0700
IronPort-SDR: Jzr+S+le5B4GUu2EQyxbXU3HDtawIzY+OyQ3xLADIAL2ivTY0OdI80xwzRmJf+X6sUAh0+Jpqv
 lf+q961xqT/g==
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="452023243"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.118.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 09:18:13 -0700
Date:   Tue, 13 Apr 2021 09:18:12 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kerneljasonxing@gmail.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net v2] i40e: fix the panic when running bpf in xdpdrv
 mode
Message-ID: <20210413091812.0000383d@intel.com>
In-Reply-To: <20210413025011.1251-1-kerneljasonxing@gmail.com>
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
        <20210413025011.1251-1-kerneljasonxing@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kerneljasonxing@gmail.com wrote:

> From: Jason Xing <xingwanli@kuaishou.com>

Hi Jason,

Sorry, I missed this on the first time: Added intel-wired-lan,
please include on any future submissions for Intel drivers.
get-maintainers script might help here?

> 
> Fix this panic by adding more rules to calculate the value of @rss_size_max
> which could be used in allocating the queues when bpf is loaded, which,
> however, could cause the failure and then trigger the NULL pointer of
> vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
> cpus are online and then allocates 256 queues on the machine with 32 cpus
> online actually.
> 
> Once the load of bpf begins, the log will go like this "failed to get
> tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
> failed".
> 
> Thus, I attach the key information of the crash-log here.
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
> Call Trace:
> [2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
> [2160294.717666]  dev_xdp_install+0x4f/0x70
> [2160294.718036]  dev_change_xdp_fd+0x11f/0x230
> [2160294.718380]  ? dev_disable_lro+0xe0/0xe0
> [2160294.718705]  do_setlink+0xac7/0xe70
> [2160294.719035]  ? __nla_parse+0xed/0x120
> [2160294.719365]  rtnl_newlink+0x73b/0x860
> 
> Fixes: 41c445ff0f48 ("i40e: main driver core")
> 

This Fixes line should be connected to the Sign offs with
no linefeeds between.

> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>

Did Shujin contribute to this patch? Why are they signing off? If
they developed this patch with you, it should say:
Co-developed-by: Shujin ....
Signed-off-by: Shujin ...
Signed-off-by: Jason ...

Your signature should be last if you sent the patch. The sign-offs are
like a chain of custody, please review 
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

Thanks,
 Jesse
