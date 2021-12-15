Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F314763C5
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhLOUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:52:37 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19348 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhLOUwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:52:36 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFIGTup018877;
        Wed, 15 Dec 2021 20:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6/hG+9/RQhME6Mcsws6mdOxIpDo5UWMO5QZkAeg1hr4=;
 b=OdTIrsmLTiHkSK9bq/C6Yf7E5nFf0z2fD2n3QNSRu/EY/du5iGUW7KjHEkIfWVX72S+K
 UJhiRKtRBIYcYsILnqdXr8z/cGjBmR+DPw9n+ruewURxJSptB1yDhTH9wWHoUyvk9RYr
 sm7V/gyvN2G0STlx3Ks9R1KbKfypecehLnpUU016SmcCbFbCiT2PijFTFNnUYvbQJmTr
 NiRPdCGqiRJVPe5o6+RvM1N/8u2QextWYeBxgtZw9Ihw4livBrLBVwqk3R4tlQmy+8A3
 EbQA6YPxvqsZg+1/tIk9tf5tc42m/17lmDOZKBuv5YlDcLvQB3fDApE9ALMrlpsOyBaW ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknrgtcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 20:52:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BFKjkfY029032;
        Wed, 15 Dec 2021 20:52:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3cvnesj2t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 20:52:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD2+J91BhdVl1sBQwV3ZEKyriiYHNOpT08+cU34Tq106TDBXQqFs+vCodvIiwZVJeDtBeFJUvL5lAxNWEJHK46C9ygLcyfsbs3lApU0dPy6eYSzr4hEWYhtLrZh3Xl73U6asACgxPkOG+ODIQU4Yc6qx00fCk0SLCINa+FKYcrgYurqszDaavqQSLVxZ5fMkEe0m7/+gxpSAeSiR25re30JzwTnAvPBbrUIRsIVRClBgytU3HQvQPGEcTnk+CnnaxtzK7Y/DyVxShlBo7bWUHaBL7jI2pDHHfTl04PzrxZPLuXVKWtvu+ThjaitrvomH8n3abkGyv3Vm23kaHuxn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/hG+9/RQhME6Mcsws6mdOxIpDo5UWMO5QZkAeg1hr4=;
 b=Yi/DMUvTm05XJQmRqAFxGPvUEYmSdTIe563KJtVEKvrl5r/Zv8T7GvYvLzGm9epQ6E3WAVGRhAO7lyhQArFJZiVQO6Dqc2sJ9r/Sd3mekJtmk0gpvRljHdHkRLwvwGpMYyyoDkUtgKdxvzh06j0pLRWMTB03sKgxW+xXhUjr7vTFlCd0AFovrvyBqthN6kPsoBXtDhugMWB3Zc/cmtM+9NpOuiyLZcIpD/RCrDWI8zmc0bX9BruqcbevsdKPbY32pC1jRRG9iNrVaPSK0IuuaeyRBlS2lx24wijnTDUK4w0Zpr05CsnDuPAyaVCqV8ojrLXgwYfjKNP/x9G5cHgXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/hG+9/RQhME6Mcsws6mdOxIpDo5UWMO5QZkAeg1hr4=;
 b=a5cwChzcKTCVbwUbAtL/rbdUzPxuqwhW5fyRvbMz6m6D3xgnIKmRIlEc1kO0G4O5vcHo7j/NcKyMNl3fJs9j/6GKx/2Ri8Clezlm6c0kTva1dHLdhuAlpg0Ee8WN9hyXrMDiBc6FDY867a4fSyfiZQczMKHzCdVJs9jwna+sAXo=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 20:52:26 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 20:52:26 +0000
