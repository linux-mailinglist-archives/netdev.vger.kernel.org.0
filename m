Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942EF5AABB2
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 11:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiIBJnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 05:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiIBJnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 05:43:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63922CD7A7;
        Fri,  2 Sep 2022 02:43:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827kweY016249;
        Fri, 2 Sep 2022 09:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Yt81hw2rJOfeW2QRU62lvVk3nNrCtOD/tn/PPyJqYXQ=;
 b=VOAWvqV9GZfppRe8msYLMIPdSbk/+VQw0+Pt8to93qs/e9zroei9psnTCMP/4DiEB00M
 IKSjw27afSJpIkjWMRByyEXYe390z2cDRqGhZwJ/X5+3KNK3HSOGcsLV50/6Jlff8LmU
 5HxkWQ+Ma3tEZhu+b+2tDURgRPavFDmZSiBjOO+BHWYGKaowYBCCRS+HayxHX29uX6sD
 /lZBwqoxhnqseAKV59HyqQoQAJTHFtKWpbGpK/bL9Z76bzgAxiswE1j1NK6k99BvmS2f
 fmvGv1dZYowxM2bddE7nf+gablRlqoZFdEvdGaBhNT3E56g6orJElsBcsojM0EHfO0eT /A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a22etq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 09:42:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2826aEX9002065;
        Fri, 2 Sep 2022 09:42:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jarqkrhpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 09:42:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0XI76DNKvJbI4S0ZyAiT1kiDODgqb3EPLwv/DY0qgtz/pupDqf1GmbREf6VfpugsuDfu3RmtmfGFOxHTATwywvQpnikRouzNMcYPQdUuPpUIfXDpTVHmLxLYTVjdQveNfLY3GBJi9oKPn15sy0gdXHW5a6rY/ijPPDU7RvOAZ1lkJaQP5sCfYjbxWKMgm+qrKjAliAtlNAUYPofQ0kzZqjeS3FwOq77YI0YbiqpOjM0J+yrKQYrv4q9vSj9/1LvIjJHAyHQ478UB19+ixruDGhWPllrX9rYIgVY65rwYk1NVYYL4KDyqb71DzUyNNBLX4Bm+nZDxytb2lCywp3yPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt81hw2rJOfeW2QRU62lvVk3nNrCtOD/tn/PPyJqYXQ=;
 b=TXxtuntLDfLfGBPgAKKljxCY7lMsSOWivytB/jmDwv9lUahy7rgJvnpCcTtZEh6XMfarNTviOZuEiT0SiB854+r7hHXcdqmz+EBPRvwHFfKWvjPFDldjKS684bw3UXjAZ9plhNme6f8b3NLvmUF4qNjqWm+c01klPBl2WEV+YKGx7sTqi2oVgDapi5sv9DCOwtLtFT81d3v87hAfNHJxvDUzUUR58bL0EoO5vcJJonVUTFkY/5tLIDeghdNn/nsBQ34MOz4KpNQHrk0CExFCq5vQNZR80a1rnh/5DGAaIGp3+tzp+faVckO9drI/wDRxz7qYEWovP8p+rvxHJvMeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt81hw2rJOfeW2QRU62lvVk3nNrCtOD/tn/PPyJqYXQ=;
 b=E+bfqcgUzeFj7JFiI/m3XMdRiQM5WlaPLuaRIb9/VsqyKeSxByqlYkgr5mZhpmlGuncj+op8yf9k5kmp1Gu+BPTdMeFpII31NoYDOtDed4yltSHaLFFLpB9q8C9DzB2V9BTkPKbP1LDikoJBthJt1uClrOfh8qaMLhxXNMHu9Gw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5114.namprd10.prod.outlook.com (2603:10b6:610:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 09:42:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%6]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 09:42:47 +0000
