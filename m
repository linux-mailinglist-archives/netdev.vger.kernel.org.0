Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C179C5A2770
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245499AbiHZMLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbiHZMLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:11:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BC8DC5E2;
        Fri, 26 Aug 2022 05:11:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QBOejr017728;
        Fri, 26 Aug 2022 12:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7n6IJGvSbowT/xwdSRk++Rw5r9D4NaNXIY7sJl6DVfM=;
 b=ORBxEeBXFG0dvSc0Blna6XzvwQNnMn7xoM6sZcMpIy2byhT5cSzOeIKkO0B2srUNYYUk
 T0g8URC4HFGzHwdo4SAJvvxttGOxyu2v6HOebPJHzL70DNRu1ioDXJWwcuCwNPiiJQ8F
 FEZ6cJ3EQX9sdIUsI3XSP6TmZsxOufZ2Qo8p6nvunhYJfmc4Kxq0TGDzwv0n33L2yICc
 Ym4bwMGPehRHSci2MXjcfAnEsqyXI6UxjKL2fc6aXFUTtgBPl2WhDkBI9SGLeMCGGWRy
 A+tQ8Vj+GxnuEejG7INmtnLWbeGwJQs+j1s/e3A8ThK3Gjqc1rh8jdZhZNVuK2Zf0ZXp nA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w241fng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 12:11:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27QBTv9b034632;
        Fri, 26 Aug 2022 12:11:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4nqcc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 12:11:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhD46PAKLq6P4rTBrEdlky0rn+pTEnOVxNxbTQ1vdiLZ9p/szbcLERejSmWlOmCSjAFgmMw0SFjjTOzBKsfI1hZNL/B0SqmxW9V47Wo46VZ8Li0u1DNugOUKpjlb21ngZKbuEVeE9HKvkZsT6/rb9xwEhjG9h2PemFW4upCh59DElNf4egWtwfRBUFUifSn4BGQa274FtwEcjn2V0ur2sxg/pVa6EtBpCXSPFJxDRrx0C+anjLWUf3WfulTD48Pigq442je+RthfmLZRBnXCKHyTP6gdq5rndTbmURMej2qmHi08WrWsfusmURTOf2IJbFyQ1FhqK4up2RkY+ipjZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7n6IJGvSbowT/xwdSRk++Rw5r9D4NaNXIY7sJl6DVfM=;
 b=jz+Gqtk4qNz86KhNpA8RjmHjo/JZTh8DnaaACZpfOXlodfJnVdEGBe+eMpA1RqEPMG0/LO6wmsMlDGlxslSf7Duz6iftMsBG8ueQ7M1B+QFZ0lNWPimibL3VFQ85OsdDD2XbFyhtCk9NW3QbVf8SuqHapPoGsaE+Z7bc9nh/fJAR41QtB9NEYRmZxmM4g5zg5aL0eNWmrVd6Wh9xwuAEy8/3tAdwcUYMaOxXsho2W+WOVwlo2XqyaJ9pcqs+fF3ZlcfM4YsG9FUrm6RiJ9eGRadM+y5UjJUMRmnA7MefS+pGsPievweRe0sgW++8uFBryWEaik6FrVkcNVSE2q4Thg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7n6IJGvSbowT/xwdSRk++Rw5r9D4NaNXIY7sJl6DVfM=;
 b=ePEO5i73Ikf9+7yUkP1EUdlulMA05iXFVeES5eBT6ZK52JIzCctLDiLrJhRbg2tYE6orkCBsqMnWhI7qd6JSq9y6MDaCKeqtZb4hYtsGmVMAkkSml3c1Cn+hy/97sTUawA69kuYEcdM3SmLfb2UIIqmk/NkiTvdu5OeGrY7xB8M=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM8PR10MB5462.namprd10.prod.outlook.com (2603:10b6:8:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 12:10:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%4]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 12:10:57 +0000
Message-ID: <fd8eca29-f4d7-a148-e31d-45319385f2ad@oracle.com>
Date:   Fri, 26 Aug 2022 13:10:50 +0100
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
 <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
 <20220826060257.6767231e.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220826060257.6767231e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0222.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00a7d00d-d697-4c7a-1510-08da875c0798
