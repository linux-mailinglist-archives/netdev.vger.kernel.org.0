Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4E01E8B6F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgE2WjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:39:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgE2WjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 18:39:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04TMYGV8024357;
        Fri, 29 May 2020 15:38:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jIx2HTn+81Z/iOfTuSe1BYbXqixA6WD31Hw3sFQND0M=;
 b=U5fyZy7ywuO7xoCDwPcx91j047c4ytekPNVdGRk8DMFDibiGy7QYojXDccoqfnZWj/Np
 FjnWIovRMDasGxLS0wEKot0QuRBFmFKkRqyRwsLcBunydn6YKSfHXjSFYNpYvWhE1OQE
 CTUq+FRPCMA8++2IYIzB2PVQbrRCFvmnLc0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31anrw3nvb-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 29 May 2020 15:38:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 15:38:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb2BP4V3nn/x3KaqUgjSzi5kcFI5FZP44rWe/gL1qoc+vtLOagKXo1nf3zHW1Gc2Y+2Bt6C+++g7A67mPojKuy8lbfGavIunbQcIpvNAUMRv54L6bHqpbssryrCFIkIW/0wazkXtt3pbrXt0ZxCu5IU+ZDTDaG0i8LCsRcabTbFur3pwayZhj9Lk+3NfGTUNQEkYNpZTMriiQ5U59Hn0CeLWVNSL9g98Gdz0gGrJXA4yZYeUWmFEJ1eoSr1lVurSm1G2UcI/qflJla/IYjuCqrtiXNV3s/5ZWZj+HGyFrqQd8tdUGJhXR1nRyuF5Ddpeqn1cJ+MEE9hENQs5ya9eqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIx2HTn+81Z/iOfTuSe1BYbXqixA6WD31Hw3sFQND0M=;
 b=IUzJAGpQuTnjzCUGwhaRoyG6dtn9soZw3itHdE+2igGc0Xj702rcdmRJO/CtCntlUoq3fZ1KajJBM+Q9H0gOz0pIRdnOjBQ1uoY9aLxbhrc1g8TWWzKJWkN1KYx8j79JAl5jwneFEowgydyLdrrCJtqCFDRHGeOYbdp4cpEkq0ngvp52FDSQ+AMrqtg7OM19s/Up+gIlljyHTGEXktHbebD/AGoavfhrNB2+mzk+hJmt429QKwPDD/6nUp1miL439t8eshCxNuk1CWuZqp7bJwz4f0/B06U1IIE53B3D1rpaXJ/iLtXvJRa0jrvWUpCeJW5myNnL0ILmY/qEgYIryA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIx2HTn+81Z/iOfTuSe1BYbXqixA6WD31Hw3sFQND0M=;
 b=dZQnNGmYWuCk0pEFLRTuOVveFJDo60sP07CKJvXlsg73cS3ZOYkSt/PvG7qjo8XRhQax20QoxyFRLuqeYQcfXNzEeY4WJdgsNYhA1fLp8RDLDPCt26nAV9aC4TSr/lm/xNgAHVTHMbOd3XrC7Tc0PdUZDS65Roewlf+jPLttSIE=
Authentication-Results: linux-ipv6.org; dkim=none (message not signed)
 header.d=none;linux-ipv6.org; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by MW3PR15MB4075.namprd15.prod.outlook.com (2603:10b6:303:4d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 22:38:37 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219%9]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 22:38:37 +0000
Subject: Re: general protection fault in inet_unhash
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, <guro@fb.com>,
        <kuba@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
 <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
 <da6dd6d1-8ed9-605c-887f-a956780fc48d@fb.com>
 <b1b315b5-4b1f-efa1-b137-90732fa3f606@gmail.com>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d3f0d5a-6c44-44ca-f8ca-cb84210bf321@fb.com>
