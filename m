Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D7848E7B5
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiANJlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 04:41:52 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:39905
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229785AbiANJlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 04:41:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK83wbKPQOCWrrhQa2koH4Ur6+5Nh493RQyTU1xBqokGzFObSHmY8OCfr2QyNIOTQDozWuBKrgTGAXS15ad3xZ9JxCXRGPL3QkpQ7fOewwiFw65fmrvdXuxcv82I2JyjxUdL3e4EKWnnJJMZEZL2x2mH/lpShYIXTPvFVOeBV+ir6STPKkg8o2e1EWDPWDJC4j2W1+BOdjxztMPRpbFwkjOn465gCKtS4nFSJ75GH9zwcAtKNcDoluCUUfLyBINPJev9gVadRMIuIKXdFqTU+Fc/I9YCv5DmQ80Pg4QqP67Pb9zJkZjRs/O4jfJ6PJQA2pEL9CLi38zlxI3Z4+EP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6BIkY6vUg0AMwew6dZIWQueZ2j1tSbq4VEkd2lfHGQ=;
 b=jrhsmYfTtvtsKZKPwkLvZTJb3OMXqqiVajg4m+oGZWtV6/cEopm/DO3LH0AlfXC974nS4WRLw/cH1izuhbPTJXPjFV82kyMR1loyv+k9wW5INRag4+VNYKtt/GzAzym8hxcL18Mpn5hRhwT4pC9hdUtB+7YiXlj+Af7TH/R+R+ExTSCfN61XjJt8U+4F5lgq3OJG0ANCdWipLB81MK7KrzXpNMWXL5uHuNa4tAPYDDcgSfRCcpIJWLNji6q4qYjjAUsjxHEsDLIh8lDGcWISEK61SjGIwYZvPaE+fj5ttRTo42i9sdCcAtxNmd/koeIuqJ1/SMXN/atq025I1dlRgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6BIkY6vUg0AMwew6dZIWQueZ2j1tSbq4VEkd2lfHGQ=;
 b=UrEzo0+p2O167xgTbKhJ3ZkHJYRf9T8xxd7rbn756GFJdrs+Q3T2ZZHlVUdNCPohj8J66GW/t+ey08Zt2NB4MZdFVAUfO96zqptyT4DZo9G2ZBkO5M+HSMJY+84UdDKvr90n4w+vrPe/fDr3J3z9e59MmbazT62150I3uzotPZ8=
Received: from SA0PR12CA0010.namprd12.prod.outlook.com (2603:10b6:806:6f::15)
 by PH0PR02MB8407.namprd02.prod.outlook.com (2603:10b6:510:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 09:41:49 +0000
Received: from SN1NAM02FT0030.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:6f:cafe::52) by SA0PR12CA0010.outlook.office365.com
 (2603:10b6:806:6f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Fri, 14 Jan 2022 09:41:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0030.mail.protection.outlook.com (10.97.5.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Fri, 14 Jan 2022 09:41:48 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 14 Jan 2022 01:41:48 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 14 Jan 2022 01:41:48 -0800
Envelope-to: davem@davemloft.net,
 ecree.xilinx@gmail.com,
 habetsm.xilinx@gmail.com,
 john.fastabend@gmail.com,
 daniel@iogearbox.net,
 ast@kernel.org,
 hawk@kernel.org,
 kuba@kernel.org,
 abaci@linux.alibaba.com,
 jiapeng.chong@linux.alibaba.com,
 bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.108.8.141] (port=44722 helo=xcbmartinh41x.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <martin.habets@xilinx.com>)
        id 1n8J5g-0005Hz-3X; Fri, 14 Jan 2022 01:41:48 -0800
Received: by xcbmartinh41x.xilinx.com (Postfix, from userid 4370)
        id 8971787767; Fri, 14 Jan 2022 09:41:47 +0000 (GMT)
Date:   Fri, 14 Jan 2022 09:41:47 +0000
From:   Martin Habets <martin.habets@xilinx.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] sfc: Fix missing error code in efx_reset_up()
Message-ID: <20220114094147.GA52632@xcbmartinh41x.xilinx.com>
Mail-Followup-To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220113161315.126410-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220113161315.126410-1-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 378e0fb5-fdb9-4f85-344a-08d9d742162d
X-MS-TrafficTypeDiagnostic: PH0PR02MB8407:EE_
X-Microsoft-Antispam-PRVS: <PH0PR02MB84074B1105BD430D213E37DAD2549@PH0PR02MB8407.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GC5snhc6ce5VUCRz642Dv4kDTgtW4+ZCxYHQRn+pqKdimponRJqpY9tOIyHjkrnAS3hmx97pfIfuQ9UXT3givja5+gguR1djNlAZZR1qtv3lejzxvzDyCHX+5WHEFDU0I8pN4l0uAIbrkmw0eVGHoaZ2KrujDLQQgYdLzeDiSnJVuroyjpU9HJBzhiL5P0SkErtkkM767KufP9BA4mTqDdx5QloxL+6L1qtyRrCXG4IObx3IaRp2r0f60N/8ep2P8pTv/AaMerTsE9TA/V2Zuylo+zBC4qiPvitnpiXAtQV94L7Oo8otr2mSm8FTjXOr4zqHAVR5k4io839qeAUYQvK34L0gJORPefUV9rBSAbSbUWlG/SBnxYVSXVEoHQX3b0uKQJYom4HUbryZYiwhn8Mqmgckh/Ih20cRdfme65GZ1zGm+tBguaRsEFPlOTD6tGghtMAT0FnoyJNfqBSEfNPdRhz3sGNtBUjQ6NRUOlHX/xSQ35vfDlzuhCyu+Lr/1D2ZCSaDzycpVu5kOecyXWJILV/N5Mw45LhGCHGaRmk+3CT12FiExq+ERnaQkAM4gUitMkqU6ygUn917JXI4VMKQEmTfeMLC+y1AYgXG4OqwFFkhBa8uXjh84x2MYU8g3hVSjkUVXoTdwtmb8T1X9WY9wVH7RR6NhysX0oEF7oH1msk2CJL9w7QXpq/ZG4hxV7E56nwsz+rWoQRuBFJ43SWNoDWMs/lOD2I2sxOeKHM=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(70586007)(6916009)(316002)(2906002)(4326008)(508600001)(8936002)(336012)(1076003)(6266002)(70206006)(8676002)(83380400001)(54906003)(426003)(42186006)(36860700001)(7636003)(82310400004)(47076005)(44832011)(5660300002)(186003)(26005)(7416002)(33656002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 09:41:48.8729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 378e0fb5-fdb9-4f85-344a-08d9d742162d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0030.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 12:13:15AM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'rc'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/sfc/efx_common.c:758 efx_reset_up() warn: missing
> error code 'rc'.

The warning is not correct. We want to return an rc of 0 in this case, and
that is what rc is already set to given the earlier code.

Martin

> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/sfc/efx_common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
> index af37c990217e..bdfcda8bb5d0 100644
> --- a/drivers/net/ethernet/sfc/efx_common.c
> +++ b/drivers/net/ethernet/sfc/efx_common.c
> @@ -754,8 +754,10 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
>  		goto fail;
>  	}
>  
> -	if (!ok)
> +	if (!ok) {
> +		rc = -EINVAL;
>  		goto fail;
> +	}
>  
>  	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
>  	    method != RESET_TYPE_DATAPATH) {
> -- 
> 2.20.1.7.g153144c
