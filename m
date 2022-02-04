Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278AB4A9EA1
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377358AbiBDSFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:05:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377419AbiBDSFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:05:45 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 214H77Hu025806;
        Fri, 4 Feb 2022 10:05:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=u4PlOCKcd8IH5lHIHZreQMy0d3jKiKS6ldjYhzhajbk=;
 b=Cm1NHTQDt+fP8V6T4kv30cIor7dzonJOLwJJa8KfEs9kUy/OJmRyKEeEU6w+m8O9hAXg
 pZaoR0mEmlpxRUFAkF6qTcKcIaJCdp6qi6oL2w2g+En3LyTLFOIvdD/+Z/OWzAzZWhOO
 aBmmo3d75S88DHhjRBpio/yLED8KUeiF4Ho= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e0cvd295f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Feb 2022 10:05:45 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Feb 2022 10:05:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CScwigKDF37AtsWvtFU0fZ/frECD/qT4JsMlbokngdJW5fKPIkhikuVd8dhfQiOGMkIL9A4KO4B7an8Jz3X5C44G6dHacu6rNzXs1XMbtdIXuJk7NvaAYOBEmT2GVRz8hQNT3+GGNDPmdrvLAwVM27yygq6BnqgCOe6r2pEKYhavF6pH4Upx7aZmzG1AWzVFOcAS+vyZHs9NvPAm/EJlPVGHv1EGoCZgLOzTzIwfutrh0I7L500c8ul9Cfpazo+0ibVmw2h7Emu6Gc71IH6M95/tXO0eg5qjtBXdONyDqNPnjIQjVoRFIcnPwOiEn/UQxwwtupEzJoI4UfrEG6W44A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4PlOCKcd8IH5lHIHZreQMy0d3jKiKS6ldjYhzhajbk=;
 b=IEj+qotNFxy8uz9mrJHcpT95RmHohJ3VlqeE/g/9ly8E3RSaI7aALw3P1YF1rdjFMFK0NzWXgHfC80NmI0lkkz9vVtdW8vpOddz114Q9ElXPsn1EILH/p41a3EIJD2mPBWLp2gSx8s1UiO/VdEgpC/dDoJFt8rnPiKkL3yOotS/Kumpbikpwrr9pdNuvhvXRFmSy/KpthY7+07MxhgcO4ddguPQiPp+/XCwmAWKSzGP5fRDl1DUCz4tjP8AddPpXGZ1HDaBTjFXmDlQGC15qTa4+bNnlCxUykBSqu5yzYlU5X9GzWADMM89DmEbwZxHvX74aQo0DBF7Km0Tj/ukP6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB4568.namprd15.prod.outlook.com (2603:10b6:a03:379::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Fri, 4 Feb
 2022 18:05:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%4]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 18:05:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH v8 bpf-next 4/9] bpf: use prog->jited_len in
 bpf_prog_ksym_set_addr()
Thread-Topic: [PATCH v8 bpf-next 4/9] bpf: use prog->jited_len in
 bpf_prog_ksym_set_addr()
Thread-Index: AQHYGZq9nVwt+XlKf0qh6wdCOGZoSKyDsG6A
Date:   Fri, 4 Feb 2022 18:05:42 +0000
Message-ID: <22BEAA3B-202D-43F4-9427-C2BCC9957459@fb.com>
References: <20220201062803.2675204-1-song@kernel.org>
 <20220201062803.2675204-5-song@kernel.org>
 <CAPhsuW5uG98fPostcQYw9Kk9DTczOw6LJUJRb8NfiDVVgJcHwQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5uG98fPostcQYw9Kk9DTczOw6LJUJRb8NfiDVVgJcHwQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e767f8a9-8acf-4c94-db63-08d9e808f55a
