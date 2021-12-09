Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE3E46ECC3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbhLIQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:12:05 -0500
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:25057
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241310AbhLIQLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 11:11:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfMxc41V31ciMjDGPhKQ2/6Vpv4IN+e6KHp0Jexy1Q/Q/VgYtQImuGxV8VfWh4bDJMRdUPn8ytWP15GiNBSnJuoJfKleMz1e/K/47d3hH34R9C9Ju7usQ3pC+rGOgpEMSfEBM5QsZd7FoyabwXBA0V2Xijn80lxDp1x0uIb0MxnfWmAHzaw/6QugPQ60CU7msC4H7VnenpG+DyWB79q6IAGrNgAnRvXaonYaha9rNfY5EXPzv3xO6u5ybaVZNaOD1QZFtjEe6G7NxyvGZCudzS3fhZeh3xABhf0DhNTmrpGgOFkp4cKbSQrO02W/WmfMFQYEHAyAY/GBGlHtppx9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nlBfQww4Ho62hmsLIutKkwsYoq4oVXVKER118mFZ1E=;
 b=eSlJOPjylNASECaBMI5fRfFwKxA+Fjz2FLKazMuUwH+D4Gt+CfbHeFNPTwhHMsLkw7xi7B4ovMGnO35jXYayEF6NvfLZi4toCagKha2ZbQmvgAdZ1Ybrd0mA/82vWLE3GaSK9ldYgy460dmapc8uehFWKM9eg3juDHCnEInCxz577as2SZhDdqqmouHyViz9fGX+X8hT17qFYXkmo14JxpQKDgUM/PVelleYBt/76c+7Z6JIJaSCbbZZiHUIgusG71510Tr27hSKziQOR5bhtb8JfsrU/NreNJp85ERDTrg2OkwBZSMO9m3mARpEbNQMtY6ZtrgmZD473mfcfnSKZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nlBfQww4Ho62hmsLIutKkwsYoq4oVXVKER118mFZ1E=;
 b=sOjgi78VkT0BKHsfUfGCy8YfCe+03AwqKjCf1EpeoFAcHdnAe/0kb2XmDQSG0tSFOatjhfJibVd9wKg8veYoVQv9EZZiGlACRAYLTED25mGUoWiWLpgpYWDlhWlf1qGJ51arGetATCnN3u1qegi+4z6G0QU6MJmLG4mCMY+riyw+o8uoutyzAvx2GNDE/7qClIAIPJHuht6Ll2unaQRkILCB1/PEb0UggDHKGehok3G18XeDKUUiV3Jf/JznOvpnhfWyO8iY/6dfUye6XhrA1UEzNCRE5Ya8rSZeLnbl5MD68quhheEP6qFWUF0F30sHWeqk/SoaNYmmxHII852imA==
