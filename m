Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56625C2AC9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbfI3XXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:23:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726425AbfI3XXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:23:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UNKALU004758;
        Mon, 30 Sep 2019 16:23:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uBjnVE+5eu3v9Bk9/sZfka5MJuclKaKRYkG+bQlkCUI=;
 b=MrNid44PaiuWv6sTY4N01lJeB0khtnvMjl+Djs0AgH+6ONahTtl5X20ET+3T2k/Nxwwd
 Ok9thHEwpSQWRWUBSkh0cy+mXygXbGr/zm7x+JmU5/9rM0pH2IT0T0RdIW2Y5kDEkuQP
 r5fdssPEt8gRKGqNzryi8rKnJqAmwPiqH98= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaq6fr00h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Sep 2019 16:23:29 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 16:23:27 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 16:23:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nv6/9sTY8NSPugvZg6KGG/YMQsJfcAeC+xosPFqMtNf+MaIiVRtjxGsHbbfxD65aXxKbBPe83eszkaU2AYyGZeRcRHhuJ5MzhBGVOrP4dCMFoeYpns3Wr+a0WNsrmYcPEQqZxD6rJQWh/vZ4gmxkROsKyzRVoYHHbK43O3UmS4qBAfjm8D1BsT10N9iFVp0AnS4iF7OtD8QPvJQbpnVlbJr38Kohr3Xnyanf4hD0mzwB+EWt4ZS+iwGDUL7x9mcw47JjrL0cM3l0dWhWWpUQJggi4/NJTSI+h43FaRwl5Y5ipDqjg75NPh9FZZ+6C7njprPaBO2U3NE/jpGuNLGFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBjnVE+5eu3v9Bk9/sZfka5MJuclKaKRYkG+bQlkCUI=;
 b=EDiYDugyQWtbczzKBDwEg/tvivE+Ce+JJ5DscQwdiT4ftAoHa9i/PKMqGJw/tpAbEI4UR9++1wOtOsyF1NHYUjqY/B0+tBS0KJ/KvyrliDxgZNTb189cLot6wt8oYBELEVqXwbcE9ifSSJLA8ekElg3B9/sfncxGlUEVb6BeTDVyevfakbSAmVIOBXz4ur0Oepcb4DZSZiJ/5cdighZiNKT44U86MbvPgyxgcgFuJGKXHsbux5mSKGd5S75e680VRYsoOuHsb5h+5wQDhL6exMAmS/hZdkyTZjVZ8ofGogGxAs5MWrPs1O7U/i2jVsTr6LQK3nYFUu7yICiM7439tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBjnVE+5eu3v9Bk9/sZfka5MJuclKaKRYkG+bQlkCUI=;
 b=LueowE6MWWIaFsh5Skzeb5KEemm/eKemvbAyd0oE54+QT5LBkwa7IytMJO9BnHjQn1wBAQnD8QWXWB+1BQLAjTLA8B8o5UJ6J084W38uzQqjVvfvabVMjBy8SvANF7r8mNJMrrxz9H15wcQXz6HyFdIw+V+jYM2bzHsjem4WwAE=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1150.namprd15.prod.outlook.com (10.175.8.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 23:23:26 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 23:23:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Topic: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Index: AQHVd8Ew888g3vk8vkOHuZyXroWL6adE1LeAgAAA84CAAAbxgA==
Date:   Mon, 30 Sep 2019 23:23:26 +0000
Message-ID: <42BABFEC-9405-45EC-8007-E5E48633CDBC@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
In-Reply-To: <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:c67b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91d48ca0-bc7c-4212-5276-08d745fd321f
x-ms-traffictypediagnostic: MWHPR15MB1150:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB11502ED9CDAA8E3796101A91B3820@MWHPR15MB1150.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(189003)(199004)(6506007)(6916009)(316002)(186003)(53546011)(486006)(66476007)(64756008)(476003)(6486002)(2616005)(76116006)(305945005)(229853002)(6436002)(46003)(66446008)(25786009)(66556008)(102836004)(446003)(54906003)(5660300002)(66946007)(256004)(11346002)(71190400001)(7736002)(71200400001)(36756003)(6246003)(86362001)(4326008)(33656002)(6512007)(14454004)(50226002)(8936002)(81166006)(81156014)(6116002)(8676002)(478600001)(2906002)(99286004)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1150;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /I7Ex0TsI6Rp461Ba9tiKd4S2LKUBPWfptM70s1z/qUN1SxG412FEP1yFMMWzkpi3rdzL5pGRCpwkJ2bgZmNicFPZGaZ3Mg5dfURbu6jt1KY4H0oBdQxiDHtYGJqW2Cj2zI+ApDh8/WvfbYBioQKpN8phOPbzgIztD0wgBClrWWce1hKxwjhgEhGqTZms1STZMCCZpyPp0s8Lk/6P1J+FPEoFyz6Ht3RvAeNc3uiRnXJb/W/AZTBOyGs+mR+hg+5Mm2s6mGnaKZqsSI46TDw5apsSPQrNytNc5yLDAVcWyLdEK3CXDKX9G20QQZepr8ZwnSSehi+mvBkzwq1AkgVGuEJoGRywD4CjbXTYcdSKNWWEK7PITf0rollXCOlquVQ71Rogrmz4urfB/M3ElSld3bGCTqXAhDNdGo3UcQxXKo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C78EED62BC3D024BB679E5F8A2FDE3AC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d48ca0-bc7c-4212-5276-08d745fd321f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 23:23:26.4691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHPHmq212euTOTkDkfk92Eh61lrDa5aVgrgWlYmupTKfsVCp0prVPWPpiowlM6laK2b85zgBemBDwPSt51WYJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1150
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_13:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 3:58 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>=20
>> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure the=
y
>>> are installed along the other libbpf headers.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
>> many +++ and ---?
>=20
> I arranged them that way because of Github sync. We don't sync
> selftests/bpf changes to Github, and it causes more churn if commits
> have a mix of libbpf and selftests changes.

Aha, I missed this point.=20

> I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
> don't worry about reviewing contents ;)

Well, we need to be careful here. As headers in a library should be=20
more stable than headers shipped with the code.=20

Here, I am a little concerned with the fact that we added BPF_CORE_READ()
to libbpf, and then changed its syntax. This is within one release, so
it is mostly OK.

Thanks,
Song

