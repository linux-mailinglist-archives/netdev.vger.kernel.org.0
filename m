Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31B4DDEF1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiCRQ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiCRQ3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:29:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8BF192364
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:27:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IGA05r009955;
        Fri, 18 Mar 2022 16:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DRJPvsWEpu8Mqg6PRxgPtxgDr2iO/6F235jZP+WPUss=;
 b=z1YB/xAZBFErTLCw76WkxjO5GwpRUkC+NPPm81OpFfeCSG3lP/77VV8ADYPDkzWLG5Ia
 5gfF/aOKLr6xlMJ4m68zGcyOz8RFKxgD0pftRfkzW0QCf1DMPELC7Lh5ZLOzCG5mk605
 kgIp0ZQ1qvrG7HBruiOfFiJVGg1/YVx7GtUgjtOEOeD8RdaEyPzTVHxm5Zsvru1OMobW
 IYJBtzKHuxKt4VfnjDNwekO4E+5v4tZ2BCWQrzO2HxjQOanQr/1pm3caZL0anCSHIoce
 3s8ZrFOqnBhl399uwQuzKKUhF2vLCHzWmffUEH5HnSXrY3xe6hudf+4Hn07FYkv+D2cx 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52q4am5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 16:27:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22IGGB66114847;
        Fri, 18 Mar 2022 16:27:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3et64mw265-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 16:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr4+uHQJb/2p0GPlYF4f2R5ph52fBu8a6zosd56k25osWc53juGi747D/lI7w8BRgxCPc0t61ajvTHib3AlHdtRIrcUj/FJzmkoNamsgXWsTSLvWMZWrLZOfmXAehOT9Ci0jazbodoMVjc0Vd5ciLGIrbf3jsYoXVUR/gBd8BB7JyVh1ytMKI+f5V4+so3Jdgigy9H1ADcOkQ3Drem5oS6ERjcS5NvhUwJz4Uf8LGf5908qROalNz93MP/38Us1wLreFJY1dWbNwZPCh4FlxNk9MZtlb0fdJJ4FjDLH/6bQvnNkWvOGptKZfDzXkJ7uMv9jEFqI5vpEocN/vTtBIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRJPvsWEpu8Mqg6PRxgPtxgDr2iO/6F235jZP+WPUss=;
 b=eY2417t59H5AeZXGlBWF2fz2PL7+Eah/VNKtEXY115gFE51nA9NmR4E6At/mRrvmpftrxyP5JLUy65fmVBg/935PP0bRyuPO682eWUv85r4pXdI4bjx0/AAbOD7k0zfWmQe0bevpJpGw5LEkMw6+L856E9B4IVNq0il+QhEFZVDlBueFGwBznslliSGEf/1z1f8EH6unc/yx1L5zKcqrX56hso9YN7smkJuMNgkbEntDigDCl6+zsJRmB296O/CLrO9Q8kNl6UW0j6RU1H932HnfeBVJtZWTJV59lAV7euAgOp4dOnTSjqLdfbne+9q5k6wut9v3nVhdpzQ+qynQCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRJPvsWEpu8Mqg6PRxgPtxgDr2iO/6F235jZP+WPUss=;
 b=RuT488CDGynXgKWmNY69S03CFyyHz3qREtU0ZavIF2fwB2v8aXLEY5Of2a8FJWs6nfic60JiLJctHbZLEHldFk3YCybTAm6rNhy9k7SEbM06OU6Mb+pvN4z5Hx1yODEREYc1l0SnS6SdrqDVs4ClrP4oqBFPKv3o8m2yQW9SJ0o=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BN0PR10MB5503.namprd10.prod.outlook.com (2603:10b6:408:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 16:27:47 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::e478:4b5e:50a8:7f96]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::e478:4b5e:50a8:7f96%6]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 16:27:47 +0000
