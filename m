Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D444767A3
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 03:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhLPCCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 21:02:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59934 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhLPCCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 21:02:11 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFMEBOs002578;
        Thu, 16 Dec 2021 02:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qwvzKCyu/WkCDgCkrl+wG9kWa5Fsd7peYWaBmQ4ywLU=;
 b=x2GL8D7uXhSBUHuimuVS6LH6sg77j2jgzUapPa/8jUjLXfwtmOCx7R/zTJ3ySFG/URIt
 u5j7KzX1srC8Q7avNgPE4kNxDYK0sv8zVPcS9qDXRH35IXxGr5wt/s6L0dW7Z6rkn0Cf
 3dWCKSGeJ4Fa9Ts7vTyOTPG4OZkMdEX/xWhEzb9h35gqxTU4LRccHhFiEmtN0nqtCG0K
 FcljfFEGMIVexLRXCYZ4OMDls0TCDnsDPMslJ672AEP/g1antbxbAkpiKDo/9bmXLB5/
 cN0R/RTJ+0Lfcto2dQ+mP6m79ZVJzaDBuRL61OuLrugeM5z6W5I9EGmuaXQVVgMpzexF ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykmbhbac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 02:02:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BG20YTk146063;
        Thu, 16 Dec 2021 02:02:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 3cxmrcqna2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 02:02:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oetzqDuv+rYUCtwCbFzuFXgJ9as+4oYKR/o3cmiNKzWO9aPOg9g/Efjo72jCk3Ub72jAtggoSc/1g562Q+TZFOjgM3dk7I+9c1qrCcH7NAtH7a4gCKqhNQxaD4xB75s2tJtD49/OIw6ybjKd+k7iJEbdBuwtyWS/dzvEM6aGZVILk7gZEevVOARw4TNWd7xPLSFERLxVKhZa7Rh/Fvpcdzf7tFnUzQKL3cyrdNpJJ80Mur9p2pNo3PCRwILf+qqpx2jEq2C/J65WXMTCh999CPaQyuoIgRo460uTWMhfZr4JMqQZoZuvzTokgyIy6CieEpnmnOkV9kxrFrchTneqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwvzKCyu/WkCDgCkrl+wG9kWa5Fsd7peYWaBmQ4ywLU=;
 b=kma18XC+bQFiwkcymUVmODEPpEm75VeBYdIGFKuFjxks1ro9vM0Euo9Kz4671kxMKc3C56REq5p4bbuHWp5mWeKVPDGmM2F0pXEAz1Rz/XpJX4auB7KSrXrfWO6MDrMPf6NqxTttpizU6wO0hvDFiQTDcY4K4ufELYmljJj5/HRoqBDTeCW4AkdOvvq4iH9CAI9g8Auo+ZznZ3wHuUNVS1dPWJvvFqIt5PxcO3Yx1kZf4392UYgwRlhDCyShY4dv7qjbr3wI05KVBZKNCj+hiynFRfbg7LQ6vYR2RTvU7hpBl9mmfdypIN4d6VTJ5jcG+fb3n7sJJntr5tKwWQD3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwvzKCyu/WkCDgCkrl+wG9kWa5Fsd7peYWaBmQ4ywLU=;
 b=iAGaJ/48kRYpEqZtewh4gyxEB+ThdVY9mpCsQR3rn0U5TDKlHvGR4C1A8FUw1C7MjqTM+9FiRPYoekvRpWA/zshLWVq4UTdVOfOeOpg8DJKN7KMOOCHq34Pm7z/25Ar1f2E0GJ+DZ6m+GCN0/Ol5+0nVn8dg/Ee4dLu8Xwp6YCE=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (20.179.158.139) by
 BYAPR10MB3319.namprd10.prod.outlook.com (20.179.155.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Thu, 16 Dec 2021 02:02:03 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 02:02:02 +0000
Message-ID: <71d2a69c-94a7-76b5-2971-570026760bf0@oracle.com>
Date:   Wed, 15 Dec 2021 18:01:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
 <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
 <20211215162917-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20211215162917-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0125.namprd05.prod.outlook.com
 (2603:10b6:803:42::42) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50bc5913-15d5-411f-466d-08d9c0380d75
X-MS-TrafficTypeDiagnostic: BYAPR10MB3319:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB33191295D62A332F5247BAC9B1779@BYAPR10MB3319.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89hp+IpHHRX2h9Dy+W87Xu3E3GhLgX9owTSKXhwWjMDUAJVbLpxTbbV9ZZN5KP3w5MUobgPgZh4xYfwjkAWOII2uLndaAQjTRvQWQUf24mZARyJRBJeBJbk8ISDHeLbHKxzfXABRQRJ0EY+8m93OfOz3UKrIaOIRghDOUbeHpa2RxrLTipy294EdwhnzxRKSaGi9ixGzrqRQLBgyfCX9AOvGYF/qdtfe3PsHsDQ2KWNklcy1RFBlQ+BMhhteMuk/FlI9+9WDMCxocDc+FSfT1L7VckV2KHXmnppkJeI3wp5GbUAJIihzCULtZGiiFG9trCqGrqACEdCj44r7QLuoQ2Uka4e6enYAMEo9+KHaKPVkJrGnwas/y+88B4h3cvj+pvpYpkEma1LrpaKUZ8YTrwcDQvgJGWMpxI2NZk5W6x0l85E03auSpccTV12jUQt4iz7DlVktGNMnrhRbXeNo0+dqBkSncQWzDdvJ+IEPG3bnHsSfJUHqQYbNl4p2bYzJmFooDZYfFWNsa250GtOLj99e/MtExFgGnW5BviWUXyOHfTXdliW88ZLhcMev+//I85VGeRPOyQS+JfFCKeV/94tyWRHB9fyGw6qL7xBgPGXmB0u3HtsoMBzKWK6F7vAoG9i6ETlcY4XwfOIL/4hSNLeuSCcPXuFmPelMKABU31D2j1HTus9bFyfbu5YlxDmzKv6D2v75RjBGUvedZ2lDDvKedk2manTPPN+xXjY+yu92iSaUje762WlWxCcVKY4FLfArR0ijUMsGb/M/79XyA8LF9ryGYeKKwSbxU9g96uly+UqnltPBhjVzlbnGYv2x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(8676002)(6506007)(6512007)(4326008)(66556008)(2616005)(26005)(66476007)(2906002)(6916009)(66946007)(186003)(83380400001)(6486002)(6666004)(54906003)(38100700002)(36916002)(316002)(36756003)(30864003)(966005)(31686004)(31696002)(8936002)(508600001)(5660300002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW9lYlczWWdQR1Z1SHB0RzN1cE4vVWo3OHhEdFlNWkhXbU1NOFdMS0E4OVEy?=
 =?utf-8?B?cU53VTdmSm5QN3NwVkp0YnVXZCtKc1pXOVgrRFpTSVdadW91UUVzeDJ2TUVE?=
 =?utf-8?B?MW5CMjhJcVJhRm1ndnQxOGFRaWR2Q01OQmoxQkRML1hoRlZUZlNtK01zWWNT?=
 =?utf-8?B?VmN6RXlPS1JhcXR3RXRDV2srMEpTWWNoWlZQbDZzZG9mRWYzeXE4eDBlQ0Rm?=
 =?utf-8?B?VmZSc0swUmpubDcwc1FkYmJzN2RXdjdiTnl3OU05STdWdTBodTQ0d2pZY2E2?=
 =?utf-8?B?bFpkaXU2OGY1ZFMzS2VxZDdaZG9ZTVVJMGc4b0RVaTk1dXBGbFU4eUpJcER3?=
 =?utf-8?B?dENCc1FxRy8yTTFSQ1FTcUJrNURwWkwxS0EvOHRoYWg5UUR5bmFuUUVnck9W?=
 =?utf-8?B?OTBMWjZ3NDFsMThkUVptWC9wN3RreVhhNFluWWxhWUVxQjlJZm9hWlI2NTdv?=
 =?utf-8?B?T2l6OUw5WXlhU1NGR2w4MGxhZ3lnN2M0WDlHSE1laXVrRFRhdnFmY2FaN2ha?=
 =?utf-8?B?YU9SVWFFU0RQOXRwKytuaC9MTjF0ZHNxeXRYV3hsZ2I4VUllS3NxSTJBWEF2?=
 =?utf-8?B?UGxvcDl1ckFaOVBnMTg2MU1CdnBKc0lvSUxZZUVpcHNIbVBIZnlXNzQ2Zjd3?=
 =?utf-8?B?M2dVUllKTnFnQnRuNm0zZkw1QVV5K0tDWTJsakNoZEQ0MTQwQ0RPV2dYWmJQ?=
 =?utf-8?B?RitLSzVUdm5SczFrU0t1cU1mVWFFRzdMM1QwNFRENjdLbkVPQXBxYk9xY3hE?=
 =?utf-8?B?eHRzYUZLUlE2b0V3emlCRWdyTDdQMGlsSXV4aEpaL3hGUXlYOHR6VGxUREZL?=
 =?utf-8?B?Zkk3STI4ZCttTmdoT0RqWGNMOVMxa3lvQ0krYkhUbG5NdE10K0w3R0t2MCs5?=
 =?utf-8?B?b1RTa2YvS1pkNDMwQldXRERXVE5PdFdNVTJuVHhheHlFWTFrd2o5THJaY2g2?=
 =?utf-8?B?OUFyTVdJaUwwWnJSN2tRNkxpVFZjV2hRc0wrMEdpVkVpQ2FDRHhhRU9qMmpa?=
 =?utf-8?B?Y3hQWVBJb1kxTmUwNHBPOXJqWXJuVmxRNndoTjJWOEF1dTd0cS9JQlJ0NXY2?=
 =?utf-8?B?U2lWOUF4VDcxTUlXdjd1QytYcS9RSGh1eTBFVXRQcjVabGZ4QzVDeENaY2RO?=
 =?utf-8?B?cWtlZW9lNTl5Y0ZTeGIrRXYveWI2Qm0zeGRDS29QdkpDQWdVU3BDeXlicmsv?=
 =?utf-8?B?MTNkMmdYRDQ2Y2I1RDNpcldiekk3YXp2ajNWbGpKS2pUR25RY3pLLzF3RzNy?=
 =?utf-8?B?MUovRXpIdEdRaW8vN21HVWV6cTRPcWdIS1U4SE5jcytUNUIvaHlJWHI5RWJ0?=
 =?utf-8?B?cWkwTldabnRuVkdySXZYSmZQd1lCSCtZT1NMRk5GdWkydXdVdVJnYTAzWnpT?=
 =?utf-8?B?OUc1dDI3cHhFb2pNOElnTHJaVExhNXBQWG9xZjdCVFM5Q2hTbWlMWkdGMVc2?=
 =?utf-8?B?ZGsrQldVRE9lOTdxdkdBTTZJL2xLK2tSY2NkTUxrTGRuNTFnNWhEUHZkSnpS?=
 =?utf-8?B?SkZ4eEdyd09WSWZTRnhJbVAzZW9LMEFTdmVnRGxtTVl3NmY3MXdLL1NETHhk?=
 =?utf-8?B?NzkxODEvZEE1eHBZZXBsSVVIcFh2RXN5OTcwSU5sWlI1R2ZCRHBnd2xuZ0R6?=
 =?utf-8?B?cWVMdUZGTDFMNlJuZkUwaHhXYXV4YjY2bUtzcmNXdWV1ZFJTdDAzdWJMWW1F?=
 =?utf-8?B?SnpjSmNwMzRQdlRJVk1nYlRXVjFsbkdFRko5aE1BOG54b2YvQUNVdFM3dE9o?=
 =?utf-8?B?STE3UFhaZmtwOHZ4S1lPOEJPeUxpN0RDNVhmZkR4ZXNYQmNCeUo3eXdMVXJ0?=
 =?utf-8?B?NFBXdmZ3a05UUFE2ZXI5L1pnZFVYS1JjTmxCbHd1MEZSNitYNmtidVR5dlF3?=
 =?utf-8?B?VlVOMkwxOC9CeWhnQ3pQNGhaZXdNTU9UYml3RVRWU2NrUDlPcTQ5SUF0eFZZ?=
 =?utf-8?B?d0hUektEd3YvNXF4UVJMRzcrMTROenFtVFhaQ0xNdXBrNUwxNEdTQ2RHOEc3?=
 =?utf-8?B?b1UvV2h2VmNFWHVpWXpYRTZaVUtydkpydWl1dkVEYmJsNjh3QTU1YXQ4MGFU?=
 =?utf-8?B?QUc2YzJzZldBdS9xeUdGaEVURklFREI4c3ppbGcrM0VWVG5oTElWMHlKeVN6?=
 =?utf-8?B?RCtRYndFQmVUNTgxbmQ1ZUJTK29wL0FsTnFhRkJ6QUtGTy94SENkZXk5NlFs?=
 =?utf-8?Q?UjvFkaoZBTaVf3ZQ8Gkv+tI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50bc5913-15d5-411f-466d-08d9c0380d75
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 02:02:02.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yfR47lQwpc0027bkwACPyEtld3nb6AzgZXOfFGXyWvrrQHSrMB3M54Z7TxmgtrdPZEdEVsAeT5w/FGPX+PgQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3319
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112160010
X-Proofpoint-ORIG-GUID: xv3ymOm2qe7AP3siLTdMVruPFE_ryV8l
X-Proofpoint-GUID: xv3ymOm2qe7AP3siLTdMVruPFE_ryV8l
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2021 1:33 PM, Michael S. Tsirkin wrote:
> On Wed, Dec 15, 2021 at 12:52:20PM -0800, Si-Wei Liu wrote:
>>
>> On 12/14/2021 6:06 PM, Jason Wang wrote:
>>> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>
>>>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
>>>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
>>>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>>>>>>> it ended up with. I have the following questions,
>>>>>>>>
>>>>>>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>>>>>>> support will be completely dropped from the table, is my understanding
>>>>>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>>>>>>> which is backed by the spec at
>>>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>>>>>>>> if there's request/need to support wilder legacy virtio versions earlier
>>>>>>>> beyond.
>>>>>>> I personally feel it's less work to add in kernel than try to
>>>>>>> work around it in userspace. Jason feels differently.
>>>>>>> Maybe post the patches and this will prove to Jason it's not
>>>>>>> too terrible?
>>>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
>>>>>> layout level and is limited to x86 only, there should be easy way out.
>>>>> Note a subtle difference: what matters is that guest, not host is x86.
>>>>> Matters for emulators which might reorder memory accesses.
>>>>> I guess this enforcement belongs in QEMU then?
>>>> Right, I mean to get started, the initial guest driver support and the
>>>> corresponding QEMU support for transitional vdpa backend can be limited
>>>> to x86 guest/host only. Since the config space is emulated in QEMU, I
>>>> suppose it's not hard to enforce in QEMU.
>>> It's more than just config space, most devices have headers before the buffer.
>> The ordering in datapath (data VQs) would have to rely on vendor's support.
>> Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w vendor nowadays
>> can/should well support the case when ORDER_PLATFORM is not acked by the
>> driver (actually this feature is filtered out by the QEMU vhost-vdpa driver
>> today), even with v1.0 spec conforming and modern only vDPA device. The
>> control VQ is implemented in software in the kernel, which can be easily
>> accommodated/fixed when needed.
>>
>>>> QEMU can drive GET_LEGACY,
>>>> GET_ENDIAN et al ioctls in advance to get the capability from the
>>>> individual vendor driver. For that, we need another negotiation protocol
>>>> similar to vhost_user's protocol_features between the vdpa kernel and
>>>> QEMU, way before the guest driver is ever probed and its feature
>>>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
>>>> from the device, but we can assume weak ordering for legacy at this
>>>> point (x86 only)?
>>> I'm lost here, we have get_features() so:
>> I assume here you refer to get_device_features() that Eli just changed the
>> name.
>>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
>>> 2) ORDER_PLATFORM means device requires platform ordering
>>>
>>> Any reason for having a new API for this?
>> Are you going to enforce all vDPA hardware vendors to support the
>> transitional model for legacy guest? meaning guest not acknowledging
>> VERSION_1 would use the legacy interfaces captured in the spec section 7.4
>> (regarding ring layout, native endianness, message framing, vq alignment of
>> 4096, 32bit feature, no features_ok bit in status, IO port interface i.e.
>> all the things) instead? Noted we don't yet have a set_device_features()
>> that allows the vdpa device to tell whether it is operating in transitional
>> or modern-only mode. For software virtio, all support for the legacy part in
>> a transitional model has been built up there already, however, it's not easy
>> for vDPA vendors to implement all the requirements for an all-or-nothing
>> legacy guest support (big endian guest for example). To these vendors, the
>> legacy support within a transitional model is more of feature to them and
>> it's best to leave some flexibility for them to implement partial support
>> for legacy. That in turn calls out the need for a vhost-user protocol
>> feature like negotiation API that can prohibit those unsupported guest
>> setups to as early as backend_init before launching the VM.
> Right. Of note is the fact that it's a spec bug which I
> hope yet to fix, though due to existing guest code the
> fix won't be complete.
I thought at one point you pointed out to me that the spec does allow 
config space read before claiming features_ok, and only config write 
before features_ok is prohibited. I haven't read up the full thread of 
Halil's VERSION_1 for transitional big endian device yet, but what is 
the spec bug you hope to fix?

