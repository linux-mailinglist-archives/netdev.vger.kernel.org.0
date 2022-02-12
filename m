Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAAA4B3210
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245212AbiBLAhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:37:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbiBLAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:37:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC76FD7F
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:37:20 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BNbvoc019126;
        Sat, 12 Feb 2022 00:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hngClPP8P+HywAedVBwENLPWRpy8cLmZyum3AjE8ZHw=;
 b=vY5QO4cbWD4ggvZQk7zwtDuCB+aZ3pJIV3dj7Hq4YOfz5Ea8U2onJljb0WiQcRT7gcvc
 zN3QUeucAUhftcPu3csZsrq4AkKJbfp/PyQgiFbvt/m0ixmd5x6/wdh3kwek/Am8rpHE
 7Ha2QEUi8NmES//aT2yyheu/+P/OYxD+kC78Cpn9aazaFiUUkmtbXyTJ9pFF6/RqgdvL
 7jetWjeR44I92nx91fbREpxCqaqoUUPcz9I9U4HoV4LLHc98/XMvdx+jnvD/xUR1rfE2
 6y8izIAFrUzX7fsXySvntPbehJfGS6c9E/dF7Zidb+uAZuYPWalCS+pnozK2zqlderNi MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5gt4aetg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:37:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21C0G1f7085959;
        Sat, 12 Feb 2022 00:37:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 3e1h2d82fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mkbz2E62rqLaMpMWobcO1AdBjsv4hAfW0uJeE/7sf80kTGwvsPtjlR0hfoW8NGs2DOabb83oAOlb53T2hX0fRStWWTJJyA2+r1Wrp+2BQE0I0MFhF5J1D2owXByEy/msQ0sSphjP6lsV2p1clIaOCP/L58Gbpl2o+morJo49NuSiZnD33fsZyyNbCodp0nC4PxHoc7yKuyq1BmXr4aom28ryLlcNmpdvjHWl3gAn9LELCsCrc25pqXiQvwG9fs4zq1AljcRGgg5iOl5b2L7HxPlLtVG5UzRISvOoSt10Gn21XbzcAq6tCRJ59+1I119bpvCp9/8OMakuQXkGL5WVyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hngClPP8P+HywAedVBwENLPWRpy8cLmZyum3AjE8ZHw=;
 b=ay7wPOTVUeKeRmsu+ZjISZhlQ2E+fBcpuQvBDLHdQkVFiCFWbD/qd9hwQEleYgreVVX+sDRY1SfiUXEGCr6l65KiktO+4IV7j2jTG9X8tU+qjsSYXGx4WX/A1aOPDlA2JRqD/+LFSnwZFQr/xmqJBIz+NFSjeDawDAwwUwyLW3xYqUqhTXh0F/H9ILXAWYU2wLo/iwxhrFhX1SaKVx0KZAnJ0tn+5Qs7VuXqGKnEJYcVkpNMsRa2wFxMQeA4gIC0wIkJFd9end8BOsYZGDMDExApGE1F5Wmeik+bUfWRjixRV/VUHIThPCjr1lLz2E6AlRJINuftqVeJVe/iyom3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hngClPP8P+HywAedVBwENLPWRpy8cLmZyum3AjE8ZHw=;
 b=ozJdv7u3nWdVaMwrzU5IbaqEvG8V91E6soZrxoxwDoCA9L8x0tr1y5yzcAPT4PwpaGEURyGKqS9ug0uwBK7ZlsA/htI3lt1XhaYMM5Mndg/U6kyUQlFdVhGyq9uDGuILCqW6F3+24K03mSrcFljsL5RIUYhBooD8X1mSKmZYiHc=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4068.namprd10.prod.outlook.com (2603:10b6:a03:1b2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sat, 12 Feb
 2022 00:37:07 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 00:37:07 +0000
Message-ID: <321ab6dd-e866-635d-b9b0-03abeb5eb7d6@oracle.com>
Date:   Fri, 11 Feb 2022 16:37:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-4-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220210133115.115967-4-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43e761b-bf1f-40d9-fcfd-08d9edbfcc23
X-MS-TrafficTypeDiagnostic: BY5PR10MB4068:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB40689D2B6737FB84B95C1FBEB1319@BY5PR10MB4068.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56bzAhbHPO5WT2Mdp/rfiz9l25VCAati2IV3YtoVZtJO538NYlMpCgg3dedAGqNq/VcSG/MiGzkCFLajJi6LCYRCMMCVq2knyGSufB5at48mG8XyDnXDZoIg6q4k94WXMMoSb/1gZHOSrVg5tmhXBA7D9XDg5LnJQbhVz2YBWbiTiqnqjY45guU0pR7PX+4DaL7fk1aN50S0xJVmbbemRlgNnlTxBz4bPlRwJ16miSz6N6H+ETfg+1MNlKHYmtW9QOGpjZGRRuQiphKRTb+f2E2rANKmBFWDUT61i5Qdngqhmf99RWe/MDU64EpPuB0a++yYd7OnUxm7OueR4rkbD0RnMFJGD+5DglulOsqbDN/OrsjwYEKv1EwJDdilMhuHS2haVK9DQKKSwxut/4Fvc0qpImD6MHG4n/lJ+1wIu99ke6GYgPi35qOr/sxRpB4pxk2H1o4Ec+rE4Q1ivTBsWQbOtAdg3v/jF+E9a13+e5iMayGXauc4zWvhR8JpIAh/WfWNrqGs+5GrXlc1OaYe7lv5OYViCZPzo2E8A2zn8fesJvrQsh2bhelXtzoO8ZzKcdLc47y4DtZlSqvKkuRfiu8dUrvtLqDr7z5vjh35MAN73ye5o8dR78npDjPy9IIjS07b0iL/Wc0FjF5hu+73y2cf7c1s+BYDT9VrzIfDom8ni/oNh6TyZXxBinPkSc2KiEB6ABZWbTLtu8uInbpxRlGxwByb+qPAsuiZuPwVWaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6666004)(38100700002)(86362001)(2616005)(53546011)(6506007)(36916002)(66946007)(31686004)(508600001)(186003)(36756003)(8936002)(26005)(83380400001)(6486002)(2906002)(66476007)(66556008)(4326008)(8676002)(31696002)(316002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzhZOHM4MmZ4TGxkT0dZeCtsR0lOd3RUb2JWYjhpSVVtN0U5UDk2aEo4MWgz?=
 =?utf-8?B?OFNGVHhTQlQ5L2tiNWd2UTdrQUgvdVptMnJvNUVtaUFvcmdiWnExRWQ4VWw5?=
 =?utf-8?B?WFU1TDNzanBPRnZ1QmZyN3g5VjZTQVFHWjQ4bGRZRXVEV1h2azFwRVd6Y3JS?=
 =?utf-8?B?Vy9rRmFnaUlkTVNMZ2ZXOWx6QTFyMjV4TW5WMU96TzFFWHZRc2tEM1k1S0px?=
 =?utf-8?B?QUtMbTJtZFE5UFRWQnk0N1poWFp4L2xkaENVRzJlcHdmcmQyVzI5ZmVXWk1s?=
 =?utf-8?B?RXNDOXdmSy9RUmFnSC8zaWNlZmUxNDc5UUZ2SHVIamxKOE1BRnlmUUk2WHVx?=
 =?utf-8?B?eWtyTTJqWnlMTTlqeFVzZ1VBK0R0bDBWN0g4alhCL3hvTjdYcnRqSUVUcjd3?=
 =?utf-8?B?OCt0cVBsbTBlYWYvNStjK1g3ZVBTaDlsWklJSTBoVDJvUGRRUVBmY3hXRUtZ?=
 =?utf-8?B?VnVtZHBhZEJVVnZGSzhDelNUb2FRd0Z0UmlVa0pxN0RQVVdEZnhJalVlMTJh?=
 =?utf-8?B?d1NEWXplTmdWcjdMaDZlUDdVdjRIbUwzR3FWelpZMlg0bzlIN1ZuUHo1dWdY?=
 =?utf-8?B?L0htTUhzaEl3UzVuZkxkOWR4RWFTQmpIWlg1WTR3VjA3bXp3RkxETXFmKzQr?=
 =?utf-8?B?bjhueFRRWUlWME1VODN6YVVPRmFYVkY5bHp0dDN4MHJPQ3laaDhRbzFBUmFT?=
 =?utf-8?B?MHcyL2dTZCs1dm9RZGd6WW5iYUdNMDUvTC9TTGhLamhvU1NJTWdJQ0lzQmxI?=
 =?utf-8?B?L0FnV1V5ckRPajNORmdxSE5yRnFWU3lmVG5DQlNaeEpMQ1gvMzNDVzFuT1V6?=
 =?utf-8?B?UnN6UFc4eTZLKzM3ZGUxUytLRldyU2FycGVraHlhU3BUbHFXNjRiYjV3S1U4?=
 =?utf-8?B?Q2l4WTgxTElmc2YzekZuYXduWlljMWVhSE5LK3JsbHBWamorQWpZVHNTOHN4?=
 =?utf-8?B?SkJYbm55eW5CTEFLZjhpMG9xNVhZMnJoN0dDRXBxTFl5Und0SEZiY1hMR1Qy?=
 =?utf-8?B?NFc2ZGc5TEJZQld4Vmx3YkI3a01ZYzBEMjVRcnZ0WnhzNGwzTGhITXRmMlJ2?=
 =?utf-8?B?R0tLUlNyZ254T2VNYlhqTks2UThweXpjaldLUmF5bmt5UmVGV2lwUG1YWDJI?=
 =?utf-8?B?Yi9NZ1RneXlveUF2K0lGU0hWYjZWZExMOUN2SEJZcHFJVnh1VnZQYUtvQ09p?=
 =?utf-8?B?UHZIZFhwcXNqcW54bDdDSHNyWWJxL25wY0NiTTFUNHFnMTBJQVpsSG11UzVR?=
 =?utf-8?B?YWtVcG94bDRvNDFKZGtXN2s3Ris0SW56QjhuZDYvdThyYjJJeU1uK3ZydGVn?=
 =?utf-8?B?bzQ2ODB4RmtqMUtXZWUyb2g2ejQ0aDFFVFhCd1Z1OS9vajZ5STh4OEZRaGk0?=
 =?utf-8?B?TmxqL3VCS0hEK21TcWRaYWVJSUhTVTJmTFBCc200WEJoMVBpYWp3ZUplOVpL?=
 =?utf-8?B?ZUlmWFZ5Nm04TUgxZUZPUHduMER1bTRzVWtTeXV2ZGFpQXRrVTR5NEM0YVJJ?=
 =?utf-8?B?Y0wrS0VCMnZMZjVkZGs2bEM2bGN6OGpjZkJHZDhCWnBwVHI5M1lxWVVCQzEv?=
 =?utf-8?B?dHh6R3pRMytJaHMyREl5MTZNaHFJdmJ4d0pxOUNpUDFidDRsS0dTdmtPNHgr?=
 =?utf-8?B?S2xWLzlkZnpvMWY1SzdvbHZkRFAyL1RGS2RFdGp0dnlDVXV2U3dHUHFyRWhH?=
 =?utf-8?B?WmlzYnlyWjUwWnJ6OGJtbmc4aGppRXVXZFM3ay9FSEVBdHVpbk5NQzJNbmtr?=
 =?utf-8?B?L0hwcE9ZdWlpYWw2Ry9xUVVpZDJUbHJKMUJxbk1nazNUeUJQY25BSTJBOThJ?=
 =?utf-8?B?cDNyODg1aGdOYXpIZ0VwRWVkZmwrSUVoVmJNUUhPanBZMzZEaXUwdXl1eUIx?=
 =?utf-8?B?c2ZiZTRDRjM3VWxQanRXalNBZWRzVkgwZlRNRHM3ZlZtL3FIdlp6R3dhUVZ5?=
 =?utf-8?B?dU5xajFiVzY1YjJZZnNaemxyemNHeUdzdlBCYVdhS09IaDJZN1JOakZGbkxB?=
 =?utf-8?B?TFVwNmdVR3J0akxCRHg3MDBQUyt0dXJJWmQrVlBpckV3d3o2RnJUQVVMQjQ1?=
 =?utf-8?B?MFpobkhuZWEwZHlqZnhTVkJacSt5eXREN3BCYTI5cEcyZVYwckxETW4rYlE3?=
 =?utf-8?B?UEVSR2lvMGd2aERFUnhxWG14aE5Jckw0SktMWHlRNVNPSGQyYWhXR040Z0tr?=
 =?utf-8?Q?mom63jOGgDePbbRl1M64Es0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43e761b-bf1f-40d9-fcfd-08d9edbfcc23
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 00:37:07.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /G0UY72CjTKv9sUPOOpq/UW4FqygHc6HeGZF5S5TBMBBhhAYntb9qkBQDmd2MGNwkdfVadkbm35hPWfmv6/yJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4068
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202120000
X-Proofpoint-GUID: 8OSSqWDb4AgquS_ZJb1veZJMpf1Ag5lt
X-Proofpoint-ORIG-GUID: 8OSSqWDb4AgquS_ZJb1veZJMpf1Ag5lt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2022 5:31 AM, Eli Cohen wrote:
> Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
> pairs to configure for a vdpa device when adding a device.
>
> Examples:
> 1. Create a device with 3 virtqueue pairs:
> $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3
>
> 2. Read the configuration of a vdpa device
> $ vdpa dev config show vdpa-a
>    vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
>            mtu 1500
>    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
>                        CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/include/uapi/linux/vdpa.h |  1 +
>   vdpa/vdpa.c                    | 25 ++++++++++++++++++++++++-
>   2 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 748c350450b2..a3ebf4d4d9b8 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -41,6 +41,7 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>   
>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 7deab710913d..99ee828630cc 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -24,6 +24,7 @@
>   #define VDPA_OPT_VDEV_HANDLE		BIT(3)
>   #define VDPA_OPT_VDEV_MAC		BIT(4)
>   #define VDPA_OPT_VDEV_MTU		BIT(5)
> +#define VDPA_OPT_MAX_VQP		BIT(6)
>   
>   struct vdpa_opts {
>   	uint64_t present; /* flags of present items */
> @@ -33,6 +34,7 @@ struct vdpa_opts {
>   	unsigned int device_id;
>   	char mac[ETH_ALEN];
>   	uint16_t mtu;
> +	uint16_t max_vqp;
>   };
>   
>   struct vdpa {
> @@ -80,6 +82,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -221,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>   			     sizeof(opts->mac), opts->mac);
>   	if (opts->present & VDPA_OPT_VDEV_MTU)
>   		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> +	if (opts->present & VDPA_OPT_MAX_VQP)
> +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>   }
>   
>   static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -289,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>   
>   			NEXT_ARG_FWD();
>   			o_found |= VDPA_OPT_VDEV_MTU;
> +		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_MAX_VQP;
It'd be nice to update cmd_dev_help() to include the max_vqp option as well.

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>

>   		} else {
>   			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>   			return -EINVAL;
> @@ -513,6 +526,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   		pr_out_array_end(vdpa);
>   	}
>   
> +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> +		uint16_t num_vqs;
> +
> +		if (!vdpa->json_output)
> +			printf("\n");
> +		num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> +		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> +	}
> +
>   	pr_out_handle_end(vdpa);
>   }
>   
> @@ -662,7 +684,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>   					  NLM_F_REQUEST | NLM_F_ACK);
>   	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>   				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> -				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> +				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> +				  VDPA_OPT_MAX_VQP);
>   	if (err)
>   		return err;
>   