Message-ID: <e0d3d255-ffb8-f830-f64a-b4de32d871a5@oracle.com>
Date:   Fri, 18 Mar 2022 09:27:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] vdpa: Update man page with added support to configure max
 vq pair
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, dsahern@kernel.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, jasowang@redhat.com
Cc:     mst@redhat.com, lulu@redhat.com, parav@nvidia.com
References: <20220315131358.7210-1-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220315131358.7210-1-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::21) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f0fc645-aca9-4384-57ec-08da08fc3cd6
X-MS-TrafficTypeDiagnostic: BN0PR10MB5503:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB55033C47F37C1A13685F9E63B1139@BN0PR10MB5503.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +aZJ8BC1fzjM/eNEd/Y/kolXFOyAXq+vNzcuB0w+fwGunQxxnx6oA6zzYOfSt6PHfn0t50UZfHOnDjyqoUAKpU6Wmk2LDiAyyzXIwww8A7KuMV43R9lnBxJOx+Gte+FQnvUlEg9yjc60AD6FjVhKkltSwYshgQJ1eVlx7oUNCnDsjOgFiQntXbhQcUwLFpWSEBeMLcC2qvULqKa0AdyhAgnZaxfMgiDVuCULcyB1cYO7V710ds6cBW68zk/Nd/VGzpGbQyXK3hWrnBctwOy/FhdDTBSLqWjzu8hi/iwYQAmUZXpwZRbjLEiLKjhBrh/IVFG5XbXkeDbMCxeoVzuWRwBGtx9PpZhPyXSeRwcMMSnFWThmenWmdahuEVgqh5wtdCv67o3SsxKi/DgZJxI0eQkup8QH29+cqsYbd26jaA1PzzCPmK+Mjl0/owvhnt0h9DAszpvIoxz4NRq6ZpzVd6tuIDMZqtZhM92OVGe3GGR08ZonE8YN6yXG8EokxcWCqcsG6C67t0I8XvztFbcZ1hfuBZE8QkrJtBm+RsfpzjP/G81MMrP+RfSPTPw4MJHc8Rz8ZWIIAm6FnrkMG7uB54RjPzht6Eopvm3gx+aQIVfua9snPOdGQjP9uAo3AnvCFl8l0F9gKODaaaHK1rMh4Qoi0Y++aQevpBU382czKc9VAHVv216CKQpCzuoLTVYIMSoBr/vYJEoDOSUB74x2CVakL3tm54niMZoxeCAhNqA3+Ambt8kBmchNgpF9uX4d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(5660300002)(4326008)(6486002)(6666004)(2906002)(8936002)(26005)(186003)(508600001)(36756003)(31686004)(6506007)(36916002)(2616005)(6512007)(83380400001)(53546011)(86362001)(31696002)(38100700002)(316002)(66556008)(66946007)(66476007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGp5MXFBVlVYeHZ1Vmk4TGlUUjFnK1RVNmJMTEVlRUlyUWdmVkNJL1FJa0xN?=
 =?utf-8?B?TDZSNVlrNEFhcTZHT21zUXlRWitvdTZHbzF3cWlQY0tPL3dTd0dnWDhBNWdD?=
 =?utf-8?B?dEhaVXRvM2NkQVZ1bDQrb0lRU29vVzkvZzRieGVaTDQ0RWtrR1ZpVkpCM0xW?=
 =?utf-8?B?T2NwNlJRWHVCb1hwSkc0N0lLa0J1MVFyeEVaVnhSUnYxNHpQbWl2K0kyeXpo?=
 =?utf-8?B?S1p2N2RxTkNKcVhaT0NXbWhWaktnV1ZQOEh1VmdaU2U4NWl6NTg4cnZJc2ds?=
 =?utf-8?B?OC9UR2k4cHFyS1pEa2R2YlZ2dTVXZFRrMWo3S1RSc3R4MDRId2wvc0laUyt1?=
 =?utf-8?B?MVJ5azQvcEE5TktqYnF3Ulhqa2VmVWtYZkdKNm5VV2tOa3lWT2FQSVJZNnVM?=
 =?utf-8?B?OUQ1dWU5OUZtcmNHNTlaR2VCY0l6bXlBQ0JVajRzS2V3WGJwdkpPUVFSNldo?=
 =?utf-8?B?Tk12MjBuVGV3WVBTajJSVlhmY2ZmMHBNeDE1MlFxL1g3WUlTQU1qQmU1UVdl?=
 =?utf-8?B?VG9sZGJFdGdabHZITjB5N05HWmVWdXJ6MXp0d1JmNENzWG1FM016RFNrUSs3?=
 =?utf-8?B?NGZXRk9jMnd1T0dmekpGc3FqVWozZCtwN1pxb0dzUEhwb051bkJKb0ZSRnRC?=
 =?utf-8?B?UmJrcnRrZ1RPMDNpQjRNclFJM2U2M29TSUJXa01iSFdpd0pnenV1dzNQZmZa?=
 =?utf-8?B?TUNXQ1hhb1cwNXg4RzdhOE1LUEpIZzRVMmVvWjNqY2xGeXlMdHEzMnFIaGNK?=
 =?utf-8?B?STZYanhGQ2NsM2VOVW9YUXRZdEt1ZklLQThtSmhSeHp4bWdiMk1BZTJ5TFpF?=
 =?utf-8?B?ekVRRk9UbFN2ZnN3L1RCZ3N4dWRBdk1zN1A4UkUxaVhicTBTNjlMT0VKL3J6?=
 =?utf-8?B?UlJ3OHMxSk5CUms0SEdYRGpaSWU5K0tWbGxxMm5FK0FZNnJuc2FIbUJzT3li?=
 =?utf-8?B?UDVZNEhHZTdMRVhPN2Y0MWh4R0xoZXVXeU9DclI2ZHdnL0VBTTRpbVpjQ09Z?=
 =?utf-8?B?Zjd2QVZXMDcvbCs1dnZqMnNUQmRJK3ZDa3EvVU1DREI2ckR4M1h1Y21ZQVlS?=
 =?utf-8?B?MEtYdFpyNU1BOEVhRlNYNUFOMk1ienU3SzhSU3RoQ3pveksreDN3NWRxNTZI?=
 =?utf-8?B?NlRHRXFFWlZ1UklRdmhLeXdVeWN4Z004MFBYaC9EOGVLV0l4RktpeDE2NGQw?=
 =?utf-8?B?UXZGZUs2dml4M1lQMWZSOHQyS0FaV3dkeEJMVEo3WDN6empnQlRKQzUzc1JR?=
 =?utf-8?B?RzlaODVpMU1QcERpTnNwKy9GcDEyclVyY3gvZ0VFdUROZncvNCtHL3UwRzlE?=
 =?utf-8?B?VlFBUndjQVNqWk0vLzMvMGQ1YnNPSkVUckl3bWFPMHVVakZHT05CZDdYQzBu?=
 =?utf-8?B?V0FZTzRjNjJNMUZsSGFZN2d4ZnRmL2J5ellsNEI1ayttSzdaU2pPbm1PbS9J?=
 =?utf-8?B?RE9iemNkL29UY1htTThLb2pVclBRWnFwU25tNTUrODQ1bG9QekxlVk5YT3NW?=
 =?utf-8?B?RnlwZGF4Y1N3YmZLbHBtZHArc3plS3ZkeU85VW5xSkNjdFFmM3VCYVQwcDZm?=
 =?utf-8?B?NUNXemN2MjhWZHFJSkFubTU4Y0Y5YWNDVnd2b29UbWF2Q3BqOHJVYS9JWU9L?=
 =?utf-8?B?M1U5WHRiSGJ5bnNRV3g2aXRYMjJQbG9pelpDczNtbG5zUFBrdFBUMHlZWVpP?=
 =?utf-8?B?aWxUOG0zZmRVMHpPTzNwQ0xwWkFaY3hvQmF1cGRMbXo4N0JlZ3dCVkludVI4?=
 =?utf-8?B?UVZ3Wjk3Yk5tWWM3bzVKZkVLZDE1cHFTQ3hZV2hQRms3ZGYyUmxSTW5RaDdP?=
 =?utf-8?B?d0ZwN1V5TFVGWHpGSUV4T3JHTmN1bXZsZlRHTUY4Zk93MHJBNzNGY0VmV1Nm?=
 =?utf-8?B?K201R0FHM1B2MWlTQVVSQ0tVVnl6c21UaVJrZ29yTG1EMGJnMTZrcUwzNFZl?=
 =?utf-8?B?WXR3YlduMllFRUdhMWtJeWV6MTFsdDlkcXg1ci9NbEhmZ2Z4ck1yYVFLbldp?=
 =?utf-8?B?R1JZaENUTW9nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0fc645-aca9-4384-57ec-08da08fc3cd6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 16:27:47.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQo7EkpOjrOwhdWjpE+d9DQrJkbI6CffiNehK219OzDjzqSJN8mrIDuzfPSFPHSRgW4pABMe3aW5QQsNgNCYbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5503
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180088
X-Proofpoint-GUID: IXl7TVhOIV57olN5jhXywyXMN0-0jFrg
X-Proofpoint-ORIG-GUID: IXl7TVhOIV57olN5jhXywyXMN0-0jFrg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2022 6:13 AM, Eli Cohen wrote:
> Update man page to include information how to configure the max
> virtqueue pairs for a vdpa device when creating one.
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   man/man8/vdpa-dev.8 | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> index aa21ae3acbd8..432867c65182 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -33,6 +33,7 @@ vdpa-dev \- vdpa device configuration
>   .I MGMTDEV
>   .RI "[ mac " MACADDR " ]"
>   .RI "[ mtu " MTU " ]"
> +.RI "[ max_vqp " MAX_VQ_PAIRS " ]"
>   


Here it introduces the max_vqp option to the SYNOPSIS. I would be nice 
to describe what it means and which device type is applicable in the 
below section:

> .PP
> .BI mac " MACADDR"
> - specifies the mac address for the new vdpa device.
> This is applicable only for the network type of vdpa device. This is optional.
>
> .BI mtu " MTU"
> - specifies the mtu for the new vdpa device.
> This is applicable only for the network type of vdpa device. This is optional.
>

Otherwise looks good to me.

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>

Thanks,
-Siwei
>   .ti -8
>   .B vdpa dev del
> @@ -119,6 +120,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu 9000
>   Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55 and mtu of 9000 bytes.
>   .RE
>   .PP
> +vdpa dev add name foo mgmtdev auxiliary/mlx5_core.sf.1 mac 00:11:22:33:44:55 max_vqp 8
> +.RS 4
> +Add the vdpa device named foo on the management device auxiliary/mlx5_core.sf.1 with mac address of 00:11:22:33:44:55 and max 8 virtqueue pairs
> +.RE
> +.PP
>   vdpa dev del foo
>   .RS 4
>   Delete the vdpa device named foo which was previously created.

