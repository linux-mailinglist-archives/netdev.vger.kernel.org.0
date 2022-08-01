Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF39C58741B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiHAWx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiHAWx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:53:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFC027175
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 15:53:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271MEOcd003974;
        Mon, 1 Aug 2022 22:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=UADTIpGkDJQHxGjNn70jx2EkKY4Hv5RStNFHFl12aoA=;
 b=tNCcuaSo1gIceVeSVglZEAybmpLw0WaE47he7+/ZhwE5pA+UjFrkFifLwSgaRJ2pO+eg
 wStbKSdVZHgg6JoJi7CAxPHMnA8NX6QchO4Te0OZXz9UxPBCWpsDdFexv1+0nQC+qXzY
 Wy12oy6ckh2063czRX781FDcJ/RPE1af++v7ZPSsz6EJ5dUKsaC+Et/ivhQRDs0xVun7
 Hb0nwKNb3rcKP9TOEWRcO3iH0T3qZQzwt0uHY4rwsSw2uOPS5QNl0MhtEb5WK2WRYxw1
 hJXGmi7v9GjbMipkj/HN1Y93CEyv0lvEjYrzheE1wGwp0azgPNxuYPwF7xQiNGS72U5P wQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9n1na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 22:53:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271KX1MO001154;
        Mon, 1 Aug 2022 22:53:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57qn4n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 22:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiLxSXWJqJC9rljolqxc4MSpt4XLc/7TAS/kpJk7N10al6mr5P68d5dBvxF+ClE+qXTc7NFJ9kpIOL3o4NDAxEUcXqtv7IxFH3lr4Oxao2d7XOMkwE20jcAsq+Y8iHJOWw5+4Pum/HsME2M8nBHYwjDJIksMToCuThqxoccpaRmg0ODPXbYHIpq313nakf7RhppHOW00pszMSixHNnnvGnaJ5LbinQbRwU+0FfkAQ0PqSLrMQlZ+JWTq1CE+hzkdzljJe6moAGAwacWc6eZmdvLAujAZoN0tJ4tauQTgi0G1RUWAH3kRj7NJiDIzRt+HIRVOEcvurJM9nK0hrKEndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UADTIpGkDJQHxGjNn70jx2EkKY4Hv5RStNFHFl12aoA=;
 b=VcdWPma6KRtOIjODrA49cm6VRtgYG59iXcuSwT9T1yK667yqbcWJbZKOqWQ0W7b6OJjgqdRxw4Re5iErV4d5+C33vZQzI9Av+r+DNx1WXloPHHxu9lIsPfhuIyEPirLbQZKdcRmFEa/TdPSIF+7wrKwRU+K6O/LehEPWGhJZnOFIAphC+NYhp4AErmeD3wy9Ys0f5YhTZ1RGcPIkLRx7CBp3nxuVWIY45AVpPrYF84B8cWBrnbcY8qp/l1B/nJwMrJPVmnoHmo8X2jzcjlsThkYPc6suYqx3DwrqeG8sddQJqyextWss0wHRiov2rS2Pys6l0zkJIiAkdzHzp7vuzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UADTIpGkDJQHxGjNn70jx2EkKY4Hv5RStNFHFl12aoA=;
 b=PI5oozaVcU6kavosFX28hPwFB0+8/nfYy1T+6xrAlZ3vZheSFlD2DzykriOgJqj1EQ3qgUoSsgfNnqwNeji/pFhBTBiVEZAWoxe53g4ZZtkG7gjKoeBsK5z+Zy12lOGiCf2HDX3mcDX/ukEDGoNY0REIzYq/4g0JD6VD4fccssk=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by MN2PR10MB3597.namprd10.prod.outlook.com (2603:10b6:208:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 22:53:41 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 22:53:41 +0000
Message-ID: <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
Date:   Mon, 1 Aug 2022 15:53:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <00e2e07e-1a2e-7af8-a060-cc9034e0d33f@intel.com>
 <b58dba25-3258-d600-ea06-879094639852@oracle.com>
 <c143e2da-208e-b046-9b8f-1780f75ed3e6@intel.com>
 <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
 <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b05b550-4189-45be-3bab-08da7410adae
X-MS-TrafficTypeDiagnostic: MN2PR10MB3597:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lr/vpIXLEwf7sG6o/w+LngjawsC1actOLFT85AEh5EtPP0DaMCZC1SRK6bF+qDcaDCV3dNNmlWgrVUEz18bFuAKH1aZ6H+/Jj95G0BcSyiWwHlBPfn/kw3zcoxNHIb4SjPVw53KVPbq5e6lrcec/CKfMqf3EPYqKxHGtLEgmNkb8+pEAa+l1PfrS80zQqMpMT18szaqtzoZdvgygKDkW3NgoaXbp/hiGTi3k+OTKTKDTjXvfzk8TdYJThN8hE+VFGPQnltPrrKNp5g5dlEjqvt5g0df8sHV+Za8wYOubefT7/3lFIJ1j35BFfccV7NXy5pbgknvyj9L0s9F14ctfTjy++pN2MYTWzQ5mXnCIJhNL1yd3vucS8KyZojlUo6CckyWcQ7WRA6pNSPuokb06qaTKUpOhZ0TrZLqSn7qH8QkhwzkXa593P79+v8DqgeLJal6z7sj6QYplpathyeKlg9TWnnc01QYUjr7YP7UsjDxqdX+VYwjDHTim/k7VkV1xtDtCFLXugny0Zngwh5x/5O5lztwZ2ba7Wh3ZCbtwPsKtBCNrfQTQBzw0hiTUWCw/xPtOy4hGpKaHSgGtT7Ad/NpPUbOw0WYoamyYjcKBkBGheQp/AcYfddVQT7gUMvnAckM/e02uPMwmff7iv+TzE0U6gkzgtNrvbt2BJ1U2D8OJrYTA7HwR/yyc3ka0HJfthaPuUgAA3PlX2dYPIHmPhKDMbqRSUva2VzyXG9svGEfNVTSKPRvl5z+Qb3GDJArPtj/jVfa5ye7uH2lb2Lm04NcM5u5aFcJQ6kjq8y0pzVs71VD+JwMR4yv9oKkCdHRfB7VDXI9PtTMC9Ngp5JpYpyqBYCOuUtHmUwaYv5CiJkc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(366004)(396003)(39860400002)(66476007)(66946007)(66556008)(8936002)(4326008)(8676002)(478600001)(38100700002)(186003)(5660300002)(6486002)(966005)(31696002)(316002)(54906003)(110136005)(86362001)(6666004)(2616005)(6506007)(53546011)(36916002)(2906002)(41300700001)(31686004)(83380400001)(36756003)(26005)(6512007)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2x6dEtTT1JneWZlL09hU0tIQ1ZQdWc4V0lOaW9KRUh4NUNCZ1FUUHZQb0Zv?=
 =?utf-8?B?WER4YWs0bGhTQ2dPWmxmekF5RllJNmRvYTREMWdNWC9sWnBINkJHWFZaUmIv?=
 =?utf-8?B?dXg4Q2txOFJaS3FSWERndkZOUmlweWk4V1R2S0o2dis0dlBZTzJtWjd6UU0w?=
 =?utf-8?B?T3RSL1Q3LzFnSStyWUJWcDNjWWJkdnphK241SW1OOHFidW83WlZGOVZwMWUy?=
 =?utf-8?B?QS8rbTRBdW1wMnNLeGhDZ0NxcThkK3RaNnRzVk5ITXVhVGJsb0tELzdJdW1G?=
 =?utf-8?B?WEhKTUJ3OVNTZldQaTlVZzdFRERNRitmSHBWUHMvVklvZVZwWks3K3ZTVEpI?=
 =?utf-8?B?eFgvdVpIdlcwZ0FlZTJ1b1BYUzZ5MmEzT1RXK3JURlM4Z0hOM29lcnJrY2Rt?=
 =?utf-8?B?cmRrcGFZUjArR0p2Ti9CNzNlLzJqY1NyWi9wUFY2cG5BQ21xUXB0aHhJMkd2?=
 =?utf-8?B?TmNqcW9kdjZHVUQ4Qk5lazNDc0FNM29mNFJMNzMzQU5kTWd5WEdpSUwzM0dx?=
 =?utf-8?B?UjFvSFBVWUdPOCtjcVZmVzMzWjBDb1A5N2svOWE4UXBEZnV5ZWFad1pzQ1E5?=
 =?utf-8?B?SERlSUlIVmpXOVVNZFBjdDZqeEFNS3lidWZSK3F6VlFmdG0zbWVKbXNabHNv?=
 =?utf-8?B?R3FHMXNtT1p1b1BNeTFGRTh4KzNnQjRBZTgyMXllK0QwbmZVOFJaa3UxNkwy?=
 =?utf-8?B?b0x1VjhQQjhVdlo1cDBDVi84TE4weEhNb1lvbDF3c2VwZWdWY0hLOGlIZGRH?=
 =?utf-8?B?OWdPOXJvWnBLeTcvQjVPNStLZDZmaVNwTkl3NUJRS1ZNNlhGM0JoajZPWkRw?=
 =?utf-8?B?QkU1MzV5c3pLKzczYXErMzhPeHVPVVc5anpNUFlvbjdVWEpBT2NwSWdSZmVD?=
 =?utf-8?B?aXg0VU1aZDBRT2ZwU3NwUnFJQ0VuMS84dUM3emRDZ0pnYkxFZWc1Qm81V3VR?=
 =?utf-8?B?UE1XbHhkcHQwWlNHOUxHUVBkUjZkY3dZRC9BUldOVEVKK29NQkxiSHBiUkhl?=
 =?utf-8?B?RktKeTh5em9yUWJLNmlRUktyR2VFZWh6dDc4VlJNQnVnUXpKZkhjTjhKeFkz?=
 =?utf-8?B?b3lMMzdJZ0hPTFJIMklYU0VZdG9LNldNQXArb3lFcFppRmYyblV6UlpERFZQ?=
 =?utf-8?B?TERaMXdnTzNuMHdGdTBkL2luL2hMcW9zR0xMYzYrYW5KZXVad3NOVUdwUHZF?=
 =?utf-8?B?Ky9FanB4M2hHM3hURE5lczZ4a2Y0OEFSWWN1VWdscmpqZ0x5aFhvYlRhem9P?=
 =?utf-8?B?TW9ybHRBOEhIVDdIdVkxSnIvbytJRHNySFNWeEFWVFZlTXl5MVJJbXhsNWhp?=
 =?utf-8?B?cys0TkRkdDVmMTNRQ29vNDlEOFAyUW0xcVNXQ3Z3TzRHbEFienZVVEN2Q2lN?=
 =?utf-8?B?ZHZuUWZQSW1SdUJQZ2M1ZFJIUmxFZE13bVYvQi9tMUdsV2ludUpueHIvNU9w?=
 =?utf-8?B?ckZiVHhlMDRyQ1FEZkd5Q1A0SlYrQms2ZzBiUEVtUnNuaEh4dzYwTUFGUjVP?=
 =?utf-8?B?ejdhQUJ6QTBvMVZQOHhwZjdFNE11NWpWemhocmVlcWFHTG9YbVI1cnhKYlZi?=
 =?utf-8?B?aks1WjZIOUF2Wmwwd0NmTVkwMzZ0b1laRXJiVlJGVlE1V1RkZ2VoK29IekQx?=
 =?utf-8?B?Tk8rczNUL1JieXRiaFNlYzI2b3NwTXJ1UW5KNkRQOG85SU96S0tLSnNBMmkr?=
 =?utf-8?B?cm52MUtITHVCZGhlNWMrYWlSdDhOc0R1Tlk5bzZSbGNsZllJeUdGNm1UYVZq?=
 =?utf-8?B?NDdQS1ZwbmZJTWhkK2I1TDZNaDhlY2pFc0NnVVdqUnhObUNHM1pIV29TdmtS?=
 =?utf-8?B?T1hrMmlhTHJuSWN6VDdmenp0UFpFTFh5RG9NWi9GVmNwY2toZWU2YUluODhJ?=
 =?utf-8?B?ZlJsbjlpcHpISllpaVdsbGNjS1A3OEluMEJlaWIwRDN0eTJ3eXpGemcyMFdZ?=
 =?utf-8?B?dHRXczN0VUVPVXIwZ0oxbDFXK3ArK2JGT0xlbVNGbkdFQ0hQbmNDS2QzTUlP?=
 =?utf-8?B?ZG5IK1d4eU0rWWNDSU1KRXlYQ0FycTVxbTlQSnJVdmhXOGxKakdtU3prUWtD?=
 =?utf-8?B?ZGZCU1lWQS9NRmFnUldvZ1lzVXBsbnFVdTZ2M3lqU2Zka2hmRmpxWE8wQUlp?=
 =?utf-8?Q?pHFg1d71UaCH5kK18A7nzx/ML?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b05b550-4189-45be-3bab-08da7410adae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 22:53:41.1021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrEUv0iQ9/dSuF4y0uyvGKk3ftsC3B7u5/0K3vDf4vF9ciy/hu9KsxmWws2Bxi7GGMG9s1Kzdms3K7l8iOH0pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010115
X-Proofpoint-ORIG-GUID: gcCCJOGJGWQ5pwtirTIsv1F89KycctDh
X-Proofpoint-GUID: gcCCJOGJGWQ5pwtirTIsv1F89KycctDh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/2022 9:44 PM, Jason Wang wrote:
>
> 在 2022/7/30 04:55, Si-Wei Liu 写道:
>>
>>
>> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>>
>>>
>>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>>
>>>>
>>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>>
>>>>>
>>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>>
>>>>>>
>>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>>> Sorry to chime in late in the game. For some reason I couldn't 
>>>>>>>> get to most emails for this discussion (I only subscribed to 
>>>>>>>> the virtualization list), while I was taking off amongst the 
>>>>>>>> past few weeks.
>>>>>>>>
>>>>>>>> It looks to me this patch is incomplete. Noted down the way in 
>>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>>          features = vdev->config->get_driver_features(vdev);
>>>>>>>>          if (nla_put_u64_64bit(msg, 
>>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>>                                VDPA_ATTR_PAD))
>>>>>>>>                  return -EMSGSIZE;
>>>>>>>>
>>>>>>>> Making call to .get_driver_features() doesn't make sense when 
>>>>>>>> feature negotiation isn't complete. Neither should present 
>>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>>
>>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() 
>>>>>>>> probably should not show before negotiation is done - it 
>>>>>>>> depends on driver features negotiated.
>>>>>>> I have another patch in this series introduces device_features 
>>>>>>> and will report device_features to the userspace even features 
>>>>>>> negotiation not done. Because the spec says we should allow 
>>>>>>> driver access the config space before FEATURES_OK.
>>>>>> The config space can be accessed by guest before features_ok 
>>>>>> doesn't necessarily mean the value is valid. You may want to 
>>>>>> double check with Michael for what he quoted earlier:
>>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC, 
>>>>> vDPA kernel should not return a mac to the userspace, there is not 
>>>>> a default value for mac.
>>>> Then please show us the code, as I can only comment based on your 
>>>> latest (v4) patch and it was not there.. To be honest, I don't 
>>>> understand the motivation and the use cases you have, is it for 
>>>> debugging/monitoring or there's really a use case for live 
>>>> migration? For the former, you can do a direct dump on all config 
>>>> space fields regardless of endianess and feature negotiation 
>>>> without having to worry about validity (meaningful to present to 
>>>> admin user). To me these are conflict asks that is impossible to 
>>>> mix in exact one command.
>>> This bug just has been revealed two days, and you will see the patch 
>>> soon.
>>>
>>> There are something to clarify:
>>> 1) we need to read the device features, or how can you pick a proper 
>>> LM destination
>
>
> So it's probably not very efficient to use this, the manager layer 
> should have the knowledge about the compatibility before doing 
> migration other than try-and-fail.
>
> And it's the task of the management to gather the nodes whose devices 
> could be live migrated to each other as something like "cluster" which 
> we've already used in the case of cpuflags.
>
> 1) during node bootstrap, the capability of each node and devices was 
> reported to management layer
> 2) management layer decide the cluster and make sure the migration can 
> only done among the nodes insides the cluster
> 3) before migration, the vDPA needs to be provisioned on the destination
>
>
>>> 2) vdpa dev config show can show both device features and driver 
>>> features, there just need a patch for iproute2
>>> 3) To process information like MQ, we don't just dump the config 
>>> space, MST has explained before
>> So, it's for live migration... Then why not export those config 
>> parameters specified for vdpa creation (as well as device feature 
>> bits) to the output of "vdpa dev show" command? That's where device 
>> side config lives and is static across vdpa's life cycle. "vdpa dev 
>> config show" is mostly for dynamic driver side config, and the 
>> validity is subject to feature negotiation. I suppose this should 
>> suit your need of LM, e.g.
>
>
> I think so.
>
>
>>
>> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 2000
>> $ vdpa dev show vdpa1
>> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs 
>> 15 max_vq_size 256
>>   max_vqp 7 mtu 2000
>>   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ 
>> MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>
>
> Note that the mgmt should know this destination have those 
> capability/features before the provisioning.
Yes, mgmt software should have to check the above from source.

