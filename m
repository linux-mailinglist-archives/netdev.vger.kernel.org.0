Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31657AD69
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiGTB5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiGTB5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:57:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8894E607;
        Tue, 19 Jul 2022 18:57:49 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K0KfZW017922;
        Wed, 20 Jul 2022 01:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/g2D2vBEKbJLQfmMLMmt1Z9jPK+gct/u6JJT0dPDn28=;
 b=m7GVkVG8+RH9Y/nxH5nS1UT5TB29CICacNeVT7dzvVsn6Vojp0aJnSlCNMi50Kx6Com5
 D9SQ6q7emGjlgLhJzcSJYRzT8rB5zZMaPbWtJE5foVWsJU20mg+igd/dz8ClTwC52wgh
 9UbjGujR6WtUrJAAxaKlm7prHSGYqNE/uHozT8o28hnIIUonVPxXQE/g5o3FFtwMoPjd
 QZ05+pFkLN112BWJ0P0+7DyN1wv+QyrC0tpw+zenn7sDTw9hSrY0H3bDpnV/rG7S2vk9
 Cj60Ywb3N8Kl1yz/agTPc0CCtB2/bl4P71S2lPn52N+jgTIjQFh934jU6qmZm+MgJcGX eQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx1075f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 01:57:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26K1I3Xc016401;
        Wed, 20 Jul 2022 01:57:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1en2rpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 01:57:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vvn8oNkOoWHz4ZEql572I5mTsvLZ740eD+I4Y/80NZdhsdyWGMmeRjjxGF/Z9+KkfKPpqNBIcny0Tiv4C1IHRRSgrzpYOJjTVIRT6EfA3t64UwbmUV0uVTOB1AEVNfMdEPPNfg9UyEBCqMjoceXEkCTQnAld5sn3wydCgZ6Rn9lEo0pdv9z7KSKvUIXbtQ5fxndx5p4ZhA2VZszFN/Xheu6Hc24s0Z6Vv1h4TaAj0ipIBpR9P+gNWkJU2ilmS2c40sTVhWMx5reCd27+n1xYd0xZuzE4HCFcZ1d9HZiqXz76VGJzX7x54KIOJJeKQpHZ+btdKvG4YHXb/jKl7AMuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/g2D2vBEKbJLQfmMLMmt1Z9jPK+gct/u6JJT0dPDn28=;
 b=V0KupoMyugYEqIDcq1t1iMpFAjiij6YDwMXv5Fkys2pbdxH3HXxWKp7wIg1u9qbjErO/UachpaPSomIzsUwA4c4tEhKUVR8ThopzA2gAMUFZW4UuUME1UrfO5QLuNOc5JtlgepK5I5L2M+inONccN/E11WUxdiWJNsXrXN4LSUQHXnaXNFLEZGUAIlNSIN3e/k70F10bvT46HZJNn6F+hABCoLvMSv4TeCzKyGyExKTuTSmnzfcVuoC8ItBOcATgM+zQgxRyWaZpin37zntvQjWPQray2QbujcB3SBe6Uc4aoydaC3Ney/9v9Al1hiLsO327fuPhN4coJYN2TPD+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g2D2vBEKbJLQfmMLMmt1Z9jPK+gct/u6JJT0dPDn28=;
 b=cKo+tDRq1GSy7By90Y+ZUu8AjvjKaoNgQif4eog/4cVqVKPP1rJtgT1nB/R1T9i/L/YIL4rNHBcXi0oqX6UAge/jwcjsBQ7BKcCSMoqnDxzYwAMv+yPB2cJLJWX/z59kJHnOshKnZs+fq756n9JjpjYT3WwWBSWe9MgNHYp6QRg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5171.namprd10.prod.outlook.com (2603:10b6:208:325::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 20 Jul
 2022 01:57:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%8]) with mapi id 15.20.5438.025; Wed, 20 Jul 2022
 01:57:31 +0000
