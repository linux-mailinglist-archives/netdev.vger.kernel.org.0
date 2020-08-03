Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AF5239F62
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 08:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgHCGBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 02:01:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgHCGBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 02:01:25 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0735ko3M011254;
        Sun, 2 Aug 2020 23:01:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=soj8mlJoHQsabgytAZptfXczgkx/1DcYjmf8q5qys3w=;
 b=BrRazzPa1u3j1t63sY6euVbj1Cksf2gbCIPI0iZuapeO2HXgIAuBezbQ4arYsbuIIK66
 vgB21PI+ynK8lsD1RR/0noOnCTNMZ9VY3Rwv497YezyhHufbENzjThKPo8krm71YLn8V
 zWLwAfUS4d3I0gwgU43zP2CQyYcRXK88Po4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nr3btyfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 23:01:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 23:01:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwA5pVYH6MWThBVE7k3gpmbKNGctimlOQEpXpkgobNnWEcE/ja2AseZ0VP9AFhfqDmOKyk0ISAjaadJkyWBaAgqg6HHK7EMOHBA9vowMwUC2JhOJfEkDd870b2a3v8qzAnwXqntU05v2ZYq6Mcve5t7hvoY/N4l9KAkwwjlpzvOYkyVihSI7Mo/3WbN3k2Hewe1Zvtm+kfL2Mxv6YmqG4PmUmxypZMNPd6+X0XQW2HftVXgxF+xkm2J1y0YgXpeiV3mfih5DOndpoAeppzbWm+7CO3jKayP8diJ2AXsMyFKN5lwk6JvPWQkYIgpKSKWSu8HdJ5boNLX7lB2nSdUrmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soj8mlJoHQsabgytAZptfXczgkx/1DcYjmf8q5qys3w=;
 b=Xy1eknf0IkOMP3M5p/2XbwbL+H+6S6ls5rnqPcVsZUow+FXHC+1i1fJYgwS1+2zQ+y0gyv0Efsi7gwiany+C80UexA99IY9Ne3SMwsSTYS2vvkuL/SN1fGHbqkAg2155cjmQxkRZQ39SyIkJYrYSbeE8A7SwrHMEnPwT1bagdyKlje2T23q9w1rPwko/4bFeunGF+MZItar9rv6jUNT5E/fVa2XiY76AybbwKe9oRtVG8djFZXstx39zfwoYo5YMijE01OrnVVmF2loGKwlPYwskJ+7uiT+5hdvY1Iu1sidP/TXcVYPe5WLUNhR30r5vqILY8sbZ/eHcdEhTI0y30g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soj8mlJoHQsabgytAZptfXczgkx/1DcYjmf8q5qys3w=;
 b=JW8UrbqWUzkQXv07i9gc82q+CjbZPLli8F7bKRwe1+508hT7a/W44DSkJTZ9IiRWkxE8O9F2cAhoQqvZQbti24KUBLHkxvydytoR+bK/Z8lslAlyyIJav6ZOR58wMndC99LorWTEslgEeL7PkypIdQHVbrZ9/qaPiE1SqED/HuA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 06:01:04 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 06:01:03 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Muchun Song <songmuchun@bytedance.com>
CC:     "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH] kprobes: fix NULL pointer dereference at
 kprobe_ftrace_handler
Thread-Topic: [PATCH] kprobes: fix NULL pointer dereference at
 kprobe_ftrace_handler
