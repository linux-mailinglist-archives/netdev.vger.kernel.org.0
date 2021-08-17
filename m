Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568A3EEE86
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbhHQOav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:30:51 -0400
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:44641
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230412AbhHQOau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:30:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1SWaAUmR4G2Pz87YrfhEJPsYiQG8D1mb2/8iyROnIaJc3LFT7N4hdlyQz06+DTpkQjJVefL7EhsAGxrSMFInuMR6ayCXCGiuaBI/UHGComha7olXjW04MD5klPD7Ko/WTbeOiEsdVPaXa2v/25ZbW4Uy79EZ//ZGEy5U9ZkVIVnAz1gnBBD8IHHPqWHh7v01UKth6hTpGx0WqalA1E/AhyjEbBBKsfMTm7Tm3E83tCtrL0HsMIOYRhZGK2HCj6ETowxttMaJb6OO4BUTMeVGfu1QMqO/ZQ30G2QRADFfAR1dwpz07E7gqkWq9vRBgI3uM46Xg6X6uAH6IZbYIGD1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHis5yKzceXjpsHToH19klBpEArYNDw50LrMS5aDA2U=;
 b=IjgqOLA258+hzr2wluOJjdTgnwHFLgYQFjWkuKDhXlSnBq949V5szFrVafHS+6z+LJyjbr5UkxivopedS1mY0+LEiWNvUdm6oECJhYRs2DU7yC9FPufSf3+ePrEX4/2FeQeZnMPEk0ppUSYpBjeIFJEuuP8fAiOw01XDgtJph/P/2VCysWE7z7YKynn70vbIO9c0VzWa7sHLpAxk1qRjTXRS+wIJEFUsEvhrjSThh1VtxNZjHjdZSYwdgmNjKCzmuZaJtgaps9OCLzlT/3ON9i1j8MQxPgMCiKeyljjL6pDcDAA01WGoksgkvLv57VPs3WbKFaR9rT1cR4ZGMhRdYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHis5yKzceXjpsHToH19klBpEArYNDw50LrMS5aDA2U=;
 b=TgG0coOr670QWucJZU33YDMiYP4DjwkCPqf3otLDERA5gS6+oO50IoArqJWMHoNqVPorlqVw9HJ5TFrWeA07lAlDxVf6npXQeks/9XvFYwh0xAJEYXRvDqnc82gu0pJR8TdqOZbwWYEXJ6qpHyGyIAVpHpH2LlplAH6m7Vjx7xP57MSjsciF42yTFxa2/SRZv/UzonFFLKKix/E2Dmpx8PblIJXRliDnYvMHFfHS0+6FmSdK4q9b5BoHCsEjBkqCl07zE+J9lb1qVLJiEkdD9m9ezl8TuIzC7YIR55O+8HJgfJ04qqD40ggaZrAVAupXqbPILC+IJcRtFqnQ8cy+hw==
Received: from DS7PR05CA0013.namprd05.prod.outlook.com (2603:10b6:5:3b9::18)
 by DM5PR12MB1657.namprd12.prod.outlook.com (2603:10b6:4:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.19; Tue, 17 Aug 2021 14:30:15 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::d3) by DS7PR05CA0013.outlook.office365.com
 (2603:10b6:5:3b9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend
 Transport; Tue, 17 Aug 2021 14:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 14:30:14 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 14:30:14 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 17 Aug 2021 14:30:12 +0000
Date:   Tue, 17 Aug 2021 17:30:09 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net: Fix offloading indirect devices
 dependency on qdisc order creation
Message-ID: <20210817143009.GA91458@mtl-vdi-166.wap.labs.mlnx>
References: <20210817132217.100710-1-elic@nvidia.com>
 <20210817132217.100710-3-elic@nvidia.com>
 <20210817070041.1a2dd2b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210817070041.1a2dd2b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 100705a8-5813-4c9f-9732-08d9618b8748
X-MS-TrafficTypeDiagnostic: DM5PR12MB1657:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16575E906318EEF27613BF3CABFE9@DM5PR12MB1657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQjLCx4BEMDPxgdRs0aqaVIcG5I+C8DbOhwXwGY5vmNjRKivHf47DeixU8EzmPwX6gIRiYeNpFM+S8sGKI7njhn5njbfeKTu+XN98X9K1DD9AA5XQDEP6qNW31iuyaGRlJ4FM2vLu3H8EDl0sKuMLsVetrA550CO+o1Hubo91hOLocsajGNbQaMzxI+APpQTsl6B6B4pnYqxQ35WdevLfSiBsuoag0UDbTUkaCTXQg3808d+oW/Axw0oEpNGlPi+hyBCiTajjcbwN/R9UTc9LV3kcKq7TLlgryBq8bz81rTrDWhxkqgF4OUKwRAs8kl8Bznvb1MlCzUmireRBgjVmJcS4A1ERC/oHc8xUlFVHQR8+BpxSrOZd5knld1lG2RFCPnrZY8h6/+jhCF6t+/FmpWa5///OOp80+vmnMCtgf5XRyBgMPlV0ikZvNpZWatziF8qW9KAF4kUMiuqUD3+gEuxtrOAyMmY2PBtfrTv0ulvTeq2kfUNCyWqeNDjtufCf8cwDMm67j/iH5qEe2MjavXR0puuVneiLz6v+rsZubpWmsyfISjZJPZLC0T0ffBxfP2/n5AeO0DaTlshqg6FfwIpXAeKTdpv6TiLJoPd8j/u1meom4qMvxVqsABna8T9I6yeTjxPz9VR5dd4IuYHIHfQ2Xxf3hDrD5ycjkg2ILZH3xUXZ4h+8Rc8k14Vh8NQV5u4kPhFwz4c+/uBo16O9Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(356005)(54906003)(47076005)(1076003)(7636003)(70206006)(82740400003)(70586007)(6666004)(36906005)(316002)(82310400003)(2906002)(4326008)(83380400001)(478600001)(26005)(33656002)(8676002)(6916009)(9686003)(55016002)(336012)(186003)(16526019)(7696005)(426003)(36860700001)(5660300002)(86362001)(8936002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 14:30:14.6556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 100705a8-5813-4c9f-9732-08d9618b8748
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 07:00:41AM -0700, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 16:22:17 +0300 Eli Cohen wrote:
> > Currently, when creating an ingress qdisc on an indirect device before
> > the driver registered for callbacks, the driver will not have a chance
> > to register its filter configuration callbacks.
> > 
> > To fix that, modify the code such that it keeps track of all the ingress
> > qdiscs that call flow_indr_dev_setup_offload(). When a driver calls
> > flow_indr_dev_register(),  go through the list of tracked ingress qdiscs
> > and call the driver callback entry point so as to give it a chance to
> > register its callback.
> > 
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> 
> net/core/flow_offload.c: In function ‘existing_qdiscs_register’:
> net/core/flow_offload.c:365:20: warning: variable ‘block’ set but not used [-Wunused-but-set-variable]
>   365 |  struct tcf_block *block;
>       |                    ^~~~~

Thanks Jakub.
Would you mind telling me how you invoked the compiler to catch this?
