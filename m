Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DDD6140BF
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJaWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJaWjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:39:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D048955B8;
        Mon, 31 Oct 2022 15:39:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VMPDLa021965;
        Mon, 31 Oct 2022 15:38:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=4pqExb13oL+QjTnhqlFlH8G4yqJg1l2aBeAG9CSC7a0=;
 b=goTOdlGFfRauSfDWGsRYhgBeekTnV8Ff2Ivj2j1yruPEHZY4ULpP37EKZkw+kJOud1P/
 f5l6rte554R/EBR/YAYamXzZ2htghhZazj7RVc5UW3I9YcjOqZ4k/qR4vslZtFkGlrKE
 Y4+sxzvSIARHFmQX+lJMqKiEzRt8s9qMvNXwvGGx/UfYf7h46cosTJBrggdJYiElBeZM
 q8ua0AdCWEbqpp5REMhAjnUFPo33LcaL72b2C6pnJs2smMv3DT7Bde8nER9/7iN4Ei9J
 I54wPFMjzvYxj5NmfUNUWN82taokXDqeOLD2MGBW5wb6yrzuo8R6ybMHxXSLwSGb3tfX iQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kjk60tcfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 15:38:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KACjQizeB30UVYsbDDZXMS3zpeDyZJxWkcVihd8fIke9TPnZXmyy5ii3fYgzfvbytbkzqGTdEGWm/5cBuavUIyI/oyZG2iFXWLMCb5ewfXy3pOJqi6/oWvaNKTqWyUPmuc8//8rGuoiTAAKBlpjBnMAXfWouy3eH1sgWuC6df8qAgPPaXgcDImhlDrPfXPXVdg2ND2oD0Noa0LDAmojPiUZ8BMAKcbgfuQoPLdk0PiQSkhETECNrTIe/uMdyebXBZqwR/tykuxav9hGvx2rJiYG2wNB9eX/SnsBe8kO/u8kojd1D+xI91K44ZqZ8p4xZdgadZ2Y0BDV9BNAzIhY+Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pqExb13oL+QjTnhqlFlH8G4yqJg1l2aBeAG9CSC7a0=;
 b=ZN60tsV9ajEt7v0lqPaQw7wSq+MiYUfcT9V6oqpDOYetK+7cGz6ce62r96Xl/zmBg82R25KDZ3/ydhbpVYniVR0rfskAIIlmN9IsPkXIAznPqpjzr7det1V+i0BqEIplKWqPUVj9Cmi86dtYeFpMv2IysVw5J04YaxGfewIGRi4CLH9JNH2Uw6lyWlAGc2OKn4Lfx8byxwbJ5CRvRWJvmOcD28JGasAeRXB7smv//BzTploZSmuqZhUG3YnjijTFE6humSPu3thGNeXpDkQpRavNMhIMD/+RGi9hduyJ+8b02eY+nkO4d44ApXjIOTgCGkYI0t8oq9PoyFD0xWOXJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4779.namprd15.prod.outlook.com (2603:10b6:303:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 22:38:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e25d:b529:7556:1e26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e25d:b529:7556:1e26%5]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 22:38:43 +0000
