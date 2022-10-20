Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B886059A9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJTIZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJTIZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:25:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C6EA2AB8;
        Thu, 20 Oct 2022 01:25:04 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K5p83Q012899;
        Thu, 20 Oct 2022 08:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yWyknBdBTnOs5oov1E6TgyBY1uNRUbbc36uSqA7wcuI=;
 b=dN/UC/TnHptgFufeFSNhhp0VOEyFn6l35q+rjkP74xbByROMYsRhTn4a/JLwmaPFGgoZ
 8/THMqwfZC0iYH4XfV9Td0424+tZYEkfkHJtn5Udn3bXStDtyDK0sbAByE0L1NEHmfuj
 rnxTMq3sTK2gKMpot6aqeO4betauSw7lipOMTbh3y/2P5niZEtadU01QLDMkdAJZYMmy
 0O/cI8vptxy6rO++NhYHnlun9jozcsb2w654WbVPE686nIhagBsv1bEnFcJxcVPe9PiR
 zhy1SMYVK2osqgUYSsVgfY8aZffFhf+DHZ12TBhcvMXDomSNouaUTXug7q9mXiqDGykh FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9aww7x02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:24:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29K7fwtB038437;
        Thu, 20 Oct 2022 08:24:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr21jvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxKfBf6vNpA4A6OuxOuidM3A81HSntRAJFrdYGiFE8rQbaqkWErgOWnVcuu/qCfLpa6QNTFyeojH6RSdTWXPsOQHFM4xnT3w5wGyDpic2Q51XhOGYnf+3fbzIJs/1YIYAIfCqhdXIarJAMvrSbE3hRGer9NZWMrQ0rjq5Ze+0kWcTba7ffqiSvCiTs1xB7bJppqIE9aQ/gr06ypouDbYJLoj4yPWG+pV1IqsVpGqNSzR07SvlO7Gs5McgQOvxZjMSXUH9meVRbB9nPaNLrgiCyn8FHFS+RmgHlKDVh77jhZ9q6VzI81RZTBwu8ZKujjVLE8B644U/u5TpltaMOLehw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWyknBdBTnOs5oov1E6TgyBY1uNRUbbc36uSqA7wcuI=;
 b=JednM9/z+6UllMBSAMtmJKtqIpgw0uldqdV8nEhaW3VC7kvbMqvm+tN8Qn2bYcUeGX0whYD8gMXZd27YUttmk+/BVjlaovX6wuoukGGuxcSY9b6zE3dGBFdAE9cakSmyl467dPkFazwJxXTaHlqFOOIOWPQDP1Qp7UIO6aBFTdOFZV+lRWgCFgM4o5ZsnDMrNwG7vxVDWSv3PQgrdpRQ5tvXZi72wvt6Nl/0H6c8rrisf2g7e7vv3EcFTvOCMW/4va5lgV9gfa/Ic88jcS/M0MzpfTyY0670OVirM2f3swIucXhsv5MTHp0GMB7vKUwI53oPimoge9tmN7JVPCHJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWyknBdBTnOs5oov1E6TgyBY1uNRUbbc36uSqA7wcuI=;
 b=fukCGKF58FSLOtGC/Cv246tlZ40oxHsMT1YegVR4Jy88no21c2uha/8kihv5ogVwmQgeAjHEoVJaxJ336IDsrc7OA9pAdEsVU/y8lPFJnjGA4+1VNS5xQrqYHEfg4MIFqbIBU9GLFThPlnbCk9TXCE/A4FoB2jQYTcs3CyYZ3fY=
