Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72002399D34
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhFCIzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:55:22 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:55189
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229640AbhFCIzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 04:55:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwxypkHgGJg7sLDK1ZvqoWKfDVjm/EBlC25qpPpoHSROn8ODzRmq2csMQCP0dP3CLFSly86DLEV24UNMGqXX/4yISLsaqCr/0i/KQ5x4rMR3GdXq48uZzUI0wnKiieKQqnn2CRYPf4c4Id+rJYT6SB8+U7qk0/mIH6cGLethecms50SijjV1+nRalEv096Qb50ftwAm+1OBh1yStmHil998QyJb9FS+hieVB52Dc4Wrwbwd00oqRzefSOu5fdJIsEq3WXFyODX+Qhc5F5cSl3HC4FXZwa5oDsYlACnQF5Thj7tJCwPb5DpN1mBrDL6SFYjul1sACzvQ8/6uvkc5uQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sK6kYXZD/0mJ8C3UdjAfuAnCYkKe6VMI/tqFUNQO8RY=;
 b=OYEBpxsYdw620sEgNr8MiGRSgRZR86w5LqFH5U04KzuZuqn/OtnQ0q60wUcsaWx8B9nWcW0vFVEI2Ya3/783zI/K48np9z5IPCX3fQWYlajPl3kJA+UVc+b5dFam0wPs8LNicBxKpBYOnply3jDvCMZA7qINwnpdQoBHDSRr0QlupeQHcSzzVPWxM9c4qYwg3sR93gxWYPfIKGbpf6la4QDxMowFBBnfJ1dicIWx6hqKVrEU9NXtMIaXtsCSbwsz/pocoJftadHIE4MuLdiM4UoQL298uc4YY4cDDEDKAHitxpdPbOAX23QMMv5ultNJunM0IFMaMkkdxRkJ8OEvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sK6kYXZD/0mJ8C3UdjAfuAnCYkKe6VMI/tqFUNQO8RY=;
 b=l5u2ZvK2GE/JhBhSWx10yB05l/NJyFMZATZRCWAp9M0x6FbWO8et6Dd3b6eIJXsJ4FEJmAHpV/3m4xGVqkBWPDOei1j/zrobTzi8vYZwxEQGsug0CFY5z71xm6akPgBiIILsmDJTQJWzy4zkY9V+ROMXfKXarWRyNGNWE69VQkciFU2Gr07k7EuN1Wo7Ms1Xn98S1qq06PdLnKiZa07xorMgw0gzlnvgMiaQSDo2BamqBLl/GSNra5LZyobHmjTXzH6FbDHyivfDg9ruFws6f333uRspV+0O1j8m1dKtsHUuFlVLR/NtGf6n2mw8ibmWT9PBIIlYv7No9wbg/onuGw==
Received: from MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7)
 by DM5PR1201MB0058.namprd12.prod.outlook.com (2603:10b6:4:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 08:53:36 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::74) by MW3PR05CA0002.outlook.office365.com
 (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend
 Transport; Thu, 3 Jun 2021 08:53:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 08:53:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 01:53:35 -0700
Received: from [10.212.111.1] (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 08:53:32 +0000
Subject: Re: [PATCH RESEND net-next v3 00/18] devlink: rate objects API
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
 <20210602095824.1d3ce0c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dmytro Linkin <dlinkin@nvidia.com>
Message-ID: <9a922d8b-507b-cc38-c006-46b859d49f49@nvidia.com>
Date:   Thu, 3 Jun 2021 11:53:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210602095824.1d3ce0c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28f729f-a44b-49bb-e507-08d9266d1302
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0058:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00584C592FC117800121BBF3CB3C9@DM5PR1201MB0058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zyhl4d4k6G9Q8ARAbZBSZQ6n2ns8KnhfcSXHw2TtXDaEzXCLLZy4Iq9wv0J1vUDz5GA303aN7H15RSl7AJrijgxKKcjpqV5YQhGUvzrMUpZWYIVsYHnpvg5lJoTC0eqV69NY9jJYlq/pRhEWGpOqOI+mKTCSycRog3pNL6bv32U1fNkEc3MsQbBsDSZkbDW955dA/87QjKFWqOuqipk/QKxA0fhJiRGt6/utleUgrsKXOhVM0c9Cw+Bn3433t3tzTyutIFZapQmNKpEY6x4k5PHW+D7WILBP+67p0sETVxXx7qwno+KQynUen4Mb1AsPmAQkg4VkoxhNoag4PqmkYH6GfPu02T3WLZsbGiKOQHZQzLDs4cAVHFjEDUMy6vkjz1wqjJeIfsJ9dcLnIRdo01GcvZZCwyWuetSC38cGmTgizTxshLeZaqodjG/KcSQ59+qNFf2dexyRCXvYkVl6wl196SePu7v9dEz+iUggb2mQ6EU/dI2lUfe9mVgiBXb113prCw1alhINHA9MXaPt4elakcgk0JAJZAsQkaQvzAYs09dp9USIhptCmnXUcVqREllVU4z9UxOADVVXTLpMmdhPHvgoZCexcrqjJ46dkVsoGQeu+gv314ck6B0Le1SdTomy5Bf5LpcYjKP0eMswakRi4KP2lu34UWLXhe5W1JN5uAzAYa5eRsUt9zatQ68D
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(46966006)(186003)(26005)(86362001)(70206006)(5660300002)(31696002)(316002)(8676002)(8936002)(36860700001)(47076005)(82740400003)(70586007)(82310400003)(356005)(7636003)(336012)(426003)(53546011)(54906003)(478600001)(4326008)(2616005)(6916009)(16576012)(2906002)(83380400001)(36756003)(107886003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 08:53:36.0814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b28f729f-a44b-49bb-e507-08d9266d1302
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/21 7:58 PM, Jakub Kicinski wrote:
> On Wed, 2 Jun 2021 15:17:13 +0300 dlinkin@nvidia.com wrote:
>> From: Dmytro Linkin <dlinkin@nvidia.com>
>>
>> Resending without RFC.
>>
>> Currently kernel provides a way to change tx rate of single VF in
>> switchdev mode via tc-police action. When lots of VFs are configured
>> management of theirs rates becomes non-trivial task and some grouping
>> mechanism is required. Implementing such grouping in tc-police will bring
>> flow related limitations and unwanted complications, like:
>> - tc-police is a policer and there is a user request for a traffic
>>   shaper, so shared tc-police action is not suitable;
>> - flows requires net device to be placed on, means "groups" wouldn't
>>   have net device instance itself. Taking into the account previous
>>   point was reviewed a sollution, when representor have a policer and
>>   the driver use a shaper if qdisc contains group of VFs - such approach
>>   ugly, compilated and misleading;
>> - TC is ingress only, while configuring "other" side of the wire looks
>>   more like a "real" picture where shaping is outside of the steering
>>   world, similar to "ip link" command;
>>
>> According to that devlink is the most appropriate place.
> 
> I don't think you researched TC well enough. But whatever, I'm tired 
> of being the only one who pushes back given I neither work on or use
> any of these features.
> 
> You need to provide a real implementation for this new uAPI, tho.
> netdevsim won't cut it.
> 

+Saeed

The series is already big enough to add more patches to it and
implementation (mlx5_core) must go through Saeed. How would You like to
proceed?
