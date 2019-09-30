Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27216C2B01
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbfI3Xjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:39:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbfI3Xjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:39:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UNcnaq013617;
        Mon, 30 Sep 2019 16:39:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Y+s39i6f4OpEBcM1rOTD6uY0jZCM/7O8gbhuWXYoDSo=;
 b=ntV83oNm2PdsJibU8fFNpl0YGizDzLVO38wTJro/s5n2lqaA+Kk6CT2UQxys0to1wV/l
 xbE8rSnvmd1vs1jgONz2MpLu5cL9Srs6WFzy674FiZBiUHAKx8aVXOX/oEIGn4/kNyHf
 KDfrY1lq7IzAQ43Nl2iiVC+A9OAIfizGwcA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaqu680vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Sep 2019 16:39:21 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 16:39:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 16:39:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swul9QbrUJwFda4HZw8WhpJyACNPg71c3/d8Lh5YvVyrHCcFdlxeULj2CwAt7EdqTEi6LXQHxJT9gjgjz6JbYvq0oKOemPaS/Gd8ZMkRpW12TLaOkuDhIoJBYcFzpI2P6vNNONeBI9pTygiFqOe1orrIDA/K6S8ikIY7eO8lqJ0XCkD9BIy30rTeoxSIkU8isMGY+GpsXHa213qYxUp6V4qyXMCpD5fzHbwDAukxdeXnTLcyz4x/33QMKzZAt1XvjnLT1qr55Zs5FV5HnRduWi/+POfFpL6Y8SjSps+NhfR7XlCdbgeoQ52aAVxq0sMwlxIMj/nyFxgnj7iASK5t7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+s39i6f4OpEBcM1rOTD6uY0jZCM/7O8gbhuWXYoDSo=;
 b=iylBKK343roJ4gPeDpVHHKZELmaIphyGgh1Pa8QulXM06cUy/z+3nXLLSPMrX1Kdu3qMZPeNh9sZQ76SgzJI/nexBQ1V/TThYPowffwdAgkKCjCpQ80yL4XbR+1xZ0RCE6Pw44ni+ETOKPP9Mg1Kfwo2AuqqTP8cx+ceLE3VHavdZtPs+1O/zPEJM+IbKGqzNLDW7Pwc3fFgbGz+Je1Z0j2IzycrQo7eQpU4S7Bj5PS1IBp2EdtvwIY5hkVSr2InsHFIKhs4BKKsXlnS556sYfaOm9Ys6F37hfOSC+7e45tYzq8n97Jlpd6BqLLunY1jKE0L6yeadeLhV+l1pwp/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+s39i6f4OpEBcM1rOTD6uY0jZCM/7O8gbhuWXYoDSo=;
 b=SHPsgP3qRPj0c+woQIhu96Cvuztlr+tld66WL6/6GiBKTPjLpNpKJRCcscQab7dWRgLchT5IDwEwnQEAgD+biYsfenypPcIdgXvGlgwWKjBXtHmpDMfo+RAIbEKZA57qb0COyLCgBu7ALHj+hn9UuteAmvl3ZbsjAx4P136UBxg=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1405.namprd15.prod.outlook.com (10.173.233.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 23:39:18 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 23:39:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Topic: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Index: AQHVd8Ew888g3vk8vkOHuZyXroWL6adE1LeAgAAA84CAAAV+AIAAAguAgAAC9oCAAADggA==
Date:   Mon, 30 Sep 2019 23:39:18 +0000
Message-ID: <B6CB1E7F-676E-43DC-8A2A-8F654440830F@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
 <20190930161814.381c9bb0@cakuba.netronome.com>
 <DC8634C7-C69D-48DA-A958-B6E7AC4F1374@fb.com>
 <20190930163609.52187526@cakuba.netronome.com>
In-Reply-To: <20190930163609.52187526@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:c67b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab3268ab-a528-4906-1a77-08d745ff6980
x-ms-traffictypediagnostic: MWHPR15MB1405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB14058AB0FA0F5CE1754F394FB3820@MWHPR15MB1405.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39860400002)(136003)(199004)(189003)(51914003)(46003)(99286004)(446003)(476003)(486006)(2616005)(76176011)(11346002)(6506007)(53546011)(81166006)(81156014)(2906002)(8936002)(50226002)(316002)(186003)(86362001)(102836004)(54906003)(5660300002)(8676002)(6116002)(256004)(478600001)(76116006)(71190400001)(33656002)(71200400001)(4326008)(14454004)(66446008)(6916009)(36756003)(66476007)(64756008)(66556008)(6436002)(66946007)(25786009)(6486002)(6512007)(305945005)(229853002)(6246003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1405;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUoe3F+p2Y86ldTjbG4XLUveP/4EBlbu7r5fZg+YNgzH7MZKvaHjafZEvM4/cHPRs9mzanrQeWD7uYM4nLPhOtvgEyP0BYQBeMiDGMXlNXUlyYustSSxAA/ZGW0M59Qu0c9g31VvIU+kLfw7GCP5v8vLofivc3iBoAHu6rG1l5c2zotbVLmZXnN4QSVWbAJTK19WQySvW92YSMBso4JDbAsomDR33OVEDoF7bMrC5w4aFrAi5Zh7qXQ/AhzZ9RcIizNohdN4YNf5aXFbg/GOvnLklgRgMRmC4dQVF0/9yiCVU5xRzf2YUzjNznWzDfDLUggqdX9oq4pbtj+TxZ6wxmk/T1hgcu6E/CoPwxPhLGa5GSwzCAhUFtp4yWkP9ORsbC6Ild/XM2yj4Cym23oH1lsGn1vqt+Y28u9KdxaXDPc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <098271637D475D4BA792AF5A468D794F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3268ab-a528-4906-1a77-08d745ff6980
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 23:39:18.2405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrkMyVJvNDalqWHPct1gjQc4As8xhp4H4g6hq7kOUPAXPXBLqUmWGMDUX1P0Y0pSsD7+/dCuxBus+jXjLYic/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_13:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 4:36 PM, Jakub Kicinski <jakub.kicinski@netronome.com=
> wrote:
>=20
> On Mon, 30 Sep 2019 23:25:33 +0000, Song Liu wrote:
>>> On Sep 30, 2019, at 4:18 PM, Jakub Kicinski <jakub.kicinski@netronome.c=
om> wrote:
>>>=20
>>> On Mon, 30 Sep 2019 15:58:35 -0700, Andrii Nakryiko wrote: =20
>>>> On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrot=
e: =20
>>>>>=20
>>>>> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrot=
e:   =20
>>>>>>=20
>>>>>> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure =
they
>>>>>> are installed along the other libbpf headers.
>>>>>>=20
>>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>   =20
>>>>>=20
>>>>> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead o=
f
>>>>> many +++ and ---?   =20
>>>>=20
>>>> I arranged them that way because of Github sync. We don't sync
>>>> selftests/bpf changes to Github, and it causes more churn if commits
>>>> have a mix of libbpf and selftests changes.
>>>>=20
>>>> I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
>>>> don't worry about reviewing contents ;) =20
>>>=20
>>> I thought we were over this :/ Please merge the patches. =20
>>=20
>> Andrii changed syntax for BPF_CORE_READ(). I guess that is new?
>=20
> I meant the battle to not split changes into harder to review, and less
> logical form based on what some random, never review upstream script
> can or cannot do :)
>=20
> I was responding to the "don't worry about reviewing contents" - as you
> pointed out git would just generate a move..

Yeah, I got your actual point a few minutes later.=20

Thanks for the clarification. :)
Song=
