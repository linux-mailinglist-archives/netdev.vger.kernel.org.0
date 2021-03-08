Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D43309C4
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCHIyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:54:31 -0500
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:14176
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229468AbhCHIyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:54:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z82isvtgj03Sqrc0gXnHqaUNhOKcZz9UT71kYE2M+55XfFPbTzr85x8usB4e1QkL+TOTDyr27jVHJeuTeOMFL6bFwQjKmRrOJzoenLPKS1kxmQHKRVOjO1WfXfVLGIWHdN73GcRFnh26l1orM1PifBF6nXyHB2Yfulcl8K7VhV93pnYO0yea5Py7rEOvaEq3V4PuWKKeYWbNd9sqdOM/i+zBJ8PdmbIxBTqTXWQMmoskA4EqJyxTT1wzQPx6bPG/1qSSa+NAH4sPDoikigyPXcvIrXxQg8hNLXPkdKP//Tc+UhuD2zBUZNn68yc+JuRqhdG8lggHWkaKv0ndxtfjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1j/4JlQ0eiX0zlDTlIw5xn9qsosuWiws+E+QVcmAWc=;
 b=PmIfr8PTqOXQytaTrRW31obEpKkCPW9MWSWKjy5pxWUGQG+yTly9LsX3WGtMNgEP9SAAVILDCxTwAyPnfnB+VQfFl1PeQnI0N2NtvAyEmwuJG/5S1AUjs4B0iHgatJHzvnDeUJdeknt7aLX8nYPfBB9gjyqZl9tT9LGuKf45bh4/FL3vV5qSNDQMV/UwDBsl5+hQ/gLzRM9SV8hxqSjH2VBuCR6NH9+XTiUze/FaDDWxNaA9deA7Mu8Pjl23wKi0eQMrhj5YV2PhhZg5wKMhd0bYPfJYXD8blnZHqE7JZWetrnoBG0RkGbBnLHeoAx3BF0xhQFy86kZzaexPu1rQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1j/4JlQ0eiX0zlDTlIw5xn9qsosuWiws+E+QVcmAWc=;
 b=RVFQ/Ba839iW00TYiQY4nyBahYvR45NUjzltdzFuprs2W0URXqOm0Mh989tZ2MoUgmTBH/DQXumd/uxj4K1yTKTv2nd8flQu6cMNXDxbEBMKvA+ZlevwXhLj2E9HpamPtCwJ9ig2XPjn2eLERPCl20uBmUIBeC6wp7fizZyv744=
Received: from MW4PR04CA0193.namprd04.prod.outlook.com (2603:10b6:303:86::18)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 8 Mar
 2021 08:54:16 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::d6) by MW4PR04CA0193.outlook.office365.com
 (2603:10b6:303:86::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 08:54:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 08:54:16 +0000
Received: from [172.27.0.187] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 08:54:13 +0000
Subject: Re: [RFC PATCH V2 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Don Bollinger" <don@thebollingers.org>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-2-git-send-email-moshe@nvidia.com>
 <YEGQRW9cYK7pHOC7@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <d1010caf-5413-56d9-25dc-67ff08ec0e27@nvidia.com>
Date:   Mon, 8 Mar 2021 10:54:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YEGQRW9cYK7pHOC7@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea81b454-d2d0-448c-608f-08d8e20fc115
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32204576E871A9E78576479DD4939@BN8PR12MB3220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: at1UopaXYJekI66MfwIJ1KUgYgDxw0I0BwV7vPZDInJMjqC33pww97U4qsxoNgmCZlgjkZua3US2SR3PXKfyeeOlucpSieS/aXOyBsUljRYIfjEmQa93DsJzbwHZCMNdm/Utwu5U+BMGNe3xwEQiiQYmb9h/SHQzGtAJt9V4inInOtUvBQ3Fl7j9i0EcSuhEy1q8N9pYGzauxNmTyzgFg+C6zTUQG8b3BkU04nSNeGnmY4i9hG/qZm9xgfe3dHUWqz6YfdIVmv/h+mjb+Q38FoRWUHY+age9QNchnDP6ulfZGvhDBzYadt/uddBk4Qx6eDcUQBw7gH6SNbabDXO8VbCG5tKdH1WJn42MBCGfztQCGk+ExH84Qo2LLMzfj1jk3sCvnOL8km+B4r6WydNyFyE/L8r2hHC2AoUYo1na1Ibs1NVX6ybj3q3fWRiZsJZ6gzCY2obuIgfvdUA5g7uskWppEU6p5S0Hb4yxDKXsIBU1lay+RoWeEKGd7jiNIhrMPBYD9Sc/bUmNzp3IQ/ntUnOcgLBNpywVNLXHiKvyjxJerM9tBfXbFElyMS0wYX1GkUrTHz3OvWTdxivypH0oC230enBa/YRPhFtQBKEoArSJ45w5mH2PpIYRrgP/BGKhlSIiQkStTcuQy7zUEQ0GpQO3tLMq+Xm/oa7vUR2/cDnFT84MQc0pNK+aTRYkCE3R5zOsGRZwkyf1AykV2bLaq7V/fvI98evX8tNn9f/y98E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966006)(36840700001)(336012)(426003)(6916009)(82740400003)(31686004)(47076005)(26005)(83380400001)(5660300002)(4744005)(16526019)(16576012)(2616005)(70206006)(478600001)(2906002)(8936002)(54906003)(4326008)(36756003)(36860700001)(7636003)(107886003)(186003)(70586007)(36906005)(53546011)(34020700004)(8676002)(82310400003)(31696002)(86362001)(356005)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 08:54:16.4036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea81b454-d2d0-448c-608f-08d8e20fc115
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/5/2021 3:58 AM, Andrew Lunn wrote:
>
>> +/* MODULE EEPROM DATA */
>> +
>> +enum {
>> +     ETHTOOL_A_EEPROM_DATA_UNSPEC,
>> +     ETHTOOL_A_EEPROM_DATA_HEADER,
>> +
>> +     ETHTOOL_A_EEPROM_DATA_OFFSET,
>> +     ETHTOOL_A_EEPROM_DATA_LENGTH,
>> +     ETHTOOL_A_EEPROM_DATA_PAGE,
>> +     ETHTOOL_A_EEPROM_DATA_BANK,
>> +     ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
>> +     ETHTOOL_A_EEPROM_DATA,
> If you look at all the other such enums in ethtool_netlink, you will
> see a comment indicating the type. Please add them here as well.
>
> Please also update Documentation/networking/ethtool-netlink.rst.
Sure, will add.
>         Andrew