Message-ID: <11865968-4a13-11b0-abfb-267f9adf3a95@oracle.com>
Date:   Wed, 20 Jul 2022 02:57:24 +0100
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     jgg@nvidia.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-6-yishaih@nvidia.com>
 <20220719130114.2eecbba1.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220719130114.2eecbba1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0056.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::31) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a6db656-adc6-4de2-95ec-08da69f334c6
X-MS-TrafficTypeDiagnostic: BLAPR10MB5171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gv0iAZlYH2S6dw6q7VVkVhKmMDxocKVVEq9xz0P6GaTuA088TrD5j8fw9G/DowDZMilMEXeLPFA3NezgGz1F8gC+CRGCiBj9foMvZvQWcfv2bu4SvADyPxSN06GNMvPkDTlUINwrxvdNFpezzi8gUfeKjDWtedEN3fesZZgMJXGMMBZXA4eDcgli1BC2ic8+NW/YAE/vbFsundf6gUqYWQpR1HebCkmxCrxswycpb86IkidmwX8Hmd82K7pXsAZxA0nsCNiTiU9Sa5B9wg8gPfL+4eaot4cL9WRwkxqGuOJ6iN/r5KkPCmVAiadEB+Po0skHTH6bX9dZo8JdYqW3sJvC2cpV4hIeY7snTiZyeChpEl1020E9rAqey9GAla/RqN3RihlFL4V2f1OJAqUybyCJ6sg/O0lbEFUrPudWbvV0wAqNKdUjkkCohXUqs71QXmZQPc03n+qacJZOwdn66qUkOBZ5swmkpiG1XbN/MyhMcbUdH0jshsYc2/yrVP4LiawnLCNTsNoQg+wllLyNqdkW5XoaFaXndLDvo2Tx0ozpbs4wwhozjhu5OgcGN4U+TcRHZk2uah5V7yk8/GQPG+g8tVhrPdoA+BG0IGlUprgUKeUc6qmN+tc0PIWK8VCSusk5bGdH16itfMHTUQRCCDA8+YD5Qmqmn0Vv9NoKP6oP6vcg5YsxOk/wHyUJQA3qpfC8U2vnuj4i1x8GaI3EYnCGYkEkzQ+xQ0kGfkPcNdefSLq1zIrEG/vSg+nuCWgtoKsZ4aCYxTyvuqlbDe9+Kjbtv6mWQInqSj0qeH2NytE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(136003)(366004)(376002)(31696002)(110136005)(2616005)(8676002)(2906002)(66946007)(4326008)(66556008)(86362001)(83380400001)(66476007)(38100700002)(186003)(53546011)(316002)(36756003)(31686004)(5660300002)(41300700001)(7416002)(8936002)(30864003)(6666004)(478600001)(6512007)(6486002)(26005)(6506007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjZSQUV5SjQvMWU5T3pUNXVDUms0RlZLaW9TWVhkeHFZNkxOV0ZtQy9RMEVt?=
 =?utf-8?B?ZjZFb3R6Tm14dTJXeG92dGErcFVqeG0ra2dSckFDYUFheDI1SGxETkp5M05k?=
 =?utf-8?B?TXBCcHNiK2VDTThGMk9yWkFDdWcrTExERUVpL3dSMWxiZ1BBeFhtVDNqbVhG?=
 =?utf-8?B?eFB4dHZuUFU2TTZ1eE9ZWlh5SjhQTkc0TGZhNDFxeFpzT0Z1Ymk5TXJ4RS9Y?=
 =?utf-8?B?RHpVdXI5OWtJSE9JZ2VIZmo5V3E1Zm1nMGsvcjk5djNJcGdlYU4wWjAzWVJJ?=
 =?utf-8?B?WTQvUXVJc0pEVkFLRWRlMmgyT1I2ZG9JbkNyR1BZdENpcllHRnRRRk14YjQ0?=
 =?utf-8?B?NVRlMm42cHF5M2UwUTB1YWlOTnhqSVBNZUhoeU1Jc1lYTktMbStPdU9Nb2tp?=
 =?utf-8?B?cEVrS2ZtbXpwOU1TZ0dZS3daQmM3SnFWOWh1dkFFN2M1dytSTy9WVXpxa3Rk?=
 =?utf-8?B?a3E4RDRwTVdJWFloaVZmNjlYcThweVVsMnRWbG9XemlPUEJOQ054TWE4eENH?=
 =?utf-8?B?OVBZNjFscHlnUjZ4T28yMUdxemUxdFAwMGswaSs0aHVKY0huWXB4a1RVWldw?=
 =?utf-8?B?YUN5T2g1SDhvREpFbFZqSHpKMkZjTHAwMWpaTU9vT29CTVN2djdWSTNQVEM0?=
 =?utf-8?B?cFlZdmNSZlNES1VvTjNRVWhnOVovWk1GRUFoMjNxdFRCTWJGajNOR25mdFBy?=
 =?utf-8?B?a3g2Q2NNVUpGeFNsRUtKaFVqWGQrUWIraFRrVXREME1wOUY1ZUVLMnV5MWx3?=
 =?utf-8?B?L0h3UTBuQ2ZCTi9LaHZNUFl3b3BnelRyZGU1bVo4Y3NzTEVyMmlnWFNxVjBQ?=
 =?utf-8?B?UUhlYU1FVGNOcnpKS1A4WVRaTXIzalRrcElJdU1zYytOMVZCVnpFYkxUMEdB?=
 =?utf-8?B?UVdrekVwYnhsSWl6NEZIM3k5N2J1ajB6ODBGNjA4NUU1a2NQU3M4MTNwODUy?=
 =?utf-8?B?QlgyOWlOQWZCL1dMSHZOTDJPTFYvV1Jkemk1WDY2aE9lc3pwcDJKRy9FT2Jq?=
 =?utf-8?B?SDhHVlJOTUpQU0lxVVMzNE8wSDVzd0tqNnN1RUF5b3hEWWlzcCszcHdPNkFa?=
 =?utf-8?B?aGZkY2IxejhMU09ueloxd2xibk1CaDlMbndFOFRxTzRkVVlSdVVYejdkR01Z?=
 =?utf-8?B?c29RYVlHc3FiVTQwY1hBN0o1T1ZyZDROb2ZRdjVKNHF5bzV3UE1wUHJteG5z?=
 =?utf-8?B?RVVjWjczQ1F0bWc4eDh5ZTdaQWExRVQ2YzRrM0ZFN3RoMVBFZUc4VEFhL3lo?=
 =?utf-8?B?OGgydmJRbEFCeEZnd20xeCtNRGMycFU0NzVRY3FETkp4VVZRQVIwZmZjc01J?=
 =?utf-8?B?WVFhRFh4MzI0cnNiaXFKMTdwSmdEWHBiandtQnBiQ3BJdkpGMUszK2hFQzZ3?=
 =?utf-8?B?NkhJbUV2M0dYMklQc1dRVHk5dUdxQk1QdWZXTDcyaGxhRWNsS1BHUnp6NmpQ?=
 =?utf-8?B?dlg2WmNPTDBrWGhpeUNsOVI5Y1Y2MXgwUEt6RENIdzlmNjQ1d2xaU0UzQ3FK?=
 =?utf-8?B?Q016ZEdYME5rbmFIUlY0RVUvYkkxZUZhcmJPQnRtbFVEWVNhRGFPYU0zVnlz?=
 =?utf-8?B?YmN6d0x6L1p0dG1HdWIwcVExMnorUG1YRVplL1FGRWhobVZKME45TC9iZGtw?=
 =?utf-8?B?SUY3RlpRN1dYS3VYQ2pmQ295b0JIQXZyemxaaUk5UzFGU2dPZXRQMGxrQWp5?=
 =?utf-8?B?U1NMVUNoQi9nWGRwLzFBZmRDWHo0bDhHVWF4SjNMcVRwTkczbUdMRkdzL2Jv?=
 =?utf-8?B?L1ZIVGdhUloyTCtMcVM3bTIzU3ZnWDM3MXBBNTQ1L2NobGIwaStlbkJGSXRP?=
 =?utf-8?B?eUdvdWlpcTNNWGhDdGQvNTdJdnRPOFFtVEF4N0NwTXR5ZERORndSbFRmMHFL?=
 =?utf-8?B?U2NDNXhRUjlEZ2d4RzBUSGZrMktyNUxRbTFrdFl6cnc0dE1vbUtYN3VqY0hj?=
 =?utf-8?B?ajdya3pOcUYxWk1xUzQwQzdGWFBTeDg5WTJjZnFlZ1ZDdzBWN1l5R1UxTzRW?=
 =?utf-8?B?L3cwS1puT2p2QzFNQWdnTXczUGhJOTR1TXFoZEZsUWlTWTR0b0p5TW9pU0Zl?=
 =?utf-8?B?ajU0YlJvN01aaEpvbVltc2FOczFHdlBYaXlHN04yRGc0YWdBV3d4MzRldXdn?=
 =?utf-8?B?K21iWlVJVFhSWkdub3lWWUVwanl3K0h0ckJoVWJ1b0hKVDBRRmdpNlpRZXV2?=
 =?utf-8?B?WkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6db656-adc6-4de2-95ec-08da69f334c6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 01:57:31.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CriBX6Zg36ImMIr9/0/oVCInWeQKDEMGgElxoE2sJcfpYO8BpTtaR9zYX9mNl+xMYonZJay4R/+OMxmMpqIFacErSDDpAh1fyC9qYyZOG04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200006
X-Proofpoint-GUID: A8rZ6H2W4j_dMusd6_n_gPthrTqjwGX-
X-Proofpoint-ORIG-GUID: A8rZ6H2W4j_dMusd6_n_gPthrTqjwGX-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/22 20:01, Alex Williamson wrote:
> On Thu, 14 Jul 2022 11:12:45 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> The new facility adds a bunch of wrappers that abstract how an IOVA
>> range is represented in a bitmap that is granulated by a given
>> page_size. So it translates all the lifting of dealing with user
>> pointers into its corresponding kernel addresses backing said user
>> memory into doing finally the bitmap ops to change various bits.
>>
>> The formula for the bitmap is:
>>
>>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>>
>> Where 64 is the number of bits in a unsigned long (depending on arch)
>>
>> An example usage of these helpers for a given @iova, @page_size, @length
>> and __user @data:
>>
>> 	iova_bitmap_init(&iter.dirty, iova, __ffs(page_size));
>> 	ret = iova_bitmap_iter_init(&iter, iova, length, data);
> 
> Why are these separate functions given this use case?
> 
Because one structure (struct iova_bitmap) represents the user-facing
part i.e. the one setting dirty bits (e.g. the iommu driver or mlx5 vfio)
and the other represents the iterator of said IOVA bitmap. The iterator
does all the work while the bitmap user is the one marshalling dirty
bits from vendor structure into the iterator-prepared iova_bitmap
(using iova_bitmap_set).

It made sense to me to separate the two initializations, but in pratice
both iterator cases (IOMMUFD and VFIO) are initializing in the same way.
Maybe better merge them for now, considering that it is redundant to retain
this added complexity.

>> 	if (ret)
>> 		return -ENOMEM;
>>
>> 	for (; !iova_bitmap_iter_done(&iter);
>> 	     iova_bitmap_iter_advance(&iter)) {
>> 		ret = iova_bitmap_iter_get(&iter);
>> 		if (ret)
>> 			break;
>> 		if (dirty)
>> 			iova_bitmap_set(iova_bitmap_iova(&iter),
>> 					iova_bitmap_iova_length(&iter),
>> 					&iter.dirty);
>>
>> 		iova_bitmap_iter_put(&iter);
>>
>> 		if (ret)
>> 			break;
> 
> This break is unreachable.
> 
I'll remove it.

>> 	}
>>
>> 	iova_bitmap_iter_free(&iter);
>>
>> The facility is intended to be used for user bitmaps representing
>> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>  drivers/vfio/Makefile       |   6 +-
>>  drivers/vfio/iova_bitmap.c  | 164 ++++++++++++++++++++++++++++++++++++
>>  include/linux/iova_bitmap.h |  46 ++++++++++
>>  3 files changed, 214 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/vfio/iova_bitmap.c
>>  create mode 100644 include/linux/iova_bitmap.h
>>
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index 1a32357592e3..1d6cad32d366 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -1,9 +1,11 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  vfio_virqfd-y := virqfd.o
>>  
>> -vfio-y += vfio_main.o
>> -
>>  obj-$(CONFIG_VFIO) += vfio.o
>> +
>> +vfio-y := vfio_main.o \
>> +          iova_bitmap.o \
>> +
>>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
>> new file mode 100644
>> index 000000000000..9ad1533a6aec
>> --- /dev/null
>> +++ b/drivers/vfio/iova_bitmap.c
>> @@ -0,0 +1,164 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#include <linux/iova_bitmap.h>
>> +
>> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
>> +					       unsigned long iova_length)
> 
> If we have an iova-to-index function, why do we pass it a length?  That
> seems to be conflating the use cases where the caller is trying to
> determine the last index for a range with the actual implementation of
> this helper.
> 

