Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3FA577320
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiGQCFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiGQCFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:05:10 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD331C106;
        Sat, 16 Jul 2022 19:05:07 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H1xbSs009471;
        Sat, 16 Jul 2022 19:04:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dfgDj7mfVrOR19ZKJBCbOzmUTgau+xpmUSKq+UyB1u8=;
 b=jYJKRwsQBaG2hvDT1tengjuKJ9q5DZNMDL76xOMvx58cAr2HwkdO9yIQQzy3Scplho57
 cU5aCiJZxaS4guetkgMidl1bypUvYHFsXUogjoBZklxVxBM8RYC0Y2INa2IlGgv1VSjN
 FTshfdAeGiYpAFk7L9iY4FtAmaqEJmyKcuM= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbtuyjbf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Jul 2022 19:04:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IByu0uW32qc92EtOO47vZZkW5CFKi5m5ZX4+eWSr29Lk8cPw4hcCmit6rcVh1g77i8q6//7Q2SZadbgf1YeVArq6ZDNv647EKzeMiM4L3THU0vF9CQLfAyVPQHFLPzr+gfBb4TNRoYzt27+TPrAL5dLmUJO5NTZC914fo7prl0dslgO/Y1DYUcJZNR8IfZFEiYR49Zw+4adhdt1oSFLyozsze9ds9MnA6L2QXlr9/emxUjvLaVD9KkS5vpafd75aMzYebLsEWplB67eyVRIAQ7N5FIAyrxn0QltaMH0AmafcB7v0Wy0e2vJYykNsDFj4DGa8/eA+A7FGyIDjNJVPqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfgDj7mfVrOR19ZKJBCbOzmUTgau+xpmUSKq+UyB1u8=;
 b=OWQTQNpeYqUxPvmF1g2SiNpUYUbtQYu90OmLga1qfgziC+q3DEW99qS7LPqIVnbQ/1aNub9PHZE5o5Me1J0GuCjt9QNduB5oZ+A4kmJevEh9tt81+eYnw5b1iImnqyGz7c4DDhN2/OrESHVBkX8izVWjz9Ja+urq6zXT/nbhqLSsa0aqqKLXJBzdv5q7XflYQao86Fo/IFv0MLHAWtoXkXitg3DBkoJJI0Yc9xzyT9m/SbJe4CLPWn556JB4Vh6JKLXY72UoxsItvMJOeZSFW11ru7mpymdA9Qoyg0ZfwYoDeX/M62ZFhpP9JBKrl5B0GSXTTNUBWpMHv291Tx/lDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1404.namprd15.prod.outlook.com (2603:10b6:3:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Sun, 17 Jul
 2022 02:04:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.021; Sun, 17 Jul 2022
 02:04:42 +0000
Message-ID: <7cb1bd2f-1361-ca6e-7c94-d82596a8a3be@fb.com>
Date:   Sat, 16 Jul 2022 19:04:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next 4/5] samples: bpf: Unify memory address casting
 operation style
Content-Language: en-US
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220716125108.1011206-1-pulehui@huawei.com>
 <20220716125108.1011206-5-pulehui@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220716125108.1011206-5-pulehui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:332::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06b69235-0aa8-4e52-1ce3-08da6798b6ba
