Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8594C498436
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiAXQEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:04:44 -0500
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:47456
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241090AbiAXQEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:04:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj4Q+wHN21g+Dp+jZppHv5qCOTe2R6qp+lGC8QCq/+Y90ezX6bgCJhJQlc0eWrl6sarHwqaFOnxggBBrTIUy5pzFEws0dX203r5Dy5paJwiPCCX1keT5E1zVXxRgEEeOYmPYKs/NAnGDyRKnEZOx9yH8IvXVYbJOVsIkTWFf8ozUnDThqdU3Q+2yfyxPM5QeT0mLnxt3faGSeV9dzLdHf74nPVHL7k5kB/LQ8Ulo2DMR0WfcDzWjREllzDfo2E0I0V6y3fYOvFaGYu+lAfl1PPYODtVFrgfOh6JkdvlpbHwqa4otlwPcq966NL7hsvGpDHDEiOck3BOtWV1HfjWazQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9Rqklwm6xmRPZUnmBs/xzlDuJ0RiAGE0HY1U/tx6zw=;
 b=WkQp5TnMNlRFJF0zXIlYT2cZ7L3PgtAO7BGH1pbqVSzYJP10xHQlxz/nVJzeKPG/stnbPbHCM/1zOoz8d7bWWDnASZAFSevGBF89tydrFiadC0riP4oHPVB3U1vb0iKHzFLzvs01aWd3l8qU/gIdapUObkGHgTKiMCU5g0o05WRTlokVrIWxqcqIYZoWP7nhTkicI2qr5Dp+Vgg3Wt2Qkbl/RSFZOO5w3a+waWCEvRWW0RsDpLU3jXorRCtpgqisYQ+Go37J7Ip+gmifD2cZ78/RI5InC27e53j6S9oXMPkBsJ1VzDz/gaeXfBJNnMtzsxrvjiGYdgMLKIaFGFw/Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9Rqklwm6xmRPZUnmBs/xzlDuJ0RiAGE0HY1U/tx6zw=;
 b=gjYJbO03QrCwPMY/cT5WyNlwk+EhIslzCfaApH30liPOfquI+ES6KSO4kB41J0Xs8tdZn7A0VEGaf7mJ6ymr02qwOyCHaSKM/30P0MIAb+GIpfCZBd/2dC9eqkBJp13b8NEV+psMvBJ6H6nii+t1StuC8gnFWDyH+AHPWn0vgx2FuPP1A1NVquvKvyRFNZvzr+7d4qAkRc03aKDpMG/qL3AjsY/MdSd4ZvLkry96+fuxyM/awppAz04UaafREwXIxzDyDALom4seezxaLYDNs8YPBq2LDRKEQP42BanyN06EOAJHsS5DWHczThuQmbFxEwWz/aDQn8lO21vxm0m9gQ==
Received: from BN1PR13CA0001.namprd13.prod.outlook.com (2603:10b6:408:e2::6)
 by DM6PR12MB3195.namprd12.prod.outlook.com (2603:10b6:5:183::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 16:04:29 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::ab) by BN1PR13CA0001.outlook.office365.com
 (2603:10b6:408:e2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.14 via Frontend
 Transport; Mon, 24 Jan 2022 16:04:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 16:04:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 24 Jan
 2022 16:04:21 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 24 Jan 2022
 08:04:17 -0800
References: <20220120095550.5056-1-moshet@nvidia.com>
 <Yel1AuSIcab+VUsO@lunn.ch>
 <172d43f5-c223-6d6f-c625-dbf1b40c4d15@nvidia.com>
 <Ye1yCtN9g/9+Sv5Q@lunn.ch>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Moshe Tal <moshet@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] ethtool: Fix link extended state for big endian
