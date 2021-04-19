Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5A3646CE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbhDSPNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:13:08 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:33320
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhDSPNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 11:13:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtDpGyetii0qbKN87726dGE9vvdv+QgkoVpNxWVika1prBSLVKps3BzARGXmKwAVnrCU2vdd51jk4eDXbXM3j27LrIOYzpZzR8RqXdsscw6pEVvY6W7mEzgAKEKsEy6Kc8eRYm3IR6/xPWsPA1URCBuC4ZJHjA944DyTlPtafKrrnQqqBLjJvpnUfckImb+RPsIgOBOfaK6Th31p10zvTEZV8y/A2/F+c/ROMadxYYeRtKBazwk3666eA1PtW/B97+rXjC5g6FCOn16hJOpThc/ClBYKW0jM7LLKARJwBEI/GeSmR8XBltf8nvPJKgH6GsaaBqF60nuK1q++/wUx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gEugqC3Lx6pzBSTzGirO0+p7kTtxQaQNafAyLfkifo=;
 b=el5V1EUGYKaiznfoSZWdFOtSJX8TxyPlHpC8mPYlvG1A/tC5c6/X6WHQg5HMFgI1cqL7alAi41lU1rzBajTlUZX6Aqfml6Z1zPUxcD6Oa5YMAX5N4XdvRLzVmNdXxS4BGIEgHTyPZPrBAingVSd9rBJdKfj2Co2Sbsy6/Wtb6lpCNzb+/Txc/7fQ33koBEHGOi4jLPOet9us8NRd0+la4UgangzyS74+sKtgwZV69/0dfY1Yr8dzdFT9goPM3JAmmQviWCOgAAe3MfBgWNEMK2jna6QfeT3luQJqYfryf1oq6NxWEnRSFHgI5jeqIVzLdtulPw5hqCwnjv+hzEgJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=synopsys.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gEugqC3Lx6pzBSTzGirO0+p7kTtxQaQNafAyLfkifo=;
 b=G9hafpYw6ZCo+kzRXc9RPDAx6zwrqIewypLm+iRhAiwvQ7w2jT9zAqV7dfqXz/9fdOmPjNvOIRWojpLkutBu0YCAYDbOFCorZiBaU5zzmuiJU6m+lYTlGSkhipQZnk1rB7F9UohC5FNF9V+TKtdJlWVwqabLeKzpOvjKCVIb0gn6PnWbP2CGxrSl//+1+I7gOi9u0MFY9BEeL6USmigKQhmrlxxQRvwcZicvSaOq9y0t1W2OrFnZnBkcrAwtvfVFACFIpgDXQgOt+eT2iRP6x4p3smJn2UDHWBjoMofzKGep7Nh3lA4fBpkWYWId5VJsjlrzbp6qOxQXURj5RKrIYA==
