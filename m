Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74578337A26
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCKQ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:57:20 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:43587
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229712AbhCKQ5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:57:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJOd9BUfN4p4zO5Szyp9fIaNGo1R/N+61pedCF/gIGt9eqke0AK6K5fWL/Zgl2a4ibh3p6+POBA55WSu4HDHjwV8NDhuSMswRqZRxVi7TyLZwFygsYy2pQmoq68nAYfFovALFpVjE7PCsiXgnbw2EmcvW2JHUv+xp1oW2bqx++XXopgc+pneOsXq4C1lvCV26OBfM+uP5B17XpL/FctD7WgTRCcNXeY7patdga8FCe2IaiqzSYpjzHbZfYJLe9lRp8kSVL/HmOk5q8lBShkCv2PH9QQuk/9kEYYbDI9wQpDFJ55UBCTK++XnpQNCoWlWWORrfISl4oZKAaIJE4pxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ksDIO+2tdsqhdMQM6wkmqV2ZwYKSvviY0qV1B+c48=;
 b=NMK8oKAMmmKAy3CWzFiRbbv6h+jhd9CTr2pXpvjbLTzaz1g3azvFmRorrjU689LKDGFaGtdcMq6Uz5wUo+q82Lhmmt5HGsXizaXbY6MN6QyenE0m9zfRh6yl2pgrHx2Hkgg3yJCHGK9TxPYe3BcKjHx2+oPuTBHMfsA89UJLpDxC53flpJC1vMtlFpyN4BRKLR5TouEhr2Zs9ApSXTPDmS1nIR5nZrFVRoaLliu27+JWcmIAFU4SZ2Xl4MGPoDUZvAD78ayD8r/QSwwEcrqvSEhRaZGlXgIYTNd7XG81o3/IVW+qLYmktpN1f/18ztYw8GTKUT+j1zgy6wrurtSPXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ksDIO+2tdsqhdMQM6wkmqV2ZwYKSvviY0qV1B+c48=;
 b=l6wICCwLvAqzqQ/itcfMHcFndLHBkFQ4rx/vh2dxtMCJNGlcWoa/QuaQFb1/yf0q01uWa/ddrueCtNs6Pi9G4UJ9QcuHBTqWq8oJaM8fX9CU38AJCTpwdttlrilt9PtDrmXt/wjGNjtBEodAwuR4KggXIHsum8WjLc8Gpnj7ffoNqsz1KsoLj7o+lZ1Y9d1T9zqZxF1L8AW0xXtt4eN8aGuqHroNix5GnX0wc8IIySljuIX3Ygar2KV1qRgf73jRqMn00TS2JsuHRWavLFf8ocNE1Xxu0MEeP6NSzEr6XrMQdG2N0GDG/Qvngi/HUMuMMD7Hj3VjlU1neuh2mzR8/A==
Received: from BN9PR03CA0073.namprd03.prod.outlook.com (2603:10b6:408:fc::18)
 by DM6PR12MB4730.namprd12.prod.outlook.com (2603:10b6:5:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Thu, 11 Mar
 2021 16:57:16 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::91) by BN9PR03CA0073.outlook.office365.com
 (2603:10b6:408:fc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 16:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 16:57:16 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 16:57:13
 +0000
References: <cover.1615387786.git.petrm@nvidia.com>
 <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
 <5cc5ef4d-2d33-eb62-08cb-4b36357a5fd3@gmail.com>
 <87k0qditsu.fsf@nvidia.com>
 <6c703efe-0357-e83a-f5b0-3fbba1b3228e@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 03/14] nexthop: Add a dedicated flag for
 multipath next-hop groups
In-Reply-To: <6c703efe-0357-e83a-f5b0-3fbba1b3228e@gmail.com>
Date:   Thu, 11 Mar 2021 17:57:09 +0100
Message-ID: <87a6r9iq6y.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0ca8c5a-5125-46bf-f882-08d8e4aeb9de
X-MS-TrafficTypeDiagnostic: DM6PR12MB4730:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4730CBC882F9E6050E99DFF2D6909@DM6PR12MB4730.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRTNyOsRoovHzlxS2ZrqkKH5iF53ErkeLNlVqq53+eQW0t6pPpcqrteExN3v0R7+ensdy94wxiIGIxS4UxSxUGBMH3P7hBLVsIp5gLzgVpSd56aomf7xpCZYDIQ7YsEgaKtPb4L1n4684V73NYLXYzs0HFD5+/AexkQ94k+AYx+fwuAMvlwXfMAUAveWAPyNhY+p4DZ1mhG4fmKLQwe7TZWcaCMrbxmwDoqcIrv65JErGIdmqoPrxoKqJBvgnAIS9aDQmAqzsepkw+iSn3mdfmrl7/rzJtLCT4+TYbd+Nzav8qcgGeVY98lT563RA63I73HGJGQZgfX5kLpjMi+X56YEe86/qSfBzQLnsHqZqwburIyiCMpv/F6I6YRwY1pIU9Aux78ViNOdj6e++yP7oWYI3mmzXfnNGNmL1ar017fvkw9RnEW0yLzv6GesELmL1nvuBSkGuGTyL4drVZ6G+qr9nOya3NhSuoqzzF6mAOKjRGSkXzlghUtY3iOco0nni/Qxyd23g++HPyP+ULtWg5uKijHOiPc8OaRoDhXbPNwDGj6WQ6OPinNLZDkZvBQmt6+ToqNsVKNOM/iA6xYgVCuU7xFpBDsMbwPdj4A6ZQEt5r4TLDEKP1KOAJaVitvgF7614RtXBAzNVXoG0t73xhb5lZ9C2VtTsx9xRLoqqvex0J+3PPKilMISGD73IogD
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(336012)(478600001)(36860700001)(70586007)(54906003)(8936002)(82310400003)(47076005)(6916009)(34070700002)(86362001)(5660300002)(7636003)(82740400003)(53546011)(36756003)(2616005)(16526019)(6666004)(2906002)(8676002)(426003)(70206006)(4326008)(36906005)(316002)(26005)(83380400001)(356005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 16:57:16.5086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ca8c5a-5125-46bf-f882-08d8e4aeb9de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/11/21 8:39 AM, Petr Machata wrote:
>> 
>> David Ahern <dsahern@gmail.com> writes:
>> 
>>>> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
>>>> index 7bc057aee40b..5062c2c08e2b 100644
>>>> --- a/include/net/nexthop.h
>>>> +++ b/include/net/nexthop.h
>>>> @@ -80,6 +80,7 @@ struct nh_grp_entry {
>>>>  struct nh_group {
>>>>  	struct nh_group		*spare; /* spare group for removals */
>>>>  	u16			num_nh;
>>>> +	bool			is_multipath;
>>>>  	bool			mpath;
>>>
>>>
>>> It would be good to rename the existing type 'mpath' to something else.
>>> You have 'resilient' as a group type later, so maybe rename this one to
>>> hash or hash_threshold.
>> 
>> All right, I'll send a follow-up with that.
>
> I'm fine with the rename being a followup after this patch set or as the
> last patch in this set.

I looked at this, it's more than just this struct field. There is a
whole number of functions with mpath in their name to reflect that they
are for the hash-threshold algorithm. (And then some where the "mpath"
reflects is_multipath assumption.)

So I'll send this separately, and have it go through our regression.
It's still trivialish renaming, but a fair amount thereof.
