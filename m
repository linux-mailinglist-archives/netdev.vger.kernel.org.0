Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E896F1219BE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLPTOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:14:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfLPTOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:14:23 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGJBnte028451;
        Mon, 16 Dec 2019 11:14:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vduqSYa3zV5OGyLDUSw7reuu04V3EhcV38vC9cLHC9I=;
 b=TO+FjiTYmW44aO6xTAJ5yisuKE3bb0S1bTU2RVcPkzEj8/sOP+D91vW139kto6+Jb2aY
 bhKGDTlvq8CQyVrUV5QBQ7sxrs6Qg84ZW9IsC8K7XoU2EIxhbS5ruNaxXBEbCcxsEn3A
 qllAyn86MY35UIudkadXXv61TVJ0V77iHuQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgsmnnas-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Dec 2019 11:14:08 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 11:14:05 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 11:14:05 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 11:14:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH3o3tJt67Zu79YlbcXngQJf7pgxpTOZBWegprmyA5xHkzd5rMDJM84Z4HWVXHf9gtPSE/Sllh9tUx5XAPVITJ1qa9xtHEONbwGLE09vICcvkvNIgQVlEccuNlOUZ9fMp+f7ozE60GbTKs6HSAeD2D+WnbGt07JrKX8RTekI9iKoESV2Hd6PY4fGy8KGIjMvI8agOa+28DODQlLc6uunEFWCsKzSniqYXxzpIghXVfBayeqdoT/XJ/unCqAov3+kjGrasF2NEuaFoFd3VB6vKyjycWNH7r1s5vO4ooAVCQPjZsu0u8mCW5Hkl27zrwuRBncRZI7XLZHqrSKVu/GtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vduqSYa3zV5OGyLDUSw7reuu04V3EhcV38vC9cLHC9I=;
 b=cw21aT6BdJGFsW3OjQ6vex9efHbzNp+IJcPjNkCoduAvril06ostYza01q2PnNYPAFX7avbbzdtyEiom4uC5mmCidhzOz8kmZQkfyl7WyM+wH+9F9BIlEKuHOl0He1ryxEx8nZby/MWdOkaKANcU2fg4elD553YUgGzSZJ4vFesMsausmpQxFbExegqYOsa0YPYmbP5YmfIc60aE60UDTLMlxsd1Pg5Nmu2oxBLgiTXLM1KsI3qCe+uzluecCpeH93kTZckEMNI5Ynb9YrYsAjUzbqWyLFa7apEjSVPAFFifQ67PQyHs2i2NJ5tJLQs+dAQuJ9HxeWAPR+7mAUMgtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vduqSYa3zV5OGyLDUSw7reuu04V3EhcV38vC9cLHC9I=;
 b=J7F6LZ2E/lOV6UYgI4oSJ9J+PDl1MyTFYke1H/QAR0XzE9ASzAMMvopKZECNOnKJuJJP24xQpXtEfKRKyFZ/2vj7pk6nauKkK/NuOYhcFtj0rUXlQ8bHFB+0q1J6Y0zX1J8tPyyYNYRK3ZQUAyR9Hmt3Sk1+gl5xerdwizO27C0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3006.namprd15.prod.outlook.com (20.178.252.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Mon, 16 Dec 2019 19:14:04 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 19:14:04 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Topic: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Index: AQHVsiI0ihgHNw98P02gRrT2dQLnz6e9JamA
Date:   Mon, 16 Dec 2019 19:14:04 +0000
Message-ID: <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
In-Reply-To: <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0051.namprd22.prod.outlook.com
 (2603:10b6:301:16::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:71b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9b1ea4d-fbbf-43e7-ff5e-08d7825c1d68
x-ms-traffictypediagnostic: MN2PR15MB3006:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB300630044E920AC926DC63AFD5510@MN2PR15MB3006.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(396003)(346002)(376002)(51914003)(189003)(199004)(9686003)(64756008)(66446008)(66946007)(66556008)(6916009)(66476007)(6512007)(316002)(54906003)(71200400001)(2906002)(81166006)(52116002)(6506007)(86362001)(5660300002)(1076003)(186003)(8676002)(3716004)(53546011)(478600001)(81156014)(6486002)(8936002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3006;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PBrBiFcy+4Ri0Godl1saxgtGeDq8X2U3MbJ5PI9myNyv88fTf5DPAJOtqbeu5wOGPyp5owKTDyK3bRrGkaTkVRMvVLvEr15NkQhKTFu49TRWYgFKHvc6VwoF1CFUFeG6VPB78Q2LrRdeoGj+hJyYWYYfY3S4XxPIoiZzZ2mmKwP/EgNRtpkG+RXbDes8MeqydwX5El2OkvQGf/8cSEeCqIOsK69omc+xeL1FEYYZCnmelVhiZXBe7GLCIsD67EKDoEtPIA+6O1Z/6x4MZxAt5HIP7F177oFE6zqPU4rKdutjk1zTnZeg9n+SLW+B4nAJFAlepLkcbYwgN0AnvFI3VadV8lEy9WV+ZbfOcZH3mhWSnDNz41B4+8RdWPR8qhsmGfTPUzM4UUFpzahr6tU7IsHK3ejY7HYMRMgEUEpdcF4+4R3Fvz6+RoxkqmoxJlXEDfdJe3N6QtMWP4mCnzQA5/mbnwa3a2lKxN0qXM4XX/x2juD/WrEZGPdPX/7A26RO
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F74BFE39B4BD8F4285C2B6B652FF4B8A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b1ea4d-fbbf-43e7-ff5e-08d7825c1d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 19:14:04.1395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TTUy5WBsTnXuIg1B+IHrrWJcgyg1XZkkibjWmfvf18RRK0yhGBqH7TF0KaY3nk5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3006
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxlogscore=732 malwarescore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:59:54PM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> > This patch adds a helper to handle jiffies.  Some of the
> > tcp_sock's timing is stored in jiffies.  Although things
> > could be deduced by CONFIG_HZ, having an easy way to get
> > jiffies will make the later bpf-tcp-cc implementation easier.
> >=20
>=20
> ...
>=20
> > +
> > +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
> > +{
> > +	if (!flags)
> > +		return get_jiffies_64();
> > +
> > +	if (flags & BPF_F_NS_TO_JIFFIES) {
> > +		return nsecs_to_jiffies(in);
> > +	} else if (flags & BPF_F_JIFFIES_TO_NS) {
> > +		if (!in)
> > +			in =3D get_jiffies_64();
> > +		return jiffies_to_nsecs(in);
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> This looks a bit convoluted :)
>=20
> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer use =
jiffies at all.
>=20
> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be con=
verted to ms.
Thanks for the feedbacks!

I have a few questions that need some helps.

Does it mean tp->tcp_mstamp can be used as the "now" in cubic?
or tcp_clock_ns() should still be called in cubic, e.g. to replace
bictcp_clock() and tcp_jiffies32?

BPF currently has a helper calling ktime_get_mono_fast_ns() which looks
different from tcp_clock_ns().

The lsndtime is in jiffies.  I think it can probably be converted to ms bef=
ore
using it in cubic.  There are some BICTCP_HZ logic in bictcp_update() that
is not obvious to me how to convet them to ms base also.

>=20
>=20
> Have you thought of finding a way to not duplicate the code for cubic and=
 dctcp, maybe
> by including a template ?
>=20
> Maintaining two copies means that future changes need more maintenance wo=
rk.
At least for bpf_dctcp.c, I did not expect it could be that close to tcp_dc=
tcp.c
when I just started converted it.  tcp_cubic/bpf_cubic still has some TBD
on jiffies/msec.

Agree that it is beneficial to have one copy.   It is likely
I need to make some changes on the tcp_*.c side also.  Hence, I prefer
to give it a try in a separate series, e.g. revert the kernel side
changes will be easier.
