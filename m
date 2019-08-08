Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE83868BC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfHHS2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:28:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfHHS2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:28:08 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78IPHJs027784;
        Thu, 8 Aug 2019 11:27:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RNlaM+7r256rn7275oY5DyEa4m3wOb4CuGAh0UaV30Y=;
 b=NidresSBzNGj7pN5YHAkZQyYQqVVsf2GoqCC4NtjywzKAFl6d3TCf9vGk0y9APuhOWbJ
 eAzz1gzF6I56okhk/6XUzOobiQ4Lwe1Q8LvFgoSu4OhuX+LCOqnDDTRo6sJfK1p/qvyJ
 ZSNRj6A/L8aIsyj8ClCKVAjfY74owH27GKI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8q76rgpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Aug 2019 11:27:40 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Aug 2019 11:27:39 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 11:27:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOs/VQi0CNmbvc4E2Mqnl9Vob1c/TQdur6W6bx/+yTMAUh/XSscMzx7934/Bvnz5bYKWjCiZWJJBmiMaijBL1LyCXfs0OacB9bRgQ6fMv4tpqmluRm1XyOzWWuNXnoanrsQjnKNMPP/6tQLJ4DJkzbvncDlQQVOrO4kLpzo+iiRBweVUOjLmZhM7peiS3BjdkCgrzFLobuhOsonTO2dnWgBtJFVi8a+Cwd73evD3LHUA6YM8/indzM/ZUOQdorooEh9vP2ocO5Q0dxe8D49UWBvXRNYdmaXqhub1nPu9qZ6AcFbPb0fl20W5PXZkaiJ1H1zi87OQ9XM/6zMk5lc6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNlaM+7r256rn7275oY5DyEa4m3wOb4CuGAh0UaV30Y=;
 b=RLhPMs01K6qjqm0VZBEdYaVv4+4WKVojycSP7JTXBEfl+i46+rQ7mM2KTuR0e13/TVF6wTTuWNxPBJWp7DDb6dquLL55CjeARdsbEikOSVDnOqcd6CyE2hr5XDwmeBss+gn+nInPnHDxWVUMhDR3b7ftp+ajjK/zJiHsbwBuVOSdUKuSXdSxF4kijOmDXuM7geGoHLoXH7/8mPoVqjZ8mCmfS0LVOukqgbd1/gMXgQgyXLywj0he5i3wgDvc8JjLlB2K67++3MT2Magk2ukw1XbKIgKUWILbAi/d3TgvCY6Vix474YpEbympaEEC9l2LEDnjtT4idWaXWx+m7gtAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNlaM+7r256rn7275oY5DyEa4m3wOb4CuGAh0UaV30Y=;
 b=YZLvjtt/L6DlFOBrPdvcwIylIfDuz+gY5Li035ryJ33Hsxa5VizxDcd4jjGgmsnODnbRps3Z30IIW014jeG1eV8Lb4bj3MueE9n/nmD9vgbQ0kI2TXlfxX/5PeWOziFUJZRKFXw17ksJzWWq1E9v/KoSjsjjED0W4a5tVeuDoGk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1695.namprd15.prod.outlook.com (10.175.142.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Thu, 8 Aug 2019 18:27:38 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a%3]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 18:27:38 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Topic: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Index: AQHVTTduqbJFH1x3FkOpJFu+AIokkKbwza8AgACTvwCAADIJgA==
Date:   Thu, 8 Aug 2019 18:27:37 +0000
Message-ID: <20190808182735.pimzots4a4vmi6ft@kafai-mbp.dhcp.thefacebook.com>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
 <20190808063936.3p4ahtdkw35rrzqu@kafai-mbp> <20190808152830.GC2820@mini-arch>