x-ms-traffictypediagnostic: SJ0PR15MB4568:EE_
x-microsoft-antispam-prvs: <SJ0PR15MB4568B49D96C58AAF175250FAB3299@SJ0PR15MB4568.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I1hYqlrdTBAUg0BoARnJAW1sc0llx6DAATX/4abeVjUdmpGqFgQEWXJollXu3N5e+lx1nEwKC11CMNl/wdwen43whg8AWNEogG89XpEn/qKXf97K/9+V3NlLkYqrF80mrIbkMcK+2INUDdrCXLagb2FeIpv5/X9IBXv4Jzq8e5pB/9bXGIwjGrRyV804+Y97qO9H2hC5G84Fe5YT8IhGs3dJ5/U1Njq3YmW3CUc+Q2BYS4Jtm1BqrSFBAiLVNqSffDm9H4D4xZzkkUzVD/srjKHPfy8eX6M5crMIZXpARuzgV0GRHB5xQ76XfXDGz4IUomcrIzB4A7lCWq41xn5fBBZK4obnBlbJoqa3hTA2cxghH3sgOIJdZlG3ACBe72K5J1w33HFcE0HalLCeAi2W4wFFIzLun9AxXFafiJ5+gHptUHiJcuur3HoA/rcXU+6UkMrzw8s/0bX1sDhI7FHmWaS0zoLBC8WWk1Ns5zlg+lxEF9WLc5AnsPKnO32+fJPp1dR52kdTVhLBYRQQuSuOMR/Tq/6y0ZQYy8uu2Y14VsELAEipY1miCdxjQZ3grykk/hWdI3Nj61wgQ47S26+pL1uSnb1pgWkfK9GAAiKlgn/Ef76vosbTcfr8Jvfy6fbs0jTsC9Sb5p7wPcgS5vx5JGzO9t4yzf1VxUxrkp4U38BUaWURiPtKHff0vJcEyLM6eXHgqKIMeFE3TsYkKgFInXzLsm1opKDTJdJtbOoKhfAyKZ7QAUCdvr9Ooxd31O+SIaVtYu+lgvQ1w8CCMsUOFjwSYKKzXkxPCWhA6ZLKMSogIhf97LLpjWMRqUsbU2FeVLpXASN0JH4qcAMHXNAIdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6512007)(6506007)(36756003)(86362001)(6916009)(54906003)(38100700002)(6486002)(966005)(508600001)(2906002)(33656002)(83380400001)(8676002)(4326008)(8936002)(2616005)(66476007)(66556008)(76116006)(64756008)(91956017)(66446008)(66946007)(122000001)(53546011)(38070700005)(71200400001)(7416002)(186003)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XqcgMazyssTC9QOCqyBOk/sbxsk2WWELnNGqg3I0qCynpkyUCckhhL6Lyfqh?=
 =?us-ascii?Q?9+2Zmcoywdo6uIFEp5oTyzTQHWcFqz3o9pBbL0RQ3FOAa03yRbqtYdWflGju?=
 =?us-ascii?Q?Wg3rEbaV3IN8pY74aKujVgb83gQrvwPv19aX+m2IDDLvm6limMMvodSNlM+l?=
 =?us-ascii?Q?ba4Fs0X5uKmMs7zbReu5tqUPESYjr/fKsX/IQmyKWSteORu5fMi5B56Zl0Nt?=
 =?us-ascii?Q?oPDGnvzfc3pBKNpeBauOf9Wre5o3gYCK2IVhoLFMZfOIqyJPZSJfnj0Zg+AK?=
 =?us-ascii?Q?fsWCNHduL8beeo1av+Pk2+1bTrmlDGZS3FYnl0uG1oxzJhYEf4eDF6ogyE+d?=
 =?us-ascii?Q?fimRMDpBGgBfvy3ZoeLzF1iPMlsKkDADmXmk8kS4vjWn5ckOpWo2fDcnDPfa?=
 =?us-ascii?Q?HwAoeF9Jk3uQGegRWYI/cR65ZrzfGc7jY2SRCUmPBCx2RmaAVw2GPUnIsfwX?=
 =?us-ascii?Q?P01udESn2AjanODhBk0TePqk4UBPrZ5+i9lH86PckanFLCLkRiB826XTdKt+?=
 =?us-ascii?Q?tZnDEoQoJCrkuewNDoEpbU1A1j0Daf97B6Ta0hj73zpRetdRrx3KRGP/XKYx?=
 =?us-ascii?Q?O2ij7iS9bFHpw+Bo8U4z9FZcNwKfn9reJqiXnQq5jo78ccdm6Wr+5kEQAw4t?=
 =?us-ascii?Q?Ejq4EPSHWRwPkj2BSt5BtHEIvmVLYVkI65a57Yf9CmwU9maoMnTuej1Yn8iS?=
 =?us-ascii?Q?EKekYzC7f5WqLcNyfCCM+MHv9nSOnVWU1cfsTSpHWgt8Cwy9hIN4SUAdWME2?=
 =?us-ascii?Q?KwcQH5dqQYZs1ECeBmoBKnQEnH4nbn24OmSFYnlaKjAZiN+WIk2ywtCmil+o?=
 =?us-ascii?Q?7QgKdSUrR8Fiuw5FOJu9r87vIp9SKqOxZIEJ2XwxDReLcJm5p6vXoA6K/wRU?=
 =?us-ascii?Q?3xDuIgjjIaBLX3Mt91lM4dK1NWlMrmsEVwZoNTSTh5719oVkND1hIBp2dDuR?=
 =?us-ascii?Q?ZzFyI2H5b8yMrQCJpF5KUAIWvGqupVBQ/Ra+NQQXMiQE44E/H2yPsToHTLlM?=
 =?us-ascii?Q?+GnGZ+tCazM93nIWuNBBLe683pi7UreWfUjGcw0a3nDvzOi9fIYb3VxAtTkL?=
 =?us-ascii?Q?5oruSxuMrhGDDdSASbLdSj++1MVlio/Y2KvtAHEzqANVdwyhMH1B7gEDg+Li?=
 =?us-ascii?Q?2OjtdDYW3Ol1eFauEIi1DzSatDhylYubTmKwIj4saBxytZ7UUEIr78RnpRxn?=
 =?us-ascii?Q?A8twydMrOtswo1T+zEd0BV6GKDreX/uIliMUiKa16JPh3+FtPuBxWTuuShq3?=
 =?us-ascii?Q?YHYii6fO/7BiUD5a9TJ1GUTIiDexLypDL3a+/8fHfA+0g98OHkOqFH2TPqzn?=
 =?us-ascii?Q?9Uckh8D8HOOfZIMmFHjG8ndX8zmVtbopxvFgO7WIUHeaSaBHhqJ9/2VmEfmz?=
 =?us-ascii?Q?TPrY+qESVxtBspF1kKJaNhgf2hLgnOsmHR+Y485jHbWPhqcADNqCMecIMeAn?=
 =?us-ascii?Q?zkYk9JdAcUKrmrK0WKmgH/7ENjfUgZ9Xk+fhE0OiUQxZE5dcI9NYmRjAI44v?=
 =?us-ascii?Q?1DG7VOoPVvlbElQI8+Tm2FWP7jkXWg1FbcVSkk9WE30VVHRIi3L3HmbIkNQj?=
 =?us-ascii?Q?Y++m/EGyLcGHjEilW/+CODT+wql1NxKm+bzokC2Fb7XiKy+LOqJgQfCB5dNS?=
 =?us-ascii?Q?DxvD3tf4Sct51mbEs3jmR54KwQ/xGfshMqioHVEijS+z+8Y5h6pfqDDeDLvn?=
 =?us-ascii?Q?O1jjsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <305E7AE2D9B18A4D880C39901ACDB12A@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e767f8a9-8acf-4c94-db63-08d9e808f55a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 18:05:42.2609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4j7KhbldNFsTxQKmcV/g4oqJ04fHghf4DX3tvdIWLrB+QYVAzCP/XXKCXJuzL/85lTt2oTrP81dcVTIfXs7xdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4568
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: WUoU6Qta06NFY-_hnFftRZ0O_3C3jzaI
X-Proofpoint-ORIG-GUID: WUoU6Qta06NFY-_hnFftRZ0O_3C3jzaI
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 3, 2022, at 11:41 PM, Song Liu <song@kernel.org> wrote:
> 
> On Mon, Jan 31, 2022 at 10:31 PM Song Liu <song@kernel.org> wrote:
>> 
>> Using prog->jited_len is simpler and more accurate than current
>> estimation (header + header->size).
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
> 
> Hmm... CI [1] reports error on test_progs 159/tailcalls, and bisect points to
> this one. However, I couldn't figure out why this breaks tail call.
> round_up(PAGE_SIZE) does fix it though. But that won't be accurate, right?
> 
> Any suggestions on what could be the reason for these failures?
> 
> Thanks,
> Song
> 
> [1] https://github.com/kernel-patches/bpf/runs/5060194776?check_suite_focus=true