X-MS-TrafficTypeDiagnostic: DM8PR10MB5462:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ublha5ES49GdHlIFeXC+ttZQB1v+bRDjbIehFlWBLzWq9PyCJBqaRPKgNSSHazXDse3OZWFIwfAsF/bQcThILN9I0UWLf/5Ou6mcCR1XQR9UROYM4/V11/pjGjx3xPIXNbKAn3tl8lzsw0xKhvQvR3SYwLas/OZtwSaiKS9u13I0iV1T5PEvtWZqMiGAaEGqR2/5/+EH65Tf3vpiOd1llytuUOuxBzeKn3cdrHtBhSM7mwjdOVvgBL76uZRGC6jRG/1zng+5yZV8TTl9V2CuLnQPXTKgX+9Mtep3qcU6GIy2AA/kY+fDIzCoa0j4ckU2BNXnJWcqSj/GcadfOtKjpdi9tMMlGsFnr5U05M21QDs42wcm9gvHBznEq73B9GEKhk0HWNfkm4fnzTcJDWVwZrQQrtKyWc7ScShRWc8LTrHKuY5hxKUQoLV+Soxza9YgBlgjgRiV4cxyqov/qM11ODtDFElZ7jLISFlMwDvfAJhlhQrPCyt9cnDQfTFCwqJkq20+cbJNhGeQKW5lHMKzaMzdQjkfLmqen419k7/M74S8dIl4T4sIyJEWSdNHNgl/hH9ztAZnr+ubVQh4AuxRHIYzWzUMnWjg4lfOj3284stILkUefGxCJhUKbnZfT7PhdPItXEILvUSKWYjBS/1RJ8QFLWZ7s6sfz2GdSa+THFacxNDOvJ0Pus8O8XnAFrexxDuj8NKfJ8bNyMG9EDF0ZJ/J4Rvm0Ygmpx9RcnEH0MmknHQOSUhJkPnXPgQwV3rnBkteAFZbeSdyRFcVPU2ySA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(39860400002)(396003)(346002)(83380400001)(31696002)(86362001)(8936002)(2906002)(2616005)(186003)(66556008)(66946007)(38100700002)(4326008)(8676002)(66476007)(5660300002)(316002)(6506007)(6666004)(41300700001)(6916009)(36756003)(6512007)(26005)(6486002)(7416002)(478600001)(31686004)(53546011)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmcrU3VxbWQyVFo5TEF0aUhPbXBMUTJpTVJ1WEQveEovcTQyMi9ZUlhVbGNW?=
 =?utf-8?B?NW1VSUF0MGhXcnN4N1FpaDJ5NGxjNnY3aVJoYUNsRDNFYmJiRTBVd2RNRUhw?=
 =?utf-8?B?UFlQZmpud3BjRWdveVA5ZnJ4UkpBYnJBSmMvREFnczBDUGd3bkpZdUxFcTB4?=
 =?utf-8?B?bzY0R2Z2eXZlV2ltUFVUclNjSU94NEJ5YlJmekd0bTArRmhqMExiSFNJZlQ4?=
 =?utf-8?B?SVRwRDF3eEVqK2l2Yk5WYmhYeTFwRXhnUTV3a3VTWGNaYkpMeWw1WnNtajdm?=
 =?utf-8?B?OFhwdjIyUWFkOTcvNnlWdDZFSkRnU2JZS2dOaDk5S0c0ZFc5ZEh3TzFWaXJR?=
 =?utf-8?B?TGxaVmFnVC9oWHFld3pxMVJYdWloYTBDQkp1RUVvY0EyUUlOOWtNQlVkbU5v?=
 =?utf-8?B?Wlp0TC9vYlYxZGx1Y2M5Qk9qdUhicUFuN2pEVnVaMHo4c293aHJXS0tWUUE0?=
 =?utf-8?B?a2pRUjJXK29vaEhvWmY5eHlDR25RaUt2RlJZZGZhd3daN25mQ0pWamVtNDQx?=
 =?utf-8?B?dEdkeEJCaEZYVk5wbVBBUngvSWJwKzZSdTAvalBzSzY4eE9oSUdxWU1OUUdE?=
 =?utf-8?B?Q0lHWEsyZFUzbzBDc2phenE1SWo5R3YyMFBid2NrbEhvSEUxOG11eW10c1Fq?=
 =?utf-8?B?QkxFaFB4SWVna0ZTZFNjNnBWS3N3UDVEbmJJeVVwNG44bGF3T21wbUhPNGxx?=
 =?utf-8?B?NzllRElDdStZZnpxRmdUazBEYUFRQVFpcEJGeFpOZkJoN3dobEw2VDBCY2Er?=
 =?utf-8?B?cWNBcVY3bnc1MGpmWTJ2S3l3aEFndGVLRSswcEdEME5uc2VZVW03V2hlUFZj?=
 =?utf-8?B?WTZaaHZ0azdBNE45RkdYa2xyaXR4VzJwTFpnRXpKblh5c05RbXdwK0ZBaXNu?=
 =?utf-8?B?a01HVHJIaEdNNGtYeFBYa0RXMmh4ZXdaOXo3djVYNFZhK2lDcVVhWE1iejZP?=
 =?utf-8?B?ZURETlZ0ZG1iNTNFTGpYWjhNblFDS1YxSWlXQzhabkFOY3J5Z0tHdXVVYkU0?=
 =?utf-8?B?VjlHUiszdFZIL1ZEbXh4K3NNVDBtbzB2YVY5UUNMeU1SU3o0NkpWTG15dE9Z?=
 =?utf-8?B?ZzcxYWtpSUJEa1JTdzgvZ2VUSU9KeGQzNDd5eno3OWZMQ05ZTUlhTHl4bUN3?=
 =?utf-8?B?dnRGalRsNTdBaEhBbHNnbTRtMlNiakhHWUczck9xWHlyRFJoOC83bUc2Qkov?=
 =?utf-8?B?a29GQjA5YVl2dTkwQTg1RkJEVzNYcXUycklIbWVXYmxhS1pjWnlRMWROVzJR?=
 =?utf-8?B?eGpROERvNCtsZStiQXhaKzVYMEFqK29EckYva3NuckZQbXMzckhGREY2bU1s?=
 =?utf-8?B?WHhINkhNZWplSXZteG9QNEM4NGY0RjZnaWNoWGV2YXRxWFczem9iZmc3K3Nq?=
 =?utf-8?B?UDIyYTRkSnRUSmgwK1QwZlM0WHBTWTNlQ2tlL245Z2Nqd2lLRXFORmtPOEgw?=
 =?utf-8?B?dVlZTUc2UG9KV2V1dVBlOTUyK1BoUnA0WkJRWDltdXNzdVp1TExjMElDTUF1?=
 =?utf-8?B?cXNCM044djR3QzFQaFZkVXY3Y3lvR0U1cng2UkFOZnc2TWlOUEhNbnY3QTJv?=
 =?utf-8?B?OTZLQk42OGZKb3dKK3p0ZXNDL2pKeXBncmZPYWVQb3NOdEUwdGlSaTdIand3?=
 =?utf-8?B?cDBCYnhMNjZERVc2ek5kd1JWQnNMK2o2YXlmSk1nTnBQT0ZmdUxLUUpGZUtk?=
 =?utf-8?B?QzJsdUE0OWFTMFhUVXRIQm5hVUNNQ0F6YjF4NTVoU0JSb1V6MDVaM0I1OUJ0?=
 =?utf-8?B?M2FDYTJSR3h5Q3JVNnNIUDFsMEE2alFwakFMNFFCNDFVaEJSUXI4Y2FBWE1k?=
 =?utf-8?B?SURWZDBkL3RDRWtWMW9OL2VpdmEvNGI0TEJzeG9qL0lnckJQdVdaTEhuMjdu?=
 =?utf-8?B?TVRvZHNuOFhwLytlbFBDMmw3S04vK0g5OHY4WGhiQzdMdWVEc2djRzVNOS9H?=
 =?utf-8?B?NGN3ekNRendEYStQQmpGbmhQemVOUWRRK2d3VHQzV3FQaW0zNjVYK2YxekdV?=
 =?utf-8?B?a0xpU0J0cERyZ0NwQm0ySk9DTk4rRm4vVytCR3VYaGNMSkE2Y2hrdzAycTV1?=
 =?utf-8?B?SU44cG1qTDdlRFIzZitiby96NU9tV0VRZUJtTXJEZ3BBRytOK3piT0Job0R6?=
 =?utf-8?B?QmthTXBieGtpU1JDSUcxYWs4eFJHMm1IYy96MndNbVlLaTIxSWVNYml5d21z?=
 =?utf-8?B?bkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a7d00d-d697-4c7a-1510-08da875c0798
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 12:10:57.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cyawPEc7MJOThvmYuuFS7bsZdodvgEN2FByU4wj2cs1orsqi1XsKIo+iF5MtwL8JGPwanBcX41NIIEZ7cTwhyrBVJKWQ72c6zYj/a9SJIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5462
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_06,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260051
X-Proofpoint-ORIG-GUID: O1R8z5hHMtXAD4ROFCKME8mCd8A59Cti
X-Proofpoint-GUID: O1R8z5hHMtXAD4ROFCKME8mCd8A59Cti
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/22 13:02, Alex Williamson wrote:
> On Fri, 26 Aug 2022 10:37:26 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 8/26/22 00:15, Alex Williamson wrote:
>>> On Thu, 25 Aug 2022 23:24:39 +0100
>>> Joao Martins <joao.m.martins@oracle.com> wrote:  
>>>> On 8/25/22 20:27, Alex Williamson wrote:  
>>>>> Maybe it doesn't really make sense to differentiate the iterator from
>>>>> the bitmap in the API.  In fact, couldn't we reduce the API to simply:
>>>>>
>>>>> int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
>>>>> 		     size_t length, size_t page_size, u64 __user *data);
>>>>>
>>>>> int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
>>>>> 			 int (*fn)(void *data, dma_addr_t iova,
>>>>> 			 	   size_t length,
>>>>> 				   struct iova_bitmap *bitmap));
>>>>>
>>>>> void iova_bitmap_free(struct iova_bitmap *bitmap);
>>>>>
>>>>> unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
>>>>> 			      dma_addr_t iova, size_t length);
>>>>>
>>>>> Removes the need for the API to have done, advance, iova, and length
>>>>> functions.
>>>>>     
>>>> True, it would be simpler.
>>>>
>>>> Could also allow us to hide the iterator details enterily and switch to
>>>> container_of() from iova_bitmap pointer. Though, from caller, it would be
>>>> weird to do:
>>>>
>>>> struct iova_bitmap_iter iter;
>>>>
>>>> iova_bitmap_init(&iter.dirty, ....);
>>>>
>>>> Hmm, maybe not that strange.
>>>>
>>>> Unless you are trying to suggest to merge both struct iova_bitmap and
>>>> iova_bitmap_iter together? I was trying to keep them separate more for
>>>> the dirty tracker (IOMMUFD/VFIO, to just be limited to iova_bitmap_set()
>>>> with the generic infra being the one managing that iterator state in a
>>>> separate structure.  
>>>
>>> Not suggesting the be merged, but why does the embedded mapping
>>> structure need to be exposed to the API?  That's an implementation
>>> detail that's causing confusion and naming issues for which structure
>>> is passed and how do we represent that in the function name.  Thanks,  
>>
>> I wanted the convention to be that the end 'device' tracker (IOMMU or VFIO
>> vendor driver) does not have "direct" access to the iterator state. So it acesses
>> or modifies only the mapped bitmap *data*. The hardware tracker is always *provided*
>> with a iova_bitmap to set bits but it should not allocate, iterate or pin anything,
>> making things simpler for tracker.
>>
>> Thus the point was to have a clear division between how you iterate
>> (iova_bitmap_iter* API) and the actual bits manipulation (so far only
>> iova_bitmap_set()) including which data structures you access in the APIs, thus
>> embedding the least accessed there (struct iova_bitmap).
>>
>> The alternative is to reverse it and just allocate iter state in iova_bitmap_init()
>> and have it stored as a pointer say as iova_bitmap::iter. We encapsulate both and mix
>> the structures, which while not as clean but maybe this is not that big of a deal as
>> I thought it would be
> 
> Is there really a need for struct iova_bitmap to be defined in a shared
> header, or could we just have a forward declaration?  With the proposed
> interface above, iova_bitmap could be opaque to the caller if it were
> dynamically allocated, ex:
> 

/facepalm Oh yes -- even better! Let me try that along with the other comments.

> struct iova_bitmap* iova_bitmap_alloc(dma_addr_t iova, size_t length,
> 				      size_t page_size, u64 __user *bitmap);
> 
> Thanks,
> Alex
> 