Message-ID: <8892271c-fd8d-e8f3-5de9-b94e5f1ce5fe@meta.com>
Date:   Mon, 31 Oct 2022 15:38:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
 <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW4PR15MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: cfe9e924-cafc-481d-1c14-08dabb90aa13
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kZM3qeRuwifdCSbO1iE49MsghfwWN06pJncpLwtwG1pHVJ/qI4J9/eRM75kIU0d2pgCwl6EzJB01uBbO6RwG6FkPuaEyw2TGpcwq78SxinlLIQN6rvq1n5l6QVOq5b4P7WsV7jmvGPe/hq3GUqj73ZHi8gUMBP1z7nwovM8oK6g9adq7Ti11orrRx/TjLpssReArGt0zVP8O0udtQixT4SO2GPnxqS1F8m3ToKMIIvXb6BdpPF/teVAt/c3dv7zmih9N/7AYMRVleSbhBpPkQCi18AOMvfYdOaXfU8U2FUF0DDyPzOf4nyMrPPE2tliZ5j5rtr55DtfTbGzFJ3ed0mGjU+pkVT3cqV60BYPc2DM6BqoBZIOOpeEDb+vmFYebvqPRhro9Gr9yrbrQRH2GCP0eCC+D5Bk+F+RhxQwKI7/p6Tur7wkggwxB0Mf34vjmWtDqZhwvObVn6nr351ro9Pa/g1eDMNaX8L7SWgVaJ5TPYiqGgAd1GHt7dY/bCxnnImWmXpWSWJjrlo+7gqZAzsXVFIAuG5J6Zy4xxfrx1LrVEV+zytAc+QWD48zDy864YSSaZjQXPfTpn3mxSKdc+1BktpVdOJKGkB84BaTaGX0koKQ3xat60cfqACAQqBGEx1lAqnSakivOfZSsqp0FBMmBFcqjwTsdAnwzRMhxjR9ibyHeIffc8/YFMPPytWdd78w1dFKgamvI+MjWAP+qBhRdkvTCfmbjdxw1adCfEjyewLF7Jk/cBI3pLO6haNNH5soV2BcrO/5feyWBjjADH0o/5hNjII7I0Sh0noAl04=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(478600001)(8676002)(4326008)(66946007)(66899015)(66556008)(31686004)(66476007)(5660300002)(6506007)(186003)(54906003)(36756003)(83380400001)(6916009)(6486002)(316002)(31696002)(41300700001)(86362001)(53546011)(8936002)(2906002)(6512007)(2616005)(7416002)(66574015)(4001150100001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdpSTMrazlDNGNqMThLV1BBSzB0YnRBYStMRkFOR0NGV0RqUTd3UlF1MmFv?=
 =?utf-8?B?SnpJbTdHczZSQXJlK0F2VTYzYTBCVTRyckhWK1VObmh2Q0w1WkRQcUxNdjYx?=
 =?utf-8?B?Z2duZ1BmbGFveWxJSlNrVVZQSU9PS3JXMytmV2pRZlVqSjFIY1dBeUNqWE0v?=
 =?utf-8?B?T3dYc3FsSCtiamRRMXRpQWJONnJ5ZTVmZW9hVHhZQ2N1aXlna0F6RUJ3V3VZ?=
 =?utf-8?B?K3RnUnUyb1c3UlBnM0tNVEFGT1A4M2pwTE9JOHovTnJZMnlod1kzdnE2c2Fx?=
 =?utf-8?B?UlJCeEJMZXhiWEh1VUxCdWRIVGdkKzZBQjJGNWNRT3dKS1NkVDRPTmxUcThQ?=
 =?utf-8?B?cktFQW1qcGpmU0hVMFdnWVMzMmVxU01DOURVMmdVZEdXcHUzdC90bHpPN2R0?=
 =?utf-8?B?eVMrNG1remtTcVZXMi9kSzB3cFRnSi9nY0VyM29jcnJ1QXRQcXpZSXphaWF1?=
 =?utf-8?B?OEV1VzBpblcyaUhrTmNkVHRnb1lJNE9WcU81YUY4Z3RkditaWHMyQ0FNSXF0?=
 =?utf-8?B?WVYxNXpoa1BTRk1kUUhQd0pjRFhNbUxCdTN6SWYyUWdBd091Ynk4K2cxbmkw?=
 =?utf-8?B?Zit3UW4xZ0VwWlNDOGZRZ0Qvb2pHc3NVejNtR0QzT2YwZHJpVzVUMTh1M1VC?=
 =?utf-8?B?R3hFcm1ua091M21WY0dTbC9ucGxKZUFCdk9OZ05jU1NMRnFoVkY4MHI0QjhY?=
 =?utf-8?B?d3Q3dFF4OGx4VTNNRGVXQUlLTlZGMjNYSVVIS1o4V0VhbEpBYmdwODdEbmlh?=
 =?utf-8?B?YlMwbGpyZ0x3cDFEV2VtTWtJcmQ1MnVWbDV2NUhJdkIrdzIxYkczdWgvTnM4?=
 =?utf-8?B?dFlMZ3NjaURqTmFmbU9icnh2bCtXL2I0ZXR5eDhiOUpsVS9sM0lXUXFZQWw1?=
 =?utf-8?B?NlR2MHVrZDU1cDVic1ZMNGpiZ2h5TG93VkUwaks3dml1dXl4ZFk3c2RPY3Fa?=
 =?utf-8?B?d1R2MFk2NmQ4UHY5TGY4TDlhQXgzVmNvR2tTRndEb1EyV2ZJOVdoOWQ0TFJI?=
 =?utf-8?B?eGt1ZmtQNlRtRisyVVY1WFIydmYySlBnZFphV1BkSm1PWVBJY0ptWGZXQjZT?=
 =?utf-8?B?ZGdJTVhaMmp1M3N6Z09vbm5BUWdzcFNJT3FWYkdXWDg5VVcrRjdUTmI4WXFy?=
 =?utf-8?B?ZTV5dTdYOGQvU3o0QlpxUXhnaS9XVEdBVlprRXJsd0ZabC9qRUNiQ1FvcGQ4?=
 =?utf-8?B?a00wTWdDc29xVXU1TzFBQW4weGJBMFRteTVuTGFqZ1JtM3hOTVJrRlJRZmZw?=
 =?utf-8?B?NDNueEdwS2ZLZEdVbXRyRnV3WEpaa25RYnoxMTNsTFQrSFdLR0diS1JURjBN?=
 =?utf-8?B?dkJGMjZMSUpFc1hXNi9wNGVHWUlkd3VIbUxUeVFKYnRtd0VMQ3VLVkwzRyt1?=
 =?utf-8?B?d0pxZUZ4QklhenFpVGFjMnp4L1gwQXRpRkJnVmxENWM1YjliNDUwUTYzeWI5?=
 =?utf-8?B?U3JTY1RpaW8raE56QkVZVVk0TjdLSGhpdyt6Q2JncFhxcEN2WVY4UFhObXZY?=
 =?utf-8?B?aE0vQXlLWk5sZWF0aFg0MlZ0SlpzQnBOZEVMbmpzd2lGRkFkYjBVMlc0ZmEy?=
 =?utf-8?B?TXYwVkkrU29peFJPM2NMUjFSU0dKOW9ZUEFMMUhZUEFzcDVTNnZnaUhMYzF0?=
 =?utf-8?B?VllPZ0FGNkdTejV6SmdKRktFbEtCWE9vVWpmb2F0bndUd3pxR09aazRHTzAv?=
 =?utf-8?B?ZEZlRkttMFpScG5SS1M3Umw2UklQTW56N3FzdmlxZFExc2U5WS9EMVpPMit2?=
 =?utf-8?B?M2NqTUxSMlF3WENzc0Q3M3JRY09kUExPQWt5NDlacVhBVFM2NFY3dndiYzdr?=
 =?utf-8?B?LzIxWHA1bGNyTzRDNVlRS1o3dW0wLzUrdmtkWGVUb3RuUzJHQjZTQ2dDNE00?=
 =?utf-8?B?Q2kyZnI1MytyWDlPd0FPZ1N4aTF2NExJNzc5MERyY2RQQnNESVVmOExhR0dI?=
 =?utf-8?B?RWNGc05UMjZiNWdxM2o1SGptelFiUWxyNWtCSGlMVVJPYzVvdW05VERtbHRM?=
 =?utf-8?B?NU45dENkemxxZmhJR2pjTnhqdUhhN0hhZTBMMURvdDJYTGk3UU5OMlhWUXlo?=
 =?utf-8?B?cHRkQm12SStEQ0RodFdVZ2ZlVnZ6alg4VzF4dDhMTmgzN3liWldZcTRFS3Bo?=
 =?utf-8?B?N0kvaGZjUHRuYWNxTWFxNnNhSFVBS3ZmaFg0aHN2bjFqVUZHNnFFekFZUU54?=
 =?utf-8?B?Wnc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe9e924-cafc-481d-1c14-08dabb90aa13
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 22:38:43.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKoWhh/Pz17fn4Q0AcvkMafGJ5SB+eT7Zz0naHKhrjxS1g4jdkOUrbQgEA5Ju59M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4779
X-Proofpoint-GUID: cTDOqiY6H9jZwqKOzKY8Grz9Ya6OVI39
X-Proofpoint-ORIG-GUID: cTDOqiY6H9jZwqKOzKY8Grz9Ya6OVI39
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_21,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/22 3:09 PM, Stanislav Fomichev wrote:
> On Mon, Oct 31, 2022 at 12:36 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 10/31/22 8:28 AM, Toke Høiland-Jørgensen wrote:
>>> "Bezdeka, Florian" <florian.bezdeka@siemens.com> writes:
>>>
>>>> Hi all,
>>>>
>>>> I was closely following this discussion for some time now. Seems we
>>>> reached the point where it's getting interesting for me.
>>>>
>>>> On Fri, 2022-10-28 at 18:14 -0700, Jakub Kicinski wrote:
>>>>> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
>>>>>>>> And it's actually harder to abstract away inter HW generation
>>>>>>>> differences if the user space code has to handle all of it.
>>>>>>
>>>>>> I don't see how its any harder in practice though?
>>>>>
>>>>> You need to find out what HW/FW/config you're running, right?
>>>>> And all you have is a pointer to a blob of unknown type.
>>>>>
>>>>> Take timestamps for example, some NICs support adjusting the PHC
>>>>> or doing SW corrections (with different versions of hw/fw/server
>>>>> platforms being capable of both/one/neither).
>>>>>
>>>>> Sure you can extract all this info with tracing and careful
>>>>> inspection via uAPI. But I don't think that's _easier_.
>>>>> And the vendors can't run the results thru their validation
>>>>> (for whatever that's worth).
>>>>>
>>>>>>> I've had the same concern:
>>>>>>>
>>>>>>> Until we have some userspace library that abstracts all these details,
>>>>>>> it's not really convenient to use. IIUC, with a kptr, I'd get a blob
>>>>>>> of data and I need to go through the code and see what particular type
>>>>>>> it represents for my particular device and how the data I need is
>>>>>>> represented there. There are also these "if this is device v1 -> use
>>>>>>> v1 descriptor format; if it's a v2->use this another struct; etc"
>>>>>>> complexities that we'll be pushing onto the users. With kfuncs, we put
>>>>>>> this burden on the driver developers, but I agree that the drawback
>>>>>>> here is that we actually have to wait for the implementations to catch
>>>>>>> up.
>>>>>>
>>>>>> I agree with everything there, you will get a blob of data and then
>>>>>> will need to know what field you want to read using BTF. But, we
>>>>>> already do this for BPF programs all over the place so its not a big
>>>>>> lift for us. All other BPF tracing/observability requires the same
>>>>>> logic. I think users of BPF in general perhaps XDP/tc are the only
>>>>>> place left to write BPF programs without thinking about BTF and
>>>>>> kernel data structures.
>>>>>>
>>>>>> But, with proposed kptr the complexity lives in userspace and can be
>>>>>> fixed, added, updated without having to bother with kernel updates, etc.
>>>>>>   From my point of view of supporting Cilium its a win and much preferred
>>>>>> to having to deal with driver owners on all cloud vendors, distributions,
>>>>>> and so on.
>>>>>>
>>>>>> If vendor updates firmware with new fields I get those immediately.
>>>>>
>>>>> Conversely it's a valid concern that those who *do* actually update
>>>>> their kernel regularly will have more things to worry about.
>>>>>
>>>>>>> Jakub mentions FW and I haven't even thought about that; so yeah, bpf
>>>>>>> programs might have to take a lot of other state into consideration
>>>>>>> when parsing the descriptors; all those details do seem like they
>>>>>>> belong to the driver code.
>>>>>>
>>>>>> I would prefer to avoid being stuck on requiring driver writers to
>>>>>> be involved. With just a kptr I can support the device and any
>>>>>> firwmare versions without requiring help.
>>>>>
>>>>> 1) where are you getting all those HW / FW specs :S
>>>>> 2) maybe *you* can but you're not exactly not an ex-driver developer :S
>>>>>
>>>>>>> Feel free to send it early with just a handful of drivers implemented;
>>>>>>> I'm more interested about bpf/af_xdp/user api story; if we have some
>>>>>>> nice sample/test case that shows how the metadata can be used, that
>>>>>>> might push us closer to the agreement on the best way to proceed.
>>>>>>
>>>>>> I'll try to do a intel and mlx implementation to get a cross section.
>>>>>> I have a good collection of nics here so should be able to show a
>>>>>> couple firmware versions. It could be fine I think to have the raw
>>>>>> kptr access and then also kfuncs for some things perhaps.
>>>>>>
>>>>>>>> I'd prefer if we left the door open for new vendors. Punting descriptor
>>>>>>>> parsing to user space will indeed result in what you just said - major
>>>>>>>> vendors are supported and that's it.
>>>>>>
>>>>>> I'm not sure about why it would make it harder for new vendors? I think
>>>>>> the opposite,
>>>>>
>>>>> TBH I'm only replying to the email because of the above part :)
>>>>> I thought this would be self evident, but I guess our perspectives
>>>>> are different.
>>>>>
>>>>> Perhaps you look at it from the perspective of SW running on someone
>>>>> else's cloud, an being able to move to another cloud, without having
>>>>> to worry if feature X is available in xdp or just skb.
>>>>>
>>>>> I look at it from the perspective of maintaining a cloud, with people
>>>>> writing random XDP applications. If I swap a NIC from an incumbent to a
>>>>> (superior) startup, and cloud users are messing with raw descriptor -
>>>>> I'd need to go find every XDP program out there and make sure it
>>>>> understands the new descriptors.
>>>>
>>>> Here is another perspective:
>>>>
>>>> As AF_XDP application developer I don't wan't to deal with the
>>>> underlying hardware in detail. I like to request a feature from the OS
>>>> (in this case rx/tx timestamping). If the feature is available I will
>>>> simply use it, if not I might have to work around it - maybe by falling
>>>> back to SW timestamping.
>>>>
>>>> All parts of my application (BPF program included) should not be
>>>> optimized/adjusted for all the different HW variants out there.
>>>
>>> Yes, absolutely agreed. Abstracting away those kinds of hardware
>>> differences is the whole *point* of having an OS/driver model. I.e.,
>>> it's what the kernel is there for! If people want to bypass that and get
>>> direct access to the hardware, they can already do that by using DPDK.
>>>
>>> So in other words, 100% agreed that we should not expect the BPF
>>> developers to deal with hardware details as would be required with a
>>> kptr-based interface.
>>>
>>> As for the kfunc-based interface, I think it shows some promise.
>>> Exposing a list of function names to retrieve individual metadata items
>>> instead of a struct layout is sorta comparable in terms of developer UI
>>> accessibility etc (IMO).
>>
>> Looks like there are quite some use cases for hw_timestamp.
>> Do you think we could add it to the uapi like struct xdp_md?
>>
>> The following is the current xdp_md:
>> struct xdp_md {
>>           __u32 data;
>>           __u32 data_end;
>>           __u32 data_meta;
>>           /* Below access go through struct xdp_rxq_info */
>>           __u32 ingress_ifindex; /* rxq->dev->ifindex */
>>           __u32 rx_queue_index;  /* rxq->queue_index  */
>>
>>           __u32 egress_ifindex;  /* txq->dev->ifindex */
>> };
>>
>> We could add  __u64 hw_timestamp to the xdp_md so user
>> can just do xdp_md->hw_timestamp to get the value.
>> xdp_md->hw_timestamp == 0 means hw_timestamp is not
>> available.
>>
>> Inside the kernel, the ctx rewriter can generate code
>> to call driver specific function to retrieve the data.
> 
> If the driver generates the code to retrieve the data, how's that
> different from the kfunc approach?
> The only difference I see is that it would be a more strong UAPI than
> the kfuncs?

