Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A832E139D20
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgAMXMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:12:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53326 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728900AbgAMXMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:12:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00DN4ir9009690;
        Mon, 13 Jan 2020 15:12:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UUNjkLuQ0jCz2PwuAGdDURC0Zo/B8LxYl1Wd0YvUJmo=;
 b=rUjS2IuoDLh7c72BaxhpgU5DQtvuXjnSW0Webr22j3dI0gIwz64IcJcMCqsnTb4XIYCe
 O3Flf1p9TXNyFjrVKjzHvq9s9DeVTKQXWo1nF79QVMVYx18KqevkFOEM2ZQeUiY7Ookq
 V+gh4ZWfFWZlPiOj2MSZNWr6eAx7W5YBlSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xfar4at9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Jan 2020 15:12:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 15:12:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V598s81x2CJc5tvobZ5AXv9oxTC8u6ox5DOnnJM1/PihGuwGGQkjlO7h5k6xpw4vNL/jWEwq/TUCx4GxZV9A/k90inrLgmvEZBQx2jd07qOMS9fAAseoPpPHOQR7wEYTQ9iz9YMwyPMElCEkKU6CGmIxY6TglfVj+FpQFmSmspxvJVW6+28+4MDHaIq0CKgoHgtiI7lKe5L8x+mz/REEO87jQLE1B/MR9pwsNg0aJmq7os8ZI59mOBMj0w4HQHNalkCzSStO4GME+NjkxgG+SPBK2VKrjPTFhYBDGx/cAYDD198R5h1EgPZ3org7UXvLEb3fBlWOtjcd9hWLTbsx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUNjkLuQ0jCz2PwuAGdDURC0Zo/B8LxYl1Wd0YvUJmo=;
 b=Jzz4zLGfezc2I3sAneDGWBFErHl/F8KlqKrQ5LH0FF017GOHIOOb5gX0S9UfSg881PuS1/NIzOlQaD2D+BpfXybhz6L59NFCJICu5h6m2BoxbJ2b5JxtBWkCMii/xSYjDtW4z3qPyhQLe+vYDUQJQQxL2A0Qr/kUK8Fn2ZJnxpAPjIAi9RD4sFeLYmZgfZos8Uj5fKxcBTYAvPa3Ln9BuH9q3XmeJywTABrTT9rMox/Wmvz7RNs1iMjF+MbpFoG1wm15pS79NaSxwbsV4bNwA/kIxlBnGf6TrsNvSJ97XxO/BaliAruSL+unJdjskUuUz8Ysqjy88hkOCHcc1/Fl0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUNjkLuQ0jCz2PwuAGdDURC0Zo/B8LxYl1Wd0YvUJmo=;
 b=Ao/lhsO0qvr0ImKmzeptC2a4bt0WmoV4TxLJCGcAaJ7vftPAZv9fCp3L5PKyvFH6orQXaimvC8K1rY4uzF9pKcMegSgngUzCvIWNL4OGvqZayFqCtIVvnSVuqetZiS8+zChL2L4JYM7aQP+j5q+mFfA8BrzOirVUT7mqu97Rw+U=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2767.namprd15.prod.outlook.com (20.179.145.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Mon, 13 Jan 2020 23:12:27 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 23:12:27 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by MWHPR2201CA0058.namprd22.prod.outlook.com (2603:10b6:301:16::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Mon, 13 Jan 2020 23:12:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 07/11] bpf, sockmap: Return socket cookie on
 lookup from syscall
Thread-Topic: [PATCH bpf-next v2 07/11] bpf, sockmap: Return socket cookie on
 lookup from syscall
Thread-Index: AQHVx6PS4j84qlTDvUut8pO4R0heWKfpPouA
Date:   Mon, 13 Jan 2020 23:12:26 +0000
Message-ID: <20200113231223.cl77bxxs44bl6uhw@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-8-jakub@cloudflare.com>
In-Reply-To: <20200110105027.257877-8-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0058.namprd22.prod.outlook.com
 (2603:10b6:301:16::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af456331-8a8c-46e6-9352-08d7987e0e39
x-ms-traffictypediagnostic: MN2PR15MB2767:
x-microsoft-antispam-prvs: <MN2PR15MB276719DF4407E731F897124DD5350@MN2PR15MB2767.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(6506007)(4326008)(1076003)(16526019)(6916009)(186003)(478600001)(8936002)(86362001)(5660300002)(55016002)(2906002)(71200400001)(54906003)(66946007)(66476007)(64756008)(316002)(9686003)(7696005)(52116002)(66446008)(66556008)(81166006)(81156014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2767;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A/iDZxXCP0TK1ErGH1KnPRMy/YCnUkZ/DXSMjKE3mMEYxC1bz37R90nDLNRRCXAMRnsA/I2EtEZ+Sk8NCmMOzJ61cJV5CDFPy8ma+qXug86aIqARv4gpS3IJbzEqn7Nt5P4eLj2cGWzdlqOQGEJLERq4YUm9B6Ys3/mBe28wKonK+od6ZBK6qCG7IBXYEE5nPPv/h6s5mfhCywuw+jtW+p3m58uwQklAtknKMdbMKsgKwlSjQLcOMt3Y8PDszxECjYLpqGvRTsP4r6NJjxUP0Ekb0EtDzcxo6LYut1I9UmbMGkEEexgHzwNz0d1pesxVDyRmKhBMVJvIPMJkIl7sW63LqfWv9aIha+C5Asq9a41iO33nwD9s8gViRY7/j3G53+an9/7UnjpvuNgF50eep6ce0COG/Dem0QhOvqjUVOYfrDmnDFFSetZ93y/pHeO0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F8673772B63F847B78C72D015E0AD65@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: af456331-8a8c-46e6-9352-08d7987e0e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 23:12:26.9969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hULr1GiCuTZa89xDSRLsXftBcOYS1yK2q4Ul7uczgymdb6cdaRw+s2jCFDWzywjv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2767
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_08:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001130186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:50:23AM +0100, Jakub Sitnicki wrote:
> Tooling that populates the SOCKMAP with sockets from user-space needs a w=
ay
> to inspect its contents. Returning the struct sock * that SOCKMAP holds t=
o
> user-space is neither safe nor useful. An approach established by
> REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
> instead.
>=20
> Since socket cookies are u64 values SOCKMAP needs to support such a value
> size for lookup to be possible. This requires special handling on update,
> though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
> with ENOSPC error.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index d1a91e41ff82..3731191a7d1e 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -10,6 +10,7 @@
>  #include <linux/skmsg.h>
>  #include <linux/list.h>
>  #include <linux/jhash.h>
> +#include <linux/sock_diag.h>
> =20
>  struct bpf_stab {
>  	struct bpf_map map;
> @@ -31,7 +32,8 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *a=
ttr)
>  		return ERR_PTR(-EPERM);
>  	if (attr->max_entries =3D=3D 0 ||
>  	    attr->key_size    !=3D 4 ||
> -	    attr->value_size  !=3D 4 ||
> +	    (attr->value_size !=3D sizeof(u32) &&
> +	     attr->value_size !=3D sizeof(u64)) ||
>  	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
>  		return ERR_PTR(-EINVAL);
> =20
> @@ -298,6 +300,23 @@ static void *sock_map_lookup(struct bpf_map *map, vo=
id *key)
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> =20
> +static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
> +{
> +	struct sock *sk;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
It seems unnecessary.  It is only called by syscall.c which
holds the rcu_read_lock().  Other than that,

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +
> +	if (map->value_size !=3D sizeof(u64))
> +		return ERR_PTR(-ENOSPC);
> +
> +	sk =3D __sock_map_lookup_elem(map, *(u32 *)key);
> +	if (!sk)
> +		return ERR_PTR(-ENOENT);
> +
> +	sock_gen_cookie(sk);
> +	return &sk->sk_cookie;
> +}
> +
