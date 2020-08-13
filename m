Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91051244069
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 23:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHMVS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 17:18:28 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3584 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMVS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 17:18:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f35aded0000>; Thu, 13 Aug 2020 14:17:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 13 Aug 2020 14:18:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 13 Aug 2020 14:18:27 -0700
Received: from [10.2.49.245] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 13 Aug
 2020 21:18:17 +0000
Subject: Re: [PATCH ethtool v5] Add QSFP-DD support
To:     Adrian Pop <popadrian1996@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@mellanox.com>, <vadimp@mellanox.com>, <andrew@lunn.ch>,
        <mlxsw@mellanox.com>, <idosch@mellanox.com>,
        <paschmidt@nvidia.com>, <mkubecek@suse.cz>
References: <20200813150826.16680-1-popadrian1996@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <86ab48ec-b5a6-a92b-db3f-b56f4a7fff56@nvidia.com>
Date:   Thu, 13 Aug 2020 14:18:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200813150826.16680-1-popadrian1996@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597353453; bh=x70wxmjsg3dzEA6o0AWxdC/qeZ1i4EgFbezQ3wMnlmI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=Nmzj1M/2D1CX7M7jQm5l0JBPUsui+jaJ8hbSzgF8Hb5bA/BcUMKoHJvPcr5omdahG
         hEdsIJ/L++XTHqVvkWUoT9g5De29nqn4rm18QEcVrX6fztVb+ijqxkKqClwjqFc92c
         5MpzxCdvHFoojaSxX3JF1OmrDAx0CKynmbyqx6+fQIXgUuQy3kV8uSYlDgJ4l8foJV
         Qz35T4CUuGXFz+kP/ZowNvE2rKBM9SqCn/YcFjh9orkfglG7z+wOMG0eoxfoDFOx4k
         i0daAEqWIsib6RJ3SPThuIJPdbxV9PJiHR/dNaUZgdhYnmjLEBRXFcTxfczBqAuWHi
         DSNufgApPcFWQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/13/20 8:08 AM, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
>
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
>
> Several functions from qsfp.c could be reused, so an additional parameter
> was added to each and the functions were moved to sff-common.c.
>
> Diff from v1:
> * Report cable length in meters instead of kilometers
> * Fix bad value for QSFP_DD_DATE_VENDOR_LOT_OFFSET
> * Fix initialization for struct qsfp_dd_diags
> * Remove unrelated whitespace cleanups in qsfp.c and Makefile.am
>
> Diff from v2:
> * Remove functions assuming the existance of page 0x10 and 0x11
> * Remove structs and constants related to the page 0x10 and 0x11
>
> Diff from v3:
> * Added missing Signed-off-by and Tested-by tags
>
> Diff from v4:
> * Fix whitespace formatting problems
>
> Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
> Tested-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Paul Schmidt <paschmidt@nvidia.com>


(proxying for Paul CC'ed, who has reviewed and relayed some offline feedback on v1)

Thanks Adrian and Ido


