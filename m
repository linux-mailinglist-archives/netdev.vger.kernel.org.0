Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB55239E71
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 06:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHCEsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 00:48:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbgHCEsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 00:48:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0734j6ig017162;
        Sun, 2 Aug 2020 21:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hXE4BRMkOcbVrhIf7nVVllufTWasyaR6sdCz+QxRHT0=;
 b=krJHqQAoEcITBOXh/ssfOoId6PdA1+C7wddSnz5cwle2SVCbxlrIr+qhIOatr12lnZOl
 SoQQLDfIefqSaHhf0x8Wxe63kLchIehoyJSiVF/AXofZCVjzs/lnXre85EMdd6rP4ey1
 ovv31cirFqYMpMTwKaBIGEGLDYIFE0K8JHY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32n81y56kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 21:47:50 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 21:47:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DodSJWHt1Tty6GaTk+vx8rPngXJBKh0Ue67SZhRf9GLR/BBj8Wt4ToPHz8FG/vJAcpqUa1bURBHSH9wfj8lZVjfeDG7uNOwTqK91FApb2bLYtIn5cqo+3NSdYDfKeb6mr2FefmG0Al6Fo5HOt23ejFsGAbMqxrkZPxB4+jnf38+PNO3yJUOJBjF+vSqMEPQKq840cWpaRa4GKZmUoPcwd0ycAvshaGDKhVRN++iOvbqj56o+V9CxQdNC63nSs1uCxlfRW7y5r8+dDwx2GTEHHIV63WO5p2kpLMujXVxX731nhd9UuKrPuvNwOINmNYx9kBsiWPOqUeC7AN56zZcKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXE4BRMkOcbVrhIf7nVVllufTWasyaR6sdCz+QxRHT0=;
 b=DthENBmNREWJ44tYA0ZGCFn9CuaBjHCaaQwZ/EBcewNvGYeDH1Q2hgcgA3nWdXdOtKK6bp3r88KbZs4pS6hcncca3k99zhaM5LfHUdghjzNGGAyJQ5+ngqJwGwjhE0OHJ/STbPmeBekQFrnna6u5/heUWxIdNk/UsUsG4LCoWeMKa4sl+tebi8rfItFaC/wW8uQxTxgCAZRHVJVW/xuOWcyBBW9UGt70i6ltNtv8BFgscebxgid42ylhuMpRvOoORHTg03mTAypsjEpPCvr+GZzdfF+vx59LK73f/WyFohU2Z8gQUSC7acLhyebvKdMugAOJv/fU2rQoCRVQdOeBGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXE4BRMkOcbVrhIf7nVVllufTWasyaR6sdCz+QxRHT0=;
 b=RcMairY7mG6arlR7i5tT9GtSD/hCPklMAj5WRrPE3uHCmz/EZY/Net0usz4h0fdXjD8MFF6lvUlfyXEhdBOTGQbjPSkImc2mpugwxMCyrKboXPULhyezdJKr6P3nEynLzPnbhxAglOZ3VcO1Eofwda7INPvbLiMWGBjA3WaaT7I=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 04:47:47 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 04:47:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Topic: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Index: AQHWZ+C4z/mDZUCS20yCUvtKcPb5ZakloXcAgAAxPIA=
