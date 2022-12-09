Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F005464898B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 21:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiLIUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 15:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIUby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 15:31:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1674D934FE;
        Fri,  9 Dec 2022 12:31:52 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9JQKUI006042;
        Fri, 9 Dec 2022 12:31:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=UU7SyMbUrCabyHWTv+R0oXCWyU93Ck0Pt/4PCeWFCOQ=;
 b=METYWd+sOTnK8mG8SPABUApovPkQizMQhGlcE8WkY+zACRO3u0nGG3aATPhygbUbhzHi
 r7BfeZyYd1Et9CCWRhn0Rz7dqGGwPd0qeB2cwNDG4QIwssPwIMCX7BCfIu0mM9H+2JnL
 8Yy11N0P12WOhi3ZNF/dziMeCvyIVCNOsFu2rqEhMeAGcKTorABLmNQ3QMjuYLTIMbOi
 UHREISil/Nc9f7fcTVdwNIJT3HsTrQuOGxDSW7zPqtKFlsODP+lAga9GRz60adQvnIaP
 YsjpFxlHkKSXA/bXtUoLOu3vnZ0ftZ0x1w5ty4oupEJVmMcja5j9UFDoANd88LMlNK4J rw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mbkep1vm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQ+DXTp1H+WNjkvjS7901nQhGvC8n8utwtNtQP8pozntLOOn5DwKffgnR+2zhaIIz4QzzFCG/38FQOJ3n/rsWwUGpO1KnNtSKk3xDpu4dMHP7rW66vOawpowDFugcNKS+cAIMiB2Qddtp8QoqXmr0/iitwFfB5V2ldDK9jUyLfZTPZ1i4W7u2Os3TTCfgKttVFpg4AFZx+G9or5I/DY7eaocMJlRXmn0sz9xH9hmLs/Pgb+Cb7HCeO8K7erP9w3V8XWWOWM8WkzAcDbXQN8ryucJ2iYhqP0UHGal9MKFqaVAg3/pC7CywWO112bSHhgL8duaMBHyK3Kn3+v+N/Frhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UU7SyMbUrCabyHWTv+R0oXCWyU93Ck0Pt/4PCeWFCOQ=;
 b=frymbCq/7S6DXxy4EAmQ/P1dIQzQo2T+f+w4Kg3xNn9xSL3RXZ+fQoSg3TdxgAbxKcMowwAJBiHlruMx31XNJkTtv3KL2fh+vPrmaT+fQcuhRvjWApRXYgJp/baS2cZpslDy5yY/vs17UAGnHzXbdHKPB9+nwUMEtpAJR8qbrsi7v/VjM/7qWPWouKA3A6kQ1vbd/uHl+27KZw86jETnqfumFlmLptddaCoBnl3eq5uMr7yN+t+1IumLi8RO8PRAYRumgXICb6zhL4GCxBXSPYwa1z4kmCuj2A41EyjfBkzEDGij0n8ixiFMhvfBtx6EN0BNmIFP/pLITdtbN1nXNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB3361.namprd15.prod.outlook.com (2603:10b6:408:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 20:31:10 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 20:31:10 +0000
Message-ID: <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
Date:   Fri, 9 Dec 2022 12:31:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Content-Language: en-US
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava> <Y5JkomOZaCETLDaZ@krava> <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava> <Y5MaffJOe1QtumSN@krava> <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <Y5NSStSi7h9Vdo/j@krava>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN8PR15MB3361:EE_
X-MS-Office365-Filtering-Correlation-Id: 95fd33ee-9e06-44b9-912d-08dada244e87
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3V/2ZZvHaX93F2XPFOiAjTNG/Ty6KEKUnHOOtkD1YuhX6/l5fvCLXS5loNYwRxBD9Bvalj8p08hBZ/tiiuizRPpogQIauiNrZIFYtN7PQyDzMXASVTCR/X6yhTNQi+4sAll8leTXWUgsaaju2yx/TOXd/LmDoFz2WJN7QQqTTmNFl5KJboeHcIM447BQHVuCjSarQqHiQiQTZWaErE0uOJbnSnDlbDVgzpZ9iLuJdQWcbe/CXxqi0PxWj6AKL0ll+MK8tJgt1mhh7T8kELG4IeTc4W8ov3JqlUriawEnN/TalV995294SSEungnD7xwYo7JsvbgOFKZtiomEzWyF2N2TznRB3IqfMj72zK+VW2NDMqU5UXgPMaJrz7MkFM515lLdx6NHQKJm8clf5BMHFxcIo0ix4SB0CDV5yyklziWqZK2wc6v3Lz3PROkAg/elwIXeO/ue5HAWJw1UsFZ6tciK49dIx3jz1BEH/dHM+BNN6MNv3B6VJ6lqCgV3xpEJ0rd9nDBod1bgeFk3NLoYcxt0HtkCutHsWr+0XdcbyYOJjx3KnyH5ZzOj+jX0ORZmgcITAAm6YRnoGY1SATWyPSo0P81wdH6Q6ScaK4X5lYgeVIHXGXCdCGthAX6+0qojfzwGes/T9PGpl4kK+DmynnM0wVFMG+OMRpwmdi8tvMwgCViFre8GuA7+Hs3s6jniNa7zBRQNxwj0D8vCV8aDei4THeS6p5wSRZKCqqLRlp8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(36756003)(83380400001)(6916009)(66946007)(41300700001)(8676002)(316002)(54906003)(5660300002)(6666004)(53546011)(6512007)(4326008)(6506007)(6486002)(31696002)(38100700002)(86362001)(186003)(478600001)(66476007)(66556008)(2616005)(7416002)(8936002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c01GdkNnZDVNcGh2d1JFVmVEcUNxQmhKN3htb2p3eTFYek5ianFzQ1V6L3lh?=
 =?utf-8?B?ZG1nalY3S2ZHZFlvNHFRSGVBL2s0L0NVdk0xeENYZUg0Mk9KNDVDV2RQR2Ju?=
 =?utf-8?B?OHZTZ0tmNCszaVhMNVdLVnRvSmtzY3RnTHNxSW9iSDVvQXNnc0tWNUh5UFUx?=
 =?utf-8?B?ckp2V3NQSUl0ZkdJaGpwUUhOalVDMnNIbnRiVXQ5bFZ1WTloNUN0amZjMms3?=
 =?utf-8?B?S0Y4UEhlSHh1RXMrQTBjS3ZVcXRuaUFTTkJHWGNCdFBLQzJDK3BIOGpTZEVw?=
 =?utf-8?B?U1NTM2VvVXp0L2xkL0dlWTdPRGk3aVNiUGpXdFNFL2tmR2dhY0MzaGxhZXJl?=
 =?utf-8?B?SnNDTUlPS0VZaCtwT2pzczh4SVg4d2poV3NJMm1oZDQ0SEo3ZnNQQldWM214?=
 =?utf-8?B?dzVyS25GN1FuNUYrK2xpRFNKSmM2VWlnNGowK3BDQW41aER3QTk3Ukx6Znly?=
 =?utf-8?B?SExMaFhadzhaaEozN3ZGL3pQUU1lUzBtNXlwVCtHcUxiRnVBeHdPYkRPRGQ5?=
 =?utf-8?B?WGNpV0JwTEVuQ2M1S3JqTEJ5YnNGbFRGVXovVndQdXhkdEV2MnpoMjUxOUZk?=
 =?utf-8?B?ck90ZldxNk04RzNRRmZtelZTZE9RNnoyY1MrVnQwUk41c2tSNkl1K3NzTURw?=
 =?utf-8?B?dHhkNVdXaS8zSlM3dUlqYUJHQjc5UnNobGRXUU9Eb2V1a2hJM1I5YVoycEV5?=
 =?utf-8?B?NVNVS1pscm5abEJCSFdQcmNlNVhXNlpCK3ZGWUdoY3dhbU1CMUZJdlhIckJx?=
 =?utf-8?B?U3pyRUk2TGJNWGtOWGk2bU5rYWhwcVRONU85K01JWm5XWDFjbVNCbnU1aGFF?=
 =?utf-8?B?ekgxMDhUcTd2d09yWE9UbFBZeml5NmFwelNtN2Q0Z3QwRHFlVFBwR0lVcUVM?=
 =?utf-8?B?Y05vWUlmSGxvVndpS1ZVMytWRzhwZnlETnpvdDIvM3Q0N1NUQmorWDlGblFO?=
 =?utf-8?B?elVoWmplb0Z5MW15M2l2dGpxZy95UDRaWUJlZVMvcmJMRHp4WjV5TkFkTWZy?=
 =?utf-8?B?MzloVWh2ZnRNT3N6dWlMN2xjMU00QnlZWE9YNGE0dnhxMlVlR2EzdEh2RXhG?=
 =?utf-8?B?aXo4SWVqL0JtMkxoaWFHMGI4c0FVSzgvdTAxdFM1anNxL2hPYmhTb1lPQmdQ?=
 =?utf-8?B?aDRjRElkK2UxdHB5djdWM2gyQnc5VFZXbFd3OEVOU3k3SmYrTUVwV2ZMSWJi?=
 =?utf-8?B?Y20xOVpNWERrNFpVYmgwV05aOHVlcFRCaHlKRDA0RHJvc0ZTU2twVVF4dnZW?=
 =?utf-8?B?NmI0OGpMVG5lQS8wUXdwR3BJbmpGSUIrU1l3MGhDUDhPOXNsZU94eDNWbjIz?=
 =?utf-8?B?RlpNaktVVytrUkVGSjloSkFRNncrTy9KNWlNbnl3SDhURk14SlpzTjRaeWRq?=
 =?utf-8?B?dy9McEY5amVpMFdUdm1PaHNIcFVyeU85SVlMUjlydnd2Tm11Mldid3dYWlZ6?=
 =?utf-8?B?cytpSTh2Y1lKYW5wMFN5bjJTeXlVbmlsSktIN0IwRVpKbnFySTBjeEdSRnpK?=
 =?utf-8?B?RkxzeUh0UFQ2blM3TWdwYkNjbjlhZXFqZVVwQ29xQmpkYXZUd3RGLzY4SkV1?=
 =?utf-8?B?SitIeUpsTmVaRDcvZGMxcG1zbzI3aXY1RUI2d01yVnFaVzZqWTVod3hrYUw0?=
 =?utf-8?B?S2NYTHRTM2Rhemh2NmhPdW1ET1dsQWRtaXV5VEcwOVNBc0h0eWpSdmNkdE9Q?=
 =?utf-8?B?cU9BaHoxVUZxaUk4M0tEUGY5YWhiUGNSMlRBSHNWU1pTdGJsN0dobVJhcml4?=
 =?utf-8?B?QVl3R1pUQ1BjeTlTNUxIMk9NYVJYMDdjVG9aYklIT3prTkpOUzNNSkpka0Rj?=
 =?utf-8?B?c0NiVExHMW0yekFqVS9zcFJmSUFUMjBBQ3IzS3pWM2dOYitiTHZzSVE0bnBh?=
 =?utf-8?B?ZmNOTUhiZ092QXEvRTczQ05EcDM1dnRZNzhCQ0Fra2IvOHE3Yy9qenA3bG5x?=
 =?utf-8?B?c1o5THJPS0V0T3NndG1haTYrVXlYUGtmbHA2QXJxaWNhYXZYMld0RE1XVUIw?=
 =?utf-8?B?MDdqVEoyUG5vSDdhYWlvTkVrTFgrM2V4K3RwK2toR09lck5Na0NzNjBBVWta?=
 =?utf-8?B?M2xTRWNJeHJ4ajNoQm9ZU2o1YkplVWZYdEFoS3ZxQ3dCc1hCdHBpeDZjUXJE?=
 =?utf-8?B?MVUrMXg1UzRKcWFPdkZncnRKeHJEeTB5MHRiSlFUTUdMaWU5RGJsbDBwaERV?=
 =?utf-8?B?THc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fd33ee-9e06-44b9-912d-08dada244e87
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 20:31:10.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hf71/CUXE6NScStoTxCURqcQaeYR+w2zMkbs41povS0A9n+PjlCXH9dRhJ7BfnYu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3361
X-Proofpoint-GUID: mz7SmBgxeGU7_U8ae2Wf043NgQWK_G4g
X-Proofpoint-ORIG-GUID: mz7SmBgxeGU7_U8ae2Wf043NgQWK_G4g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/22 7:20 AM, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 02:50:55PM +0100, Jiri Olsa wrote:
>> On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:
>>
>> SBIP
>>
>>>>>>>>>
>>>>>>>>> I'm trying to understand the severity of the issues and
>>>>>>>>> whether we need to revert that commit asap since the merge window
>>>>>>>>> is about to start.
>>>>>>>>
>>>>>>>> Jiri, Peter,
>>>>>>>>
>>>>>>>> ping.
>>>>>>>>
>>>>>>>> cc-ing Thorsten, since he's tracking it now.
>>>>>>>>
>>>>>>>> The config has CONFIG_X86_KERNEL_IBT=y.
>>>>>>>> Is it related?
>>>>>>>
>>>>>>> sorry for late reply.. I still did not find the reason,
>>>>>>> but I did not try with IBT yet, will test now
>>>>>>
>>>>>> no difference with IBT enabled, can't reproduce the issue
>>>>>>
>>>>>
>>>>> ok, scratch that.. the reproducer got stuck on wifi init :-\
>>>>>
>>>>> after I fix that I can now reproduce on my local config with
>>>>> IBT enabled or disabled.. it's something else
>>>>
>>>> I'm getting the error also when reverting the static call change,
>>>> looking for good commit, bisecting
>>>>
>>>> I'm getting fail with:
>>>>     f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
>>>>
>>>> v6.1-rc1 is ok
>>>
>>> so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
>>>
>>> attaching some more logs
>>
>> looking at the code.. how do we ensure that code running through
>> bpf_prog_run_xdp will not get dispatcher image changed while
>> it's being exetuted
>>
>> we use 'the other half' of the image when we add/remove programs,
>> but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
>>
>>
>> cpu 0:                                  cpu 1:
>>
>> bpf_prog_run_xdp
>>     ...
>>     bpf_dispatcher_xdp_func
>>        start exec image at offset 0x0
>>
>>                                          bpf_dispatcher_update
>>                                                  update image at offset 0x800
>>                                          bpf_dispatcher_update
>>                                                  update image at offset 0x0
>>
>>        still in image at offset 0x0
>>
>>
>> that might explain why I wasn't able to trigger that on
>> bare metal just in qemu
> 
> I tried patch below and it fixes the issue for me and seems
> to confirm the race above.. but not sure it's the best fix
> 
> jirka
> 
> 
> ---
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index c19719f48ce0..6a2ced102fc7 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>   	}
>   
>   	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> +	synchronize_rcu_tasks();
>   
>   	if (new)
>   		d->image_off = noff;

This might work. In arch/x86/kernel/alternative.c, we have following
code and comments. For text_poke, synchronize_rcu_tasks() might be able
to avoid concurrent execution and update.

/**
  * text_poke_copy - Copy instructions into (an unused part of) RX memory
  * @addr: address to modify
  * @opcode: source of the copy
  * @len: length to copy, could be more than 2x PAGE_SIZE
  *
  * Not safe against concurrent execution; useful for JITs to dump
  * new code blocks into unused regions of RX memory. Can be used in
  * conjunction with synchronize_rcu_tasks() to wait for existing
  * execution to quiesce after having made sure no existing functions
  * pointers are live.
  */
void *text_poke_copy(void *addr, const void *opcode, size_t len)
{
         unsigned long start = (unsigned long)addr;
         size_t patched = 0;

         if (WARN_ON_ONCE(core_kernel_text(start)))
                 return NULL;

         mutex_lock(&text_mutex);
         while (patched < len) {
                 unsigned long ptr = start + patched;
                 size_t s;

                 s = min_t(size_t, PAGE_SIZE * 2 - offset_in_page(ptr), 
len - patched);

                 __text_poke(text_poke_memcpy, (void *)ptr, opcode + 
patched, s);
                 patched += s;
         }
         mutex_unlock(&text_mutex);
         return addr;
}