see below

>> +{
>> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
>> +
>> +	return DIV_ROUND_UP(iova_length, BITS_PER_TYPE(*iter->data) * pgsize);
> 
> ROUND_UP here doesn't make sense to me and is not symmetric with the
> below index-to-iova function.  For example an iova of 0x1000 give me an
> index of 1, but index of 1 gives me an iova of 0x40000.  Does this code
> work??
> 
It does work. The functions aren't actually symmetric, and iova_to_index() is returning
the number of elements based on bits-per-u64/page_size for a IOVA length. And it was me
being defensive to avoid having to fixup to iovas given that all computations can be done
with lengths/nr-elements.

I have been reworking IOMMUFD original version this originated and these are remnants of
working over chunks of bitmaps/iova rather than treating the bitmap as an array. But the
latter is where I was aiming at in terms of structure. I should make these symmetric and
actually return an index and fully adhere to that symmetry as convention.

Thus will remove the DIV_ROUND_UP here, switch it to work under an IOVA instead of length
and adjust the necessary off-by-one and +1 in its respective call sites. Sorry for the
confusion this has caused.

>> +}
>> +
>> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
>> +					       unsigned long index)
>> +{
>> +	unsigned long pgshift = iter->dirty.pgshift;
>> +
>> +	return (index * sizeof(*iter->data) * BITS_PER_BYTE) << pgshift;
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Isn't that BITS_PER_TYPE(*iter->data), just as in the previous function?
> 
Yeap, I'll switch to that.

>> +}
>> +
>> +static unsigned long iova_bitmap_iter_left(struct iova_bitmap_iter *iter)
> 
> I think this is trying to find "remaining" whereas "left" can be
> confused with a direction.
> 
Yes, it was bad english on my end. I'll replace it with @remaining.

