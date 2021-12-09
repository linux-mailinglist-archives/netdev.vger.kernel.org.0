Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF2346EE93
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbhLIRBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:01:09 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:21664
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237551AbhLIRBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:01:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGueGhx3xOg5rOf2i+7UXNLrvmiB3+m79ImG0e97M1toTJHAyDur8zYC4YObetNTDsL0jgEzX1mOdUP+RG9tWxt9NLd72Xx8c7Sbm6Wj2/XjdlXNEgEOXqMRvzNN+t5y7ZxUeVlwTVU7Wr3SLFikW3tzkKuqFPluERo1utPcySuJIaVkhIiayA5N8VMi5Wv4hN701A4UV1UdqkXSMIDv67FNXEpB0rfEWLlnw/xdXVe80btg9DGsCXzyHfMJrK/AMCmN025c/d2Rj/RLeiqQLDX0+op1c0mHWakuXDAFys4CxYq+krNEE80WoHz46TDgfDa4qo3JDNczIXyPuJhl6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4i4nfofWk0ou1jPBwHkINxptqod11v5fVwVIwHazwpU=;
 b=GdzV9dRibL7VdSOIIU1gvnWrwgvSFiJY7XJ+Sv8pJOxxSSc6vr6f1/anOzcy59uEwkrhpURKp2vPsaahEkADxy2/o9IRiuLzdzpywHJsC/+YRDinB+6qFeSes3w9fxRE8Qn1u0KDTZT79p9VfLexHc26vns63/cXUmAdoSuDUKn0d5/p59/nuGo4fzO/PnDOEgmZioqD1TAFebBLLsC8II5ej3aMCpLXTxB75ngoa8ZYRsFG+Af1ELytjVnvel+BVz8Ir3UYSOj4pskLPNH2/CRREtymINCdwCJAhvWI7Uy+uoCLtJ9fqFPvCeOQO2MZ34JXP+Eu2U0X+Pq8ttoHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4i4nfofWk0ou1jPBwHkINxptqod11v5fVwVIwHazwpU=;
 b=jYMDEyjqELTpmCUgi+x1ZK7kjsnnXgjZLUEmJ01PXPWu+T0kW6miN4lCczI7cBv7AZ0pAyYArLuAsa2SNfV+XAhMMvxH3i7PYsq06ga4Q51Zh8lAeEQUQ/VgjCiNM9IUGHs6SSpPKiFS5Gr1EAJAZXiC6evtB+GOHDfKiK8KtuvE/eF25duh+xCkhw1+GVTSUpIWelx/OQaNxCviZegTWrbskzNOrKxlX61AtzmkdyTrCuMAywOLtTBkrr5V9JmXFmAymRvpgWPULloSUwYbnuP1xRC1psbGT0jgytFPz3wsv8igrPl/Lg8f0Gwmrh1SZktSnzfHGmA9GCkmQZD9Rg==
