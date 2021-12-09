Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4829B46ECFE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhLIQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:27:11 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:27072
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233101AbhLIQ1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 11:27:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIBdJ+gYgY8xnSktOdouzDoWfNuTKo42QnRmOk/T07PjbP+VoL/VTR4gbvtnIzP0/lHoOXF/Fkof2avxIQxDI9fSg8BNczkszASGfwBohO/Px7zKWmRO+Um6U935TdRuYzbWfKc5Cz/QCCSxGJOzFS/2OwTflWTyUupHUnj+qR6ybnLSgf/f1rsCXVrEuZooWKIHZcos2q6ZXXHHXQdONKxiu3wecdD2OPk2FONH7j+ii7jk6pThNvTJmybNN+5ry3Kp1+5nBPyoearhk/hPxMeoJk601cJc50CtFRWgP7v0tjohatuJwL9EKPMKE9I82dRzwO3CLFb3gjn1s9fjsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dufZWZg+g+g2rXhkA1lE4OjxRRiobz7I5ZTAyPO2CR8=;
 b=U5QF2fRipEa0k2m6OcNGmtsxhzl37yiWdadaMWqt527VcwNLq2dFW1R6sawnDAAQur/6nO8cjE13i3Ukk63yP7kwP8XOcsHSCbLyP7UBGMXYxPjiROhmp/VUWrwLrssTX/CGFG/BCXV4eYLZPB02b+q1cr7jEGnyo9V0u7D1qlC/AE4B6RODTdWaQ7oxFbNQKVvG15PdJuqSRSboQFUZ2JEjJNeQUH5x7JpQpBuogZELdNTYeK98Pc8FxLDZPmYCVHOeDx7Op02osAyRRtLEw2qM5oIJ7XxXz+7oYr76ebjXbkewV/i16dnWzLhH8r98r2S87BttihbQiH9tOSCIWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dufZWZg+g+g2rXhkA1lE4OjxRRiobz7I5ZTAyPO2CR8=;
 b=n+44F7QBoRyMnNVzrGKZqGsdumzjYGxljVqnUJh+CHhvHnTRJvDXiGtMv5TgbwAOdXtG18nXPnX79YYTRabD6ZliVswK69g33UDjb6Rn/Jl1R3aPiTHntBGY9oZiaEiN07eyxIVOFX+BduOH4EzMJs44RifpAVu0X0GyrLP9HAzPmK7whZ8jZeFYkLvaTTXkHq0bGhuhfb9k4HZSZTF8em46MMhyetD4l55bqGOCQLcXv0J1KiJZ173+0Qze/NWvT2Xa6AYDds9n0EAE4hSbPZxuuVW2lMeBKov7ZqNECUb4AWpMkkPEikrL5Fb+Q1UygpZEI5ZrZ9+TJ4lO0BnWvw==