>
> WRT ioctls, One thing we can do though is abuse set_features
> where it's called by QEMU early on with just the VERSION_1
> bit set, to distinguish between legacy and modern
> interface. This before config space accesses and FEATURES_OK.
>
> Halil has been working on this, pls take a look and maybe help him out.
Interesting thread, am reading now and see how I may leverage or help there.

>>>>>> I
>>>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
>>>>>> 0.95 support, it seems all the ingredient had been there already dated back
>>>>>> to the DPDK days. The only major thing limiting is in the vDPA software that
>>>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
>>>>>> a few DMA setup ops, which is virtio 1.0 only.
>>>>>>
>>>>>>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>>>>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>>>>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>>>>>>> of vdpa_get_config() to vdpa_set_config().
>>>>>>>>
>>>>>>>>             /*
>>>>>>>>              * Config accesses aren't supposed to trigger before features are
>>>>>>>> set.
>>>>>>>>              * If it does happen we assume a legacy guest.
>>>>>>>>              */
>>>>>>>>             if (!vdev->features_valid)
>>>>>>>>                     vdpa_set_features(vdev, 0);
>>>>>>>>             ops->get_config(vdev, offset, buf, len);
>>>>>>>>
>>>>>>>> I can post a patch to fix 2) if there's consensus already reached.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>> I'm not sure how important it is to change that.
>>>>>>> In any case it only affects transitional devices, right?
>>>>>>> Legacy only should not care ...
>>>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
>>>>>> modern one in a transitional device model rather than being legacy only.
>>>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
>>>>>> guests without having to reconfigure. Or are you suggesting limit to legacy
>>>>>> only at the time of vdpa creation would simplify the implementation a lot?
>>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>> I don't know for sure. Take a look at the work Halil was doing
>>>>> to try and support transitional devices with BE guests.
>>>> Hmmm, we can have those endianness ioctls defined but the initial QEMU
>>>> implementation can be started to support x86 guest/host with little
>>>> endian and weak memory ordering first. The real trick is to detect
>>>> legacy guest - I am not sure if it's feasible to shift all the legacy
>>>> detection work to QEMU, or the kernel has to be part of the detection
>>>> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
>>>> effort in QEMU) as well. Let me take a further look and get back.
>>> Michael may think differently but I think doing this in Qemu is much easier.
>> I think the key is whether we position emulating legacy interfaces in QEMU
>> doing translation on top of a v1.0 modern-only device in the kernel, or we
>> allow vdpa core (or you can say vhost-vdpa) and vendor driver to support a
>> transitional model in the kernel that is able to work for both v0.95 and
>> v1.0 drivers, with some slight aid from QEMU for
>> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for the
>> former we still rely on vendor for a performant data vqs implementation,
>> leaving the question to what it may end up eventually in the kernel is
>> effectively the latter).
>>
>> Thanks,
>> -Siwei
>
> My suggestion is post the kernel patches, and we can evaluate
> how much work they are.
Thanks for the feedback. I will take some read then get back, probably 
after the winter break. Stay tuned.

