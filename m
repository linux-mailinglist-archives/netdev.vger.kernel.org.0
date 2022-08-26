Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050585A2498
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbiHZJhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343852AbiHZJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:37:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC4A9D8F6;
        Fri, 26 Aug 2022 02:37:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q7XjqH028479;
        Fri, 26 Aug 2022 09:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kbRKdHeyPzqFBrF/6dcTcPGxIshS7HsVkPl/zNBzfes=;
 b=soWTotm+94/pXvkmjgRbAulQgfpROjux3QRTx58oI6pjnkJQFFANcy+V93d6kOojXzmF
 IcTmH1Cq24GIF3BdnyA34XHMQvg8HoIzpVNHfzUcfMGwsT/rh8ObGpKDVY8zkatvNDq2
 89wvYMfHRYTRJxhFM9s3U81yWWijEKtoBC9F2k4vU+wRrJSLsWTOFqhh8i80S3c9unjn
 moXMJyCu86mWnU7S4Y/h7bOhOayaW8uLMPgkRLHBhHwUSaL4XEyX6KTYFHC1sc39pkff
 qHPngqSkG2T6LNTDWTooC9yZkCV3eRidCQnDY+BebJz8SUZbZK2Saofk3ummcBqsNuL0 uA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w241686-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 09:37:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q8PGVq034564;
        Fri, 26 Aug 2022 09:37:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4nh2ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 09:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEj2MdsgQ4/ub+ZlVGdvK5CVxjdS0kshu2qh8Lvg0/Lfe/VVW2TCZYrZFTY2oMf3g8Yqqp1yGSNbm0pnDrtI2AwuWlmrMF2gabsdnA+kqr/SEhYyGEkUQbskAT/gjATs+sMUq5AXs1QRQolM5hV/rJ8xe9V6nzYJctGu49l3nQN1EVtHn5QYxciuA9a24VUC/CfPwZ8pXOoAHAlTkqAehgN9OsB8zKq5DapmjQWutlhBp1/PdSzHAlTZd/MsctkwfuMFf5LtlwBwzL71jFzQXZy8GyhCDRbu0OPoDlhVWM4xNWYsP0wmq44Ez89IK5LDGhTXi6LXYyI905jwiOYLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbRKdHeyPzqFBrF/6dcTcPGxIshS7HsVkPl/zNBzfes=;
 b=DMLPYVraAJ/zI/gK1frDIxVGkewWXcB5sBYwdJXVdjF+7U2bP8v2oMJl8W8k+C9NiY1g/8gG0infMIKm6zbZfOaml312b5KEyh4UDhdI8WBW02y5uqlhVHfn3nDrwMbNsLGv1q8XaCLiOBkhLmbLPoV6/eFvKtOitoIuBviwBnOjP0hfjuFAEq6+szI4chFvbjKVhoIhBLYM6p2gmbAIeb1ZvK/r90Vy0gLoV3h1QZlGwAqW1B2nWZ9mvPGXiE1x28UTU+c8kczWu4Vnuua491h5c89QFYjQy7ZPzfzDI3uhtnlcWELyMczZz60ACjwGDKKsq87puUOZh3kjdQK+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbRKdHeyPzqFBrF/6dcTcPGxIshS7HsVkPl/zNBzfes=;
 b=Bwuc1X+5fFg001s586R9jYIlGOnanXKRBstY0/v/zhgmajEFKYFmaZ7gtQV05eKv254mqZxNDRFCP+rEqBqo7srs2SxLXXKxYbO8BpctVxcZ334uFyUoz+GWz2ebvCPFolfezvfnN1WGRgiiMcXZJfVnRkZ4mPs8vw/Ewte48d0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR1001MB2338.namprd10.prod.outlook.com (2603:10b6:405:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Fri, 26 Aug
 2022 09:37:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%4]) with mapi id 15.20.5546.021; Fri, 26 Aug 2022
 09:37:34 +0000
