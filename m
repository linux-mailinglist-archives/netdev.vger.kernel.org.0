Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4C5521D3
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 18:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiFTQGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFTQGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 12:06:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94EC2019D;
        Mon, 20 Jun 2022 09:06:46 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFJ1v3023364;
        Mon, 20 Jun 2022 09:06:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QyrjqSoq6QCMhea6KaUKqhLS04I75xR05H/pCAZ3vDU=;
 b=HAfhKUCJfJfGvgr8tkCSUxw5MfCdpoHCJJxJcmDECRynvkbFdQXVjrbhWAyf4MhEMjeq
 ZFKlx/3+UFqkUQzUhMtEpIc34UtOMwMtL5h2wppK4mKSUBKql/mket1LNrKSlvN79V9/
 cLaaNh1WqYS+/hp3cTHL5qddUUmjfmG4gQo= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gsa1p230e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 09:06:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABAte6XyIjgte2UtAwUdzTH/3PBF/LDb1vOrRFaSPjnM2OaBN/A8aVjdsEkVla8DdMtQmT/M9fb768kUCgMs8yJXgmirZFzQAZ4BoSYq4ffUFDfqce6cc4VS5lEcxNbN31EqQCU8bPa1MidMnzTil9yNrjCUZ3n4v8x9T1OAO30WxmlMG//7gzwiBZSQTPDi/+qvktuBSf8qBVccvxiAz+2g4Rjgpl/u/G8v1gUTYdcUzDg8VwlNY0Ae35MAppwovKqieQd5pG4AmbSM2JFKVpmswcxE60H+xVlOFdyTc8OOD6I9BwoKdkE889yDIsncEHxjnxKUn4bRceOXRP8m4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyrjqSoq6QCMhea6KaUKqhLS04I75xR05H/pCAZ3vDU=;
 b=QrpzD8pNDdw4YmUq2SJ+mRkQR7drhIIAw9r0NLmdYa71dEqkH0yrRkrs5GeHHoppVX9FTBODFw3rCRpQp+7FLRcppUOF5r/Ew+masBm2WRGvK55CH2oBsKDBDWFNNEvpzwOyEEO6gerYxFzc9tzNRYZ4LPPSwueX/orfBzZ1iJUMzKJg/2bq8fWa01igbLTanPOfVe7qxEZ6WgBeI2BFsgQxE+LrOk/roUd7MBvNy01orvVC5mNAazgPmiyeQb946xveItkLGf4aq0oKXNnfBJumD3LpmbHsCtDCV0ogE/LqP6gnNNlKLEBkA5vwrFstJLLgqCjiq8npNpH4EuQamQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB2868.namprd15.prod.outlook.com (2603:10b6:408:89::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21; Mon, 20 Jun
 2022 16:06:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::482a:2ab1:26f8:3268]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::482a:2ab1:26f8:3268%5]) with mapi id 15.20.5353.021; Mon, 20 Jun 2022
 16:06:16 +0000
Message-ID: <e4390345-df3b-5ece-3464-83ff8c1992ce@fb.com>
Date:   Mon, 20 Jun 2022 09:06:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing
 sk_pacing_*
Content-Language: en-US
To:     =?UTF-8?Q?J=c3=b6rn-Thorben_Hinz?= <jthinz@mailbox.tu-berlin.de>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
 <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
 <629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ca0fa9b-cf3b-4df6-25ef-08da52d6ce41
