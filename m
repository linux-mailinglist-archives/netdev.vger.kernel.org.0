Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A964585C2
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhKUSFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:05:19 -0500
Received: from mail-dm6nam08on2046.outbound.protection.outlook.com ([40.107.102.46]:59009
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238625AbhKUSFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 13:05:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N83AMrP7hLLuCc+OJHDRdmSAiA+8HvaBxdTuo3jSxi65rvl1I7XjH4SP/3NNbKQ2O9ppae5546JL6qYIQ/YSnn0MPV+YEHV+/zdkQVAh+s3MFEzV5vJ8kA54mUZgOBSYuyiwOyL7Opw1hwsHKsXKSDc1XWVm/pT4AH3k5i4LE9neljnDGKhR7G320dSez7t287Rrjd8MjW7Qr5nPwWoYsJZfK2/NPn/PkmYuG35WFNUrlofXNs9ra/brEClke9+4CGmVcyZA5g8HN8UlTVaF4wkm5IWiQBhDp/0b5Wyz2ZdVYg9kkrYUosekDzhN7IMXPtaNeI9l+AdDjMUcih++/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsQ95nsfUizLkXPdz/0yIX2BKRr4hFnFqHdarKQdCAE=;
 b=PW6i04psUIqcdUwDUhQ3/hfnUO+msmgyDa9eWwYC+z4e8kJAZWlADM5T94zukF4SJX0chrZEh6pbJEAC1x0ELmy8GYA4/I0vifoJXHEKRCgYtVthqCke7H0/ePkgR5yE+E+8rl7sH3+ZoiRjAtTHRAUZ7FJHwTpqNSS5CDy68zfyeJn6V0UP2gy9NaEuMMYXhc84iauDU3G8V8uuleTlNQEhrMb7LKpv+6Umnl3L2jPk6fa89TRtSjFnPpHA0WVem0TSIxVd2pLZRDjg4QTB+c9e3AafxkfTTeMEp7+z789LdkUGaLrLDO0UCw11cOPaeYTS/ZxXyXztnxiHPyylzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsQ95nsfUizLkXPdz/0yIX2BKRr4hFnFqHdarKQdCAE=;
 b=Ykfzm/SJPqffa5lch72ytQaVDKNlt+81PPt0ezABEedpK0RYpVkQFSy3f/S+cmXksOnM5Wonr5M0rUhpuMmCjdRv8DxRg270OCOW2gBgM3l1sKRXVjz/8LoUpPpxnhUlBEOS9/DDwfWwct9937Gw0YXu+pvE8/hlfkqs2jGsq4HXCvPweGygy9mGZNZCKTLzzbzVfDSouLpe7dzajjojr+HG+oSFOmdYghhRvrMJjH/Tp8yOd0+fj1jGXgZgckTWJK5uBaAyFIxEPytlRPefujfTDnvExGWp6YjfPSXhLS5TtZlyKhPxgvw/WjWJabsOpPB49xmteUYiJ+tQw2CpLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 18:02:09 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4690.027; Sun, 21 Nov 2021
 18:02:09 +0000
Message-ID: <e6aa1715-52e0-8aed-323e-996b519b1668@nvidia.com>
Date:   Sun, 21 Nov 2021 20:02:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 2/3] net: nexthop: release IPv6 per-cpu dsts when
 replacing a nexthop group
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com
References: <20211121152453.2580051-1-razor@blackwall.org>
 <20211121152453.2580051-3-razor@blackwall.org> <YZp/MvIX/YCHJY9K@shredder>
 <YZqDVQiqSCMsDEZh@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YZqDVQiqSCMsDEZh@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Sun, 21 Nov 2021 18:02:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 764b23ef-99fe-429e-f50d-08d9ad190941