Message-ID: <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
Date:   Fri, 26 Aug 2022 10:37:26 +0100
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-5-yishaih@nvidia.com>
 <20220825132701.07f9a1c3.alex.williamson@redhat.com>
 <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
 <20220825171532.0123cbac.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220825171532.0123cbac.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0166.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2852341d-5488-4596-1e7d-08da87469aa6
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2338:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EW1rBbmRMbPhwvwP7EF8dOC2rh/jutKMFyS4RArsRRDhCUOAiRZ/lqHM28mfJ4dC0BSFRfAcpg6dZ6ljjAyy+wtsrAVEU9WIIn3w0RLCykB9kDFBoUTpO6/U6WWpR2A8ktkqkFb/18IJKF2QbR7xtUbqFAibaU1VGeuwJbG9SOCpTtVEJlkwjo7cVwcUPSl5uHqQohrVhSvAnBM/rq/gogqC1Pj5GX8cjnKmpYalNBNqzIC/3r5HluXwiNW6cWWMyxV++mvqood9mp9u2tL3p6xQhUgrvArUOdV10NaW+7Czv6kIBNiYV4+Z45d2rzZRzqi6neX9MwsuLcLefo1PhdOJrjmA+Z6JsmL4IyeMinxpKfJ3lKoDhWVDJgaw1wl0qN2wmPkzKrwxQ7nCM5EDZBzR4Gqp4VrwKL1JHWyaL7A+SsygUBi85pql22QWJH+rIuz12t35CevK4sOkK9tZq87WRoQQ2OuB7M9ZdvulA85MPu41oiWSu9+fUUAAkXcRCuRPqjslSW0z84xsSbqBEF95IDLMlXVO9g8SmevjAtMXTvT/sgLV8pxal/6UV4H7NUQ/HQtPEsfT7IfcAtyEFqtcme5pRvsRFsd2abMwUQ7dzcvqg9FxT/enAG1parQCBkXPi1QcnMfCkvozPh+pGDJSX0wb+EtEjaveXTy/YeCvudV1hRtq1GhQqta4vxuuIhm9O4PRAuudrZ7sVYI8kbpT9fn8phAwU1Uhp5eGe5QO06o4jcAjI2vCyLrQPRho7MFYZhEYTbE94f9pPMWhGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(39860400002)(396003)(346002)(41300700001)(36756003)(6506007)(8676002)(6486002)(83380400001)(6666004)(31686004)(186003)(2616005)(26005)(8936002)(53546011)(316002)(6916009)(38100700002)(66946007)(66476007)(5660300002)(66556008)(478600001)(7416002)(86362001)(31696002)(30864003)(6512007)(4326008)(2906002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmhFMTI0SURHM2VUVUZIOTNiek1kbVZOYlpkWXBLUkpDbTBiZFE1L1ZyeU9C?=
 =?utf-8?B?YUFkaGU4ZHhBS1lvcWZ1ZkRzVGlrNWdiNEJiYk9mQXdoYzJlK1k0R3FGREUw?=
 =?utf-8?B?cUd0SHhVd2FRblA2SXpZUlo0UnVZZm1uS0lhejZjb3FDUXhaRlFTS056dHZo?=
 =?utf-8?B?Y1lxTVVkc2JkWWtCOENoQ3Vvd2pnRXhuMGRGTGNLSk1IWmlVeHY5L1lKd0ZC?=
 =?utf-8?B?eGFtUmFxS1djNWl6amZkMC80Tmh3d0k0SDRmMWwvMGtrZ0E0KzhMMlJxQXl4?=
 =?utf-8?B?OFRFejhaQnJOT0FkR2N4bzc2RG9MbTAwMkZucFU1ZlhweFlTQjJoWmEybGdY?=
 =?utf-8?B?eVp3b1lTSURrOXh3a2F4d1p3aDU3WXdjNjJTWS85S1JoaWRqSHpXTmlyUCs2?=
 =?utf-8?B?MUw4NlBUZ1plaU9vQllsQmZ3VVFxY0hWK1hoMWdFNjlidDNDT0ZMczRscHFN?=
 =?utf-8?B?WHo4dmk5TUd2WWdyU1Jia2oxcUxaTEptbzlJSkkrdkVDRnJaQ05UUHJYanp4?=
 =?utf-8?B?REJybGRVbWMvZlZrTFhXQWNHSHVLTmlYY0RtY09qbWxGcEhCVEpKMFZ4akEz?=
 =?utf-8?B?MWlJRjhWblp2SlYxbHFBMGdoM1JITnpnaWdXQ1gremFobmpkZVREQ2ZEd2I0?=
 =?utf-8?B?NTV4em9IUWFacWtMR24zdlc5cGpOL0dHa3J4MjZNSHd4dmhPS2hJdXhTU0hX?=
 =?utf-8?B?ZWQzWnhUdU5vY3h5UUN0VURMTnpVZEdDTGJ5cEVsL1N0a0NCaWk0dVpZdXAy?=
 =?utf-8?B?QjRyL1Jyd3U1aDRTMmk1d3JhNTlaZWgvZ1ROc3R2RU9SZDlJQU1BR3gyb1Fo?=
 =?utf-8?B?VnVpNFZFYm9PMXVSUDVxK3JHQTNsdzNYVmJ1RVRjTzlWNFRudEUxaWw1Q3g1?=
 =?utf-8?B?L0xqaE9jMitjMEdoMHAwSWtTYUJ6VFZac0dQbGhCc0drZTl0d1VsWnlkZzhk?=
 =?utf-8?B?aXZoS29HdkdYVTZyRGhXWUdPbXRlSFZWYy9KbHFUY1hySGRRUkFvMHFPWE1E?=
 =?utf-8?B?dzdhekxJV0VFcCs5SW5MbFMxRDVybVVQT3BXb3ZWTkp4eVJTQndwb216Zk1O?=
 =?utf-8?B?VTdzK29VYm5LaHA2bXdvbEU5aHJnRDBpNjBXdHV3cVhkaTRQc1Y2alorcUU1?=
 =?utf-8?B?akRPUFlVMnJNY25tbEIwbVFDbFVwWnI4bjMrTHV3OGxub05rM3RuRHBHbDc1?=
 =?utf-8?B?OXhPaHR1RmFGWXFNZVV1QWIvTFV5aHRQMlVYT29ORzhmd0o4QVFVQVc2U0k4?=
 =?utf-8?B?SzlqZHhxYm1BU3BSSGszSHVFWk1ybGdwTmF4YkRvQ1ZWQWwydWRIWXFJa3NO?=
 =?utf-8?B?R1lsUWZVRnIzckU5TGl3SEp5OUNkSHJ2ZUlyTVZJTU9jYWtmTHFjQk1TNnVs?=
 =?utf-8?B?Wk8yNkhBbFkrMVA1ZndzSmdZSUZJS0JPd0s2eXdNUElYSllIdmdtOU5lZGp4?=
 =?utf-8?B?RngwOEdzMTNMYngyMU04enphZVNoT2JlRlBRcEpuSVhxdlp4anVtb2NBQjZN?=
 =?utf-8?B?RyswU1Q2UTJvbGhQekNKaXVlZFkza0s0UDFnL1VzQi84YUNuMDlFYVI4dGg4?=
 =?utf-8?B?eFRXMDB1WVJoN1JEcE9wSkhiQWJMT0E4RXdiZU1NanpKWE5WK2Rid3B6bTIw?=
 =?utf-8?B?eU1hampGamZRdTV2L25OL2dObjFQZVZHY01ISE54NjR4WTM3Qkk0Sm85UnND?=
 =?utf-8?B?RS83cExKUC9UTFJxQkdRU0toSjRKSVI5UXdhQVZpSzRRK1dYNE1MN3FPRXI3?=
 =?utf-8?B?REZTeVFqT3IzdEwyeE9NSlhJTlRlb1ZlZDg2UCsxUHljMlh0bzhJSldyS3Q2?=
 =?utf-8?B?U05TaEtlNGtZQTUreEpqd2VObWw1TnRTbWd4YkIxajFwZnhBdG1JelZYNWdr?=
 =?utf-8?B?WnUzeDBtdXFxamRjaHVYL1NXbmZMNVRCaGxBLzd6S3RHOVRubGp1NXl0ZXJJ?=
 =?utf-8?B?WGJuOEJmL0FvTlRTQVM4L3RpbFpTV1JpdHhncWcwNThSVHZNdGtCVGZjKzNp?=
 =?utf-8?B?N1hrMTVOcHdNS0FGTTk5c2dEbk1ibFZDNUg0cGNqbmRGMkliczdtTjFCVjVN?=
 =?utf-8?B?Ty9xUHNmNWUxTXR6R1FFamVJNlNJMG9lajM2ZEU5Q0RGL0FYSWtGQjk2dnk1?=
 =?utf-8?B?djQwT3VxMHZJdy9RL3dGa00rbEJLcWxSTVlCcWRIaTVmNnNIQzZyMjE4TkFm?=
 =?utf-8?B?cWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2852341d-5488-4596-1e7d-08da87469aa6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 09:37:34.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDQGgfHk/ap1XuXFjipxD93aan7g/hIekzi4NpsdRU5It5psCEhq2YpuWrnYMWPSTgT6WYzceK17DCA7jZICoc6AGiwaLPdenZn7ClWCPzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260038
X-Proofpoint-ORIG-GUID: o63L8JYZsa7weZ9pE15rrvA8ZuAn6FcH
X-Proofpoint-GUID: o63L8JYZsa7weZ9pE15rrvA8ZuAn6FcH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/22 00:15, Alex Williamson wrote:
> On Thu, 25 Aug 2022 23:24:39 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 8/25/22 20:27, Alex Williamson wrote:
>>> On Mon, 15 Aug 2022 18:11:03 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>>
>>>> The new facility adds a bunch of wrappers that abstract how an IOVA
>>>> range is represented in a bitmap that is granulated by a given
>>>> page_size. So it translates all the lifting of dealing with user
>>>> pointers into its corresponding kernel addresses backing said user
>>>> memory into doing finally the (non-atomic) bitmap ops to change
>>>> various bits.
>>>>
>>>> The formula for the bitmap is:
>>>>
>>>>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>>>>
>>>> Where 64 is the number of bits in a unsigned long (depending on arch)
>>>>
>>>> It introduces an IOVA iterator that uses a windowing scheme to minimize
>>>> the pinning overhead, as opposed to be pinning it on demand 4K at a  
>>>
>>> s/ be / /
>>>   
>> Will fix.
>>
>>>> time. So on a 512G and with base page size it would iterate in ranges of
>>>> 64G at a time, while pinning 512 pages at a time leading to fewer  
>>>
>>> "on a 512G" what?  The overall size of the IOVA range is somewhat
>>> irrelevant here and it's unclear where 64G comes from without reading
>>> deeper into the series.  Maybe this should be something like:
>>>
>>> "Assuming a 4K kernel page and 4K requested page size, we can use a
>>> single kernel page to hold 512 page pointers, mapping 2M of bitmap,
>>> representing 64G of IOVA space."
>>>   
>> Much more readable indeed. Will use that.
>>
>>>> atomics (specially if the underlying user memory are hugepages).
>>>>
>>>> An example usage of these helpers for a given @base_iova, @page_size, @length  
>>>
>>> Several long lines here that could be wrapped.
>>>   
>> It's already wrapped (by my editor) and also at 75 columns. I can do a
>> bit shorter if that's hurting readability.
> 
> 78 chars above, but git log indents by another 4 spaces, so they do
> wrap.  Something around 70/72 seems better for commit logs.
> 
OK, I'll wrap at 70.

>>>> and __user @data:
>>>>
>>>> 	ret = iova_bitmap_iter_init(&iter, base_iova, page_size, length, data);
>>>> 	if (ret)
>>>> 		return -ENOMEM;
>>>>
>>>> 	for (; !iova_bitmap_iter_done(&iter) && !ret;
>>>> 	     ret = iova_bitmap_iter_advance(&iter)) {
>>>> 		dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
>>>> 				   iova_bitmap_length(&iter));
>>>> 	}
>>>>
>>>> 	iova_bitmap_iter_free(&iter);
>>>>
>>>> An implementation of the lower end -- referred to above as dirty_reporter_ops
>>>> to exemplify -- that is tracking dirty bits would mark an IOVA as dirty
>>>> as following:
>>>>
>>>> 	iova_bitmap_set(&iter.dirty, iova, page_size);
>>>>
>>>> or a contiguous range (example two pages):
>>>>
>>>> 	iova_bitmap_set(&iter.dirty, iova, 2 * page_size);
>>>>
>>>> The facility is intended to be used for user bitmaps representing
>>>> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
>>>>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>> ---
>>>>  drivers/vfio/Makefile       |   6 +-
>>>>  drivers/vfio/iova_bitmap.c  | 224 ++++++++++++++++++++++++++++++++++++
>>>>  include/linux/iova_bitmap.h | 189 ++++++++++++++++++++++++++++++
>>>>  3 files changed, 417 insertions(+), 2 deletions(-)
>>>>  create mode 100644 drivers/vfio/iova_bitmap.c
>>>>  create mode 100644 include/linux/iova_bitmap.h
>>>>
>>>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>>>> index 1a32357592e3..1d6cad32d366 100644
>>>> --- a/drivers/vfio/Makefile
>>>> +++ b/drivers/vfio/Makefile
>>>> @@ -1,9 +1,11 @@
>>>>  # SPDX-License-Identifier: GPL-2.0
>>>>  vfio_virqfd-y := virqfd.o
>>>>  
>>>> -vfio-y += vfio_main.o
>>>> -
>>>>  obj-$(CONFIG_VFIO) += vfio.o
>>>> +
>>>> +vfio-y := vfio_main.o \
>>>> +          iova_bitmap.o \
>>>> +
>>>>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>>>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>>>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
>>>> new file mode 100644
>>>> index 000000000000..6b6008ef146c
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/iova_bitmap.c
>>>> @@ -0,0 +1,224 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>>>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>>>> + */
>>>> +#include <linux/iova_bitmap.h>
>>>> +#include <linux/highmem.h>
>>>> +
>>>> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
>>>> +
>>>> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
>>>> +
>>>> +/*
>>>> + * Converts a relative IOVA to a bitmap index.
>>>> + * The bitmap is viewed an array of u64, and each u64 represents  
>>>
>>> "The bitmap is viewed as an u64 array and each u64 represents"
>>>   
>> Will use that.
>>
>>>> + * a range of IOVA, and the whole pinned pages to the range window.  
>>>
>>> I think this phrase after the comma is trying to say something about the
>>> windowed mapping, but I don't know what.
>>>   
>> Yes. doesn't add much in the context of the function.
>>
>>> This function provides the index into that u64 array for a given IOVA
>>> offset.
>>>   
>> I'll use this instead.
>>
>>>> + * Relative IOVA means relative to the iter::dirty base IOVA (stored
>>>> + * in dirty::iova). All computations in this file are done using
>>>> + * relative IOVAs and thus avoid an extra subtraction against
>>>> + * dirty::iova. The user API iova_bitmap_set() always uses a regular
>>>> + * absolute IOVAs.  
>>>
>>> So why don't we use variables that make it clear when an IOVA is an
>>> IOVA and when it's an offset?
>>>   
>> I was just sticking the name @offset to how we iterate towards the u64s
>> to avoid confusion. Should I switch to offset here I should probably change
>> @offset of the struct into something else. But I see you suggested something
>> like that too further below.
>>
>>>> + */
>>>> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
>>>> +					       unsigned long iova)  
>>>
>>> iova_bitmap_offset_to_index(... unsigned long offset)?
>>>   
>>>> +{OK.  
>>
>>>> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
>>>> +
>>>> +	return iova / (BITS_PER_TYPE(*iter->data) * pgsize);  
>>>
>>> Why do we name the bitmap "data" rather than "bitmap"?
>>>   
>> I was avoid overusing the word bitmap given structure is already called @bitmap.
>> At the end of the day it's a user data pointer. But I can call it @bitmap.
> 
> @data is not very descriptive, and finding a pointer to a bitmap inside
> a struct iova_bitmap feels like a fairly natural thing to me ;)
> 
OK

