Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3196585B4E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 09:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbfHHHMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 03:12:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12786 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbfHHHMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 03:12:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x787BaTi013242;
        Thu, 8 Aug 2019 00:11:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=c9VAO91CG+im/SjGsu6qcToZJhBFT6zoDWRYgg3EAEI=;
 b=Mv276Cc4LefcNiF2hSlYUvwo7k7o47Qk2i/o3oFEpsewrCwOtvGveZbll3RIEu6dSS/e
 ++71G++/KDRB4y0G3/rwqtEDs0fqi+RKEJWpkytikDlPeanBAB35DmkVSMk8fmIapuU+
 IBOTW7IuF3eZclitx/xf79EZr5jXofHaSlo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u87u1h64y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 00:11:49 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 00:11:43 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 00:11:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 00:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk2fjSTQrq8rTaXf+kr8YQM+HNsC+a0rCQBq5wWkpwsI4uMqoXHL2BIOc6h1C11ErWo/H9Xa1yVP+rcoH+CGxen+NWwmzHECtSY2H+ZssoxHbRMlZVFkdP4rP8NM+iomMTPR8Mi/S21D08MnswJniRm2L418nORmsO7CFieGsYNtShNdrU3oJBbNNfhoXdTPeJipDRO/0Nx3HJrx1L85F9U+It+ZZdu3jkYW3mjMwogJVP86E6USPNGz9DR5E+9/xo8i1Cs1SabreL8B2Q+2jpaQBu6Qnh8rD7ddoVCu054UEQNOKCvo4+d6X4w8lmtotHztkOCyLiQIx0Zrqk/87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9VAO91CG+im/SjGsu6qcToZJhBFT6zoDWRYgg3EAEI=;
 b=M8ZW1wIKZ+CsIqARwU4f4yqEnFBETVqlUU8JD6Q7mAoOf3aVOyGUqWbRIt5ycLteKQxRSw0Jz4evV9LwAiCpTxA/jbChNYmOCZQNIdp+ccx8XXBZwhAStz71fTzJz/L0XWvbesG7UMcN+DrsfaNNsvqJzDdm3RPMNqb5tTV4ldZCYXP7ow8eK6EllLiVacgjo7kuJzfcyoNV2OFQiYSS5mYEu1j2YSPg6J1CWhjMLA4sDq/vmbdTOE9mTFpULrcgzMeSX0H1pGOJvZKYmnFbKKHbJCvUe06UVrQTdHp9HkzE8Pm5u0wegii9Hjk4R9GdyUq8hu3GkSefLGxPcpHD4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9VAO91CG+im/SjGsu6qcToZJhBFT6zoDWRYgg3EAEI=;
 b=J4wze5OdApy1XIU4z7GCViNJ4KcwGLOuZskgyExvOhCi/EpHdz8iEJ1F+87lA1c31g5oQIpZUURGZF1BnzmJ0zAhfG4GnGrQMhggCh1T9w70Lgu9uuuZ+7EMlESqgWqrSGYXqvcMIHFvMcIrFyq/uAxcs1b+m69MYf0rq2ad3zA=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1614.namprd15.prod.outlook.com (10.175.140.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 07:11:41 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a%3]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 07:11:41 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Topic: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Index: AQHVTTduqbJFH1x3FkOpJFu+AIokkKbwTkSAgAARS4CAAHcHAA==
Date:   Thu, 8 Aug 2019 07:11:41 +0000
Message-ID: <20190808071134.bfekidamavbyjrcy@kafai-mbp.dhcp.thefacebook.com>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
 <9bd56e49-c38d-e1c4-1ff3-8250531d0d48@fb.com>
 <20190808000533.GA2820@mini-arch>
In-Reply-To: <20190808000533.GA2820@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0021.namprd21.prod.outlook.com
 (2603:10b6:302:1::34) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a50f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0edc136-b37e-483e-b2f3-08d71bcfa98d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1614;