Date:   Fri, 29 May 2020 15:38:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <b1b315b5-4b1f-efa1-b137-90732fa3f606@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:a03:100::33) To MW3PR15MB3980.namprd15.prod.outlook.com
 (2603:10b6:303:48::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:bf4c) by BYAPR08CA0020.namprd08.prod.outlook.com (2603:10b6:a03:100::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 22:38:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:bf4c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a61147ce-96a8-45eb-af7f-08d8042106f6
X-MS-TrafficTypeDiagnostic: MW3PR15MB4075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB40758C6448D58B4ED74E23CFC68F0@MW3PR15MB4075.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+iyNA+xLtbPtsA65jAeIU4FXmA+vRbVWAuilkefPglR30C0axNxt+2IGWyfQOT3xFhMVsjQehEFGhhWV792P0vczI1eBaaZe1rA2OCmplarKt1JxuQilZtI0oyAaI9ZDTcL/pNuQwMNSlHVgN2NoPN9TLm+rAc5eu3EbUlSJQIKRr3C0KqYSXbG/3xT/V0hNcTjzL+L7WRN2/tC1AEScUfmGmSXOnWOsqEyVJ5WpIzDBW4Obxarl6hgVsy/p+CB0G6DKvWrMK0Z22tsubP2Zmr6NgeF9irYOCrqpqCC9RC/KIACboCBktOsw1pjLN2214vyws74+BthHH2NVjO+7mIHS1WOuahNF9DTnkMUSxON6e9Sz4z5FELe7Gz1sAULee/rZdCpAus3AajzAkdUALb8HeAVudvIT8TZzuPcOUSHhdRbrX1jEhuWzZ7EtHenuI9D7clFVv75SyjnXPdsoA88EiSgXOMwwAICgin/0Ns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(54906003)(2616005)(2906002)(83380400001)(8676002)(110136005)(478600001)(86362001)(7416002)(36756003)(45080400002)(53546011)(83080400001)(31686004)(8936002)(66476007)(316002)(4326008)(966005)(6486002)(186003)(16526019)(66946007)(31696002)(5660300002)(66556008)(30864003)(52116002)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wNzSEvI66UU469SgDtP/VRuhJJglz1c06Fzn2LuDxbrSTMInT4H2id1ZguRcE9j9hjLiKBlBGMgsy+T6jTWOAOuQqafit59pe8pvCcNLtWSC3ZFB3uvUdaJzXF2HVsOckxPhOOHU87NBSU7FeO47jDz7Rl189SZsKq0mj/OQfakPUBCzU3ZYuTqwf3VafMjCRC+yfPKB2rHjHl9E6FH1UPgb8hG4veoReM85Fc3mXSBA38qE57Wi19yJU+rk2YBxoRgU2NJ6XM7loSiEpS5xcj1fQbsc+DKf0r8SlQT+KwbnZapsxRjKRJwWQN0kQPYktL4AbvYHLq6gZ8cO2SZeAH4vjTxo8G93oqDAoai8k3eBsKU96ywdFulpAyVoJEvak27n7a4s2roiCFZCzkbggo3kehOtTuE7hw3j0ZrTsfwTM9BcOsBqSdmltHDqR3/z4s+LX3O8I10CBIqpEQDouv0fsVsAeRykUFxbyEdrigbhFm2u/DDnRz5opV7i2kfa0M41CCW4CfGD6sOva7d1YA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a61147ce-96a8-45eb-af7f-08d8042106f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 22:38:37.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o1G9MpUpz9ZdYADwiun9pqdG74gsBJAe3ism4Q6BVHHyqOA8idd0HPgLwgWZEA/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4075
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_13:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 10:32 AM, Eric Dumazet wrote:
> 
> 
> On 5/28/20 11:32 PM, Andrii Nakryiko wrote:
>> On 5/28/20 11:23 PM, Dmitry Vyukov wrote:
>>> On Thu, May 28, 2020 at 11:01 PM 'Andrii Nakryiko' via syzkaller-bugs
>>> <syzkaller-bugs@googlegroups.com> wrote:
>>>>
>>>> On 5/28/20 9:44 AM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following crash on:
>>>>>
>>>>> HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics support f..
>>>>> git tree:       net-next
>>>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=t1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=
>>>>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=yeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=
>>>>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=
>>>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=cPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=
>>>>> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=r6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=
>>>>>
>>>>> The bug was bisected to:
>>>>>
>>>>> commit af6eea57437a830293eab56246b6025cc7d46ee7
>>>>> Author: Andrii Nakryiko <andriin@fb.com>
>>>>> Date:   Mon Mar 30 02:59:58 2020 +0000
>>>>>
>>>>>        bpf: Implement bpf_link-based cgroup BPF program attachment
>>>>>
>>>>> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=rJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=
>>>>> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=TWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=
>>>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=
>>>>>
>>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>>> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
>>>>> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
>>>>>
>>>>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>>>>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>>>>> CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>>>
>>>> No idea why it was bisected to bpf_link change. It seems completely
>>>> struct sock-related. Seems like
>>>
>>> Hi Andrii,
>>>
>>> You can always find a detailed explanation of syzbot bisections under
>>> the "bisection log" link.
>>
>> Right. Sorry, I didn't mean that bisect went wrong or anything like that. I just don't see how my change has anything to do with invalid socket state. As I just replied in another email, this particular repro is using bpf_link_create() for cgroup attachment, which was added in my patch. So running repro before my patch would always fail to attach BPF program, and thus won't be able to repro the issue (because the bug is somewhere in the interaction between BPF program attachment and socket itself). So it will always bisect to my patch :)
> 
> L2TP seems to use sk->sk_node to insert sockets into l2tp_ip_table, _and_ uses l2tp_ip_prot.unhash == inet_unhash
> 
> So if/when BPF_CGROUP_RUN_PROG_INET_SOCK(sk) returns an error and inet_create() calls sk_common_release()
> bad things happen, because inet_unhash() expects a valid hashinfo pointer.
> 
> I guess the following patch should fix this.
> 
> Bug has been there forever, but only BPF_CGROUP_RUN_PROG_INET_SOCK(sk) could trigger it.

I knew it! :) Thanks a lot for taking a look, Eric!