>
>
>>
>> For it to work, you'd want to pass "struct vdpa_dev_set_config" to 
>> _vdpa_register_device() during registration, and get it saved there 
>> in "struct vdpa_device". Then in vdpa_dev_fill() show each field 
>> conditionally subject to "struct vdpa_dev_set_config.mask".
>>
>> Thanks,
>> -Siwei
>
>
> Thanks
>
>
>>>
>>> Thanks
>>> Zhu Lingshan
>>>>
>>>>>>> Nope:
>>>>>>>
>>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>>
>>>>>>> ...
>>>>>>>
>>>>>>> For optional configuration space fields, the driver MUST check 
>>>>>>> that the corresponding feature is offered
>>>>>>> before accessing that part of the configuration space.
>>>>>>
>>>>>> and how many driver bugs taking wrong assumption of the validity 
>>>>>> of config space field without features_ok. I am not sure what use 
>>>>>> case you want to expose config resister values for before 
>>>>>> features_ok, if it's mostly for live migration I guess it's 
>>>>>> probably heading a wrong direction.
>>>>>>
>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Last but not the least, this "vdpa dev config" command was not 
>>>>>>>> designed to display the real config space register values in 
>>>>>>>> the first place. Quoting the vdpa-dev(8) man page:
>>>>>>>>
>>>>>>>>> vdpa dev config show - Show configuration of specific device 
>>>>>>>>> or all devices.
>>>>>>>>> DEV - specifies the vdpa device to show its configuration. If 
>>>>>>>>> this argument is omitted all devices configuration is listed.
>>>>>>>> It doesn't say anything about configuration space or register 
>>>>>>>> values in config space. As long as it can convey the config 
>>>>>>>> attribute when instantiating vDPA device instance, and more 
>>>>>>>> importantly, the config can be easily imported from or exported 
>>>>>>>> to userspace tools when trying to reconstruct vdpa instance 
>>>>>>>> intact on destination host for live migration, IMHO in my 
>>>>>>>> personal interpretation it doesn't matter what the config space 
>>>>>>>> may present. It may be worth while adding a new debug command 
>>>>>>>> to expose the real register value, but that's another story.
>>>>>>> I am not sure getting your points. vDPA now reports device 
>>>>>>> feature bits(device_features) and negotiated feature 
>>>>>>> bits(driver_features), and yes, the drivers features can be a 
>>>>>>> subset of the device features; and the vDPA device features can 
>>>>>>> be a subset of the management device features.
>>>>>> What I said is after unblocking the conditional check, you'd have 
>>>>>> to handle the case for each of the vdpa attribute when feature 
>>>>>> negotiation is not yet done: basically the register values you 
>>>>>> got from config space via the vdpa_get_config_unlocked() call is 
>>>>>> not considered to be valid before features_ok (per-spec). 
>>>>>> Although in some case you may get sane value, such behavior is 
>>>>>> generally undefined. If you desire to show just the 
>>>>>> device_features alone without any config space field, which the 
>>>>>> device had advertised *before feature negotiation is complete*, 
>>>>>> that'll be fine. But looks to me this is not how patch has been 
>>>>>> implemented. Probably need some more work?
>>>>> They are driver_features(negotiated) and the device_features(which 
>>>>> comes with the device), and the config space fields that depend on 
>>>>> them. In this series, we report both to the userspace.
>>>> I fail to understand what you want to present from your 
>>>> description. May be worth showing some example outputs that at 
>>>> least include the following cases: 1) when device offers features 
>>>> but not yet acknowledge by guest 2) when guest acknowledged 
>>>> features and device is yet to accept 3) after guest feature 
>>>> negotiation is completed (agreed upon between guest and device).
>>> Only two feature sets: 1) what the device has. (2) what is negotiated
>>>>
>>>> Thanks,
>>>> -Siwei
>>>>>>
>>>>>> Regards,
>>>>>> -Siwei
>>>>>>
>>>>>>>>
>>>>>>>> Having said, please consider to drop the Fixes tag, as appears 
>>>>>>>> to me you're proposing a new feature rather than fixing a real 
>>>>>>>> issue.
>>>>>>> it's a new feature to report the device feature bits than only 
>>>>>>> negotiated features, however this patch is a must, or it will 
>>>>>>> block the device feature bits reporting. but I agree, the fix 
>>>>>>> tag is not a must.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>>>
>>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>>
>>>>>>>>>> Users may want to query the config space of a vDPA device, to 
>>>>>>>>>> choose a
>>>>>>>>>> appropriate one for a certain guest. This means the users 
>>>>>>>>>> need to read the
>>>>>>>>>> config space before FEATURES_OK, and the existence of config 
>>>>>>>>>> space
>>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>>
>>>>>>>>>> The spec says:
>>>>>>>>>> The device MUST allow reading of any device-specific 
>>>>>>>>>> configuration field
>>>>>>>>>> before FEATURES_OK is set by the driver. This includes fields 
>>>>>>>>>> which are
>>>>>>>>>> conditional on feature bits, as long as those feature bits 
>>>>>>>>>> are offered by the
>>>>>>>>>> device.
>>>>>>>>>>
>>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if 
>>>>>>>>>> FEATURES_OK)
>>>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>>>
>>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>>> And
>>>>>>>>> It should be in format
>>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if 
>>>>>>>>> FEATURES_OK")
>>>>>>>>>
>>>>>>>>> Please use checkpatch.pl script before posting the patches to 
>>>>>>>>> catch these errors.
>>>>>>>>> There is a bot that looks at the fixes tag and identifies the 
>>>>>>>>> right kernel version to apply this fix.
>>>>>>>>>
>>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>> ---
>>>>>>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>>   1 file changed, 8 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device 
>>>>>>>>>> *vdev,
>>>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>>>       u32 device_id;
>>>>>>>>>>       void *hdr;
>>>>>>>>>> -    u8 status;
>>>>>>>>>>       int err;
>>>>>>>>>>
>>>>>>>>>>       down_read(&vdev->cf_lock);
>>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>>>> completed");
>>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>>> -        goto out;
>>>>>>>>>> -    }
>>>>>>>>>> -
>>>>>>>>>>       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, 
>>>>>>>>>> flags,
>>>>>>>>>>                 VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>>       if (!hdr) {
>>>>>>>>>> -- 
>>>>>>>>>> 2.31.1
>>>>>>>>> _______________________________________________
>>>>>>>>> Virtualization mailing list
>>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!NzOv5Ew_Z2CP-zHyD7RsUoStLZ54KpB21QyuZ8L63YVPLEGDEwvcOSDlIGxQPHY-DMkOa9sKKZdBSaNknMU$ 
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

