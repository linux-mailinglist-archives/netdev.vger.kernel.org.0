Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1A5DA8E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfGCBRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:17:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51318 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbfGCBRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:17:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62NlW42012927;
        Tue, 2 Jul 2019 16:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JA6Ux3g7UbVB9PPNR905vQAYHuYo1ioH1lR1bEgTsvY=;
 b=NLy+7iUdTFgSyQ/Yc+8q0v6DMuDYKbgc+zt7nOwRCCO+y0GK0erw4S2n7MMsMUYqwHPt
 rAN5r2PWEq6ZGEST7vojejaeEcFV4H6MCyGgKYKEBwZg7i/5tKtPy82FRM6WPSELwrRg
 VC0y/2XV0WX6LHXEnPOogSo8T12P39kqOOo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tga64st1b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 16:48:31 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 16:48:29 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 16:48:29 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 16:48:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JA6Ux3g7UbVB9PPNR905vQAYHuYo1ioH1lR1bEgTsvY=;
 b=ff+hjI2nBtW8dTfDUvZ47vPafdZPsxI2iEI31yDgJoqbN35daGHYEIj6wBEcZlk1d34fnwA14SZzgafkNEirphGn3CRQfvSICgFE+8QOvDq9B3WFlBVe//bj0kboLtFDCZwSSuRpCmb6hlXAsGtr6V3ayinfR0YnmmbNICZFIq0=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1742.namprd15.prod.outlook.com (10.174.100.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 23:48:28 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::c804:a8f3:8e8b:3311]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::c804:a8f3:8e8b:3311%8]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 23:48:28 +0000
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
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgAAmF4A=
Date:   Tue, 2 Jul 2019 23:48:28 +0000
Message-ID: <69E09581-78ED-45A9-BD2C-616A3620BCB0@fb.com>
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
x-originating-ip: [199.201.67.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 113b3a82-db04-4826-f9c4-08d6ff47c824
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1742;
x-ms-traffictypediagnostic: MWHPR15MB1742:
x-microsoft-antispam-prvs: <MWHPR15MB17424ADE63133954B2F236BCB3F80@MWHPR15MB1742.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(376002)(346002)(189003)(199004)(51444003)(5660300002)(33656002)(186003)(6246003)(76176011)(68736007)(57306001)(50226002)(14444005)(6486002)(99286004)(2616005)(26005)(14454004)(11346002)(54906003)(36756003)(66946007)(446003)(66476007)(66556008)(64756008)(66446008)(256004)(486006)(476003)(102836004)(86362001)(6436002)(478600001)(53546011)(6506007)(229853002)(6512007)(81166006)(3846002)(76116006)(6916009)(8676002)(71190400001)(7736002)(66066001)(73956011)(2906002)(71200400001)(4326008)(6116002)(25786009)(53936002)(8936002)(316002)(305945005)(81156014)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1742;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jnp8MX3oCtYuHMBdWReMat9mrHwzuXntwzGxA/JoTty4DMgPmf9qYkfNC1WRfbty/GzkZlorq5IIVa1doHmChHuqsC/6ho5aAKAJh96zDz1xMlvUB3+rgxhUmjHjOXIh0yAmX7ZibB+T46Uc69gQKpEjjY7A7THhz0BAa4ijcnBGtt9Y7HLnVrgwk7ywSCcyOfMRLQy6hi5Wk4eKQwoJY7qgtnx9V9xK3pAXakq1g3et6phaia8nCmEAUz8wOB7towSUXCSlrSGUmkbq4CQ0i7d+TONs7b4ESBAfvMlXGLDzZcepQXC9LcJRQ8XYBC3vBHGZ/aBjgehcY2Gbpz5ed2HibSl5HyebPzm4PhufExU95XNPdvWi7FuClOvUzf38qqLTAR3HBene/v/S0wab0wAAdVGVfd/u6mKq1K8vIuQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB5FF07740E23E4E8327F92A60277096@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 113b3a82-db04-4826-f9c4-08d6ff47c824
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 23:48:28.4190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1742
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=847 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020266
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 3, 2019, at 5:32 AM, Andy Lutomirski <luto@kernel.org> wrote:
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

Thanks everyone again for great inputs. We will discuss this again and=20
respin the set.=20

Best,
Song
