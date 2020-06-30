Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4920EE22
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgF3GNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:13:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729768AbgF3GN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:13:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U69fhN010176;
        Mon, 29 Jun 2020 23:13:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=G/LTA8/tr1XeAuPn/CYyO1wzo8UsYLi2qKprVIc8HFc=;
 b=DBtKiDo3vL1Qc4dQ2vRCfYVP4JUuVXHN2ACpU72oY8AltbslWinktMj4FUjkRdmVU1Yw
 mvxUn7qZ4+QF/KuQj0qoUlKZ+eXCAupOGW6GVHvfutV20g7Eb5u+1eGcYHf/NtzPqQpL
 PEp/CtHZgsLlp20I8ile9hCxL+/142HZTj8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp3rgcj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 23:13:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 23:13:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTuixb2lQE3SM2KL9Gs5rZ2PhcKuGFFNESYLdxVqwHQfyhFxiy4sTyLViVCOaVLgBPhhDCc21NIiyzmhgN6BdxvYD5BLeLr1gOtr5In5wiMgsbYBk2lR9O5p4dyKLABLrY09Q+YyIiYHRsnORDekKK6ZXtE99fwwWJuZ0IcH9iRaq0Y4P4tlKdoe67+T2YX4ga2tDM7GR8XwDLFQRHFkYq4Zje/Q1rc/7rhifrgZU6hzfjeDL0RquNySOBDC42j+MoxhHu+LFdbTf4jErGHlWQTyTeC6cHMeNZyMrzaEydipnVzgZaWo7Mx+DRxrqXvx/YtAjSLtSMTCzn6JXXsuAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/LTA8/tr1XeAuPn/CYyO1wzo8UsYLi2qKprVIc8HFc=;
 b=Ydr18lJEu6m7D0PP8sSeyS1lyXBAPqpcbjKRZ6agJe8xvJOzEkwdYDv9lC0fOVsbfrqhEae61PkcSFa22bF8wlnwXjyo4hT0+MPWuMqJw71ytyBh3gu0a5pW1b3eBEY+s4ALtEACvn11Tcz1pvDON7u1ahvGEzTHx2GH2VAVGoFGq5FNRtm7uPPuDBf+da1LR/vfLLJZ//2IhYgDQEPUiw5MSB0JV/bjKUOYMBPXaT9favtLiWfR5WYno77Rtjto0dBEas/eA3j9Fk98vPiIcMwzZx1Vw3vhh+gSgg0uhqxxc9cEGKpYAsEQyEPGHJ9qT4Gwm8Pj0mYBEtbXaTsy+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/LTA8/tr1XeAuPn/CYyO1wzo8UsYLi2qKprVIc8HFc=;
 b=aJkev7ao7MFwijoHW3zae5OIeEC19xT+YkTLKcsP+rGxXPEER4nT1IAY8uTD7j9slarKGuVgbI/EWm+x6qlRlw1p1iCVvToQbbCamDvJtYxhTmtjGTFKrG7efrMRyFsUFZSCoyOyFOpugea1MrWtuQIsIskr20/x3JBvnQcJ4cg=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 06:12:53 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 06:12:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: introduce helper
 bpf_get_task_stack()
Thread-Topic: [PATCH v4 bpf-next 2/4] bpf: introduce helper
 bpf_get_task_stack()
Thread-Index: AQHWTdpOOeBrZxmplkiL+hzLkKWLhajwj1OAgAAf8QA=
Date:   Tue, 30 Jun 2020 06:12:52 +0000
Message-ID: <9FF7383E-2D6B-4B6C-B996-50347E0A2F94@fb.com>
References: <20200629055530.3244342-1-songliubraving@fb.com>
 <20200629055530.3244342-3-songliubraving@fb.com>
 <CAADnVQJUdLKmdMu_eAX3ZGjf5K8GMkow+KoBSTTqy6CftgmdTw@mail.gmail.com>
