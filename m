Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0D92D2192
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgLHDtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:49:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgLHDtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:49:14 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0B83UL7a001240;
        Mon, 7 Dec 2020 19:48:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sSRN3jNbGRvcBVusHyjJci1a7fikyajosMpfPFQ8yfQ=;
 b=pugpnCnmmZ0ldYGMg07aHfcdXUsVL/C3r9yJUpIuiDa7GlcdpDg7jbfu23V11ljJAc5S
 7lwVcm6CmW4SP8RR7rtHvASKuX8Tqdh8TnCQUilZGL4SZ20iWDNzabDMSNQdXdUEq/vC
 BIPW8lRUeoqerjk5qhYpZ5RVPkmbk38uxLg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3588026bcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 19:48:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 19:48:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OThRA9butO/ZzzDLIayUuRxel75HacuPe5+xvo6mZ9CXkmXenFfEBOo6WsDCqfrfa9+Azyzw+X+TZtbTpfy5S0oCawnJUb37zyCU8sEDXAkG280SVL36TeTtr5oNTJOhDtZ63In8drkex4eFWoTZtj/wxwpIatuscTB1wTQ8tHPtFzw0Z0KkoKSTCwIlVRNMEWSQSPm/Vkq6q1myv4Q95k0EsH9R2gjvn7NuH7M1fzz4q/EZAlz0VlCetZixpEu+QuamKcFN8y2cTMUu82uV8QFH7DKDKd+oa+TfTHk1CbfZL0jXqQ0ONqqcIuhNCFHInz2RoMJqrmwsToLF+tkzsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSRN3jNbGRvcBVusHyjJci1a7fikyajosMpfPFQ8yfQ=;
 b=id8jTr4jeFNOP3vZ4nFhcZ0DCl4lFQFjnW78Y4NG8VwoY0T7ybFNXE8FSuxTNj1QvNNIuYiIB9v4HcXN7tQSlevdJKjUZsLX0kwkqVIY/VpIrEyZ30OVUbhr2oT1Kw81VadruQg6gtoFyBla/3yNZ6avWBFaxCwcP1Tf8lA5N6/n8/T7g0/H9fw0kyiuzN88cwdOEoaMuK6tyLOgZczbL3snIRjRihqJdWQ3O+gNQ61Krp0Y7d/YbXNhTx4PhgE7YmVjyvIcKC7QYLSxk0BpGsI+HK1ZPnx7zzmwXgWCHhlO+4poUjFWMc7iTsQ5xjoCy8sfW97Z4fvIqIpKqWrgGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSRN3jNbGRvcBVusHyjJci1a7fikyajosMpfPFQ8yfQ=;
 b=WN2Drneb3nQsEiV2k2wIn8cBvesasuagJhdmbKjQaGJnjSvra/oUY17SSlpclnDcnkBBDZpTQP9pcuSgzG0SICndiXeBbsGTWMRdsGJhVz+xIYcz+jxBLZAlI872Rfhnktie9VHZOeDOoRmvyzjE85LYJ9ioRCQWyHkpuUe5ZJg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 03:48:06 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 03:48:06 +0000
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
 <b153b6af-6f75-d091-7022-999b01f553aa@fb.com>
 <CAPLEeBY_soGW66KE3U66_h2R3s0cFLjsektvYXCFb+5Uvc0YfQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2e5831b5-f034-fe2e-e263-2c5d4d1bebd3@fb.com>
