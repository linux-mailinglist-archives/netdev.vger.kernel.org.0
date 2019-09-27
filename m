Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3079FC0D31
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 23:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0VWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 17:22:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41582 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfI0VWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 17:22:33 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8RLJ0Rx027282;
        Fri, 27 Sep 2019 14:22:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MGrf2xGVtLhipyA3hKzNW3pbca2G7sGpVvu1S3bWhXE=;
 b=akHiiCc8KNXcmwl4J47isR8BILNLyZKqFcCFIlGBVaATh/+dGlR2ay7CtjV2y/gPEdEw
 mNUZ6QDWz7QKgB2fBZ59N+Bh862vTHD+n4xr5EdyGwAfgsQx+kVuEfEld4OPIqp9LNGg
 YcjlKx7/4ZunnH9Aw6z2t6HTV7jX/vwsP+8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v9nfyskfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Sep 2019 14:22:18 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 14:22:17 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 14:22:16 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Sep 2019 14:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKLDCw0gKCfJF4ho2eeV+yoLwsKNguMJybZsK7OP9Epr8tcyH5CUjtpmuKWji/xZ3OK/6Lc+JSMr2UMdaU1DIUoAovdkVTtBPX/1zEa3hr+yWY8Rbk5FNsY3aeGr89y/oFuj7zrJzQAFHChDnPJoYonIcXKkWzN0Wb/QfXMmNX3ZCq7hcQW0hQLPN0gwrdwNROFuMl2el7XjvNdYzAslOLS4OrIAJnAkwXKUSsineUmTx8ZE7sU+/nvFFJ3flG+RjPfWrJTqeWgdvRFcPm0DIO13ENelIBykPKvYoGNgR/kF+IX4Xs5Fb5FZpmKaI4a8Z3FdxeYBohnCvz5fJb3GPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGrf2xGVtLhipyA3hKzNW3pbca2G7sGpVvu1S3bWhXE=;
 b=OcpPqbuk7U2DZDX3HCWGNwgBmuEeqrP0wT4htTV5yRuxD9QNdhI1E683hL4+fjaJgTeFqEgIqwaj6uUtOZzlhMAtQjl8zgsXNmpVm0ma+MfRXnw/0aKSlzKRPTyty3QrMJ9l5J7NJQlLahW3Qv9jU9GX4FTd71wILt8TG2eJf63ga7TPkKjHiOxbOYl2m7lbUPBkYjpQSiT2RUz+YCMut70jf+C2Wfd6audqDP8b1Gz8/dcVs4fMRjpPE7Yu920JYBNhN7Y/67EeUUR3fkdFuu7r0M4noZeIRRXFiMRg4J+sBviMcZmwUBGMPmDz1I866C0xmDLQxTCIMl82E0kHEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGrf2xGVtLhipyA3hKzNW3pbca2G7sGpVvu1S3bWhXE=;
 b=j4RTDoT/Bv/WBLpDlJVJu2Hs0gE//zLtKPLGJup3J9ebRF5EVP2ypXAkVgootuLnW58tJYgxKrD/g4VKXOmihNUHZ7oVTTqv8kSvpHgvUYDj64vIIuDwAGQXhS2jc/lKMOX1c/WQYMMu09dXm67xlACcwxfLFutyJgHyX3oRGPs=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1693.namprd15.prod.outlook.com (10.175.138.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 27 Sep 2019 21:22:15 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::acac:2542:7b0b:583c]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::acac:2542:7b0b:583c%6]) with mapi id 15.20.2284.023; Fri, 27 Sep 2019
 21:22:15 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
Thread-Topic: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
Thread-Index: AQHVdVPxyEcQqINYA0aChEzQ25OGv6c/xkWAgAAOt4CAACntAIAACbGA
Date:   Fri, 27 Sep 2019 21:22:15 +0000
Message-ID: <20190927212213.abxgmwzm5b3bspnm@kafai-mbp.dhcp.thefacebook.com>
References: <20190927165221.2391541-1-kafai@fb.com>
 <04f683c6-ac49-05fb-6ec9-9f0d698657a2@gmail.com>
 <20190927181729.7ep3pp2hiy6l5ixk@kafai-mbp.dhcp.thefacebook.com>
 <fc762c01-94da-7f72-4fc0-9b76d6bbe3dd@gmail.com>
In-Reply-To: <fc762c01-94da-7f72-4fc0-9b76d6bbe3dd@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0014.namprd17.prod.outlook.com
 (2603:10b6:301:14::24) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::5bdb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aee28b2e-bc19-4a6d-467e-08d74390c4af