>> +{
>> +	unsigned long left = iter->count - iter->offset;
>> +
>> +	left = min_t(unsigned long, left,
>> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
> 
> Ugh, dirty.npages is zero'd on bitmap init, allocated on get and left
> with stale data on put.  This really needs some documentation/theory of
> operation.
> 

So the get and put are always paired, and their function is to pin a chunk
of the bitmap (up to 2M which is how many struct pages can fit in one
base page) and initialize the iova_bitmap with the info on what the bitmap
pages represent in terms of which IOVA space.

So while @npages is left stale after put(), its value is only ever useful
after get() (i.e. pinning). And its purpose is to cap the max pages
we can access from the bitmap for also e.g. calculating
iova_bitmap_length()/iova_bitmap_iter_left()
or advancing the iterator.

>> +
>> +	return left;
>> +}
>> +
>> +/*
>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
>> + * further casts to signed integer for unaligned multi-bit operation,
>> + * __bitmap_set().
>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>> + * system.
>> + */
> 
> This is all true and familiar, but what's it doing here?  The type1
> code this comes from uses this to justify some #defines that are used
> to sanitize input.  I see no such enforcement in this code.  The only
> comment in this whole patch and it seems irrelevant.
> 
This was previously related to macros I had here that serve the same purpose
as the ones in VFIO, but the same said validation was made in some other way
and by distraction I left this comment stale. I'll remove it.

>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
>> +			  unsigned long iova, unsigned long length,
>> +			  u64 __user *data)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	iter->data = data;
>> +	iter->offset = 0;
>> +	iter->count = iova_bitmap_iova_to_index(iter, length);
> 
> If this works, it's because the DIV_ROUND_UP above accounted for what
> should have been and index-to-count fixup here, ie. add one.
> 
As mentioned earlier, I'll change that to the suggestion above.