Received: from BYAPR10MB3575.namprd10.prod.outlook.com (2603:10b6:a03:11f::10)
 by DM6PR10MB4345.namprd10.prod.outlook.com (2603:10b6:5:21a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 08:24:56 +0000
Received: from BYAPR10MB3575.namprd10.prod.outlook.com
 ([fe80::34c3:574c:1f2e:3854]) by BYAPR10MB3575.namprd10.prod.outlook.com
 ([fe80::34c3:574c:1f2e:3854%4]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 08:24:56 +0000
Message-ID: <60899818-61fc-3d1e-e908-fb595cac1940@oracle.com>
Date:   Thu, 20 Oct 2022 01:24:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com
References: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
 <Y0frx6g/iadBBYgQ@unreal> <a7fad299-6df5-e79b-960a-c85c7ea4235a@oracle.com>
 <Y05aGuXSEtSt2aS2@unreal>
From:   Aru <aru.kolappan@oracle.com>
In-Reply-To: <Y05aGuXSEtSt2aS2@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:a03:333::28) To BYAPR10MB3575.namprd10.prod.outlook.com
 (2603:10b6:a03:11f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3575:EE_|DM6PR10MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: 187f4383-8199-42b4-d7ee-08dab2749218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /oUQGLExHppfs//NC9/EOV1qQdDHXRIyCcJOHda9+ZyKnumjVvGgWNxCzlymnzJpsyobvoxHKz72Wzw8gODT1zzJxaVfY0ZIRoYyswolp0GH/whEFckYUC5ZjvLYi8uZJd0EUUAwKjrqpdoK8+xx8dlx4XrzqKzooYH9SI+fDUR9HhbjXT11LHF7f+DS7z1tH4/gN3T9Ud5glLv/czFMaLw66R8vOI8N8o2Acn23ohbL8VNxCRKATWj+NdygEaZWvfYtyTasuaLWQzbxRe/12f4agYeRTBBHmMg31exzEHQWOD9/9YoZBFrHeme5tA8OyVKOdYhlGtPsNKoVHeO5FfSNtTO1EVg1m+YLWcRp/75bzQpGd4N3IcAP6uFp6Of6PcJ6KIATVD/EwBcZZL44eMZkk8fmJg9WXGHKdpoYexfY51o4zpDTLdkrjJyR/lzAPBvQanYqg3iaZp7OiD8k+zpaf/XsvqD1w2jz/Zryv/oxA/Mpfn7awYSDbmf1P+PowBKPTyU3yucfx2g1ZAHoXydCXacPTt7DZ2OAMOsepifixYSvIoybiXj/ABl5amZgrCk5p6G0EAR/yc9mngi4ZDu493d6IoPUhHkJp3ZZSR9EXVD+G0/WQWb061w85zDBINTyEb40RSSidbWwWk0VQKljZtcMja8mecBp1eEVZZP1kd7E0QY3N3J1Ht+brsRPJYZFBBAm2GkVPXjeOztlGxzm7ZeGTZEKjvuOBp/7nAiQbPUsDPwJW6vDTEJ0MDB+y3TdxiloL7vQbpY3Kkh0OAu0SOylpVVhSvc9pIqjjC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3575.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(6506007)(31686004)(316002)(41300700001)(53546011)(5660300002)(26005)(6512007)(2906002)(36756003)(6916009)(4326008)(8936002)(66476007)(8676002)(86362001)(31696002)(66946007)(66556008)(6486002)(107886003)(478600001)(83380400001)(38100700002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3FsYlhXeElZLzdkSXAzTmtUREFrSUZXREpOejFvOUw0eTNFTUJkc2hVSmtI?=
 =?utf-8?B?SE56NDQvaFVBaVJFbFNCZEtnbTdac1NsNktLUTFKWVpQU3hrcGVNWW0rbDFp?=
 =?utf-8?B?dU0vWFYwL2l3OUkyS1ltSE01V0JLUmp6Z3VQQjBrbWJoVXMyby9ncEN1WGt5?=
 =?utf-8?B?Qzl5eFZIcGk4QnhsQnJCczliL2dETTlYaDJjME9scDF1cFJSMUgwZWVuM1hh?=
 =?utf-8?B?STBpazJtcWNsV21RMEhDSm9Fb2dZSjV1TEMzSmlOSzB2azJJUDFjZytyaWxS?=
 =?utf-8?B?TDR3Sm84Ylk2WUhDRlh5RGRVajk3bVdCNVY3S2ZDbXRXZ0NZM1FQRWN4OHRG?=
 =?utf-8?B?am84dGkzWTVOcVkrYUhrYjFmYS8yYzRETW9iZ3NzUTN0aGIxVFBKWGJMZ0sx?=
 =?utf-8?B?V1IrenppSVNvYm9FalNYblZaR1lnaVoyRVVBQnlyQWhuSjQxVExScFZQeWVw?=
 =?utf-8?B?NmV1Q1pFOFJsRUV5amphZ0N0MWZWM21PZmlJb0dZL3U0UHA2bDVDTUY1dDV6?=
 =?utf-8?B?dk1sUWhwTGczOVRCSWNaUm1oR2lOeUdLNmlDZVJwWE1LNnZOc1dHVlJQOFFG?=
 =?utf-8?B?WWdJWmozM0JMV0hZWERtOCs2MWFCd1MwVFFQdUVLUm92dnZaOUdMNnlWRXNm?=
 =?utf-8?B?TmJybE8xbk5rdFlBSzA3eHFuSGdzV2pvMkUxR3U2WWwzb0RON213ejZmLzVk?=
 =?utf-8?B?WXQrdE4zUVdtQ1laSjRwbkVtZzZIN0hXc2pXaEhmT2wwOUR0bWFDcW1PUm5n?=
 =?utf-8?B?b2NYY2xZMzA3cDN0dnBaNFY5ODc4OHBab09YbzZuMlg4M2NOcUxBdHZPVVdF?=
 =?utf-8?B?V3NGd1Flb3BJTklGSTJKRGRzdVFJbHh0dnNTN3ppaTlpRmF4OVIzQ3puQUtt?=
 =?utf-8?B?SVl4MHNybFJYMXhOdGNIUjZtcWNpTDhBNlA0SGtySVVHSjF6Szd5YTNqVXpB?=
 =?utf-8?B?YjZkWjFRbnBXbG1vT015cVYrQTF0QWVXUSt1RldxcW9xZHpFNFUxT2t6d2JQ?=
 =?utf-8?B?dkthdkdmUnZCdy9iSVd0RUlxTGFmbzdaTlJVcUxwS0xqMjlwekJkQWJPamJx?=
 =?utf-8?B?WWpxZmYrcVo1d0huQktHdzVremM2dVlSYmx3b3NLTnhVdnd3RkZvWUhnM2sv?=
 =?utf-8?B?OXQ2ZG54QlF2TmFVOWUvUWljZEZLQUZybHBoNTN0L2pETEE4Wk9yU3g5c1Ra?=
 =?utf-8?B?akZjNTFnZ1VoNVdzSzJDS001akZYdkJYbnk0SzN3Y0dCS2dyeGJ5ZldHQ1lV?=
 =?utf-8?B?cnN6U3NjeWJWVWYrbGlCdlBWbUpjRHM2eGhaSlZ4U0wzclpZaVFGOEF1SWZ0?=
 =?utf-8?B?R1VDeDdRVkErMW5LMk40VG90RUdDR1BrZ0wwTkJHMURKdVNidUpYaWpaNEtP?=
 =?utf-8?B?ekJ5ajdmSDF5RURqckpRa0hBQThacnE2OUlOWEE3K3FyRWRFaFdnNEU4WDFK?=
 =?utf-8?B?bS83eTBCc3phNjNkR1hmZG15SCs4MXVxdDZsNk9NVURWcWszNnRhS3VOdTRj?=
 =?utf-8?B?VWtUbkM3SGxzcHVYd2xsSHdFdlVXUk5EZzVaSGNOcW5rSUw1ZXpZc29Ick5w?=
 =?utf-8?B?ckZEYTQ4VDJBMEZya21mcUxJNC9RZ2FoYTBIemlNWGpOUGgwQ2RTNTNUVFhm?=
 =?utf-8?B?SVFEYjdkdFB2WTNHYXhZc2V0enNMcHZ2aU01UE5jdCtrbktvekNURW5CeEU0?=
 =?utf-8?B?U2xES0YzS2tBU1p1S3hjMjNYQzQxSXB5ZjgrSWxnYWQ1OC8yMGI3UklmUEdI?=
 =?utf-8?B?WXlyaE1uZDJUSS9OaWczYUJrRmc0V01uMmsrTU5PcnovYXVXd1hVRUJlTEVJ?=
 =?utf-8?B?eGVwd0t6KzZTNGNkT1ZPV3ZJSDA4dnNnSFYxNVhhSWFBTkp4cDV2OXVVSWgw?=
 =?utf-8?B?YTZzZWVkWnN1N1UycFd5WEZyRVp3dDZ6Y3BkamN4TEZmT24zWDlRazBUVUZI?=
 =?utf-8?B?Y3Z6bHVxV21qQldocHFYbkkzR2xwdlpvN3p2QVBITUYybDhBdUF5ZjBJdEtF?=
 =?utf-8?B?VTJYOFpXWmdCaTZJb3BGaVN3NGJVU2p5eW5FZmtWNklnMHhyWWxmeEYvTG1D?=
 =?utf-8?B?cGtvUi9ud0R3bVBqTmk3UUdUK3l4Wkl6N0ltKzBtSk0xMDV3Q0VXaDJ1QWRD?=
 =?utf-8?Q?OARoOkzzEItJA1TNerQak0yOK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187f4383-8199-42b4-d7ee-08dab2749218
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3575.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 08:24:56.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1XVoEqPB/xvM44uBQvj1APh0Ag+f8HAwt1EaE5KsYg1erULSj2I4uYxmp4KLcrrrRFJIi1VsLcixLn5WKsvnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200049
X-Proofpoint-GUID: Xruk_vYGiodryG9OD2O6RXS0BG9blrBf
X-Proofpoint-ORIG-GUID: Xruk_vYGiodryG9OD2O6RXS0BG9blrBf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/22 12:47 AM, Leon Romanovsky wrote:
> On Fri, Oct 14, 2022 at 12:12:36PM -0700, Aru wrote:
>> Hi Leon,
>>
>> Thank you for reviewing the patch.
>>
>> The method you mentioned disables the dump permanently for the kernel.
>> We thought vendor might have enabled it for their consumption when needed.
>> Hence we made it dynamic, so that it can be enabled/disabled at run time.
>>
>> Especially, in a production environment, having the option to turn this log
>> on/off
>> at runtime will be helpful.
> While you are interested on/off this specific warning, your change will
> cause "to hide" all syndromes as it is unlikely that anyone runs in
> production with debug prints.
>
>   -   mlx5_ib_warn(dev, "dump error cqe\n");
>   +   mlx5_ib_dbg(dev, "dump error cqe\n");
>
> Something like this will do the trick without interrupting to the others.
>
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 457f57b088c6..966206085eb3 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -267,10 +267,29 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
>   	wc->wc_flags |= IB_WC_WITH_NETWORK_HDR_TYPE;
>   }
>   
> -static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
> +static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe,
> +		     struct ib_wc *wc, int dump)
>   {
> -	mlx5_ib_warn(dev, "dump error cqe\n");
> -	mlx5_dump_err_cqe(dev->mdev, cqe);
> +	const char *level;
> +
> +	if (!dump)
> +		return;
> +
> +	mlx5_ib_warn(dev, "WC error: %d, Message: %s\n", wc->status,
> +		     ib_wc_status_msg(wc->status));
> +
> +	if (dump == 1) {
> +		mlx5_ib_warn(dev, "dump error cqe\n");
> +		level = KERN_WARNING;
> +	}
> +
> +	if (dump == 2) {
> +		mlx5_ib_dbg(dev, "dump error cqe\n");
> +		level = KERN_DEBUG;
> +	}
> +
> +	print_hex_dump(level, "", DUMP_PREFIX_OFFSET, 16, 1, cqe, sizeof(*cqe),
> +		       false);
>   }
Hi Leon,