Message-ID: <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
Date:   Wed, 15 Dec 2021 12:52:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
 <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b836775-d1db-46c1-3b86-08d9c00ccce8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4337195B3B89D16FA59BF994B1769@BY5PR10MB4337.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Vq9mpMWgumt19k2R7AzotPDX1li1Yka/EbMmL5WZozS9Q6RnDAYvlWH+OGgteKp5JyKIhJMJCdTJPWbdZ6Vhku+71zEGOOQooMFcwCsZ5gmpsPcrbIlDvUJn1PxT3aTxlKFJsz7aecbwugT6csTbfPOBIBGducJrA0daXONyUvFjSh+FvRslBgytvWdRhnqUEkZLJbuOkztX52Pj/cXty4Ynw6ce9uhCItih6HgkbStN/1IcjZnxMMx2f1ohzOXR5pS5xXD6BZJScKDgwl4FREsh9VqyGGON6RARECPm9mF/zgVA9NaG/3qDx52KM8wOAuIKClZtNo7KenW+aoTY38AQip5lEAkmXkkvCl5n5yHTlOW+3Yh7cl6XLrNEv9xaCi158kmUTntQb5at0IEGR0U+fuHcULISrim9hmEac6iDhI/OtW/PLsUv/67lml/3CNxM+Nzxncy/aYkI24zHdGmfu96lLzOge2FQw0qSzIhZoqOMHXts1AZUf8PwoaRQtUHuJUvFRMnVTb3nAKltM40wmqYNaCdPYc98jH2l9i0/4LEi0C/M4g15gtv+7KILt0RFmCbGyJwW+aZnjiSlbh7ZnTTKmzgMEDuS+e2YMuEXEHgPAqrLvydEu4Rh9f1yKxLvR1iv+Cc+n4DWU3GrnutlPxqU44wHj/2aXnuyNQmlHHbRqe/x1G1/JxXjKSOxXKr4dFqjHuYDXqkIUEJHNs/lr+avB9sD0zEcOHDI1WlHqLjHMUGTx+gZtg/PP6sQS/uKwp9oHH3mbRGwPO/Xr/R46ppfbG3qGxXc7+MjUR2ZIE51g46pIUpGEQvbL4M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(36916002)(66556008)(4326008)(36756003)(2616005)(6506007)(86362001)(53546011)(6512007)(8936002)(6666004)(966005)(6486002)(5660300002)(2906002)(26005)(6916009)(38100700002)(186003)(316002)(66946007)(8676002)(83380400001)(66476007)(54906003)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGpkN1F0eXFJY2k2T3FSWXZEaFhNNFF5K1oxNVlHbUQ5a2xkamQwNDh0c3dM?=
 =?utf-8?B?U2lkYnJwYkhGUlNWaytUaHJEMDNjSnJrMkxuR0M5dWVhcjhOQTF2bnlDbmg1?=
 =?utf-8?B?T1FYQlkvYW5OajV2Q3FvQTBVZ0UwckVaMkV5ZFhrZkh1ZlpSa3BHMll6cTA5?=
 =?utf-8?B?Z0EvMmQwcE43cVlaQVFjcWh5Z2FNVlhLZVcvbjBIWTJXN1kzWXVVUFZqQzl4?=
 =?utf-8?B?U21aZlY0RlNsYjF5dldiTTVwams0NGNDRGd3c3ZkdDNkNHhsQWVZaG9oWGxo?=
 =?utf-8?B?WlppYVdUUGw1Z1lHaFFZdmVJOTFIVEpMaGdUL0thaWNFN1MrR3dSZmVJRWoz?=
 =?utf-8?B?MDJDcTNVNFZvSXloaEdiNmR2ZE9FTUwrNnpNZWxwa0hLN2NTR29HbU1Ud2Yr?=
 =?utf-8?B?S0xRRUhWcXdsV2JGOHlHOENXdlZxTERUMVpxQVhnZWxwanJ1cEwwbHAyK1R2?=
 =?utf-8?B?cFlPTEpvV2J3Z2xUWEREbTVuVzNYb1hRVWt3ZXBZdkxidUduRUdzZFloVWl2?=
 =?utf-8?B?UHcvOGo0Vm5UVk50V1FKbkR3ZHQxZTJ6T3JFSSsyaEtyc2pKbWMrdEtMcUZQ?=
 =?utf-8?B?TnU3N3lQcG02K0pIQjU4bnZrNFBtQjlyQ1lqTFRPaDV3bVNhTi9CYVliQXhp?=
 =?utf-8?B?UitqVXVDZW4xRmw2WGNRVi9VQzY1LzErTkhTdExkY3VGTFpOSjBrczU5R2Mx?=
 =?utf-8?B?L3NUVlhUU1J4VExYNXFKSy9UTnhWMGwweTZiOUdqZUI2WEl4dFRnSW9KTU9y?=
 =?utf-8?B?N3FVRnpYK1dKVDNDVk5obXFrbHpqWkhQVDVwWHp0R2FBSEhnMlkyOWlJakdO?=
 =?utf-8?B?TGZ5YndKdkN1UVROQVlhMDZ3V2dBWUtiNjBUczF3aTY0TTMvMzd5d05CQ1p1?=
 =?utf-8?B?cEVsaVFQaXlhckg5MklhdmVIK2VRWmQ4MkxveWVsVDFGNEZsVHZZWkR6TDZx?=
 =?utf-8?B?S3dSTjR3RWRFamlRZm04S3RDOWZqNFNhc3l4akZ0a3YvQXpwV3NWMUNCd1Er?=
 =?utf-8?B?V0JVRzlMMTVXcjFOaXJRTnZmV1FWcXY4R1RYejFxWmJkZ3F6T0RBMFVOVWJi?=
 =?utf-8?B?Z3JkRUpqUkVvWWJ0VXo2UmNqbU5kT3VzVTVwR01jN0VWaE9qVm4vMnNVSHZn?=
 =?utf-8?B?VDhjeGZ0VkZybHJRMU8wNmxQNExZMGVKYWcrU21DbjFSR1gwMWgyVmx6K2Q4?=
 =?utf-8?B?Q1FST01KcFFnT3VQTlFOSTMvam81aTF3WnBMSnhMeXAvKy9YOER6MWdCRlV3?=
 =?utf-8?B?YWQ5cUlmQ3V6MjVnL3pseVJ5RWlSeWNXN3lTRHhxMzAwMkcwODVzbXFsc3ZB?=
 =?utf-8?B?eVU4Q014bVVqd0ZxZlVrdWZNNTVERGRYY2NsdTlnNVIwQlR0QXVpQXdKQXBF?=
 =?utf-8?B?clVmaTFDVW16NGxreXpNb2ZQT0gyQ1VGQzJjUmFYMyt0RWU1bUxCbmpkd2tB?=
 =?utf-8?B?Y3d2TWxaQ2NGbVNlRFFzM1FTYTRtS0twUStmM2Z2WU50cEFXRzBHMmMzNjZa?=
 =?utf-8?B?bGxNQ2xGUUxpU1dXdDgrSVh6U0gxTjZBM1laL0tJbUV0ampPYVF0MGdkWXNU?=
 =?utf-8?B?RHc5RXBhaXBSdWx3QUx3dWJEWWkvNzJGWUIxOHZETW1JdXlkZzEySXJUc0hK?=
 =?utf-8?B?QmhsKzdxalBESXZBYVA0R2dkZndmS1FBczlEeWE1UXFyN2tRMjRyaHJKdDF3?=
 =?utf-8?B?RDFoVHVnV2dEcE5sdWdyVW0wT1hDdU1CbllQZE9WdGRkYlpRQkRRaHUwZ1Mz?=
 =?utf-8?B?ZzBIS3phQmtuOEI1SSt1eTRiMzVKZVdpbUI1NVBXMFo2YmR5Q0xxb2U4bitB?=
 =?utf-8?B?Q21KZnlFeTJIdzBaL3dmWVZmei9xdzErWU0yanlrMjNEcDRFWXA0R3BLNmIw?=
 =?utf-8?B?WGtMVStGUStVQkQvWDUzelpjdjJkNVRtRDlqb280YzNCOVB3b1luV2htejl4?=
 =?utf-8?B?SWVsaytYc1NYeDArK09oR2s3T3o5bnFPMTFRd2tqTmNNZFNKaGt3bEp5R0hE?=
 =?utf-8?B?NWpqRzVPb09yWm9kYStjK3djbHYwZlc0ckMvUjVIMXZNb0RneDdyY3BndVRY?=
 =?utf-8?B?VTdpeHpKSThzRndaMkVmcFAwcW40ZEtmcVQwd1ZHM3R0VkZnY0ZBcVIrMG85?=
 =?utf-8?B?dVdYTnp3Y3ZmODc0M0pYNTMxcEpPTGtSWDlQcm40SUlxVm40ZEsxODBNMkN5?=
 =?utf-8?Q?9OnVRSxQOr4o2mAh1YGzIu4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b836775-d1db-46c1-3b86-08d9c00ccce8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 20:52:26.5016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xGk5SIlX0Lf4ufDQCfFslrKDBa53lRGiKTdKrGrtgDo0ToZMLMkHCDeF2tzl/aGRI8QG05mwmEqzOC2RA/biw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150115
