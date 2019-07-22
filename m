Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46570AE1
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfGVUyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:54:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14168 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727547AbfGVUyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 16:54:19 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6MKriwm028703;
        Mon, 22 Jul 2019 13:53:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=whAF+O3w6LYWAes4Vy/AuKxXLr4XzJzTvVwyAyP9nBw=;
 b=PYIAp+i7HA3W1HeDiZqq59+GeRXWeHj7ZP3vMoaUxqevY/4PsqPwpBLOGZ51Va2oAMFi
 M12s5flYOfYhiC2FpIvdqkMZarWeC1f5L88Ylvju+AZwB5KyXKn0n78ZLNaR6acd0gzY
 n+IGCB4SZU0WlCYE0rSJgzUVdY4knXu9rzU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twfxes6gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jul 2019 13:53:52 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 22 Jul 2019 13:53:50 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 22 Jul 2019 13:53:50 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 22 Jul 2019 13:53:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfjLlllJw7JcTDCfFbJDg29R9zY7f5l3bUAiXBe2a50TtnZoG25VA+S5+hSXb47iIkH1CiJjy8td0z9s4f5YmTTxSHkW/r9w8+1++sAv1YuEXJNEa8pkfoeQOzStoSVCZPieD6AprB1GYKFKZGaJpSMql20RpbpPWNCLZiQtXUaN3AJ/9GYSjCORhdZ5BKDwyK4hYRl1/C4BPLhINQ52FC8bC7DpIbgnHSCRAAg0/tb0C++aLLnaKMiZfondoeXd92I40bsUh6Yhqg/4AELzSri5Z3ZCB0gq1/TVVcXtpDxVKDNWGL4zfTv9Lvhn/FnLx1imHwyDmzbeT68aAMLj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whAF+O3w6LYWAes4Vy/AuKxXLr4XzJzTvVwyAyP9nBw=;
 b=UN+N0823A1Hl0qizYSHci7paeGFuIEliZ6bx+tP2jI+IdXDQdfMy43zRb9PgFAVdUaE3sB3t3ANLWnMp1/rXYJfle3hDcV25aEFcG1L54sFFd2UIjpmziB0Z7ehyBMOf1EkidZo+/l8j/cuJSQwyKEPHhK0TuBfgW9598wtfspQIWdFhI1AERLeOhqbb+vsm5j/8xzeMiIUH6zabVsxZ9UXHhjY7i3sZ/al/sCLDsMQp1rRq3EN1Us+7m6sm9vSeKyq282rvDA8E4i1glUtaf96hQaLguwFHGkXSEghcFw1Te7w6oG+URdiiWNGtlngpJO75mi2TMt0+c11W82MyiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whAF+O3w6LYWAes4Vy/AuKxXLr4XzJzTvVwyAyP9nBw=;
 b=BC7P3SGUDffuXtYjFT8JcEqsHrQ2KI0QjBtVkV8+HrugRpwfAbz59UPWQus+hUeFRaCW5iOPioTjpEnGngY6anBBmaXFYoSR/Mr3lZChIL9VUSoTgA6GdwybvxpOxHyXlCwY5S/S13cD5xJcEH+plcbxpkBr/QZAzhkelHaFv1I=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1870.namprd15.prod.outlook.com (10.174.96.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Mon, 22 Jul 2019 20:53:49 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 20:53:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wA=
Date:   Mon, 22 Jul 2019 20:53:48 +0000
Message-ID: <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
In-Reply-To: <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:c799]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d50729da-4313-4458-41c8-08d70ee6b23f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1870;
x-ms-traffictypediagnostic: MWHPR15MB1870:
x-microsoft-antispam-prvs: <MWHPR15MB1870741EC841E05EF49C1448B3C40@MWHPR15MB1870.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(366004)(39860400002)(51444003)(199004)(189003)(7416002)(99286004)(6916009)(50226002)(57306001)(478600001)(68736007)(66946007)(76116006)(229853002)(8936002)(256004)(7736002)(14444005)(305945005)(71190400001)(71200400001)(25786009)(6116002)(14454004)(486006)(446003)(476003)(2616005)(81166006)(8676002)(81156014)(11346002)(33656002)(102836004)(186003)(86362001)(6512007)(316002)(6486002)(6506007)(46003)(36756003)(54906003)(76176011)(4326008)(5660300002)(6436002)(66556008)(66446008)(64756008)(6246003)(2906002)(53936002)(66476007)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1870;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C+Yl1rKXCoxfcTCvlc62/L+pbPhpGvCHMOW1q9FpajfHsnoRb/Hwq7mG4qcgUyk0xrPo54QG6mK1B5pTeBy0YEIsoEIxOBQBTFA55yeQzhvcUqrWQGC2DGGOb+iUEhRfMfagcwRQhhtRJD+uHZfLeSYUyKMbYBLPw5vVQutGe3e+RHm25Kyi4BDS+HQYtUThP/1tRRW5Fftkvriuu7uqyiQFiVQW9YTqqC/FMlveKc+uWeQZLPwMW50jF3Uqf3eGv7p0sfxH2HgZM4T2l9/QlKZgYkKX8n6WEn87SFUDrwVVP2ZiQ/8ALmqSSpevIdKCOxUbsweBnjlkvICr47NAZq6ySgVScqQgamj5Rq1p/FeXiKm5/G99D0wxM+/8WXqe94kw1a/hs8+sKupitGgJaA+ps67N5SVHw30gTNqWd+c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4934353FD63ADE4698F42238323400FC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d50729da-4313-4458-41c8-08d70ee6b23f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 20:53:49.0530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1870
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-22_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907220230
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, Lorenz, and all,=20

> On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
>>=20
>> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
>>> I think I'm understanding your motivation.  You're not trying to make
>>> bpf() generically usable without privilege -- you're trying to create
>>> a way to allow certain users to access dangerous bpf functionality
>>> within some limits.
>>>=20
>>> That's a perfectly fine goal, but I think you're reinventing the
>>> wheel, and the wheel you're reinventing is quite complicated and
>>> already exists.  I think you should teach bpftool to be secure when
>>> installed setuid root or with fscaps enabled and put your policy in
>>> bpftool.  If you want to harden this a little bit, it would seem
>>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
>>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
>>> capabilities that they currently check.
>>=20
>> If finer grained controls are wanted, it does seem like the /dev/bpf
>> path makes the most sense. open, request abilities, use fd. The open can
>> be mediated by DAC and LSM. The request can be mediated by LSM. This
>> provides a way to add policy at the LSM level and at the tool level.
>> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owned
>> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
>> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>>=20
>> With only a new CAP, you don't get the fine-grained controls. (The
>> "request abilities" part is the key there.)
>=20
> Sure you do: the effective set.  It has somewhat bizarre defaults, but
> I don't think that's a real problem.  Also, this wouldn't be like
> CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
>=20
> I think that a /dev capability-like object isn't totally nuts, but I
> think we should do it well, and this patch doesn't really achieve
> that.  But I don't think bpf wants fine-grained controls like this at
> all -- as I pointed upthread, a fine-grained solution really wants
> different treatment for the different capable() checks, and a bunch of
> them won't resemble capabilities or /dev/bpf at all.

With 5.3-rc1 out, I am back on this. :)

How about we modify the set as:
  1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.=20
  2. Better handling of capable() calls through bpf code. I guess the
     biggest problem here is is_priv in verifier.c:bpf_check().=20

With this approach, we will be able to pass the fd around, so it should=20
also solve problem for Go.=20

Please let me know your comments/suggestions on this direction.=20

Thanks,
Song