Right. it is a strong uapi.

> 
>> The kfunc approach can be used to *less* common use cases?
> 
> What's the advantage of having two approaches when one can cover
> common and uncommon cases?

Beyond hw_timestamp, do we have any other fields ready to support?

If it ends up with lots of fields to be accessed by the bpf program,
and bpf program actually intends to access these fields,
using a strong uapi might be a good thing as it can make code
much streamlined.

> 
>>> There are three main drawbacks, AFAICT:
>>>
>>> 1. It requires driver developers to write and maintain the code that
>>> generates the unrolled BPF bytecode to access the metadata fields, which
>>> is a non-trivial amount of complexity. Maybe this can be abstracted away
>>> with some internal helpers though (like, e.g., a
>>> bpf_xdp_metadata_copy_u64(dst, src, offset) helper which would spit out
>>> the required JMP/MOV/LDX instructions?
>>>
>>> 2. AF_XDP programs won't be able to access the metadata without using a
>>> custom XDP program that calls the kfuncs and puts the data into the
>>> metadata area. We could solve this with some code in libxdp, though; if
>>> this code can be made generic enough (so it just dumps the available
>>> metadata functions from the running kernel at load time), it may be
>>> possible to make it generic enough that it will be forward-compatible
>>> with new versions of the kernel that add new fields, which should
>>> alleviate Florian's concern about keeping things in sync.
>>>
>>> 3. It will make it harder to consume the metadata when building SKBs. I
>>> think the CPUMAP and veth use cases are also quite important, and that
>>> we want metadata to be available for building SKBs in this path. Maybe
>>> this can be resolved by having a convenient kfunc for this that can be
>>> used for programs doing such redirects. E.g., you could just call
>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>> would recursively expand into all the kfunc calls needed to extract the
>>> metadata supported by the SKB path?
>>>
>>> -Toke
>>>