Thank you for the reply and your suggested method to handle this debug 
logging.

We set 'dump=2' for the syndromes applicable to our scenario:  
MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR,
MLX5_CQE_SYNDROME_REMOTE_OP_ERR and MLX5_CQE_SYNDROME_LOCAL_PROT_ERR.
We verified this code change and by default, the dump_cqe is not printed 
to syslog until
the level is changed to KERN_DEBUG level. This works as expected.

I will send out another email with the patch using your method.

Is it fine with you If I add your name in the 'suggested-by' field in 
the new patch?

Thanks
Aru

>   
>   static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
> @@ -300,6 +319,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
>   		wc->status = IB_WC_BAD_RESP_ERR;
>   		break;
>   	case MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR:
> +		dump = 2;
>   		wc->status = IB_WC_LOC_ACCESS_ERR;
>   		break;
>   	case MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
> @@ -328,11 +348,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
>   	}
>   
>   	wc->vendor_err = cqe->vendor_err_synd;
> -	if (dump) {
> -		mlx5_ib_warn(dev, "WC error: %d, Message: %s\n", wc->status,
> -			     ib_wc_status_msg(wc->status));
> -		dump_cqe(dev, cqe);
> -	}
> +	dump_cqe(dev, cqe, wc, dump);
>   }
>   
>   static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,
>
>> Feel free to share your thoughts.
> And please don't top-post.
>
> Thanks
>> Thanks,
>> Aru
>>
>> On 10/13/22 3:43 AM, Leon Romanovsky wrote:
>>> On Wed, Oct 12, 2022 at 04:52:52PM -0700, Aru Kolappan wrote:
>>>> From: Arumugam Kolappan <aru.kolappan@oracle.com>
>>>>
>>>> Presently, mlx5 driver dumps error CQE by default for few syndromes. Some
>>>> syndromes are expected due to application behavior[Ex: REMOTE_ACCESS_ERR
>>>> for revoking rkey before RDMA operation is completed]. There is no option
>>>> to disable the log if the application decided to do so. This patch
>>>> converts the log into dynamic print and by default, this debug print is
>>>> disabled. Users can enable/disable this logging at runtime if needed.
>>>>
>>>> Suggested-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>>>> Signed-off-by: Arumugam Kolappan <aru.kolappan@oracle.com>
>>>> ---
>>>>    drivers/infiniband/hw/mlx5/cq.c | 2 +-
>>>>    include/linux/mlx5/cq.h         | 4 ++--
>>>>    2 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>>>> index be189e0..890cdc3 100644
>>>> --- a/drivers/infiniband/hw/mlx5/cq.c
>>>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>>>> @@ -269,7 +269,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
>>>>    static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
>>>>    {
>>>> -	mlx5_ib_warn(dev, "dump error cqe\n");
>>>> +	mlx5_ib_dbg(dev, "dump error cqe\n");
>>> This path should be handled in switch<->case of mlx5_handle_error_cqe()
>>> by skipping dump_cqe for MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR.
>>>
>>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>>> index be189e0525de..2d75c3071a1e 100644
>>> --- a/drivers/infiniband/hw/mlx5/cq.c
>>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>>> @@ -306,6 +306,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
>>>                   wc->status = IB_WC_REM_INV_REQ_ERR;
>>>                   break;
>>>           case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
>>> +               dump = 0;
>>>                   wc->status = IB_WC_REM_ACCESS_ERR;
>>>                   break;
>>>           case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:
>>>
>>> Thanks