I guess this is the missing piece:


diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ae41d0cf96c..bbef86cb4e72 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13067,6 +13067,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)

        prog->jited = 1;
        prog->bpf_func = func[0]->bpf_func;
+       prog->jited_len = func[0]->jited_len;
        prog->aux->func = func;
        prog->aux->func_cnt = env->subprog_cnt;
        bpf_prog_jit_attempt_done(prog);


Will send v9 with this. 

> 
>> ---
>> kernel/bpf/core.c | 5 +----
>> 1 file changed, 1 insertion(+), 4 deletions(-)
>> 
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 14199228a6f0..e3fe53df0a71 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -537,13 +537,10 @@ long bpf_jit_limit_max __read_mostly;
>> static void
>> bpf_prog_ksym_set_addr(struct bpf_prog *prog)
>> {
>> -       const struct bpf_binary_header *hdr = bpf_jit_binary_hdr(prog);
>> -       unsigned long addr = (unsigned long)hdr;
>> -
>>        WARN_ON_ONCE(!bpf_prog_ebpf_jited(prog));
>> 
>>        prog->aux->ksym.start = (unsigned long) prog->bpf_func;
>> -       prog->aux->ksym.end   = addr + hdr->size;
>> +       prog->aux->ksym.end   = prog->aux->ksym.start + prog->jited_len;
>> }
>> 
>> static void
>> --
>> 2.30.2
>> 