In-Reply-To: <CAADnVQJUdLKmdMu_eAX3ZGjf5K8GMkow+KoBSTTqy6CftgmdTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:4392]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d34432f-d6aa-4622-bfd8-08d81cbc9f92
x-ms-traffictypediagnostic: BYAPR15MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2647B91FED26CC16F2CA1494B36F0@BYAPR15MB2647.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N5KGiBufJ3bRFeKQrf6zsYWv8wl6PBJns8yVCspUFiQR3fXtOGaIuUfX39sjQzqLMDdNJypv99jVBkF9QDPBaXnhFiGUKYiyluOLp8WLnbXYwRFpXA+k7VcON7i3uEuIK1D7ff3OQKZqxTRMMuWuTdCElKJbX0R0kE/UhaPrLlphnQ7XuejSs7NEHtX+A2rotMsBZRx53mApgYwKsr1r2uxbkgzEmA/JAmYL44o47Vn0YYaKe8RhlicfEljvB2jlin8pb06zEStXHFtqKaTCSH88HSwVFCquGlMX0Ujz2TldasguXIk+dktoEaZy+27O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(86362001)(33656002)(36756003)(6506007)(83380400001)(6512007)(54906003)(53546011)(478600001)(5660300002)(6486002)(4326008)(91956017)(316002)(76116006)(71200400001)(6916009)(66446008)(66556008)(66946007)(66476007)(2616005)(186003)(8936002)(8676002)(64756008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TzTrex1WHYYOV13ozNCuBncNoaEJ2LeQjzzZsf+vRzVgMa7uj6Fvs37Aq+EQ7MSjEz90/8rHAEE2T2a/PclWKdjd+jYqMA7+YpKHaI7VVWnum1TxcySjDivqRSUZAPVbztYzMUeD0ltrRzxPDizxeVo1obVlF4nE5nz4vG8bHOWDX3N594U2w7ePDcsVP7abgFaGXSdqeHXG9fey3h37Z5sRABA+z7kMqDXjRVx7MiNxRj4mq2euraIrqkrx/FzN6cBXXbSSESvjsuroBoznsOIRF3ZAJeG/+nU3Zv5zJHiXS/PoeOJPL5SEpCvzc9TNr35exdI4e3BCez5Krwug5sHlepfe7WMPKuhZCrP24KMRAemwafIPyebnamKFlweiiM+/sGFx61O4YT/SMWDv2whWqSlZOsr2N5wXLntu6VOsPx4Ahv/yH68KH93WvaWT1dRH+8X/TXzheCJoJ4XX5ndLVPJ7uS8eybXbtnd7WN8fze+SCwPpOCEeWz0rpHlSBH7dSiOGIh6cZQdxej7i7w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4959B192D5F99C47B5A07ECE53AC44B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d34432f-d6aa-4622-bfd8-08d81cbc9f92
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 06:12:52.7830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/o73N+pminW8SdR+7GmsDfHrcVyq2sr4/r+bjLbk9+lxkr6bDQnQW41QfqZblRkq9yiRRjS7ndgeYTGF8HYwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_01:2020-06-30,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 cotscore=-2147483648 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006300047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 29, 2020, at 9:18 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Sun, Jun 28, 2020 at 10:58 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
>> task. This is different to bpf_get_stack(), which gets stack track of
>> current task. One potential use case of bpf_get_task_stack() is to call
>> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>>=20
>> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
>> get_perf_callchain() for kernel stack. The benefit of this choice is tha=
t
>> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
>> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
>> stack trace to unsigned long array. For 32-bit systems, we need to
>> translate it to u64 array.
>>=20
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> It doesn't apply:
> Applying: bpf: Introduce helper bpf_get_task_stack()
> Using index info to reconstruct a base tree...
> error: patch failed: kernel/bpf/stackmap.c:471
> error: kernel/bpf/stackmap.c: patch does not apply
> error: Did you hand edit your patch?
> It does not apply to blobs recorded in its index.
> Patch failed at 0002 bpf: Introduce helper bpf_get_task_stack()

Hmm.. seems "git format-patch -b" (--ignore-space-change) breaks it:

# without -b, works fine

$ git format-patch HEAD~1
0001-bpf-introduce-helper-bpf_get_task_stack.patch
$ git reset --hard HEAD~1
HEAD is now at c385fe4fbd7bc perf: expose get/put_callchain_entry()
$ git am ./0001-bpf-introduce-helper-bpf_get_task_stack.patch
Applying: bpf: introduce helper bpf_get_task_stack()


# with -b, doesn't apply :(

$ git format-patch -b HEAD~1
0001-bpf-introduce-helper-bpf_get_task_stack.patch
$ git reset --hard HEAD~1
HEAD is now at c385fe4fbd7bc perf: expose get/put_callchain_entry()
$ git am ./0001-bpf-introduce-helper-bpf_get_task_stack.patch
Applying: bpf: introduce helper bpf_get_task_stack()
error: patch failed: kernel/bpf/stackmap.c:471
error: kernel/bpf/stackmap.c: patch does not apply
Patch failed at 0001 bpf: introduce helper bpf_get_task_stack()
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Let me see how to fix it...

