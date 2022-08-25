Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA175A1C4B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiHYW1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbiHYW1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:27:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379BD9DF90;
        Thu, 25 Aug 2022 15:27:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PLKLA7008723;
        Thu, 25 Aug 2022 22:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uIRJID3LAJHLn56d2ckol3zTVVFpd3+RYn34pkioEtY=;
 b=YvLj7DTN7mTPlclES3d0edFCLZJztPuRPiu9KlHVridaip6/KddLwmSiOg1lIE7KGv6h
 bvl/easEwDvhUXoEEu2naYFTQyxJXXUNFVKUykZpSn20l3+qXIEqm0TGZBbqYKP3YC5v
 fHuAFJfgZxZuCFbhW5O2fy0Pg1LpNH5daJA7vVh6e+i6iW+pCqa55VVLGhB2GywOi0w+
 fYrc3iP1ZIqpiY2fVf/2Rw2fsm9dMiFLBiP/2heQPIdodrEAd5oE38TQH7cbvi47DkWb
 VA33UIhvZdY93ZEELhq7WwprWakzinRpq0SXT+1V+lXQVwz4Na2NBde4HreG1GNGVE4y +Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j55nyecg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:26:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PK0508003538;
        Thu, 25 Aug 2022 22:26:19 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n6q2wj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:26:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv/zSYVp735qX/lBRffkI7/QKLyR1WLThUpF7jc6zSqVoOl85G4vBl/XhW8xTbeZMXbiD42vNakXF+pOgSq2GPP3tvQqjQgch2rwUPsDEZ5BjfWBsSbi0vE2HzvSQJyutEODjNUlJxHKSlhPUHFhiO/Nf8OHP7brUk760eJxJqZZfKxq+3BkyrMn7RAlHP0OkPcwLwTzJlKmq6gK6MMhDPREuff6WrL1nEhH5qYmpGejIyemxrJI0bmQ5yyV+osfA3FC+FuZLMWgMxYTJXbAAmsj6R35WCQyG58xGgbKzt0FzSYJCW1hdYLDx+Ld3w3IcswA8EcNMJZ+YUGzwvjB+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIRJID3LAJHLn56d2ckol3zTVVFpd3+RYn34pkioEtY=;
 b=HR+DWm69koJOOx3c+y6uhp34OQBNBWbtIRoE0ufJC6ASaEgx2z4LVP0OetGr/Y1OjPYt5tHd3lQwvXucfOfdV8Xu78LGLgr4Kc7lm2N9Y7JN7LSttnX9jtefDlo+Ra6VaSw8nqSqKXh7eTMOj0XeNwWG3tGmQd8hhL6ZmnuXvoJh0JPBoSoYLcye3iKB/Etas5ZeBsZpguvw16yDHr1FAJDogKnQZdPEPuiCBBY/n7VL+iSJitg4QO3yBJia4YIz91cjPlu9OG64yFtXEY3ZWmchAtibAcWNfotKCn3U5q/J6VsdrymE3rqmm9+CSEIP9Hte9Y/m7cco8Jj1m7yUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIRJID3LAJHLn56d2ckol3zTVVFpd3+RYn34pkioEtY=;
 b=C4kZvbZblDsm2YEtXb2YGr2wClo/4PoFClquIzMvB61gedp7GfERIX9S3/s2wkZ+SwUEuhM5H0NOewNtDNQOQQ+ihWD19P2Q6UxKabT+HQfy4UloCJAvd4LqTONBMCwzpmQLL8F7XGAI/ml41vGtEhWST4gaJYXsrDydw3JGYxw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 22:26:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%4]) with mapi id 15.20.5546.021; Thu, 25 Aug 2022
 22:26:11 +0000
