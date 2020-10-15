Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5928ECDB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgJOFu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 01:50:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728714AbgJOFu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 01:50:56 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F5h73B022370;
        Wed, 14 Oct 2020 22:50:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-id : mime-version
 : content-type : content-transfer-encoding; s=facebook;
 bh=vW164dqV/76QsglcJUBQXLB2sghUq/qjRSxGCxHxBIY=;
 b=cSAjjuIu12yt7J/5nRLDKH1gYOrm49uKiuo3FqI2ac6GHGguXBK/xAj+8NT20cAOyMmJ
 iPJujE6S4qQwlGzYuS0394epdKGcr8qh1IpTsncnUngaJ6t//PJlS6y7Jx17rMPX4hIP
 xmXO23m6zgUHmue0pu1y9osIO89vqJ7eunE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 345yv0n64a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 22:50:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 22:50:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKhyDsYV0ML+xdcNqZfbzk6qp9jJPGJIGVEcibPKRCHjL7aUjZLg3svlfDOcPPiWIgw362Ok8wIWUZaC2OC93STxX/SULAwP2/qtyzN2oXZcDtnJG4nM31BlR9YnTG097U31bngNpc60QpmxMcPVtbJdLVWgg7B77zhFraG0yCXfzempHG0LfPWyazb+KMVx25HnSwpNwNB6mbrR9ooOl/NjvthSnBMMo2mDfdOlFX2+rcoCMwatCLxm8bbRQACFHAalbArsCtceb/4Q4bvTFrYzars9UFYP0JH/W6HQMds5QR+cpry+GY04VsOWeS3DZDC1qK6fkFeXhTYEH/bxZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW164dqV/76QsglcJUBQXLB2sghUq/qjRSxGCxHxBIY=;
 b=dkMN+GSCKCIXEWTJvomB+AtnFOuD3VzJ96ueHAOnqktOHLjab80l19JTc1+b8KhnQjeoSy8Oeo1mY3fsZsIz7q1pWGFdDf4zj8OI4h17P5uOrEYYMRx5tweBJcIZGgPs9gZS0T4EN59p6WFaxT9gsjA3itDoiDkpBy4HfXVOczbqsXaDvisEG1Y5T2+5/5IWdjQBQEFmbwb9ecPMouQxaRh41bJNQC69JM41kFTO815NjDz63mTN6ssjI/UsA/U/y5VgShA94SihQf0YPw2aDRc8HBWDEZRUarMQHLmEGje+Et1LSO3Z9WVhKueb0g0yy/ZFjPANkoA2W6lhLPS7+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW164dqV/76QsglcJUBQXLB2sghUq/qjRSxGCxHxBIY=;
 b=SFAUDuhyr6lLigZWGcGXP5N8HVteUNbv0X4uKZ6641JlITScADiojWAzFNtRwrxfsnIYdRygXIhDQbejTb/oMVF8qGo4sGcqyGiRXoQublBiYK5/8Egdf7dJGYNPuBYDwWDzaOoNmiOVkPECrBbEhjBfhZ4yiWixeLfnGor68/s=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Thu, 15 Oct
 2020 05:50:34 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a%7]) with mapi id 15.20.3455.031; Thu, 15 Oct 2020
 05:50:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Thread-Index: AQHWoeOm3LXpZuI85EKOjjpbainxQ6mYE8IAgAAWp4A=
