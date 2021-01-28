Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AA130726B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhA1JPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:15:44 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11370 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhA1JNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 04:13:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012800b0001>; Thu, 28 Jan 2021 01:12:43 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 09:12:42 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 09:12:40 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 28 Jan 2021 09:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS3TtnRqGiGIfBPCos1/+VJ7mlw+Hmmj0IJj9hq11LEK2nRE0APZJ92dnM/1fr1WLTL9DaLF96Q23BHoaxoU6d8zU0RR6M/isIjAUEPfJfqw7nWNL3hnA2Uu8NvWQeMmDFPUyCvebKBXkW2/cawZQxqEGM3Cd4xiuR1jLXBGM/B1K1JisjBvi4rQZzz2hJ1MiAnJ89jgLWOyzpK7UdODecacDwhlI0OHXFBsEe8pLiVUoZyTGgeJ/Mae2m0pxwm9WYVAuz+Er7J7CMlR8l0yEWDQxPzkQKnrBfZbBzxsFYketKZVGya4o3zuW0wTo7Gex8Ekys4S8GnC61w7DqUb9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6434+fx3NeTTQzriDT1tL1g4EM7i187MlZg28mNBPeE=;
 b=IkphNmc/s++vi3wSFrDkK+VEloVwMAbt5KeeP+GcM24nZE5tPw2g0EkM7BRQK7hvdcAj4hkNpxp+OYzIuONPho1uu608w2vuTMMYa3cvxiuJltRz00ONg2qhifafrRu+lG+h2gycCadQsTDDwwTglmUX6tduDOTMVOWE30m6b/6aofdRSw2XRTc5yVTK0jvaMRt9i8HYDOeSraD0xRyBu/N/6oIsZTUqai4g2/QzfYGvq0szCbDPQH2aQFskeDqABptaPUnOjHUQfE+jf5RuH/ZEezRFGNnLGOx9yGusdqxdQQCRlEv6B47VJHGzJNX7QLiREiuPhLo2owfWjSefFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3052.namprd12.prod.outlook.com (2603:10b6:5:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 28 Jan
 2021 09:12:38 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.018; Thu, 28 Jan 2021
 09:12:38 +0000
Subject: Re: [PATCH net-next v2 0/2] net: bridge: multicast: per-port EHT
 hosts limit
To:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <roopa@nvidia.com>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>
References: <20210126093533.441338-1-razor@blackwall.org>
 <20210127174226.4d29f454@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <046fad19-2f44-21d2-82b9-feb1fd62b068@nvidia.com>
Date:   Thu, 28 Jan 2021 11:12:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210127174226.4d29f454@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0079.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::12) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0079.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.18 via Frontend Transport; Thu, 28 Jan 2021 09:12:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a797acd-239c-4674-68ae-08d8c36cdb5e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3052:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3052A8410554A51FFE415004DFBA9@DM6PR12MB3052.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2IgscDDd97HKvqo4SGprysOzHcbkvNnVZnCAhmwSYnzimmWbRrnGEe4wUngSgHgHQ1HfFsmwANdvUJLtZS1MWeFX257VJi2GgeypKyYkmngAzAY0WdYOR9psDGAO1a3x+DECFqIdn5tgNnobybC79ClnYI/iSH133ZHVmou+HkARJHfPyCtnWnH+nGKm+PQk2sWxwONsaLmthNCV4ywLo1hVKJII3uULtcdhfk4bgau7GkvrdOKuGOX771WhiiQPWyI2hbzMRLT31425NesWOLQZDx2NM1c1DCI/7KTOMNHzncNFiEeJ+4GiTLC8LlWQdDPODqPxounW6Q6mbCCUdoemNjT+mvR0L5R96PwmaxDqMGnXdn3Bv5qDTE9XicA6Xy1a9+8IpL4HMTpMkzwVWQ6RxzEMlW3i9L5+bprOtWlhgb2lXINTs9y0OHFeGJVRgBfr84OYPugC8ybtirpnwZ1xC9cUbzTmafAAh589YlOgOqr2djccso6KqBWsrvBZVor0x7OMq6dgMLn0DZNge0ER2zeD9YHPQ1+eMt6n5pCx1KmQpoIIdbL3Ym5/FPYoD4LJoucz7aRrZAj0a+85uWbQqTpqNDxHHCmNvEKH6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(31686004)(31696002)(53546011)(2616005)(66476007)(6666004)(83380400001)(8936002)(36756003)(16526019)(5660300002)(26005)(4326008)(8676002)(66556008)(316002)(478600001)(66946007)(2906002)(6486002)(956004)(86362001)(186003)(16576012)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGRad2hNbWtHSGhXSDUzZ0JvU25xanV5UGhwNW9QZ1BYeVpLTE50c1BPZWxw?=
 =?utf-8?B?aVFwK1RTVmUzdDFGcTNQMzVXSno3N2Y5SHl0dUxzQ3Qya2hjbDhsVHN2RzR4?=
 =?utf-8?B?cTRNMXRkNmpMajBnY01vaTFKeTNCUmpXTnQ0VUYyYUtSUTF4K1I2dC9BajFl?=
 =?utf-8?B?bWlKa01uNzFhT244ZUxvbk42N2hJYjVVVlFrazc3eWtqckhOWVQzQkhIdDJY?=
 =?utf-8?B?a0E3MEdYOFBZZGhobUlqeUxad2xUL21qWS82bHJlUnNkdm1BOG96UG5pRmJw?=
 =?utf-8?B?SjBmR0xYWFhadE9RaHoxRWd3OHhDYzBTbVVhdk50RlFFRlpkdnFQenlSU2c5?=
 =?utf-8?B?SWxkdnZLMU16eDU1QkwzU2ZVVnNxTnR6TmVUNzJRMkhva0F2RXloeHZHN0JZ?=
 =?utf-8?B?YStnTnlUTmRoMURITGdUZzQxM0cyQ2xVQmxFUjlNVkRDNjFKYk9JT2h2TDVG?=
 =?utf-8?B?TnZQMHM0N1Y0OUwrcUdWa2tpZUNSeHQ5Y3J6MmJjdko3UjBkbFlRN3c3WEdB?=
 =?utf-8?B?d2tDVU90N0MrWDRyYXlYMjNwbW5zRjhzZHJWZEl3QnViRTUxdis5MllLOHRn?=
 =?utf-8?B?d0RGZXZKZUFlNDRqWjNwcXdXT1VSeEY5T0s0djBvcVF2ZVN5TWM5TVFaOFI5?=
 =?utf-8?B?YkxLYlVJZ3EzdERRU2dYZDFMRW5tYlc5Q2ZkUm5RSEJDVWRuSC9sRzQ5ai9N?=
 =?utf-8?B?L3hhaGY5cVYyVzBCbDZycitOWHN6U3pKaTNnblFRSUNNN2dpY253S1Rkazk5?=
 =?utf-8?B?Y0gxYUVveW9RZzFOQW4za0dIVFlFZmVXZ1ozS0RrbnZJNm1jdlZpb0tHWUpp?=
 =?utf-8?B?Nk5Ta0ZuRFd3N2VudUhYSUJYNlBqKy84WHlUUnNqYTAzNjA3YlpDdFlXSGZY?=
 =?utf-8?B?Rnk1d1I1OStqby9VSWhGS2xPUTRpODUwakdPR1l0alRyMzNwQnhkR0kyR1ZY?=
 =?utf-8?B?SWtKeGtTZUhIcXU5Q1JhUHpmQmgwRnE4ak1PZU83Y0Z0MTJVenlqVk1yWllT?=
 =?utf-8?B?aFhCNFNVd3lmWUo1c3NBaHQxZGRjREthSW5aTE9LUXc3bXhZR1JibFZtL3VU?=
 =?utf-8?B?RkY0Y3huQURJUXdubjVRTXFPdzVWR3NIM3dxUTdvNmVibmhPd0MvYVplYnZ1?=
 =?utf-8?B?ZGhFRncwSkdXRW9UK2NyL0hvTEtSWFB6QzgrK25sQWR0NHJWS1EzNllwalNC?=
 =?utf-8?B?aVJCc3htQ29hL2cydHBDL3MzaXoxSkdhblVhY1dFQkR1cGN3VFFLMXJQTzRP?=
 =?utf-8?B?VitCUkQwSlVlVlRvaThPbmhuYzF4Nm1LRTBDWE1HbHluMHZVWDJXMnV3Yndi?=
 =?utf-8?B?cHhGWjUzVmtqRFhUNkhUYmlxYVF5Ymxpdnl6d1VjKzFWWmgveml6YW5ESTZT?=
 =?utf-8?B?cDJLdXN4dkw3dVdwZEJydDI3aG0ydlBocWZsZ1RGT0JoSUt1UGNwRFBHSkZD?=
 =?utf-8?Q?EnjGyhtu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a797acd-239c-4674-68ae-08d8c36cdb5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 09:12:37.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YpQs+/K50LfhtU4csPUIseT5lWQvP6RvXJzDpcpvYm7SuPm9GS34QIWZkqLvmBq00zgVoEEfhnk/b1xm1mxfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3052
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611825163; bh=6434+fx3NeTTQzriDT1tL1g4EM7i187MlZg28mNBPeE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=YnZStjHaf+6bzVPdmJA4QAEgq+srZgxy98AjqLhZU4UtWyYpBSj/mvo1UNkzeCFR0
         68FcXw+3rTHfwkoMTjdbDrbFYtPyN4g+/HDJa+4t8vcTn/FK/I4SfuF5aIbgnCutIR
         KSfQIHHcQ9fMlYcnzVbyNsqsbfOuSP5u5rDdxWr37ktzlUCsFNt0r8zCJurAsgwznG
         NtAPhUiflMbciWQMm6jY5F2zalC1Nc6EW7k3N/NgIEZC0zgXvxZ47jI/8zXv74+fSz
         aqDIaLRYxYn1KbtPDf1ayfq1vk5cYvo+gra/dRpWZ7gC0Z8m/5Z30RhQJqtY882Ccn
         XU2uge+M1FDsQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2021 03:42, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 11:35:31 +0200 Nikolay Aleksandrov wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> Hi,
>> This set adds a simple configurable per-port EHT tracked hosts limit.
>> Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
>> changes are still only in net-next that shouldn't be a problem. Then
>> patch 02 adds the ability to configure and retrieve the hosts limit
>> and to retrieve the current number of tracked hosts per port.
>> Let's be on the safe side and limit the number of tracked hosts by
>> default while allowing the user to increase that limit if needed.
> 
> Applied, thanks!
> 
> I'm curious that you add those per-port sysfs files, is this a matter
> of policy for the bridge? Seems a bit like a waste of memory at this
> point.
> 

Indeed, that's how historically new port and bridge options are added.
They're all exposed via sysfs. I wonder if we should just draw the line
and continue with netlink-only attributes. Perhaps we should add a comment
about it for anyone adding new ones.

Since this is in net-next I can send a follow up to drop the sysfs part
and another to add that comment.

WDYT?

Cheers,
 Nik

