Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E38AC7D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfHMBsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:48:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbfHMBsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 21:48:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D1jAHF024281;
        Mon, 12 Aug 2019 18:48:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HdL44Nxw7zmUhz6O8O2JjHnb1BoE2g5Gr75Xbyz/F50=;
 b=U9tvXFAyOEqLYzgbnI4fHg1m/UrYY12PiayncAVaWZWokLB4whAoGadEpY8zoWCX7v8N
 SmHJRni3Q0kETF0jfHD0tCsHLcj/3PGAv6ksZJhnFFdKXrotNjak4P5Pwydty4wcNSkS
 dB0CY4Pdlf/5JEJddw3zufk0/7ct+dM/ByI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ubbta21x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Aug 2019 18:48:03 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 18:48:01 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 18:48:01 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Aug 2019 18:48:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDYMzCPhCPChWUumtqivm2m3kORvjt34z7LQhPCiZLzRMlLMzehw2lpuHVQDVkmycsHXFIeaZcXBl+PILeF9MndZcX8SVZQrC5AR/GM84VSBfWeqS5LDmgvXGKLCdyyU8FvxU9i+IksumBfnwIVenV3D49mG1hwGPMVopyxoQhXwu17hNwfRmcw8W5NbLUVBZJsOkBz6o4Cwv5xeF5BTCfVurjleQIILuL/QCqKbxPy9LUx9v8I3BVHacEwZiH/azfRXUl9ZiigZ4DG/MmGwzVJuFmyZ6/ZT2/dVHM9RRmygtanPpqhcEhqHaumOSR7uz5CntLRh3v/P6UJ1xxfzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdL44Nxw7zmUhz6O8O2JjHnb1BoE2g5Gr75Xbyz/F50=;
 b=BzYy5kL6i1Jcc3ePltqY8xKuI9redYXWNkGCISvK6CWEC9H9TqCYOxVfrVMPVky07FU+10FYO6z4PcJ71q+pXJwIXmEEiAT8q3AHGEILTR13qC6UGqr1V/1aB4ddcz6OSmA5Y9oLvs0GW6ni+EDD7QUvZXOyddBeXNUISK7AG3VrezOvIOI1xRwu3bCB1i0txQNKKOTp1FdYvRmxuQwdSlaHCjtnOVmMI9MgkQAi4oqR9P8JtgMBrLniVR6CfrwqnLwwTcfArN3mCfOVNoNwaq0v7XyaVW5TWuwzLVoEdC19ExtNm7mI3nekyuTY1ZaL1I3jWmci2SRqW88Pv+/Mog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdL44Nxw7zmUhz6O8O2JjHnb1BoE2g5Gr75Xbyz/F50=;
 b=ZwOsD2bG0tAIgDDeAxvQUXrqK41kYqMM6WabJo5grMrOMAjwBqDd/MacLEtbLJCR7tpieeS/OQED/vnYXcEXUXzpDB+m+r0tiFcO5XjK0aJQcIXLHzN/vKb3SY40qDpgeaOnio+0sfxLZYGx6zR6T1jcgTVOMfXXIoaiv/yeotI=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1277.namprd15.prod.outlook.com (10.175.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Tue, 13 Aug 2019 01:47:59 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a%3]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 01:47:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Thread-Topic: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Thread-Index: AQHVTs0IaXH93kXjvU66dmstTIcToqb4VKOA
Date:   Tue, 13 Aug 2019 01:47:59 +0000
Message-ID: <20190813014753.vftgwwzqxzx2pawg@kafai-mbp>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-3-sdf@google.com>
In-Reply-To: <20190809161038.186678-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:301:3b::45) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d20204ee-ebdf-4649-e8bf-08d71f9044c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1277;
x-ms-traffictypediagnostic: MWHPR15MB1277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB127792A4AF98532953D0AF28D5D20@MWHPR15MB1277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(199004)(189003)(81166006)(6506007)(86362001)(8936002)(6436002)(53936002)(386003)(478600001)(81156014)(102836004)(4326008)(2906002)(54906003)(6486002)(256004)(5024004)(52116002)(486006)(66476007)(64756008)(66556008)(14454004)(33716001)(76176011)(476003)(14444005)(66946007)(66446008)(11346002)(446003)(46003)(25786009)(5660300002)(7736002)(6116002)(229853002)(305945005)(186003)(8676002)(1076003)(6512007)(316002)(71200400001)(9686003)(71190400001)(6246003)(99286004)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1277;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rJktaCao52ljyDnIyXCvZFqVN2rr9PzSuke+1cL+/Q/vXWtEhPf8uFz4J/uJivWqnNd37iMovO1adAE8VKFzxGy8/0CGjedehgXKHsXVhjGNP57ipTiiEk0mbP2xjoofv1nAACOF2IpF9iCHR4/AbPzvZhghQfopXps9TePzCdq8kQOK2RxGPgQHSfoeV6zwJOkscmot75q933tXq8fsqEk/FDS3p/8O1h71BW2l2BNjZi/MRbXkDaO/VyctvW2DP8SxFkr3etLs3ZiOHQed0qY+FGDO+OKgK3FyCsGcD8psX9CwjDPGgj8vzR5RpUmYoYHAp2vAaSTHOBvWTyzLk3ZzZIz+GCdb7tadf1ud646JJtdLNpJ+pch+b+L1EdtSeGJQ3TkWC2uGEHNbt84RqgHAQ9BFSH8fff1GWia1TZI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0506C9D3B5F66346A167D51E983AE1CF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d20204ee-ebdf-4649-e8bf-08d71f9044c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 01:47:59.1785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izyg+3UFxv73KyL2QHlFXRJ/YgbdSUpZFdHEvCarOrz0rZ5zDSPu7VMO3LV0UisA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130016
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 09:10:36AM -0700, Stanislav Fomichev wrote:
> Add new helper bpf_sk_storage_clone which optionally clones sk storage
> and call it from sk_clone_lock.
Thanks for v2.  Sorry for the delay.  I am traveling.