Received: from CO2PR06CA0059.namprd06.prod.outlook.com (2603:10b6:104:3::17)
 by MWHPR1201MB0270.namprd12.prod.outlook.com (2603:10b6:301:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 16:08:13 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::cb) by CO2PR06CA0059.outlook.office365.com
 (2603:10b6:104:3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Thu, 9 Dec 2021 16:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 16:08:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 16:08:11 +0000
Received: from [172.27.13.125] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 9 Dec 2021
 08:08:07 -0800
Message-ID: <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
Date:   Thu, 9 Dec 2021 18:08:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Lamparter <equinox@diac24.net>
CC:     <netdev@vger.kernel.org>, Alexandra Winter <wintera@linux.ibm.com>
References: <20211209121432.473979-1-equinox@diac24.net>
 <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50db4701-840b-4bda-89a6-08d9bb2e1a24
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0270:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0270790DA642AFD0AB48B6ACDF709@MWHPR1201MB0270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uecJpGT/etT9jfcvah5wsWc2C9QGcysWwT6yHX/M9NHnSg+W5JTgwKf6C60HIrHu3151PE57u5L4BS6Qs6wEzH5eqWP9OqeNNupW+b0HgOaLafSzJGLivRRardqboUy1010qsy9+FOHzDDHejKA7SIOCjrh2goAVpOXA/8HVnrAZERS52b1uMD9dtboxnAF4QGMSJ+59Exqemin10K3nA5/fqCHWNJ+PCz2Bi0EmFSwi2SxLgMwQ+LmfYi1CyJJpIRlnhQHZMxAWPa7Czv08/6h9nfVzme4cQtjkTpS7Q7c/9wBorXudoLX2dYrbbY71eNnV0hC17qBX5bw7DhSWMyp7oeUIrAroAlFqODX/Jd4zP+T0h5pW1zooCbm1OiJAV32opU0LnqjbOJ2vzLIjWns4DX5fu79UPQtjbWUBQWY9Bh4A5b2Hn9U3TuaRq4NcMi2Y51iSkaQxIExB15hk/9zI/qQhSj1B1hWIkVFvV3sUyAXsZGTrwlSb6yeFVtRoLbI+XQATSLUHz6yhZIdwI3M4kqkbA+othAjj4lqs9EeqyXZsIPuaSbh5JcIcic6xbo0SwvJivnQ55AOOobRCNwiN7c7SLqUqRBiMlAotGIVS1aWrmF3yhufNzWvq4Ml1LkUfbptaMVZEATtQ0whsZsjgxldiDS7SFnmts2vEHItfIRKjOLl2EAeZ13O4QHZ4e85OhuX/hie0e9/qZlQY3sPfvIxsC33XnfqFgK5GCKS099BNBhhwRHSRIGMX9iAGehm1OGf+6X/Wa6qRuH9gS0dLkf7VbYBJz1X/ydslAOlW1QzaORqMLuXSxlcXKFDg+d3xpqYuTsa2t7jTBbwgGg==
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(356005)(336012)(426003)(26005)(31696002)(53546011)(2906002)(2616005)(47076005)(508600001)(7636003)(83380400001)(31686004)(70206006)(70586007)(8936002)(40460700001)(4326008)(8676002)(36756003)(54906003)(110136005)(6666004)(5660300002)(16576012)(36860700001)(82310400004)(86362001)(186003)(16526019)(34020700004)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 16:08:12.7690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50db4701-840b-4bda-89a6-08d9bb2e1a24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2021 17:42, Jakub Kicinski wrote:
> On Thu,  9 Dec 2021 13:14:32 +0100 David Lamparter wrote:
>> Split-horizon essentially just means being able to create multiple
>> groups of isolated ports that are isolated within the group, but not
>> with respect to each other.
>>
>> The intent is very different, while isolation is a policy feature,
>> split-horizon is intended to provide functional "multiple member ports
>> are treated as one for loop avoidance."  But it boils down to the same
>> thing in the end.
>>
>> Signed-off-by: David Lamparter <equinox@diac24.net>
>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>> Cc: Alexandra Winter <wintera@linux.ibm.com>
> 
> Does not apply to net-next, you'll need to repost even if the code is
> good. Please put [PATCH net-next] in the subject.
> 

Hi,
For some reason this patch didn't make it to my inbox.. Anyway I was
able to see it now online, a few comments (sorry can't do them inline due
to missing mbox patch):
- please drop the sysfs part, we're not extending sysfs anymore
- split the bridge change from the driver
- drop the /* BR_ISOLATED - previously BIT(16) */ comment
- [IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0), why not just { .type = NLA_U32 } ?
- just forbid having both set (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP])
  user-space should use just one of the two, if isolated is set then it overwrites any older
  IFLA_BRPORT_HORIZON_GROUP settings, that should simplify things considerably

Why the limitation (UAPI limited to positive signed int. (recommended ifindex namespace)) ?
You have the full unsigned space available, user-space can use it as it sees fit.
You can just remove the comment about recommended ifindex.

Also please extend the port isolation self-test with a test for a different horizon group.

Thanks,
 Nik




