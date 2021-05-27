Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE3392E30
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 14:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhE0MpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 08:45:06 -0400
Received: from mail-sn1anam02on2064.outbound.protection.outlook.com ([40.107.96.64]:18388
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235206AbhE0MpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 08:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8kIE/1istKlRFdIWBJHiC/pEuPSV3Aw8YOrNEHI0ZLKbAdFwPcYfICsu6oNXhs2bpYq0/JG4kisTny9WP8aFy7FCaecThgsNk7Z0U/e0LfWVA3zJPJl/iP6MKu5igCs7RFeEOX+KRCI07z1+gS8ccn0xJckGvV7bwZBSLuXcz4jUR2GqrI0MkLf9FjbxWepf3aiEIr1PunhYA2majYfrUe6V+ZjbVxJpGSm5T6Lf87fnwTuIUz93+XSuSmyPk1xOz+eUS01Wy2YsaZTeCuvyszFYYsvPGdrl77Sn/SNxfsDkUnAmplZxUnnAP0pqkJBErp6/EOfsUpGuLE32U+ReA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYVsFyikypUdfIaWo0wukDAWPIVWc+aMYm+TEp2M2qk=;
 b=HP5Dlx9iB1fb+satKih4bysgs8g7ousGKfngJuslnzu6QSTtI4cm2///VFAE56TtA6vSqyhwSfY7mLGScSwpSmhc5HrlB5lmsPH39WsNrWarqtV8yk7XRw2/9buqtsEr6elAkMVPTcDgZTQwr67pO+zzwlroNuujt90oialC75tzXPss2phnnpFfp1OzxKze8K7DizDPVyzqpK+hgFxtSDHGfhWEJI211n7R4gRhbEfeVyy3CZ1NEPVUbD6XYCaWQGuzpVdKdZd/5sx4HkfIbBJP+2/CoArv7EgoAq59Fgr0JIZWpc2yp6HEszLAI2luXWcuxs+qRnnMeZ0EuaMyjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYVsFyikypUdfIaWo0wukDAWPIVWc+aMYm+TEp2M2qk=;
 b=bet6Ye0FH8PCoLEGMNsMwno1kMIW0ggsI/GTgarc5+M7Ml9fT0S6/FkUX2MXmkKKBw4PF7IMyX/6bPSaV+CqZ6NFq+LLnG+4z3tZS/oFA10cS0S2KGB7heM7WKn1tm2vhKsbzPOuawaKEe6lGiTkjAEJEIsmKmavwHsKy7RGw4L4adGrG1pp+0lbHWnMdHVAAY50/9X8aSIMy7gd8StnReZLAONM5bVKE9wQpoA8EiLdmPlJ7gpTTOIui5mvKUPf302aenLrMTOLtGjyJMIhEARMJuR2oXuD+MIDcg+LnovpGCDkVzBMBhF7tFRpcWUV+NiRWq2QaJDlXaPY5pNezA==
Received: from MWHPR19CA0020.namprd19.prod.outlook.com (2603:10b6:300:d4::30)
 by MN2PR12MB3424.namprd12.prod.outlook.com (2603:10b6:208:cc::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 12:43:31 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::c3) by MWHPR19CA0020.outlook.office365.com
 (2603:10b6:300:d4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 12:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 12:43:30 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 12:43:27 +0000
Subject: Re: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, <f.fainelli@gmail.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <andrew@lunn.ch>, <treding@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-imx@nxp.com>
References: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <e2f651f8-e426-1419-dbdc-4854b3d6ee83@nvidia.com>
Date:   Thu, 27 May 2021 13:43:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52107c31-7443-4430-4f72-08d9210d0823
X-MS-TrafficTypeDiagnostic: MN2PR12MB3424:
X-Microsoft-Antispam-PRVS: <MN2PR12MB34246F3D60A824151C0E176BD9239@MN2PR12MB3424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zpznj2eAuVZ1F1pqGGxGy/atzT+uyBhx+1X75zBic7sDRGo0WfjtapCYq1ds+3Wv0ZzC1pxBzFkLjz197LLi/q4afIgoPf8YUYdgb/p3jTK6XFIta0zq2fgePrxHNkGwxml3FoaBovPRGUWxZgu0jKFeVaCh5OFqKKxfuUpDEnBn9GyxGRF6El+N+1aGRndM8OSKiS7YZodHG+HlDpBJhVzZOWECAqjBnBzV2ohO/ajR1rfqkNQm9lHtuugY/R+b3UZvws+1NY4QrDt6Y9MaA3zcplZ/gFyIIDYNYLWFsHnRByJUPdY1XlsZN/EB0cRDUHhpQN+p6sAOjXmQ8Rbt+OAgDY9q1UXrA4OU3+/rE11yRyO3Bd+gocOzWF2HVnKivgMsysUWJ+MMW7IsdSIvwdWJEZUMIqWUgZ5Pxk49e5/rfh/D2FlSfdhJqdVqW3zxEfn3fYfEbwpZlpyXL4AV1y6auPtibNNN44zD7nzd0t3c2DcFfJIRdbO3pWH/v9N01/n1KIQ+PNH0gN7KpuMoUD9ynbETAVJaRsd8bxJRiPYkG8u0drIEYBxb7XuF+gfGUa9ozLklmFDcn2UvFdT3DXbk3r+f3RkNKmn5Vo2veHSRX7m5iG3AQO6IYp6HMgZeNmQAWfMNS4DlkpvkAIhGLnLJzuSUqAtWaJZDHtZe58ui0M74jF8Xwl/2/Fy+mhAvU688lnpRCtP4tsonNrQb3BukyR8s4kANi3+Imwr3dMxvEapBLB02A+R5PT/RDlBpZxlQH9E7wfU4TtVaDnlY8Yvmybq7rTAcypaZMgrkHfBXC5DBjMyBKJ0ovBvJ76+jDq7JcRA/eQQvzIfm3SkTA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(46966006)(5660300002)(82740400003)(70206006)(2906002)(4326008)(8676002)(70586007)(8936002)(36860700001)(31686004)(83380400001)(478600001)(16576012)(31696002)(7636003)(36906005)(316002)(966005)(2616005)(47076005)(54906003)(53546011)(26005)(336012)(426003)(186003)(16526019)(921005)(356005)(82310400003)(86362001)(110136005)(6636002)(36756003)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:43:30.3459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52107c31-7443-4430-4f72-08d9210d0823
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3424
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/05/2021 09:49, Joakim Zhang wrote:
> When system resume back, STMMAC will clear RX descriptors:
> stmmac_resume()
> 	->stmmac_clear_descriptors()
> 		->stmmac_clear_rx_descriptors()
> 			->stmmac_init_rx_desc()
> 				->dwmac4_set_rx_owner()
> 				//p->des3 |= cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
> It only asserts OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/2 fields.
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
> i.MX8MP STMMAC DMA width is 34 bits, so desc0/desc1 indicates the buffer
> address, after system resume, the buffer address changes to
> 0x40_00000000. And the correct rx descriptor is 008 [0x00000000c4310080]:
> 0x6511000 0x1 0x0 0x81000000, the valid buffer address is 0x1_6511000.
> So when DMA tried to access the invalid address 0x40_00000000 would
> generate fatal bus error.
> 
> But for other 32 bits width DMA, DMA still can work when this issue happened,
> only desc0 indicates buffer address, so the buffer address is 0x00000000 when
> system resume.
> 
> There is a NOTE in the Guide:
> In the Receive Descriptor (Read Format), if the Buffer Address field is all 0s,
> the module does not transfer data to that buffer and skips to the next buffer
> or next descriptor.
> 
> Also a feedback from SYPS:
> When buffer address field of Rx descriptor is all 0's, DMA skips such descriptor
> means DMA closes Rx descriptor as Intermediate descriptor with OWN bit set to 0,
> indicates that the application owns this descriptor.
> 
> It now appears that this issue seems only can be reproduced on DMA width more
> than 32 bits, this may be why other SoCs which integrated the same STMMAC IP
> can't reproduce it.
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
> ChangeLogs:
> 	V1: remove RFC tag, please come here for RFC discussion:
> 	    https://lore.kernel.org/netdev/cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com/T/
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index bf9fe25fed69..2570d26286ea 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7187,6 +7187,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
>  		tx_q->mss = 0;
>  
>  		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
> +
> +		stmmac_clear_tx_descriptors(priv, queue);
>  	}
>  }
>  
> @@ -7251,7 +7253,6 @@ int stmmac_resume(struct device *dev)
>  	stmmac_reset_queues_param(priv);
>  
>  	stmmac_free_tx_skbufs(priv);
> -	stmmac_clear_descriptors(priv);
>  
>  	stmmac_hw_setup(ndev, false);
>  	stmmac_init_coalesce(priv);
> 


So as previously mentioned this still causing a regression when resuming
from suspend on Jetson TX2 platform. I am not sure why you are still
attempting to push this patch as-is when it causes a complete failure
for another platform. I am quite disappointed that you are ignoring the
issue we have reported :-(

To summarise we do not see any issues with suspend on Jetson TX2 without
this patch. I have stressed suspend on this board doing 2000 suspend
iterations and so no issues. However, this patch completely breaks
resuming from suspend for us. Therefore, I don't see how we can merge this.

Given that this fixes a problem, that appears to be specific to your
platform, why do you not implement this in away such that this is only
done for your platform?

Jon

-- 
nvpublic
