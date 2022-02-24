Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409EC4C337A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiBXRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiBXRVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:21:44 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3344A186202;
        Thu, 24 Feb 2022 09:21:14 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21O7bhVK002007;
        Thu, 24 Feb 2022 09:20:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=i/rFeztuTg31ng2oDfJ/2LVRzI1FBLMWwCSHAgTGfms=;
 b=lcKhD77yMUhoq56iy/5OYjYNbsbynxtE+BwT5hwvmkL4oboI6u24KUfLnGIlDtw2T8HV
 fgjoTpSIUoWI9qWg01HPes+XtnyQL/578vW9Gufa9A25JnkFv53/uFvBT53GfPgoyvdx
 Fjs/G4FVI6QzL6LwUWCO4/IhoCfNrwhpBwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ee5sw33tr-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Feb 2022 09:20:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 09:20:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha08sfvbRKMgFvsvDtSMT5cYYBUkTZI6t5Izk5lrrSPdJesvko8Buq9OAfz7P0RrVkffqdV3N6GQO+TEWRF5Av5Vk8EPHR6OPmuTrTfWaUxLZQ3dV+V40HmoLF5C+XzTf0VNyAHegDQ26gFkdT80Q1DxZcVFlmDPRzVdQC8O/uhkwQ6xUNDKx5f0G2VFaxn5rwniZSk4/qXp6iioJP4//v0v3hiTrlksNIGNNmwzwnag8mcJ+LLMrmYgaiLHxduMs2Gwp8FzDZqiuVkTdDS8fQCUgv0VMLN9MqluDHMQXmT07Q9LI1mxkNeiPAqbbbFJJI/fsVQtO1mGCIoUIKPcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/rFeztuTg31ng2oDfJ/2LVRzI1FBLMWwCSHAgTGfms=;
 b=Gpn5lgbwOWDy3asNdD6Fu45ntievHnMHJxQuuMU/lgCAJC6F7qYIigOVtj1JQVXoWKywUnkM5Wx6fTY46aXI6inlEVGmtIQla5cjoTq3kWFdWgZhdDjGD/CcIWE6+eFtXZc/5txymZdqguzRd2df+Sa8C+dknqenVxvu8piWVNxCObWZ2d+CXd7JKHo1PRk/TlktJz1qZXgjmfbz5aevp8Pe4P2nZ8qCN/vxHjwzfxz05atcRdSpFx5mZ5QLDGWYe9M4VrwiEcmtQ6vh1dtB4+2aXmWjeghQ3/cWy4rf9tMKCweQsFD/04SqvrLEUB4d0Rsl40w6+u1a69f7+P4d9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2952.namprd15.prod.outlook.com (2603:10b6:a03:f9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 17:20:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 17:20:44 +0000
Message-ID: <ed97e5e8-f2b8-569f-5319-36cd3d2b79b3@fb.com>
Date:   Thu, 24 Feb 2022 09:20:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Peter Hutterer <peter.hutterer@redhat.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0079.namprd17.prod.outlook.com
 (2603:10b6:300:c2::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03cf9dea-301e-4c07-2cdc-08d9f7b9fd5e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2952:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2952AE0F225BA51BEFF1FD50D33D9@BYAPR15MB2952.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouyJdODjhaNtolqUAGeV1ObrvGoSD00rkZUniDkDturLEaZY397GPUPZb3xpA3kWyxpo//pXZc1k/NqK/1qMjZOMu5dcwgzjYZUXiPZCKB9ztbEwC07VtT6cBFmMwIz7ediXkF9SeAKxoXEWuqKYFqLiId0owmJ0zDksUkiEVcDDlYXbMghEWcZ47mDz30x4C+xfcWZDUJlNyZojY9OjK8yoyAMr3uC3FctZ+l1eTrkah1pu7qPy2sREaWxgMqmcuztEdFaLX31lzDhaK3/Iq7jePq8s1FUQNEBUtu6LhJLa8XkfR3sLdFsbGaXrbVi6LTOeQSbaDOs2LmufnN6Jg0mTGSoRK7MWXfZRCQwu9IEAOzYM+lZBkV34QYhJjmbTAuPwMnxkWo2PhSLmU+8S1VS7nnq8sxICxuqzTX65xcnRy8uU2+O38MKXbN8jrv5OOHH+IgA5VbvWSFunQ/gHslovd6zTDa9Xx5f5qcme5RTbE+cOylKw6C06vpE3azPVNZg+ZIr+bYr7RzCF8uOe60/dY5vahCSyoGJ8W5GU4tfAgScQJ8XmE9DMZPnwUatN2GPbIYtDLuhRI7FMDYUbWy1ddJaN6LawRETO86u/NSE26XyTfJqBHTq6D2bJ4OfShDNs4fKKyLaWd9H9G4Z9QiYhHHnCUmHveuSpN5/2uWBdmwMb82G6a+RDvE3KplndxgIX7hCkR9sf/7iSNe9hElKUtzjb4LrlRA7JxvWQabA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(31696002)(86362001)(6486002)(54906003)(110136005)(38100700002)(508600001)(36756003)(4326008)(316002)(66556008)(66476007)(8676002)(66946007)(5660300002)(8936002)(7416002)(31686004)(186003)(2616005)(52116002)(53546011)(6666004)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHVpZ1NSVTJsMnRJb0pRbG1rWnpzRlNGT25weFdJWXlrQTRHRlZpYlZ0b1pJ?=
 =?utf-8?B?N0ZOQjJnb0ZmTVFzOU5pRENydjhZYisxTmtVdVhDZEZzM3RvY0dEK2NuQklr?=
 =?utf-8?B?cVVEREh5UVZuNmw4QWZjQUNGeTVRWEVKallYVjZVOS9kMk9HUDNweHkwNDUw?=
 =?utf-8?B?aE15OHNXNFFEbW1KYWZZdkltWkZtZWVJODlGQW1rY2xUZHdGbkZTbVRmM3lt?=
 =?utf-8?B?N1FxcWo1RG9XandDdklhdW9PUldnRjZUR3ExVThQeVFlbE4wNCs3c2RlMndr?=
 =?utf-8?B?S2pMbjFQcStUSG9Gby9vL1dtZHZ4bjZxT2tSekV2bWt5YWNlR3ZHT0VPdEpl?=
 =?utf-8?B?QlVYOVBIMGl2KzNJVnhtcE1NUjMxUHNYVm8xb2Jwck5uK3VYOWc0QitSdWJF?=
 =?utf-8?B?TzdNYXlGeDlKcHF6dzFNelRLaC94VWNOM1RIeDhRMTlzeEtjK2RqU1J1dWxJ?=
 =?utf-8?B?czZLVDc1RFU1dmVKYVRnNmFZSmd2Q3N4S1NGTDl5WWJQdUJ0d1lwbXpNMHox?=
 =?utf-8?B?UU5EWnBJTmxSamZXbXRzd0dFa0tGMWh0UGJiRVA2VW53R0J0b2V1K1ZtNHlG?=
 =?utf-8?B?dHhrUTQrMjhmNG5TMHRhRXpuUzlnUWZMdFJmY2UwOEE2WVBzcllNSCt6Qitt?=
 =?utf-8?B?U0U4KzNVRFJiZW1TRlluMlM0a3grcjZISVAwU244cC96THk0eWg4ekxyQW5o?=
 =?utf-8?B?bUJIYkpXYldGNGZXSlRxYVhWaWZhQzFidEQyWXdjbGF1T1A5cFRReWd2WnlZ?=
 =?utf-8?B?NEgrd1RpZVBRWUtUbktOWGY1NFVJeFNTbHRlb2VKa0x1Rjd5VDY0bU9aSkE4?=
 =?utf-8?B?cHpIOEhVMzdGZ0dxdHhNQ0drMTZ2NjFZWFkwcy9MUzJQYTRoS2lsWVBRNk8v?=
 =?utf-8?B?OTZIdWNXcHhUbmh1SEhDZ3hoUTNpdXBIYktobGtNUnR5dUQ3eUVJN2QxUGFS?=
 =?utf-8?B?QkRvWnhGTzcxcDk3MmNDWjZMaTNUcC9tbGQ2WTJTNkJ1cjljaXFOL0kwMUxy?=
 =?utf-8?B?c1R0QjJpTFRPclgyd2duaDU1UWpWNE5OK1F1Tjd5ZmxNZ0VHckpDMjZaZ1dH?=
 =?utf-8?B?K2NXL21UNzZiYmFvTlhmTTA3OHcwWjJLaWhSRmtYcUpBUFMzK0M4bVhMcE1Q?=
 =?utf-8?B?UTJJdkhiWm05RFpTTlU5QnJiVFJYckFuTXZ3ZXlVVnh2UngwcjNoWEViR3lq?=
 =?utf-8?B?aUJIcGVXL0tldncvUHcxak1TYktxUGpxQ0hyL245UmNMT2wwTzcrN2c0OEtV?=
 =?utf-8?B?dFpDL29VbVRPaU5VaGlKM1J5OGtpZm9HbTVDcXFzMktsVUJtbzNjbGdaQ1gx?=
 =?utf-8?B?SXVkS2JOb092Uys2VGNuYjYrK2xRRzlYeGJ5aitOKzJ1L0xtVGRwS1hVeXMx?=
 =?utf-8?B?VVFGK3RpdVZ5c01BdEZpdnF6TVFyUDJBZXhRdGI2d2o0OWR1SzBRMm83cElr?=
 =?utf-8?B?TytVVFJlQjAyRW9tMk1ZeHVoVllpVXdjZFUrbTRtZWRWKzd5dlkvNWZqTlVJ?=
 =?utf-8?B?bEVEM0tvaFJpL3h3bnUxWXkyV2xNc1llN3Z6NzV6U1pKc09kR2JDY21NdXJZ?=
 =?utf-8?B?Smpuc1E4OWNKS3kzY0xlWENub0YzbGNWTElzOVJnRWdGMUJ5bVhKb2hDWTZG?=
 =?utf-8?B?TEVLU3FvUHpucWswMmRpcU5QTndrbml0S0wxNi83Q3dzbythMldwK0dtVnNw?=
 =?utf-8?B?VGhURXl2MVdHVXZYa0hHYUl1dHJDVi94V0QwWUpCN0ZsY3M2L2p5ZUhEOG5L?=
 =?utf-8?B?Q2RQa2ZNUytwSnpxYXE5MVpnSDhSeXNpOTJVUlZLakxlLyswM3g3YTBybXdG?=
 =?utf-8?B?L2RLY0tPcWRMOCtBN2hqaGdncnVxZWtNVFVyb2FkTzJodkQ5SVFjQUgvNGdO?=
 =?utf-8?B?L0lwNnptbitrMGRqQTFKajN3RnErdFhrZS81Z1AzYkUzQm5lczZ4TFlTMGc2?=
 =?utf-8?B?OUJKcFNrYmpXeFJrN2drMFRqRTgrZ1ppZm40YUptRjVkMFoyU0ZGaGRFRHBy?=
 =?utf-8?B?Uk02aWZPdFY1dldNT2ZybTZLUkVjUnJ5OHhHcjZFTEdHV25QNjNZc1JtRGhP?=
 =?utf-8?B?eGJ5d3liRFZpVkQzZ0tDcDhsM0xNbjNpRnVMekJxK3Nvekk2RlVZMWpaN3RB?=
 =?utf-8?Q?77cdNnNZDOjE4GB0uA76V0k1u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cf9dea-301e-4c07-2cdc-08d9f7b9fd5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 17:20:44.3641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnUYuVbTBAk0KAbcTiKJd4cTw972dI1gSebOVdVd6kJZaNvg9BnxsfUAPwZMzYn6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2952
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: S6B-pxxpnDYHA0m9bOsQHck6O7Nkbp-0
X-Proofpoint-ORIG-GUID: S6B-pxxpnDYHA0m9bOsQHck6O7Nkbp-0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240098
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/22 5:49 AM, Benjamin Tissoires wrote:
> Hi Greg,
> 
> Thanks for the quick answer :)
> 
> On Thu, Feb 24, 2022 at 12:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
>>> Hi there,
>>>
>>> This series introduces support of eBPF for HID devices.
>>>
>>> I have several use cases where eBPF could be interesting for those
>>> input devices:
>>>
>>> - simple fixup of report descriptor:
>>>
>>> In the HID tree, we have half of the drivers that are "simple" and
>>> that just fix one key or one byte in the report descriptor.
>>> Currently, for users of such devices, the process of fixing them
>>> is long and painful.
>>> With eBPF, we could externalize those fixups in one external repo,
>>> ship various CoRe bpf programs and have those programs loaded at boot
>>> time without having to install a new kernel (and wait 6 months for the
>>> fix to land in the distro kernel)
>>
>> Why would a distro update such an external repo faster than they update
>> the kernel?  Many sane distros update their kernel faster than other
>> packages already, how about fixing your distro?  :)
> 
> Heh, I'm going to try to dodge the incoming rhel bullet :)
> 
> It's true that thanks to the work of the stable folks we don't have to
> wait 6 months for a fix to come in. However, I think having a single
> file to drop in a directory would be easier for development/testing
> (and distribution of that file between developers/testers) than
> requiring people to recompile their kernel.
> 
> Brain fart: is there any chance we could keep the validated bpf
> programs in the kernel tree?

Yes, see kernel/bpf/preload/iterators/iterators.bpf.c.

> 
>>
>> I'm all for the idea of using ebpf for HID devices, but now we have to
>> keep track of multiple packages to be in sync here.  Is this making
>> things harder overall?
> 
> Probably, and this is also maybe opening a can of worms. Vendors will
> be able to say "use that bpf program for my HID device because the
> firmware is bogus".
> 
> OTOH, as far as I understand, you can not load a BPF program in the
> kernel that uses GPL-declared functions if your BPF program is not
> GPL. Which means that if firmware vendors want to distribute blobs
> through BPF, either it's GPL and they have to provide the sources, or
> it's not happening.
> 
> I am not entirely clear on which plan I want to have for userspace.
> I'd like to have libinput on board, but right now, Peter's stance is
> "not in my garden" (and he has good reasons for it).
> So my initial plan is to cook and hold the bpf programs in hid-tools,
> which is the repo I am using for the regression tests on HID.
> 
> I plan on building a systemd intrinsic that would detect the HID
> VID/PID and then load the various BPF programs associated with the
> small fixes.
> Note that everything can not be fixed through eBPF, simply because at
> boot we don't always have the root partition mounted.
[...]