Message-ID: <8342117f-87ab-d38e-6fcd-aaa947dbeaaf@oracle.com>
Date:   Thu, 25 Aug 2022 23:26:04 +0100
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     jgg@nvidia.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-6-yishaih@nvidia.com>
 <20220825144944.237eb78f.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220825144944.237eb78f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e2f0a9d-c57c-4b39-c57e-08da86e8d03f
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxIMcxC0Kt/Za973N4K24jl3cV/FcKmAE+q8XupSub4724RPNCBuHOz4cj/5exPdLog4tigUbQYGOBmYyNHnD3gYW03XiHyVckL3LFysyZJvF37exSZ9d17HS4/USbSafOy9wUv8KvVxIOSHTl4hhHa+iqqGB391Mr9SCHulENKf7lqbeaHXDGEJUpnRoyfLrnfvuWthYiHS1lA3VV30iQ9z6KUAdcdIOmSbrZGZfuZAeyZaYneCy+hAH4CknVr4uYsiGxXgqAyaHNVBgiJLkCCBDV+RsqSYXr74mAFD2J2+Tww/YQ/LSBhArBQ57K8GwdBx4zaogEvoAJBNb+xhjGGXF15Thv51oBubW5WOkf9SoXG5CDrbHGQJUxHjJOVefTJ9n5EqQK7viZJU0oiL5bEREnLbJctuHIsairzmi7lvyN/gwlrzWlTXVsXJ4B5NlPjnlW0zwlS6bPgqnWD+ZgV1jqMGM5F++0y+HcD6zdEHnZHtyRV0Gd7UkA1bdwv1DfMX+wfHiec3c3wcXliKUVvZbi8BozhP+SOSy3v6H2EXaC1uoiT9WVPTdDrzDyQjtgZYrWELXArPp9SgTzuKNSI/l4gWUF7uV7+1albr4NDdi7Hl/b7dB3Gphmo1VtAVvKJnUgtOQeA64A7GqJ2mK/xkMpd1vZGd1qGduORASOzUCmWCtW0mxeO+gKplPWQAnYjThh/0rnN89N8joi45ydvldjaiZkH8hQNMMUGPa41N0utbtd234eCqGZ6mKhYkDekTHyy0IK8LwHZoIIfV2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(346002)(366004)(136003)(6506007)(6512007)(5660300002)(6666004)(26005)(53546011)(31696002)(86362001)(478600001)(2906002)(6486002)(41300700001)(7416002)(8936002)(186003)(38100700002)(2616005)(4326008)(110136005)(316002)(8676002)(36756003)(66556008)(66476007)(31686004)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVhnZEl4QW8zWTBONTlnZUF5cC9uc0lZK1dxYksxUzY4UHpxNXBqSjlHSHFk?=
 =?utf-8?B?LzczaDFZSUY4OVhrcG81Yk91MnVIRTM2cnZDc3Z4SVZiZmxSNGpoTnlUck5P?=
 =?utf-8?B?KzkxMGZmNlgrSkxjbWRUZnRnNExnK0RxdGx1eWFVZXRMcE45ZzFqK0dzOEVV?=
 =?utf-8?B?Y01pM3JVOWVtaU4yd29jdERjay94YW04Q3ZFV1R2QXJEUmVGSGhocERtSDUr?=
 =?utf-8?B?M2hxUW82OTMzQmJ1ck1Bb2g5NWRKcXZCZDZ6WnUzaG01N0V1M3BYTzlVTjRa?=
 =?utf-8?B?SkFiSm96eERJaWZBcERVZEwwSm5WaUQ2emxOTWVBNGxCRjVrTkFISURtd090?=
 =?utf-8?B?SmZIcC9qLzlEa2pDaFFBa294NWd5VWlodFVhWnprbStpbkZ5RDgzN0lXYlNw?=
 =?utf-8?B?MUp1Z3hBa1dkS2phR1NPV1NuTEZ3dkU2V1dpRno4NUVxaVNkWE80UkUvL2hv?=
 =?utf-8?B?d1BScWsvY1poVmQ2UmRuWjUrai9iam5yNUw5MjhkM255VUhlbU1oOUlPZlQ0?=
 =?utf-8?B?aE5pSGRhVXhLUXFIb1lzWDZFZmZWcXhzdFVVd2tucEZIYnVMMkpkNGZpMUVU?=
 =?utf-8?B?bS9ON0ZnV2ZXb2dLN29LbDJHdzhrUDlKaDhGQjJTWkJhWWliTzN5ckR3ZlBZ?=
 =?utf-8?B?TnhOdFUrV0h1ZUd0RWIvWjN0YStnWEF2UWJGS3lWTzFUNW5ReTdaN3lpc1hF?=
 =?utf-8?B?cHo3ekZkYUwxWWN6WCtYUnJrdGRmL2Z1ZENPYlRYOXZLZHlwblM4RXZ6alp6?=
 =?utf-8?B?bXdYNXE0c2MyK21VN0FWSG5GMy8xb3pHK0lRRW83enI3UnFYcVJHcmwrM05q?=
 =?utf-8?B?QW9hK0YrM2VBL0k4ZnB4YVI0TTJOQ1A3UVVkOUI3UWlrT0wxb3FTbzV5bW5p?=
 =?utf-8?B?cDUvUXpRVnlvWmxVYVpvc1JVTlYxeVlKdUgzbk8vUTEwMFpuaVdxYmpCbk9s?=
 =?utf-8?B?YmJnTWFDY0VsRGZndVp4d1lXSjQrbWVwUzlQMjdxMEUwQXVLTmVMdU1LYU01?=
 =?utf-8?B?NmNHWk1LU0o4SXhmLy9mTXZaSURHcjhoRXUxM0c2V1JmeTQ5KzFKNXdXbWpP?=
 =?utf-8?B?S255SUhjS1hwdmZKWDgvUTJ1WldwSVlLeTRYcjhuUHZ3clpNUnpuZDJHNThl?=
 =?utf-8?B?RjM1RFNVd1V6WldCYzdOTjY3bGxlZVBCcW9aWXV6UCtUK3NMYzhQZFNjeEMy?=
 =?utf-8?B?dlBwTGpQdnIrS3lJbVc3STJSVTR5bDNBUEVFWmx3c3pDNXZ3ZmVKMnpjSjFm?=
 =?utf-8?B?SXVPcjVXUkpBcEZIdXl5dm9EckdFWFJBVStkamFqVUtzT24zUEhZU3JUR0lr?=
 =?utf-8?B?V2k0MVhWaER4K1dsMFNrY2RqQVJvVElQRDlOZWx0QmpVK1B4Q1NJSkllRWky?=
 =?utf-8?B?VEI5ZXdMRk5nc3UxNDVWVHhiVm5WUHQ2SHhsdGJYTFVYRFdOalI1N3hiMHcx?=
 =?utf-8?B?RzNWNlBNV25QS05DUUt2WWtiUitEYzhCNmJoZzVqWFVqM2JMbGN1TXkxVU85?=
 =?utf-8?B?ZzlEdzdIWlcrTElWSkdVcnBEOVRyMnZYNUJaWTQ2QmV0eVpxR25zT29wU1hQ?=
 =?utf-8?B?TGQ0V2lQOW83bk1uUVk5a1lrMnNtcC9SQklTS0l4MXQ2RXMvT0ZnbVpDSUVZ?=
 =?utf-8?B?YTRneDdjOVE2OGVOWXVnMWpQYWJHZVNjeGJSWS93a0lpZU9MT0xlcEN5aFVV?=
 =?utf-8?B?bkZGQXNFUEx2ZDRWUTc2QTRkN3EvMmYvOHE3YUhZZ3BTd242RVhWemNNT3R1?=
 =?utf-8?B?cnk1YXFiUCsyUFdvOGVKMFNFcGlkeUpVK1lMdWhzTHZ2VlVLTVE1NHRnYWVt?=
 =?utf-8?B?aU5jQWFSMm1FRldNUjdQMXhpUHBtT3AxR0IrVjJHOVhJV3NQTVIyL08zcEZo?=
 =?utf-8?B?RGN2WENHNzF2L2l4TDhaQXpidXFiY0ZmWUJTU2FGb3FNbHF4d3NaVzlWcE1P?=
 =?utf-8?B?ZnVxNllqNGRDME14VWlYZms0Zi80SCtYYjlrYnk0Z3VZQ3lYZ1B4Q1IzVEU2?=
 =?utf-8?B?TGZ1RzZISU1ab25obGc5RHB5OWp5NTkvQkRIeWRIb3hXMEZSblJBdnhVM2Z1?=
 =?utf-8?B?SVBTVXlxRHA0RjdkSkFnZUVlT1pDVUUwOGVEVWMxckVZUUFNZ3dTbldGVlZK?=
 =?utf-8?B?aTlUVi9TK1dxUnhCVkFwYURhQUhuL0FzQWhNeTNaR1IzUnowQkIvYkVlMmVC?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2f0a9d-c57c-4b39-c57e-08da86e8d03f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:26:11.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NplBjA+O6Pf4GbPXZdqOZ+kh5OKSlY6LHeWTfFHQLRdYvOPmnNmiRGLPjR7yUa/VJA1StHvU09rff7kDvB9U5bjreAkDFdfv5xGOVAVWJeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_10,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250086
