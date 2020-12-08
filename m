Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775352D21A6
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgLHD5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:57:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15262 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727193AbgLHD5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:57:37 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B83nZK7032069;
        Mon, 7 Dec 2020 19:56:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bFVrwVYt01ikTRIv2+43Ek+oykEKJbr5dI7Vn1Urxrs=;
 b=hqDrasDxVmn8h+xKBOws9JFVcHyyKTZ6JABXmKXCC1ZWEPhete3OTX36QAOtL2xW/idF
 ZbFVS7yNRm+LWWSKekPXSs/ekMYGKwPdCLUD8EhBKv8t74fpAag1HxL4kGYW2Y8t29HK
 VaXyDmEXWel3/ttquWkYUeAiLWG3wb3WkN4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 358ud9kmnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 19:56:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 19:56:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0cmYl08jjzLkZhVggWZT4rptU9NfzaLwtV5ydvipBMnXbf4ljIqgc7hk4NZzzWGjON6X/uLgjTEgnon6HahbSz5nFeHZit8YEcKbDdXoMit+JvD1c24MXHCjI0/XGw1srbAoPU2x3xE/BXZ/ojfWqopgC1stRxcFIdmVSaezeWv8AaGe0rP5ETfMXYERydNW8wIlFxGe9MiAKg7JK9rvRhUJmLsePoEu18eInWWiMD3BJLB15MM3E+rj9/kdbk7eKOKv/WPsT20Q6vgapGSTTF2zWSZXwBb9PJPCJDoLZhAwVZS70T51aIM6zbEgaKwPQNPdpA+jR5Tb/d0m9AoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFVrwVYt01ikTRIv2+43Ek+oykEKJbr5dI7Vn1Urxrs=;
 b=foal8rzVP+t0TysaIKp5B3XIElhN8N+nEJQprBLuN9K56vQmwHALg0L8XUMc5KGJNP1ILdzocRRAEqLaU85ASmb8heCIPIP2qRjGMrm/mdnqnHacx6HNFAqXPzxYrA610Gqap8jJGbJ2nT2LizFiMgj8TdPgwyY36eA3Y4ss2oY2grunHhc13vfGRO3K7tDiZgfZe7hQYtElgm0LgJ51F/eeskhki0dUmXzZgtkZWFb5k/BBRzeRSMWh5jzsPI7ytjJSF7wV8AhiWdDY1hAEWKqq07NObYGpqD3UP9H8m+GaXbv1jAO77bVIuUbXUKdZjZvnU7eOdE0yCYnNyxRqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFVrwVYt01ikTRIv2+43Ek+oykEKJbr5dI7Vn1Urxrs=;
 b=SetymF9DLk50HiQE6vXMkejIxRZVJhfyOxO6DcTkM0+7ZANspgJRZAaJJPa8xo9UXUpbGrtRxBlLp3jJMsd8h9R3sq6WRyhc5tyC01qID0S9bcNDg0zaAuF5rjTFi9wC5Yt/FShQ5cem6wxTA3r8AAZEtDyG01MxYT91LFqrCyA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2776.namprd15.prod.outlook.com (2603:10b6:a03:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Tue, 8 Dec
 2020 03:56:34 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 03:56:34 +0000
Subject: Re: [PATCH bpf-next v4 0/5] selftests/bpf: xsk selftests
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <956522ac-5a57-3755-ede5-6d33169ce6e1@fb.com>
Date:   Mon, 7 Dec 2020 19:56:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4c73]
X-ClientProxiedBy: CO1PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:101:1f::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:4c73) by CO1PR15CA0048.namprd15.prod.outlook.com (2603:10b6:101:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 03:56:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c4970f-d2d0-4cc3-fcde-08d89b2d4197
X-MS-TrafficTypeDiagnostic: BYAPR15MB2776:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2776BE10EC1A0A45C2CF5D6DD3CD0@BYAPR15MB2776.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44W6+8FhNib8qtR5Hs/kzy01PZiAr6Fkl2pW2jJkcTqxXjxLLwREVpD27B8rKTFOQ2eM0L+CrojahOSdFzCpnL50AjgqDFMB/iPFeEtMFUskUyuvVbfBbCtinz4ZfnTljaPB8MSUKGpUqgtt/Ro2wcD1fSCKQU7DrhfT4DEKPyTVwb9zDTCSYHxTnFcUdTgm4rwchbRQQt3xtqD7HHyYP7itGqXtteSHhM+zob0eqMtbKi75+kmjuHzO2jM1OepwTwWnjEOwM6ajkQmzzcN+LGLHtKZuipNEsAp3BPV9cW9dT7PnK2B/ZniHF26iRd+V5Xfkf2QIy7YwPBGVgu4GJ/xorCPSS23gcgT30NjvbSIbijs3VRh4zIbGLI3esdI3pjZ8S4zCbq2AdEJmP5tHRCTa202orn5XhHT91OI28A4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(366004)(376002)(2616005)(6486002)(7416002)(66476007)(83380400001)(36756003)(186003)(16526019)(2906002)(66946007)(31686004)(4326008)(86362001)(8676002)(31696002)(5660300002)(52116002)(8936002)(66556008)(316002)(53546011)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M0RPTHRCbVJiVjIrZG5aS0VRbXpnb0J2THVnbjZMQ0xxYVYxSGhTbTd5Nnlu?=
 =?utf-8?B?Y29FS2hwMlBqYjJ3OU02MUN6OFBnNzM0anRsYjlEekFrQXZIcEVrSGJGdmZn?=
 =?utf-8?B?S1dySzlZWS81MUJkOTVoZVRjam5QV01kMUNxelZVSHV4U2lJVWhuQmNOWFBC?=
 =?utf-8?B?eURXbHBraGxLWUNrM3lvOEx2RFJRemdUTFpPUVVhSUlIWlBSWmt4a1o5QWZl?=
 =?utf-8?B?cUdJbnA1a2ZxQ3JSWUVDMFNJb2gzeGJjTmpKSXBtdVd1L0JINkVjZWZaL1BN?=
 =?utf-8?B?cmJUT0JYdlUvdGVQWWlFNVJvMERSY1FMeWZjWmRvc2NocnJOczM3MENUWVFk?=
 =?utf-8?B?TUFydXR0bDQ3a09IMW44eUJ6TUdBNXBSTDg1SkJnTmtlOFZxSlRtS0hjb0hw?=
 =?utf-8?B?MjZpOGcwemZ6NDZ1eDgzTnVrNTB0N0FYL3JQLzkwcE1LOUUvbldMek5mcEsy?=
 =?utf-8?B?L3RNb0k5RTNHVkhNbTdNL0dMLzlrVnFKQzZrTDNTN3dZbXJqTndsc0hZUUZD?=
 =?utf-8?B?T3RBdkVYd3ROSThaemlWT29ielNja3dQVjhGZDUxM3JlRlVFR1V1Nk5CS01m?=
 =?utf-8?B?REtVUjlJNENoZ2pTektZWDA5SmVRMHdHaGxzN0w3bDRmZldtL0Ewd2d0bFp5?=
 =?utf-8?B?aFBKbkYzMTBjZEZzcjlMb1R0cXdadlFSemlaK25RTitYTm1KRnFtdDZzL0ZP?=
 =?utf-8?B?T0EzQmNsUm1MYlltUEFhRkJYYzl4ZzBrSTA1ZmNrdDVObHUyY3JLdHZxWThP?=
 =?utf-8?B?L0EvTkt1TWYzVEFuOVJXaGlKcCtYcSs3eUo2ZHU1WktSbnQ0S05MYjY5c0xn?=
 =?utf-8?B?V3dDYVBPNTFkNEdWVXBUV2lnb0RYT0xqc3dyRk1QQk10L2RtTWlLZktuK2ZD?=
 =?utf-8?B?RkZXUk9URVR6VzZHbnA2amFJSlNFWFU3RXFOd0VnS3dQaittdnQzTG9sTWhi?=
 =?utf-8?B?Tzh3ZWFJT0c4MVZjVXJBbDA3YmhlRFZULzY3TTArMTY3S1hBbUNlS2RrY0t6?=
 =?utf-8?B?emdLUXZxWXVNVC8xOXpBM0xJOFhJbkVpUm53eGVDUFNxL2dxVkxVcmNUUE5l?=
 =?utf-8?B?QjFzbFJmUDRwdXkwd0tPRkcyR0wrakxSQmQxSjVKMCtoQ1l1Vk45ejFLS0dv?=
 =?utf-8?B?MWlGd3pqakxnVlRwVGsra1haNWVPNEJCK1R3d0xPUC94MGEzcFVOODBDbStJ?=
 =?utf-8?B?SDVCWllWWWxmR1pXM0dHdzdMckhLYTRQeUNzMGRXTlNlelFXNEVYWFdGRm1t?=
 =?utf-8?B?QklZeEU2eUdUZ3JaR1VZOE11eFZUbkN2THpIZFIwd0FrUkZWOGo2ZEJheHcx?=
 =?utf-8?B?RFFQRGp6MmJTSlZhd2IvWVhYVExZNnVNNEs0ZjRCY3UxNjE3TnBpTGVVZHNZ?=
 =?utf-8?B?ZHRFSlJqaStUK3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 03:56:34.7969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c4970f-d2d0-4cc3-fcde-08d89b2d4197
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1Z2ZPtyu8Gg/D8ThXdxltsR4fdaq8SM94doXdi1AonF4kglpk6tVabeq+fZ6H8b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_19:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012080021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/20 1:53 PM, Weqaar Janjua wrote:
> This patch set adds AF_XDP selftests based on veth to selftests/bpf.
> 
> # Topology:
> # ---------
> #                 -----------
> #               _ | Process | _
> #              /  -----------  \
> #             /        |        \
> #            /         |         \
> #      -----------     |     -----------
> #      | Thread1 |     |     | Thread2 |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     -----------
> #      |  xskX   |     |     |  xskY   |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     ----------
> #      |  vethX  | --------- |  vethY |
> #      -----------   peer    ----------
> #           |          |          |
> #      namespaceX      |     namespaceY
> 
> These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
> Ethernet interfaces.
> 
> The test program contains two threads, each thread is single socket with
> a unique UMEM. It validates in-order packet delivery and packet content
> by sending packets to each other.
> 
> Prerequisites setup by script test_xsk.sh:
> 
>     Set up veth interfaces as per the topology shown ^^:
>     * setup two veth interfaces and one namespace
>     ** veth<xxxx> in root namespace
>     ** veth<yyyy> in af_xdp<xxxx> namespace
>     ** namespace af_xdp<xxxx>
>     * create a spec file veth.spec that includes this run-time configuration
>     *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
>         conflict with any existing interface
>     
>     Adds xsk framework test to validate veth xdp DRV and SKB modes.
> 
> The following tests are provided:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
>     c. Socket Teardown
>        Create a Tx and a Rx socket, Tx from one socket, Rx on another.
>        Destroy both sockets, then repeat multiple times. Only nopoll mode
> 	  is used
>     d. Bi-directional Sockets
>        Configure sockets as bi-directional tx/rx sockets, sets up fill
> 	  and completion rings on each socket, tx/rx in both directions.
> 	  Only nopoll mode is used
> 
> 2. AF_XDP DRV/Native mode
>     Works on any netdevice with XDP_REDIRECT support, driver dependent.
>     Processes packets before SKB allocation. Provides better performance
>     than SKB. Driver hook available just after DMA of buffer descriptor.
>     a. nopoll
>     b. poll
>     c. Socket Teardown
>     d. Bi-directional Sockets
>     * Only copy mode is supported because veth does not currently support
>       zero-copy mode
> 
> Total tests: 8
> 
> Flow:
> * Single process spawns two threads: Tx and Rx
> * Each of these two threads attach to a veth interface within their
>    assigned namespaces
> * Each thread creates one AF_XDP socket connected to a unique umem
>    for each veth interface
> * Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
> * Rx thread verifies if all 10k packets were received and delivered
>    in-order, and have the right content
> 
> v2 changes:
> * Move selftests/xsk to selftests/bpf
> * Remove Makefiles under selftests/xsk, and utilize selftests/bpf/Makefile
> 
> v3 changes:
> * merge all test scripts test_xsk_*.sh into test_xsk.sh
> 
> v4 changes:
> * merge xsk_env.sh into xsk_prereqs.sh
> * test_xsk.sh add cliarg -c for color-coded output
> * test_xsk.sh PREREQUISITES disables IPv6 on veth interfaces
> * test_xsk.sh PREREQUISITES adds xsk framework test
> * test_xsk.sh is independently executable
> * xdpxceiver.c Tx/Rx validates only IPv4 packets with TOS 0x9, ignores
>    others
> 
> Structure of the patch set:
> 
> Patch 1: Adds XSK selftests framework and test under selftests/bpf
> Patch 2: Adds tests: SKB poll and nopoll mode, and mac-ip-udp debug
> Patch 3: Adds tests: DRV poll and nopoll mode
> Patch 4: Adds tests: SKB and DRV Socket Teardown
> Patch 5: Adds tests: SKB and DRV Bi-directional Sockets
> 
> Thanks: Weqaar
> 
> Weqaar Janjua (5):
>    selftests/bpf: xsk selftests framework
>    selftests/bpf: xsk selftests - SKB POLL, NOPOLL
>    selftests/bpf: xsk selftests - DRV POLL, NOPOLL
>    selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
>    selftests/bpf: xsk selftests - Bi-directional Sockets - SKB, DRV
> 
>   tools/testing/selftests/bpf/Makefile       |    7 +-
>   tools/testing/selftests/bpf/test_xsk.sh    |  259 +++++
>   tools/testing/selftests/bpf/xdpxceiver.c   | 1074 ++++++++++++++++++++
>   tools/testing/selftests/bpf/xdpxceiver.h   |  160 +++
>   tools/testing/selftests/bpf/xsk_prereqs.sh |  135 +++
>   5 files changed, 1633 insertions(+), 2 deletions(-)
>   create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
>   create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

All tests passed in my environment.
Tested-by: Yonghong Song <yhs@fb.com>

