Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9285AEC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfHHGkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:40:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731325AbfHHGkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 02:40:17 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x786bReF002688;
        Wed, 7 Aug 2019 23:39:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=os6bS8kcoQ+358AZituoLT/A+65pzk3NcUfaMqe58/o=;
 b=kveJLjMoMhq21oD9WVEkygTDuvJh7W4A/rCCdi4IlRD5teNtAYHd0Dj6eiaZDsh8RO+Q
 lGTumchkvhu83KePAWV+BpINPpqaobUTrzn1lSDAnOm2Kwi1381Uk98uSSDoT8yKpvlH
 Qd5l0aV2rIOYC0ZBopX1udbDoJbW4W7OgSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u87tss39r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Aug 2019 23:39:51 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 23:39:51 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 23:39:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm/G2rh1Vsho2Sx+Q2Te/ThdLN+aJsK4nIaK36iXNEi9MbvEzO+TaVk9A4i5jFLsrpvIrhRD02owTErBvmlSldDFX7JgcawQn24MYu7lORKuxU8Z5BvsJcYgLNMENt/dY8HjKQsLBCHPdNW6OC0Hje7Y1ByVkWST0hBeXDFGiDY6A6Ucivix7eD3qrQjux0gB/ZYG9y8rR/EV/YGsxBcb95fpRM1nVnmTGWWRV4G5JsvHEb51A+PzXuFCOk6ngQKnpMsoi10S9NyKO27SqBrufkvjqXwX/HVXN4QpC9cLb1pPYT5gS2sWjXUyhYgkMYiU9UNuJHUP0nTYSUzCdaMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=os6bS8kcoQ+358AZituoLT/A+65pzk3NcUfaMqe58/o=;
 b=bTTgIfOZpMvnL55c/SdebnUw9DjVgJMfpP2zCviD0By3KBu+pqJBA1xjCIiaW/wUKLktPoV3JmbXHxyN0BMD30AQVLxKjgXUnGKgReewsx2droemXIb5qmp2RhPuNKGtS4T0iB6HHBaia8/VDzVmozgxp+mkpsBfdaMJpy8WqhuamRIjukskI1RgSwup3y2PoR69j1fG+mTciMi6eAwf17v5IjKrTxuxZUg1slC6iD9EPels3/cL0snxixlvF1cqfOqDJcO4P3sWyR6K7JffZlL21E1LR0ESfrROUJMZHDAuKfiussqX6wEj9ecM6eSJO6ljv0st8vB6PGJeQRXF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=os6bS8kcoQ+358AZituoLT/A+65pzk3NcUfaMqe58/o=;
 b=i90h7xsgi/V8NmewP9bWEMMg8VoPAsXSK6nH4qUduCZRl5g5yzPPJlzpfQFkYQa+v/RHK+0hSNlZtJ1KrhVcr1pTbJbhiAoPdxiAqVhKrqFj9MEWQHdkg7KzlP73uBr3xY5pPQ/Eeb6BOc2jk6fsAfw/CKpP0X45viKaCXi0Yos=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1837.namprd15.prod.outlook.com (10.174.255.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.15; Thu, 8 Aug 2019 06:39:49 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a%3]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 06:39:49 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Topic: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Index: AQHVTTduqbJFH1x3FkOpJFu+AIokkKbwza8A
