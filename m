Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9413E2763D6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWWhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:37:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9028 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgIWWhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:37:25 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NMXahY017190;
        Wed, 23 Sep 2020 15:37:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7Wud2CvZYhQXkVJqbeQy4bkzUDl+W3csStoiXo4/rFI=;
 b=kWN1ZNH25vciIxm08Pk6Izo358i1Dni8tZzp0cIvszvgjYXmFDAUZrj9LaY2kf/hlSeb
 qAFinKSIvHLe16vk5+8JdDaykJKhcLxaAJz+iRwRYJdHexRyPYFbINDYDKOBMJQnGik0
 OGFfh8F9I8ctn4FKHzN3G9nwaszUA+5V9gQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp3xgs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 15:37:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 15:37:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3Ul1plroWRktat0HWT4RY0D9KGLa6kmHc7khM6a1Qxb6s+qO7Pl1/avOQM+4f0LWkMBilu99tGFIGDH8jGd4bFnkQ+81Qisoj9HR2K7j8pqcjkAYdoKa8R/y8pVPLd3EdRKHP0AM1jD085lDCSqNl0rrCvHL5ay6ZuMX6USwBWaKF5aMwBIEOJ76CcjSKT25GrpoSb4N9+AN107pnM7EMG28JMKVJsclIUSGvuisc7RJnU3IzwQCRjmkC/c5x8l6CXm/r3qiH0fIvebNen0iMyzF4LOD6fl0CYxr/QSJrHN2+z1Vew3p8+sfaqLmLGcHDGnJgmp6Ipi+c4+WGOX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Wud2CvZYhQXkVJqbeQy4bkzUDl+W3csStoiXo4/rFI=;
 b=f1n0QI9cv0mx/4LIJp008fcmufNJ0CI2tUsn2TrGbTNH3JRvl42bjbEE9hI2r5qNtzKidR5znxoUyjre8i/sYbCJbp+pNZlC3p7U48xNUGJbFAejt7dneAkjx7zw+C+b0qXuXtMjvZK+CPtx3rs56iIWPB56bd/kHD4SMT0AVABv5NrlAQKr02HSXi14iB9sqMaFfqjdXFp92/YJ2NHGmPV3rRRDsBS5+6RsQod6jiqISCW8+01IpzgPt372TAn9iM3tnsmVKl0KkgZT0tK8+ooulDo5WZS2zKCG1tjgjuaB6EGOX0GCZ+HSb3pVve8mPr4XGS4Ee7ASh8rONo6WyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Wud2CvZYhQXkVJqbeQy4bkzUDl+W3csStoiXo4/rFI=;
 b=JFsJnmjSWrAHktJGlzrGInWQbD/2hYnm353IZKN6bnKXy7V3KZD1Na+qoh8fTi7Vp+KgMTzNiVVoekQFfEpqQ8YlSd9Uy+pnQFgF/ys/D+PtYbBZRRJqxiL1Ehn4F6Gviu63Jjw4Fmf2Njjyp2lu9VwfIMhj7KQxrPX/GU3SxkM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 22:37:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:37:08 +0000
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
Thread-Index: AQHWke9TdhzHEmJVCkirb8f/NEp9R6l2wqcAgAAHOYCAAAKtAIAAATgAgAACfoA=
Date:   Wed, 23 Sep 2020 22:37:07 +0000
Message-ID: <BE7445DE-72EC-41A9-B793-6A32D45B45A2@fb.com>
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
 <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
 <20200923221415.jxy6hcpqusodpqsr@ast-mbp.dhcp.thefacebook.com>
 <7DAA1D76-860C-4058-9D5F-7A87DB45B8C8@fb.com>
 <20200923222812.oxhp6zznwdnkiffs@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200923222812.oxhp6zznwdnkiffs@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 655b5186-e233-4b86-26c2-08d86011343f
