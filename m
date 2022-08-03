Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB75894A6
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbiHCXJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiHCXJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:09:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF994E605
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:09:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273Mw6Nh028788;
        Wed, 3 Aug 2022 23:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jZHsXrjZLfkioqyWIuFCQPHm98h1eKrfqXQbJze4UGI=;
 b=nkovEJ95d2UkKsKVUySxjOaFgMKUmfHlBoV9Dx0rRwVkEMKCSWCE9jglqK8Vh2WBASse
 RiMBaX9K4tJHS2nOISDV327ThG+cOwVqO0eQUDC0ZtsvHNJA4lB8do+z3zt0U2rqxoqW
 dLvbk8IWkOdumsdhNlZlvuYmUvFVVzQtGz4zSkpyODjner1Twy2qg4uMaGCdpkF7d0uO
 JzKeHTYcf8Mk2uZ7ixYoljNfTr3PPed9iR2nSD9wTlOmzdeMvUhWrZAGDf6xP/AjDf1D
 vZCng61+ouFNjP9gbjc9a75fWUj9hOggdDiXcAi1Rv86BiUarZFxz8oSDIgtnhCG+CbP 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2uhnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 23:09:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273M25TO010784;
        Wed, 3 Aug 2022 23:09:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33psrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 23:09:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgoAubL21Ofbey9gy2DqoE/LFmN53UGbTrvvlnACh1+HNbw9yyc0yv68PpA6Rh8S6kNkmR/TWlaImY11CCrwjCUILAGDmHrqi1yoYi7SVJD2hFoRsE7R61s6SjOSfhMqdwEvpx1IQZt2NSprE7GICfE+UVab1Dq32ApCXBQqwU2Q+EEZtgKgid8Q0NcqD/aSuM3HmtF4JXadD9bCFN+KKVDDyYkAGuTmLs9afwpJf11KwpO8UrD05bO1Ar5RVsSp7fbWzLLk314UyuZxQAcvIsSlGP4QpcrSoJRASxDnEUnuBh+8VPRZJmyDhiRwz55HkVHHZNlFUzKEN4nbmSDBIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZHsXrjZLfkioqyWIuFCQPHm98h1eKrfqXQbJze4UGI=;
 b=k6y21IiIqiWPugFloaP58sHkqy4YpLw8i55ZY5LU+Xij6EUrEacc29hZVvyQfxgt26VlWoUzjTzb5+HnlnWQ4YU73kWXo5P4neO2VqWrhhcuyUGrMdyp7uhRzVLQdmBo/iD61lpmqmRqb9807q8nXFfsndn9TCvUAx+GqH7Ynb5DF1SsH1PnK/wXY/irB5BG15k0dIoJ+62oFuSWyrNQTeo9+ZwvPmmOjZbjt0nXpnx6M+9GWXfby1WPBW4qkRWzWZwVFUWcrPpKM5mw9XJRiITF8jyRqoQcUC83NdBRNIDDMuIt7FHmQfhs1OtrJIuUvr8T67Zbbc0c6OkmPuiQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZHsXrjZLfkioqyWIuFCQPHm98h1eKrfqXQbJze4UGI=;
 b=H/wuJHis8x61yyRSC8s7XyIkXSP5ZfQauCR7yx4mbC6yCKvYeIi3E9KpFJWJDeoVx02pB1RLH2YieoB7lxoPZNMdHGk183eYt6N82v+8MOBXK3XQwwaJknrNQ8E4Qert7d+Ac7t4ho+ML9lmlpxxOjbLdCnzHCdLkIijFHLsaVA=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by PH0PR10MB5705.namprd10.prod.outlook.com (2603:10b6:510:146::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Wed, 3 Aug
 2022 23:09:28 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 23:09:28 +0000
Message-ID: <73b17906-fb89-5d92-ca31-ca21652b8335@oracle.com>
Date:   Wed, 3 Aug 2022 16:09:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
 <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
 <c77aa133-54ad-1578-aae3-031432cc9b36@oracle.com>
 <CACGkMEuUVicQX87PDCO87pckAg5EMQ9OGura2J35DaR0T=COfw@mail.gmail.com>
 <a2b2fe74-4633-2911-b953-25fcb8e81665@oracle.com>
 <213dec42-bd3d-2b5c-9003-276bc2a9f649@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <213dec42-bd3d-2b5c-9003-276bc2a9f649@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::26) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87cec100-d1b0-423d-bbcf-08da75a536f8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5705:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4n9VTSr7wrLMKYWS8DIGvcjKrbcR20m6SK7CBRxpExXF/ODTOD/8RA62th1bcTV21GIMwfQb3n/1pXhtib3DS55H+XigF0trsqqqzuBirriBZdB+VI9CFOrExu0nkUb18vR4T1KhEjv/COz+pQc4yC2+m0LC5o5PjP4qGqvFqWtjwi5FBc5cuM8BRJOQlL1SD5Y9qhCgQeI6Q7ho7caprXwl3+bQiCHIFf2TVk665E4AjNaZJFD1f4PrsXVefQvwsfbariMbOkzkJmOyC2+7OtbcPN8R6ouB4ZoEsxoXpL5XfxnpHefQxWnpgU8g5aCfssiM4zNeSUGOTcAGSZm4Nx2vpS3sP5A7SJZ2ocHSbN48AJrT7gaQEj/rPSvVpOQr5TRDXL4G6QKb/RFGOaEwl2K/upolMIs7LrVseNoD7p8tlIpBEY70yA5GKWB5H0uIQfKZxzcN885JE5trlR9j1B9EgjDzeOzkfDp7FH+FMSx9amlUMyCxdY1KKiEYMMEe/23U3tT5PSrmgYM3EMrFp3KOolmKBTcVYrFVU9z/9CS67DHGQnPjXUT0H6yI0Psfp3X0bSEOM9Yf3e7JMuAbgG0CHswZ6jJXPTnEb87esifSqAbEsCCGljuwmzYIp2roa2U0Xal2C08D+1T+1n5bzUztDWEVcTkGG1hgUGKMHixYZ7zlFgjxRlOEcHf4b//ELXAIzDHS7uU4H6GnqMHlpjDhOeW2IDe/Rw+LQskaZ48P2TsdMCAUE27qnVGPLydg0grr8eAMWCAHRGyZEtYMoLG/ktmyYyw2JdMp/rxV8YAIgo2JWjCpGrqtcMb8t+umNhox2tVadU8KaRYfOGwCUcZt/C98fTkFT6RSuXRUKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(366004)(396003)(136003)(86362001)(31686004)(36756003)(30864003)(83380400001)(478600001)(31696002)(41300700001)(6666004)(6486002)(110136005)(966005)(8936002)(2906002)(54906003)(66946007)(66476007)(66556008)(4326008)(8676002)(316002)(2616005)(5660300002)(6506007)(36916002)(6512007)(53546011)(38100700002)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnpheGpiQ2YwMnJlbjNMRks3bzEzMURjZDFsQ242NHhIUGxFMmw0UDgydTc4?=
 =?utf-8?B?akR3dTdIaHRKQVZCWEI3ZXRaQmV2Slh5T2kvRWlsNWhZSlRxaDkyMDlpTWxw?=
 =?utf-8?B?bkEyL21FMTZxOEdHVjhLeS9Mc3Q1TlZkUGFxclY4a3lhK2Q4cFJBQzBhTVhz?=
 =?utf-8?B?Rmh3RzVIUndlTDF4bDc1NHRYbnpqYmVuZjUzRDVULzBlY1lKRWR4Ky9Db1Np?=
 =?utf-8?B?UzV0ZythR0t1QVViSUpYM2NZajYyWFVGYVlJZDVHYmordStQWWFIY0kyUDVz?=
 =?utf-8?B?N3RWVm9aZzR4L2RwWGNhRVg2aDNxaGlWUGRwTkp0ZGx3SHQ5aWpQRDAyejFi?=
 =?utf-8?B?ajVJcEo3MHlmVTE0U0d0ME94Y1drcVlxdGZqZXlBSFZsQ0JuVUt4c01Ja3pP?=
 =?utf-8?B?OU9mUzJ2cVlRQTBSQmhaYmkybHZ0MldGRkJSbkxLbWwxSndhQ2IyV2w2MmZn?=
 =?utf-8?B?WmZxMVBYN0pyNmswRVFnT1BLYVNVenRsZi9LNHRBU1ZqQzhkcElUK0ZiVUcr?=
 =?utf-8?B?cmdGemEzNTNwRkNJb2JQRTRCSGhCbDVXbm1GUFlQMWhUc0VadGwxS3lRQ2Fl?=
 =?utf-8?B?S29nV3ZtK1JnU1UrY2h6V2JMSGM2akFZdnpUZGxRK2tUckQxeWRtTE82RnMz?=
 =?utf-8?B?NUZPVnBzSlVva1F3MEIvMTlIa29MT0E1NDBTOVh5YnFFV1NVR3d5UkFzaVZT?=
 =?utf-8?B?M0hqQ245WlJLd2d1Smk0enlxaW5CdWt5dlBpa0Zhblk5T3V6TG40VHBMaXhX?=
 =?utf-8?B?Z2YzQ0QyZUJrMkFwNlllWFpwcEVHdzJWSW9xeVgvYVZzcDVZRDdnK2NMdzlu?=
 =?utf-8?B?SkZWRU00VlFHSGJTSFJhQlM4NDRVak9ROUVmQTZCVmJ3QXYrV3BKQkljWHVW?=
 =?utf-8?B?YTI1WTh4YWtQUnlsV2Z4WWVFVFE3NUVaT09Gb0lVQ2pNVHlQandzbElaWjI1?=
 =?utf-8?B?T2xnQ1N3QmUwNS8yZ29scTd0aGV5VnQzaFpVTkM3Mk9DYUNYZExJVE5DV3hp?=
 =?utf-8?B?eklFYjA0ZStMaFRjOWt0ZnhJbUpWem5GeDhWZkVkbzRGUENWdWdWbmI3T09j?=
 =?utf-8?B?ZTJwK3dZelFvdVgzV3UvaElEOUNJZDQrRnNMcHdTbXY0cXphZDBWa04vMVMz?=
 =?utf-8?B?NmplbGR5Sjk2eFhPbXdDY3Q0a09DWmxHclRHWWlZL3pOaXBDN1BNYWg4WUJR?=
 =?utf-8?B?MGdYZmloRGlybEFXUldibytqR250MGFrRnhGTEpUdTFKL1pTVGhlQTRGcVMz?=
 =?utf-8?B?S1c5bm9EVVFrY0tWa2tVRFJGU3ZRM0pwZUVJQlQ3WUFxU0pFSElqTVFPV0F2?=
 =?utf-8?B?dThPeTkrdzlVbExQYTIzNFZUc3NNRHpIaVhWd2o5WU9EUzVyREdhS2NnSVZQ?=
 =?utf-8?B?VkpxZDR1VEVHZGV6czU0RVNzTFFUdDFEcEZuS0dhRnozUjdPUkMwZ3B2bzFB?=
 =?utf-8?B?eS80c01rQi83NnlzOGlOMXN3U1ZIUm8xMVQzVjdqcUs0RDhCVVBxS2dZayty?=
 =?utf-8?B?WXozS1JDYjUvVWVmbXZTdEtPWnplMkRJczR2eUl0QVJhUXIxR05PYTNNMnF0?=
 =?utf-8?B?aFU2dEVpbEkyVFdlczIyTm4yRytDbWZNSzEyY3V0OHhrZWsxUjUvUlBmSmZO?=
 =?utf-8?B?Ulp5N3ZWbEhsLzQxb1JqdGRJblJiRXlSaWFpQ2xGaitOR0txWHdVbkQxSTRO?=
 =?utf-8?B?YnNRTlB0RlpiK1ZNalVmMzRLZmNXYnBjdEhQakhTcGJTRnVReks5MmlHa3JS?=
 =?utf-8?B?amVoNlJlbDdKMktxVXp5SVhneUZwR25yV2U4anI3Nkx5bms1dlRpck1wZjFW?=
 =?utf-8?B?WS9iejJTSWc5S2JIQVBhRUdsK296Rzd1NTZiS01VRnFLc0tJSUoyc0VRREdp?=
 =?utf-8?B?RHFJZkVTK3JFeU9waTBtTUdiVU1rTzIyYmpMWFhYOXFmS2c2R1FIelpxRys0?=
 =?utf-8?B?UThQTjZxVzBKVmg5b1FvWFpCODRoUWhjcjlsMmRrV3Zvd1RoWXVwTkV0eUZ1?=
 =?utf-8?B?UUJlZVNaL2VtSDNGRDRhck9uVkFiQ0p3OGwzb2FNbVJGS3hvdlQ1M21FWDhr?=
 =?utf-8?B?QjFSSCtBb1RSZ3hDRFJLTk15WFlkTkM4eEY4TkNZdGpmRjFWd0U0K2Njd2VH?=
 =?utf-8?Q?/m+JFUUTUwIUzJASYkCTLillM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cec100-d1b0-423d-bbcf-08da75a536f8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 23:09:28.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEsfISeSgSADrGpUE/N5g5aZiDazSCiJ87eutvT7YhguZ/WbQLPnXIUfQ6+wlJPt8MVCA2eUOOYrTiFdLx5Ycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5705
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_06,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030097
X-Proofpoint-ORIG-GUID: BWRNT1MOggW_SVgBWBWm8iWpVKdOrsPm
X-Proofpoint-GUID: BWRNT1MOggW_SVgBWBWm8iWpVKdOrsPm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2022 7:30 PM, Zhu, Lingshan wrote:
>
>
> On 8/3/2022 9:26 AM, Si-Wei Liu wrote:
>>
>>
>> On 8/1/2022 11:33 PM, Jason Wang wrote:
>>> On Tue, Aug 2, 2022 at 6:58 AM Si-Wei Liu <si-wei.liu@oracle.com> 
>>> wrote:
>>>>
>>>>
>>>> On 8/1/2022 3:53 PM, Si-Wei Liu wrote:
>>>>>
>>>>> On 7/31/2022 9:44 PM, Jason Wang wrote:
>>>>>> 在 2022/7/30 04:55, Si-Wei Liu 写道:
>>>>>>>
>>>>>>> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>>>>>>>
>>>>>>>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>>>>>>>
>>>>>>>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>>>>>>>
>>>>>>>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>>>>>>>
>>>>>>>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>>>>>>>> Sorry to chime in late in the game. For some reason I 
>>>>>>>>>>>>> couldn't
>>>>>>>>>>>>> get to most emails for this discussion (I only subscribed to
>>>>>>>>>>>>> the virtualization list), while I was taking off amongst the
>>>>>>>>>>>>> past few weeks.
>>>>>>>>>>>>>
>>>>>>>>>>>>> It looks to me this patch is incomplete. Noted down the 
>>>>>>>>>>>>> way in
>>>>>>>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>>>>>>>           features = vdev->config->get_driver_features(vdev);
>>>>>>>>>>>>>           if (nla_put_u64_64bit(msg,
>>>>>>>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>>>>>>> VDPA_ATTR_PAD))
>>>>>>>>>>>>>                   return -EMSGSIZE;
>>>>>>>>>>>>>
>>>>>>>>>>>>> Making call to .get_driver_features() doesn't make sense when
>>>>>>>>>>>>> feature negotiation isn't complete. Neither should present
>>>>>>>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill()
>>>>>>>>>>>>> probably should not show before negotiation is done - it
>>>>>>>>>>>>> depends on driver features negotiated.
>>>>>>>>>>>> I have another patch in this series introduces device_features
>>>>>>>>>>>> and will report device_features to the userspace even features
>>>>>>>>>>>> negotiation not done. Because the spec says we should allow
>>>>>>>>>>>> driver access the config space before FEATURES_OK.
>>>>>>>>>>> The config space can be accessed by guest before features_ok
>>>>>>>>>>> doesn't necessarily mean the value is valid. You may want to
>>>>>>>>>>> double check with Michael for what he quoted earlier:
>>>>>>>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC,
>>>>>>>>>> vDPA kernel should not return a mac to the userspace, there is
>>>>>>>>>> not a default value for mac.
>>>>>>>>> Then please show us the code, as I can only comment based on your
>>>>>>>>> latest (v4) patch and it was not there.. To be honest, I don't
>>>>>>>>> understand the motivation and the use cases you have, is it for
>>>>>>>>> debugging/monitoring or there's really a use case for live
>>>>>>>>> migration? For the former, you can do a direct dump on all config
>>>>>>>>> space fields regardless of endianess and feature negotiation
>>>>>>>>> without having to worry about validity (meaningful to present to
>>>>>>>>> admin user). To me these are conflict asks that is impossible to
>>>>>>>>> mix in exact one command.
>>>>>>>> This bug just has been revealed two days, and you will see the
>>>>>>>> patch soon.
>>>>>>>>
>>>>>>>> There are something to clarify:
>>>>>>>> 1) we need to read the device features, or how can you pick a
>>>>>>>> proper LM destination
>>>>>>
>>>>>> So it's probably not very efficient to use this, the manager layer
>>>>>> should have the knowledge about the compatibility before doing
>>>>>> migration other than try-and-fail.
>>>>>>
>>>>>> And it's the task of the management to gather the nodes whose 
>>>>>> devices
>>>>>> could be live migrated to each other as something like "cluster"
>>>>>> which we've already used in the case of cpuflags.
>>>>>>
>>>>>> 1) during node bootstrap, the capability of each node and devices 
>>>>>> was
>>>>>> reported to management layer
>>>>>> 2) management layer decide the cluster and make sure the migration
>>>>>> can only done among the nodes insides the cluster
>>>>>> 3) before migration, the vDPA needs to be provisioned on the 
>>>>>> destination
>>>>>>
>>>>>>
>>>>>>>> 2) vdpa dev config show can show both device features and driver
>>>>>>>> features, there just need a patch for iproute2
>>>>>>>> 3) To process information like MQ, we don't just dump the config
>>>>>>>> space, MST has explained before
>>>>>>> So, it's for live migration... Then why not export those config
>>>>>>> parameters specified for vdpa creation (as well as device feature
>>>>>>> bits) to the output of "vdpa dev show" command? That's where device
>>>>>>> side config lives and is static across vdpa's life cycle. "vdpa dev
>>>>>>> config show" is mostly for dynamic driver side config, and the
>>>>>>> validity is subject to feature negotiation. I suppose this should
>>>>>>> suit your need of LM, e.g.
>>>>>>
>>>>>> I think so.
>>>>>>
>>>>>>
>>>>>>> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 
>>>>>>> 2000
>>>>>>> $ vdpa dev show vdpa1
>>>>>>> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs
>>>>>>> 15 max_vq_size 256
>>>>>>>    max_vqp 7 mtu 2000
>>>>>>>    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS
>>>>>>> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>>>>>
>>>>>> Note that the mgmt should know this destination have those
>>>>>> capability/features before the provisioning.
>>>>> Yes, mgmt software should have to check the above from source.
>>>> On destination mgmt software can run below to check vdpa mgmtdev's
>>>> capability/features:
>>>>
>>>> $ vdpa mgmtdev show pci/0000:41:04.3
>>>> pci/0000:41:04.3:
>>>>     supported_classes net
>>>>     max_supported_vqs 257
>>>>     dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS 
>>>> CTRL_VQ
>>>> MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>> Right and this is probably better to be done at node bootstrapping for
>>> the management to know about the cluster.
>> Exactly. That's what mgmt software is supposed to do typically.
> I think this could apply to both mgmt devices and vDPA devices:
> 1)mgmt device, see whether the mgmt device is capable to create a vDPA 
> device with a certain feature bits, this is for LM
> 2)vDPA device, report the device features, it is for normal operation
Can you elaborate the use case "for normal operations"? Then it has 
nothing to do with LM for sure, correct?