X-Proofpoint-ORIG-GUID: n21MkkjZeAG1tKzKewt4luP6lUl6y_C9
X-Proofpoint-GUID: n21MkkjZeAG1tKzKewt4luP6lUl6y_C9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2021 6:06 PM, Jason Wang wrote:
> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>>>>> it ended up with. I have the following questions,
>>>>>>
>>>>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>>>>> support will be completely dropped from the table, is my understanding
>>>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>>>>> which is backed by the spec at
>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>>>>>> if there's request/need to support wilder legacy virtio versions earlier
>>>>>> beyond.
>>>>> I personally feel it's less work to add in kernel than try to
>>>>> work around it in userspace. Jason feels differently.
>>>>> Maybe post the patches and this will prove to Jason it's not
>>>>> too terrible?
>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
>>>> layout level and is limited to x86 only, there should be easy way out.
>>> Note a subtle difference: what matters is that guest, not host is x86.
>>> Matters for emulators which might reorder memory accesses.
>>> I guess this enforcement belongs in QEMU then?
>> Right, I mean to get started, the initial guest driver support and the
>> corresponding QEMU support for transitional vdpa backend can be limited
>> to x86 guest/host only. Since the config space is emulated in QEMU, I
>> suppose it's not hard to enforce in QEMU.
> It's more than just config space, most devices have headers before the buffer.
The ordering in datapath (data VQs) would have to rely on vendor's 
support. Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w 
vendor nowadays can/should well support the case when ORDER_PLATFORM is 
not acked by the driver (actually this feature is filtered out by the 
QEMU vhost-vdpa driver today), even with v1.0 spec conforming and modern 
only vDPA device. The control VQ is implemented in software in the 
kernel, which can be easily accommodated/fixed when needed.

