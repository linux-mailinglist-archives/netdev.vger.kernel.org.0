Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AE54B8691
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiBPLXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:23:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiBPLW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:22:59 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8252A1F79E9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:22:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihK9NIWoHYIcCn8NvyRhWTL7Ao2b4EZbekbj4v1R4IoZx0OG83TBGyFvyDyrWs10gYHnzWhtJnhLeaxAabHoebARNoWj6nG7SZHqqMxnZUd58f0tDA5Hpmd/qDqQYNHrS6ZmzrT0mCbdTH3hdCjfB8To82Z9BRo2+J07IRu+vfjx82Ogq+7d5b/QPCGd/ZMxQ0VrnWU5pzJNKVtWoJPWx5eDAyOHl8ww0ICBtEXHr/mWBNwptwLDU73zNxvALG4OpTlYS5q6UnkoWt9RH2KVpQ6QpMIhZV7HxRIOyhlKqOZm2dbkWtc785dM5q8OTqrTumrGphf9PeuNG66gAZ7jEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adDStaoYHtm7bO//tpTkci02v84muB+yI1YVtZEMf6U=;
 b=BsfDTvSH80/hsZs5M3giP5hk47dBqVJ2sWdg67C5PXJq9/1ky/WEvx14lnPHR9oKhbzTEKJviS2oSOkQjUKHk36PTSIVUuz5wWo8HbijNhDh8zatZQx8jbd3MGk26VzfwsMWQDqJ8FJAdH/tkuEnwroJ0XKdpZnfNgan3AFggBuTd/S/t6UbD4819UTcTz53lBj53uNCIFDn7J21NbulXGWa2TbCYZMW2mWbHtOPugzddXWpJmtDtZTjT9r/JrymoekR0+6c0zlatBrY5f5MTg9UhzmAzcOw6Sc1UnjhlTrKZLTAvB01r9xmuqSVhPG/i2gjZzv5vRw2u1GFUyz/yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adDStaoYHtm7bO//tpTkci02v84muB+yI1YVtZEMf6U=;
 b=dw94rBie5DGCyGSTtBlMUOJyfm3oBJuwqQmPFarlKbJ18tkpcnqTbUReyt0+KO1FeGKo3zgZkZt1f/pElYs/FsnbKRuf/ZwpPSRG4OMq2mL8jV/shFS748Y9I/v1QL6ct56e/DtvFFxPRmGQC2TjHeJ0VZH7/+zuZ2Ksv2Z2IBNIPYAmWGHj/wa9I2AYvehn9lCbUcDNM6p3G/V0bikgU4o2yn8+YZ63aNLKbFiR/djcF12pU/QOYwPLwvtZw2jB/H7fjfIaF89O3/YOhAhjA1U7fmUYlzvOif8ws/y6O5wgadMKj/JXb248CtJV4rmh8813mx5BUXvVCVBOeyXfYA==
Received: from BN7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:408:34::30)
 by PH0PR12MB5498.namprd12.prod.outlook.com (2603:10b6:510:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Wed, 16 Feb
 2022 11:22:44 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::f9) by BN7PR06CA0053.outlook.office365.com
 (2603:10b6:408:34::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Wed, 16 Feb 2022 11:22:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:22:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:22:43 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:22:36 -0800
Message-ID: <b2c0d6e7-72d6-ce92-894b-711e67f2f70a@nvidia.com>
Date:   Wed, 16 Feb 2022 13:22:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 03/11] net: bridge: vlan: make
 __vlan_add_flags react only to PVID and UNTAGGED
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-4-vladimir.oltean@nxp.com>
 <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
 <20220216110845.4vu2bcsuez5jhvn6@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220216110845.4vu2bcsuez5jhvn6@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b395495-0fc0-4625-5e54-08d9f13ea715
X-MS-TrafficTypeDiagnostic: PH0PR12MB5498:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5498E2108DEF77A84A8EE610DF359@PH0PR12MB5498.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIk9kkW99b1x10oyrYkVZy5QJOiDmIOe5cG0uWX1upTeiQ1pqQW2PRsxOTm9FJWL31dMBI7+gLHGJmFv38DLQAVz9Oso9T2lRijqpKsh3AsPZCT+KYc5hpMqQXIj1517+jaOCAQaOJG3XP57MZVmPsAtUcU+wulhwgV3/ZTf5lSD/PKHa6AvWfY5o4aNmCWmB1RKQQZAh6sR/VTt6YSrmxxxj8WznkD6geYPzPIWNZstk28l27gnJIdtZzlNF0eFzZk7Ui+Q9egHK7Y14fULSZBZAO9Ra2+rJvBk/PGetcheiMVFwSrgizIZQGQUuurFGy7nF+72joSoLw+34F6n3Bq5MEHj/z28QS1+2l9b5dlAlrrrXFu2HN0USqpZsQFQ02y00WQmZW69MIDWdxI1ZGQQRRnATclkcKqcWnHXuZZx9OWwFbNnvpWrF3fuXqgvOpp9Xb5J2zF7LdyEpsuYzL59urS9Klt7cNe+uoyWsmkv6TDtva3DVdPrsANQTc+64feRGnvlA4BzDNNdy7/9DVrX1a8QgAdOmPVydhba3zVBRX7ZYUiGswtvhH8SGkKO2tgFkTIvyD3Jv8lw5TQ2j+cZyVPkSyuVcenoT4a5iAIhR1iv1vMqDgOrTxupVT8sgMiAFWmUfoVYLwvOCBhpVtMDJylPrsZD+7vqBjH7LTQjdib24lijZTG2lDM+OnS54fGA70sDW7RZ3QZxQ4g+oIq22LKhmnZFHe6ELmtievNjVIzviLMkjlFIgbZY9Qls
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6666004)(316002)(4326008)(8676002)(86362001)(70586007)(70206006)(508600001)(82310400004)(16576012)(7416002)(81166007)(40460700003)(426003)(336012)(26005)(5660300002)(356005)(2906002)(186003)(31696002)(4744005)(16526019)(8936002)(54906003)(6916009)(36756003)(47076005)(36860700001)(2616005)(53546011)(31686004)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:22:44.1379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b395495-0fc0-4625-5e54-08d9f13ea715
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5498
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 13:08, Vladimir Oltean wrote:
> On Wed, Feb 16, 2022 at 01:03:54PM +0200, Nikolay Aleksandrov wrote:
>> This patch is unnecessary and can be dropped given the next one.
> 
> Not unnecessary, it reduces the complexity of the next change and makes
> for a cleaner transformation of __vlan_add_flags(), one that doesn't
> affect its commit behavior. The behavior change will matter for patch 4.

As I said in the reply of my reply - nevermind my comment. I agree that the
description of the transformation is good to have and to be explicit.




