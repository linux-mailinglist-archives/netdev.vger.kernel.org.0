Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6E5145ED2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVWzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:55:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46916 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgAVWzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:55:54 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MMsYBA004104;
        Wed, 22 Jan 2020 14:55:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jvac6lEiodtg8/xIxnPclINRBTAedKlHsTUlDUEdLe8=;
 b=WgEPTMmqtaq/eRGFs0n2LUSju19InewdwMT2lcfp+XatG9JaQjlA+dEo/W7nkNfwZexZ
 F2WPklqEpoRzil1LiiP0Eun2Db/aL/Y9mq31LaBldE3RhoU1+tPZXhmy5w6jbafSAQkx
 nX1fuqPJI8QlciL2x0z/H48bWDc1N+dsW+k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpr4ka98b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 14:55:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 14:54:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FN0HpVKIrHPDiIo3GTu70Alex7GvrThevd3RO+KM7Gtg9kK8VL3T3JGN6ZOVQMvVlsoLFF8xe6Xu2Dst8wVqTGnHqyZeLztlW7aUa62QFRqrZ/VR0akv0R+E8KRCztmxl8extMwLXfXMITbEArJG6Dw/cvxQCIsUB+74w86dFIBPP1eSlpbGax18gz6k8G31j5+fhL8+WNvv7qSWn+eFDo+jne3MK7c6OCc3Pl0n+nc0Oybj60q8/fxAio3CLyEWvhKLoQ1JZ3GTv7fciwrTmNDacJqobosE6uBhky7NSIOuIfEvC7zcVTaAIq9gKNW2+gz9hBGbyojDXT2CDvmJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvac6lEiodtg8/xIxnPclINRBTAedKlHsTUlDUEdLe8=;
 b=iRbCtxYgjUa4tdC0RpovgCCViDds6Ljf3NiHj4osotoBGoM7FxCuzW7f0a4FNh0dmRAgah4X2ay9Ukglo/7vKZPipQtb0ojXieQ8joLtr+WBl2GqCbPvaUpr+MugIyi69/79DhgB3fBFEE4WRnBJIGcj1YACc/TiBIvFyNFtTb0nD5Vm+yuJeTzaVVm6VgAQevYRAwC2crQfPWCv0xtrwpsf9InV+bj9AOlWakiDB3lx+wu9hSBChXz/Shv20bfJY42/bXVfnT8R4Pfk3VF0mIbf1B2Sxp7c7uvt4GEZP0yigrZgvxc47+3ANHwUQl+e/sLWfdoQ2vqPcFSN7DE+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvac6lEiodtg8/xIxnPclINRBTAedKlHsTUlDUEdLe8=;
 b=bLAIWcrCUvseOu2KDfCdoqjdWutH7EHS5+x7Sc2btBbPTQ/gejiymtwm9UVh8rpgfgSvUVeoVGpYmakzR5LLzMJX8xW+3l3hjg23ATvMhKCgmamkOSZljbtFKb+EHHN6d4MaCS40n1WxIHhNE61X+HgUFyorbE6zwXYPKLEBmD4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2575.namprd15.prod.outlook.com (20.179.146.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Wed, 22 Jan 2020 22:53:56 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 22:53:56 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by CO2PR07CA0072.namprd07.prod.outlook.com (2603:10b6:100::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 22 Jan 2020 22:53:54 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 10/12] net: Generate reuseport group ID on
 group creation
Thread-Topic: [PATCH bpf-next v3 10/12] net: Generate reuseport group ID on
 group creation
Thread-Index: AQHV0SS4nGLET2x3Kkm+ShCvFrAG2af3S1eA
Date:   Wed, 22 Jan 2020 22:53:56 +0000
Message-ID: <20200122225351.hajnt4u7au24mj5g@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-11-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-11-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0072.namprd07.prod.outlook.com (2603:10b6:100::40)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85b65efb-7cbb-4740-33f9-08d79f8df5c0
x-ms-traffictypediagnostic: MN2PR15MB2575:
x-microsoft-antispam-prvs: <MN2PR15MB2575ECAF074AF11D53B2DC47D50C0@MN2PR15MB2575.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(5660300002)(478600001)(81166006)(8676002)(81156014)(1076003)(64756008)(66556008)(66946007)(66446008)(66476007)(4326008)(6916009)(16526019)(316002)(86362001)(2906002)(71200400001)(8936002)(6506007)(54906003)(186003)(9686003)(7696005)(52116002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2575;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lrFOkAKi1RurcaAHKzrGKzdtkYqQLPfCbYEd3yF89gfgEkzYXrrJx1dCxupYEdOa8FtWFi8FqelOphTtAQ1q5t48oQ3DxJPQfbNSZHvnRAE+pCfaGaH8wNfKpkg0XejFiASo7wV7NxwRC6vgpzTSxd7iwBKEyl0LvtNS/45UHm428XbE7uQvcTOWQ8fEztiALsVKJ09q545QeXrWCW9mHlIoLMqtQ/42c+UTkMIXW84ygj6ZNUPHlsdn/8YC9p7YZfbPu33x0RngOluO89Yw7F/Kq0EWcgZyTBbuU0fyawGbWjapHiYJadeMBOrQTL0hp3ymgilUnIJVfCDvi/bvMu3Qx52sqawYStY0+vGDAMrlg5seKpToq3zQwS42xrWcW+9Y0wXruKMFFuC4BvFNiXCjMX9yewWNtJNUPWUZ+R7AGJJOpbbXsXSAEhfWvoBd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17152243CA44E24A9FF306DC0E3BD232@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b65efb-7cbb-4740-33f9-08d79f8df5c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 22:53:56.4700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lZtbt7R/1LO4D0Ubtgiu+HAMlvB6uVzeWQKUk77VBMpGHG+B+PFGUNfJqVYVLV7A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2575
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:47PM +0100, Jakub Sitnicki wrote:
> Commit 736b46027eb4 ("net: Add ID (if needed) to sock_reuseport and expos=
e
> reuseport_lock") has introduced lazy generation of reuseport group IDs th=
at
> survive group resize.
>=20
> By comparing the identifier we check if BPF reuseport program is not tryi=
ng
> to select a socket from a BPF map that belongs to a different reuseport
> group than the one the packet is for.
>=20
> Because SOCKARRAY used to be the only BPF map type that can be used with
> reuseport BPF, it was possible to delay the generation of reuseport group
> ID until a socket from the group was inserted into BPF map for the first
> time.
>=20
> Now that SOCKMAP can be used with reuseport BPF we have two options, eith=
er
> generate the reuseport ID on map update, like SOCKARRAY does, or allocate
> an ID from the start when reuseport group gets created.
>=20
> This patch goes the latter approach to keep SOCKMAP free of calls into
> reuseport code. This streamlines the reuseport_id access as its lifetime
> now matches the longevity of reuseport object.
>=20
> The cost of this simplification, however, is that we allocate reuseport I=
Ds
> for all SO_REUSEPORT users. Even those that don't use SOCKARRAY in their
> setups. With the way identifiers are currently generated, we can have at
> most S32_MAX reuseport groups, which hopefully is sufficient.
Not sure if it would be a concern.  I think it is good as is.
For TCP, that would mean billion different ip:port listening socks
in inet_hashinfo.

If it came to that, another idea is to use a 64bit reuseport_id which
practically won't wrap around.  It could use the very first sk->sk_cookie
as the reuseport_id.  All the ida logic will go away also in the expense
of +4 bytes.

>=20
> Another change is that we now always call into SOCKARRAY logic to unlink
> the socket from the map when unhashing or closing the socket. Previously =
we
> did it only when at least one socket from the group was in a BPF map.
>=20
> It is worth noting that this doesn't conflict with SOCKMAP tear-down in
> case a socket is in a SOCKMAP and belongs to a reuseport group. SOCKMAP
> tear-down happens first:
>=20
>   prot->unhash
>   `- tcp_bpf_unhash
>      |- tcp_bpf_remove
>      |  `- while (sk_psock_link_pop(psock))
>      |     `- sk_psock_unlink
>      |        `- sock_map_delete_from_link
>      |           `- __sock_map_delete
>      |              `- sock_map_unref
>      |                 `- sk_psock_put
>      |                    `- sk_psock_drop
>      |                       `- rcu_assign_sk_user_data(sk, NULL)
>      `- inet_unhash
>         `- reuseport_detach_sock
>            `- bpf_sk_reuseport_detach
>               `- WRITE_ONCE(sk->sk_user_data, NULL)
Thanks for the details.

[ ... ]

> @@ -200,12 +189,10 @@ void reuseport_detach_sock(struct sock *sk)
>  	reuse =3D rcu_dereference_protected(sk->sk_reuseport_cb,
>  					  lockdep_is_held(&reuseport_lock));
> =20
> -	/* At least one of the sk in this reuseport group is added to
> -	 * a bpf map.  Notify the bpf side.  The bpf map logic will
> -	 * remove the sk if it is indeed added to a bpf map.
> +	/* Notify the bpf side. The sk may be added to bpf map. The
> +	 * bpf map logic will remove the sk from the map if indeed.
s/indeed/needed/ ?

I think it will be good to have a few words here like, that is needed
by sockarray but not necessary for sockmap which has its own ->unhash
to remove itself from the map.

Others lgtm.

>  	 */
> -	if (reuse->reuseport_id)
> -		bpf_sk_reuseport_detach(sk);
> +	bpf_sk_reuseport_detach(sk);
> =20
>  	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
> =20
> --=20
> 2.24.1
>=20