>
>> QEMU can drive GET_LEGACY,
>> GET_ENDIAN et al ioctls in advance to get the capability from the
>> individual vendor driver. For that, we need another negotiation protocol
>> similar to vhost_user's protocol_features between the vdpa kernel and
>> QEMU, way before the guest driver is ever probed and its feature
>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
>> from the device, but we can assume weak ordering for legacy at this
>> point (x86 only)?
> I'm lost here, we have get_features() so:
I assume here you refer to get_device_features() that Eli just changed 
the name.
>
> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
> 2) ORDER_PLATFORM means device requires platform ordering
>
> Any reason for having a new API for this?
Are you going to enforce all vDPA hardware vendors to support the 
transitional model for legacy guest? meaning guest not acknowledging 
VERSION_1 would use the legacy interfaces captured in the spec section 
7.4 (regarding ring layout, native endianness, message framing, vq 
alignment of 4096, 32bit feature, no features_ok bit in status, IO port 
interface i.e. all the things) instead? Noted we don't yet have a 
set_device_features() that allows the vdpa device to tell whether it is 
operating in transitional or modern-only mode. For software virtio, all 
support for the legacy part in a transitional model has been built up 
there already, however, it's not easy for vDPA vendors to implement all 
the requirements for an all-or-nothing legacy guest support (big endian 
guest for example). To these vendors, the legacy support within a 
transitional model is more of feature to them and it's best to leave 
some flexibility for them to implement partial support for legacy. That 
in turn calls out the need for a vhost-user protocol feature like 
negotiation API that can prohibit those unsupported guest setups to as 
early as backend_init before launching the VM.