x-ms-traffictypediagnostic: BYAPR15MB2200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB22005F96C00FD2F871C815E9B3380@BYAPR15MB2200.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J3h09VfDsA2tteHLtBa+QaBsEfrJRlh3lza3X9bRmDMEQT8lb6TPuNcxNwVnhT+BPxFRphV6El5PyddUzXNTiHxtuDMhNILMNvmbKl9zL8kJART1KBt7WmBWptK0TnOs22CB/JtwP0RINBCQjmtfyW6BEkUh3KpVhfFJZHGv6p3HQnTF3I0dH6hgIYgxmT65V5XcQiICsDSHI9EkMJEAv12+wCO3LITMt2RUNJJfA0y/+b+cBJtVjoKaSW6cULVAb9FORUNG4wcI230rG+GUF0bDPTiDliCDPQCGoQvwB4FX1lrwqkkRb2Z4fSr4/1Tl7uHoCnMMOXzax5G/AmCfVzP3fBS67yLtX0QCM45NXe8SHHGYF9GAPyfV8NyWfNh9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39860400002)(53546011)(91956017)(2906002)(478600001)(54906003)(186003)(3480700007)(86362001)(6506007)(5660300002)(2616005)(4326008)(66476007)(64756008)(66446008)(66946007)(66556008)(76116006)(71200400001)(83380400001)(8936002)(8676002)(6486002)(36756003)(316002)(6512007)(6916009)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9ckJ+WTWsnK4a2lE8+6fXm0uWxBLURqSEdvCtGVxE75hHLtvURKPrypY/eC2M2QbNVzX0yHWeOljY5ajwK2CGYigjIvnwRzqa7n6gSBa4DQvTbOn66YtpzJ+HjENdbwLXOnFS+qantqVNq3RLLwaHjqlCBVMvnEIokeYyyTA0zSRQJ4/4Rd4FzelSC5gchu/EBYxXvNfXvwwzcVG/+RLbfDCeHH5d+FJIRJpApfKw3DJXPQli7EclIDqxz3zzTD4XUfvf61YDY8WQ0jkHgCFSfZ5nIgixk+VaxvXBaQ2wz7iISO3skraQQFrA+MUwF+ao1/Td/BbCP6ZAlVJZKuSfP3Drob06NIl3DFF9TeOE1/fiBDrWim03zb3Zm1/w2SfL18tK/2Pbm/S0DCSBpENarRxlgWM2skpdrYtUVfJf3E78rdqFI8BkFFBzw37B61Gp673l6wZC7L3JI06Emq8/hsrPG2XcI3PvwOu+3CS8MBNM9ou9GPEvkJIJQNeykULVUTxy0Eje5wvNhWg6nbsRPi8GvyfkKVjWImmdYhGP2t1WNRjBeIiFlw+xNtiWlyV5+yocPBSwNVvU3ct1kzePVmXujDE+86v8/UCLQ9p+xRDywiqikeYbyj2/PwNVdEvwPigdod2GI6XDiE19bBPTosTYK30ln4DjiT2rjTEApzBWWVwrWstXtIwyYN/G0sH
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8AF189E9C98F544FAEBA9E27EF7BCA3B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655b5186-e233-4b86-26c2-08d86011343f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:37:07.8590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etd67neal/t5m2t3uFMsS+NEjxvwKYg9LSZxOezg8ViVRsl7iY+7j1wev1rWoSGPaOVIYY3pVpGorjlVuNY8fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=838
 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230171
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 3:28 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Wed, Sep 23, 2020 at 10:23:51PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Sep 23, 2020, at 3:14 PM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>=20
>>> On Wed, Sep 23, 2020 at 02:48:24PM -0700, Andrii Nakryiko wrote:
>>>> On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>=20
>>>>> BPF developers,
>>>>>=20
>>>>> The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In th=
e past we
>>>>> observed a rush of patches to get in before bpf-next closes for the d=
uration of
>>>>> the merge window. Then there is a flood of patches right after bpf-ne=
xt
>>>>> reopens. Both periods create unnecessary tension for developers and m=
aintainers.
>>>>> In order to mitigate these issues we're planning to keep bpf-next ope=
n
>>>>> during upcoming merge window and if this experiment works out we will=
 keep
>>>>> doing it in the future. The problem that bpf-next cannot be fully ope=
n, since
>>>>> during the merge window lots of trees get pulled by Linus with inevit=
able bugs
>>>>> and conflicts. The merge window is the time to fix bugs that got expo=
sed
>>>>> because of merges and because more people test torvalds/linux.git tha=
n
>>>>> bpf/bpf-next.git.
>>>>>=20
>>>>> Hence starting roughly one week before the merge window few risky pat=
ches will
>>>>> be applied to the 'next' branch in the bpf-next tree instead of
>>>>=20
>>>> Riskiness would be up to maintainers to determine or should we mark
>>>> patches with a different tag (bpf-next-next?) explicitly?
>>>=20
>>> "Risky" in a sense of needing a revert. The bpf tree and two plus -rc1 =
to -rc7
>>> weeks should be enough to address any issues except the most fundamenta=
l ones.
>>> Something like the recent bpf_tail_call support in subprograms I would =
consider
>>> for the "next" branch if it was posted a day before the merge window.
>>> In practice, I suspect, such cases will be rare.
>>>=20
>>> I think bpf-next-next tag should not be used. All features are for [bpf=
-next].
>>> Fixes are for [bpf]. The bpf-next/next is a temporary parking place for=
 patches
>>> while the merge window is ongoing.
>>=20
>> I wonder whether we can move/rename the branch around so that the develo=
pers can=20
>> always base their work on bpf-next/master. Something like:
>>=20
>> Long before merge window for 5.15:=09
>> We only have bpf-next/master
>>=20
>> 1 week before merge window for 5.15:=09
>> Clone bpf-next/master as bpf-next/for-5.15
>>=20
>> From -1 week to the end of merge window
>> Risky features only goes to bpf-next/master, bug fix goes in both master=
 and for-5.15
>>=20
>> After merge window:
>> Fast forward bpf-next/master based on net-next. Deprecate for-5.15.
>>=20
>> Would this work?=20
>=20
> It will create headaches for linux-next that merges bpf-next/master.
> All linux-next trees should not add patches to those trees that are not g=
oing
> into the merge window.

I see. Keeping bpf-next/master for linux-next/master does make sense.=20

How about we keep bpf-next/next always open, or maybe rename it as bpf-next=
/dev?
Developers could always base their work on bpf-next/dev. When the maintaine=
r=20
applies the patch, he can decide whether to apply it to both master and dev=
, or
just dev.=20

Thanks,
Song

