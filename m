Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8334AE36
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhCZSDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:03:30 -0400
Received: from mail-bn7nam10on2108.outbound.protection.outlook.com ([40.107.92.108]:15457
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230258AbhCZSDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:03:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfS3g68yU8qQxdXy6drsVeFIm4+227uqKzOND4nG6SKKRsnKjwaW86WXgRbWUvDRNWgZ6hEFulFas29cjwqpWTAKAJ94lACIZ8MAJ7Em2r8YgQopwcKDgSnMpYanSsmSsXs/8VVrNFyK305iMl8Z06A537p5M9ZYKOIutLn/ZwvEdiCeN+kdgCnbs5MoPdkEIKdE3bXmhJzKV1m/ObiOknIL+sSmwUyYArWXjiZVMQUEP/jFefH8YeK/gxXEqjXT4rINylD0ERK2GHptYRH5Js8KvL55xCBGK+5TEfhETKaJZzmAmYBZUiUrFaSIWzQFW+H3WDpVV2OgZGD1zG+Z1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MBVTSdzWHBooxCBwRb5adpzmtQXlIZFUJuM359CivA=;
 b=IcTfr/08IpnsmsmI7Yryjktnw2uoGHWf8FgNFeWZyrXGQKNL9QiZjrYmYm1jB1U8HRJLdDX8eZNkqRVKornQFchPfet9tlXbCBxqwQA94IIvYzg34gi2del5Uws/2zAcqtKuFw3OZp7hayRlCgE59U+m56TYlxRKTddzk40JvucbbEQEp8M4Xn950slU3v6SCl7FQV/x9YkslBSG+JTuJmWFnqjgy73Lpk0yz7mJa63WLZwt9K2+4Nr5LVAtBcddyCZErSnCjQCQLglmOUmGTtyoqnYjcnBvmkOW966aiNHPUyd7dh+l+jvGcNL52ov4qPm0GAMUnphGf/4SNJHZGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MBVTSdzWHBooxCBwRb5adpzmtQXlIZFUJuM359CivA=;
 b=Jg3AYbmRed3A0BAMDIoBO54jY0R43skTE8YkFbKscfxPmDXSTuJTMQexrZ7/DUc43mS3cvf+Gn6WOc/yr6eulttxHzMlZq0NL+4qSOo+eYKoD+GTjJ417uIir/QEerjEx2KMssdxF6TE7o5yArydv7xIN7iDemmcovI9Tpb26uQ=
Authentication-Results: netronome.com; dkim=none (message not signed)
 header.d=none;netronome.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB4130.namprd13.prod.outlook.com (2603:10b6:5:2a5::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.15; Fri, 26 Mar 2021 18:03:20 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9%4]) with mapi id 15.20.3999.015; Fri, 26 Mar 2021
 18:03:20 +0000
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     wenxu <wenxu@ucloud.cn>, Ilya Maximets <i.maximets@ovn.org>,
        "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
 <YEvlysueK+eiMc1b@horizon.localdomain>
 <58820355-7337-d51b-32dd-be944600832d@corigine.com>
 <fc269566-9652-ed80-cea4-016c069fa104@ucloud.cn>
 <c32bac8a-8127-1bf1-3b3e-13afdfbe7379@corigine.com>
 <YF4SnCaDTfKcVImr@horizon.localdomain>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <e8b98109-7cea-8f85-c54c-11ce78aa4bc1@corigine.com>