X-Proofpoint-ORIG-GUID: fQDr1eYFJCwqZmna3q8Fdpm8OBFxUzOp
X-Proofpoint-GUID: fQDr1eYFJCwqZmna3q8Fdpm8OBFxUzOp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/22 21:49, Alex Williamson wrote:
> On Mon, 15 Aug 2022 18:11:04 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> +static int
>> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
>> +					 u32 flags, void __user *arg,
>> +					 size_t argsz)
>> +{
>> +	size_t minsz =
>> +		offsetofend(struct vfio_device_feature_dma_logging_report,
>> +			    bitmap);
>> +	struct vfio_device_feature_dma_logging_report report;
>> +	struct iova_bitmap_iter iter;
>> +	int ret;
>> +
>> +	if (!device->log_ops)
>> +		return -ENOTTY;
>> +
>> +	ret = vfio_check_feature(flags, argsz,
>> +				 VFIO_DEVICE_FEATURE_GET,
>> +				 sizeof(report));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	if (copy_from_user(&report, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))
> 
> Why is PAGE_SIZE a factor here?  I'm under the impression that
> iova_bitmap is intended to handle arbitrary page sizes.  Thanks,

Arbritary page sizes ... which are powers of 2. We use page shift in iova bitmap.
While it's not hard to lose this restriction (trading a shift over a slower mul)
... I am not sure it is worth supporting said use considering that there aren't
non-powers of 2 page sizes right now?

The PAGE_SIZE restriction might be that it's supposed to be the lowest possible page_size.

> 
> Alex
> 
>> +		return -EINVAL;
>> +
>> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
>> +				    report.page_size,
>> +				    u64_to_user_ptr(report.bitmap));
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (; !iova_bitmap_iter_done(&iter) && !ret;
>> +	     ret = iova_bitmap_iter_advance(&iter)) {
>> +		ret = device->log_ops->log_read_and_clear(device,
>> +			iova_bitmap_iova(&iter),
>> +			iova_bitmap_length(&iter), &iter.dirty);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	iova_bitmap_iter_free(&iter);
>> +	return ret;
>> +}
> 