X-MS-TrafficTypeDiagnostic: BN8PR15MB2868:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2868F7E733F021703A0C5ECDD3B09@BN8PR15MB2868.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uz5CBkN2hFitwm25kX/TStT+0jNBlDcK6wTypg0hhVfcEGu7LU5odtTGxgDZOk3hKdjjlzHc6zA5VD+dY/g7CY3J5RGzSs1DYpkZF5+H/a9vRM+VfHNEDGTkm7X0i4osdV9SVN8b598MSpT81SGnDr4oZQeQg8FzHh63nPBww2eetHdVe5U3BkxkE4lXZA71i8CKw0RZY8/HUsfhGLo2yu0qswNJANjmWCzhpvtOn8bHFmUqVjDiDysE9jRACHo4KBXw5wupFDEnGJ9gbHUkERv1iyIMt5LZbTXuh1/wHfifdI2URg6MRaxKi+hRoIhnhO2ikqpBzNwxTwbN5TiG4IemLjxQhgiPD3KcGkd0XLmSCB4haJxVGGRb/RjBPauNl5lLuZspU3TnjZRgbvg6cvwjlvf5pbbFCs4AhaQ42QTqiS0vI3/wBj79LUSkrCfr32XLd2u5RXjGLaNd3BFTc8+UoknzlmyY5s0Y3Ov/ZqqW+g0kjyumMN3LVFn94eVePxtBP9OWFURh3wSU29PpVADTP6Y9m8sQLGYUv06fT1a4J730zRKy0iwy5nXZzHpRQ4FdN27Rh3kKO4Updv7j5WDlPR16ewIWabzXi1Z/2KkUHov0H8Vb2pKwhJ5tLy9+qwzCjPp4qhA3DESZMQ4JjyE7LmUJD4iXgSKxX4QokTMcKSsdifBwP0k09Z+UnNsLogEYDXugWHLINXGWtiAkl52uMX38s3hXxAF1ZAzuw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(54906003)(6512007)(6666004)(38100700002)(66574015)(110136005)(2616005)(6506007)(53546011)(2906002)(8936002)(36756003)(5660300002)(66476007)(6486002)(83380400001)(498600001)(8676002)(66946007)(4326008)(31686004)(86362001)(66556008)(31696002)(316002)(186003)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2c1ZWMzMGpxWEYzT2xIdElJazVnRkJmbS9IY0dzTFlTaXBBZVhhKzlSTHM5?=
 =?utf-8?B?em5IU05YUWM0VUVYTmJvSnpPMnRid21Lekk2dng4N2hab085aW9aazFTQ3I5?=
 =?utf-8?B?MmFXUG9SaGkyK242VFRRZGw0eWFrSWFRV3JGdWdhdXlmUm02cDZZM1JXNERU?=
 =?utf-8?B?S05SYTBGU3BXL2pFb2I3TDdja3B3QVpZU0QwdXNaMGdhbE5ZVkNaK1hrYnN3?=
 =?utf-8?B?aWlERnZNb01tRGlsZGRITHQ0cXhuT1RXa3JrdEVoSWdRUGZ0R2I1YlBKMThD?=
 =?utf-8?B?SFkrSlZ2L2xMZ2l6c3EwNnVlZStEYXVFVTNHNyttcGNZU2wzTkVmM0VTanF4?=
 =?utf-8?B?VEpVc0lyUFJLOG91WmdNckxSR1NPMWxaK1VyUlNKbytIMzhyUnkrWFV0M3cx?=
 =?utf-8?B?eE52YXpFdjJyczY0YVZzdDJyYWlKQ2s3d1lpN3kxR2VTQm5VRnpvOHpma0tr?=
 =?utf-8?B?R3g1aGtVTjFMb0RtYXBHcTBLTmx1ZVdBbkV6L1YwWUJlM1NPT1VyVytHcU4z?=
 =?utf-8?B?MVFvU3FnM2J6S3pjanBaV3ZEWUc5OFRXVTJNTUZWWXphWVhwOUQwS3JkbFlh?=
 =?utf-8?B?Ti9Mb1drbHU0b0VFSkF1TGgrYW1qVER4OEJ4REZQSFlzc2NuNG96UWY2dmps?=
 =?utf-8?B?SWUzdHdERUR1N2JsSEpOZzU3Q0VrTStpUEVzWTE1UVdVd0VVbmU5enlKa1Zm?=
 =?utf-8?B?KzRiMkZLdjZrcUdxRHR6ZnRuODBneGtPWlNEM1Z3ejNyaDJzdUtQczAyaDlZ?=
 =?utf-8?B?RWhWUDcrVzZiQUdrYzZld1QvSGpDNVA1NE1YR2IxdDlwcXJkM3ZQUWIvRlhh?=
 =?utf-8?B?NThsUEVnVWxSZlpuODJFSnVkYVFmSU1kQ1ZqQnUwenZDaTREQmN6ZUo0ZTRI?=
 =?utf-8?B?UlVjcm9IblMzbVVQb0lmMXl6aENjQ2hoMFZDc2xLSDJHVDVOYWVpdThqNnNS?=
 =?utf-8?B?TTBHSG8rbXJzK2VXdnRHa09IcUxEc255aldtRVB4OFRlQUxKZ3krRmE0ZCt2?=
 =?utf-8?B?VzBCWlhQWVZBV3pYdERqRm50bHNEYlhkQ1lYTFBGdlpCU2lKMHFBKzVKQ0sv?=
 =?utf-8?B?Nm5McHlBSW5YdWpFVngwQkthZlRMQnh0TTJheVc5eDVtWVpZaVdUdXh5c2x1?=
 =?utf-8?B?N2FDSzVDUVpTTThST2FNVExYL0ZwZXpZOGxmMUN2YVM3MzJvK0V5bDl5N3BV?=
 =?utf-8?B?UVRYYjhlLzR2OGdkc3RDWjFScXp1eHI3cWF0c2s2VE9xcUt5TVg4S2JkMlly?=
 =?utf-8?B?eFZtWUVkd1NZc1RvVEYrVkJFZmJ3ekU5Smo4WURJQXdCVEFnMmdXR1JUNDQ4?=
 =?utf-8?B?c3lLQm4rdnpvYW40OXJQUWZCaHRieXBVRW8waEpSTVFBalFheXdxTHhqR1pR?=
 =?utf-8?B?V2Uyd25GMmtDRnpqUEs4aEtjZzlGUWxQeGkzdG02N0U2aVdrc2VlaWwvak1F?=
 =?utf-8?B?VThGdGhBQ0QwV0lJL3lMbnNUV0dRY2RnaXVpcWV6eUNTd2J0UWNhUEQ4YnBD?=
 =?utf-8?B?YzFiTjg4bWpPZ0M5czNxV3AzNHlicktLOUUvVW1uMkpCaU5vbGdqdUYwdjVX?=
 =?utf-8?B?UGxqQmlGSEdPekY0ZVF0bXJjZmovcDM0eCtOaHh2Q2xmMlhQb3BVcSs5U0Rp?=
 =?utf-8?B?R2g4MU92QnlDS1FPd0RxQWVndk1XVFg3OU01TzVpL3ZpRUhYdUtqMTFTZWM0?=
 =?utf-8?B?NFpINm5icThEVjV3VHFIakNhdGNhaTgyVHFXR0x3WTVOTU1ZSGN3UVAwUTZH?=
 =?utf-8?B?UWY1S2Z2dFpJdG5JK3E2bGlDYmN5SDZ5aU11RURvNG9pZXZQQXJheWM4Rmhk?=
 =?utf-8?B?dy9mR1JvTUE3ZHNvMzQyaHZwNHVoeDFMeXNHN29kdWRHUmhEdS8yeDc1Qzlw?=
 =?utf-8?B?elJWRkJ2M2xuUTErL3lpQ0xaVVNTVnQyZ3VGWklJc0E2TjlpV2RuQmhlRUJh?=
 =?utf-8?B?UzZ1OFlhTG5ibFNUUGdUTmRldTJkYTJzNUVpRGVRdTAySld4OE0rZVBva3M4?=
 =?utf-8?B?MUlsVHhwTkNweFdmdTBWMldLcEN6eUpqTHpHVVBrOVdwMGNqNU9ONExIaU5I?=
 =?utf-8?B?dUhuSjY0MUZpR1VUNG5ZdGtOYXU3TGxCRksrYXNRaEJZaGdjWUlXdk9KTDVN?=
 =?utf-8?B?VTFyNk1GeGI0bXRIU0JIS1NUZUVMa1NZVjNKdVMrSkk3VTQ3TWhWNitpUzJI?=
 =?utf-8?B?eUVwV3NiWDlRekdmTVhJeTJrbDJPb0hKR2ZmcGh6YzJaaDhZYW5leGtTcE5Q?=
 =?utf-8?B?ZXcrV2pFU0N0QVUwUlNGbnJtTGlRUFZ1UkVKTVh1K01zM2xlUFJGdHg2a3RG?=
 =?utf-8?B?WHNZUGtjVkZBVmlRRjdHaXVvVGVQVHhTZzRmRTJpQXpMQ1FGRmNQL2dHdGpL?=
 =?utf-8?Q?SuLNPOL11ZuesnCg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca0fa9b-cf3b-4df6-25ef-08da52d6ce41
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 16:06:16.6013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwwgO7FxXjxWGPzis4wfXIMFu995m5Dm/rQ2bOGvNQXFz/LK0hXT2XGhmqIhfSR0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2868
X-Proofpoint-ORIG-GUID: 6WyOrH0vTOQop2itGGADLIY6UriIMwDB
X-Proofpoint-GUID: 6WyOrH0vTOQop2itGGADLIY6UriIMwDB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/22 9:43 AM, Jörn-Thorben Hinz wrote:
> On Fri, 2022-06-17 at 14:04 -0700, Martin KaFai Lau wrote:
>> On Tue, Jun 14, 2022 at 12:44:50PM +0200, Jörn-Thorben Hinz wrote:
>>> Test whether a TCP CC implemented in BPF is allowed to write
>>> sk_pacing_rate and sk_pacing_status in struct sock. This is needed
>>> when
>>> cong_control() is implemented and used.
>>>
>>> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
>>> ---
>>>   .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 21 +++++++
>>>   .../bpf/progs/tcp_ca_write_sk_pacing.c        | 60
>>> +++++++++++++++++++
>>>   2 files changed, 81 insertions(+)
>>>   create mode 100644
>>> tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>>> b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>>> index e9a9a31b2ffe..a797497e2864 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>>> @@ -9,6 +9,7 @@
>>>   #include "bpf_cubic.skel.h"
>>>   #include "bpf_tcp_nogpl.skel.h"
>>>   #include "bpf_dctcp_release.skel.h"
>>> +#include "tcp_ca_write_sk_pacing.skel.h"
>>>   
>>>   #ifndef ENOTSUPP
>>>   #define ENOTSUPP 524
>>> @@ -322,6 +323,24 @@ static void test_rel_setsockopt(void)
>>>          bpf_dctcp_release__destroy(rel_skel);
>>>   }
>>>   
>>> +static void test_write_sk_pacing(void)
>>> +{
>>> +       struct tcp_ca_write_sk_pacing *skel;
>>> +       struct bpf_link *link;
>>> +
>>> +       skel = tcp_ca_write_sk_pacing__open_and_load();
>>> +       if (!ASSERT_OK_PTR(skel, "open_and_load")) {
>> nit. Remove this single line '{'.
>>
>> ./scripts/checkpatch.pl has reported that also:
>> WARNING: braces {} are not necessary for single statement blocks
>> #43: FILE: tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c:332:
>> +       if (!ASSERT_OK_PTR(skel, "open_and_load")) {
>> +               return;
>> +       }
> Have to admit I knowingly disregarded that warning as more of a
> recommendation. Out of habit and since I personally don’t see any
> compelling reason to generally use single-line statements after ifs,
> only multiple disadvantages.
> 
> But wrong place to argue here, of course. Will bow to the warning.
> 
>>
>>
>>> +               return;
>>> +       }
>>> +
>>> +       link = bpf_map__attach_struct_ops(skel-
>>>> maps.write_sk_pacing);
>>> +       if (ASSERT_OK_PTR(link, "attach_struct_ops")) {
>> Same here.
>>
>> and no need to check the link before bpf_link__destroy.
>> bpf_link__destroy can handle error link.  Something like:
>>
>>          ASSERT_OK_PTR(link, "attach_struct_ops");
>>          bpf_link__destroy(link);
>>          tcp_ca_write_sk_pacing__destroy(skel);
>>
>> The earlier examples in test_cubic and test_dctcp were
>> written before bpf_link__destroy can handle error link.
> You are right, I followed the other two test_*() functions there. Good
> to know that it behaves similar to (k)free() and others. Will remove
> the ifs around bpf_link__destroy().
> 
>>
>>> +               bpf_link__destroy(link);
>>> +       }
>>> +
>>> +       tcp_ca_write_sk_pacing__destroy(skel);
>>> +}
>>> +
>>>   void test_bpf_tcp_ca(void)
>>>   {
>>>          if (test__start_subtest("dctcp"))
>>> @@ -334,4 +353,6 @@ void test_bpf_tcp_ca(void)
>>>                  test_dctcp_fallback();
>>>          if (test__start_subtest("rel_setsockopt"))
>>>                  test_rel_setsockopt();
>>> +       if (test__start_subtest("write_sk_pacing"))
>>> +               test_write_sk_pacing();
>>>   }
>>> diff --git
>>> a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
>>> b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
>>> new file mode 100644
>>> index 000000000000..43447704cf0e
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
>>> @@ -0,0 +1,60 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +#include "vmlinux.h"
>>> +
>>> +#include <bpf/bpf_helpers.h>
>>> +#include <bpf/bpf_tracing.h>
>>> +
>>> +char _license[] SEC("license") = "GPL";
>>> +
>>> +#define USEC_PER_SEC 1000000UL
>>> +
>>> +#define min(a, b) ((a) < (b) ? (a) : (b))
>>> +
>>> +static inline struct tcp_sock *tcp_sk(const struct sock *sk)
>>> +{
>> This helper is already available in bpf_tcp_helpers.h.
>> Is there a reason not to use that one and redefine
>> it in both patch 3 and 4?  The mss_cache and srtt_us can be added
>> to bpf_tcp_helpers.h.  It will need another effort to move
>> all selftest's bpf-cc to vmlinux.h.
> I fully agree it’s not elegant to redefine tcp_sk() twice more.
> 
> It was between either using bpf_tcp_helpers.h and adding and
> maintaining additional struct members there. Or using the (as I
> understood it) more “modern” approach with vmlinux.h and redefining the
> trivial tcp_sk(). I chose the later. Didn’t see a reason not to slowly
> introduce vmlinux.h into the CA tests.
> 
> I had the same dilemma for the algorithm I’m implementing: Reuse
> bpf_tcp_helpers.h from the kernel tree and extend it. Or use vmlinux.h
> and copy only some of the (mostly trivial) helper functions. Also chose
> the later here.
> 
> While doing the above, I also considered extracting the type
> declarations from bpf_tcp_helpers.h into an, e.g.,
> bpf_tcp_types_helper.h, keeping only the functions in
> bpf_tcp_helpers.h. bpf_tcp_helpers.h could have been a base helper for
> any BPF CA implementation then and used with either vmlinux.h or the
> “old-school” includes. Similar to the way bpf_helpers.h is used. But at
> that point, a bpf_tcp_types_helper.h could have probably just been
> dropped for good and in favor of vmlinux.h. So I didn’t continue with
> that.
> 
> Do you insist to use bpf_tcp_helpers.h instead of vmlinux.h? Or could
> the described split into two headers make sense after all?

I prefer to use vmlinux.h. Eventually we would like to use vmlinux.h
for progs which include bpf_tcp_healpers.h. Basically remove the struct
definitions in bpf_tcp_helpers.h and replacing "bpf.h, stddef.h, tcp.h 
..." with vmlinux.h. We may not be there yet, but that is the goal.

> 
> (Will wait for your reply here before sending a v4.)
> 
>>
>>> +       return (struct tcp_sock *)sk;
>>> +}
>>> +
>>> +SEC("struct_ops/write_sk_pacing_init")
>>> +void BPF_PROG(write_sk_pacing_init, struct sock *sk)
>>> +{
>>> +#ifdef ENABLE_ATOMICS_TESTS
>>> +       __sync_bool_compare_and_swap(&sk->sk_pacing_status,
>>> SK_PACING_NONE,
>>> +                                    SK_PACING_NEEDED);
>>> +#else
>>> +       sk->sk_pacing_status = SK_PACING_NEEDED;
>>> +#endif
>>> +}
>>> +
>>> +SEC("struct_ops/write_sk_pacing_cong_control")
>>> +void BPF_PROG(write_sk_pacing_cong_control, struct sock *sk,
>>> +             const struct rate_sample *rs)
>>> +{
>>> +       const struct tcp_sock *tp = tcp_sk(sk);
>>> +       unsigned long rate =
>>> +               ((tp->snd_cwnd * tp->mss_cache * USEC_PER_SEC) <<
>>> 3) /
>>> +               (tp->srtt_us ?: 1U << 3);
>>> +       sk->sk_pacing_rate = min(rate, sk->sk_max_pacing_rate);
>>> +}
>>> +
>>> +SEC("struct_ops/write_sk_pacing_ssthresh")
>>> +__u32 BPF_PROG(write_sk_pacing_ssthresh, struct sock *sk)
>>> +{
>>> +       return tcp_sk(sk)->snd_ssthresh;
>>> +}
>>> +
>>> +SEC("struct_ops/write_sk_pacing_undo_cwnd")
>>> +__u32 BPF_PROG(write_sk_pacing_undo_cwnd, struct sock *sk)
>>> +{
>>> +       return tcp_sk(sk)->snd_cwnd;
>>> +}
>>> +
>>> +SEC(".struct_ops")
>>> +struct tcp_congestion_ops write_sk_pacing = {
>>> +       .init = (void *)write_sk_pacing_init,
>>> +       .cong_control = (void *)write_sk_pacing_cong_control,
>>> +       .ssthresh = (void *)write_sk_pacing_ssthresh,
>>> +       .undo_cwnd = (void *)write_sk_pacing_undo_cwnd,
>>> +       .name = "bpf_w_sk_pacing",
>>> +};
>>> -- 
>>> 2.30.2
>>>
> 
> 
