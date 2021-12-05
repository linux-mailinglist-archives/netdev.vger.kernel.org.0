Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEDB468A55
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 11:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhLEKcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 05:32:11 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:26622
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232218AbhLEKcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 05:32:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfdYVq+tJDkHv3CoCYawpnSY9ETYShSlr51z9WdKoJL4HLS2wo2lXuBVMxA8vv/yO9R/k7m2uqen10RzvMdYAQopd/pF553T1kuDyfwj3v0gSB873pvRJsSuPc1bjnSwdZiy8W5B/q2H4g1KGzqlKeYWsZ84+VX5crI+86mts+SXHIevnJ6e9zKqTdDDjWV+FO/8/hc9cPRe8Pln3d0Y2AEpmbwerJdrlgpKgG52L+2Sbfs8F4EFizVCDz+980YDnZWyMzMaosA84nendjAN3tMgyF87tOtIBj0nXvButr7OE8kyOBbUj0WSCikhFJ2IxcYhdtMQu+A4nY2MX1uUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qd8nyTWBnDum8bfqfXhpbE+36rtLgeVNAPKM/NoAWFc=;
 b=EMKI2hRlRoteC0fJ9rJesfI3Ix+i3aZtjzPTstnBYaZPW80Ucug+5IkEw/MtBF3XCUWxtxfNLGlxARYruYD9rYdFFitDLuMnl5/u8vs8IIW/SG/07yWRaDTk233NXY4pDdH28b8azM1B5LHxMRHxoZONtA40JBQkm/o2wcdIoUxcFqCWhJ/Ao9q5crFMkl/4Xlb5X+1uL3cN617g+u1LNzLZAA153XE+SdZeHWgti3Godn5vNekpQcRMopM+NVg07V9S9cUi1DPP92yVgPRZzzdKMVxiJCtmpOZPRu3Q4E6V32s+5evd6K89sLwifSTqySLKh2DdE9oQQfMFY097eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qd8nyTWBnDum8bfqfXhpbE+36rtLgeVNAPKM/NoAWFc=;
 b=PP+Gbd/SPkNPjR15hvs05b69yup61mHyXEf/MlhYPp4P8kpsAVAMWso4oNfTMaE/JRp3chS9AHQtU4Blxlb6tsLivwfJwY+gsTGGKJtor+7+B5VvapF7kGAUBnECq3FFy1SFmlJK9b5Bt+2YY9LPvgV2iv+0X7074VHlyLK6E28fQVvy8QQzEQ1t1XT72IcI8rR7a8W+PlargKV8eEZlVVXmYED8SrQAfciLRw9Uk5EnQWBDRnhi5ece1MSeX/k9mIovUFfafs4iz2CuwFH3qbDxDgENBLSWQlJIEahGrzSmCV5KZZx+ZjWEyYEyA9Zcc9G0jPmWfJ2OaZXHo+Ns+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sun, 5 Dec
 2021 10:28:41 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.028; Sun, 5 Dec 2021
 10:28:41 +0000
Message-ID: <376287b0-8b47-a89e-4359-0dac162b822e@nvidia.com>
Date:   Sun, 5 Dec 2021 12:28:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com,
        Ido Schimmel <idosch@idosch.org>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211205093658.37107-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.25] (213.179.129.39) by ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sun, 5 Dec 2021 10:28:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1787573-1edd-42c2-9b5e-08d9b7da01ed
