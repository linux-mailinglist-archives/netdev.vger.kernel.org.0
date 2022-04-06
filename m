Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1233E4F6D87
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiDFV4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiDFVz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:55:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCF89FFB;
        Wed,  6 Apr 2022 14:52:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236JV8I4014716;
        Wed, 6 Apr 2022 21:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kZwNZLOMHJe5W+HU/tVqVRcsa0vM1s1+qeJTBJwDtww=;
 b=YsWrgzPrIEuesySHBcnqerKAt0VRaHN7MW2Pkswz35pgigK92nJwb9pzPxWyo+BVp4if
 +lJNH2yFjb6JknGOdE2g1aBlFRkyhPmHOesFVWK8yu0vs4Tf1wekq85cXoKLpJD/6FpC
 fxRd9HdpAfVuGFuUnUmcB011w5RrXr688egXZh+qNIFbTyd2tiO6LShdyrjh53n3vInV
 08Up6TySXWvAVxY2CXLKX0RUpJBRei6hZjdU4Lw5zn7CqSQbK9PjTjRymqScqp0sjBjn
 FPShRWAe4Mpj9GNBvQA8wfY2kh2F0czyH3i4EBvWtu7wtKCMweHmsKZmakkrcYo5SIKU xA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9t1h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 21:52:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236Ll4c5005463;
        Wed, 6 Apr 2022 21:52:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974ddbvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 21:52:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jt+e3vWcbI/sdx86sIxecqWiOftl4/BKPuKpgBZ1v2DOu0bZxQQ7cGIDjso8AXDfOnCzDmck0KIrWMXaZQnNxcZ+hsT/Y93ld0vqgbESPtYZyJ8C2byZh5oe3GCdUhukRHMR5RzGL78jfp7Z/ZXrTB80kLeLfr4lEBMLwWxMRJ7MqEwvDwuRpr3MrcOOVAFO/HQ4NSrnV6lNjyWiuxg7+1xMutPPiKmtuuWY+kgOs7aT5wMge3whFRCLqWTk0gSBuckk6+0K4Y1VCw8RZxkDe3rsCKF94L8OX2AoZQZUR6Zsog+y2OmZzt0bEESR31oxSrBd2VTqP/psRYIGFoo3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZwNZLOMHJe5W+HU/tVqVRcsa0vM1s1+qeJTBJwDtww=;
 b=oJc8sI8wB9+9Fw94t0siPVPrceo7NMqKUcjp64+nNPM5mDyCZK3v5Tw3Ceigy4ialMQPr9F0vbjMZYm29zdru8t98+XIJlJ4k5Tz2mgC17+o6dLURxSBtVGeVkekW6S0pfQ8TNRsv9NfOGjPwNfpB54KILm6hF7GHemqjFzkraU9U3lz7JqtkTh3RV4kQXLqUNsWBWLHwI2KKZg76IYaPtw7Bzf+tgJy/XAHX/Eyx7uH+/TWVUHRR9VKFZoLyixa6t6lWBnu7gXHWD4NhUZRrIvLOLoEaP/Z1cOz5HDEaChqvuc/SdDS3J1Y7sBpRhmCQkz4B92j83yZAPS8GhNmiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZwNZLOMHJe5W+HU/tVqVRcsa0vM1s1+qeJTBJwDtww=;
 b=BxMqXmQM9AQ28ipTFm8UHzOdsN2fnO0RX38KoXPkYPzDrbUjO5AAeexpaIiM5pjq5T6X1VdHj+EfT8ycvCnlJU+cA7KiqPtpyCZtkisD1VAuTDQ0TVRNRJnDcw0DpKaBJVBsxe3uXQgcm1429XeWnGHlF1a8s0IMtAiSxmAsCbE=
