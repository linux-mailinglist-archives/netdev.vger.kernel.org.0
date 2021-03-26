Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5234A77A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCZMmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:42:13 -0400
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:25697
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230139AbhCZMl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:41:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EN8pk96w+7yR+/8T79sK8Q+ymyn4o+c2cUcQrPT2YSZY18RJQ6JQoD4Li5cblKvh1Z/2621iBZxY5HCZ2XN03Xw5vB7kTylBb7a4+h5ghAl0sQ+TqBds4Urmh5ObrZjePExhCh3UXyySLa2wof3Z87hGd1CD0iBtLI49mFX5h2NCYGinrrS87BWH7dBOpyU/TAjJseagRen/N83mFWeOeeF6fJV76oIDjndG2eX5zn2ODCwYsR6Qh7avZskxFd1q3MOAQ0ISn2CedYNrpDAb7ZbQIgE7OC6zTh5ONpSaM4jRXiF8HugYcP4euWvYKRV3no7onBKrcdVHz5+IFWs11A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIKgScyvXbYgNQsWpv7eqyjRTtKdHdlMw+46my6yeJY=;
 b=dB6UImSnoiAJVVbt7/5pBpYLIzWYhnabEYyH+yydUjoetyrYoEmiAeZM1JWYU32MJ5O9pzkYq+wnCHmYZtRAjQATBEc8QMGNDWczfQNLs8C95CJYXmpsa879OPEeovQDzc6fl3F1t6xlyw2Ca0PVatV1qOgBCcoJP8hoDqTp//cDXFnCTNxyySe97lHU9Yax1wKQdmmTV0oy5rxevz50DIMH+6ICEUOeRN7ZMceQ73k/xuhGvK2N0fhEEA1TDd7Zia3G0aIVpQWWA4K1DiEZcNPj/OEvrZp6lragL8eQqblR2ru4ysmpHJJBYDpqVarLOB5eesyQpx/kUZIbLV2Opw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIKgScyvXbYgNQsWpv7eqyjRTtKdHdlMw+46my6yeJY=;
 b=eQzxlNM711vy3hHxdtl4JlHIlQjMwecwiiLo5a0gHOHZVTpnCM4pDzl93lLELeMFtpJEZ9bmrXZAuhn7nXjyc7cs17pIwSlsGwIkiWRATrnHcjUnFInhfPvJwQT67BKVNoirjitb/bSnQxH7sT3h+5WS8neu4jp8Gg+78FWdrKrercR5bScAmBK80dZ0tRDCLCzksgsUwlExuh73gMTwJpbQxpGkiSTqIy1y8Dy5uE7skPGStl42FKQFdbXxz6zJ7daV16Xl3zbnpSluBAmvkOofqELkfrAGC2bXooMAKUE2O4Ea6Z03MpP8a61fFInktv7AFgsoyIamzEflXrvPUQ==
Received: from DM6PR08CA0065.namprd08.prod.outlook.com (2603:10b6:5:1e0::39)
 by MN2PR12MB3533.namprd12.prod.outlook.com (2603:10b6:208:107::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 12:41:57 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::d6) by DM6PR08CA0065.outlook.office365.com
 (2603:10b6:5:1e0::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Fri, 26 Mar 2021 12:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Fri, 26 Mar 2021 12:41:56 +0000
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Mar
 2021 12:41:53 +0000
Subject: Re: [RFC PATCH V5 net-next 0/5] ethtool: Extend module EEPROM dump
 API
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Don Bollinger" <don@thebollingers.org>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
 <YF0fm+j7pwxxzHDR@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <92d17d76-2423-9ab2-8fe4-0b86a0be5a45@nvidia.com>
Date:   Fri, 26 Mar 2021 15:41:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YF0fm+j7pwxxzHDR@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b22807ea-d143-462f-c74d-08d8f0548ae2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3533:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3533E2774567667B8C970A38D4619@MN2PR12MB3533.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJ/+MvkaBMFd1bLKS48Ka47v+srVDwpyc3k7DG4apDInls7OiamNf5MCNy1zKdN+0c7WcKr/skbniA4OuyxOsnQI4HbJKcAtUO7y550qYVofnlrACO9df99J9b/OdPzkS3JsUOJ9QU8F2pr9p+ZlsxoAXDcqtzxly2/OlGORJxQpfIWtPBCNfH0bfQnm6zxNuV1kfSqA3tTTwXP7dbRZAc9AARwyRRtsNyykY9FEBDmdsceLE7Wwby6oycCe/Ps+Iu3Hmbz4H8wOkXZX+/MMv91GXQbxXWbdq0IzVB4dH93EFz+un5MIP14z4PB3dyXO6XAXCiP4++aijIsJjCtBcbIHh79mQW/4netfTBM8xRqPrLYqAf7DJpkUxw4Bjtu33Ru2W50PvUYqzgi90V9GzhXu1c7XWY8ol/FiRoGLUcL6Q7xRVcTeKXow0pnMGJYrPUdGTiyy3nU/PybJsF+dN5GSi/Hh7hqk1wAty+w+bu+LuJiNBXrnV0hsL3P/E4JiZQZcGrFO4USEJoZ1XYrunCXX8yZTHY5V/VJGWlAbRepWKbcXyhT3yZnplqh9VIvCHZWDZ49NWnyH4eOg4iZrjzOYEfuPB5SPa7dWfFx3Ie/Jz3rBA1IAqtxruFbQC58CXDNrVYXtayP8RUVxO5Eg8HzoQQolERgrleiG7r4u/i7mwFVv9BRG5uFwOTkh9EaT
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(36840700001)(53546011)(70586007)(336012)(426003)(7636003)(186003)(86362001)(107886003)(31696002)(82740400003)(2616005)(70206006)(356005)(16526019)(2906002)(26005)(8936002)(54906003)(6916009)(31686004)(36756003)(47076005)(36860700001)(5660300002)(4744005)(83380400001)(4326008)(82310400003)(8676002)(478600001)(316002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 12:41:56.9852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b22807ea-d143-462f-c74d-08d8f0548ae2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/26/2021 1:41 AM, Andrew Lunn wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu, Mar 25, 2021 at 04:56:50PM +0200, Moshe Shemesh wrote:
>> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
>> But in current state its functionality is limited - offset and length
>> parameters, which are used to specify a linear desired region of EEPROM
>> data to dump, is not enough, considering emergence of complex module
>> EEPROM layouts such as CMIS 4.0.
>> Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
>> introducing another parameter for page addressing - banks.
> This is looking much better.
>
> Do you have a version of ethtool using this new API? WIP code is
> O.K. I will add basic support to sfp.c and test it out on the devices
> i have.
Sure.
>    Andrew