Noted for the LM case, just as Jason indicated, it's not even *required* 
for the mgmt software to gather the device features through "vdpa dev 
show" on source host *alive* right before live migration is started. 
Depending on the way how it is implemented, the mgmt software can well 
collect device capability on boot strap time, or may well save the vdpa 
device capability/config in persistent store ahead of time, say before 
any VM is to be launched. Then with all such info collected for each 
cluster node, mgmt software is able to get its own way to infer and sort 
out the live migration compatibility between nodes. I'm not sure which 
case you would need to check the device features, but in case you need 
it, it'd be better live in "vdpa dev show" than "vdpa dev config show".

Thanks,
-Siwei

>
> Thanks,
> Zhu Lingshan
>>
>> Thanks,
>> -Siwei
>>
>>>
>>> Thanks
>>>
>>>>>>
>>>>>>> For it to work, you'd want to pass "struct vdpa_dev_set_config" to
>>>>>>> _vdpa_register_device() during registration, and get it saved there
>>>>>>> in "struct vdpa_device". Then in vdpa_dev_fill() show each field
>>>>>>> conditionally subject to "struct vdpa_dev_set_config.mask".
>>>>>>>
>>>>>>> Thanks,
>>>>>>> -Siwei
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>>> Thanks
>>>>>>>> Zhu Lingshan
>>>>>>>>>>>> Nope:
>>>>>>>>>>>>
>>>>>>>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>>>>>>>
>>>>>>>>>>>> ...
>>>>>>>>>>>>
>>>>>>>>>>>> For optional configuration space fields, the driver MUST check
>>>>>>>>>>>> that the corresponding feature is offered
>>>>>>>>>>>> before accessing that part of the configuration space.
>>>>>>>>>>> and how many driver bugs taking wrong assumption of the 
>>>>>>>>>>> validity
>>>>>>>>>>> of config space field without features_ok. I am not sure what
>>>>>>>>>>> use case you want to expose config resister values for before
>>>>>>>>>>> features_ok, if it's mostly for live migration I guess it's
>>>>>>>>>>> probably heading a wrong direction.
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Last but not the least, this "vdpa dev config" command was 
>>>>>>>>>>>>> not
>>>>>>>>>>>>> designed to display the real config space register values in
>>>>>>>>>>>>> the first place. Quoting the vdpa-dev(8) man page:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> vdpa dev config show - Show configuration of specific device
>>>>>>>>>>>>>> or all devices.
>>>>>>>>>>>>>> DEV - specifies the vdpa device to show its 
>>>>>>>>>>>>>> configuration. If
>>>>>>>>>>>>>> this argument is omitted all devices configuration is 
>>>>>>>>>>>>>> listed.
>>>>>>>>>>>>> It doesn't say anything about configuration space or register
>>>>>>>>>>>>> values in config space. As long as it can convey the config
>>>>>>>>>>>>> attribute when instantiating vDPA device instance, and more
>>>>>>>>>>>>> importantly, the config can be easily imported from or
>>>>>>>>>>>>> exported to userspace tools when trying to reconstruct vdpa
>>>>>>>>>>>>> instance intact on destination host for live migration, IMHO
>>>>>>>>>>>>> in my personal interpretation it doesn't matter what the
>>>>>>>>>>>>> config space may present. It may be worth while adding a new
>>>>>>>>>>>>> debug command to expose the real register value, but that's
>>>>>>>>>>>>> another story.
>>>>>>>>>>>> I am not sure getting your points. vDPA now reports device
>>>>>>>>>>>> feature bits(device_features) and negotiated feature
>>>>>>>>>>>> bits(driver_features), and yes, the drivers features can be a
>>>>>>>>>>>> subset of the device features; and the vDPA device features 
>>>>>>>>>>>> can
>>>>>>>>>>>> be a subset of the management device features.
>>>>>>>>>>> What I said is after unblocking the conditional check, you'd
>>>>>>>>>>> have to handle the case for each of the vdpa attribute when
>>>>>>>>>>> feature negotiation is not yet done: basically the register
>>>>>>>>>>> values you got from config space via the
>>>>>>>>>>> vdpa_get_config_unlocked() call is not considered to be valid
>>>>>>>>>>> before features_ok (per-spec). Although in some case you may 
>>>>>>>>>>> get
>>>>>>>>>>> sane value, such behavior is generally undefined. If you desire
>>>>>>>>>>> to show just the device_features alone without any config space
>>>>>>>>>>> field, which the device had advertised *before feature
>>>>>>>>>>> negotiation is complete*, that'll be fine. But looks to me this
>>>>>>>>>>> is not how patch has been implemented. Probably need some more
>>>>>>>>>>> work?
>>>>>>>>>> They are driver_features(negotiated) and the
>>>>>>>>>> device_features(which comes with the device), and the config
>>>>>>>>>> space fields that depend on them. In this series, we report both
>>>>>>>>>> to the userspace.
>>>>>>>>> I fail to understand what you want to present from your
>>>>>>>>> description. May be worth showing some example outputs that at
>>>>>>>>> least include the following cases: 1) when device offers features
>>>>>>>>> but not yet acknowledge by guest 2) when guest acknowledged
>>>>>>>>> features and device is yet to accept 3) after guest feature
>>>>>>>>> negotiation is completed (agreed upon between guest and device).
>>>>>>>> Only two feature sets: 1) what the device has. (2) what is 
>>>>>>>> negotiated
>>>>>>>>> Thanks,
>>>>>>>>> -Siwei
>>>>>>>>>>> Regards,
>>>>>>>>>>> -Siwei
>>>>>>>>>>>
>>>>>>>>>>>>> Having said, please consider to drop the Fixes tag, as 
>>>>>>>>>>>>> appears
>>>>>>>>>>>>> to me you're proposing a new feature rather than fixing a 
>>>>>>>>>>>>> real
>>>>>>>>>>>>> issue.
>>>>>>>>>>>> it's a new feature to report the device feature bits than only
>>>>>>>>>>>> negotiated features, however this patch is a must, or it will
>>>>>>>>>>>> block the device feature bits reporting. but I agree, the fix
>>>>>>>>>>>> tag is not a must.
>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>> -Siwei
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Users may want to query the config space of a vDPA device,
>>>>>>>>>>>>>>> to choose a
>>>>>>>>>>>>>>> appropriate one for a certain guest. This means the users
>>>>>>>>>>>>>>> need to read the
>>>>>>>>>>>>>>> config space before FEATURES_OK, and the existence of 
>>>>>>>>>>>>>>> config
>>>>>>>>>>>>>>> space
>>>>>>>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The spec says:
>>>>>>>>>>>>>>> The device MUST allow reading of any device-specific
>>>>>>>>>>>>>>> configuration field
>>>>>>>>>>>>>>> before FEATURES_OK is set by the driver. This includes
>>>>>>>>>>>>>>> fields which are
>>>>>>>>>>>>>>> conditional on feature bits, as long as those feature bits
>>>>>>>>>>>>>>> are offered by the
>>>>>>>>>>>>>>> device.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only
>>>>>>>>>>>>>>> if FEATURES_OK)
>>>>>>>>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>>>>>>>> And
>>>>>>>>>>>>>> It should be in format
>>>>>>>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration 
>>>>>>>>>>>>>> only if
>>>>>>>>>>>>>> FEATURES_OK")
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Please use checkpatch.pl script before posting the 
>>>>>>>>>>>>>> patches to
>>>>>>>>>>>>>> catch these errors.
>>>>>>>>>>>>>> There is a bot that looks at the fixes tag and identifies 
>>>>>>>>>>>>>> the
>>>>>>>>>>>>>> right kernel version to apply this fix.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>    drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>>>>>>>    1 file changed, 8 deletions(-)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c 
>>>>>>>>>>>>>>> index
>>>>>>>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct 
>>>>>>>>>>>>>>> vdpa_device
>>>>>>>>>>>>>>> *vdev,
>>>>>>>>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>>>>>>>>        u32 device_id;
>>>>>>>>>>>>>>>        void *hdr;
>>>>>>>>>>>>>>> -    u8 status;
>>>>>>>>>>>>>>>        int err;
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> down_read(&vdev->cf_lock);
>>>>>>>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features 
>>>>>>>>>>>>>>> negotiation not
>>>>>>>>>>>>>>> completed");
>>>>>>>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>>>>>>>> -        goto out;
>>>>>>>>>>>>>>> -    }
>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>>        hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family,
>>>>>>>>>>>>>>> flags,
>>>>>>>>>>>>>>> VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>>>>>>>        if (!hdr) {
>>>>>>>>>>>>>>> -- 
>>>>>>>>>>>>>>> 2.31.1
>>>>>>>>>>>>>> _______________________________________________
>>>>>>>>>>>>>> Virtualization mailing list
>>>>>>>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!NzOv5Ew_Z2CP-zHyD7RsUoStLZ54KpB21QyuZ8L63YVPLEGDEwvcOSDlIGxQPHY-DMkOa9sKKZdBSaNknMU$ 
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>
>