Thanks,
-Siwei

>
>>> Thanks
>>>
>>>
>>>
>>>> Meanwhile, I'll check internally to see if a legacy only model would
>>>> work. Thanks.
>>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>>
>>>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>>>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>>>>>>> know what the use
>>>>>>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>>>>>>> directly? Is there a
>>>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>>>>>>> BTW a good API could be
>>>>>>>>>>>>
>>>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>>
>>>>>>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>>>>>>> legacy driver
>>>>>>>>>>> for vDPA. Consider:
>>>>>>>>>>>
>>>>>>>>>>> 1) It's definition is no-normative
>>>>>>>>>>> 2) A lot of budren of codes
>>>>>>>>>>>
>>>>>>>>>>> So qemu can still present the legacy device since the config
>>>>>>>>>>> space or other
>>>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>>>>>>> accessed by
>>>>>>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>>>>>>> in this
>>>>>>>>>>> case?
>>>>>>>>>>>
>>>>>>>>>>> Thanks
>>>>>>>>>>>
>>>>>>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>>>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>>>>>>> seem to work for people. Any changes need to take that into account
>>>>>>>>>> and document compatibility concerns.
>>>>>>>>> Agree, let me check.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>       I note that any hardware
>>>>>>>>>> implementation is already broken for legacy except on platforms with
>>>>>>>>>> strong ordering which might be helpful in reducing the scope.
>>>>>>>>> Yes.
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>