x-ms-traffictypediagnostic: MWHPR15MB1693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1693D78E5FC5D4844C07F87ED5810@MWHPR15MB1693.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(39860400002)(376002)(51914003)(199004)(189003)(81156014)(7736002)(99286004)(229853002)(52116002)(64756008)(6916009)(316002)(305945005)(476003)(66446008)(4326008)(76176011)(53546011)(102836004)(6486002)(1076003)(478600001)(66476007)(66556008)(6506007)(186003)(386003)(6246003)(81166006)(14454004)(8936002)(8676002)(6436002)(46003)(2906002)(54906003)(446003)(6116002)(5660300002)(6512007)(9686003)(86362001)(11346002)(486006)(66946007)(71190400001)(71200400001)(25786009)(256004)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1693;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eILRivOH6OOOnooFkMFgS7Ap1HURpRGTkuULio/9z6upF9CYy2tj/b6x9A9m0lptPrCIkRw9r9sfhVOcmEWekhAOnaqZPGMX9mQU68m48TRcslPiCL8zn7Trgz8wHa3hLcr1czUyJRmoq/QTC5xTQw9AtbFpWMcGe9Nf+FS69aBrRnt2r7HaLYvtl38TtvjiAh6eqcwlq8ao5QAbAh6Xc6+fL4r69uIVJEbCkrBqgWR8ly59kUWFlKPgmtC2g/PDZc3j3pvrGsv+HUJ9U7VYYl8yqkp8UJ7ECBdMIcPKehyT2sP7g1xZWn6I1zaFHa0K4NhK4kEanlELVfJvQyuSPty6P2hQLDLxPZ/g3xl9VE8Cjv/+elV7mdjdzso9EbpJLlNmLIow5EIISwsw7bUSOiXoEBM3bJa5u98/b/kfYMo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB95A7451036DD42998808AD9C2CB95F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aee28b2e-bc19-4a6d-467e-08d74390c4af
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 21:22:15.3805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WUtvLITRHWUen8Gj4k2Ivjae6ZC+E+IKiEnche4PKcYCQEQdlZ5UDFwRRQv7qgZX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_09:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 01:47:32PM -0700, Eric Dumazet wrote:
>=20
>=20
> On 9/27/19 11:17 AM, Martin Lau wrote:
> > On Fri, Sep 27, 2019 at 10:24:49AM -0700, Eric Dumazet wrote:
> >>
> >>
> >> On 9/27/19 9:52 AM, Martin KaFai Lau wrote:
> >>> In reuseport_array_free(), the rcu_read_lock() cannot ensure sk is st=
ill
> >>> valid.  It is because bpf_sk_reuseport_detach() can be called from
> >>> __sk_destruct() which is invoked through call_rcu(..., __sk_destruct)=
.
> >>
> >> We could question why reuseport_detach_sock(sk) is called from __sk_de=
struct()
> >> (after the rcu grace period) instead of sk_destruct() ?
> > Agree.  It is another way to fix it.
> >=20
> > In this patch, I chose to avoid the need to single out a special treatm=
ent for
> > reuseport_detach_sock() in sk_destruct().
> >=20
> > I am happy either way.  What do you think?
>=20
> It seems that since we call reuseport_detach_sock() after the rcu grace p=
eriod,
> another cpu could catch the sk pointer in reuse->socks[] array and use
> it right before our cpu frees the socket.
>=20
> RCU rules are not properly applied here I think.
>=20
> The rules for deletion are :
>=20
> 1) unpublish object from various lists/arrays/hashes.
Thanks for the analysis.  Agreed.  Indeed, there is an issue in reuse->sock=
s[]
which is shared with other sockets and they may pick up the destructed
sk from reuse->socks[].

> 2) rcu_grace_period
> 3) free the object.
>=20
> If we fix the unpublish (we need to anyway to make the data path safe),
> then your patch is not needed ?
Correct, not needed.

>=20
> What about (totally untested, might be horribly wrong)
I had something similar in mind also.  I will take a closer look and
re-spin v2.

>=20
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 07863edbe6fc4842e47ebebf00bc21bc406d9264..d31a4b094797f73ef89110c95=
4aa0a164879362d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1700,8 +1700,6 @@ static void __sk_destruct(struct rcu_head *head)
>                 sk_filter_uncharge(sk, filter);
>                 RCU_INIT_POINTER(sk->sk_filter, NULL);
>         }
> -       if (rcu_access_pointer(sk->sk_reuseport_cb))
> -               reuseport_detach_sock(sk);
> =20
>         sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
> =20
> @@ -1728,7 +1726,13 @@ static void __sk_destruct(struct rcu_head *head)
> =20
>  void sk_destruct(struct sock *sk)
>  {
> -       if (sock_flag(sk, SOCK_RCU_FREE))
> +       bool use_call_rcu =3D sock_flag(sk, SOCK_RCU_FREE);
> +
> +       if (rcu_access_pointer(sk->sk_reuseport_cb)) {
> +               reuseport_detach_sock(sk);
> +               use_call_rcu =3D true;
> +       }
> +       if (use_call_rcu)
>                 call_rcu(&sk->sk_rcu, __sk_destruct);
>         else
>                 __sk_destruct(&sk->sk_rcu);
