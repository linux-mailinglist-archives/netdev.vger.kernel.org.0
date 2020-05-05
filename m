Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB35B1C4C45
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 04:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEECoS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 May 2020 22:44:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:31648 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgEECoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 22:44:18 -0400
IronPort-SDR: JrzXRH2wlqVPt8b1StdQjQi+lT7rWe1FpG9/OzilD3wjlf8ncKpJXa9QLKbyF4CqqoLli/BJ1X
 Y8paEsvVUJiw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 19:44:18 -0700
IronPort-SDR: Cw0t5scE+DXk0tAVbbTjx1prBri9H12oNtWUnV6oed9VLpZb/AFgB5T1UjJvZVQ3upKT/6HJDn
 rov7QaMdhCNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="277727970"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga002.jf.intel.com with ESMTP; 04 May 2020 19:44:18 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 4 May 2020 19:44:17 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.25]) with mapi id 14.03.0439.000;
 Mon, 4 May 2020 19:44:17 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Xie XiuQi <xiexiuqi@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] ixgbe: fix signed-integer-overflow warning
Thread-Topic: [PATCH net-next] ixgbe: fix signed-integer-overflow warning
Thread-Index: AQHWIoaqP7B4wK9mpEeCjVZHIrr8naiYyOWg
Date:   Tue, 5 May 2020 02:44:17 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986886BA@ORSMSX112.amr.corp.intel.com>
References: <20200505024521.24635-1-xiexiuqi@huawei.com>
In-Reply-To: <20200505024521.24635-1-xiexiuqi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Xie XiuQi <xiexiuqi@huawei.com>
> Sent: Monday, May 4, 2020 19:45
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH net-next] ixgbe: fix signed-integer-overflow warning
> 
> ubsan report this warning, fix it by adding a unsigned suffix.
> 
> UBSAN: signed-integer-overflow in
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:2246:26
> 65535 * 65537 cannot be represented in type 'int'
> CPU: 21 PID: 7 Comm: kworker/u256:0 Not tainted 5.7.0-rc3-debug+ #39
> Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2
> 03/27/2020
> Workqueue: ixgbe ixgbe_service_task [ixgbe] Call trace:
>  dump_backtrace+0x0/0x3f0
>  show_stack+0x28/0x38
>  dump_stack+0x154/0x1e4
>  ubsan_epilogue+0x18/0x60
>  handle_overflow+0xf8/0x148
>  __ubsan_handle_mul_overflow+0x34/0x48
>  ixgbe_fc_enable_generic+0x4d0/0x590 [ixgbe]
>  ixgbe_service_task+0xc20/0x1f78 [ixgbe]
>  process_one_work+0x8f0/0xf18
>  worker_thread+0x430/0x6d0
>  kthread+0x218/0x238
>  ret_from_fork+0x10/0x18
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Dave, I am picking this up.
