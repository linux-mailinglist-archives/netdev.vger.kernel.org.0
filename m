Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961E2368564
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhDVRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:01:53 -0400
Received: from mail-eopbgr700043.outbound.protection.outlook.com ([40.107.70.43]:18256
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236058AbhDVRBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:01:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLITGmucItkZ8FKU/CQ2y1/c1JGHFB2urbWVDcrTv++lXidScm/LVmceG5MQxxgDkWsEdWxF6joCiMPyDu0gaehsfWqM4EicivpioHOhalMSShG5Mqm9lHQy1Ir6Glgy9qU6zU1DB3hPKHNyPR8S2AUkJWcYcz6tchHeydx2ygZUlXB5ymg7Ir8Ky4KVb9qO9ZGgyI8UvOAEDTy2lYNseOvbOuZ1zlnRdTUBr6KWnsXgSVQ2I6mkXZUPTf8uXrMT19JqAgWcLojGOt7Sev0JjQa/d4S1McO59kybBmqviiSdHvW7yznjWjDr4VGwMblV3fDKuXgYhXqOEgT45dHYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/XUKfoHp8vIO7OnmFGDIu6o4f/VMba3XZqbYF17QCM=;
 b=nPzPzJ7ZkChJu7urCDbjXhULPiOtJ8xNgOzTN1eEmUBVaypKeeA3oWjlZLXbbJ9+wNR9fB722KQdrZqT8Sfsaph4KVM7YmHbPrnBClyX4Ter8XPL2AaN/5r70M3E7+unasgWmMcntxJfZttDBhuEe4cnRu+Xmcd3uODtiT1/vcNSx8hkV6DCDMjZvICAP6UsWIc7ERA3gKH4ZD9MLkrqG4bMsCt26G21yRzL8+YzxdF6qxJaxVtKqwWLpCOwrErp6pGnpHPgneG7vE9LWNn/EZ7rKAQzkdYvHH6QdSLvo0SVZjejeAm8vZaFOjAaBMNWIEC5gfH+JyMXWOk6r+NKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/XUKfoHp8vIO7OnmFGDIu6o4f/VMba3XZqbYF17QCM=;
 b=HJyhdlqLyQR3ATFu9h8bQ4RPInJTRPmz+Rh7hX5awENfzHfFk39a2+q0O9wHmuvLGqLtB9UAEVYPJr1HKZ97+cHXKaTi9GSSpQTGM5ommUVIFIKbcthRR61TSlCQM8XEVnBjkM2Fc8RzDci9Czs56XGTR63Cx5MNQlHe6KMNEGhr2rVyGrSjPKisTKaU4tJdPqY3pwRtUJtINEb6eTorKfszL86Zn6s7KYHBUGuIYe9MDgtH8/JBBIE8gojPoV2oRvKnvjcbumPeDgy4nAxolIiF2eoowYVUBeY9JF3tuTPFXPK4dLE9JuAJW2w3YEvYKaTzZ1ZmA0DBUN+AYsJqkA==
Received: from BN6PR17CA0008.namprd17.prod.outlook.com (2603:10b6:404:65::18)
 by DM6PR12MB3435.namprd12.prod.outlook.com (2603:10b6:5:39::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Thu, 22 Apr
 2021 17:01:15 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::f0) by BN6PR17CA0008.outlook.office365.com
 (2603:10b6:404:65::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Thu, 22 Apr 2021 17:01:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 17:01:14 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Apr
 2021 17:00:16 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
Date:   Thu, 22 Apr 2021 18:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 762e7a81-203c-445c-a8b9-08d905b03d13
X-MS-TrafficTypeDiagnostic: DM6PR12MB3435:
X-Microsoft-Antispam-PRVS: <DM6PR12MB343534AC8F49BD89405F7EECD9469@DM6PR12MB3435.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sdXssc4iqnwJ6brdiI3mdnGXGAGm6ACDa25xdm0sSLxgAiG/lUgJMMSAOip/EEgS3QD79nEio3/GIqp8TsDx2GJDv+rM8s9rSaX16/+Zv+YRoRJMLu2sH/9ITrtHGdOv6vqfK6J0F+rQQhm4MT67mGcRDxe6Fmz5i6e3AHyPSum4XHvFI7WSIb2dyEHFgNlcNgPLf7mNZmZ2PqYlBKhZoTMsxXq72S4G/z0L9vgdsUHleq4eEPmmiD2fWfgI3BCCmxi7gSoUWNEa995PcWz/bQ5G+nfNoHDtjteOUXKeRCzmZCupEvMzdVI077AZIPMWnKCJXM39/hs667cklX+GyjGKZLc0qYVP1jezXaGRP/wSn/7JjFvTat0nV26rrABAQO7iphUggMlEGmQTBRwnRiTawgE4Yl/vytVMPF1AFDrscJsQTjMq3pFkLAtAp6Lr/5ZI6q9riRujwwulH1iJ7U5THcqqlv/4wM/7KDfTshO40jVUlbkNCRQSKcxMWedky6EsJ8Tf72KDzj6ItC04gjK55tpnKyZe1MIW8YaiPUmdgMfutIx2ZkaKtzg8oDCfgv4UIi+lEh4R64r0Ddpr3j/rNrZWgTTU0tqVPCpso/8LOLtJX9e+rQExfqkZ+Wls4YBycv+eSi4UXF/RVJnNd8d592be2BNy258SMcB5nSs08r00aYz1fOdnpI9sY87zwnU2HpxMt9Aa2gehID012cmo5fX40sCdj1JX97lhIvbS/+zMB/i7zN25r9Mdk0bUvtSQBIiwD98wGlApSDj+Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(31686004)(82740400003)(83380400001)(16576012)(36906005)(356005)(316002)(5660300002)(82310400003)(86362001)(426003)(36860700001)(7636003)(2616005)(2906002)(110136005)(336012)(54906003)(478600001)(47076005)(8936002)(6666004)(8676002)(966005)(53546011)(186003)(70586007)(4326008)(26005)(31696002)(36756003)(16526019)(7416002)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 17:01:14.4128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 762e7a81-203c-445c-a8b9-08d905b03d13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/04/2021 17:12, Florian Fainelli wrote:

...

> What does the resumption failure looks like? Does the stmmac driver
> successfully resume from your suspend state, but there is no network
> traffic? Do you have a log by any chance?

The board fails to resume and appears to hang. With regard to the
original patch I did find that moving the code to re-init the RX buffers
to before the PHY is enabled did work [0].

> Is power to the Ethernet MAC turned off in this suspend state, in which
> case could we be missing an essential register programming stage?

It seems to be more of a sequencing issue rather than a power issue.

I have also ran 2000 suspend cycles on our Tegra platform without
Joakim's patch to see how stable suspend is on this platform. I did not
see any failures in 2000 cycles and so it is not evident to me that the
problem that Joakim is trying to fix is seen on devices such as Tegra.
Admittedly, if it is hard to reproduce, then it is possible we have not
seen it yet.

Jon

[0]
https://lore.kernel.org/netdev/e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com/

-- 
nvpublic