>
>>>> I
>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
>>>> 0.95 support, it seems all the ingredient had been there already dated back
>>>> to the DPDK days. The only major thing limiting is in the vDPA software that
>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
>>>> a few DMA setup ops, which is virtio 1.0 only.
>>>>
>>>>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>>>>> of vdpa_get_config() to vdpa_set_config().
>>>>>>
>>>>>>            /*
>>>>>>             * Config accesses aren't supposed to trigger before features are
>>>>>> set.
>>>>>>             * If it does happen we assume a legacy guest.
>>>>>>             */
>>>>>>            if (!vdev->features_valid)
>>>>>>                    vdpa_set_features(vdev, 0);
>>>>>>            ops->get_config(vdev, offset, buf, len);
>>>>>>
>>>>>> I can post a patch to fix 2) if there's consensus already reached.
>>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>> I'm not sure how important it is to change that.
>>>>> In any case it only affects transitional devices, right?
>>>>> Legacy only should not care ...
>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
>>>> modern one in a transitional device model rather than being legacy only.
>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
>>>> guests without having to reconfigure. Or are you suggesting limit to legacy
>>>> only at the time of vdpa creation would simplify the implementation a lot?
>>>>
>>>> Thanks,
>>>> -Siwei
>>> I don't know for sure. Take a look at the work Halil was doing
>>> to try and support transitional devices with BE guests.
>> Hmmm, we can have those endianness ioctls defined but the initial QEMU
>> implementation can be started to support x86 guest/host with little
>> endian and weak memory ordering first. The real trick is to detect
>> legacy guest - I am not sure if it's feasible to shift all the legacy
>> detection work to QEMU, or the kernel has to be part of the detection
>> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
>> effort in QEMU) as well. Let me take a further look and get back.
> Michael may think differently but I think doing this in Qemu is much easier.
I think the key is whether we position emulating legacy interfaces in 
QEMU doing translation on top of a v1.0 modern-only device in the 
kernel, or we allow vdpa core (or you can say vhost-vdpa) and vendor 
driver to support a transitional model in the kernel that is able to 
work for both v0.95 and v1.0 drivers, with some slight aid from QEMU for 
detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for 
the former we still rely on vendor for a performant data vqs 
implementation, leaving the question to what it may end up eventually in 
the kernel is effectively the latter).

Thanks,
-Siwei

>
> Thanks
>
>
>
>> Meanwhile, I'll check internally to see if a legacy only model would
>> work. Thanks.
>>
>> Thanks,
>> -Siwei
>>
>>
>>>
>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>>>>> know what the use
>>>>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>>>>> directly? Is there a
>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>>>>> BTW a good API could be
>>>>>>>>>>
>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>
>>>>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>>>>> legacy driver
>>>>>>>>> for vDPA. Consider:
>>>>>>>>>
>>>>>>>>> 1) It's definition is no-normative
>>>>>>>>> 2) A lot of budren of codes
>>>>>>>>>
>>>>>>>>> So qemu can still present the legacy device since the config
>>>>>>>>> space or other
>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>>>>> accessed by
>>>>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>>>>> in this
>>>>>>>>> case?
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>>>>> seem to work for people. Any changes need to take that into account
>>>>>>>> and document compatibility concerns.
>>>>>>> Agree, let me check.
>>>>>>>
>>>>>>>
>>>>>>>>      I note that any hardware
>>>>>>>> implementation is already broken for legacy except on platforms with
>>>>>>>> strong ordering which might be helpful in reducing the scope.
>>>>>>> Yes.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>