Date:   Mon, 24 Jan 2022 12:58:00 +0100
In-Reply-To: <Ye1yCtN9g/9+Sv5Q@lunn.ch>
Message-ID: <87czkhp1c0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b96bb2f-758b-4462-c0ce-08d9df533399
X-MS-TrafficTypeDiagnostic: DM6PR12MB3195:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB31954BCEBB1B5BFBA4C603B2D65E9@DM6PR12MB3195.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qI5UbnThSvJpVdQ2Nf+X7usjWRP1kcgjzUCmecH09ftzg+8/eaonDusVu4adVrSHW79yZkb+Y4WHYNMPaLa8BWVE0t1cKnHn5HRlQr10sdZUlc0Ro0ISvG9dgy8aHOoKAA+x/Fm9mBBAaWQH7AJEP1zXladBUE8OiX2XNwl4r3docfvNVQcuwDNvUGR0acIRX/kcpWvzhijEOQFTjfXcRJePqg4OTNDPhhp/v0jJEHz/2BRPJMD8yT3e1bQPtQ757+4xyvjYqW+lX9+Eqq099eEtiHgxH5rSU9Fyfh7o756WEe0wyhL5qq54FlFcnFliRntsPthfYIAO80GwSUighGK/ENgc5d0QukAIUkEo0srIMgwQbZlvPHyaOkk4331NIRm9f8utYNkuXg3u4q88jOYhTsUG24vuyht6E+8Vi2vnLHryIexF38C8NpzGISd01tDyF4iiapN2lUYfWAgIMV6KiYGJEYyJHpwRkQX7jugm8x2eRGj8O4XiwKP1cDSmfbmn81LvSjNs7G9df/SG1kGuXQNuoS7IiScvfZtRW2MYcy7JfY1zPUeaZGPKboae0iOorp2plLGUpU3S2USU3nDp9CWD7dSJs01R0lghjNkf1UdLSA6lav2+ildWtaoZ1EdxuOhJTUz4DZpk6dpPtNRjWAU73Ryj7LWmV1noA/0Zk0SZM0B/yMkcBZxDUxL24+D3NxVNOsLdlSAQBb+Bla8qaFfB11i2ENup/zAbZv2aWbXs3VHOJzIC8wXK60B+w7MbLiSV/Z9U65KK9Zk20djnnKtZOEKwHflPCOxBBNc=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(40460700003)(426003)(70586007)(36860700001)(83380400001)(6666004)(47076005)(8936002)(86362001)(5660300002)(70206006)(26005)(6916009)(508600001)(2616005)(8676002)(336012)(186003)(82310400004)(2906002)(316002)(36756003)(356005)(81166007)(16526019)(54906003)(107886003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 16:04:28.8754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b96bb2f-758b-4462-c0ce-08d9df533399
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3195
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn <andrew@lunn.ch> writes:

>> The Netlink message was defined to only pass u8 and we can't change the 
>> message format without causing incompatibility issues.
>> So, we are assuming that values will be under 255.
>> 
>> Still, the compiler is storing enum as int, this isn't matter what the 
>> size of the other members of the union.
>> If it will be read into u8 - on BE systems the MSB will be read and so 
>> it will always pass a zero.
>
> It sounds to me like the type system is being bypassed somewhere. If
> the compiler knows we are assigning an emum to a u8, it should perform
> a cast and i would expect it to get it correct, independent of big or
> little endian. When that u8 is assigned back to an enum, the compiler
> should do another cast, and everything works out.
>
> I assume there are no compiler warnings? The enum -> u8 is an
> assignment to a smaller type, which is something you sometimes see
> compilers warn about. So it might be there is an explicit cast
> somewhere?

The only cast I'm aware of is the implicit cast in the call to
nla_put_u8(). The C standard has this to say about the conversions:

    When a value with integer type is converted to another integer type
    other than _Bool, if the value can be represented by the new type,
    it is unchanged.

There's more verbiage about what happens when it doesn't fit, but we are
on a happy path here.

I'm not especially well-versed in various warnings GCC gives, but I
think it only warns about expressions that involve literals. So
assigning an overlarge literal to a narrow type, or literal-only
expressions that would overflow the type of the expression.

> But you are saying this is not actually happening, the wrong end is
> being discarded. Should we not actually be trying to find where the
> type system is broken?

The mistake was in the union. Both the u8 and the enums are laid out to
start on the same address. When an enumerator is stored into an enum
field on a little-endian machine, the LSB is stored first, and that's
where u8 is laid out in the enum as well, so you get the enumerator
value back when reading the u8.

On big-endian machines however, the byte that u8 is laid out on is the
MSB, which is a zero in our case.

The underlying type for an enum is an integer. So de iure the fix should
have been u8->int, not u8->u32. Practically I suspect it does not
matter.