Date:   Fri, 26 Mar 2021 20:03:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YF4SnCaDTfKcVImr@horizon.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [102.65.192.244]
X-ClientProxiedBy: LO2P265CA0272.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::20) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.107] (102.65.192.244) by LO2P265CA0272.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Fri, 26 Mar 2021 18:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adb0fde3-ecb9-453e-2953-08d8f0817053
X-MS-TrafficTypeDiagnostic: DM6PR13MB4130:
X-LD-Processed: fe128f2c-073b-4c20-818e-7246a585940c,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB4130409C1168AC0BF917254E88619@DM6PR13MB4130.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koUeWLdfjosWU3LvW6GFn8byKA9jqAHtXKjFofsPQ0yuTixpEE4mYWRDH2ENMa90oP0ncEunOoY73mOAs//t3v3vLjdtvAp/rB4JQsSKgrLbx84s7Bo4g8j8sLQfur9aUpj395lsUgbAm8f5qgYUfNqRCRts9uV7eINykRcXX1qJ5YQildTnPiQdNilNNHEfpqJsxG3AHQD07HCS1Keuu2iLCs/iHB/Ni0pYEwIAZCimnCKq7eixPU41OqW1Y+LQjdgx9eDPBDRQp/wU5VHfd6ujWNKg0pRuvUaECvazbPw0C9WSSd3qvJ9DJGRF0Btoanxtui306SUWuG5QyMYMt5pFopmLM7aDJBUJNlJdzSTkHp3qPfJH1O34R+CU+OGtlTqXP1nE1jCqayZUzx0jN4JVtqZrXda6E99VQkvVZF6YQtnYvqYMOarcejtn8dj1ndYMNs7oyXk/lLzykvOgg/ACwXqiN0zhst1fMfQPQ9C0v3EgQX7337FMTZI5GuATqTk5QEZEWGC34EjJMfS9ou9apDqgZ3yQr51L+1nbN5ow71O4rCdS+k2V6+r9TbqB1L2RtHqaqYR0s6GypETvGY3dVAjui/9EINYF7j3PBUr7D/JrFX4GFB78SoZ2819tBU7WTHfmPsNE+KQLnlZ0NEwkgi12JaI+daOMZUnDjmDSo+/2WXzCICa5hviSz0LpkSboxX0PKxHlGK8XO/F7Cuj+MtBFEfD67KZqdoo9eI4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39830400003)(396003)(346002)(6666004)(2906002)(16526019)(83380400001)(52116002)(2616005)(38100700001)(186003)(6916009)(44832011)(53546011)(956004)(478600001)(6486002)(36756003)(316002)(26005)(54906003)(4326008)(16576012)(8676002)(86362001)(31696002)(66946007)(5660300002)(66556008)(66476007)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTZxOFh0UlEzdzFkcjlqUzljbDNlYjN6emRuVEJIMjc3MUdsVmJJMDJhM2dH?=
 =?utf-8?B?d0RlaGtGK3dXRGpHVGtIcm9UeGgrbmJGYS9TZXJtSm5hZVZadXBjQjNqcFlS?=
 =?utf-8?B?eXc5SndLeGpkWFdPTWViM2dwU00wRi9EbTM4K3Q2QkUzS29kNkJmT1VSUndU?=
 =?utf-8?B?Q1FFN2NCa2tTc0p3WjFVM2pMYXdLMnlaTTkxMjhBZTcwSUZUck1FVjRrNTVI?=
 =?utf-8?B?ZVIySlhOSFJDeXZhVGJBVlhWd2F1bWRsN3lFb3k1c0E4ckx3WXpscjA1NGxr?=
 =?utf-8?B?UmZqNEtycnFicDZFVHZoRGJvZGF4OUE3dnVzV1ZyRHdvdEtEVjJXcEQyMGEx?=
 =?utf-8?B?VU1vV2czZnNva3BPQ1E4Z0FEMmpjYUp6OElrZDBrVytDQk8yQ1l5R2FYV3pt?=
 =?utf-8?B?NGduMDBZMDIvYVNYMlZVMDR0MUQ4V1RIWkx0R2RxOTluUVVoY0R0L1lvN1NJ?=
 =?utf-8?B?dXVLWkNtazgzdTVJMlNValN4MjdvaU13VG1kcVFiYjhFNGE3K045WTkwK3Jy?=
 =?utf-8?B?TWxSaUVmZ3A2Z3lIUkNha05ncDZ0NDNvZDRacWRTN1BJTzFsNHFhbFBmQ2tT?=
 =?utf-8?B?QlpUMXV1aWVKYkRBMXNtRlhJZWF2Qjl5MnlkakRMR0R6N1djOGVaQkxzaGll?=
 =?utf-8?B?U1g4RG9aVXdMNHlJeWpCM3ljVzRnK29uTzQ1c0RPYXp0ZE1FYkJRSlFnRS9Q?=
 =?utf-8?B?SW1UQUNUbVd1RjVldmxLWWtwdGd0dk91M21jMm5qNzQ1dzdIMTVtS1c4cld3?=
 =?utf-8?B?b1Z3SGZOS0daOGczRUNsb1pwam1YNjRLVThlaHh6ZFdRMzhmaDJmZ2RYSHNj?=
 =?utf-8?B?dk1rTDVpTW9IczVROGNBbExtVHlGSGYwTllOQ0YzS04wUVNKTGtCUFYwdnVW?=
 =?utf-8?B?NTJiMTJCUVEzOG44SnkrcC8zZzhrRTQ3YlA5bGtiU1B6ODBENzVOUlJLMy8y?=
 =?utf-8?B?OThrWmFkbmZmd085bGo3aWVhcHdwT0ZNN25SR0N2TTdqSnBQdzdaQ1I0UmY3?=
 =?utf-8?B?a09Za0RsY1psOVIzRFp1aEt4QlM0dVNHZnNKTm0wOXR1NmRlMHhFL0FmTGVz?=
 =?utf-8?B?QlJMVU1VU3dmeHYzV1NURDU1eUovTHVZdXpSdTNEQllPMjQ5Q0JESzlNRzFD?=
 =?utf-8?B?VEVEZUJteTdMUkZ3aEdFTHBtb0xBTHpTdDhsSmxwWnU3UDBKVklXS3RKMDhR?=
 =?utf-8?B?S29JTFBrZE9CRys0R0lqVlgxSmdRcnlFc2J4VmVBYU5kS2xjQzhIOUw1VENC?=
 =?utf-8?B?UmNXMmorNW1ONWtwT3NJTG9kNDBVMkxQajBXbHlxRTFoWXdXN0ZuVkxWNktT?=
 =?utf-8?B?RkEzOUVpS1RueTl1SVRXaXN0ZWdBbFdJeldxOVRDRGRDRm5ySDdXcXdJb09h?=
 =?utf-8?B?M1B1T0dCMFozVEo2V3NRbkl6bVgwK1pOc2NDN3kxMlQySFFGdlZIZnAwc2NU?=
 =?utf-8?B?YVF3YStOQWgrS0E4dTExMHFUY1NmdWVRai9ZTVNWQVFyZDlmQktpdjZDNmN2?=
 =?utf-8?B?dXBoUGJ6UWFNbHRBUjl4WGhqN1BMbkE3RFRBbXZIQWRxK3g0azMwRGpPdzUz?=
 =?utf-8?B?UmM1Z1dQNGxpajdRc3pGRG1oUFZBSWFiZ3RMZVdHYWluY2gyUkhPbnY1aHIw?=
 =?utf-8?B?RnVrM2VYTnhGdDQ5V20xdjFsMWQ1SjI2U1lzbzMrNVpFbWNHUDArYnZJaTZB?=
 =?utf-8?B?bU1pT1dVYzBHTjY1Y0ZWdGdVY1o3RklSb3dzUDhncjZjYk5MUk1sbCttV244?=
 =?utf-8?Q?lGsJInvFyLpTmH9TixxgGeOE8NlGfQ7RFgnx3IL?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb0fde3-ecb9-453e-2953-08d8f0817053
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 18:03:20.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iyvx1yWuClgiLsV57KCIan/YYkmDCWCdS3b+V/NdQh6klbJz5CXPkOEO8SzhrEWx9ZScgyXpDSvJXRNfGwDAqNJRe5IVpxaIaDycfLaBfts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/03/26 18:58, Marcelo Leitner wrote:
> On Tue, Mar 16, 2021 at 05:12:22PM +0200, Louis Peens wrote:
>> So in the end I think there are two problems - the on you identified with only checking
>> the mask in commit 1bcc51ac0731. And then the second bigger one is that the behaviour
>> differs depending on whether the recirc upcall is after the a rule installed in tc
>> or a rule installed in ovs, as Marcelo mentioned.
> 
> Hi Louis,
> 
> Not sure if you noticed but both fixes landed in upstream kernel
> already.
> That's basically:
> afa536d8405a ("net/sched: cls_flower: fix only mask bit check in the
> validate_ct_state")
> d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after
> do conntrack in act_ct")
> 
> If testing again, it's probably better if you use the latest one.
Hi Marcelo

Thanks for the ping, I saw the mask fix, but I did indeed miss the
post_ct fix. Looking at the change it looks like it would address
the issue that we saw. Will test it out and report back in case
something is still wrong, but hopefully this is the end of the
chain. Thanks for the help everyone.

Regards
Louis

> 
> Thanks,
> Marcelo
> 
