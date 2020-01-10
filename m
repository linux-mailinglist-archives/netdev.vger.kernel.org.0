Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2104F1365FD
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 05:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbgAJEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 23:10:20 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731245AbgAJEKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 23:10:20 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 65C86E507ACFBCF8546A;
        Fri, 10 Jan 2020 12:10:18 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 10 Jan 2020
 12:10:13 +0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>
CC:     <valex@mellanox.com>, <jiri@resnulli.us>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
Date:   Fri, 10 Jan 2020 12:10:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/10 3:33, Jacob Keller wrote:
> This series consists of patches to enable devlink to request a snapshot via
> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
> 
> A reviewer might notice that the devlink health API already has such support
> for handling a similar case. However, the health API does not make sense in
> cases where the data is not related to an error condition.

Maybe we need to specify the usecases for the region trigger as suggested by
Jacob.

For example, the orginal usecase is to expose some set of flash/NVM contents.
But can it be used to dump the register of the bar space? or some binary
table in the hardware to debug some error that is not detected by hw?

> 
> In this case, using the health API only for the dumping feels incorrect.
> Regions make sense when the addressable content is not captured
> automatically on error conditions, but only upon request by the devlink API.
> 
> The netdevsim driver is modified to support the new trigger_snapshot
> callback as an example of how this can be used.
> 
> Jacob Keller (3):
>   devlink: add callback to trigger region snapshots
>   devlink: introduce command to trigger region snapshot
>   netdevsim: support triggering snapshot through devlink
> 
>  drivers/net/ethernet/mellanox/mlx4/crdump.c |  4 +-
>  drivers/net/netdevsim/dev.c                 | 37 ++++++++++++-----
>  include/net/devlink.h                       | 12 ++++--
>  include/uapi/linux/devlink.h                |  2 +
>  net/core/devlink.c                          | 45 +++++++++++++++++++--
>  5 files changed, 80 insertions(+), 20 deletions(-)
> 