> 
> diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
> index 10cf7c3dcbb3fb1b27657588f3d1ba806cba737f..097c80c0e323777df997a189eb456e3ae6d26888 100644
> --- a/net/l2tp/l2tp_core.h
> +++ b/net/l2tp/l2tp_core.h
> @@ -231,6 +231,7 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
>                           const struct l2tp_nl_cmd_ops *ops);
>   void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
>   int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
> +void l2tp_unhash(struct sock *sk);
>   
>   static inline void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
>   {
> diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
> index 0d7c887a2b75db65afba7955a2bf9572a6a37786..461bffa534a039410070834ac6144c23239a27bb 100644
> --- a/net/l2tp/l2tp_ip.c
> +++ b/net/l2tp/l2tp_ip.c
> @@ -221,6 +221,16 @@ static int l2tp_ip_open(struct sock *sk)
>          return 0;
>   }
>   
> +void l2tp_unhash(struct sock *sk)
> +{
> +       if (sk_unhashed(sk))
> +               return;
> +       write_lock_bh(&l2tp_ip_lock);
> +       sk_del_node_init(sk);
> +       write_unlock_bh(&l2tp_ip_lock);
> +}
> +EXPORT_SYMBOL(l2tp_unhash);
> +
>   static void l2tp_ip_close(struct sock *sk, long timeout)
>   {
>          write_lock_bh(&l2tp_ip_lock);
> @@ -595,7 +605,7 @@ static struct proto l2tp_ip_prot = {
>          .recvmsg           = l2tp_ip_recvmsg,
>          .backlog_rcv       = l2tp_ip_backlog_recv,
>          .hash              = inet_hash,
> -       .unhash            = inet_unhash,
> +       .unhash            = l2tp_unhash,
>          .obj_size          = sizeof(struct l2tp_ip_sock),
>   #ifdef CONFIG_COMPAT
>          .compat_setsockopt = compat_ip_setsockopt,
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index d148766f40d117c50fc28092173d3686428d1dfc..1d9911937aad524c9ad5edcdf23297b81c2d0a21 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -729,7 +729,7 @@ static struct proto l2tp_ip6_prot = {
>          .recvmsg           = l2tp_ip6_recvmsg,
>          .backlog_rcv       = l2tp_ip6_backlog_recv,
>          .hash              = inet6_hash,
> -       .unhash            = inet_unhash,
> +       .unhash            = l2tp_unhash,
>          .obj_size          = sizeof(struct l2tp_ip6_sock),
>   #ifdef CONFIG_COMPAT
>          .compat_setsockopt = compat_ipv6_setsockopt,
> 
> 
> 
>>
>>>
>>>> struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>>>>
>>>> ends up being NULL.
>>>>
>>>> Can some more networking-savvy people help with investigating this, please?
>>>>
>>>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>> Call Trace:
>>>>>     sk_common_release+0xba/0x370 net/core/sock.c:3210
>>>>>     inet_create net/ipv4/af_inet.c:390 [inline]
>>>>>     inet_create+0x966/0xe00 net/ipv4/af_inet.c:248
>>>>>     __sock_create+0x3cb/0x730 net/socket.c:1428
>>>>>     sock_create net/socket.c:1479 [inline]
>>>>>     __sys_socket+0xef/0x200 net/socket.c:1521
>>>>>     __do_sys_socket net/socket.c:1530 [inline]
>>>>>     __se_sys_socket net/socket.c:1528 [inline]
>>>>>     __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
>>>>>     do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>>>>>     entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>>>> RIP: 0033:0x441e29
>>>>> Code: e8 fc b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>>>>> RSP: 002b:00007ffdce184148 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
>>>>> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441e29
>>>>> RDX: 0000000000000073 RSI: 0000000000000002 RDI: 0000000000000002
>>>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>>> R13: 0000000000402c30 R14: 0000000000000000 R15: 0000000000000000
>>>>> Modules linked in:
>>>>> ---[ end trace 23b6578228ce553e ]---
>>>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>>
>>>>>
>>>>> ---
>>>>> This bug is generated by a bot. It may contain errors.
>>>>> See https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=NELwknC4AyuWSJIHbwt_O_c0jfPc_6D9RuKHh_adQ_Y&e=  for more information about syzbot.
>>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>>
>>>>> syzbot will keep track of this bug report. See:
>>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23status&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=YfV-e6A04EIqHwezxYop7CpJyhXD8DVzwTPUT0xckaM&e=  for how to communicate with syzbot.
>>>>> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=xOFzqI48uvECf4XFjlhNl4LBOT02lz1HlCL6MT1uMrI&e=
>>>>> syzbot can test patches for this bug, for details see:
>>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23testing-2Dpatches&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=_cj6MOAz3yNlXgjMuyRu6ZOEjRvYWEvtTd7kE46wVfo&e=
>>>>>
>>>>
>>>> -- 
>>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>>> To view this discussion on the web visit https://urldefense.proofpoint.com/v2/url?u=https-3A__groups.google.com_d_msgid_syzkaller-2Dbugs_d65c8424-2De78c-2D63f9-2D3711-2D532494619dc6-2540fb.com&d=DwIFaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=b2VQiGg0nrxk96tqrmflMQ24DJk-MOxx4uyOs7wSUJ0&s=TYFus0Dh0-ZHiL510kJIyPOWCyX34UzLWR4QvS3r_iY&e= .
>>

