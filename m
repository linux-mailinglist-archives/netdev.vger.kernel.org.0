Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534EB315D5A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhBJCdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:33:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34354 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhBJCbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:31:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A2Tuct005119;
        Wed, 10 Feb 2021 02:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Or2jmmlYiNXd2tTj0RQNVkDfZM+1wpjCjO6ANL1Cifc=;
 b=Olnl0Ikm7+lcl5t97nSVYwlR96wD+mwt7MuNHQHrl2p6mz+RKkOC6vVgS/vjjCQgoFLu
 txO7atdueo9LTRahi8ACWrvZ0zCHjpMrB8jzDLEiFUKnUGoMsx/6KWHM8tSXT46/DxJv
 zj2X+lfUGeQsUYjIXzFhE+UZSGvFQvG/uizZrt9QC26M8Pr2h9e1AHUAnjb7D+sAxcnR
 zMeTZRlVYcvzQRaau9EM+gl+rKNJOZUmllors55X9uzUiZMP5FhT0cxYzw/zqBpI0HlT
 oLhh6L2NupJYix982ew9juL3LyP/kij1QHn28KdYwWSKg7z0nJ3nvtcw/c1Ya6qT4nec OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36hgmaht0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 02:30:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A2OejQ117026;
        Wed, 10 Feb 2021 02:30:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3020.oracle.com with ESMTP id 36j4vs73pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 02:30:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vp2O15Iv8cmzwyV/n8mNNtfvG4sPBcw0CMHk/pPxCntRLwdlrIDzQhcGPiW5RPMWzuVJl/Tc9K6c8By707sOQlxm3hGR7Kmj55z9wiPeo51qI2A8esjmhPK8xXO3oqcNp9Joys1vQ3XBo4jDDJIr+Ccl1W0wOs3wBBZvdebNcv+oD+PuQ608tklSNW2AR4wLod17uYPAl216wp7D9kvZ3+PTHvoooaDQiJQWr1XKias5GNC350fHV06PGm98rIjmjIx9EAPqz/XJZlQlbU97Kx4uqw4U0/87kMraPcLwNVa5NHlkI0JJoDAGuKI0kCKProfa0Pw8LaWm47v0SMtYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or2jmmlYiNXd2tTj0RQNVkDfZM+1wpjCjO6ANL1Cifc=;
 b=CmU+6orvVem6VEoGmlUoGDJ/xzuqqAOJzsASgeJEmOgnXAlj/pGVdO1ZnWYCWRYCMg4GsbDkCswHq8Si14CZ/cK2W+j5qrxACB9BleTXuox3puoY0hCPLSYUqt/5JgPD/5ZbRgN2PKGHyRPcCIzBIh7IOZbcZGI3rMa5yxOWkVVPUSThLmv+OKSXlBTP7Nqmd2HEovNPESFVjdEnI9PDM5CbaVqGLy/9cgglvORxkRAiGTvWqYs3t9W8uj+9cYf617odsk63jZvYpBfWphJXeXv0hP5Oirh3IHBEo0Lmf7FklI4FPKAtGsc6/lkBahFLgbY4zDMfcLT7FQIX5BsjRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or2jmmlYiNXd2tTj0RQNVkDfZM+1wpjCjO6ANL1Cifc=;
 b=ZvR1dnSeaTZTG+76vZSZTiXgBI3MEXyreBLPXyO1nvJ8bDFISYT/7qCX3iHHWO7RVaozfr6OsIZpeglBlcZexhPbhnVlycDOHFWhNTE9S4YPQxs+7zHn9rW61G83vAYWwm2aCzHXfFLRfqbXlBov4UWQdES8zBYytsfNAaUmr0E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3128.namprd10.prod.outlook.com (2603:10b6:a03:14e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 02:30:05 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.026; Wed, 10 Feb 2021
 02:30:05 +0000
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
Date:   Tue, 9 Feb 2021 18:30:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by BY3PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:39a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 02:30:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 661e1df6-3f60-49d9-974c-08d8cd6bc66b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3128:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3128B45624432CDE38FB12E4B18D9@BYAPR10MB3128.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjHLI6qLU9FS2oiyhWzquUQn8jG1iznw8MXKBKBj6GlA5OdEiPZPL3MbDPux638H35YKpoo90RhOOhj5wpoLBN8jL9vxmnxttEeTaod1/Ti2TlHbKskGV77AyA1JAoodVeD0Hoe4u8Sx8dK6eepxSIbNuz9xj5Vc0RQ4D6yiexxrWg2HsDb3+Shg2ttXGduMfsThiaInW/zVTUHIRLZvtqMyi2FSNGr1LCk/kf5jr9MILnT9w2osdZAkumKrJ81ZSTSCkXmLxnoTl/E+gU15cMSaHNTOCb/d9FTZL7WTWpW7/3XXbVzJ63Gw1T6q+UL6l9fmVkO48V22NDefXLBRmrr8av958hOlVnyj/vZOIIeRzFpMlhqLJzgwLYxU+LXBtPeVE0gneQy5FE3Zc6JoKAmAOzMJy321vEPCP+3SB47jeGSsAh2lEthN+dAInjm8tbMrGIXUhCSOwMm8pNJosUUtxCqBG/dKtFzUR0bPixtN/kGPFdCkFRkNapm4Y5BJW8SCZtg5BqET30TnUgUG5OgNzkAFAJq1nEpb1aDhJtxvhYpsWJ8jVX/G7Du/0QKGvhDwpudLIKZ4jmlLkDcoam8SWmXbr/L5nG6SWTRQBp4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(31686004)(6486002)(53546011)(83380400001)(5660300002)(26005)(8936002)(86362001)(16526019)(2616005)(316002)(36916002)(110136005)(186003)(2906002)(16576012)(8676002)(4326008)(956004)(36756003)(478600001)(66476007)(31696002)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?alZwcEd1MnJvVEErWWFGY1hzaXFOZ2VVbnJKaEdVb0lQcjZDWW9EeFBPalR4?=
 =?utf-8?B?TnRpMDNjWXN0RE1MaTVteWgzUHpLVVNhdGthZlpXNlZsTG1CNG9WS004aFh1?=
 =?utf-8?B?QzRleHprUGNsdmRkaERQVW5NczNwT1U4ZnJJUnpIb0xYVXA1VStOWXBHQ3BF?=
 =?utf-8?B?Qmt0WEVaVTRmVjRmazhjaEJmNENRQi9zbXdlei9jakcyOEw2cnhCZGFlRDNy?=
 =?utf-8?B?Nk02YXNrSTlHRmppYnlxZHlrR0dsdlFPamVtYlh2bTAwNGQ0a0tScWVmR2N2?=
 =?utf-8?B?R1p2Qnp3Q3ZEc0tQaGkrQm9DUEJlUGZXRFZvcG1VWXpzZWZ6ME5vTHRQbDA2?=
 =?utf-8?B?SDB4M21RajIybTQrM1dwL1hueXcybW00MTBWeHpPZWozSHU0aTJ3bEJJcXly?=
 =?utf-8?B?c1BvS2o0RG9KU2RES0RiZkdhbG5lU3RBQkdKUkJMNFFkUWtOQlFXa2Q1SjVO?=
 =?utf-8?B?eGdNWXBnNDVITGFnNy9INWdpR2M1MDhRSGVtenB3RWl1S3BEVkoxdmVOaUJh?=
 =?utf-8?B?NGI2dEtNQTdkVTh2RVdlS1J0aTkySGxVQ1BsY3Q1YUJsVE13SGFrVHBST3dk?=
 =?utf-8?B?LzVqV0toVStLditYd1QrdXVHdzNUeXV1Nm5vTlhYV2k2TDBLR3gzaEtpWmZT?=
 =?utf-8?B?WW1qbkMwMkJTZS96ZmFxRGtVUmhtS25jVkxSQmhBaHY4S2VHVEN1V1NNLzZR?=
 =?utf-8?B?Wm5ubVVnU3RreG1QVVpWT3VsQThoTVN1OEZaeGUrV0ZjNHczekY5T2xkR0lM?=
 =?utf-8?B?WDJOVjZDNUNZaWxEbkkzV21kWWh1elFNR2dWa2tDckcwV0MwR2VtWkRxMGpT?=
 =?utf-8?B?dUZNVjZXajRQVEpVbGFQSW1MaHpKdFFyL2RpbmtWLzA4aVRhZHJLQnZHYmFY?=
 =?utf-8?B?L2dQenQ5MjBNL3ExM0Q1aTlDeE8zMFJWYnJKTzZKLzJ4RzVtbFdxYTBRcUgy?=
 =?utf-8?B?OWd6WGNZYmNXRG9XbHdTcU5oa25FaEtydnpOZ0JQTHNnbmZJR1dWS1dZTSsw?=
 =?utf-8?B?ME0rQzd2MHo4Z1FQTlBCU01MZWRKSmFTbWZSZmFFVFZYNGhNZGpoWFNWOE9T?=
 =?utf-8?B?eTlKVEFuM2dEMWpWZGdxY2dKalRPdzRxVTFFcHdHM0ZpaU1iV25GVysvSjBp?=
 =?utf-8?B?bkZucjg5dEVXenUrZHowWXJMQ1p0cUFtdDFmVzV1bEM4UU1RNFpOdmxCOVM3?=
 =?utf-8?B?K1hHUzZvMTJpVHptUitONWgvdklkZktudTlKZVJvd2Vud3paRzhHcjNFMndy?=
 =?utf-8?B?dFRRbFlKZ1g0aFZlT1NUSElUQStYNXpMb3VjZ3F4RFR0bW5lRTRmTHdqeWFw?=
 =?utf-8?B?YzYzbmZVRTl4cTF5N3M5dSttNjhDNmxwakR0c1c5NTVIMU1jaVZTcTZxdC9Z?=
 =?utf-8?B?ZFEyVHdxVThFRHJTV1IrOWR2SElPTnpEWElTZFpKWTNHNmxtNmVGYkZvOGQ4?=
 =?utf-8?B?QVFtUFJQTU1tc3liSGpOaFdUQm5QRkRTNzQ4UkFxWTBhYnpoRHJ0TkV5Q1NO?=
 =?utf-8?B?Um83SW5UODY2VWk5Q3ZWTnA0UlMvUFM2RlBHcGswU2JSTitWZTZYNTRuTFp3?=
 =?utf-8?B?dDRVbGtvU3RodVY4ZUdMaVk2MDR6Q1I0dm0zRnQ1ZGd3M1ZhZENiNGE2SVFQ?=
 =?utf-8?B?VVltczlNcUd0YVVmRCtFQW9lODZYTit2NUVSSEtmZmZITUQ5Qk12L2pjalNI?=
 =?utf-8?B?UzhyUjFDSkJzM3hQR3NKdVIxV0ZpcGFHSFZGSE9wS2dPVm1nMVQ4c1FvMzNm?=
 =?utf-8?Q?sLUkGM5Hpa98x9So+POtaQcRhO4eNc7qYAQjm4i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661e1df6-3f60-49d9-974c-08d8cd6bc66b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 02:30:04.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4f7/8KYrefICQdZic4K7FEr4flUwS9lZrZtRkZfIBcuLSpdj20YPanVnjRwlq8c69PrTyeQQw4hMJBhW66Pdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/2021 10:37 PM, Jason Wang wrote:
>
> On 2021/2/9 下午2:12, Eli Cohen wrote:
>> On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
>>> On 2021/2/8 下午6:04, Eli Cohen wrote:
>>>> On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
>>>>> On 2021/2/8 下午2:37, Eli Cohen wrote:
>>>>>> On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/6 上午7:07, Si-Wei Liu wrote:
>>>>>>>> On 2/3/2021 11:36 PM, Eli Cohen wrote:
>>>>>>>>> When a change of memory map occurs, the hardware resources are 
>>>>>>>>> destroyed
>>>>>>>>> and then re-created again with the new memory map. In such 
>>>>>>>>> case, we need
>>>>>>>>> to restore the hardware available and used indices. The driver 
>>>>>>>>> failed to
>>>>>>>>> restore the used index which is added here.
>>>>>>>>>
>>>>>>>>> Also, since the driver also fails to reset the available and used
>>>>>>>>> indices upon device reset, fix this here to avoid regression 
>>>>>>>>> caused by
>>>>>>>>> the fact that used index may not be zero upon device reset.
>>>>>>>>>
>>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported 
>>>>>>>>> mlx5
>>>>>>>>> devices")
>>>>>>>>> Signed-off-by: Eli Cohen<elic@nvidia.com>
>>>>>>>>> ---
>>>>>>>>> v0 -> v1:
>>>>>>>>> Clear indices upon device reset
>>>>>>>>>
>>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>>>>>>>>>      1 file changed, 18 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>> index 88dde3455bfd..b5fe6d2ad22f 100644
>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>>>>>>>>          u64 device_addr;
>>>>>>>>>          u64 driver_addr;
>>>>>>>>>          u16 avail_index;
>>>>>>>>> +    u16 used_index;
>>>>>>>>>          bool ready;
>>>>>>>>>          struct vdpa_callback cb;
>>>>>>>>>          bool restore;
>>>>>>>>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>>>>>>>>          u32 virtq_id;
>>>>>>>>>          struct mlx5_vdpa_net *ndev;
>>>>>>>>>          u16 avail_idx;
>>>>>>>>> +    u16 used_idx;
>>>>>>>>>          int fw_state;
>>>>>>>>>            /* keep last in the struct */
>>>>>>>>> @@ -804,6 +806,7 @@ static int create_virtqueue(struct 
>>>>>>>>> mlx5_vdpa_net
>>>>>>>>> *ndev, struct mlx5_vdpa_virtque
>>>>>>>>>            obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in,
>>>>>>>>> obj_context);
>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context, 
>>>>>>>>> hw_available_index,
>>>>>>>>> mvq->avail_idx);
>>>>>>>>> +    MLX5_SET(virtio_net_q_object, obj_context, hw_used_index,
>>>>>>>>> mvq->used_idx);
>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context,
>>>>>>>>> queue_feature_bit_mask_12_3,
>>>>>>>>> get_features_12_3(ndev->mvdev.actual_features));
>>>>>>>>>          vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context,
>>>>>>>>> virtio_q_context);
>>>>>>>>> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net
>>>>>>>>> *ndev, struct mlx5_vdpa_virtqueue *m
>>>>>>>>>      struct mlx5_virtq_attr {
>>>>>>>>>          u8 state;
>>>>>>>>>          u16 available_index;
>>>>>>>>> +    u16 used_index;
>>>>>>>>>      };
>>>>>>>>>        static int query_virtqueue(struct mlx5_vdpa_net *ndev, 
>>>>>>>>> struct
>>>>>>>>> mlx5_vdpa_virtqueue *mvq,
>>>>>>>>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>>>>>>>>>          memset(attr, 0, sizeof(*attr));
>>>>>>>>>          attr->state = MLX5_GET(virtio_net_q_object, 
>>>>>>>>> obj_context, state);
>>>>>>>>>          attr->available_index = MLX5_GET(virtio_net_q_object,
>>>>>>>>> obj_context, hw_available_index);
>>>>>>>>> +    attr->used_index = MLX5_GET(virtio_net_q_object, 
>>>>>>>>> obj_context,
>>>>>>>>> hw_used_index);
>>>>>>>>>          kfree(out);
>>>>>>>>>          return 0;
>>>>>>>>>      @@ -1535,6 +1540,16 @@ static void 
>>>>>>>>> teardown_virtqueues(struct
>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>          }
>>>>>>>>>      }
>>>>>>>>>      +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>>>> +{
>>>>>>>>> +    int i;
>>>>>>>>> +
>>>>>>>>> +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>>>>>>>>> +        ndev->vqs[i].avail_idx = 0;
>>>>>>>>> +        ndev->vqs[i].used_idx = 0;
>>>>>>>>> +    }
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>>      /* TODO: cross-endian support */
>>>>>>>>>      static inline bool mlx5_vdpa_is_little_endian(struct 
>>>>>>>>> mlx5_vdpa_dev
>>>>>>>>> *mvdev)
>>>>>>>>>      {
>>>>>>>>> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>>>>>>>>              return err;
>>>>>>>>>            ri->avail_index = attr.available_index;
>>>>>>>>> +    ri->used_index = attr.used_index;
>>>>>>>>>          ri->ready = mvq->ready;
>>>>>>>>>          ri->num_ent = mvq->num_ent;
>>>>>>>>>          ri->desc_addr = mvq->desc_addr;
>>>>>>>>> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct
>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>                  continue;
>>>>>>>>>                mvq->avail_idx = ri->avail_index;
>>>>>>>>> +        mvq->used_idx = ri->used_index;
>>>>>>>>>              mvq->ready = ri->ready;
>>>>>>>>>              mvq->num_ent = ri->num_ent;
>>>>>>>>>              mvq->desc_addr = ri->desc_addr;
>>>>>>>>> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct
>>>>>>>>> vdpa_device *vdev, u8 status)
>>>>>>>>>          if (!status) {
>>>>>>>>>              mlx5_vdpa_info(mvdev, "performing device reset\n");
>>>>>>>>>              teardown_driver(ndev);
>>>>>>>>> +        clear_virtqueues(ndev);
>>>>>>>> The clearing looks fine at the first glance, as it aligns with 
>>>>>>>> the other
>>>>>>>> state cleanups floating around at the same place. However, the 
>>>>>>>> thing is
>>>>>>>> get_vq_state() is supposed to be called right after to get 
>>>>>>>> sync'ed with
>>>>>>>> the latest internal avail_index from device while vq is 
>>>>>>>> stopped. The
>>>>>>>> index was saved in the driver software at vq suspension, but 
>>>>>>>> before the
>>>>>>>> virtq object is destroyed. We shouldn't clear the avail_index 
>>>>>>>> too early.
>>>>>>> Good point.
>>>>>>>
>>>>>>> There's a limitation on the virtio spec and vDPA framework that 
>>>>>>> we can not
>>>>>>> simply differ device suspending from device reset.
>>>>>>>
>>>>>> Are you talking about live migration where you reset the device but
>>>>>> still want to know how far it progressed in order to continue 
>>>>>> from the
>>>>>> same place in the new VM?
>>>>> Yes. So if we want to support live migration at we need:
>>>>>
>>>>> in src node:
>>>>> 1) suspend the device
>>>>> 2) get last_avail_idx via get_vq_state()
>>>>>
>>>>> in the dst node:
>>>>> 3) set last_avail_idx via set_vq_state()
>>>>> 4) resume the device
>>>>>
>>>>> So you can see, step 2 requires the device/driver not to forget the
>>>>> last_avail_idx.
>>>>>
>>>> Just to be sure, what really matters here is the used index. 
>>>> Becuase the
>>>> vriqtueue itself is copied from the src VM to the dest VM. The 
>>>> available
>>>> index is alreay there and we know the hardware reads it from there.
>>>
>>> So for "last_avail_idx" I meant the hardware internal avail index. 
>>> It's not
>>> stored in the virtqueue so we must migrate it from src to dest and 
>>> set them
>>> through set_vq_state(). Then in the destination, the virtqueue can be
>>> restarted from that index.
>>>
>> Consider this case: driver posted buffers till avail index becomes the
>> value 50. Hardware is executing but made it till 20 when virtqueue was
>> suspended due to live migration - this is indicated by hardware used
>> index equal 20.
>
>
> So in this case the used index in the virtqueue should be 20? 
> Otherwise we need not sync used index itself but all the used entries 
> that is not committed to the used ring.

