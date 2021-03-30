Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F9934E7E7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhC3MvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:51:18 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:7904
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232025AbhC3Muz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:50:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zlf2tMIN2eckoT+okOGUcYBVw9ncVTniErw2DA3jKNWs+SqV7iDkluRGM5bp6rhzJDAfkn6UND44iEjXr5bsKzOhGNcEXwnAHI71ccCJUdg/f9W2+QDX4IjIpJ1GYvxY0ybweQoWi6nHOXxFlsj2l1NcIZuoWYb5fHzDyXtBGkjRI/mEhaiBLstjOTU/hiHtgRNwsJPCzAorTYj9GWBXqq228sUFhm6zbuph6Td9x5x2rlcSRVOS9hakn/dyX2Ki8H4o28VnkNMm84tZDqqksmFsMFzDg+tpxOQ8GhLPuE107CA/0h8Mowh+j88q8hezRkf/2jhZRJM/RQNFrdogxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maYFdigKmgUl6zfPIy3uif8tpJ7HAfWWepiQcAresU0=;
 b=oIQMjiQSUDBN71uvgv/94SUNpLdqeWsulNnG9p/LDp6ZjEoV88CaRxkBDEPIiv7Cogr29kxd26PO/KXK3Bg8HDOZgM8It3A8vwlRZghaa77c3UmTEsWhzRn2AupIxUa+HmMwVeG5SLJPEejvUObsN8cF2uM7ITtYUtD7NtCeNgtz2C3nzTANt21V2l5Z8wnunNCDFpxegFIPPja5Y5igjgubARe1lpF27LWzE9H4M0i18ivpCi/0gHikntxrmOlS4D4OSK51i3kTN8sdpHFhJ2fR4d8MRP2clVwaXzU+CKKd17qvqtSmbaouPLpvyM9D7i5zBVAUhHwJMwtq7Q+oOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maYFdigKmgUl6zfPIy3uif8tpJ7HAfWWepiQcAresU0=;
 b=YRRndB5c6u+qHnjRHscycN/58+3sahz5/GdiHBPabftQV+gv3vlpE2aWm87zXiRx5YDHfZ1V3qPw1L5yBx1GxNrMWYz4L8ZX/ylqt+uXgSj28ORs5S80OwkbnBH7XeVWitHDwLUNqZ6gvTpdCyb4eS9P9eV7zeCCcWFeydrszEiv3lfPKav0or9zGScWdfCQNTy62fT2wct3GJh3gJJdGPek6u8uKPPqas5/2S+f+9MQuALn/lxNrpCElQ4Bf8mrmsmcLOfw8eZzu37pc3cG946cCEhplbsaX03l8A9Hp/W1QdcajKYIns7yL9x9Q1uGy/L/g/RuMVb7ba53+3y/dg==
Received: from BN9PR03CA0533.namprd03.prod.outlook.com (2603:10b6:408:131::28)
 by MN2PR12MB3869.namprd12.prod.outlook.com (2603:10b6:208:16f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 12:50:52 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::68) by BN9PR03CA0533.outlook.office365.com
 (2603:10b6:408:131::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Tue, 30 Mar 2021 12:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 12:50:52 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 12:50:50 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
Date:   Tue, 30 Mar 2021 13:50:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33dddbf6-3df3-4666-f8ea-08d8f37a737f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3869:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3869E6DC8EE871AC38F75C0FD97D9@MN2PR12MB3869.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D35axSq6rGYtjHvTWol2l17IcttO9+TVTJxacrFiHqAmnEabKyRywcuGJd1PV6q9bBOM3z/WVoZQQeAppQWXirx9SkWmpxRWmjB280Zi/1NR8ELcbcylinuv/d5DXkKyTnSHWK2lntnGCn8kJj8rVTi0vv0cBwMHy6MmBxNPuvQ2zfejtcm7AFjoZ2XJyAEkWiyv2C74bTj0U8m492Vr5di3Rktut1B78hU2FNqILsqMVdIoW4cBVvV83WPpHfCbJzPwiHjmJchn6dqIiBjJPgxOPmPHMXgdN8zoAVyOTlOM6fKivLZfoH6c+mU5HH1ciEXPBtKEddx6L2069yc+qjyPvB+x8JoiqtqZndjND7Hix5+IUtDQcjL87oGGubsAHMZvskAU9b+i/amvwhFI3bZ8IoV/40Nd4kT9aiLJ4lPE4u0yUknvw3LFjPmt53vSypeDnQ4jWLh3OJa+wIkIm38ZEalaKzPNohHlgFN4pUvD0FYJB0iyqlM6YSFCw4vfN+LVvsYEKO7WIuH7JK3Ehd+Sa5szI6JTpuvIgnXYn5oPRitS1q2Njj/YZyWGQV+mf9V7qwjvvmpJCaMXUbcdVTfF2BLmLjZIob+jTGBjdHsnlUgH4mECFOBapd8MfaQvMJczTkJyyBUZGU7Nzkn+gTkl3u3uy1AX8BTS3Y0CQFOdP+EackBruRBscXMGUxOe
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(7636003)(31696002)(186003)(36756003)(6916009)(82740400003)(36860700001)(8676002)(82310400003)(4326008)(426003)(4744005)(70586007)(356005)(16526019)(336012)(31686004)(16576012)(54906003)(2616005)(478600001)(5660300002)(47076005)(316002)(2906002)(70206006)(53546011)(26005)(8936002)(86362001)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 12:50:52.0682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33dddbf6-3df3-4666-f8ea-08d8f37a737f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3869
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/03/2021 08:12, Joakim Zhang wrote:

...

>>>>> You mean one of your boards? Does other boards with STMMAC can work
>>>> fine?
>>>>
>>>> We have two devices with the STMMAC and one works OK and the other
>> fails.
>>>> They are different generation of device and so there could be some
>>>> architectural differences which is causing this to only be seen on one device.
>>> It's really strange, but I also don't know what architectural differences could
>> affect this. Sorry.


I realised that for the board which fails after this change is made, it
has the IOMMU enabled. The other board does not at the moment (although
work is in progress to enable). If I add 'iommu.passthrough=1' to
cmdline for the failing board, then it works again. So in my case, the
problem is linked to the IOMMU being enabled.

Does you platform enable the IOMMU?

Thanks
Jon

-- 
nvpublic