>=20
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/bpf_sk_storage.h |  10 ++++
>  include/uapi/linux/bpf.h     |   3 ++
>  net/core/bpf_sk_storage.c    | 100 +++++++++++++++++++++++++++++++++--
>  net/core/sock.c              |   9 ++--
>  4 files changed, 116 insertions(+), 6 deletions(-)
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
> index 4393bd4b2419..0ef594ac3899 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -337,6 +337,9 @@ enum bpf_attach_type {
>  #define BPF_F_RDONLY_PROG	(1U << 7)
>  #define BPF_F_WRONLY_PROG	(1U << 8)
> =20
> +/* Clone map from listener for newly accepted socket */
> +#define BPF_F_CLONE		(1U << 9)
> +
>  /* flags for BPF_PROG_QUERY */
>  #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
> =20
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 94c7f77ecb6b..584e08ee0ca3 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -12,6 +12,9 @@
> =20
>  static atomic_t cache_idx;
> =20
> +#define SK_STORAGE_CREATE_FLAG_MASK					\
> +	(BPF_F_NO_PREALLOC | BPF_F_CLONE)
> +
>  struct bucket {
>  	struct hlist_head list;
>  	raw_spinlock_t lock;
> @@ -209,7 +212,6 @@ static void selem_unlink_sk(struct bpf_sk_storage_ele=
m *selem)
>  		kfree_rcu(sk_storage, rcu);
>  }
> =20
> -/* sk_storage->lock must be held and sk_storage->list cannot be empty */
>  static void __selem_link_sk(struct bpf_sk_storage *sk_storage,
>  			    struct bpf_sk_storage_elem *selem)
>  {
> @@ -509,7 +511,7 @@ static int sk_storage_delete(struct sock *sk, struct =
bpf_map *map)
>  	return 0;
>  }
> =20
> -/* Called by __sk_destruct() */
> +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
>  void bpf_sk_storage_free(struct sock *sk)
>  {
>  	struct bpf_sk_storage_elem *selem;
> @@ -557,6 +559,11 @@ static void bpf_sk_storage_map_free(struct bpf_map *=
map)
> =20
>  	smap =3D (struct bpf_sk_storage_map *)map;
> =20
> +	/* Note that this map might be concurrently cloned from
> +	 * bpf_sk_storage_clone. Wait for any existing bpf_sk_storage_clone
> +	 * RCU read section to finish before proceeding. New RCU
> +	 * read sections should be prevented via bpf_map_inc_not_zero.
> +	 */
Thanks!

>  	synchronize_rcu();
> =20
>  	/* bpf prog and the userspace can no longer access this map
> @@ -601,7 +608,8 @@ static void bpf_sk_storage_map_free(struct bpf_map *m=
ap)
> =20
>  static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
>  {
> -	if (attr->map_flags !=3D BPF_F_NO_PREALLOC || attr->max_entries ||
> +	if (attr->map_flags & ~SK_STORAGE_CREATE_FLAG_MASK ||
> +	    attr->max_entries ||
I think "!(attr->map_flags & BPF_F_NO_PREALLOC)" should also be needed.

>  	    attr->key_size !=3D sizeof(int) || !attr->value_size ||
>  	    /* Enforce BTF for userspace sk dumping */
>  	    !attr->btf_key_type_id || !attr->btf_value_type_id)
> @@ -739,6 +747,92 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_=
map *map, void *key)
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
> +		return NULL;
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
> +		struct bpf_sk_storage_elem *copy_selem;
> +		struct bpf_sk_storage_map *smap;
> +		struct bpf_map *map;
> +		int refold;
> +
> +		smap =3D rcu_dereference(SDATA(selem)->smap);
> +		if (!(smap->map.map_flags & BPF_F_CLONE))
> +			continue;
> +
> +		map =3D bpf_map_inc_not_zero(&smap->map, false);
> +		if (IS_ERR(map))
> +			continue;
> +
> +		copy_selem =3D bpf_sk_storage_clone_elem(newsk, smap, selem);
> +		if (!copy_selem) {
> +			ret =3D -ENOMEM;
> +			bpf_map_put(map);
> +			goto err;
> +		}
> +
> +		if (new_sk_storage) {
> +			selem_link_map(smap, copy_selem);
> +			__selem_link_sk(new_sk_storage, copy_selem);
> +		} else {
> +			ret =3D sk_storage_alloc(newsk, smap, copy_selem);
> +			if (ret) {
> +				kfree(copy_selem);
> +				atomic_sub(smap->elem_size,
> +					   &newsk->sk_omem_alloc);
> +				bpf_map_put(map);
> +				goto err;
> +			}
> +
> +			new_sk_storage =3D rcu_dereference(copy_selem->sk_storage);
> +		}
> +		bpf_map_put(map);
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
The later sk_free_unlock_clone(newsk) should eventually call
bpf_sk_storage_free(newsk) also?

Others LGTM.

> +	return ret;
> +}
> +
>  BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
>  	   void *, value, u64, flags)
>  {
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
> 2.23.0.rc1.153.gdeed80330f-goog
>=20