>>> Why do we call the mapped section "dirty" rather than "mapped"?  It's
>>> not necessarily dirty, it's just the window that's current mapped.
>>>   
>> Good point. Dirty is just what we tracked, but the structure ::dirty is closer
>> to representing what's actually mapped yes. I'll switch to mapped.
>>
>>>> +}
>>>> +
>>>> +/*
>>>> + * Converts a bitmap index to a *relative* IOVA.
>>>> + */
>>>> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
>>>> +					       unsigned long index)  
>>>
>>> iova_bitmap_index_to_offset()?
>>>   
>> ack
>>
>>>> +{
>>>> +	unsigned long pgshift = iter->dirty.pgshift;
>>>> +
>>>> +	return (index * BITS_PER_TYPE(*iter->data)) << pgshift;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Pins the bitmap user pages for the current range window.
>>>> + * This is internal to IOVA bitmap and called when advancing the
>>>> + * iterator.
>>>> + */
>>>> +static int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
>>>> +{
>>>> +	struct iova_bitmap *dirty = &iter->dirty;
>>>> +	unsigned long npages;
>>>> +	u64 __user *addr;
>>>> +	long ret;
>>>> +
>>>> +	/*
>>>> +	 * @offset is the cursor of the currently mapped u64 words  
>>>
>>> So it's an index?  I don't know what a cursor is.    
>>
>> In my "english" 'cursor' as a synonym for index yes.
>>
>>> If we start using
>>> "offset" to describe a relative iova, maybe this becomes something more
>>> descriptive, mapped_base_index?
>>>   
>> I am not very fond of long names, @mapped_index maybe hmm
>>
>>>> +	 * that we have access. And it indexes u64 bitmap word that is
>>>> +	 * mapped. Anything before @offset is not mapped. The range
>>>> +	 * @offset .. @count is mapped but capped at a maximum number
>>>> +	 * of pages.  
>>>
>>> @total_indexes rather than @count maybe?
>>>   
>> It's still a count of indexes, I thought @count was explicit already without
>> being too wordy. I can suffix with indexes if going with mapped_index. Or maybe
>> @mapped_count maybe
> 
> I was trying to get "index" in there somehow to make it stupid obvious
> that it's a count of indexes.
> 
OK, @total_index{es} then (probably drop the plural to keep suffix naming convention
as them being related)

>>>> +	 */
>>>> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
>>>> +			      sizeof(*iter->data), PAGE_SIZE);
>>>> +
>>>> +	/*
>>>> +	 * We always cap at max number of 'struct page' a base page can fit.
>>>> +	 * This is, for example, on x86 means 2M of bitmap data max.
>>>> +	 */
>>>> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
>>>> +	addr = iter->data + iter->offset;  
>>>
>>> Subtle pointer arithmetic.
>>>   
>>>> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
>>>> +				  FOLL_WRITE, dirty->pages);
>>>> +	if (ret <= 0)
>>>> +		return -EFAULT;
>>>> +
>>>> +	dirty->npages = (unsigned long)ret;
>>>> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
>>>> +	dirty->iova = iova_bitmap_iova(iter);  
>>>
>>> If we're operating on an iterator, wouldn't convention suggest this is
>>> an iova_bitmap_itr_FOO function?  mapped_iova perhaps.
>>>   
>>
>> Yes.
>>
>> Given your earlier comment, mapped iova is a bit more obvious.
>>
>>>> +
>>>> +	/*
>>>> +	 * offset of the page where pinned pages bit 0 is located.
>>>> +	 * This handles the case where the bitmap is not PAGE_SIZE
>>>> +	 * aligned.
>>>> +	 */
>>>> +	dirty->start_offset = offset_in_page(addr);  
>>>
>>> Maybe pgoff to avoid confusion with relative iova offsets.
>>>   
>> Will fix. And it's also convention in mm code, so I should stick with that.
>>
>>> It seems suspect that the length calculations don't take this into
>>> account.
>>>   
>> The iova/length/indexes functions only work over bit/iova "quantity" and indexing of it
>> without needing to know where the first bit of the mapped range starts. So the pgoff
>> is only important when we actually set bits on the bitmap i.e. iova_bitmap_set().
> 
> Ok
> 
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Unpins the bitmap user pages and clears @npages
>>>> + * (un)pinning is abstracted from API user and it's done
>>>> + * when advancing or freeing the iterator.
>>>> + */
>>>> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
>>>> +{
>>>> +	struct iova_bitmap *dirty = &iter->dirty;
>>>> +
>>>> +	if (dirty->npages) {
>>>> +		unpin_user_pages(dirty->pages, dirty->npages);
>>>> +		dirty->npages = 0;
>>>> +	}
>>>> +}
>>>> +
>>>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
>>>> +			  unsigned long iova, unsigned long length,
>>>> +			  unsigned long page_size, u64 __user *data)
>>>> +{
>>>> +	struct iova_bitmap *dirty = &iter->dirty;
>>>> +
>>>> +	memset(iter, 0, sizeof(*iter));
>>>> +	dirty->pgshift = __ffs(page_size);
>>>> +	iter->data = data;
>>>> +	iter->count = iova_bitmap_iova_to_index(iter, length - 1) + 1;
>>>> +	iter->iova = iova;
>>>> +	iter->length = length;
>>>> +
>>>> +	dirty->iova = iova;
>>>> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
>>>> +	if (!dirty->pages)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	return iova_bitmap_iter_get(iter);
>>>> +}
>>>> +
>>>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
>>>> +{
>>>> +	struct iova_bitmap *dirty = &iter->dirty;
>>>> +
>>>> +	iova_bitmap_iter_put(iter);
>>>> +
>>>> +	if (dirty->pages) {
>>>> +		free_page((unsigned long)dirty->pages);
>>>> +		dirty->pages = NULL;
>>>> +	}
>>>> +
>>>> +	memset(iter, 0, sizeof(*iter));
>>>> +}
>>>> +
>>>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
>>>> +{
>>>> +	unsigned long skip = iter->offset;
>>>> +
>>>> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Returns the remaining bitmap indexes count to process for the currently pinned
>>>> + * bitmap pages.
>>>> + */
>>>> +static unsigned long iova_bitmap_iter_remaining(struct iova_bitmap_iter *iter)  
>>>
>>> iova_bitmap_iter_mapped_remaining()?
>>>   
>> Yes.
>>
>>>> +{
>>>> +	unsigned long remaining = iter->count - iter->offset;
>>>> +
>>>> +	remaining = min_t(unsigned long, remaining,
>>>> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
>>>> +
>>>> +	return remaining;
>>>> +}
>>>> +
>>>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)  
>>>
>>> iova_bitmap_iter_mapped_length()?
>>>   
>> Yes.
>>
>> I don't particularly like long names, but doesn't seem to have better alternatives.
>>
>> Part of the reason the names look 'shortened' was because the object we pass
>> is already an iterator, so it's implicit that we only fetch the under-iteration/mapped
>> iova. Or that was at least the intention.
> 
> Yes, but that means you need to look at the function declaration to
> know that it takes an iova_bitmap_iter rather than an iova_bitmap,
> which already means it's not intuitive enough.
> 
OK

>>> Maybe it doesn't really make sense to differentiate the iterator from
>>> the bitmap in the API.  In fact, couldn't we reduce the API to simply:
>>>
>>> int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
>>> 		     size_t length, size_t page_size, u64 __user *data);
>>>
>>> int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
>>> 			 int (*fn)(void *data, dma_addr_t iova,
>>> 			 	   size_t length,
>>> 				   struct iova_bitmap *bitmap));
>>>
>>> void iova_bitmap_free(struct iova_bitmap *bitmap);
>>>
>>> unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
>>> 			      dma_addr_t iova, size_t length);
>>>
>>> Removes the need for the API to have done, advance, iova, and length
>>> functions.
>>>   
>> True, it would be simpler.
>>
>> Could also allow us to hide the iterator details enterily and switch to
>> container_of() from iova_bitmap pointer. Though, from caller, it would be
>> weird to do:
>>
>> struct iova_bitmap_iter iter;
>>
>> iova_bitmap_init(&iter.dirty, ....);
>>
>> Hmm, maybe not that strange.
>>
>> Unless you are trying to suggest to merge both struct iova_bitmap and
>> iova_bitmap_iter together? I was trying to keep them separate more for
>> the dirty tracker (IOMMUFD/VFIO, to just be limited to iova_bitmap_set()
>> with the generic infra being the one managing that iterator state in a
>> separate structure.
> 
> Not suggesting the be merged, but why does the embedded mapping
> structure need to be exposed to the API?  That's an implementation
> detail that's causing confusion and naming issues for which structure
> is passed and how do we represent that in the function name.  Thanks,

I wanted the convention to be that the end 'device' tracker (IOMMU or VFIO
vendor driver) does not have "direct" access to the iterator state. So it acesses
or modifies only the mapped bitmap *data*. The hardware tracker is always *provided*
with a iova_bitmap to set bits but it should not allocate, iterate or pin anything,
making things simpler for tracker.

Thus the point was to have a clear division between how you iterate
(iova_bitmap_iter* API) and the actual bits manipulation (so far only
iova_bitmap_set()) including which data structures you access in the APIs, thus
embedding the least accessed there (struct iova_bitmap).

The alternative is to reverse it and just allocate iter state in iova_bitmap_init()
and have it stored as a pointer say as iova_bitmap::iter. We encapsulate both and mix
the structures, which while not as clean but maybe this is not that big of a deal as
I thought it would be
