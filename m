Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCA2C6E9A
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 04:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbgK1DQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 22:16:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728558AbgK1DOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 22:14:51 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AS3B27k024930;
        Fri, 27 Nov 2020 19:13:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MaJA/bBoKh4KeVabo9uGPvF87X2qGtOBbqHblYoAgfs=;
 b=NvkzaolWbMt+dfq4zFF2rerFcToSC78/dmjEdcNZ+4bNOR4yFZxFFk2VC+Xl3r8w3+KN
 GzAMGoV5r3JqWlmblgwzpO6A8+bdjEbGm2Q3eQlhsFg1Unllzegiz5iXzf6sjtELtL8W
 BRwHVGuL2p9abjoPtiPF0QIelOLMjzrvk7c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3530c3k43x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Nov 2020 19:13:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 19:13:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRtK89Nd/NlTUtJHoTURoK5XSBwYu19bhFNUuDz3Ezi6guC5hceNHO3Yg3bJ3H2ipN4kNoW22saI3HviGi5VqRMWPDCnDIzAd3571BwPKJCRSIyexYIWS0t6w63B4gZtAMAFdcSc9Uo9i021bvSvkIJ5MgXijJkoznkxHD8ax34zhej5RIubPNbp+cUv8QP9bHj+bAGeK+bxM88K6OL4Vq2rAbA97nQVXKid4isvKiGTFv4QwRw7YSyW8EcxBHPbEW0bOwqrodUlKpGmspEnpAqb/cLlFYdmK5u6frQdXJ+VCbV96PicdYDeGRM3ZxSLs+LVDsif0IR1Ah1IFQk8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaJA/bBoKh4KeVabo9uGPvF87X2qGtOBbqHblYoAgfs=;
 b=FipbdAioAnfnB5Gul2rXObx7soVpzbVKLp1ckRsjSRpVlgsBX/b1Ujm5/j0SaVS+d14DnEIvxRsOv5YUnaNjmSapP2m7SDXWuYax555DErjiD+cBBMo2laSEHDp26WHnuBqxdhSt50X8TmZr9KZmQsBVG4RjybQbIZ5vIGaRBTmgxvjVqSPFMsdiVXnSsm26GR0qNCIkY3BhMPHYCusIbX+9o1NubI7fFKCLSl/SXxoJPMgBCWekR7/xopNDkDc5F3YZIbOp+4Y5ATgBS1128gPiBD2p1shWlkFt8SllMrzd6uKrSyWT1g88gmtDbjOQuPxDjie2/CSZOoIiBPU9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaJA/bBoKh4KeVabo9uGPvF87X2qGtOBbqHblYoAgfs=;
 b=hHCINTx2ygthZlw0ZIcbaVVLl5zAbMBwfKXFjJ1tOBYtFLYS/2HZQjawoAoYYiUfexY+qtPkKLXT6wF0ldlEhYUTVG3rAasKJzrC7AmmdhvAWrZb6ovS3iokilXf4NMQJCIZxvbi0+tSE9OPZo/5YzrzcgszQdxgxpSu/bMQTQc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2997.namprd15.prod.outlook.com (2603:10b6:a03:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Sat, 28 Nov
 2020 03:13:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Sat, 28 Nov 2020
 03:13:04 +0000
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     Weqaar Janjua <weqaar.janjua@gmail.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        <jonathan.lemon@gmail.com>
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com>
 <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
 <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com>
 <CAPLEeBYnYcWALN_JMBtZWt3uDnpYNtCA_HVLN6Gi7VbVk022xw@mail.gmail.com>
 <9c73643f-0fdc-d867-6fe0-b3b8031a6cf2@fb.com>
 <CAPLEeBZh+BEJp_k0bDQ8nmprMPqQ29JSEXCxscm5wAZQH81bAQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b153b6af-6f75-d091-7022-999b01f553aa@fb.com>
Date:   Fri, 27 Nov 2020 19:13:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <CAPLEeBZh+BEJp_k0bDQ8nmprMPqQ29JSEXCxscm5wAZQH81bAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:b678]
X-ClientProxiedBy: MWHPR21CA0050.namprd21.prod.outlook.com
 (2603:10b6:300:db::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::102b] (2620:10d:c090:400::5:b678) by MWHPR21CA0050.namprd21.prod.outlook.com (2603:10b6:300:db::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.0 via Frontend Transport; Sat, 28 Nov 2020 03:13:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 555076f9-1773-48f3-f83c-08d8934b8588
X-MS-TrafficTypeDiagnostic: BYAPR15MB2997:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2997F522933619D4DF70C0AAD3F70@BYAPR15MB2997.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ++iDUC8Ad3fLUnM78Q+eJUGM2gMqqle3YNndqXJeSLvDxCkTYkYsXq+TKwBUfJIZTbFNbY0Tf0YRyT3Emo5p0NSBqBNT0wVlpqqO0KWzczRci48KoSv8sMCsB4MFd4CTjoJF4SnceqYvQSSOzQVLqoKHcWv01aBBaWHRHyxRR5WV9VCnX63vcT0sGbqfeh9VH4bi13VhR4Z8Mxu8vkiPUt1mKessfSlnZ6Pw+rYYlL16EN+5EVtMCBphmlG9AWvXeMuqWxs3FcCTbWfCsQUe7SPLELpmx5COsilGOssePwgFfy7bY2z65kdQH1iv560HAOzTxDssCISRSts6TstuqDKMdJIyep/1/kqDToyuraIhf9N3NOVeN5UqEfacDSbT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(39860400002)(376002)(4326008)(8936002)(2906002)(66476007)(8676002)(31686004)(36756003)(7416002)(86362001)(66574015)(66556008)(66946007)(5660300002)(53546011)(83380400001)(4001150100001)(478600001)(54906003)(6486002)(31696002)(186003)(6916009)(16526019)(52116002)(2616005)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L0pYcXlPdHpZTUtsdDV2OFJTRFh0eDJBbnJKRjZzaW5acTdkOVptUStZdkVU?=
 =?utf-8?B?UWEvNE5FeWJKaVZrSS9jS3FzVzh3R1NwbHl5VGdMaXJ0Y29kalZ3K202RHhJ?=
 =?utf-8?B?akpyU2Y5UUdyU0lUUjQ4aUV6QXFYRmlwMnlkdkNkSzk0UkFmNGNGQXBETTYr?=
 =?utf-8?B?dGd0L3oyUjNIN3FNSml4SjJEcmdxRFVUSVNMSTBIR1k3eVdLMm00UkxxTEhO?=
 =?utf-8?B?V1FUekRBL09BWWc3ZUErSWRwYXo4eGJBeHJiUWk3dTJ5eGR5ckMzMW1yYkhl?=
 =?utf-8?B?WG9rdjZneHU0a29WeGhwOWlwOHpaL25mSnBGN3lWOHFKdlQ2STBCcWFmOTRD?=
 =?utf-8?B?SjRrUDgrZ3Y1K04wMitHdU9xekRtRTR4Y0liMVkvaWErOVJFT2tOZUNqei8w?=
 =?utf-8?B?Z1lwNHlOSVRDVElycnpTM0JNQlBzWHRrZHBBQ1dQOTZkWi9OSStlNTczTnBY?=
 =?utf-8?B?ZThxUHBUZU5UN201TVhUVitzZStCY1Y5L2o2SnNGUlB6RTVqNUY0SEg1WlE2?=
 =?utf-8?B?cTBtdFF2M0kvOW1LVG5DZDV2VXU1ZkN6eGpoT3QvSlNqZEt1aXVSQUFkbHRR?=
 =?utf-8?B?UHNCWlE3dnFwdGowL0lLT0N3bFZRRWlQWTEvSU93OG5RK0d5VEl2bmxSaExG?=
 =?utf-8?B?M0htTko4OWlwMW1YSWJsdVFIU2FBTUx5cXZNTEtvalJ0dHdpNDVqR2NkeWRF?=
 =?utf-8?B?cm9JeFgrdzFjN1k1dXh4dm1MaU5VeUhYL0FzeXFFMVp4K2hkcnZoakRQQTBE?=
 =?utf-8?B?K29uZGJra2dzdk9oVSt0c2lXN1RWZzZUb2xpVEY4SHkrMFFvZk1pd2tLbHgw?=
 =?utf-8?B?Mml2M21PQkt4Q29oWnh4Yk9CYU9saUpadytzOWwvcjlGWjlrZEhzRUoyc3JB?=
 =?utf-8?B?dWhCSEI5RGlLb1hubnJ6c3NWKzJraXBaeElOM0h1dkc5VW9CL1kvMVJ0Q2dH?=
 =?utf-8?B?Z21ESllLaGhhclU1SXZCckxSbnJJNVVsRlZhZGpMcmkxb1ZIWDRGYm9Obm96?=
 =?utf-8?B?bGplY1lkMzQ3ZkFlK1dtb2pIRFFaK0RHQUdQY3lTb0VBb2JyRDhHWEZlcU5B?=
 =?utf-8?B?eFpYcThHT0JHRWwwZjVRSFNObVdQWk1vV0RRYjNYbFJEVzhjZC8xV3RSN21i?=
 =?utf-8?B?TGQyVVhUUDBULzZPYnlUcUcyazZWbjRQdDJSdFNyelhkY1M5cVRscWx3VUl1?=
 =?utf-8?B?clVSbEhmdk1GOUE3OWVIaEtpeUFTTEhOQklJdmhZaUt0NERPMmVJUjkyWGt6?=
 =?utf-8?B?MVlnVyswdXpZRFR1Um9BVk1yYnlQdWxUQ1lpRElNdmdkRUZrMkJHTk9ySzFP?=
 =?utf-8?B?bUg4RUJpTnRGeWxjS0xHU2xvRXNGVldCZlJLNUUxVVN3SUVDZW84OGY1c3ph?=
 =?utf-8?B?K1B6QU04UnZPcEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 555076f9-1773-48f3-f83c-08d8934b8588
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2020 03:13:04.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDH6xbGrlTnLIN0CKJ3aaWRWc2F7+dclR3zCnT6eUKQYUKzLjS1es199ojqCOGDS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2997
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_02:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011280021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/27/20 9:54 AM, Weqaar Janjua wrote:
> On Fri, 27 Nov 2020 at 04:19, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 11/26/20 1:22 PM, Weqaar Janjua wrote:
>>> On Thu, 26 Nov 2020 at 09:01, Björn Töpel <bjorn.topel@intel.com> wrote:
>>>>
>>>> On 2020-11-26 07:44, Yonghong Song wrote:
>>>>>
>>>> [...]
>>>>>
>>>>> What other configures I am missing?
>>>>>
>>>>> BTW, I cherry-picked the following pick from bpf tree in this experiment.
>>>>>      commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
>>>>>      Author: Björn Töpel <bjorn.topel@intel.com>
>>>>>      Date:   Mon Nov 23 18:56:00 2020 +0100
>>>>>
>>>>>          net, xsk: Avoid taking multiple skbuff references
>>>>>
>>>>
>>>> Hmm, I'm getting an oops, unless I cherry-pick:
>>>>
>>>> 36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")
>>>>
>>>> *AND*
>>>>
>>>> 537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")
>>>>
>>>> from bpf/master.
>>>>
>>>
>>> Same as Bjorn's findings ^^^, additionally applying the second patch
>>> 537cf4e3cc2f [PASS] all tests for me
>>>
>>> PREREQUISITES: [ PASS ]
>>> SKB NOPOLL: [ PASS ]
>>> SKB POLL: [ PASS ]
>>> DRV NOPOLL: [ PASS ]
>>> DRV POLL: [ PASS ]
>>> SKB SOCKET TEARDOWN: [ PASS ]
>>> DRV SOCKET TEARDOWN: [ PASS ]
>>> SKB BIDIRECTIONAL SOCKETS: [ PASS ]
>>> DRV BIDIRECTIONAL SOCKETS: [ PASS ]
>>>
>>> With the first patch alone, as soon as we enter DRV/Native NOPOLL mode
>>> kernel panics, whereas in your case NOPOLL tests were falling with
>>> packets being *lost* as per seqnum mismatch.
>>>
>>> Can you please test this out with both patches and let us know?
>>
>> I applied both the above patches in bpf-next as well as this patch set,
>> I still see failures. I am attaching my config file. Maybe you can take
>> a look at what is the issue.
>>
> Thanks for the config, can you please confirm the compiler version,
> and resource limits i.e. stack size, memory, etc.?

root@arch-fb-vm1:~/net-next/net-next/tools/testing/selftests/bpf ulimit -a
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 15587
max locked memory       (kbytes, -l) unlimited
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 15587
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

compiler: gcc 8.2

> 
> Only NOPOLL tests are failing for you as I see it, do the same tests
> fail every time?

In my case, with above two bpf patches applied as well, I got:
$ ./test_xsk.sh
setting up ve9127: root: 192.168.222.1/30 

setting up ve4520: af_xdp4520: 192.168.222.2/30 

Spec file created: veth.spec 

PREREQUISITES: [ PASS ] 

# Interface found: ve9127 

# Interface found: ve4520 

# NS switched: af_xdp4520 

1..1 

# Interface [ve4520] vector [Rx] 

# Interface [ve9127] vector [Tx] 

# Sending 10000 packets on interface ve9127 

not ok 1 ERROR: [worker_pkt_validate] prev_pkt [59], payloadseqnum [0] 

# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0 

SKB NOPOLL: [ FAIL ] 

# Interface found: ve9127 

# Interface found: ve4520 

# NS switched: af_xdp4520
# NS switched: af_xdp4520 

1..1
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
# End-of-tranmission frame received: PASS
# Received 10000 packets on interface ve4520
ok 1 PASS: SKB POLL
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
SKB POLL: [ PASS ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [153], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV NOPOLL: [ FAIL ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
# End-of-tranmission frame received: PASS
# Received 10000 packets on interface ve4520
ok 1 PASS: DRV POLL
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
DRV POLL: [ PASS ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Creating socket
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [54], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Creating socket
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Creating socket
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [64], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
# Interface found: ve9127
# Interface found: ve4520
# NS switched: af_xdp4520
1..1
# Creating socket
# Interface [ve4520] vector [Rx]
# Interface [ve9127] vector [Tx]
# Sending 10000 packets on interface ve9127
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [83], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
cleaning up...
removing link ve4520
removing ns af_xdp4520
removing spec file: veth.spec

Second runs have one previous success becoming failure.

./test_xsk.sh
setting up ve2458: root: 192.168.222.1/30 

setting up ve4468: af_xdp4468: 192.168.222.2/30 

[  286.597111] IPv6: ADDRCONF(NETDEV_CHANGE): ve4468: link becomes ready 

Spec file created: veth.spec 

PREREQUISITES: [ PASS ] 

# Interface found: ve2458 

# Interface found: ve4468 

# NS switched: af_xdp4468 

1..1 

# Interface [ve4468] vector [Rx] 

# Interface [ve2458] vector [Tx] 

# Sending 10000 packets on interface ve2458 

not ok 1 ERROR: [worker_pkt_validate] prev_pkt [67], payloadseqnum [0] 

# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0 

SKB NOPOLL: [ FAIL ] 

# Interface found: ve2458 

# Interface found: ve4468 

# NS switched: af_xdp4468 

1..1 

# Interface [ve4468] vector [Rx] 

# Interface [ve2458] vector [Tx] 

# Sending 10000 packets on interface ve2458 

# End-of-tranmission frame received: PASS
# Received 10000 packets on interface ve4468
ok 1 PASS: SKB POLL
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
SKB POLL: [ PASS ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [191], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV NOPOLL: [ FAIL ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV POLL: [ FAIL ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Creating socket
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Creating socket
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [171], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Creating socket
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [124], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
# Interface found: ve2458
# Interface found: ve4468
# NS switched: af_xdp4468
1..1
# Creating socket
# Interface [ve4468] vector [Rx]
# Interface [ve2458] vector [Tx]
# Sending 10000 packets on interface ve2458
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [195], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
cleaning up...
removing link ve4468
removing ns af_xdp4468
removing spec file: veth.spec

> 
> I will need to spend some time debugging this to have a fix.

Thanks.

> 
> Thanks,
> /Weqaar
> 
>>>
>>>> Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory?
>>>> This will be easier than the above for bpf developers. If it does not
>>>> work, I would like to recommend to make it work.
>>>>
>>> yes test_xsk.shis self contained, will update the instructions in there with v4.
>>
>> That will be great. Thanks!
>>
>>>
>>> Thanks,
>>> /Weqaar
>>>>
>>>> Björn