In-Reply-To: <20190808152830.GC2820@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0052.namprd14.prod.outlook.com
 (2603:10b6:300:81::14) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9dd4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dc36906-f4d3-4817-3c64-08d71c2e1704
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1695;
x-ms-traffictypediagnostic: MWHPR15MB1695:
x-microsoft-antispam-prvs: <MWHPR15MB16951C0E9BB75F2CFEC985A2D5D70@MWHPR15MB1695.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(366004)(39860400002)(396003)(189003)(199004)(316002)(446003)(7736002)(71190400001)(64756008)(11346002)(71200400001)(66446008)(66476007)(66556008)(14454004)(66946007)(229853002)(2906002)(305945005)(476003)(486006)(5660300002)(52116002)(99286004)(6506007)(102836004)(386003)(6916009)(76176011)(54906003)(186003)(8676002)(81166006)(81156014)(8936002)(6512007)(46003)(86362001)(9686003)(6246003)(1076003)(25786009)(53936002)(4326008)(256004)(14444005)(6436002)(6486002)(478600001)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1695;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dgqDS+zhbapmjteIEDqRNGpVMR3rtb8g1N18HB3OG8ibGu2Fc2em8mzjWFvSdvC1mYip4D8hH0sGQQM6OEptuKQ786TV14kmwFSVkrEV7VEqH4mpkpC4v3fwfcolyVfiLnid2KFLogzbNElCihphaLNffVBuLJv9cqE2vByv7neHRxwlscJGNWxrrPBZgusCR7ONcZguzAXEOEZk4362aSq/lhadk4yyaSnVXrokKQPGg8Ku3y2knSujfMtOJuYiUTa35jdDxjavKiYBZtMH8VR8P4+M9moBmIM8CsdvUpv5x+sx0NVoopQ5bxpwZHxzuckbimbgrRkG0kiWYj1v5qb90QGv+oFeggT7WDftM5Fg5GyH41eYSr6lJ4+7xtf87ipXiw9IWO9plP4CGxmQNhxwFCp1ataSv2A96xFFl+8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE680CEA5750484B8113B8909F9FCFF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc36906-f4d3-4817-3c64-08d71c2e1704
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 18:27:37.8710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2zn4Q4v0yH4GOQLJSLymGsu4D6U9wzNCjyWDvkbHUnFmPorbNzAEBjdGRZBULVb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 08:28:30AM -0700, Stanislav Fomichev wrote:
> On 08/08, Martin Lau wrote:
> > On Wed, Aug 07, 2019 at 08:47:18AM -0700, Stanislav Fomichev wrote:
> > > Add new helper bpf_sk_storage_clone which optionally clones sk storag=
e
> > > and call it from bpf_sk_storage_clone. Reuse the gap in
> > > bpf_sk_storage_elem to store clone/non-clone flag.
> > >=20
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/net/bpf_sk_storage.h |  10 ++++
> > >  include/uapi/linux/bpf.h     |   1 +
> > >  net/core/bpf_sk_storage.c    | 102 +++++++++++++++++++++++++++++++++=
--
> > >  net/core/sock.c              |   9 ++--
> > >  4 files changed, 115 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storag=
e.h
> > > index b9dcb02e756b..8e4f831d2e52 100644
> > > --- a/include/net/bpf_sk_storage.h
> > > +++ b/include/net/bpf_sk_storage.h
> > > @@ -10,4 +10,14 @@ void bpf_sk_storage_free(struct sock *sk);
> > >  extern const struct bpf_func_proto bpf_sk_storage_get_proto;
> > >  extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
> > > =20
> > > +#ifdef CONFIG_BPF_SYSCALL
> > > +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk);
> > > +#else
> > > +static inline int bpf_sk_storage_clone(const struct sock *sk,
> > > +				       struct sock *newsk)
> > > +{
> > > +	return 0;
> > > +}
> > > +#endif
> > > +
> > >  #endif /* _BPF_SK_STORAGE_H */
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 4393bd4b2419..00459ca4c8cf 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -2931,6 +2931,7 @@ enum bpf_func_id {
> > > =20
> > >  /* BPF_FUNC_sk_storage_get flags */
> > >  #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
> > > +#define BPF_SK_STORAGE_GET_F_CLONE	(1ULL << 1)
> > It is only used in bpf_sk_storage_get().
> > What if the elem is created from bpf_fd_sk_storage_update_elem()
> > i.e. from the syscall API ?
> >=20
> > What may be the use case for a map to have both CLONE and non-CLONE
> > elements?  If it is not the case, would it be better to add
> > BPF_F_CLONE to bpf_attr->map_flags?
> I didn't think about putting it on the map itself since the API
> is on a per-element, but it does make sense. I can't come up
> with a use-case for a per-element selective clone/non-clone.
> Thanks, will move to the map itself.
>=20
> > > =20
> > >  /* Mode for BPF_FUNC_skb_adjust_room helper. */
> > >  enum bpf_adj_room_mode {
> > > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > > index 94c7f77ecb6b..b6dea67965bc 100644
> > > --- a/net/core/bpf_sk_storage.c
> > > +++ b/net/core/bpf_sk_storage.c
> > > @@ -12,6 +12,9 @@
> > > =20
> > >  static atomic_t cache_idx;
> > > =20
> > > +#define BPF_SK_STORAGE_GET_F_MASK	(BPF_SK_STORAGE_GET_F_CREATE | \
> > > +					 BPF_SK_STORAGE_GET_F_CLONE)
> > > +
> > >  struct bucket {
> > >  	struct hlist_head list;
> > >  	raw_spinlock_t lock;
> > > @@ -66,7 +69,8 @@ struct bpf_sk_storage_elem {
> > >  	struct hlist_node snode;	/* Linked to bpf_sk_storage */
> > >  	struct bpf_sk_storage __rcu *sk_storage;
> > >  	struct rcu_head rcu;
> > > -	/* 8 bytes hole */
> > > +	u8 clone:1;
> > > +	/* 7 bytes hole */
> > >  	/* The data is stored in aother cacheline to minimize
> > >  	 * the number of cachelines access during a cache hit.
> > >  	 */
> > > @@ -509,7 +513,7 @@ static int sk_storage_delete(struct sock *sk, str=
uct bpf_map *map)
> > >  	return 0;
> > >  }
> > > =20
> > > -/* Called by __sk_destruct() */
> > > +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
> > >  void bpf_sk_storage_free(struct sock *sk)
> > >  {
> > >  	struct bpf_sk_storage_elem *selem;
> > > @@ -739,19 +743,106 @@ static int bpf_fd_sk_storage_delete_elem(struc=
t bpf_map *map, void *key)
> > >  	return err;
> > >  }
> > > =20
> > > +static struct bpf_sk_storage_elem *
> > > +bpf_sk_storage_clone_elem(struct sock *newsk,
> > > +			  struct bpf_sk_storage_map *smap,
> > > +			  struct bpf_sk_storage_elem *selem)
> > > +{
> > > +	struct bpf_sk_storage_elem *copy_selem;
> > > +
> > > +	copy_selem =3D selem_alloc(smap, newsk, NULL, true);
> > > +	if (!copy_selem)
> > > +		return ERR_PTR(-ENOMEM);
> > nit.
> > may be just return NULL as selem_alloc() does.
> Sounds good.
>=20
> > > +
> > > +	if (map_value_has_spin_lock(&smap->map))
> > > +		copy_map_value_locked(&smap->map, SDATA(copy_selem)->data,
> > > +				      SDATA(selem)->data, true);
> > > +	else
> > > +		copy_map_value(&smap->map, SDATA(copy_selem)->data,
> > > +			       SDATA(selem)->data);
> > > +
> > > +	return copy_selem;
> > > +}
> > > +
> > > +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
> > > +{
> > > +	struct bpf_sk_storage *new_sk_storage =3D NULL;
> > > +	struct bpf_sk_storage *sk_storage;
> > > +	struct bpf_sk_storage_elem *selem;
> > > +	int ret;
> > > +
> > > +	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > > +
> > > +	rcu_read_lock();
> > > +	sk_storage =3D rcu_dereference(sk->sk_bpf_storage);
> > > +
> > > +	if (!sk_storage || hlist_empty(&sk_storage->list))
> > > +		goto out;
> > > +
> > > +	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
> > > +		struct bpf_sk_storage_map *smap;
> > > +		struct bpf_sk_storage_elem *copy_selem;
> > > +
> > > +		if (!selem->clone)
> > > +			continue;
> > > +
> > > +		smap =3D rcu_dereference(SDATA(selem)->smap);
> > > +		if (!smap)
> > smap should not be NULL.
> I see; you never set it back to NULL and we are guaranteed that the
> map is still around due to rcu. Removed.
>=20
> > > +			continue;
> > > +
> > > +		copy_selem =3D bpf_sk_storage_clone_elem(newsk, smap, selem);
> > > +		if (IS_ERR(copy_selem)) {
> > > +			ret =3D PTR_ERR(copy_selem);
> > > +			goto err;
> > > +		}
> > > +
> > > +		if (!new_sk_storage) {
> > > +			ret =3D sk_storage_alloc(newsk, smap, copy_selem);
> > > +			if (ret) {
> > > +				kfree(copy_selem);
> > > +				atomic_sub(smap->elem_size,
> > > +					   &newsk->sk_omem_alloc);
> > > +				goto err;
> > > +			}
> > > +
> > > +			new_sk_storage =3D rcu_dereference(copy_selem->sk_storage);
> > > +			continue;
> > > +		}
> > > +
> > > +		raw_spin_lock_bh(&new_sk_storage->lock);
> > > +		selem_link_map(smap, copy_selem);
> > Unlike the existing selem-update use-cases in bpf_sk_storage.c,
> > the smap->map.refcnt has not been held here.  Reading the smap
> > is fine.  However, adding a new selem to a deleting smap is an issue.
> > Hence, I think bpf_map_inc_not_zero() should be done first.
> In this case, I should probably do it after smap =3D rcu_deref()?
Right.

and bpf_map_put should be called when done.  Becasue of bpf_map_put,
it may be a good idea to add a comment to the first synchronize_rcu()
in bpf_sk_storage_map_free() since this new bpf_sk_storage_clone()
also depends on it now,
which makes it different from other bpf maps.

>=20
> > > +		__selem_link_sk(new_sk_storage, copy_selem);
> > > +		raw_spin_unlock_bh(&new_sk_storage->lock);
> > > +	}
> > > +
> > > +out:
> > > +	rcu_read_unlock();
> > > +	return 0;
> > > +
> > > +err:
> > > +	rcu_read_unlock();
> > > +
> > > +	bpf_sk_storage_free(newsk);
> > > +	return ret;
> > > +}
> > > +
> > >  BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *,=
 sk,
> > >  	   void *, value, u64, flags)
> > >  {
> > >  	struct bpf_sk_storage_data *sdata;
> > > =20
> > > -	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
> > > +	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
> > > +		return (unsigned long)NULL;
> > > +
> > > +	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
> > > +	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
> > >  		return (unsigned long)NULL;
> > > =20
> > >  	sdata =3D sk_storage_lookup(sk, map, true);
> > >  	if (sdata)
> > >  		return (unsigned long)sdata->data;
> > > =20
> > > -	if (flags =3D=3D BPF_SK_STORAGE_GET_F_CREATE &&
> > > +	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
> > >  	    /* Cannot add new elem to a going away sk.
> > >  	     * Otherwise, the new elem may become a leak
> > >  	     * (and also other memory issues during map
> > > @@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, =
map, struct sock *, sk,
> > >  		/* sk must be a fullsock (guaranteed by verifier),
> > >  		 * so sock_gen_put() is unnecessary.
> > >  		 */
> > > +		if (!IS_ERR(sdata))
> > > +			SELEM(sdata)->clone =3D
> > > +				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
> > >  		sock_put(sk);
> > >  		return IS_ERR(sdata) ?
> > >  			(unsigned long)NULL : (unsigned long)sdata->data;
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index d57b0cc995a0..f5e801a9cea4 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *=
sk, const gfp_t priority)
> > >  			goto out;
> > >  		}
> > >  		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> > > -#ifdef CONFIG_BPF_SYSCALL
> > > -		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > > -#endif
> > > +
> > > +		if (bpf_sk_storage_clone(sk, newsk)) {
> > > +			sk_free_unlock_clone(newsk);
> > > +			newsk =3D NULL;
> > > +			goto out;
> > > +		}
> > > =20
> > >  		newsk->sk_err	   =3D 0;
> > >  		newsk->sk_err_soft =3D 0;
> > > --=20
> > > 2.22.0.770.g0f2c4a37fd-goog
> > >=20
