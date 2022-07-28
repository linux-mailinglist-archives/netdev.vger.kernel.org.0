Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C51583678
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiG1Blr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiG1Blq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:41:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E87C4F644
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:41:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RNONrn017513;
        Thu, 28 Jul 2022 01:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=AgRg191Yf/dNiLpN8psiCRKzs6ZIszTHNBI45fIBodg=;
 b=HLyrabpgzlP4OmsMT7sxR9EcNpLDHvctRnfMnx+N9Nay5OKFKrNbs1PVW0iKfGsYL21o
 jnRobBn7J4tNQj6VtrlsOn4gjMiR+gVg7LlpTwyx41pcVCZUp2n7hkS/SAt9a3CHFrTR
 i7e5w/Jog79BykVWRaCMhwfbNydAPG/Fg1fjFRu5HrXO0wffkKT/MQ7JwFEhQ4yDVcK5
 K6R0We1ibPb4aK0XwMC3P6fIc6fnkPv1HDCzknJJ2AwmLuB7BnWA0E5mO1O7Ho6MyKNI
 iBdkN8mb5BZH1zrWp7VqKK3nP5GZ55mx3SyIx/5I7GLTeXGo7dbbJXZrcpgScxHYCAho GA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg94gk6f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 01:41:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26RNTrve006173;
        Thu, 28 Jul 2022 01:41:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh65dq4g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 01:41:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSAGZZCz647buIVOYCiyOBSgWIR81kaon5HGGML2IF898UR8+xm7aXDpDsTpfgkPOL5jnx/e5aBXiKuL0shpP6vTMNZbfp4ZZVTnHNy+u1xd5r2Izoar3stU4YdhPXKTp0sc3zXkYmIBptSCoe/hV8BqsRrJTVkJrgNrSTkTRHEZuf8Omjk4MCkLmpiCKIPmXjrKvXv934cGa4rRXhMhx9YDBMVaFjra1EzY7aF+swHNQc1XsYH1iYcOCp6cPiDCqiK42TtVtD+oiejEtEucC75eQloqhI1k4x/m6BKU0Qar3+Multvg60qPwhVjZLCoqbql4uPurRnodyjb95spTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgRg191Yf/dNiLpN8psiCRKzs6ZIszTHNBI45fIBodg=;
 b=ElzzTMcPKdyXvSqFYh/7THnsqikdgOYRt8oWeR2M3JQ97wKWSF42xDqZ+CJc+SUXRWaCgs6tn3nAarwz1pXDPJ5c5eUNsEj+XD0xYh+GXpo3HWvbOAKLKG7QyVF9v+akVmm5WzRbqk5i0++gA4K0Ox1EJYAHLxS/BdSV0OEh6X1eC35NT9pApW/mPTkvw82mScHypHxOlWqVjiuHSXGBQEjbo8e0gnk5ucZ3l8T+K8ed80+ynAPeVFBF0j7PSsWMEHMdxsi/+FoUMg4L+/71+RotQpQKxfAxUARPFj3GUTZRxHqzUzJK67CjSfd7VG9VvezAfQswRTgYmwgiCjVkGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgRg191Yf/dNiLpN8psiCRKzs6ZIszTHNBI45fIBodg=;
 b=saXz4WmZh2ZCPBlJiF3sUOeJFjyRUg1nFvppIIf2pxfYoWOnwr3bf2dbEclLNEAcrbV1jy8Prdpq17z8Fr/XUN2mYPcgCjHO/Rh2yFY4cZ7ME2W+SWbkSxqSla0Yk8exz5ZEyEFQ1OTR8En5K5UQ8Lm3YoxFjMSFYetkZnO2LxE=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SA1PR10MB5821.namprd10.prod.outlook.com (2603:10b6:806:232::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 01:41:33 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 01:41:32 +0000
Message-ID: <e546e6c0-37bd-ee3e-76e5-def63a33f432@oracle.com>
Date:   Wed, 27 Jul 2022 18:41:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
 <20220727050102-mutt-send-email-mst@kernel.org>
 <6d5b03ee-5362-8534-5881-a34c9ea626f0@oracle.com>
 <939bc589-b3ad-d317-8b1d-6da58e4670c0@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <939bc589-b3ad-d317-8b1d-6da58e4670c0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:806:22::10) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 932da5ac-c899-4bbf-097f-08da703a4cf0
