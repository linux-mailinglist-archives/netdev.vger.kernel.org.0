Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC172763C3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIWWYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:24:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgIWWYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:24:11 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NMNoJA011206;
        Wed, 23 Sep 2020 15:23:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4OxZfWqxeuhtr4kU576BadHFP1HTc8ZslFgxoVOey0E=;
 b=OlNfL3uTeYfGWyzCmf/qkrB0efW7Zrn8Het868hfCNcTI1vBXo3EiGTYNv9r3HNHa2BI
 AfrJAuGiBOG5y9IdHvPiIm636PpyFVFxXaWjnz3KaiPt8vCsPFezPbCjXSxcF+qYTqNY
 Jnm/BRcYZFFzE51B/RZatlab/pm/FkeV0M4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp5xfj8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 15:23:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 15:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ghl1+daosp8pwmt9CxAeKp/0y+9rq9oV7EeHXuaj6Vz81W0OikB3LIoGV9qaYh1wZmr5EAwJqQsdcJ9fikIzpgNUXlRuoySZ5i4CyDZO2NJlOFIoas08B4QCaHkVueeRYTrTwbQ1AFqq4VzNlo7JaqT7ru9HcScEgv+0pMYGm0ekOg539ncrBFShaXngaFGJVATR2VpEwynxSp+h1YbuS4zVzmRRtQHtmuRoJtOj6ez0NRum8XeicJohZqui2DWmO3nNT8MBw/EmOooBMAMw4B0OkEMY/tCsF2P6VLX8dQwardHNbovcxeIs1V9yIzFGt17BL6Yih03s841JFU5GGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OxZfWqxeuhtr4kU576BadHFP1HTc8ZslFgxoVOey0E=;
 b=dJjC2WV+/KJePfOnQ4uEPw7sAhUfC6PC06hlMFP+l6lhXXTfQBJDLThIBOnwsvueje1uwxy9K2nfYA4xg6pGy2jvyRzeFfPte51gKbUJ0LC94xBDbefIMLwZ9zZdKCVyVW2ENydwYXtCk9NmA8gz6Op52pXeitLDI0t7neEdnNDGtf4aAG5IxUMrNmjhWo8xaVhXYIdk0b2KeJ8C4+P9fWT8CmVU/2VsZCMAM61JJOIKZl5s0aUsi8ocOX0mh1zDLtZPah76G38bZVCAty1XjqzPbbhagJH+llBrvMC0YDegJOdbOh5N68Az2PmEb3sWICNuYtOUI/I533PHksbV+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OxZfWqxeuhtr4kU576BadHFP1HTc8ZslFgxoVOey0E=;
 b=Pn1YKJZ8ACdeYRMaxrNM+YlvHSNZIBX0ZF0Xs8fY7m3WLLuvfOCBbiR1Ue+i7WH2sy2yJruA60Kj05w9U8hhgy3j/29U2lk2fOMrPQPv6h7JKpdH6Bfir09k7PiGNb9rIjbLzupebUGIlDBlEVn06Lm3eAWWWOHSHDZa5fGwPAk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Wed, 23 Sep
 2020 22:23:51 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:23:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: Keep bpf-next always open
Thread-Topic: Keep bpf-next always open
Thread-Index: AQHWke9TdhzHEmJVCkirb8f/NEp9R6l2wqcAgAAHOYCAAAKtAA==
Date:   Wed, 23 Sep 2020 22:23:51 +0000
Message-ID: <7DAA1D76-860C-4058-9D5F-7A87DB45B8C8@fb.com>
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
 <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
 <20200923221415.jxy6hcpqusodpqsr@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200923221415.jxy6hcpqusodpqsr@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92a6a655-a5aa-4a7e-ff9e-08d8600f5991