X-MS-TrafficTypeDiagnostic: DM4PR12MB5183:
X-Microsoft-Antispam-PRVS: <DM4PR12MB518385BF8EBD2169854C10D4DF6C9@DM4PR12MB5183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz83epd+MAUxuy/4GOWov0INNfbPBJ54EoukldqHjhxi3Nsbn7/5q2TfuyFAKGOlFxWwduRoM8FEOAfdCSC4NbQSdhh3cNbBNQFxwSXgE/9Sl44wfpTT6WfYEaNukhAvhss5x81fbOYL+V+Oup0zVTC1NbqyLyXJdEJMI3i16kEVwPe9L4f/ose9g4sHDnHOLgpVMpXVHjcxkf3caNR4gAs8NTstzPSVySCsh8HmiiiYZcIpf67pJIzxbTCYqhsfyLwiwjFByK+T0fOJZq6ZuVwB/QuZK8My/FVVbPRvMRiNiaWVMe70JEM2BfK3p9qGQuziuF72QvKeCzfHPbFUtmz4reA8ctQgdpLwhOsT5tXeUQUQg/2WAuT2i0EEbCwHdAnOJR5j0tTtZasjG6WR7UsSBV5Ljw6NQjsLmfouzQBh078Iy7nFYH1bzqcRF+D2CoV8YMdaQe/JCIGxcZ33mIZgABo2Xw7Q12qTWHRwdTzfRVQ8/UZ1pYvCOHNpjFEzuVlFJChg6rg4I5ywPeLfDVBZdV1TRvZgI+flA/DvLBON/Y5UAIK1kzpT0TnTkXKBeN+PU+zSm7wMZFAj5C4tfMWr8j8RwjPSb4gmRxz9n0iG6Lud2MnNgp+PpjxE4taxSuC0X301NsH098hylK8d38idej1fMyudOtXsCGChvQL+o49KnzTdidnh0A5Jx4rAtSEo8mS4P2oXQZNW7dvBxYgp40j5l1hiAa2s6+vAc/NpnTLzQk+dDcN8g2IzSa2eNBjQE5qh8KejAjwlNvO041dLen3+ARTSkdoK5wNJAH3O2Q5Br9SKqA1OhCW4fV/0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(186003)(8676002)(4326008)(66476007)(31696002)(83380400001)(2906002)(6666004)(316002)(66556008)(6486002)(26005)(8936002)(5660300002)(4744005)(2616005)(86362001)(38100700002)(966005)(16576012)(508600001)(66946007)(36756003)(956004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0R2Q2lCaWpvUUdqb1NuT1FHcVQyeU00b2UrRmxrVEdhbXVYdHczSys3UXE5?=
 =?utf-8?B?TjVXSG42Mm11NW8xdFdISjlZWU13bWFFNCttTTJNZCtkR21VbXF5TWVmb3BX?=
 =?utf-8?B?cGxlR1drRFA0SXZlOGcwdnZkbUNaQTJrSS9qL1d1NlowN1hMKzNZWm1YNnZm?=
 =?utf-8?B?MElscC9GNHBmY2lJT2ovMTdoV2V5SnZabUNXdVZPV29FNTI5aWw2Z3BvcHVW?=
 =?utf-8?B?NTJIMVB1RDhIYmJGQW5HUCsycWRIcTlyN2hiaXlGTzlqeUhudjlYNUd6cDNs?=
 =?utf-8?B?NWE2aGp2MlE4ZGhXTktWUjZNUFM1RFA4dzFNS3JHZnoyTCsxbUNqS0h2cVRC?=
 =?utf-8?B?bTdrUDlmRndlaUVRbnFMblJXeTlHTHlOQVBtS2l1TUxuU2Z6aW1xT1R3YVEv?=
 =?utf-8?B?NVJvL2ZkTzh4bTdCTTd3aFZ3R2g5YUIwaUI2a2hpOGc2cHpDR1JmWFY1YlB5?=
 =?utf-8?B?V0Yzc2VWM1ZicmQ3cEVyVVlSanl6b3NoRXpDcHM3UTJ6NTY2ZFJiU1V5VDlp?=
 =?utf-8?B?L0FiRGROcXZHM1FmOFpQSStQUmVzeHh3K2hoUENyQmdLbE9FK0hTTjJzRmly?=
 =?utf-8?B?RHlyOGQ3YkpaOWZzWkZEYXYzNWNxZ2RoWlBiUTBjekN3NHJCV1VhZXJ4QXVR?=
 =?utf-8?B?WlFWUFA5alhtSUlnbW5wM0RCeUJ2TGhySXNxN0FmUVlVU2ptbUwxbmlTdjVk?=
 =?utf-8?B?UVlqWmhEZGwzQStvdnpjOG5WaWkwVEkwRHR2alZWMFFGSDRYdW9VQWl5OHdw?=
 =?utf-8?B?OFNwalNXOGxzck92a21OUzl5ZGY3Y0pJUXE2UzRkNWV6UGVZZVF3Q2kvcDF0?=
 =?utf-8?B?QTJGQ280NFFkNXJZZWhsZjdabjFkZXc0cTQwSk50SjlXeWFTT1VqQmpCQlk0?=
 =?utf-8?B?dUI1OUZHeHBSSEIyd0l5NHRPZ0JQcllqeThUUHQ5RUlBZWpnTEoxeHVWc2VK?=
 =?utf-8?B?ZDBiZGxmbzQ1U1hmTzZaRVdhaEpGdy9XSHdhdlpwcjBvd1R4ajJSbWNBNGxD?=
 =?utf-8?B?M2UyZjR3blRGUFMvMzlaTkRmOWhwVFdVNkdpTnlUUFNRR2ZqWjUyK00vODlw?=
 =?utf-8?B?V1ZqZlN2NmJhcTN2SnR6K2U0OFVsYmplbWdpYkxHLzNQMU9naDVPbGt4NzVh?=
 =?utf-8?B?SUJiTFRRSzVUVGVwbnVHKzA5dEg5aFZiaW1NSE4vUEtKNFlPR0xFTG5MTkFV?=
 =?utf-8?B?WWdlN1hkeCs1RzNYeEsxcHF5WjBwWlhud2d6ei96NUM5TlpQYS9DOUh5eWIr?=
 =?utf-8?B?bCtoWW53NE1Cc2VGcE5ralMxNGFraklaSjJSNFlLbDNNNFJlYWgzWlkveTA4?=
 =?utf-8?B?cnYwYUdwL2YySk9WQXN6L25WOFNLTUJjeEk4eXZGeGF6NTA4YWRaQ2wwK3Jo?=
 =?utf-8?B?Z1BWVkNwakl4c05neTY4NisxZ1dVbnc4RVhid3U1TGVEVTZIYzVKY2VvOFdN?=
 =?utf-8?B?UC9FMFltYVVIandLTXhCVXdySllHb1I1VFdhRzlVUnVjR25OY3EyUko5cmx0?=
 =?utf-8?B?UWtJOUMxZEN4S3REWHNSNzh2dlJqb1BEL0dXUWZDOVJlVGkxZGY2VEhrOVJS?=
 =?utf-8?B?b1FneTJtUEcrMEI5bmErR0pIMVFQUEMvVFV0YXBmNnhleVpVWmlXODIzRWtM?=
 =?utf-8?B?ckgzVEhwZTFJYUUySnFjVUEvdlFZWEVDTnR5UmFqaFFWZ1h5anpyeGQvTUlO?=
 =?utf-8?B?WVhDT2dKMUIvTUF1MEZubTZGeVFYajBDTXEzaVU5MDhTVXllVVR4SlM1NWdk?=
 =?utf-8?B?OHNKd1R5Z01xVXNDRWtzaWpBemV6MkxkYitWUEZYQ3JoV2xRUEs4bUNFRDhP?=
 =?utf-8?B?eWhSRzF3SFhtVnEybEROTDZ3SVZGWDYvVHlmcUdMV0hxTE1RMlVTYzJxdVRR?=
 =?utf-8?B?VVFDN2xlbXRmTE5lcW9RU3hOODNDV1lYcXhOektpOXJSNGk2TE9Za3I5dzlK?=
 =?utf-8?B?VmZpemFYZUlOYTAxOVJpSXdNKy94a0ZJUUZHb21NWEFaMjN1M21MemZiM3hX?=
 =?utf-8?B?K3djcjEvdFNNd2lXaFZiakptbkRuRlVsb3c4UWFxZnpob2FzS2w1VldZV3Q5?=
 =?utf-8?B?UXdwd1o4d1VMUmM5NWEvcHlNUVhHN2ZQY2JXc0cwQVM2bVZaWlRCeXBYWTk3?=
 =?utf-8?B?SzFTNlpwWStDN2xuVm0vZ2srWFpnd3dQZkhnVHB5S0lHN1lXZTNFeVdZV3hy?=
 =?utf-8?Q?Z4WRmOnsANfjEHnahr12bFI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1787573-1edd-42c2-9b5e-08d9b7da01ed
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 10:28:41.5824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6GmVcvV9dRuHVREoYCcBCZZ2HmAkcqaWC/itbykupuCQ+YBNxbp0TnfMoSp18wmmsJtFInBfeLiMABiMMBpQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2021 11:36, Lahav Schlesinger wrote:
[snip]
> But, while "group deletion" is the fastest, it is not suited for
> deleting large number of arbitrary devices which are unknown a head of
> time. Furthermore, moving large number of devices to a group is also a
> costly operation.
> 
> This patch adds support for passing an arbitrary list of ifindex of
> devices to delete with a new IFLA_IFINDEX attribute. A single message
> may contain multiple instances of this attribute).
> This gives a more fine-grained control over which devices to delete,
> while still resulting in rcu_barrier() being called only once.
> Indeed, the timings of using this new API to delete 10K devices is
> the same as using the existing "group" deletion.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
[snip]

Note that Ido raised a good point[1] about group operations and their efficiency
as a reply to v4 of the patch.

+CC Ido

[1] https://marc.info/?l=linux-netdev&m=163869796129581&w=2