Thread-Index: AQHWZKq+cwuqZwgf4EmOpIx4quozWqkl7ZqA
Date:   Mon, 3 Aug 2020 06:01:03 +0000
Message-ID: <5555B378-4326-451C-9771-714D5A345421@fb.com>
References: <20200728064536.24405-1-songmuchun@bytedance.com>
In-Reply-To: <20200728064536.24405-1-songmuchun@bytedance.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 634c5544-f906-4799-85cd-08d837729b09
x-ms-traffictypediagnostic: BYAPR15MB3464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3464019A18F546DBA65E1ECDB34D0@BYAPR15MB3464.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5g+C5+vbpLN9UoHHHT07lWqld4BSFJsjiIlWPc8oRAc+d/Ls80meWmr5aeEoHP5l3wZaY3kMC3WIykBy4q1Vk3vLd37PHykTsCjqtcVRU+rOfLcjLVEHyey/aOvN3B81CcWwg7HmItpXmh0f9maLzui8pZIrOgdW092NwaJC5dzwS8d51FC3UFR6EpozhuItxsfbB/WZGwbdr2yBLXVko+hgrRjWceuOkV8GuzvpImcugnfIVpLP2cK7VYJWmyOaBBe2nd5l+tOkom5hZwV5dWp9fMnWdg3VtI4u8hSfRSnAYd6cZYhGT/UdH2js7t6p0uOMj+GgfujL0YKOokA3Qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(66476007)(66556008)(64756008)(66946007)(66446008)(6512007)(5660300002)(6486002)(2616005)(83380400001)(4326008)(36756003)(7416002)(6916009)(316002)(76116006)(8936002)(6506007)(53546011)(8676002)(54906003)(2906002)(478600001)(86362001)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o2zM+pH7HYv4wV5oLV7sHa/xCya8vOgFSNSRqgSE4DMGMLMAtfazzcU4RH19pah9OqgS/pyF+gmmxeM0fxubX4nIJ9ZgddXh4FcrbjwQkzUTaASwJAYDuATscXRJyD/o7x9FPbXxknGYPnfgIGqqRNjUSXqWiXIGiyyw3NIlgMVIVV84PfmH0Nv75f9EagZfRxoQCUAhnsXW8oKFzFHsyniooihft3RRGe6SsfWXTACQXExXdLOKf+vSM2AdtKoN7IdmScalwYwf4J0fxHhcEUHaWpOUL39Qz6P/WBNFui382ooGQco0mil5SZWBdJQ49Hb7sdlaukBOaJeKq9y6z/9/BVjTbCfJji0vL8I7IQbXpuNMGmAZbm0XxkkZYsHyOLrjAeqcG0zs6bFSpXokFBU1hzDP24nsEJeh/Zy9mU90wtT9yFm5eLGuAjhIxO1DvWgfexFZnUJEa/IN1l4nKlxM+4lnzrv8gZfchOz3sPLu0q/d0hCd58bTubWLOD/10T+Qj/ryntmVJHiLSFAfONs5+hJdInGH8aHpjMBo8KJPrPpmiQxAido1QQLb6ZUMwcdUzYJEkBlZWGY6h7FgrG1/bYyWIG0uYnQ5mpfqJNPCpF4XiK/FvIe1Az6n+MJvdF/uHzWhM17z9sFScf1SrRZjyHzFYtIHcdp1x4l5bPE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC74A5F2522D1247BCC8386205B4FA32@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634c5544-f906-4799-85cd-08d837729b09
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 06:01:03.7558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79Z+KXGR312KXqBtFlitlwrZTxS/HEvNONXO34Am7pVkN4+BKC4KfVA73wWP35gCgF2gHmkg2KoxHYzVOLXicA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_04:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 27, 2020, at 11:45 PM, Muchun Song <songmuchun@bytedance.com> wrot=
e:
>=20
> We found a case of kernel panic on our server. The stack trace is as
> follows(omit some irrelevant information):
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000080
>  RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
>  RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
>  RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
>  RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
>  RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
>  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>  R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <IRQ>
>   ftrace_ops_assist_func+0x56/0xe0
>   ftrace_call+0x5/0x34
>   tcpa_statistic_send+0x5/0x130 [ttcp_engine]
>=20
> The tcpa_statistic_send is the function being kprobed. After analysis,
> the root cause is that the fourth parameter regs of kprobe_ftrace_handler
> is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.
>=20
>  crash> dis tcpa_statistic_send -r
>         <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>
>=20
> The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller=
.
> So it is reasonable that the fourth parameter regs of kprobe_ftrace_handl=
er
> is NULL. In theory, we should call the ftrace_regs_caller instead of the
> ftrace_caller. After in-depth analysis, we found a reproducible path.
>=20
>  Writing a simple kernel module which starts a periodic timer. The
>  timer's handler is named 'kprobe_test_timer_handler'. The module
>  name is kprobe_test.ko.
>=20
>  1) insmod kprobe_test.ko
>  2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
>  3) echo 0 > /proc/sys/kernel/ftrace_enabled
>  4) rmmod kprobe_test
>  5) stop step 2) kprobe
>  6) insmod kprobe_test.ko
>  7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
>=20
> We mark the kprobe as GONE but not disarm the kprobe in the step 4).
> The step 5) also do not disarm the kprobe when unregister kprobe. So
> we do not remove the ip from the filter. In this case, when the module
> loads again in the step 6), we will replace the code to ftrace_caller
> via the ftrace_module_enable(). When we register kprobe again, we will
> not replace ftrace_caller to ftrace_regs_caller because the ftrace is
> disabled in the step 3). So the step 7) will trigger kernel panic. Fix
> this problem by disarming the kprobe when the module is going away.
>=20
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Looks good.=20

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> kernel/kprobes.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 146c648eb943..503add629599 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2148,6 +2148,13 @@ static void kill_kprobe(struct kprobe *p)
> 	 * the original probed function (which will be freed soon) any more.
> 	 */
> 	arch_remove_kprobe(p);
> +
> +	/*
> +	 * The module is going away. We should disarm the kprobe which
> +	 * is using ftrace.
> +	 */
> +	if (kprobe_ftrace(p))
> +		disarm_kprobe_ftrace(p);
> }
>=20
> /* Disable one kprobe */
> --=20
> 2.11.0
>=20