Message-ID: <4cc88875-feb7-4d78-26f9-9009b5083525@oracle.com>
Date:   Fri, 2 Sep 2022 10:42:41 +0100
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
References: <20220901093853.60194-1-yishaih@nvidia.com>
 <20220901093853.60194-5-yishaih@nvidia.com>
 <20220901124742.35648bd5.alex.williamson@redhat.com>
 <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
 <20220901143625.4cbd3394.alex.williamson@redhat.com>
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220901143625.4cbd3394.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd0d59e8-33fa-41b8-5d37-08da8cc77e54
X-MS-TrafficTypeDiagnostic: CH0PR10MB5114:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRTudh32pxNxxccsSjQBCUKjzIkhXXUbt/rV/g2orvfw6Mj0q+2B/3WRl9dJx1K6CUlx5Dm88LCER9IqeQBXGD6y1ldRmyGqwoZytPTJ4mAumH0HikZPztSOylu6/2AsOIljrLgmsB8ycVxzYW58MEys0np88kWcjMmCUiQuJvVGm66W0RSmuKzLetNJT0qwLigxfSgTka4nLA6kbB0M5qNvRQNgNGlmmwCP+/AMSej3J4Y9xWYSejitheq2BowpYJK9BPe+p8MrgGsoLa4NYmasWtA10hKT4osVFhPP1mrOgdQwnPDXAdHJuw0YF6td3upNRjT7Aiw239JQI7lBgWexkYfWX+x+6lqUWVSs7JAyU+JnviCGjWwCSpxeiRLAVTX9PV80YwIweP6jCf411gl7JCcy3HKBOk73G7oVQDZvFl4sjVT1bhTuVz4FkqRCDfQq5zkDJ0QqOvacekucaAzcof89q2F7MUgmOpw3v0hfoJXu/4BaQE9SF5nDIt2PkOBTIzZEywIlrpBgLWeuwjmd4ehuyBtmT1S9nJdt7US/KGUBgcQ1A0kGX9gqg7LZ0uygPO9bzehWtdSKIPGt2P73IN5kC4ih6QwpW6aYJeTpYdeirRHq+CwKqGBJwn0gF0/nINlvuxpiV2hLIybQBrgs9IVElCrxIVr+ZW3QMMc56or5FEkgoKcM55l1XxPXAoLHuHXjeoAJqbZJgfMIFN8OsJ5712fuyZ1t+Nt8jesMvd6klN9Hnm92y1OYNZG5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(376002)(396003)(346002)(6506007)(186003)(316002)(83380400001)(6916009)(6486002)(2616005)(53546011)(36756003)(2906002)(6512007)(5660300002)(41300700001)(31686004)(26005)(66476007)(86362001)(31696002)(66946007)(8936002)(38100700002)(4326008)(6666004)(7416002)(8676002)(478600001)(66556008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3hSVXU2VzJFeUIxZ1RkUEN0MU1mcGU1cnl4ZHpZQnhtTUd0TzdwZ1p2c0NM?=
 =?utf-8?B?aG95bUlrY3JPRllHeXNPMWcrTk9IaVNEQ3IwbUpwYWlmSWVsMWlQdHdrY3dQ?=
 =?utf-8?B?SmZnR2RwUGhtU2lsMEJQbVBON0pOdWhHWnBqVGFWVUN1NGYxZ1g3WWI1Vyt2?=
 =?utf-8?B?TEpRVXpYenh1MjMwZk43d1hKTnFFZjR5UGdXTVQxa2krWlJvWTBlZnMvQWRz?=
 =?utf-8?B?ZkRTaHJobWdCVXh3eW16b0s5UGRWV0E0TFJic2xjb1NLNlpBVDlyTG55aGhU?=
 =?utf-8?B?VmdOZW4xYTZqaVN0d0pNUnlEVHp3bFVGL3cyaURxM2RHbDd6bUd3eFc5Ykpy?=
 =?utf-8?B?L0ZzM3doZ3dNdDNUbDZoT0V3VTYxZG8rK3VKVlF4TFlIbngxbk12QUJYclpO?=
 =?utf-8?B?WkF3U1dIaTl0bndOTVlJcTdFL0ZtU2ZrTmlwcGQ5S1NzZXZnTXl4eUZJZzNS?=
 =?utf-8?B?UnUxY2crYzMzM1BYSmYxN1NpeGJqaTFlN0JHU2l0WWV5TnkzS1doRTBCMTJr?=
 =?utf-8?B?ZXBUMkNXSHVsWW5OaGtXVG9xWlhGTVJGRmZranZmRmdWYmltZlhDd0ZFZmY4?=
 =?utf-8?B?VEJCRDhGTUZtWVArUjlsOVV5d201OXNQOU9wZG9GVzRrQm85S01QYXg2eHBq?=
 =?utf-8?B?ak1pWkQ1ZHNnak5kMGJtS2YvZXQwK0gxSlFvbUhwelhCNDlFV2h2M05UMk1r?=
 =?utf-8?B?UjNKemhnTllRZkkzSWl4Mmd2TllwWjNacnFwNDVPaGpyNldTRy9SRlBHcHE2?=
 =?utf-8?B?aUo4djdLS1hndmJFUFp0R0t3cGJGZzN5ZUUzM2ppbHdZT21tQ1R0Sm1HajRK?=
 =?utf-8?B?eEpjZjZUNnRobnpNS3VEaStZR0ZoUExidnpyUlVBOEtpUjBKcUdGQjJLWi9p?=
 =?utf-8?B?Z3Q4NHBTN1l1TnN4WkZLVXJER1hDNXF0cFNoOElyQlVQa05zcU15MmlQcm14?=
 =?utf-8?B?ZlZ1c21SWVJZVXAxRDgyL0Z1Ny9HYXpPaUw0SHAxQUU1UDRqRnZCSmlaQ2RY?=
 =?utf-8?B?R29GWmpNaXRxbGZydTdHSjlCRndkLzM5WW5ia21sYlNBRnVucVpXVEpDNnhM?=
 =?utf-8?B?QmozeDdVeGo0T3hzU2pBWURhdWtKZmo4YUZ0ZFFQOXhYdkVCZGoxTzFhWHMw?=
 =?utf-8?B?Tm5yNHpoVytwSk12Tit5VXdtWHdzbi9DVlZJR2hyc2dnVmRtbmVTVlNHL3BI?=
 =?utf-8?B?SnlMd21WTjJ1VEJEZWpnUmFWYXNBRzU3VFRjY3o1REluYlRwT2J6K2lrL3ZG?=
 =?utf-8?B?ZG1kaHVFeUR5cjRNMktRT0lpd2lrM24vY2NST3ZBZDR5cnR5dVo5RTVzMGsy?=
 =?utf-8?B?dStCRDcvdEdiU0MranNNaTlQOWpNQWQrbEIwYXUwQkZ5NzhiZkJlV3VPcHp1?=
 =?utf-8?B?ZlI2TlY4ZTNUdUUwZXBEVGtHR1VLWUVaNGp6RERuT1ZyWjJIVnRIYXVlUkdN?=
 =?utf-8?B?V0ZPSW85WmNoelhZNHp4Wm1HT1pBOVFNcjc2TGt5TEQvNG5JbFd4RnlCK0lk?=
 =?utf-8?B?Y2o0ZXo5N2tpcXZqNWh4T0FuZEx4bXEyczFUL292WGFiVkVBWGpLVm9UR2RR?=
 =?utf-8?B?VHhjWGN1dng5YUM4STRJS3YvOER6YTZsaTY2VkwySVdLRUNjUE1zY2cvQ3dp?=
 =?utf-8?B?TjZONVlEOWFxTTNjcnZEdkZjbnBCSEIwSFpFUmxiT1AvaGh2UXJ3QWN1eDZt?=
 =?utf-8?B?S2Z2em55NkpwNjlzeGd0d2xIYTJTcWY1bU9xaWJlNFhJSEJCQkMwTDQrNk5F?=
 =?utf-8?B?cEl2eTk0RkhrUzd6UUlhK1R3WUsraUhxdklCN0VzeFpGT0d2R2RPdFIrbWN6?=
 =?utf-8?B?dDh1b09OOTdnaHkvUmJTeTZVYVZqbzV0dE5RR0thMlNxRWtZS3U3eVorMGdP?=
 =?utf-8?B?Z0NBY244VUVoTUUvc0RKYk1mWElkOUttUmZZMjIxc2paSVZIWDhlRWlON0Zi?=
 =?utf-8?B?VXZUOWY3czI2blNPVERPV0d0Zk5jTnFKM0k0ekVITGxkOTZYVVUvN0pXRjFK?=
 =?utf-8?B?QklpN2M0NkVuSktkdmI4MDR2OXNhTXZjc3lEQ0xEdGw0Mk1EeG5sWW9NWEIy?=
 =?utf-8?B?NW9SeG1iNW9FZDVldktSN25NTHVNZUd0NENNNi80M3hpaGVIbEtsVk1pOVRa?=
 =?utf-8?B?ZncrN3RYVnRtSGI5VHdoUEQ5cDhtSGs1UUlBRGVTZ1dxOWJ1N3hDV29nYXFO?=
 =?utf-8?B?U2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0d59e8-33fa-41b8-5d37-08da8cc77e54
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 09:42:47.4215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dfe7sZ0SblbWFXgQy0i2vT1/6P0f1npyLu29FJ6iHn9xfcppvLs50foVXnDORiZiD8fdrWSuYTK2Qsj7B552cyrOHuW/qTLT/MKv7FPXbbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_01,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020045
X-Proofpoint-GUID: eLsnZe60AtCerahNpdbCwuFhx_vHugDJ
X-Proofpoint-ORIG-GUID: eLsnZe60AtCerahNpdbCwuFhx_vHugDJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/2022 21:36, Alex Williamson wrote:
> On Thu, 1 Sep 2022 20:39:40 +0100
> joao.m.martins@oracle.com wrote:
> 
>> On 01/09/2022 19:47, Alex Williamson wrote:
>>> On Thu, 1 Sep 2022 12:38:47 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>> + * An example of the APIs on how to use/iterate over the IOVA bitmap:
>>>> + *
>>>> + *   bitmap = iova_bitmap_alloc(iova, length, page_size, data);
>>>> + *   if (IS_ERR(bitmap))
>>>> + *       return PTR_ERR(bitmap);
>>>> + *
>>>> + *   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
>>>> + *
>>>> + *   iova_bitmap_free(bitmap);
>>>> + *
>>>> + * An implementation of the lower end (referred to above as
>>>> + * dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
>>>> + * an IOVA as dirty as following:
>>>> + *     iova_bitmap_set(bitmap, iova, page_size);
>>>> + * Or a contiguous range (example two pages):
>>>> + *     iova_bitmap_set(bitmap, iova, 2 * page_size);  
>>>
>>> This seems like it implies a stronger correlation to the
>>> iova_bitmap_alloc() page_size than actually exists.  The implementation
>>> of the dirty_reporter_fn() may not know the reporting page_size.  The
>>> value here is just a size_t and iova_bitmap handles the rest, right?
>>>   
>> Correct. 
>>
>> The intent was to show an example of what the different usage have
>> an effect in the end bitmap data (1 page and then 2 pages). An alternative
>> would be:
>>
>> 	An implementation of the lower end (referred to above as
>> 	dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
>> 	an IOVA range spanning @iova_length as dirty, using the configured
>> 	@page_size:
>>
>>   	  iova_bitmap_set(bitmap, iova, iova_length)
>>
>> But with a different length variable (i.e. iova_length) to avoid being confused with
>> the length in iova_bitmap_alloc right before this paragraph. But the example in the
>> patch looks a bit more clear on the outcomes to me personally.
> 
> How about:
> 
>   Each iteration of the dirty_reporter_fn is called with a unique @iova
>   and @length argument, indicating the current range available through
>   the iova_bitmap.  The dirty_reporter_fn uses iova_bitmap_set() to
>   mark dirty areas within that provided range
> 
> ?
> 
Yeah, much clearer. Perhaps I'll add a : and the API usage like this:

   Each iteration of the dirty_reporter_fn is called with a unique @iova
   and @length argument, indicating the current range available through
   the iova_bitmap.  The dirty_reporter_fn uses iova_bitmap_set() to
   mark dirty areas (@iova_length) within that provided range as following:

	iova_bitmap_set(bitmap, iova, iova_length)

And of course I'll change this in the commit message.

> ...
>>>> +/**
>>>> + * iova_bitmap_for_each() - Iterates over the bitmap
>>>> + * @bitmap: IOVA bitmap to iterate
>>>> + * @opaque: Additional argument to pass to the callback
>>>> + * @fn: Function that gets called for each IOVA range
>>>> + *
>>>> + * Helper function to iterate over bitmap data representing a portion of IOVA
>>>> + * space. It hides the complexity of iterating bitmaps and translating the
>>>> + * mapped bitmap user pages into IOVA ranges to process.
>>>> + *
>>>> + * Return: 0 on success, and an error on failure either upon
>>>> + * iteration or when the callback returns an error.
>>>> + */
>>>> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>>>> +			 int (*fn)(struct iova_bitmap *bitmap,
>>>> +				   unsigned long iova, size_t length,
>>>> +				   void *opaque))  
>>>
>>> It might make sense to typedef an iova_bitmap_fn_t in the header to use
>>> here.
>>>  
>> OK, will do. I wasn't sure which style was preferred so went with simplest on
>> first take.
> 
> It looks like it would be a little cleaner, but yeah, probably largely
> style.
> 
/me nods
 
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	for (; !iova_bitmap_done(bitmap) && !ret;
>>>> +	     ret = iova_bitmap_advance(bitmap)) {
>>>> +		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
>>>> +			 iova_bitmap_mapped_length(bitmap), opaque);
>>>> +		if (ret)
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +/**
>>>> + * iova_bitmap_set() - Records an IOVA range in bitmap
>>>> + * @bitmap: IOVA bitmap
>>>> + * @iova: IOVA to start
>>>> + * @length: IOVA range length
>>>> + *
>>>> + * Set the bits corresponding to the range [iova .. iova+length-1] in
>>>> + * the user bitmap.
>>>> + *
>>>> + * Return: The number of bits set.  
>>>
>>> Is this relevant to the caller?
>>>   
>> The thinking that number of bits was a way for caller to validate that
>> 'some bits' was set, i.e. sort of error return value. But none of the callers
>> use it today, it's true. Suppose I should remove it, following bitmap_set()
>> returning void too.
> 
> I think 0/-errno are sufficient if we need an error path, otherwise
> void is fine.  As above, the reporter fn isn't strongly tied to the
> page size of the bitmap, so number of bits just didn't make sense to me.
> 

OK, I am dropping it for now.