Date:   Thu, 8 Aug 2019 06:39:49 +0000
Message-ID: <20190808063936.3p4ahtdkw35rrzqu@kafai-mbp>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
In-Reply-To: <20190807154720.260577-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:102:1::22) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a50f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4aad060a-98fa-4f17-c1bb-08d71bcb358b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1837;
x-ms-traffictypediagnostic: MWHPR15MB1837:
x-microsoft-antispam-prvs: <MWHPR15MB18370379B5CAD75A0CFAA51AD5D70@MWHPR15MB1837.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(64756008)(66476007)(25786009)(54906003)(6916009)(316002)(14454004)(6116002)(99286004)(33716001)(1076003)(52116002)(186003)(46003)(2906002)(6506007)(446003)(5660300002)(386003)(478600001)(102836004)(11346002)(486006)(66946007)(6246003)(8936002)(81156014)(476003)(4326008)(86362001)(53936002)(76176011)(14444005)(256004)(71200400001)(305945005)(7736002)(6436002)(71190400001)(9686003)(6512007)(6486002)(229853002)(8676002)(66556008)(81166006)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1837;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 15h+u4povO1iQYk2PRsMRewdFt4v20rjKY0Z8+cLFYvr8bZxSe6r3pAHZ0lQ6rd8R2p7Xu1tb8dndlEdwH4b45WEqTrlgSpLMZjOfZqDZZnoHw7lT3cwcbzAH+dgmeEc4zJ98uf4OQ1nYCtBw2vADQtSBDeEWuCRfbgYl1JRn+4uFT1bwBY00rqdizd2lNV6qG1iAat2qsBCedGdl5ocVJ5/I7q+Pmk/iWu0fP62xDYam+80Gm8D0EdO6pioSMdspjSF7+Rpn7jhPoZowEQ5Ffby4dAv56HJDOGdBX6RxUE+KSCyuMuDNXEvZyoJ/7Twjf6Izkq5LGJL5WPemlrWdaGaUnYgUaEkHM8leQ9QurgUMWw7eD33TCoWIjb4/eHkHLuCYiyR9m2zny9oWe7MtJCsSeZxXt7qpquDv/fn7Jk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B06577F9599ED42AAD608FFDDA8B9C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aad060a-98fa-4f17-c1bb-08d71bcb358b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 06:39:49.4383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QgaoLOKenYKYpAf7shm2hAG7olze3xUXTHOLVbP9Wk/g3p4Dhk0Yp+YbSrc/xPQ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1837
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 08:47:18AM -0700, Stanislav Fomichev wrote:
> Add new helper bpf_sk_storage_clone which optionally clones sk storage
> and call it from bpf_sk_storage_clone. Reuse the gap in
> bpf_sk_storage_elem to store clone/non-clone flag.
>=20
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/bpf_sk_storage.h |  10 ++++
>  include/uapi/linux/bpf.h     |   1 +
>  net/core/bpf_sk_storage.c    | 102 +++++++++++++++++++++++++++++++++--
>  net/core/sock.c              |   9 ++--
>  4 files changed, 115 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
> index b9dcb02e756b..8e4f831d2e52 100644
> --- a/include/net/bpf_sk_storage.h
> +++ b/include/net/bpf_sk_storage.h
> @@ -10,4 +10,14 @@ void bpf_sk_storage_free(struct sock *sk);
>  extern const struct bpf_func_proto bpf_sk_storage_get_proto;
>  extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
> =20
> +#ifdef CONFIG_BPF_SYSCALL
> +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk);
> +#else
> +static inline int bpf_sk_storage_clone(const struct sock *sk,
> +				       struct sock *newsk)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _BPF_SK_STORAGE_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4393bd4b2419..00459ca4c8cf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2931,6 +2931,7 @@ enum bpf_func_id {
> =20
>  /* BPF_FUNC_sk_storage_get flags */
>  #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
> +#define BPF_SK_STORAGE_GET_F_CLONE	(1ULL << 1)
It is only used in bpf_sk_storage_get().
What if the elem is created from bpf_fd_sk_storage_update_elem()
i.e. from the syscall API ?

What may be the use case for a map to have both CLONE and non-CLONE
elements?  If it is not the case, would it be better to add
BPF_F_CLONE to bpf_attr->map_flags?

> =20
>  /* Mode for BPF_FUNC_skb_adjust_room helper. */
>  enum bpf_adj_room_mode {
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 94c7f77ecb6b..b6dea67965bc 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -12,6 +12,9 @@
> =20
>  static atomic_t cache_idx;
> =20
> +#define BPF_SK_STORAGE_GET_F_MASK	(BPF_SK_STORAGE_GET_F_CREATE | \
> +					 BPF_SK_STORAGE_GET_F_CLONE)
> +
>  struct bucket {
>  	struct hlist_head list;
>  	raw_spinlock_t lock;
> @@ -66,7 +69,8 @@ struct bpf_sk_storage_elem {
>  	struct hlist_node snode;	/* Linked to bpf_sk_storage */
>  	struct bpf_sk_storage __rcu *sk_storage;
>  	struct rcu_head rcu;
> -	/* 8 bytes hole */
> +	u8 clone:1;
> +	/* 7 bytes hole */
>  	/* The data is stored in aother cacheline to minimize
>  	 * the number of cachelines access during a cache hit.
>  	 */
> @@ -509,7 +513,7 @@ static int sk_storage_delete(struct sock *sk, struct =
bpf_map *map)
>  	return 0;
>  }
> =20
> -/* Called by __sk_destruct() */
> +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
>  void bpf_sk_storage_free(struct sock *sk)
>  {
>  	struct bpf_sk_storage_elem *selem;
> @@ -739,19 +743,106 @@ static int bpf_fd_sk_storage_delete_elem(struct bp=
f_map *map, void *key)
>  	return err;
>  }
> =20
> +static struct bpf_sk_storage_elem *
> +bpf_sk_storage_clone_elem(struct sock *newsk,
> +			  struct bpf_sk_storage_map *smap,
> +			  struct bpf_sk_storage_elem *selem)
> +{
> +	struct bpf_sk_storage_elem *copy_selem;
> +
> +	copy_selem =3D selem_alloc(smap, newsk, NULL, true);
> +	if (!copy_selem)
> +		return ERR_PTR(-ENOMEM);
nit.
may be just return NULL as selem_alloc() does.

> +
> +	if (map_value_has_spin_lock(&smap->map))
> +		copy_map_value_locked(&smap->map, SDATA(copy_selem)->data,
> +				      SDATA(selem)->data, true);
> +	else
> +		copy_map_value(&smap->map, SDATA(copy_selem)->data,
> +			       SDATA(selem)->data);
> +
> +	return copy_selem;
> +}
> +
> +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
> +{
> +	struct bpf_sk_storage *new_sk_storage =3D NULL;
> +	struct bpf_sk_storage *sk_storage;
> +	struct bpf_sk_storage_elem *selem;
> +	int ret;
> +
> +	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> +
> +	rcu_read_lock();
> +	sk_storage =3D rcu_dereference(sk->sk_bpf_storage);
> +
> +	if (!sk_storage || hlist_empty(&sk_storage->list))
> +		goto out;
> +
> +	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
> +		struct bpf_sk_storage_map *smap;
> +		struct bpf_sk_storage_elem *copy_selem;
> +
> +		if (!selem->clone)
> +			continue;
> +
> +		smap =3D rcu_dereference(SDATA(selem)->smap);
> +		if (!smap)
smap should not be NULL.

> +			continue;
> +
> +		copy_selem =3D bpf_sk_storage_clone_elem(newsk, smap, selem);
> +		if (IS_ERR(copy_selem)) {
> +			ret =3D PTR_ERR(copy_selem);
> +			goto err;
> +		}
> +
> +		if (!new_sk_storage) {
> +			ret =3D sk_storage_alloc(newsk, smap, copy_selem);
> +			if (ret) {
> +				kfree(copy_selem);
> +				atomic_sub(smap->elem_size,
> +					   &newsk->sk_omem_alloc);
> +				goto err;
> +			}
> +
> +			new_sk_storage =3D rcu_dereference(copy_selem->sk_storage);
> +			continue;
> +		}
> +
> +		raw_spin_lock_bh(&new_sk_storage->lock);
> +		selem_link_map(smap, copy_selem);
Unlike the existing selem-update use-cases in bpf_sk_storage.c,
the smap->map.refcnt has not been held here.  Reading the smap
is fine.  However, adding a new selem to a deleting smap is an issue.
Hence, I think bpf_map_inc_not_zero() should be done first.

> +		__selem_link_sk(new_sk_storage, copy_selem);
> +		raw_spin_unlock_bh(&new_sk_storage->lock);
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +	return 0;
> +
> +err:
> +	rcu_read_unlock();
> +
> +	bpf_sk_storage_free(newsk);
> +	return ret;
> +}
> +
>  BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
>  	   void *, value, u64, flags)
>  {
>  	struct bpf_sk_storage_data *sdata;
> =20
> -	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
> +	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
> +		return (unsigned long)NULL;
> +
> +	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
> +	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
>  		return (unsigned long)NULL;
> =20
>  	sdata =3D sk_storage_lookup(sk, map, true);
>  	if (sdata)
>  		return (unsigned long)sdata->data;
> =20
> -	if (flags =3D=3D BPF_SK_STORAGE_GET_F_CREATE &&
> +	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
>  	    /* Cannot add new elem to a going away sk.
>  	     * Otherwise, the new elem may become a leak
>  	     * (and also other memory issues during map
> @@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map,=
 struct sock *, sk,
>  		/* sk must be a fullsock (guaranteed by verifier),
>  		 * so sock_gen_put() is unnecessary.
>  		 */
> +		if (!IS_ERR(sdata))
> +			SELEM(sdata)->clone =3D
> +				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
>  		sock_put(sk);
>  		return IS_ERR(sdata) ?
>  			(unsigned long)NULL : (unsigned long)sdata->data;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index d57b0cc995a0..f5e801a9cea4 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *sk, =
const gfp_t priority)
>  			goto out;
>  		}
>  		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> -#ifdef CONFIG_BPF_SYSCALL
> -		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> -#endif
> +
> +		if (bpf_sk_storage_clone(sk, newsk)) {
> +			sk_free_unlock_clone(newsk);
> +			newsk =3D NULL;
> +			goto out;
> +		}
> =20
>  		newsk->sk_err	   =3D 0;
>  		newsk->sk_err_soft =3D 0;
> --=20
> 2.22.0.770.g0f2c4a37fd-goog
>=20
