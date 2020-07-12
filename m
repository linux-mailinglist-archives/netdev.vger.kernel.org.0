Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9AB21C7C2
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 08:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGLGfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 02:35:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbgGLGfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 02:35:15 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06C6SdrS005872;
        Sat, 11 Jul 2020 23:34:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6nRA6KXSUTq0LaCj5pUztlRS30K4+bqoYnVjPEOyQTE=;
 b=IukzPW0C7aED2Z2MvELiaACgb5DVYj2Leh7FO42n7Hip/OsaopcRUVPmCYjSlM6soUT4
 lg061+qC+vtaGWoEgzr32kTosO2w1iodbznFA6mn+MD1RqrXcfgWX1E+Xkk4e/YiEaww
 YXfEKKCQt/ClCOgykVZHoHXYzoHb8Jn++Rg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 327cquanp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Jul 2020 23:34:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 11 Jul 2020 23:34:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV4feEtsyAycsyDwLxwXkdKwIVsrzgUZTOzN6lYw8Pr7oL+yuo3frg/knYMkm9/7yZqsaXCGC3TwpZMtJLPF5UI36JK0RbQlFUgcTwDe3zd3sFZTL5Oq0fJNHpIlu4RKNTC7skhA8nPT5RI8s/akBd/mvjmsLkWNfYzXiJRNIoVdsbC7w73aRvVaAOOENNvp2stR35RjJX90YiNT0Jqx/+Oozro6WCDCp2NhpESfoeTfqxk0RzdLkaVRWD8TSmaS0Qwq7BzO3jaqGVWWIOXguc5tFtcyEqjsjwtyaGsciqByE7kWDooh5e6cQBLf3BOni8Hb3pUhsVl/0VaaRx2i1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nRA6KXSUTq0LaCj5pUztlRS30K4+bqoYnVjPEOyQTE=;
 b=MfQQGszW8bns3cOgxjpcaffETYmaoJ0bC1bdbegqZvgeipbsha0C4zj+7YvweyHDgD3irwoLCh/koeMd41nM0GKJErVAy0vaRqHT8PB+x6lHKDFcVIOKx3K+BB9k52Sse+15Oo79cgI8m052gH0KcKdECu8XESUynrdMp++L7WpSDSBGrtUtPnIoHr1ENO5H+hjgWKKVvFOwZ6qnjLGW6+jPc0262ZqT2r6IZSNGYlOJrdyYbTk/K2t4WPsFVMicYWtFWhNd/FsFg+D7mAyvd6AW+WBacoBGGz967EK3dpoUmyKXQRETQ7vnkxb9eSlyxQJWnRkikGYH+jJh2jGxlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nRA6KXSUTq0LaCj5pUztlRS30K4+bqoYnVjPEOyQTE=;
 b=a+IDfO9W1KbB2WCmm5DI3TnESUu8Xnb7PuC9mR3f00JBwkQ2HmXU9wsiVE2rNd4xQ1t5J8j9YdL5+iAVgdoYtXy08aZn74KYD24eeA1bDTIqiTvPMqYlbSKYXyXQ7ScNHx3cpOcLiDiKWbAf2a5QdtaChNgMJby1ZWOhLHbI6LU=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 06:34:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 06:34:31 +0000
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
        Peter Ziljstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
Thread-Topic: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
Thread-Index: AQHWVyKzhisy7cu33UCexze8SbKGKKkBv0iAgAArfwCAAXttgIAAGIQA
Date:   Sun, 12 Jul 2020 06:34:31 +0000
Message-ID: <34E0EF7C-A247-4C6D-9C16-CDD29F20C7EF@fb.com>
References: <20200711012639.3429622-1-songliubraving@fb.com>
 <20200711012639.3429622-2-songliubraving@fb.com>
 <CAEf4BzaHAFNdEPp38ZnKOYTy3CfRCwaxDykS_Xir_VqDm0Kiug@mail.gmail.com>
 <DEF050B0-E423-4442-9C95-02FB20F6BA57@fb.com>
 <CAEf4Bzbur1KBM3aPMMtQmsYXbHTfwsx4ULbNxpzR-DF7g=HDeA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbur1KBM3aPMMtQmsYXbHTfwsx4ULbNxpzR-DF7g=HDeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f0b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cbedc39-1931-452f-65ad-08d8262da2bf