In other word, for mlx5 vdpa there's no such internal last_avail_idx 
stuff maintained by the hardware, right? And the used_idx in the 
virtqueue is always in sync with the hardware used_index, and hardware 
is supposed to commit pending used buffers to the ring while bumping up 
the hardware used_index (and also committed to memory) altogether prior 
to suspension, is my understanding correct here? Double checking if this 
is the expected semantics of what 
modify_virtqueue(MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND) should achieve.

If the above is true, then it looks to me for mlx5 vdpa we should really 
return h/w used_idx rather than the last_avail_idx through 
get_vq_state(), in order to reconstruct the virt queue state post live 
migration. For the set_map case, the internal last_avail_idx really 
doesn't matter, although both indices are saved and restored 
transparently as-is.

-Siwei

>
>
>> Now the vritqueue is copied to the new VM and the
>> hardware now has to continue execution from index 20. We need to tell
>> the hardware via configuring the last used_index.
>
>
> If the hardware can not sync the index from the virtqueue, the driver 
> can do the synchronization by make the last_used_idx equals to used 
> index in the virtqueue.
>
> Thanks
>
>
>>   So why don't we
>> restore the used index?
>>
>>>> So it puzzles me why is set_vq_state() we do not communicate the saved
>>>> used index.
>>>
>>> We don't do that since:
>>>
>>> 1) if the hardware can sync its internal used index from the virtqueue
>>> during device, then we don't need it
>>> 2) if the hardware can not sync its internal used index, the driver 
>>> (e.g as
>>> you did here) can do that.
>>>
>>> But there's no way for the hardware to deduce the internal avail 
>>> index from
>>> the virtqueue, that's why avail index is sycned.
>>>
>>> Thanks
>>>
>>>
>