X-MS-TrafficTypeDiagnostic: DM4PR12MB5245:
X-Microsoft-Antispam-PRVS: <DM4PR12MB524511999070BBF7FD1AA6E2DF9E9@DM4PR12MB5245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PjRp1EulkE10Pw29RhVpY6XeIy2GR+r97aiFjS4TtsZ05Emiali6gsHcdOieifGGXa1M4YZiJyJVDR+KpcW09fd2on/yPAZ45L8V7+Fd2l4z97nBnSsMN9L87zwcfqf52X7l/DLlsBF0wUn/hndKMdoKJBQEn97GOHjs37T8nVx26gbfyuZ1bZG7LAywL2ISSFxXBfQ9ldjCI+BpF0YdNVz3D8Q7VlIOvsEZ2YPp+TUayo7Zt7Gcv92PBf5TbMMHV943eT+r/nz/5YssH6zwOwHIARtq+wcGkqrlGY+amnV73jAfcYTSFgOHonFw027onXbwv5jIkvbVM4PBQ7BA+p20mUQ4+2cwapwSrvKn/QneqmLhIFHfMcryWa5+4PVbkrICfn+ogseaDepPNe/acfm8gv4sp+MaNz/YC26NHw9i2p4BRcG/q+xCAEPHI0l6nNEGY5XliqZKU3AQb9z4GemtSNMktEaBmb5DF8SZpGpZXwjeEWsoNG9pf9M9UIWfUg2WXgsksyNk0b/IDrvT+UJBpIlqh3JGzQ2/Qh0PArNqC0aHL3CjS1X+qcjLI15wyf2G83SkWuEFpFHRhL9yCYLM2RiXNyBqV1/ALokFw2vHh/E6dT8lMCERje0YHUpinOozuG52OARVRnvhwh3gKV5BuIbAYey9lkimg+jiQ3XVH8Ckh3wHjKAe9+MKFOwpCPV40kfmj0DOW/l82IIiNmfh9488aYtv3AqvSaIC4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8676002)(53546011)(66556008)(66946007)(508600001)(36756003)(6666004)(31686004)(8936002)(38100700002)(16576012)(31696002)(66476007)(956004)(6486002)(2616005)(4326008)(2906002)(316002)(86362001)(5660300002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejFKRHlzVUNEL1kzcFB3MkorQjY0eWRWdUR1Ylg5dkdVUEs5N0NGVlh5RFpD?=
 =?utf-8?B?SC9XMUVrMytkOU5BSGFENjhRVnBHM3JRV2QzUEQ1NCtXQnkrQy93enc0bFAv?=
 =?utf-8?B?NVlTWGh0OS9wSGdZbFM5TGpZUzhQbE9MTkt2aWJwVnVKOXB3MUhBL3piVnA5?=
 =?utf-8?B?SUhXU1lneXF2YmFrMW1vcDErbDk4UHVJcndJMk1UN3dteFpEdStrUHljZC9N?=
 =?utf-8?B?SEViYW9MZGRnR2V1Ui92ZkhwUWxoRnp2Mm10Z0RYVzRMZkhlQWRtbFJ4SW90?=
 =?utf-8?B?MXYyRWFWeFRYRXVJUllmek9FclNQL0JTMHRLQVJiU3lJdWUxNW5VZEJZOGZ3?=
 =?utf-8?B?ZW5jaCtqdk96WWVnOWlHMWZNVENxUm9ENXp3V3Qvall0dTdNQit2ZjJvdGly?=
 =?utf-8?B?NnRxR1oxbzBDTDRwRTBSOWRSNUhFbVFOdjliK2FBd2dQcWRkV295REhxSURt?=
 =?utf-8?B?WnJyUi9ZRU9vcWc1ckpDN2s2bUpTZTVmK2VRQTB2dzBqekVESElYbXpOK29U?=
 =?utf-8?B?L0h2eHJrRHF5N2pnR3lPb1JaWUpSWmY0dVpNbmZSWWcwMEMvZjlZWHBicmc3?=
 =?utf-8?B?OUlwOGhtbXBYbXY1cmNLajBKNEo2TkFWckxmT2dic1lxOVoyTWh4RXV2ZE5R?=
 =?utf-8?B?SUg4dmoxTTBWaTRQQ1hzRXlZSHVORk5MNlFGeUgyRENKT1d0bm5iMWVLc1Jr?=
 =?utf-8?B?Q1QxMGQvcVZRQmRwM1dZY3VGaEUxV1Jnd0tLTHJlTzdsdEhhcEpuM1llckM5?=
 =?utf-8?B?c0ZuMXNIaHNVby9FZkNzVERISHNiSnU3dDRncnFjREhwUllnV2RoVlRTZG5F?=
 =?utf-8?B?R0orbzFLVjM3M3hMNHZObmQ4YVR4SldDT2psQTl0RG5tZnlsOHdVVkt5eE9t?=
 =?utf-8?B?WCsrMWFFWHZTQXd3Y2lHdkoxUW9Xa1A4T1JmQjk3SlNZZHlldEphc0w2MVhi?=
 =?utf-8?B?N2pwaVdycDlBdzVreDJGQ2IzWVV0T2pTMzN6bktUKzhzTnkvZGZoMHRvTDM5?=
 =?utf-8?B?SFR6NHVjaGcreTkvZEJ2eUFGOUo1OWZzQU1uVkVET0M5bkg4WHVhWFd6dHVt?=
 =?utf-8?B?YkErRUx4STlaemI5eUdJZiswOHJ2c21zN0VZKzZKYmJLNUIrVzJjQkM2OU1V?=
 =?utf-8?B?N2FNOHdVL2NPT0x0c1dBR3hSQjNla1RpQTcvUUtuQnpkcjNNeHJUZUgwUzUz?=
 =?utf-8?B?MllYTmZLU2tuN040NTZFRTExZlJUVG9Id1VrM3RQajZSQXFIWWdBWnN0N3ZG?=
 =?utf-8?B?b1hwK2g3TGJmQ1BSSHhzZ2MzQ2lJb0RGZkhSMlEvcGd3MTNSQVBTc0NSUVhj?=
 =?utf-8?B?b0w5blV1WXhvbDlhN0JpamhQSUFMTTAwdS9TSndxbDN2L2JzeWcvMERHaDhO?=
 =?utf-8?B?eGd6RS9URTEzTG4yS2xQVGc5RUs2czdyNlJ2enI4bHoyNVllZFV1c2J0VjZL?=
 =?utf-8?B?bFBVb2lnQnVsc3BoS2hRbFlCV01XbHNTckNYMG5zSXRSN29SSUtRbERaRHpn?=
 =?utf-8?B?bnF2WmVIaGFoSmNhS3c1NnBQQ091V25yaWZjRktJbGxCUGdwSU5DOHg2UXps?=
 =?utf-8?B?ejVwRWY4eGhtM0tqWmJmcDNWSTFYN3NUTUZ1andJZGhjOHEzcmo2Uy95Rm8x?=
 =?utf-8?B?REhabU83Znpjb1YrUGYxdGsyV1pzdUI2QXVkZTVKU2lvZ0pudEpIejNPOFlw?=
 =?utf-8?B?YmxpOFE2b0VGTy9wOG9kRUx5L0pRTlRCaTlPM1NrTHBab05DcHl4RVdaSDZR?=
 =?utf-8?B?Wkg0dTQxSXJHbjlkdGdvV2VnZkNWalZBL0hPVDNzMjlCallLUDJQUHVVM0xn?=
 =?utf-8?B?QVQ4NW9HVDRFN3hoR3Q3SnA0MWJhYXIxanlGRndMMmdsR1JxeHhISDRLVlVH?=
 =?utf-8?B?MDRMM3RFYi9KMWxCNy9zUTNlZVduNjgvNE1kbzdmYWdHWnp0RjBoUE04UURD?=
 =?utf-8?B?bWtmSjVMSWNVN3BYcjF2Z2xEaWNLUC9pSURLMXB4bzhEMnhodVJZRGZaNGhV?=
 =?utf-8?B?ZWZFL3FjSmtrZkp5NEZ0emFhV3RhMmJtRVB6WVg2MjB0NVNxNzdBeFpoNmU4?=
 =?utf-8?B?SWhoTUxoRVZxaU5ETW9vejdmVVVNdUhkaW9EdWExUXRjT3BsSGZZb1N6U2FJ?=
 =?utf-8?B?UUdSSGhsVXVXcCsrMDVtVmd0Y0FGVXNqa1Vaalp5TkxFYWFyMWErL01XOEpX?=
 =?utf-8?Q?n6E8PE8jTUlccxtCyHDw4Fw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 764b23ef-99fe-429e-f50d-08d9ad190941
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2021 18:02:09.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igYq28lMi4fkbPU42F2E/kJ9qqpqzpKY3rc6/Pp/4WYKsHraQcwZ+CId9nr+ALhCzK+UC1cFi2lvY5Lx51N6/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/11/2021 19:35, Ido Schimmel wrote:
> On Sun, Nov 21, 2021 at 07:17:41PM +0200, Ido Schimmel wrote:
>> On Sun, Nov 21, 2021 at 05:24:52PM +0200, Nikolay Aleksandrov wrote:
>>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>> Can we avoid two synchronize_net() per resilient group by removing the
>> one added here and instead do:
>>
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index a69a9e76f99f..a47ce43ab1ff 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -2002,9 +2002,10 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
>>  
>>         rcu_assign_pointer(old->nh_grp, newg);
>>  
>> +       /* Make sure concurrent readers are not using 'oldg' anymore. */
>> +       synchronize_net();
>> +
>>         if (newg->resilient) {
>> -               /* Make sure concurrent readers are not using 'oldg' anymore. */
>> -               synchronize_net();
>>                 rcu_assign_pointer(oldg->res_table, tmp_table);
>>                 rcu_assign_pointer(oldg->spare->res_table, tmp_table);
>>         }
> 
> Discussed this with Nik. It is possible and would be a good cleanup for
> net-next. For net it is best to leave synchronize_net() where it is so
> that the patch will be easier to backport. Resilient nexthop groups were
> only added in 5.13 whereas nexthop objects were added in 5.3
> 

Indeed, thank you for the review. I'll send patches for this suggestion and
the IPv6 optimization (that is one of the optimizations I was referring to
in the cover letter) for net-next after net is merged.
