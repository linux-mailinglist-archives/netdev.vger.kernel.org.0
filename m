Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7F3979DD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhFASQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 14:16:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:46250 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFASQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 14:16:20 -0400
IronPort-SDR: hhVZFbIvqa77dbgX9pzFHwngmTT9heU9E5H73yBfLBIgbONSh/zMzQ710iMSpIvg/GlL58xCdH
 OaCyRjkFCmSQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="224884243"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="224884243"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 11:14:38 -0700
IronPort-SDR: fQcAOBUzDfMZaD5LQ8NCA9urtGcc04vjtIctOInIq5o96ywMjVIqWEBiOhEkPfRTQ51CijOyM0
 XSiC1wy+HD3A==
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="549147068"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.201.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 11:14:37 -0700
Date:   Tue, 1 Jun 2021 11:14:36 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jacob.e.keller@intel.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <sgoutham@marvell.com>,
        <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V2 net-next 0/3] ethtool: extend coalesce uAPI
Message-ID: <20210601111436.00001c69@intel.com>
In-Reply-To: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huazhong Tan wrote:

> In order to support some configuration in coalesce uAPI, this RFC
> extends coalesce uAPI and add support for CQE mode.
> ...

> 3. ethool(netlink with cqe mode) + kernel with cqe mode:
> estuary:/$ ethtool -c eth0
> Coalesce parameters for eth0:
> Adaptive RX: on  TX: on
> stats-block-usecs: n/a
> sample-interval: n/a
> pkt-rate-low: n/a
> pkt-rate-high: n/a
> 
> rx-usecs: 20
> rx-frames: 0
> rx-usecs-irq: n/a
> rx-frames-irq: n/a
> 
> tx-usecs: 20
> tx-frames: 0
> tx-usecs-irq: n/a
> tx-frames-irq: n/a
> 
> rx-usecs-low: n/a
> rx-frame-low: n/a
> tx-usecs-low: n/a
> tx-frame-low: n/a
> 
> rx-usecs-high: 0
> rx-frame-high: n/a
> tx-usecs-high: 0
> tx-frame-high: n/a
> 
> CQE mode RX: off  TX: off

BTW, thanks for working on something like this.
I hope it's not just me, but I don't like the display of the new CQE
line, at the very least, it's not consistent with what is there already
in the output of this command, and at worst, it surprises the user and
makes it hard to parse for any scripting tools.

Can I suggest something like:

rx-cqe: off
tx-cqe: off
rx-eqe: off
tx-eqe: off

Then, if hardware is in EQE mode it is clear that it's supported and
ON/OFF, as well as for CQE mode.

-Jesse