Received: from MWHPR07CA0018.namprd07.prod.outlook.com (2603:10b6:300:116::28)
 by DM6PR12MB3004.namprd12.prod.outlook.com (2603:10b6:5:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 15:12:34 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::b8) by MWHPR07CA0018.outlook.office365.com
 (2603:10b6:300:116::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Mon, 19 Apr 2021 15:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 15:12:33 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Apr
 2021 15:12:30 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>
CC:     <linux-imx@nxp.com>, <treding@nvidia.com>, <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
Date:   Mon, 19 Apr 2021 16:12:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5aa8ba4-1b1c-4952-56ee-08d903458f1e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3004:
X-Microsoft-Antispam-PRVS: <DM6PR12MB30047C90CAB232CE57D7FB79D9499@DM6PR12MB3004.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYSpT1b4+ymGa7Dbul0c4fa/j8cU5fbi4k5vGr6c0MpWU2RotRBEEaq6lvewNgAlJImiPlWdHQ37/ZduVIb9VSd2BeukcgXzaFzL6Mk+yaHUDJW7zakL+vR7epj5c+WMpnwuDCOflYpTJCsXp/nZJ7q5lnTclsjs8ULZjg+UnvLrSmhUnL2jcZzCDpr3zB47lWes5gNK/SoA05Io7H9v3mXPR6Rf7nnLnjQL6vwfMcugZH8tx/NyJCvbGm5vZE6CiFXotwzb5C7q73H2HbCicf7YqDrKf8oxrF2PQLL6tSz3UHe6rPP3rhA2ElXX5lXe2UYTIu3IsMrJPPdja9+VwK5Wbc1TI8i7/M+KmmiQRm6g70sVmEgUiKx9HzLMS7dkSpsrHsQnOlSeIH9t3W4yQ0ed4erikLrc+FYSNlbkqLnVJ+9+sZ9lFYOed2APGis+ZBsb9konV8BsxQbggA5iZnwps3f68IGIn1/VUqLqpgvUmtbNN7/LUqGDVDJMSt9HxPqPvAdM6IdoMM/UAMJqWW3AVTnustqKPKCLQPWomEK7BDSGwilAOuEx0JrkXpBWpznvZId8AHEWougUpkhfxrBelXvgfWaYGjSnzS+z2fU66UqFMa7pn8Acdu4+J3Qiy2LwkSRBrvjzCIt2YUZDhYHeODLTo+CzLtNEAlI+/moJGfz5D2ghTc4T8fQ7RWjm
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(36840700001)(46966006)(5660300002)(16576012)(36756003)(426003)(82310400003)(7416002)(86362001)(70206006)(31696002)(6666004)(70586007)(54906003)(2906002)(110136005)(36906005)(2616005)(336012)(53546011)(36860700001)(316002)(478600001)(4326008)(83380400001)(8676002)(356005)(7636003)(26005)(47076005)(186003)(82740400003)(16526019)(31686004)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 15:12:33.7263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5aa8ba4-1b1c-4952-56ee-08d903458f1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On 19/04/2021 12:59, Joakim Zhang wrote:
> When system resume back, STMMAC will clear RX descriptors:
> stmmac_resume()
> 	->stmmac_clear_descriptors()
> 		->stmmac_clear_rx_descriptors()
> 			->stmmac_init_rx_desc()
> 				->dwmac4_set_rx_owner()
> 				//p->des3 |= cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
> It only assets OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/2 fields.
> 
> Let's take a case into account, when system suspend, it is possible that
> there are packets have not received yet, so the RX descriptors are wrote
> back by DMA, e.g.
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040
> 
> When system resume back, after above process, it became a broken
> descriptor:
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040
> 
> The issue is that it only changes the owner of this descriptor, but do nothing
> about desc0/1/2 fields. The descriptor of STMMAC a bit special, applicaton
> prepares RX descriptors for DMA, after DMA recevie the packets, it will write
> back the descriptors, so the same field of a descriptor have different
> meanings to application and DMA. It should be a software bug there, and may
> not easy to reproduce, but there is a certain probability that it will
> occur.
> 
> Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back") tried
> to re-init desc0/desc1 (buffer address fields) to fix this issue, but it
> is not a proper solution, and made regression on Jetson TX2 boards.
> 
> It is unreasonable to modify RX descriptors outside of stmmac_rx_refill() function,
> where it will clear all desc0/desc1/desc2/desc3 fields together.
> 
> This patch removes RX descriptors modification when STMMAC resume.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 9f396648d76f..b784304a22e8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7186,6 +7186,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
>  		tx_q->mss = 0;
>  
>  		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
> +
> +		stmmac_clear_tx_descriptors(priv, queue);
>  	}
>  }
>  
> @@ -7250,7 +7252,6 @@ int stmmac_resume(struct device *dev)
>  	stmmac_reset_queues_param(priv);
>  
>  	stmmac_free_tx_skbufs(priv);
> -	stmmac_clear_descriptors(priv);
>  
>  	stmmac_hw_setup(ndev, false);
>  	stmmac_init_coalesce(priv);
> 


I have tested this patch, but unfortunately the board still fails to
resume correctly. So it appears to suffer with the same issue we saw on
the previous implementation.

Jon

-- 
nvpublic