X-MS-TrafficTypeDiagnostic: DM5PR15MB1404:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5uKeERokySCLtRXrraUJItUzt2A3b3RlCdp8oEAnqez/UOJPYi25ax1iVLbeMtKDtqvpE40OzHJbTzQNpAY4iUfpSgDBGGa2Pc7Ur5XdU7ZhlPfWnHZImCHEV5Vy4VLNdOfTYjPkopaOXMekP+QFiSQK5hTW5vPbZwc/3g+hduT77gBdmIAuYCORbzdzoaTKfyxTgddzLmP5Ig4LtrDJJqNgYubrgRrQnyb3cRo7C/g58uuIy5OhgEilYGdbKYL3Ze2qAs+RyCfLJthRZm54eMhWDU3p2GDj6Ot7OBP77o33ROf3/ffOkfCTxfh3Z2x2knU5XI/l7FByCJlFzRYrEqHghSK+5SXtXtz6DI5OF9OhbgAzRRYQgpEizCynZF8ikYV6T1AhbF93g+rgDLh+dPmocZ5CvenhIYdU7gZ4FTyw0hwO71oAs2n7MVtdmEH01Aza0VCcRQt+Xiiydr2tLwVvxLYrqYuuugMILdfSpyKwEQ0Ihs0GKmbWPSMfF87SVQhjBWilcNAwavq6jR+Pm+AyYrJc8BC3j34ihTV4CoYPWEe278McOwddfWZ/fiQG6JZeJo7Dn0z21XxtDh2Kk1b1wmm6h81hy5wynRqdo5B6a3p62rb9N0n/kjic0maBdEst0nqL+TFqvZdqZnSFao7j5P7Iym70lgs0baBCIDeB2/yAPUPqI9drJV1bE9nL7Px2UvTk0S1t8aahtXaoCZu133SOa3Sm97as9+uovEtmvr135lF3yXtnEZ3R5hK6tu+ZuJE0sP86O8PY5JJ5lrTjthSnPAwF6Eh7vnR2AvUZoDzpDBMGqrfw7Vumz12e1cDjqeUwlJpwReJFaavwOS2IEUxIW7SRpYcJCGKbwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(36756003)(5660300002)(8936002)(6486002)(186003)(7416002)(2616005)(2906002)(38100700002)(31686004)(41300700001)(4326008)(8676002)(6512007)(66946007)(66556008)(66476007)(53546011)(86362001)(316002)(478600001)(558084003)(54906003)(6506007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGNHNWdUbFdkeWRTd0sxK2VNSFZxT3JWKzFCSklnTk05VlE2ZTR3TnQzcmcr?=
 =?utf-8?B?TFZCeUNFSjRPVDQ1aXRDcGkzK2U5Z3AvcDhDdW1SVjV0MmI5b093dzFFWG1x?=
 =?utf-8?B?ZnEzMTJJTzVIanpvWDhMRlh5ZmJabzNHNFBTbHFoaDhXbFprNG9MRERXQm5n?=
 =?utf-8?B?bEkzeHRvczk5anZSTCs4V0VaRkhIWC91SWtiMmhhSGNRdGw4cGN5bDlrYWhJ?=
 =?utf-8?B?akRVbFJRMjgyUU90WTVhUVFXK3RBV2ZCaStEMGZONHlVcWtoQTZBSkZGOWRj?=
 =?utf-8?B?R1AyZm16OW5Tajd0WW5KMWlORmRtaXkrMERmQzk3RDBTeWszUktxQTUycE5q?=
 =?utf-8?B?ZWJoZ1RpclFwS2lyTXdmUmRRTmdlUFJ3Y3lsbFh5c1ZXNTRpUlkzeE5aVlhi?=
 =?utf-8?B?aTBhcFlDdmg1RE9BK00veGdpRWY4citZcWVIL3NuUE1wTitEamFGVEgrN1d5?=
 =?utf-8?B?WWtEVW9qOVl4bFF2TElQaGVqSFR1eGFQVEJucG04VmJaVFFiMVBBRVlQRGhE?=
 =?utf-8?B?UTNrYUZRanFVSXIxcmZ3RldwUFNzMy9pdytXVUdOUkhEMHczN0FYRUh0Tml6?=
 =?utf-8?B?U0FSNnBHc1p1dTBnMEhBQk51dXhUdkxkUS8vcytMRVZIcVVleDRPZE54WlJt?=
 =?utf-8?B?RndNNG9GbDBIUHpPUGoxd0VnaWF6cWZpWm1iT0g4L0JlNlVSVDlHTW51MEtz?=
 =?utf-8?B?NzZGM1pERVJvaU01a21CdzBNdXAzdVNnVVU1MHFOb0pRc1RSTlVISVZtbnRt?=
 =?utf-8?B?YlJWQmVQNzVIa0hrSTVPZXptUFdSOC9yRlhKNWg3ZWVZS3NhQWw1UjJNenhp?=
 =?utf-8?B?MjRITFdpQnE0T3BVcVFFWWZRWHh0OUhiZkxhUHk3WTM1Ty84aUVUcWthQk5k?=
 =?utf-8?B?SURTZ1RNTTg4QUJWTjI0YXZUbUVQZjl6M2FwcEduSGJ6dHI3SFlGSjYzNkxW?=
 =?utf-8?B?N2lMVmNJL3crSk9zdi82N1pKNGg2U044SnZxRWdQTWhTZTl5eFBnQWtjdDE4?=
 =?utf-8?B?V3BHTHNDc2xzU1VOVk51M1B3Y1NmVXJSVkZDeU1VTDZPYmlHbjZPNjdxVzds?=
 =?utf-8?B?Sk1VSmd1OWlZZ0Rlcys3NFB5VEgyTy84Q1lkZzBQM1pqdXRhTWQ0ZEcraW8z?=
 =?utf-8?B?aXNFb1ZZQ2E5eUZZdGhsK1lhYnNlWExtelUwd3Z1cjZiYlFMYW1LMmhwc3Y4?=
 =?utf-8?B?ZlRFTTA0WU9WOCtmOTRQeUhaMmZONjN5c3RMUlM0STRaU1pBcXliRlNLK0Zz?=
 =?utf-8?B?cmNzVnJVREhRVS9RTnRxV2ZrSnZ5MHdtZ2lFK2h3ZmNSd2VYWWhIcUVzNmdK?=
 =?utf-8?B?QjgwU2ZCbE1ENWEyREJvWitDbjZwSEJPam1nY25kdTU5T0MvVnpVakRTdTUy?=
 =?utf-8?B?and2SWFxcGFiejlJUmVlQ1dNbjVwMG5MYi9ndldCQ09ndkNUMnN5a0JVOVJv?=
 =?utf-8?B?V1RKR1VobHR1b0JJQkdOeUg0aTlhcGN5c0JySzdGRFNBdW8yQmRoQS9WR1Az?=
 =?utf-8?B?cDh2WUVkZTN6aTNXM2ZGTmpBRnFiaE9lYXFqYys2aFgwL1hCdVJFVjgxdktv?=
 =?utf-8?B?MjgzeEJXQWlzcEpMUHZTS1IzN0xmaVNnMzlneG5CZDgrUE5wRlNsblZGaStw?=
 =?utf-8?B?cUd5Sm1WVDMvQzRUTFE4WEM1VVIwSDBQNGk1NUNpb1NORjVFRjYyVlJJTnUz?=
 =?utf-8?B?M3h2SjhTYUc5cml0eGtrN3h4dEhjSlV6Nlo5ZThjNHUrcGlndDBZZlhIU1kr?=
 =?utf-8?B?Z1NhRm9uWDd6WE01aDFQMldUUXZ3QU5EYkRsc0lOcmJmcjdaMEswd2hXOVA4?=
 =?utf-8?B?VkwwdHJGSG1WZW94VkpKc2RYTmdLYlhzdUk0Z2s2ZzRvakNtYkx2WXMxUXJI?=
 =?utf-8?B?L1NKeHNwc0ZOeC8rRnUwMzFpOGc3WUx1WmFIM1JaZFZqdXYxNlFacWlEdmp0?=
 =?utf-8?B?Z3o4d295NzQ5WWdIbDhwTWljZm4vWnFHYXIwSkZwbjNBOEJEUHlqUnUrMkZ3?=
 =?utf-8?B?cVBXWDk1dWZ3VGdRbSswSVhGOVQvZW5IeUdZTXg5aU0zNXRPcXc1VG5hSmdQ?=
 =?utf-8?B?ZVRkQ3l3dnNWcWZ4N0NsZlFsVjgvTWIycW13UG92THRnd2FRMHBzeXMvRHlw?=
 =?utf-8?B?Q3NLN3NrMFFONE5kcHNZRGVEYVk3ZHpScXJhVC9ZWENKV2dkZ3dkYm1WTm1P?=
 =?utf-8?B?cnc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b69235-0aa8-4e52-1ce3-08da6798b6ba
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 02:04:42.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kylVHAJGnhVN3ZX/Cboau4HrXE8iJ7z7C5Nv45CGnEXPehuop7SvDVNMV7FzgqY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1404
X-Proofpoint-GUID: LJMx8M-7vCtjA1Bl3YmFEoQZCwAwGxAZ
X-Proofpoint-ORIG-GUID: LJMx8M-7vCtjA1Bl3YmFEoQZCwAwGxAZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_21,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/22 5:51 AM, Pu Lehui wrote:
> Memory addresses are conceptually unsigned, (unsigned long) casting
> makes more sense, so let's make a change for conceptual uniformity
> and there is no functional change.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