Received: from DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35)
 by DM5PR1001MB2266.namprd10.prod.outlook.com (2603:10b6:4:2d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 21:51:56 +0000
Received: from DM5PR1001MB2409.namprd10.prod.outlook.com
 ([fe80::24c9:6393:3e2b:2849]) by DM5PR1001MB2409.namprd10.prod.outlook.com
 ([fe80::24c9:6393:3e2b:2849%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 21:51:56 +0000
Message-ID: <d641f93c-6369-b97d-3aaa-38ee026c2bb2@oracle.com>
Date:   Wed, 6 Apr 2022 14:52:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/1] net/rds: Use "unpin_user_page" as "pin_user_pages"
 counterpart
Content-Language: en-US
To:     Gerd Rausch <gerd.rausch@oracle.com>, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
From:   Sharath Srinivasan <sharath.srinivasan@oracle.com>
In-Reply-To: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:806:a7::16) To DM5PR1001MB2409.namprd10.prod.outlook.com
 (2603:10b6:4:33::35)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62b0d8a6-9eae-4a65-83c0-08da1817aaff
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2266:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2266F18F4653FBAE5F6AFEF1FCE79@DM5PR1001MB2266.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bA9ttKC7sTMkbB5PPHbzGqf4nCorqlPF0WDlf5UezUqmqOGXTVTrEj+31zp2AcGJuY0rrugjw9r5VDZ5Knu6h5bxvMmDIX1pCiVuIOMeD7CqjWXp151yCJoSuYblz/YHtHsCtMmIgy5COfxk2foTBmf9DAHaXUENpkc0QjqKCefnHiBNb0lmwsYfR8i0dRt/JpDI+n8KzJJQFVL3mbtNOY+PvnhBUgJC+STVVs7Z4p3Oxufs0wb3r9XlLu3ZQOGYJOvcwdG0dCFLJSMZCB2gRVEwjZoZ+Xhh7CiyMHIHQhqbLTD+tUyMTeDW66zGFlekQALXqQRDAb6RsX2N7KYPAtbn7kqffebw0YiFIcS03T+0O9bw+NsKKV3jO+4V51dDSvbuH8Yh6PDsIOpNZP8ikQL5QrI3RqGocNNH2CY1MXw+zCGi0NnO2iCP8H726j4DgGhHp3C7Nv8ZLsfk326ciQQNpTdNkPK8j17GNXU57mgZiHjY8c/0CtXQXCmNH1oXW9BjSDmmE77l1WgIG0eFnJojndn3MEg4n/q6C9Ar8MAq8gV54WNGuRxmMipiP0hOXvXOT9vryKx5t4T5kIylbcxNJjOI1CBe5DKLWJe8DhDK8SK6RB84nutglZhGgB1fvJMOCI9PpMeG7FWDkf56xDjj1jumJ2glRPdrZKpl3VXgIiN+sUhEYdpQT7befo5SpEUU9STPUbQeC4p5v4ubwhlPrVjFChV4szry8VTHWqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4744005)(31696002)(86362001)(8936002)(6512007)(6506007)(6666004)(508600001)(36756003)(5660300002)(52116002)(2616005)(186003)(44832011)(66476007)(66556008)(8676002)(66946007)(53546011)(316002)(6486002)(31686004)(2906002)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWhIMjNWRkRyY0V2TWtvRTQwdlcrNmZwR0dBcy80cjFnMjFXbUc2a1duNHZh?=
 =?utf-8?B?NUJ6bGo3TlJCT21BRDB1SjhDRmQ4Yy9LdWhoVDBIR21adkRrODJTeGdtNWpV?=
 =?utf-8?B?eEFTL0NqYnRTRENuK01FeWJkZDg0cHZ1R0ExaGZTeDhkNXRPS3d4V3Y0Mi9H?=
 =?utf-8?B?Qm4vRFNQbkJTZFJUR3Fycnk5OEo3NWdqTG5tNjQ3VVlIODV1aGtzVmdsWSsv?=
 =?utf-8?B?R1kzRzh6OTFDVlNOcjNOMXNQd1RXQ3J3UEdDWWxENHFySGNGL1JlRlluM29E?=
 =?utf-8?B?U3drOEkwZHRObjEwYVUzVFJGU1VQSGdzUGxYZkF1bllxd3loYXRKUHI1aGxr?=
 =?utf-8?B?ZkhvWlZuT25PWUtXRXgyUVlLSTFGM0xPQm90NUxhcWFHZ1FLNzc5RjRKSW9k?=
 =?utf-8?B?SXZ6N2pZZkxQdTBQQzdKVm9GVURNendJV2dRSXQzaVhIL3hUVG9zazh1cytL?=
 =?utf-8?B?M0g4akhwSDh0czlVUkFOREY5RXFnVVEvVFdvV0dxSkhyRlB3dkhubi84TEVR?=
 =?utf-8?B?NWY5V29hRjNtNmljY1JCNDA2b09EVk9vMU1jNFF6bmUzNFFYZDBRa1BuODU5?=
 =?utf-8?B?M2tJSXRUcSt1MlUwY3RsSTA1NGZGRW5KMUlKQkIzQTYzY1dDME4zREZFU3BO?=
 =?utf-8?B?blFrY1lBeFJCNmNaMmpsOUhxQ1Fxa1FYWGU0OUplZGlxMU51bFJPWkxLaXhQ?=
 =?utf-8?B?dE5kQXdCaFgwZUlhcG5XcFFKWHhuVWN6eG9teFVGWldCanNuajJ6RVVadEli?=
 =?utf-8?B?YzhkK01OaXRwR0lPNzBHOTlITXFpc3JZSDJJaDNjUXBXblZLdmx3U0M0M091?=
 =?utf-8?B?S3FpdURONkgxUEVLRGZ1RmZFN0FHVjRjV0xlMVVVV1RKVktSQ2FhUTRLT25G?=
 =?utf-8?B?L2p6NHFFTFE5QSswNEsyV2pKV1FWVWlaQ3V6YXAxRVlMMXFLcUVrWVVTMWY2?=
 =?utf-8?B?TzZ4djhhaURTdmRGU2ZlejRLcDVwNkFCYktTaTVXMjRXQkF3VDFVZXgwbWZM?=
 =?utf-8?B?clgrcUdzZytCTEVveWFGVndNSlFiYng0T0p6RU0zN1JOaWRWQlNIN3Z0NU1N?=
 =?utf-8?B?TXZYNlR5TVlnMXlDL2d0TURid0lGZlNFVXh5aXJaNUR3RDBYR0ZLVW9mTXZn?=
 =?utf-8?B?U0tiZTc5TEEzT2hMTEtULyt1T29MV2FQWTNqQnkrejVlSEppV3dwL3ZBaW05?=
 =?utf-8?B?OGtqaGdwb2lkbHI0ZXZZMWVOQVZmRXlwa2FsTFNFZDVoaUtBcU95UzJWbzMx?=
 =?utf-8?B?MVdSTnI4SnV3UVFRN0djYnBXNUVKVEcyUDdoWlV2ak9FbVZ0NzNmRUNRYnhJ?=
 =?utf-8?B?TFJkVFlMUXFDNDkwdHB0eGhkajdheC9UYW4wRjhsY2R2aGxWTnIvY0EvNjhS?=
 =?utf-8?B?ZEV0THhXVXZINHFOOWdJK2RrSWpuNmsvQzh4NzdDSXVlenpTdnZQazF0b1c3?=
 =?utf-8?B?K2VyTi9WSVZKbXVjTXV1eTNsRytoc0FraWZhTEpja2MvemIvdE4wb0UwZnpz?=
 =?utf-8?B?ekc0MzRld2xJeDVIUmdqQ2taRStoSnM0bE1KbEZvY0VqeVR4ckZ2clpNNlJF?=
 =?utf-8?B?emluYUU5TE51YnZBTlhxbkREU09BZ21Zb2hEVXdFOWpwNnc1c01USSs3eTUw?=
 =?utf-8?B?NHlFOWxLemhtOGpXY1ljUmltWWNWRmZ0My9SZ2VZK09NVEJmZ1NiNDMvMEV4?=
 =?utf-8?B?eUh5Wlh5SE1TbmdSWWRRNFNyMkJDbmt2SHVUcHdtTGlmTzhZbjZhVmhBa1p5?=
 =?utf-8?B?TVp3Z2wrbnpvODU5QnJCT2dxckFoRi9FUUxHWWlEcHNFQ2M3dTcwVWsyTzMx?=
 =?utf-8?B?MVloY0VOeTRqakQ2Z2NDQWFPb0svTTlzZU1ZMXpmK3N5eUx5eGlJZ0RhU0p3?=
 =?utf-8?B?eHphei8raXI0Ulprb0lwRU02RU5rVkJiN3ZCLysvdElxL1k2b0FtN2UzWTdX?=
 =?utf-8?B?eEQvYTZUa0Y3NWxZc0FzY1hObDIxYWx1Sis5NS90N2xhTVZ0UUl1clpBYkVz?=
 =?utf-8?B?cDZmc0tLL3BxR3VLSmlIRGNmcGhsR011OFRWY1lBTHozUEtPUXZYcXBRYWVZ?=
 =?utf-8?B?Y2lra2s1Um52eWpKK1RWUFZzcnhBekJ5WTY5QW10L2FxaUJoRXZOT1kyWVJm?=
 =?utf-8?B?NnBDUS82VXo5N1d2YTkwMEl6UE1TV2UrNVI4eE02M1JzTmNRRkN5V0dackli?=
 =?utf-8?B?YmE3TEVOaytqVnRXYldWRlpmb0l1eGFrRjdYZVJoYzJPTXV5TS9ZSVp2WUZN?=
 =?utf-8?B?SlJwd3Vjazk4cHBVT0plSjVZOC9jbnUyeHpZZGhqQWlEcS93OHVzbW0vWlJ5?=
 =?utf-8?B?c0JGZ2d0L25iK2wxMTA2bnZhZWp5QWhWemJtdUVBNjJTR3prSzlMT2dzRWVp?=
 =?utf-8?Q?MfTnM314l2O0RGXosNWKKZyj/MI6aYoTgNHE+3HHrhq7Y?=