Date:   Mon, 3 Aug 2020 04:47:47 +0000
Message-ID: <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc5e02b8-dd5b-4e90-308e-08d837685e6a
x-ms-traffictypediagnostic: BYAPR15MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB27256D7D28897B8E24422DFFB34D0@BYAPR15MB2725.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HNybmf69Z/cj9mhS8zbAJ/ZJ5ljr1YyVbfOvajmvwd6RRLoCwCNcWuZoh9p0ld7ilfpolGIW8KsY7HP8evhw5Dtc191gk6F8Vdufk0kEwUlJ/Hl8VRyqA/6JSnNejKmwZswcqJrI7NdWUJP9WEzzaNM6qD9jzoBgsTWlltcL7IzhnQBFx7Brg6Hv4ZyyCJg3Pk6DxnirCwyM/dZ3yRlggV6r25m+WbAsumrzcqkzalw+G3r9ybqua0dTdbktGX6UFel+TJ1Qm3TL9fbHX4eCwS+G3QieHnygM4TUrNa+7pMa2r9QHwcHyWMAMYEOiz4PQ/0+4IN3tS1WEAdaKEMPkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(478600001)(6916009)(66476007)(66946007)(64756008)(66556008)(316002)(54906003)(66446008)(36756003)(8936002)(5660300002)(86362001)(8676002)(6512007)(2616005)(4326008)(71200400001)(76116006)(6486002)(33656002)(186003)(2906002)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OszQmV7EP1T0yGl/6TSPmPlVmcvhtfHMY2brgZanzLooZZnMTZmQU4qBrPLerne6NcXLuvikqwj7nhQt2VZv0lf6kLpCaHR4gUOTjgMY1xwA2rPp/ceVlv9mZCXzuM4tTuSHTcI6XjL8uV0UBID6Li9EmyPaMZPUyDCj+2qwsJxPijp9Ho+uzMylJlPOJ8h+aC8zcNEDX+s59BLNHKsIKM7ON7pky52xygQyKOO20jUc6fAsOIm9oBfkqYCCap2LEiXvHaY8Hxn6InS553LinkHA9MnXfb2WAeAeH/kjfxWPRE1PTOJqjhvp0eEo8dujD1q3iMeOYaCScF7uFI/GgoQuNgUhuT1MrOVbxwOYiBFzPtAeF9uhzxc+pVPoJDw6rn7n0I84R4oxJGrXMM6yB+vVLEGsrfMAvuLAyrjFK7nmqOFaTeQNVEpqUg6A6fzakUPTpAu2kxhm7+LlCj+nGltn3P0zRCcEqmVzV1w9JC9Gs0yehJ56J1ypUUeOKUbPVjdGQK1bB/qxkphJCoJVbmgN3Z1zzc4u4u4XWnlOYvxv2/BF6CDs90ueP6s8D/ubXI313+sihw8K4biDdPSyepw22/q6tuXwW5C+8gvAdfgIFJEY0f9CjkzyIEqaf3zTM2qjQ28UPgcpy0tRvFEV9p8cB2wyVAm9DGZMtJQeKs0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAE547F6212CEA45A3013B1D9598BEB4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5e02b8-dd5b-4e90-308e-08d837685e6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 04:47:47.1849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GfNm0s4OX0+IM8YpBqfW+j4mkwLaG6985UwWiGAH5AeKc/+tKoI0pAVNdRC4+iSZBAskzE1nuaZBFL7EXxTxrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 2, 2020, at 6:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Add a benchmark to compare performance of
>>  1) uprobe;
>>  2) user program w/o args;
>>  3) user program w/ args;
>>  4) user program w/ args on random cpu.
>>=20
>=20
> Can you please add it to the existing benchmark runner instead, e.g.,
> along the other bench_trigger benchmarks? No need to re-implement
> benchmark setup. And also that would also allow to compare existing
> ways of cheaply triggering a program vs this new _USER program?

Will try.=20

>=20
> If the performance is not significantly better than other ways, do you
> think it still makes sense to add a new BPF program type? I think
> triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be very
> nice, maybe it's possible to add that instead of a new program type?
> Either way, let's see comparison with other program triggering
> mechanisms first.

Triggering KPROBE and TRACEPOINT from bpf_prog_test_run() will be useful.=20
But I don't think they can be used instead of user program, for a couple
reasons. First, KPROBE/TRACEPOINT may be triggered by other programs=20
running in the system, so user will have to filter those noise out in
each program. Second, it is not easy to specify CPU for KPROBE/TRACEPOINT,
while this feature could be useful in many cases, e.g. get stack trace=20
on a given CPU.=20

Thanks,
Song=