x-ms-traffictypediagnostic: MWHPR15MB1614:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16140DE490CC7761A04AFB84D5D70@MWHPR15MB1614.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(102836004)(256004)(4326008)(486006)(6116002)(316002)(1076003)(229853002)(46003)(76176011)(71190400001)(2906002)(186003)(52116002)(14444005)(71200400001)(99286004)(8676002)(81156014)(476003)(5660300002)(6916009)(6486002)(66946007)(25786009)(14454004)(3716004)(66556008)(53936002)(66446008)(66476007)(6246003)(64756008)(305945005)(8936002)(86362001)(6512007)(6436002)(7736002)(386003)(11346002)(446003)(478600001)(81166006)(9686003)(6506007)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1614;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GJySYdqVg8vqiGFKrSHy4XSPXxn+kyPY+mACS4nuitt9P+8z4f8I118RoSZ5h2+/LlKUxhYjGup1FDF1pYN/JWCiZ42TeIbHpWoDd1PSIoMafPBwGzAdu8FepkDFZ35mojJOKnFqsNHZ7IantiK3L3X63kbABCtxVTenuxk6/bgedAd9+bf3I8uS4M5oGQExS1zRrz7bVLT33MF0/0gmrPfZ9KtZEak/AnevkJmv8tsmwIuzfNMcsTdDuLqytDa5Jglitj8Med7R12AkmQq6g4jUGm0wcj3cNuy5L+fAtT0btsJqftbnpwEuQzuUs7d6qKqYxVPahA94YxuI+QXg8z38fg53FQ2x4kTAnwbb23YraKA+x+g4HfZldSNyARmdO8giF6+oaMtF/fSu9IfbG4F9ZOu0MkJWEEI1Eh4L1pc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <458CC37AC679244E889C625DDA7F7886@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0edc136-b37e-483e-b2f3-08d71bcfa98d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 07:11:41.6619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KRoBHhyT+D+RGWrv3fkLyVdcEuQzn+0rOdvv8YcRN7fRxoBCvzfGnHP1nfCMZQZi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1614
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=953 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 05:05:33PM -0700, Stanislav Fomichev wrote:
[ ... ]
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
> > > +		__selem_link_sk(new_sk_storage, copy_selem);
> > > +		raw_spin_unlock_bh(&new_sk_storage->lock);
> >=20
> > Considering in this particular case, new socket is not visible to=20
> > outside world yet (both kernel and user space), map_delete/map_update
> > operations are not applicable in this situation, so
> > the above raw_spin_lock_bh() probably not needed.
> I agree, it's doing nothing, but __selem_link_sk has the following commen=
t:
> /* sk_storage->lock must be held and sk_storage->list cannot be empty */
I believe I may have forgotten to remove this comment after reusing it
in sk_storage_alloc() which also has a similar no-lock-needed situation
like here.

I would also prefer not to acquire the new_sk_storage->lock here to avoid
confusion when investigating racing bugs in the future.

>=20
> Just wanted to keep that invariant for this call site as well (in case
> we add some lockdep enforcement or smth else). WDYT?
>=20
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
> > >   BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *=
, sk,
> > >   	   void *, value, u64, flags)
> > >   {
> > >   	struct bpf_sk_storage_data *sdata;
> > >  =20
> > > -	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
> > > +	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
> > > +		return (unsigned long)NULL;
> > > +
> > > +	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
> > > +	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
> > >   		return (unsigned long)NULL;
> > >  =20
> > >   	sdata =3D sk_storage_lookup(sk, map, true);
> > >   	if (sdata)
> > >   		return (unsigned long)sdata->data;
> > >  =20
> > > -	if (flags =3D=3D BPF_SK_STORAGE_GET_F_CREATE &&
> > > +	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
> > >   	    /* Cannot add new elem to a going away sk.
> > >   	     * Otherwise, the new elem may become a leak
> > >   	     * (and also other memory issues during map
> > > @@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, =
map, struct sock *, sk,
> > >   		/* sk must be a fullsock (guaranteed by verifier),
> > >   		 * so sock_gen_put() is unnecessary.
> > >   		 */
> > > +		if (!IS_ERR(sdata))
> > > +			SELEM(sdata)->clone =3D
> > > +				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
> > >   		sock_put(sk);
> > >   		return IS_ERR(sdata) ?
> > >   			(unsigned long)NULL : (unsigned long)sdata->data;
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index d57b0cc995a0..f5e801a9cea4 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *=
sk, const gfp_t priority)
> > >   			goto out;
> > >   		}
> > >   		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> > > -#ifdef CONFIG_BPF_SYSCALL
> > > -		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > > -#endif
> > > +
> > > +		if (bpf_sk_storage_clone(sk, newsk)) {
> > > +			sk_free_unlock_clone(newsk);
> > > +			newsk =3D NULL;
> > > +			goto out;
> > > +		}
> > >  =20
> > >   		newsk->sk_err	   =3D 0;
> > >   		newsk->sk_err_soft =3D 0;
> > >=20