X-MS-TrafficTypeDiagnostic: SA1PR10MB5821:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4nOh5J+V113lLpA5qg+UEmcr/eQYLkjhLbuJpLz6w6g04jBDNN1hi0J0mrJzOV/1TDD6LPizOgM+cH+nCmPYg50FeI8AMHXdJOJ2E7r1oOihCOibxSIsjZLUj7L88kgR06ZRBAdAEbmjd8fN72TMHKT/vE8Db4PrKR/8JY4fLfCv11CYJLHoyhKf38FchjqYGT9OBltWz1rRUMvIOJ5S4b/yETJr0OoRqeK4iw4ujtvneVQzCtzFzyOwOGNwJI5Iqk3Jk7uP+dzf3wRyQEGixqv1aFvuUXYFdq6mRWmOJtSRn4v9XOfpUHhKSTz+6CylQbnrO4gAXDyYP8M/Vg1XK0D5kI+kev/bKemTOoZIZQelVYpzO/6JolivdEqERIIy9cduRhwtrkQYTRXcNQlBoj8wQ9GGDAEog4c8+ZSI/7IuEfZ5b9wSIclrU9QLF33LJzxWVc05HCS8upPOzqjwg5O2ojqglt3N0nfyolW2KYv8/I7Dy7SLrf89QOvB5NJKqeQbbHNJnhMWxUKRn+VzGVKrtyRkkMwIlVnK37mp7udIvigvkW+DEFVcx8iaJCZu5q1TP7cxQeDGHkBziUH08LXKlc1rE0fNkDu7nUb48196rG7KLUhcWit7J21UQ6s31U3e1vCnmg7yPUvAUiRQiaUp0kIxNM5xum3mtBOwN3G7FnSpf50fKWqxQH8Vjhgi3h9SmUqaYOI5QsvkVX3aRM0puvyJWrx/wlqQtbd/yI1aXYd2duqxbP+rwzIW4YehNCUdnHynDfWlhqtKer9qKN4/PKdEvibKftYwgg/IfrlRlWQceg8HyXoyIq/0GNQQBWfOuyBXB23+oi3MEdqmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(136003)(39860400002)(376002)(54906003)(5660300002)(31686004)(8936002)(66946007)(8676002)(66476007)(66556008)(86362001)(31696002)(110136005)(316002)(6666004)(6512007)(26005)(36756003)(2906002)(2616005)(53546011)(478600001)(41300700001)(6486002)(83380400001)(38100700002)(4326008)(6506007)(36916002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUdsK1luYWs5SWtVVjNEZndZRFdBTnpEMzhuRFFVUW0xOW1KSFU3L0M0UVlM?=
 =?utf-8?B?T2h0UXNjbmtCRExzaDVueHpWLytsN3BJTTZ6MG5TWlNsS1JrVlRXOFVraGlG?=
 =?utf-8?B?K3BkWnRPSy92TWVwR1N4cjdKT0x5SkNKU20xdUMrbnNwUms4MlFHcUo0Q2p2?=
 =?utf-8?B?UnFMV290dk0zSVlOYXJVQ1dYTWsrY3JERUN5VlJFUlI4UGhQdklqYmF6K3Az?=
 =?utf-8?B?MnJxS3ZHRHVXWW0rZEpqcFc2TytpQ0FhTVU5WHBLcW9iMFZiNW5hMU9IT1pL?=
 =?utf-8?B?TVhrYUtSR0ZieWRLdk05WmpsRlU3c3duR0tTOCtTSW1oeVFpMTJwYUF1NVRx?=
 =?utf-8?B?d0gvdUc4cFB1OTdBTCtSRzNxbXRhMHdZQ05wQzVYVDUzRThCQWlucTRabTU2?=
 =?utf-8?B?cnQrRWk1NGd6WWgyQ05Cc3VJWmM4OUNhZ29tYkl5MjRHS3pmMzUxK2t6Wmtr?=
 =?utf-8?B?d0N3UHAxbXZSTjdqZXF5SHdTNFpMVUx6amYxUU92YnRaaFZxZHd2OER5MnJ0?=
 =?utf-8?B?cm5JZWNOa0pVNGYyaE81V3l5Z1plZm9jdHdkVnEvV2phaWNLMXdZS1JsczVG?=
 =?utf-8?B?eDlHODQ1eWI5Y0gzTDMxOFEvcnJKczdhcDQreVF0NHFyZWVSWGQ2dVo4Zkd6?=
 =?utf-8?B?K2FwQlgyZmhCZFFwSWdhQ0kwU0I5dlluS01kMkd4cU5OTm9EVmd3RWp1bkxB?=
 =?utf-8?B?Uk1mb2pGQUJiN3Vhd0pXRXNhR1lFdWwwclBEaFRNU3Q2aUtJc1RYZERPbEpR?=
 =?utf-8?B?WmdVb3RCdDNsWFJpUjYrdHhhNlJrbkxzcTJmSUNKQVBaTVI4ZkpiUk8yQmo2?=
 =?utf-8?B?RGs2eHV5THhyakJabUFpNHpHQVU1RG12bk9ZMkxGOEJ4ZTVtOEJJTldzOFc4?=
 =?utf-8?B?blNWbWhGQWpPdHJMRTN4MnZYRU5NRE0vUVZhQkhsMW5QbDJKNEFPRGJVUnVs?=
 =?utf-8?B?L3lLVGQzT1BTakhZTTAzWDBFVTh3TDFpNmMzOURWVkxDekhZRzQrWjF5Z1Jp?=
 =?utf-8?B?bHB3OTRmakYrcW80N3QzTVhkMHdnRXJLSjFwLzBsTko2SENaY3E1c2lwT0ZW?=
 =?utf-8?B?S29Tb09vZXNDcm10amFFK3FEZERiNGxzYmZML2Y0ZGFnWENWUEQwTUJJeStU?=
 =?utf-8?B?TUlEYS91RTBSZFdjS1VTM3lFK1R1YXVhbE5wRWdyTlpHTC9jVlhWZWxTUVFT?=
 =?utf-8?B?S0o4VklGWVlBSTh3aUpjWXUrczVDZzV2bmhhUFlSYVJGblZETWJwMDAvZk04?=
 =?utf-8?B?VU5rbVRaL3pDQ3dKbXNNdnNnZktseXFQaW9zT2FhdFErNy9iaHZIWGhhdmpj?=
 =?utf-8?B?aER4dlg4ZEU4Y3REQ1N1ZWthS0JHWjlzVUJlSzZWSEZMS2RJUS9WOUx4S3VV?=
 =?utf-8?B?b3YwR2o4TUlCZmZMb1l2UjA3M092UVM3ZWl3TWIzWHJCY2NUMGlYWGN3bVY3?=
 =?utf-8?B?RS83Q1U0TWFuNzlVQ3ljb1hxL1hHQnlTdzlxSythSXV6b2prNGRNSGpSTE5R?=
 =?utf-8?B?eWhlc0phMzk0ay9JYldveWM4emVtSGYyMjNqOXpzK0NMWExQeE8xTHFOVXV6?=
 =?utf-8?B?bUZnOFloWVFBalJsY2gwWnBDQkdjRXpvcUVmUGlzSFNWMW53dWNhQW9POW5z?=
 =?utf-8?B?U21jby9NTmJ6N2dHbjlPY011MGhnZ05FSFZmVUw2eXpjYVMxT2w1OEowcnIz?=
 =?utf-8?B?dHlFTUNaRnRKZEpOaFVQcW15UXdFT0hCWkQyajRFTFA3K295bURrR3NYUkNF?=
 =?utf-8?B?SW8rZ2hwQ241Z0tZNGlWV29xSUFNdXlOa3praGtZME5lOXAzZzlXWjdqLzFE?=
 =?utf-8?B?SSs0OXdWU0xDeE5FeUh4V2l1ZGpxK1hZRHM2MXFIL3ptVU5reFBEUEVmMVRW?=
 =?utf-8?B?RFVaMnFqTmkzWm1WekxUb2UySi9waVZ4RUJPd3FCMWZMQXpMdjFCUVJIRVd4?=
 =?utf-8?B?REtvNi9hWXdadTdXekpraDdRemJITW5sckhrdFNBb3Iwc3QwcUdIUmRnK3g3?=
 =?utf-8?B?Y3hoRThnZytBTjB1TG04UWJOMnV0N2dGUDYrOHowVVlITHFveTlmS29iWXpv?=
 =?utf-8?B?bGF4TGhUbXg5dHZXQkwxOTV5Y3Q1Zy93ZThqbzB1bzhkbnBlVExmMGwvZE5w?=
 =?utf-8?Q?yxrsYAHxrRqOYRMP5S7WbKeMs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932da5ac-c899-4bbf-097f-08da703a4cf0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 01:41:32.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCCTLI5RLYJpa34Fo8RnAfcYfTXg5zKtW5Yd0HNn3zq5Dh1OPzFtZPMW9XfLcXdLbAInWbLZSi7j+KaJqdrhRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207280004
X-Proofpoint-GUID: qu2sUZfrEV4pM-gsZkqCNis4WY5XExBF
X-Proofpoint-ORIG-GUID: qu2sUZfrEV4pM-gsZkqCNis4WY5XExBF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 4:54 AM, Zhu, Lingshan wrote:
>
>
> On 7/27/2022 6:09 PM, Si-Wei Liu wrote:
>>
>>
>> On 7/27/2022 2:01 AM, Michael S. Tsirkin wrote:
>>> On Wed, Jul 27, 2022 at 12:50:33AM -0700, Si-Wei Liu wrote:
>>>>
>>>> On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>>>>>
>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>>>>>
>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>>>>>> When the user space which invokes netlink commands, detects 
>>>>>>>>>>>> that
>>>>>>>>> _MQ
>>>>>>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>>>>>>>>> I think the kernel module have all necessary information and 
>>>>>>>>>>> it is
>>>>>>>>>>> the only one which have precise information of a device, so it
>>>>>>>>>>> should answer precisely than let the user space guess. The 
>>>>>>>>>>> kernel
>>>>>>>>>>> module should be reliable than stay silent, leave the 
>>>>>>>>>>> question to
>>>>>>>>>>> the user space
>>>>>>>>> tool.
>>>>>>>>>> Kernel is reliable. It doesn’t expose a config space field if 
>>>>>>>>>> the
>>>>>>>>>> field doesn’t
>>>>>>>>> exist regardless of field should have default or no default.
>>>>>>>>> so when you know it is one queue pair, you should answer one, 
>>>>>>>>> not try
>>>>>>>>> to guess.
>>>>>>>>>> User space should not guess either. User space gets to see if 
>>>>>>>>>> _MQ
>>>>>>>>> present/not present. If _MQ present than get reliable data 
>>>>>>>>> from kernel.
>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>>>>>> it is still a guess, right? And all user space tools 
>>>>>>>>> implemented this
>>>>>>>>> feature need to guess
>>>>>>>> No. it is not a guess.
>>>>>>>> It is explicitly checking the _MQ feature and deriving the value.
>>>>>>>> The code you proposed will be present in the user space.
>>>>>>>> It will be uniform for _MQ and 10 other features that are 
>>>>>>>> present now and
>>>>>>> in the future.
>>>>>>> MQ and other features like RSS are different. If there is no 
>>>>>>> _RSS_XX, there
>>>>>>> are no attributes like max_rss_key_size, and there is not a 
>>>>>>> default value.
>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
>>>>>> "we" = user space.
>>>>>> To keep the consistency among all the config space fields.
>>>>> Actually I looked and the code some more and I'm puzzled:
>>>>>
>>>>>
>>>>>     struct virtio_net_config config = {};
>>>>>     u64 features;
>>>>>     u16 val_u16;
>>>>>
>>>>>     vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>
>>>>>     if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>>>> sizeof(config.mac),
>>>>>             config.mac))
>>>>>         return -EMSGSIZE;
>>>>>
>>>>>
>>>>> Mac returned even without VIRTIO_NET_F_MAC
>>>>>
>>>>>
>>>>>     val_u16 = le16_to_cpu(config.status);
>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>         return -EMSGSIZE;
>>>>>
>>>>>
>>>>> status returned even without VIRTIO_NET_F_STATUS
>>>>>
>>>>>     val_u16 = le16_to_cpu(config.mtu);
>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>         return -EMSGSIZE;
>>>>>
>>>>>
>>>>> MTU returned even without VIRTIO_NET_F_MTU
>>>>>
>>>>>
>>>>> What's going on here?
>>>>>
>>>>>
>>>> I guess this is spec thing (historical debt), I vaguely recall 
>>>> these fields
>>>> are always present in config space regardless the existence of 
>>>> corresponding
>>>> feature bit.
>>>>
>>>> -Siwei
>>> Nope:
>>>
>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>
>>> ...
>>>
>>> For optional configuration space fields, the driver MUST check that 
>>> the corresponding feature is offered
>>> before accessing that part of the configuration space.
>> Well, this is driver side of requirement. As this interface is for 
>> host admin tool to query or configure vdpa device, we don't have to 
>> wait until feature negotiation is done on guest driver to extract 
>> vdpa attributes/parameters, say if we want to replicate another vdpa 
>> device with the same config on migration destination. I think what 
>> may need to be fix is to move off from using 
>> .vdpa_get_config_unlocked() which depends on feature negotiation. 
>> And/or expose config space register values through another set of 
>> attributes.
> Yes, we don't have to wait for FEATURES_OK. In another patch in this 
> series, I have added a new netlink attr to report the device features, 
> and removed the blocker. So the LM orchestration SW can query the 
> device features of the devices at the destination cluster, and pick a 
> proper one, even mask out some features to meet the LM requirements.
For that end, you'd need to move off from using 
vdpa_get_config_unlocked() which depends on feature negotiation. Since 
this would slightly change the original semantics of each field that 
"vdpa dev config" shows, it probably need another netlink command and 
new uAPI.

-Siwei


>
> Thanks,
> Zhu Lingshan
>> -Siwei
>>
>>
>>
>>
>