Received: from DM5PR19CA0067.namprd19.prod.outlook.com (2603:10b6:3:116::29)
 by BYAPR12MB3510.namprd12.prod.outlook.com (2603:10b6:a03:13a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 16:57:34 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::f2) by DM5PR19CA0067.outlook.office365.com
 (2603:10b6:3:116::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend
 Transport; Thu, 9 Dec 2021 16:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 16:57:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 16:57:31 +0000
Received: from [172.27.13.125] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 9 Dec 2021
 08:57:27 -0800
Message-ID: <898155b2-08d7-1977-d0c9-bbb1ae99c0bb@nvidia.com>
Date:   Thu, 9 Dec 2021 18:57:23 +0200
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
 <481128e0-d4d0-3fde-6a9e-65e391bbf64d@nvidia.com>
In-Reply-To: <481128e0-d4d0-3fde-6a9e-65e391bbf64d@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4732ec08-a6b2-48f4-0bc5-08d9bb34fefd
X-MS-TrafficTypeDiagnostic: BYAPR12MB3510:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3510341650B7D9F5BC149E70DF709@BYAPR12MB3510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGIqNNVCWOS0uduu9QpMW3CQq93GdcCWYCDXrW2uQBk4/lNBXlryKe869VS/jwrX/Fey4Jj/XnKHKi9X4h+GVtXSis0pzRAZ+RUqeAIjVz+ZDzX8wgt4Zd6KOwPzOOgXORmgXMhNKHp955Eipow0yVLPcZ8E/smKX7427FhA+/WntUFJi2Q2YtrlgVbBwty2WVPOKLotexpBDQq+xSHXPW1Pb3P3hyGQQCYZv2gDOL2aAiqrbKRkaglB1IXwV4IBkz0j07E36K1R3KTLPCpLU33sqrhyYgcE80zvAggHmE3r/pVZIL/iXvo0AazmlXPUPAPC+AAKuTBkBVNYImmWcsQvjTQk6UZY9QxCnrGji/AFJUsF9l6qUoThISASNSW3MP74Aq7DDW3mAzrmr4i8IRV9cNUk71TgtcXuwc0pLurpBhlKbR+csfxbXa3RUj3YtHEBGiD83G5S+BQ2Yp2kZNUzwbQDSawZZULRad4Fxa5ZuvMhlhEb8d4M/5NBRj4NYYz/vk1DTdDBx+/c/RDVpWtwgvPYUPkrYoBQdpIQDxRET8luWnxrZNHXjaFtqtAwtKCQ/RnfOHRUHMhQBF03usO3fkDKDdF2mwGIwysQbxIVVAAwHwGGZE5XN0lA/zI3mi/2CGt0e/bJ/jSKliYpqI7l5hu8xq0sfJittD0WkAPeWX7zSnAVZi0pSbKmNVdLyy2CeHXHgm9KKkpFLjYlCcUI+kMnRkKh8yROsJV0RyUKLR4+KE/Rug/K6Y8Qt9AQ4HJXvxzT0vZpdu3canUfp4zNwukVUM9NnOs+RDORWS0INWttXhOfFFtbc2zyA00Ah/SH4EH5Svruqtz2nwhgRZbRgycRqodLWMDGr8uo6qY=
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(36860700001)(40460700001)(36756003)(82310400004)(86362001)(6666004)(356005)(34020700004)(7636003)(16576012)(316002)(186003)(83380400001)(8936002)(70206006)(110136005)(53546011)(5660300002)(54906003)(508600001)(8676002)(426003)(2616005)(31696002)(26005)(336012)(70586007)(31686004)(4326008)(47076005)(16526019)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 16:57:33.5951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4732ec08-a6b2-48f4-0bc5-08d9bb34fefd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2021 18:23, Nikolay Aleksandrov wrote:
> On 09/12/2021 18:08, Nikolay Aleksandrov wrote:
>> On 09/12/2021 17:42, Jakub Kicinski wrote:
>>> On Thu,  9 Dec 2021 13:14:32 +0100 David Lamparter wrote:
>>>> Split-horizon essentially just means being able to create multiple
>>>> groups of isolated ports that are isolated within the group, but not
>>>> with respect to each other.
>>>>
>>>> The intent is very different, while isolation is a policy feature,
>>>> split-horizon is intended to provide functional "multiple member ports
>>>> are treated as one for loop avoidance."  But it boils down to the same
>>>> thing in the end.
>>>>
>>>> Signed-off-by: David Lamparter <equinox@diac24.net>
>>>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>>>> Cc: Alexandra Winter <wintera@linux.ibm.com>
>>>
>>> Does not apply to net-next, you'll need to repost even if the code is
>>> good. Please put [PATCH net-next] in the subject.
>>>
>>
>> Hi,
>> For some reason this patch didn't make it to my inbox.. Anyway I was
>> able to see it now online, a few comments (sorry can't do them inline due
>> to missing mbox patch):
>> - please drop the sysfs part, we're not extending sysfs anymore
>> - split the bridge change from the driver
>> - drop the /* BR_ISOLATED - previously BIT(16) */ comment
>> - [IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0), why not just { .type = NLA_U32 } ?
> 
>> - just forbid having both set (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP])
>>   user-space should use just one of the two, if isolated is set then it overwrites any older
>>   IFLA_BRPORT_HORIZON_GROUP settings, that should simplify things considerably
> 
> Actually they'll have to be exported together always... that's unfortunate. I get
> why you need the extra netlink logic, I think we'll have to keep it.
So one relatively simple way to drop most of the logic is to have BRPORT_HORIZON_GROUP's
attribute get set after ISOLATED so it always overwrites it, which is similar to the current
situation but if you set only ISOLATED later it will function as intended (i.e. drop the logic
for horizon_group when using the old attr). Still will have to disallow ISOLATED = 0/HORIZON_GROUP >0
and ISOLATED=1/HORIZON_GROUP=0 though as these don't make sense.

e.g.:
if (tb[IFLA_BRPORT_ISOLATED])
	p->horizon_group = !!nla_get_u8(tb[IFLA_BRPORT_ISOLATED]);
if (tb[IFLA_BRPORT_HORIZON_GROUP])
	p->horizon_group = nla_get_u32(tb[IFLA_BRPORT_HORIZON_GROUP]);



This will be also in line with how they're exported (ISOLATED = 1 and HORIZON_GROUP >0).