x-ms-traffictypediagnostic: BYAPR15MB2567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2567D53BAEBB499E8CE5D55FB3380@BYAPR15MB2567.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ii0paYGcqr+wzL/4WV6hYUdPayheV6SuTY4ZGb2Knyh+XcBn5F5wol3bQR75m9w6gFTIjHLeEgxvZmIn0SD2TWc5cPNh9zvUyTFHmDp0ypUgy/+EmrQ0gsHer1eElQayMnBv1D5tqi0o4RoIVMSKRfC5qepP4ZJXyJujJaz4nYkHOnvb7/Gz2MEHIZmYT9ojTpg3T/fwF8I8yAS44h2zWHFCPmpjdlyLdYQ/iS1VkmVAEUq3J2rKUbzjODvAL5TxO97Fqd5CAcRwuiwFBFXn291+UjUvq4q6jPpbpt2NuWeaPDanGGeZYY/hAEYcSqGtWH/indSfCw7R+xMTJUWyMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(76116006)(66946007)(64756008)(91956017)(6916009)(66446008)(3480700007)(36756003)(186003)(2616005)(86362001)(71200400001)(83380400001)(2906002)(8936002)(6486002)(33656002)(53546011)(66556008)(66476007)(6512007)(316002)(6506007)(4326008)(5660300002)(8676002)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: QvCzA3sMydpViAYumaL+qN6ll8paDJmxe5jd+zMr9Xx0JSGUmWk9r5r+wJixdV/ZBgq+kvcPQN+BsXdgXPYtZOO3esd3PGSVbW/AGl71/tDwB3UxaxxCYGRwv3K1JBdnF8ig1bI2rqRMi5Fp0EhI7lesUioxoOtoUQMcJkVozLg8bU1Sq6nqgdyPStresqMlbTFIFlu9EYZs4VXVAWKlZgizu3h5cW/t2Ljd4WTK6L1kdhfhfFN3NQ5rhiXfF8fDZb8a3KzFeMX7aenWxwQ29QDDg1jWsgG8PayM+l5xTtKrRjSB5Ej1Las9t4NOvh4IBeqH6q5Dxxaw5eM0ZTQcGt/YCyJbp0pSpM9CcLyXKhbVyp7CelnWn7TDBafoCikqU/ipLboeo+C/SoIGkJn1xIvmIHLAVYIRPvk857y4AJTqcYexCdyRtZ7txmb86VzCrORUdZf8ky7WZP4lLuL/r/DpnLaruVgemfgAVRQD99J3hxDVIirJ7/giMwPj5gcKFZ3pHcnP1Ke2FvpXOvClLOVBgXs2EYRENK3kLC3xsDK8dR2x81O3gFC7s0vJ+WgekVR+vhQzfnwVT29JBuWewpb5tYYyTcADd2Nb9QMSgk6Zh10yHrIHsd7DNsNEsZuPf439Wz5fRo2sZI+8zt5k+1UDeHK4OnHLb6jzMuiuiiK3pQI3M8jb4SwGjuOYwjih
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFBA854699EB604EB232E1878B2D5A62@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a6a655-a5aa-4a7e-ff9e-08d8600f5991
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:23:51.5072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/JhQiJTMg5Wg2cYIWRz7HadIuYEYzyVWw2FSKtU7d9UCGiqk/anPJ0D9GY7uozS/LLjwcpTCaKlGm1s5h3VeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230169
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 3:14 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Wed, Sep 23, 2020 at 02:48:24PM -0700, Andrii Nakryiko wrote:
>> On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>>=20
>>> BPF developers,
>>>=20
>>> The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the =
past we
>>> observed a rush of patches to get in before bpf-next closes for the dur=
ation of
>>> the merge window. Then there is a flood of patches right after bpf-next
>>> reopens. Both periods create unnecessary tension for developers and mai=
ntainers.
>>> In order to mitigate these issues we're planning to keep bpf-next open
>>> during upcoming merge window and if this experiment works out we will k=
eep
>>> doing it in the future. The problem that bpf-next cannot be fully open,=
 since
>>> during the merge window lots of trees get pulled by Linus with inevitab=
le bugs
>>> and conflicts. The merge window is the time to fix bugs that got expose=
d
>>> because of merges and because more people test torvalds/linux.git than
>>> bpf/bpf-next.git.
>>>=20
>>> Hence starting roughly one week before the merge window few risky patch=
es will
>>> be applied to the 'next' branch in the bpf-next tree instead of
>>=20
>> Riskiness would be up to maintainers to determine or should we mark
>> patches with a different tag (bpf-next-next?) explicitly?
>=20
> "Risky" in a sense of needing a revert. The bpf tree and two plus -rc1 to=
 -rc7
> weeks should be enough to address any issues except the most fundamental =
ones.
> Something like the recent bpf_tail_call support in subprograms I would co=
nsider
> for the "next" branch if it was posted a day before the merge window.
> In practice, I suspect, such cases will be rare.
>=20
> I think bpf-next-next tag should not be used. All features are for [bpf-n=
ext].
> Fixes are for [bpf]. The bpf-next/next is a temporary parking place for p=
atches
> while the merge window is ongoing.

I wonder whether we can move/rename the branch around so that the developer=
s can=20
always base their work on bpf-next/master. Something like:

Long before merge window for 5.15:=09
We only have bpf-next/master

1 week before merge window for 5.15:=09
Clone bpf-next/master as bpf-next/for-5.15

From -1 week to the end of merge window
Risky features only goes to bpf-next/master, bug fix goes in both master an=
d for-5.15

After merge window:
Fast forward bpf-next/master based on net-next. Deprecate for-5.15.

Would this work?=20

Thanks,
Song

					=20