Date:   Thu, 15 Oct 2020 05:50:34 +0000
Message-ID: <5A67779B-B40B-46D4-8863-A804E20FD43C@fb.com>
References: <20201014043638.3770558-1-songliubraving@fb.com>
 <20201015042928.hvluj5xbz3qxqq6r@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201015042928.hvluj5xbz3qxqq6r@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:8115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 021c76b3-9dac-4ba6-db24-08d870ce3c47
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2583884BCEBF838B4600AFE0B3020@BYAPR15MB2583.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3U3OPL5pGJIbMykz1/N9oayQWUhh6ymBj63CXyQb0A1H91uXYkreXbspoCj8yTPlTCWD/CnVKLF12j3W6PQgYwHIM4uOHE1YXPZNzxRwJDLcc/YAB5A1u8s2aQ8zbSN76+8uVx3F2SRiePqczAfTAInVYaQqSog4ez2r3AmKEkFZNc6vRQKQBiyuGvSegsDna9EPndqKvYWnBPJ+3DCeJ4X9XU76iBk6VjeIlnlC7LpDzicS/NVLgUSykLNJyoBHRzF9VbuBsT5QSKzmQ6eaP4Ps1/vzSxkWitBCUjKGYKu9C1dl21wfXDAgKW40jAfseB8z6bp8KbxjpqyIY28OSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(366004)(136003)(53546011)(71200400001)(316002)(36756003)(83380400001)(54906003)(8676002)(33656002)(2906002)(6916009)(6506007)(5660300002)(76116006)(6486002)(91956017)(478600001)(86362001)(66446008)(2616005)(4326008)(66946007)(66476007)(186003)(8936002)(64756008)(6512007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mnwFcdncvGyr2CXWKw0ut/688A3tnH+kKEDar80LJKondNIfGRKrPf0BVFu13bnOMoTire9qSqrkLrNJ9KoJ6sibgOtJp0ivIdLaVCrSrwo5SVjp8j8pRs62Zy37cnG1XpljHD7BPB++wmhQbunlRYe+plsgwbRjTTrWiM7VSQ5bxhVALSW+h1mapRojQl8Fn25nKun5lzk61pS23g3rCxrEQGHvTwRClOIleKKIKNXosXiokEHgvkRFYbdJc/lKauuul6deeV7s+cJEAlFIfhP17F4Tr++C8T14BgrGJkuu1CQAS3b5axaYKiJP4bBI/iOJO+cjoIFFxo7tVCX2vC4aiuKspVt/vvL7ozqxe3hr4i7SJFd7krmXyYXj6YqBNs8eO47Un50ovdGA0H2k74DGTXAApGYvQYMf6v1zh/mD3X+ImOPhsq8mRem3O2o9XH1AWqb7fa6OotD1x7eiZVdn2X8126NvhH1kfsHrwKm5EmUMzkBrdMW73p92c2GQwrFmmWXoHWW+yTgnySFAFoCtZoaeCANLzm2Aanh9dAIp3s2GcTusPMjlCZLNSbhBZaRmjbNojr1rcI5i7d21HcmIymHBxO8pYH2zG82I4LyO3oIeJcwYVse2P7IaMqb/n4/PHG8NTfLgVWQBxIEwlvCdZ6y5xFLPWJPDKE50zmVOBgDDceUugcp0vuEXlKg/
Content-ID: <6F156EF2D38089499B5EC375E78D46E0@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021c76b3-9dac-4ba6-db24-08d870ce3c47
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 05:50:34.8931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n33cT2KLUKJRQJlpsbcK5tkSVWJerczNKCzPb4eVYG8/QzI3ZPHhbaiaZv6uNSaGAQTEOv6FJ78cvj4C1Y1F+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2020, at 9:29 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Oct 13, 2020 at 09:36:38PM -0700, Song Liu wrote:
>> Fix the following error when compiling selftests/bpf
>>=20
>> progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as dif=
ferent kind of symbol
>>=20
>> pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
>> error by renaming pids_cgrp_id as pids_cgroup_id.
>>=20
>> Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> tools/testing/selftests/bpf/progs/profiler.inc.h | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/te=
sting/selftests/bpf/progs/profiler.inc.h
>> index 00578311a4233..b554c1e40b9fb 100644
>> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
>> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
>> @@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_nod=
e* node)
>> 	}
>> }
>>=20
>> -int pids_cgrp_id =3D 1;
>> +int pids_cgroup_id =3D 1;
>=20
> I would prefer to try one of three options that Andrii suggested.

Ah, I missed that email (because of vger lag, I guess). Just verified=20
Andrii's version works.=20

Thanks,
Song=