x-ms-traffictypediagnostic: BYAPR15MB2199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2199B89895CAD4370FF588A2B3630@BYAPR15MB2199.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bo4BVYGM2Ev7A9VyvBvWgTQVtJORmQtQkM95M1skYiVeVJeFrUqPHeO/2GyydMS+JC57hCqRXwumZ+tmEOU4V8A0xzHRVAT6e5fLNouLL6H4klDsAKqMF+5Xh1C7zPm6yTv++Ey5BXtsvyc6N0VTAd+r1WyMB8sBgPzqf/pt0Fv8T11paZ6WEQXldhpmuZW0cgWpooDiFR4nFqYA/fgnVT7BvSLCDVuzBFagDDptA5K9aHrVMWuyyhoMJhtxirzUYAgp484h7oF+B7iTrU/pJzzhr73LaIZTQNteXmOQ7ZrNG5e/jee6o4FavVXZbuZ7nZ5uA98FLqpPb/ni/U1fNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(76116006)(66946007)(8936002)(66556008)(64756008)(66476007)(6512007)(66446008)(36756003)(71200400001)(478600001)(186003)(4326008)(6916009)(7416002)(8676002)(54906003)(33656002)(6506007)(6486002)(83380400001)(5660300002)(316002)(86362001)(2616005)(53546011)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: d98Z+zU0K33F+k9dVxJYUYyNFbx0SwPgCnESYCwqkUKWGBZxCvGpB1R+YlXnqr07PxA0cufeZUHQiZGjjMuPYVNis9ZDJpKtXDmPBDSqOoE6iqO76yiqu0BxQ0BPN9DazBD7A6ierKx0eesS829+glOyuktrZIuto7lDT9fdmU44P3p/CNd8onqRnC6zv37XeYRLIhxqir1HnD4OB2Bmac/fBNVL6incXdjoGsCem/k5vk00XD80X/lBf2zvLjxEgQLnoJC+t0rxKTi7Jrj5x7LDnpy/lD/FM/XtS7uRU47vt2k30mG+No2BBNgAq2dZ9xjVluqJ5kpBWieGXwdzcN9wQYGSYWOQ4Khy+vYj1s941FNrqs+oLT3cA1Wv4Furk8mmFE/4c3HbKN58v3Q6rtnyS6aTeebgWe9gsrilr91mfqDnU3zQ2d/ciQgmCZoqAVLy122wq/tLyX4f6A6vNxXPCmMEIoHhpQAp6DkcPaQxC0vVEX7X/5f6qmi7j6tPUHOmUZrZdSq6gReo3rbHcw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B80A221B7AA0B4F8A96977335AD04A7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbedc39-1931-452f-65ad-08d8262da2bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2020 06:34:31.7032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nKqrEfX/FCJa4Gf7IUfdJa0/c4pskIrgwWSAE6a79A9eG7cmmIli4+dJ/xE0/xPgW1X10YQekamWuXnZ231MfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-11_17:2020-07-10,2020-07-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007120050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 11, 2020, at 10:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Fri, Jul 10, 2020 at 11:28 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 10, 2020, at 8:53 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Fri, Jul 10, 2020 at 6:30 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Calling get_perf_callchain() on perf_events from PEBS entries may caus=
e
>>>> unwinder errors. To fix this issue, the callchain is fetched early. Su=
ch
>>>> perf_events are marked with __PERF_SAMPLE_CALLCHAIN_EARLY.
>>>>=20
>>>> Similarly, calling bpf_get_[stack|stackid] on perf_events from PEBS ma=
y
>>>> also cause unwinder errors. To fix this, block bpf_get_[stack|stackid]=
 on
>>>> these perf_events. Unfortunately, bpf verifier cannot tell whether the
>>>> program will be attached to perf_event with PEBS entries. Therefore,
>>>> block such programs during ioctl(PERF_EVENT_IOC_SET_BPF).
>>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>=20
>>> Perhaps it's a stupid question, but why bpf_get_stack/bpf_get_stackid
>>> can't figure out automatically that they are called from
>>> __PERF_SAMPLE_CALLCHAIN_EARLY perf event and use different callchain,
>>> if necessary?
>>>=20
>>> It is quite suboptimal from a user experience point of view to require
>>> two different BPF helpers depending on PEBS or non-PEBS perf events.
>>=20
>> I am not aware of an easy way to tell the difference in bpf_get_stack.
>> But I do agree that would be much better.
>>=20
>=20
> Hm... Looking a bit more how all this is tied together in the kernel,
> I think it's actually quite easy. So, for perf_event BPF program type:
>=20
> 1. return a special prototype for bpf_get_stack/bpf_get_stackid, which
> will have this extra bit of logic for callchain. All other program
> types with access to bpf_get_stack/bpf_get_stackid should use the
> current one, probably.
> 2. For that special program, just like for bpf_read_branch_records(),
> we know that context is actually `struct bpf_perf_event_data_kern *`,
> and it has pt_regs, perf_sample_data and perf_event itself.
> 3. With that, it seems like you'll have everything you need to
> automatically choose a proper callchain.
>=20
> All this absolutely transparently to the BPF program.
>=20
> Am I missing something?

Good idea! A separate prototype should work here.=20

Thanks,
Song