Date:   Mon, 7 Dec 2020 19:48:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <CAPLEeBY_soGW66KE3U66_h2R3s0cFLjsektvYXCFb+5Uvc0YfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:4c73]
X-ClientProxiedBy: MWHPR1401CA0015.namprd14.prod.outlook.com
 (2603:10b6:301:4b::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:4c73) by MWHPR1401CA0015.namprd14.prod.outlook.com (2603:10b6:301:4b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 03:48:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a05fe399-8c52-4024-50c1-08d89b2c125d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-Microsoft-Antispam-PRVS: <BYAPR15MB282114AC88ECA0A83745D7EAD3CD0@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuFrYFq6r6uSvwf7Tc5AeWmXrNPSnKDxmirGI/R5WVgwwbCNZWe8t59XMr2hi5t9eAyyHoZmx0Y9Qbhl1xzx7GNwwycc2Er9QcyoGYdeJDmJh5RCCK9/EDAWkpNZPa90RJnCrqT18cJwxURtJK8JzN+T/bwqyB3BoQfqiojLqG/4u3inXyytZFypG2hnh4bneknxN0dvrGY9dkVIFz7JHiTV2ic0eXQt8gWtyPYSW+2Tlb6myfcHD9Fpzk+eCWZDuQ75K8BA2tfc4Y+WBpqiycRz5BP8Lbuv6qOu5K99CJIUZvNh1um3x+83UvjJ5Kt7h2Zw+2XOLglOoAl0PSohtOQLmfbIBfbERsWiteZf4SAokzPtU+OM6kH4Tz7jTqJh7hahWPgbJYiKtWTdRbPu7tb9rQP5AF1aTTR4a01IUOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(31696002)(186003)(31686004)(478600001)(30864003)(316002)(86362001)(54906003)(6916009)(5660300002)(6486002)(66574015)(36756003)(8936002)(66476007)(2906002)(4001150100001)(8676002)(4326008)(2616005)(83380400001)(16526019)(52116002)(53546011)(7416002)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0dKclZlazRRYzNaMkRSVVVwQmRrQUlpZUVzeTd0YUptNXlwcE5RS1ZtT2Ez?=
 =?utf-8?B?eUtaeWRVTDIzM3NDalBoYitHSi9pUDVlcUlpbElBM2ZrcmQ4WEtWZXArRWdl?=
 =?utf-8?B?c2xldlBXeVVXcUdtZEFhTFZocVBXVWJyYzA1NFNtTEpCVldadFRXcGhYZzVy?=
 =?utf-8?B?RDdJY2tCZUFnS0pIMDVhZVJiK0hQSnBySmdxajdhdlFXbFNIMFhrUmhWTXFu?=
 =?utf-8?B?N0dJRVFvYnU4Ym1iSm5CWXI1TFFzc0oxa1BRM2R0UXJDcVJzTnVJZy9JWnJv?=
 =?utf-8?B?T0c2M0xCdUtFNmVRejR3eG8weWMvMVJYa0dianZ4TjZPMmdNQ2xjdXVjYTJK?=
 =?utf-8?B?QUhTdGFZWDd2TFN6dTJ3Y0Q5eUExTE40RktncUI2L1dsVmpmMFJxTTZGSGdw?=
 =?utf-8?B?NzdGd0RhQ2tRUk50SUU5VU9uTWVFSnFHNkQ1dVBSR1FPZVp4QlhEUnVvT2k4?=
 =?utf-8?B?RkE5cWpWdms3M0NDeUZTcDRWZkJad0FjRmptd014ZnVud2hIT3dmelp2NEZv?=
 =?utf-8?B?UHpWM0lKQ0ZKRkhHWlhhYkV6cUxtQ0VUdnpOdmVPd2ZGd0o2UUVNVHpiV3Ja?=
 =?utf-8?B?cHErR01iSHIyTURZSC9pOG80M05vV1ppMC93UnZQaW9jdVZJMGJFRVB6TGZP?=
 =?utf-8?B?bEc5eHBBNVNVZUN6OGZDNk9WRFdRNGVZV3QvSzlGdWIwV2IvdzFGM0RYYjVZ?=
 =?utf-8?B?c09uSXhPbHhoVHI5ZjZnTndHMHg0ZGkxWFRTMExGS21DblpHeTBNdUlHaVgy?=
 =?utf-8?B?QUFuY2ZoNnU5ZVZPVFg2Vk1WSmZEdFB2WkYyVHBoQUc0ZnFUUEVMN3JMaGhV?=
 =?utf-8?B?RE9pcnlKaHlYMkxBeXppZForeVJ4VWtlV1lqOGErdXhTQWs4aHZXNDRJamlq?=
 =?utf-8?B?TGxGVE1JU2xsUmx1cVUwUnVGS0VIQUovZHc5OXlhMFNmTnhremdFdDZIZXB2?=
 =?utf-8?B?Nmoxcllucno2dmVYRS8vS0c5Mno1cGtsRktmbzI4Q2gwaHpEWnd0YkRFSzgz?=
 =?utf-8?B?aVZ6OGwvQTlmLzBBbzBNN1o2SGpzR0QyWW5SR1AvbkluRkI0U2dHb3ZUVUVo?=
 =?utf-8?B?eDNXVC9tMXpNenNsQ3FIQm80L0Z2c3cwclgwbjk3SFQzQ1J6U256UThidTFQ?=
 =?utf-8?B?UllkZE1iMXVoQnZQWlBXOGV6VXZvZGVKK1dvTUpXQmNCQVYwNEwwNVJ2dkNu?=
 =?utf-8?B?S2ZhcEZnUm11M05QR2grT2pGNnkwOFpZYlBWcFNSVWtOaU5uMk4wK3lnc2xZ?=
 =?utf-8?B?Qkh2SU80MTNpdDZ3VjJpMENmYlpNSkNCUFJmV29xNzQwK3A5QUFmRmVaQjNT?=
 =?utf-8?B?b2EvNmxWVEgreEJSM3RNNzZwNkZ5ajN5UzVLOW5CVWtKUDBtTDRPcUZMbTdm?=
 =?utf-8?B?T1lVUVlEUEF6SWc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 03:48:06.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a05fe399-8c52-4024-50c1-08d89b2c125d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFQ5Nr/BX1YQ7fSX9Yeps3iXH/o7Djpt+b88NXXn3qDwbLa0T1J1XYSSyFTUeB6Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_19:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/20 1:55 PM, Weqaar Janjua wrote:
> On Sat, 28 Nov 2020 at 03:13, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 11/27/20 9:54 AM, Weqaar Janjua wrote:
>>> On Fri, 27 Nov 2020 at 04:19, Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 11/26/20 1:22 PM, Weqaar Janjua wrote:
>>>>> On Thu, 26 Nov 2020 at 09:01, Björn Töpel <bjorn.topel@intel.com> wrote:
>>>>>>
>>>>>> On 2020-11-26 07:44, Yonghong Song wrote:
>>>>>>>
>>>>>> [...]
>>>>>>>
>>>>>>> What other configures I am missing?
>>>>>>>
>>>>>>> BTW, I cherry-picked the following pick from bpf tree in this experiment.
>>>>>>>       commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
>>>>>>>       Author: Björn Töpel <bjorn.topel@intel.com>
>>>>>>>       Date:   Mon Nov 23 18:56:00 2020 +0100
>>>>>>>
>>>>>>>           net, xsk: Avoid taking multiple skbuff references
>>>>>>>
>>>>>>
>>>>>> Hmm, I'm getting an oops, unless I cherry-pick:
>>>>>>
>>>>>> 36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")
>>>>>>
>>>>>> *AND*
>>>>>>
>>>>>> 537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")
>>>>>>
>>>>>> from bpf/master.
>>>>>>
>>>>>
>>>>> Same as Bjorn's findings ^^^, additionally applying the second patch
>>>>> 537cf4e3cc2f [PASS] all tests for me
>>>>>
>>>>> PREREQUISITES: [ PASS ]
>>>>> SKB NOPOLL: [ PASS ]
>>>>> SKB POLL: [ PASS ]
>>>>> DRV NOPOLL: [ PASS ]
>>>>> DRV POLL: [ PASS ]
>>>>> SKB SOCKET TEARDOWN: [ PASS ]
>>>>> DRV SOCKET TEARDOWN: [ PASS ]
>>>>> SKB BIDIRECTIONAL SOCKETS: [ PASS ]
>>>>> DRV BIDIRECTIONAL SOCKETS: [ PASS ]
>>>>>
>>>>> With the first patch alone, as soon as we enter DRV/Native NOPOLL mode
>>>>> kernel panics, whereas in your case NOPOLL tests were falling with
>>>>> packets being *lost* as per seqnum mismatch.
>>>>>
>>>>> Can you please test this out with both patches and let us know?
>>>>
>>>> I applied both the above patches in bpf-next as well as this patch set,
>>>> I still see failures. I am attaching my config file. Maybe you can take
>>>> a look at what is the issue.
>>>>
>>> Thanks for the config, can you please confirm the compiler version,
>>> and resource limits i.e. stack size, memory, etc.?
>>
>> root@arch-fb-vm1:~/net-next/net-next/tools/testing/selftests/bpf ulimit -a
>> core file size          (blocks, -c) unlimited
>> data seg size           (kbytes, -d) unlimited
>> scheduling priority             (-e) 0
>> file size               (blocks, -f) unlimited
>> pending signals                 (-i) 15587
>> max locked memory       (kbytes, -l) unlimited
>> max memory size         (kbytes, -m) unlimited
>> open files                      (-n) 1024
>> pipe size            (512 bytes, -p) 8
>> POSIX message queues     (bytes, -q) 819200
>> real-time priority              (-r) 0
>> stack size              (kbytes, -s) 8192
>> cpu time               (seconds, -t) unlimited
>> max user processes              (-u) 15587
>> virtual memory          (kbytes, -v) unlimited
>> file locks                      (-x) unlimited
>>
>> compiler: gcc 8.2
>>
>>>
>>> Only NOPOLL tests are failing for you as I see it, do the same tests
>>> fail every time?
>>
>> In my case, with above two bpf patches applied as well, I got:
>> $ ./test_xsk.sh
>> setting up ve9127: root: 192.168.222.1/30
>>
>> setting up ve4520: af_xdp4520: 192.168.222.2/30
>>
>> Spec file created: veth.spec
>>
>> PREREQUISITES: [ PASS ]
>>
>> # Interface found: ve9127
>>
>> # Interface found: ve4520
>>
>> # NS switched: af_xdp4520
>>
>> 1..1
>>
>> # Interface [ve4520] vector [Rx]
>>
>> # Interface [ve9127] vector [Tx]
>>
>> # Sending 10000 packets on interface ve9127
>>
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [59], payloadseqnum [0]
>>
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>>
>> SKB NOPOLL: [ FAIL ]
>>
>> # Interface found: ve9127
>>
>> # Interface found: ve4520
>>
>> # NS switched: af_xdp4520
>> # NS switched: af_xdp4520
>>
>> 1..1
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> # End-of-tranmission frame received: PASS
>> # Received 10000 packets on interface ve4520
>> ok 1 PASS: SKB POLL
>> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>> SKB POLL: [ PASS ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [153], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV NOPOLL: [ FAIL ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> # End-of-tranmission frame received: PASS
>> # Received 10000 packets on interface ve4520
>> ok 1 PASS: DRV POLL
>> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>> DRV POLL: [ PASS ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Creating socket
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [54], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> SKB SOCKET TEARDOWN: [ FAIL ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Creating socket
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV SOCKET TEARDOWN: [ FAIL ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Creating socket
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [64], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
>> # Interface found: ve9127
>> # Interface found: ve4520
>> # NS switched: af_xdp4520
>> 1..1
>> # Creating socket
>> # Interface [ve4520] vector [Rx]
>> # Interface [ve9127] vector [Tx]
>> # Sending 10000 packets on interface ve9127
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [83], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
>> cleaning up...
>> removing link ve4520
>> removing ns af_xdp4520
>> removing spec file: veth.spec
>>
>> Second runs have one previous success becoming failure.
>>
>> ./test_xsk.sh
>> setting up ve2458: root: 192.168.222.1/30
>>
>> setting up ve4468: af_xdp4468: 192.168.222.2/30
>>
>> [  286.597111] IPv6: ADDRCONF(NETDEV_CHANGE): ve4468: link becomes ready
>>
>> Spec file created: veth.spec
>>
>> PREREQUISITES: [ PASS ]
>>
>> # Interface found: ve2458
>>
>> # Interface found: ve4468
>>
>> # NS switched: af_xdp4468
>>
>> 1..1
>>
>> # Interface [ve4468] vector [Rx]
>>
>> # Interface [ve2458] vector [Tx]
>>
>> # Sending 10000 packets on interface ve2458
>>
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [67], payloadseqnum [0]
>>
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>>
>> SKB NOPOLL: [ FAIL ]
>>
>> # Interface found: ve2458
>>
>> # Interface found: ve4468
>>
>> # NS switched: af_xdp4468
>>
>> 1..1
>>
>> # Interface [ve4468] vector [Rx]
>>
>> # Interface [ve2458] vector [Tx]
>>
>> # Sending 10000 packets on interface ve2458
>>
>> # End-of-tranmission frame received: PASS
>> # Received 10000 packets on interface ve4468
>> ok 1 PASS: SKB POLL
>> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>> SKB POLL: [ PASS ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [191], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV NOPOLL: [ FAIL ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV POLL: [ FAIL ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Creating socket
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> SKB SOCKET TEARDOWN: [ FAIL ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Creating socket
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [171], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV SOCKET TEARDOWN: [ FAIL ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Creating socket
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [124], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
>> # Interface found: ve2458
>> # Interface found: ve4468
>> # NS switched: af_xdp4468
>> 1..1
>> # Creating socket
>> # Interface [ve4468] vector [Rx]
>> # Interface [ve2458] vector [Tx]
>> # Sending 10000 packets on interface ve2458
>> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [195], payloadseqnum [0]
>> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>> DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
>> cleaning up...
>> removing link ve4468
>> removing ns af_xdp4468
>> removing spec file: veth.spec
>>
>>>
>>> I will need to spend some time debugging this to have a fix.
>>
>> Thanks.
>>
>>>
>>> Thanks,
>>> /Weqaar
>>>
>>>>>
>>>>>> Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory?
>>>>>> This will be easier than the above for bpf developers. If it does not
>>>>>> work, I would like to recommend to make it work.
>>>>>>
>>>>> yes test_xsk.shis self contained, will update the instructions in there with v4.
>>>>
>>>> That will be great. Thanks!
>>>>
> v4 is out on the list, incorporating most if not all your suggestions
> to the best of my memory.
> 
> I was able to reproduce the issue you were seeing (from your logs) ->
> veth interfaces were receiving packets from the IPv6 neighboring
> system (thanks @Björn Töpel for mentioning this).
> 
> The packet validation algo in *xdpxceiver* *assumed* all packets would
> be IPv4 and intended for Rx.
> Rx validates packets on both ip->tos = 0x9 (id for xsk tests) and
> ip->version = 0x4, ignores the rest.
> 
> Hoping the tests now work -> PASS in your environment.

Yes, no all tests passed in my environment. I will reply the v4
with Test-by tag. Now I think xsk people can really look at details.

> 
> Thanks,
> /Weqaar
> 
>>>>>
>>>>> Thanks,
>>>>> /Weqaar
>>>>>>
>>>>>> Björn