X-MS-Exchange-AntiSpam-MessageData-1: CDsBZXNxwbUgFA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b0d8a6-9eae-4a65-83c0-08da1817aaff
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 21:51:55.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7v1DO7bjgPcFPrqUGYqBtUQmxc/FUJvTZx4Pu+weQPwXXYV02Xghw61GitoApDwdmnesqTRKNOuonXPmcCz4qbBGqii5bMIN9dQnDidi3vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2266
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060107
X-Proofpoint-GUID: _KRWGYXiykIOvHfuMiIjSH6mCjzt7dCG
X-Proofpoint-ORIG-GUID: _KRWGYXiykIOvHfuMiIjSH6mCjzt7dCG
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/22 14:03, Gerd Rausch wrote:

> In cases where "pin_user_pages" was used to obtain longerm references,
> the pages must be released with "unpin_user_pages".
>
> Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Reviewed-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>

Regards,
Sharath
> ---
>   net/rds/ib_rdma.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 8f070ee7e742..9d86d6db98c4 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -256,8 +256,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
>   			/* FIXME we need a way to tell a r/w MR
>   			 * from a r/o MR */
>   			WARN_ON(!page->mapping && irqs_disabled());
> -			set_page_dirty(page);
> -			put_page(page);
> +			unpin_user_pages_dirty_lock(&page, 1, true);
>   		}
>   		kfree(ibmr->sg);
>   
>