>> +	iter->iova = iova;
>> +	iter->length = length;
>> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
>> +
>> +	return !dirty->pages ? -ENOMEM : 0;
>> +}
>> +
>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	if (dirty->pages) {
>> +		free_page((unsigned long)dirty->pages);
>> +		dirty->pages = NULL;
>> +	}
>> +}
>> +
>> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
>> +{
>> +	return iter->offset >= iter->count;
>> +}
>> +
>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
>> +{
>> +	unsigned long max_iova = iter->dirty.iova + iter->length;
>> +	unsigned long left = iova_bitmap_iter_left(iter);
>> +	unsigned long iova = iova_bitmap_iova(iter);
>> +
>> +	left = iova_bitmap_index_to_iova(iter, left);
> 
> @left is first used for number of indexes and then for an iova range :(
> 
I was trying to avoid an extra variable and an extra long line.

>> +	if (iova + left > max_iova)
>> +		left -= ((iova + left) - max_iova);
>> +
>> +	return left;
>> +}
> 
> IIUC, this is returning the iova free space in the bitmap, not the
> length of the bitmap??
> 
This is essentially representing your bitmap working set IOW the length
of the *pinned* bitmap. Not the size of the whole bitmap.

>> +
>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
>> +{
>> +	unsigned long skip = iter->offset;
>> +
>> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
>> +}
> 
> It would help if this were defined above it's usage above.
> 
I'll move it.

>> +
>> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
>> +{
>> +	unsigned long length = iova_bitmap_length(iter);
>> +
>> +	iter->offset += iova_bitmap_iova_to_index(iter, length);
> 
> Again, fudging an index count based on bogus index value.
> 
As mentioned earlier, I'll change that iova_bitmap_iova_to_index()
to return an index instead of nr of elements.

>> +}
>> +
>> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	if (dirty->npages)
>> +		unpin_user_pages(dirty->pages, dirty->npages);
> 
> dirty->npages = 0;?
> 
Sadly no, because after iova_bitmap_iter_put() we will call
iova_bitmap_iter_advance() to go to the next chunk of the bitmap
(i.e. the next 64G of IOVA, or IOW the next 2M of bitmap memory).

I could remove explicit calls to iova_bitmap_iter_{get,put}()
while making them internal only and merge it in iova_bitmap_iter_advance()
and iova_bimap_iter_init. This should a bit simpler for API user
and I would be able to clear npages here. Let me see how this looks.

>> +}
>> +
>> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +	unsigned long npages;
>> +	u64 __user *addr;
>> +	long ret;
>> +
>> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
>> +			      sizeof(*iter->data), PAGE_SIZE);
>> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
>> +	addr = iter->data + iter->offset;
>> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
>> +				  FOLL_WRITE, dirty->pages);
>> +	if (ret <= 0)
>> +		return ret;
>> +
>> +	dirty->npages = (unsigned long)ret;
>> +	dirty->iova = iova_bitmap_iova(iter);
>> +	dirty->start_offset = offset_in_page(addr);
>> +	return 0;
>> +}
>> +
>> +void iova_bitmap_init(struct iova_bitmap *bitmap,
>> +		      unsigned long base, unsigned long pgshift)
>> +{
>> +	memset(bitmap, 0, sizeof(*bitmap));
>> +	bitmap->iova = base;
>> +	bitmap->pgshift = pgshift;
>> +}
>> +
>> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
>> +			     unsigned long iova,
>> +			     unsigned long length)
>> +{
>> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
>> +
>> +	nbits = max(1UL, length >> dirty->pgshift);
>> +	offset = (iova - dirty->iova) >> dirty->pgshift;
>> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
>> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
>> +	start_offset = dirty->start_offset;
>> +
>> +	while (nbits > 0) {
>> +		kaddr = kmap_local_page(dirty->pages[idx]) + start_offset;
>> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
>> +		bitmap_set(kaddr, offset, size);
>> +		kunmap_local(kaddr - start_offset);
>> +		start_offset = offset = 0;
>> +		nbits -= size;
>> +		idx++;
>> +	}
>> +
>> +	return nbits;
>> +}
>> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
>> +
>> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
>> new file mode 100644
>> index 000000000000..c474c351634a
>> --- /dev/null
>> +++ b/include/linux/iova_bitmap.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#ifndef _IOVA_BITMAP_H_
>> +#define _IOVA_BITMAP_H_
>> +
>> +#include <linux/highmem.h>
>> +#include <linux/mm.h>
>> +#include <linux/uio.h>
>> +
>> +struct iova_bitmap {
>> +	unsigned long iova;
>> +	unsigned long pgshift;
>> +	unsigned long start_offset;
>> +	unsigned long npages;
>> +	struct page **pages;
>> +};
>> +
>> +struct iova_bitmap_iter {
>> +	struct iova_bitmap dirty;
>> +	u64 __user *data;
>> +	size_t offset;
>> +	size_t count;
>> +	unsigned long iova;
>> +	unsigned long length;
>> +};
>> +
>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
>> +			  unsigned long length, u64 __user *data);
>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
>> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
>> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
>> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter);
>> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
>> +void iova_bitmap_init(struct iova_bitmap *bitmap,
>> +		      unsigned long base, unsigned long pgshift);
>> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
>> +			     unsigned long iova,
>> +			     unsigned long length);
>> +
>> +#endif
> 
> No relevant comments, no theory of operation.  I found this really
> difficult to review and the page handling is still not clear to me.
> I'm not willing to take on maintainership of this code under
> drivers/vfio/ as is. 

Sorry for the lack of comments/docs and lack of clearity in some of the
functions. I'll document all functions/fields and add a comment bloc at
the top explaining the theory on how it should be used/works, alongside
the improvements you suggested above.

Meanwhile what is less clear for you on the page handling? We are essentially
calculating the number of pages based of @offset and @count and then preping
the iova_bitmap (@dirty) with the base IOVA and page offset. iova_bitmap_set()
then computes where is the should start setting bits, and then it kmap() each page
and sets the said bits. So far I am not caching kmap() kaddr,
so the majority of iova_bitmap_set() complexity comes from iterating over number
of bits to kmap and accounting to the offset that user bitmap address had.

	Joao
