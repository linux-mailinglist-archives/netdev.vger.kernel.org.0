Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3534C52A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhC2Hpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:45:38 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:13248
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229711AbhC2Hpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 03:45:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oE0FSMB77SiGVfLmNSLgseNRiP7Nx9+NZng4sK6CGJQtJZhbb69ZYGRgomSBqcDtvKxAAHTt/wGDjmXN5iknW6m947zNbjCIh6EswANZlExipLLSFdIUkf/r9hZwxRpguoTFKdr2fqkKwz8OFx9ZwSaBnOD6wh08ehg/ZU4cspOCXOY2QdSlE3ca7drKkZee+sgg/GPQvIEe0/q9wuISwHdF7ueJb1TmpmuYNDncAy4Zy34gngnqFBnVyZURpLQP/wjRXPxrO8uKwXGEPZUMg0eFFfs9dzIdcn/+oJSu4XJqCVEjok2oiVtXvghRcLQvC97xzORNkVHThHeqcmj06g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GxAdba0lay//H+YMYG7/xsQEUwuuaovJOKLVt1dfhw=;
 b=T02GE2qlB/fX9A5oliDKa+c0VTqjTqlFKOvyfx2Jz+ZIb5oij/FNPoP8oZOa7TZNL5INlrgwTFzDDItYb0gcNKOK6COK8SjCg/A3JexbSg77Fft2dJNA2VonkSGNpc1s45y3S3fLEfGpp//XczDrKKdO5n3MfnSr3S7hdsmsgTgxQL6OJHCRPuf030kJhHbkBA3WjWGee4biEHl40JIWhEWfeYF6jzsymLdxVgk1a6eOI5i+gJXHXGGyWzWIwL5XV444RWU/IfebySfMi78qgZoJKko5qxW8nsa6ZFLOCPxh80m7mDoFynyYFOQh2lDfteWrvyDr3ugCLkCP0wkyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GxAdba0lay//H+YMYG7/xsQEUwuuaovJOKLVt1dfhw=;
 b=NIGdt7AI1oPuQ0HbMbzKqZymR5MM8pOyiRD+kq9o7UvIWyEyv4uy30zBgyhIZNZZNTUMoh2wA5KtEH4MwbFSy0/VUTrog94btYKQe+q1SYHTVdydodaadiSVoRWFzXolA0bUbM0wlWRAGmfWKlUPGaZSLT4VvseBXOxzqBXB68s=
Received: from DS7PR03CA0072.namprd03.prod.outlook.com (2603:10b6:5:3bb::17)
 by BL0PR02MB4802.namprd02.prod.outlook.com (2603:10b6:208:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Mon, 29 Mar
 2021 07:45:31 +0000
Received: from DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::21) by DS7PR03CA0072.outlook.office365.com
 (2603:10b6:5:3bb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.28 via Frontend
 Transport; Mon, 29 Mar 2021 07:45:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT013.mail.protection.outlook.com (10.13.5.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 07:45:31 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 00:45:30 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2106.2 via Frontend Transport; Mon, 29 Mar 2021 00:45:30 -0700
Envelope-to: linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 huangguobin4@huawei.com
Received: from [172.30.17.109] (port=45758)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1lQmaY-00084I-9C; Mon, 29 Mar 2021 00:45:30 -0700
Subject: Re: [PATCH net-next v2] net: axienet: Remove redundant dev_err call
 in axienet_probe()
To:     Huang Guobin <huangguobin4@huawei.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <1616982313-14119-1-git-send-email-huangguobin4@huawei.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <c69a9877-425d-9fe5-4815-3ac87950a930@xilinx.com>
Date:   Mon, 29 Mar 2021 09:45:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1616982313-14119-1-git-send-email-huangguobin4@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8ef81c3-6279-4be2-9415-08d8f286a0d8
X-MS-TrafficTypeDiagnostic: BL0PR02MB4802:
X-Microsoft-Antispam-PRVS: <BL0PR02MB4802E54C636606CA122CDF22C67E9@BL0PR02MB4802.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZvs0tEvzwMJDj+SqsA1CncPE4a0kr73rkPL0e98hCAKpc8xSAQKI2M+/rusC1YnNKdgBbl0xXPM05ORynJ3rr2sbKl4tCljim587VuR49EZKOoo0YPXTS/Tu6BWOGMxYRBMTsCRj+Z9I85iL3gOZKSkbfv9TO2bmT8YBi01yPJr3uMahBuCm2JtbsIRkAMJOas30vBwA2XN98grKY/2lYJEvGiZXDkLgR0RA7OaHKD85OtdeIoCiRbzQ7NgfhcDbwMuphxhHd7TTSoB3yygrNCeJnRqBPPP2E/RNyz6RhaZOL38TBXa0DKvDdk5+wBGBW6sf3fW2HgkIwviRpk0wpfSYhPhKjYPEbZY2bJkLP76Ou4/ulVTUTS3JvfJYl1BdGDnLI5/VcW7rtfMO0FLD8nTsnFd+WqFVkskPLT7FAP9KFvps/QR0IMAFvj56TARutSgIkLJs+d9G1oE2/w1m/UCxWTlQQ9eHGB2pIUwr5SD3a9XIDzYj2IfpYXwqG8krHYBNSS4i5+GOb5G1K25sLtxH0fmiMUKHqPukkMC66VtfksOp8f6tKGkF7ocRCXjoQXYJAUoGlet4C36qeEcyPV0kFKgSfn62vT+U/NIhEzZP0LB2n9DEYFw78BMJuPJPMxURrLqemXxnAT5/Xq5p0RfUI08voGY2uxVZ7scD0Y1aD62t35Z9M1B1Yp+sxVoOX3uHQX7ix6gRFc7XEping==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(39850400004)(346002)(136003)(396003)(376002)(36840700001)(46966006)(4326008)(8676002)(8936002)(36860700001)(82310400003)(5660300002)(47076005)(478600001)(54906003)(36906005)(316002)(36756003)(110136005)(83380400001)(7636003)(53546011)(2616005)(44832011)(6666004)(70206006)(82740400003)(356005)(426003)(336012)(70586007)(186003)(2906002)(26005)(31696002)(9786002)(31686004)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 07:45:31.0113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ef81c3-6279-4be2-9415-08d8f286a0d8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/21 3:45 AM, Huang Guobin wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 5d677db0aee5..f77a794540fc 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1878,7 +1878,6 @@ static int axienet_probe(struct platform_device *pdev)
>  	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
>  	if (IS_ERR(lp->regs)) {
> -		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
>  		ret = PTR_ERR(lp->regs);
>  		goto cleanup_clk;
>  	}
> 

I have already reviewed v1 and I can't see any v2 description what has
changed. Why am I getting this v2? Where is my tag?

Thanks,
Michal
