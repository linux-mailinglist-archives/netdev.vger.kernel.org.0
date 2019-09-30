Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47FDC2AFA
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbfI3XgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:36:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbfI3XgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:36:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UNZkdS027433;
        Mon, 30 Sep 2019 16:35:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iOr7xg7hMGpe14rHqnEIStqdWevyX+KvWpCV1WAvsZQ=;
 b=YkZCsH3vMkz/vAc5dxbyCf6pGM7oyw+wECkwQ6bVikR1S5L7Zi5yLNAZMlJ03rCtKSyi
 /zFby9APjeavLhHLJQ8BGS772GUU3yVE/KhIFUCs2KYXQYyKUfE5tWYjnKIrkEQxXi4l
 66iDvN0eiM+0jsjiVK5oVXPPy691bRFvsO4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaq9pg29x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 16:35:48 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 16:35:37 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 16:35:37 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 16:35:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdtKWoKNtB03WlPjVpCs2yIDYHVMNybD2L2A/miOAH8yZLG9K/yUgb+vk3EGxPAApfDCZN1BRJ0080BLUebLHK7Rf/EDBhe1h5MaWAdp8VHu7o1jPxGt9y4XFNdoGZ9lxn2Ztt2pv6IiqDpbaTnsE/KaMY8c5r52mBj8slFPjKtYD2i1RnozaugR11mhCijPAP4wJKzx9C9VMsBAkp3gqXFs5xQgP6kBD5El9zQMqjIam9TQA0Rupq+wgtpR4hax3hHQB3wQFurAz4Bst4OaZIe4+WLjXnmLCuBCK/GXcvNc2/cev2s7zsLo+Zl8sDa/kVO8eFncXizbSbRiVRCeZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOr7xg7hMGpe14rHqnEIStqdWevyX+KvWpCV1WAvsZQ=;
 b=kZjJ9N7P/PDXFaWOM9Wqb0bM/4gByo56jZyWFBFGT6XCxt6qYU1+GW4b39zsoYo7XzV4EQkFVZMUwn8y5ytOAnyJN/XaugQMI9jL7OoUEiioa3gAYc3rAF5rL7xt/V79V2VaPJ9Up5ptwqoomQGAcKyiIIw/J3YIZ4Oz6EZr9ftH79MiJBiTrV6mQzZrqOIavBl2yL8iUdNEyjy6Vj4ZJqyRA8mLALzvbC41dj25MWH8nE3YtOEv9oSbM8/ZwvrrVi2AoIwYYhM84JeQGBw0/5JHXEVcDR6ZjJ6a+wXb2kejmp4R6ZlWZlJakYgfHQ5z5rbRyRCHz3Rc/ZfLuLQF1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOr7xg7hMGpe14rHqnEIStqdWevyX+KvWpCV1WAvsZQ=;
 b=Z80XHbcmYBS9zjKg0kFXkQhEXyAVf/2X4qkhGh7y37jcwVc8VIQAxCMOj/bqYsTLnzlXDadtUuN6ETdPPTu1tPbgzo5lSsdGGUREYLwyoMyhqaQYuvdjxTbfE9tidRh7aaGnNc15fsQK7V8w2UxGi03iuyimrZf0SpolJH1BHLI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1278.namprd15.prod.outlook.com (10.175.3.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Mon, 30 Sep 2019 23:35:36 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 23:35:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Topic: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Index: AQHVd8Ew888g3vk8vkOHuZyXroWL6adE1LeAgAAA84CAAAbxgIAAASWAgAACQYA=
Date:   Mon, 30 Sep 2019 23:35:36 +0000
Message-ID: <DDE6EAC2-EB86-4A21-9AF7-D74E1538E87D@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
 <42BABFEC-9405-45EC-8007-E5E48633CDBC@fb.com>
 <CAEf4BzbaSJ_-9fWWLyaHGHaMhVD_49UTpJQ6Kr4FTYotCupXwQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbaSJ_-9fWWLyaHGHaMhVD_49UTpJQ6Kr4FTYotCupXwQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:c67b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cbfa864-7bce-43e4-3b70-08d745fee54d
x-ms-traffictypediagnostic: MWHPR15MB1278:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1278785D53909F9D5AF4BC80B3820@MWHPR15MB1278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(136003)(346002)(39860400002)(199004)(189003)(305945005)(54906003)(71200400001)(478600001)(36756003)(6916009)(186003)(76116006)(11346002)(66556008)(2616005)(476003)(64756008)(66446008)(66476007)(25786009)(50226002)(446003)(5660300002)(46003)(66946007)(71190400001)(33656002)(14454004)(486006)(256004)(6246003)(76176011)(81166006)(81156014)(6506007)(6486002)(86362001)(6512007)(6436002)(2906002)(4326008)(6116002)(229853002)(53546011)(99286004)(316002)(8936002)(7736002)(8676002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1278;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kit87yvPzCsHdF5VeiLGeo5n6xj/rNVRLDTsYVJAt76DKkkLZoOT+3Qtyz2NMailDalN03CjKtNCngv/iG5Wn1I3s3woihPt7gx+FJsSdLB+Frfsl3VWoPchT9s/XH7r3VI00Mx2b1qCsCnbnBfOOuqwYfNWJ0l8vowu7HGCoMk5V/N+C902QuSXtF+NxOYlNaXTaVpG8wAruloxijSkIth63Ww0YR3d8Iffi7XCG3kh/g5KoKittKVw9CiQFqtUEJFeDY0HaqdAmGTod1FgMHdgMuQuIau5G9LhsYLc4kAL7fPcpOHRNDP92SYrOSm7JOzTJdbEgDybbXSD/NqCFr4yfiOFErcchkjf4Hpj+/Q6uwadO6iwrXIR0WZwr50Hl0XTC1XK41S8sxcPcwh92sR1PIajdftEG3DcpCbB3dI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0875BF8478BDF24380F209F0EAC979F7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbfa864-7bce-43e4-3b70-08d745fee54d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 23:35:36.5718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hg1w5Yx4SC+2MeT5juioDodupYGrdNAm86haf4+Lx1BXb4gCSf7hlCps0Vx4NEckNOKP9T5axa6iMY8BPAt9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_13:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 4:27 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Mon, Sep 30, 2019 at 4:23 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Sep 30, 2019, at 3:58 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote=
:
>>>>=20
>>>> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote=
:
>>>>>=20
>>>>> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure t=
hey
>>>>> are installed along the other libbpf headers.
>>>>>=20
>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>=20
>>>> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
>>>> many +++ and ---?
>>>=20
>>> I arranged them that way because of Github sync. We don't sync
>>> selftests/bpf changes to Github, and it causes more churn if commits
>>> have a mix of libbpf and selftests changes.
>>=20
>> Aha, I missed this point.
>>=20
>>> I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
>>> don't worry about reviewing contents ;)
>>=20
>> Well, we need to be careful here. As headers in a library should be
>> more stable than headers shipped with the code.
>>=20
>> Here, I am a little concerned with the fact that we added BPF_CORE_READ(=
)
>> to libbpf, and then changed its syntax. This is within one release, so
>> it is mostly OK.
>=20
> Well, I could bundle bpf_helpers move and fixing up selftests in one
> commit, but I think it just makes commit unnecessarily big and
> convoluted. BPF_CORE_READ in previous form was ever only used by
> selftests, so it was never "released" per se, so it seems fine to do
> it this way, but let me know if you disagree.

A better approach is to modify BPF_CORE_READ in selftests before moving
it to libbpf. But I am ok with current approach as-is.=20

Song