Received: from DM6PR02CA0109.namprd02.prod.outlook.com (2603:10b6:5:1b4::11)
 by MN2PR12MB4487.namprd12.prod.outlook.com (2603:10b6:208:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 16:23:36 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::5) by DM6PR02CA0109.outlook.office365.com
 (2603:10b6:5:1b4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Thu, 9 Dec 2021 16:23:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 16:23:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 16:23:33 +0000
Received: from [172.27.13.125] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 9 Dec 2021
 08:23:29 -0800
Message-ID: <481128e0-d4d0-3fde-6a9e-65e391bbf64d@nvidia.com>
Date:   Thu, 9 Dec 2021 18:23:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Lamparter <equinox@diac24.net>
CC:     <netdev@vger.kernel.org>, Alexandra Winter <wintera@linux.ibm.com>
References: <20211209121432.473979-1-equinox@diac24.net>
 <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
In-Reply-To: <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d42391f6-47b0-43da-ff77-08d9bb30403b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4487:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4487D372489529B2AC19A064DF709@MN2PR12MB4487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i8F7NaIWnLa15VsjhYnm270kFmnYKbcA8ssHNJdznTUuOAG5acOPPRnnVohdzwUjWlPL8Pf4869DXUAJ7bIG8P+C0VQLNXVJ93MYFu5jjjzSbunRmf7JeYnc2Kv/QPrV4da+XQuljtm2opfPg5deyJjb2Dx6LNNwr8+zIAm32CkmqqZldSzRwQv+3eY7Ienad0b1JxbpESIWhqHKPdJpZBd8zCdKpRjDL7gqHwbq1rwrZ3Visd2bZG3HJ6bNzK1tQasS1dLAp5oy2m2libJU63Dm/ieCDawxTqDZAGy7AE2mToN9wkQpsT6hSdt6LW1JSa5lXrWVebo4At5h/aTFT9UMMWm5BSCg6dxOpYwze9ntnT5/zs2I8FOvvTy2N9NW3Lhc6f/YQJ6IWRIBG/v52TqyHYupnWQ0LWI1tovaEcXOp/bstD9JUc5B7fNxwVr9GJtOoomtJ87xbdV+AbjPn3sX8Ah5MLsif8geQ1mvnJqlTM+yp9T6CfasRQ3cjgjk9CJHlHgfQ0UU2SsalMxpglcAsNZtRUzl6BsJ85EjYqN3y7QuJKuiT1EEdByqLkzF/phOnJQ3LlJmCbk1OYUukT1lIcvawYBf8WA5f/ghser45n2mjPXyxBb4xB2wbMMg3ePrYcIqWDhWFmbECWgr61MA+jTt2TYMIAsX+VdaCktKrCUXU1UdpctlW+5Dn5BFqBnzdywcpUFh/kRixpNOAcDzU9A/DJN+LHMc3LVZoMHulT9z2URQqSvSkwX/nOTAwqFoauad/6RxvmgiGnQqIM4Ak634ETxpSIg3s7fny9ugGGsrgdjCUq00NIp0vIBcMiJFJmZ5EHabKZKttJ31dg==
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(54906003)(4326008)(36860700001)(53546011)(70206006)(110136005)(26005)(47076005)(186003)(31696002)(316002)(34020700004)(16526019)(16576012)(426003)(31686004)(82310400004)(6666004)(2616005)(8936002)(5660300002)(83380400001)(336012)(356005)(7636003)(8676002)(40460700001)(508600001)(2906002)(70586007)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 16:23:35.5722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d42391f6-47b0-43da-ff77-08d9bb30403b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2021 18:08, Nikolay Aleksandrov wrote:
> On 09/12/2021 17:42, Jakub Kicinski wrote:
>> On Thu,  9 Dec 2021 13:14:32 +0100 David Lamparter wrote:
>>> Split-horizon essentially just means being able to create multiple
>>> groups of isolated ports that are isolated within the group, but not
>>> with respect to each other.
>>>
>>> The intent is very different, while isolation is a policy feature,
>>> split-horizon is intended to provide functional "multiple member ports
>>> are treated as one for loop avoidance."  But it boils down to the same
>>> thing in the end.
>>>
>>> Signed-off-by: David Lamparter <equinox@diac24.net>
>>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>>> Cc: Alexandra Winter <wintera@linux.ibm.com>
>>
>> Does not apply to net-next, you'll need to repost even if the code is
>> good. Please put [PATCH net-next] in the subject.
>>
> 
> Hi,
> For some reason this patch didn't make it to my inbox.. Anyway I was
> able to see it now online, a few comments (sorry can't do them inline due
> to missing mbox patch):
> - please drop the sysfs part, we're not extending sysfs anymore
> - split the bridge change from the driver
> - drop the /* BR_ISOLATED - previously BIT(16) */ comment
> - [IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0), why not just { .type = NLA_U32 } ?

> - just forbid having both set (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP])
>   user-space should use just one of the two, if isolated is set then it overwrites any older
>   IFLA_BRPORT_HORIZON_GROUP settings, that should simplify things considerably

Actually they'll have to be exported together always... that's unfortunate. I get
why you need the extra netlink logic, I think we'll have to keep it.



