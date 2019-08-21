Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9775982BD
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfHUS1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:27:04 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:25497
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfHUS1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 14:27:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQH0zX0HczGBQNa7ZE1nJUT7nh+xMxUUcQcCF59p1Tphxd41KEm6zzG4ODP3sjqOIGoLpXFuMIf8bTTYmHc8joDCoJSt0lYmgRY5Jyne5qLcx+0syPfCWJzuZRipedKMXzNJ9BOHEwM+YG7M5bX1XCO71M3V4NvG/0rIltkrqCpw8bm5jLcMjXj5/bWQ0hCvNBYtTwWvOEbREDHLVq7/GPpHwSUiZITKlaHfw+MSgFqIFjXPNWVEAwXNhKWPf8ATweVg3N4/mU43OGW8qPzwUuG48oVPxn9ZX040a8ItVUQyi+8bue14jm7STTsZ1nmPgh/52CQfZB6qQ5ZA3kwEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC1KKd9ZZC505U+DW3o01WopfOiORrZLPXC+il0D92k=;
 b=K4WIY/mwxlueKBV45O6itll2Yzj9/+WM12fgxYPsMiA99gU3au0Iq806s+BF8Fd3/7tsdfJm8ts8w/S1F+CAwrAJUn+qHFzr4VpFQT2P3UG4mUknzLC9uJtCmpZVZ2dovDIzKgndn15EBO7kXz4fPteBu4uwXym6QP1O+vas+FqUTv5rqCCZvqJV/+f29ETPQ3YPJmlOaja7EF5YCL3AF+Mx5/YDM4DPWfseTUvkiCDvVo6CLGCL2p8/138kvawgWd1lHE6uLu+4uWNe43TaWbNYJN3Mb5bPBxHdkaVjKc1SG9bnv6iztIsv0qplInkqCyQ4WddTji1ekIfKJuUiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC1KKd9ZZC505U+DW3o01WopfOiORrZLPXC+il0D92k=;
 b=QoLzqzvb89ph6aDpE1DoFwHQleVyH9DiK6KGPlv9vvPLbogAblT5QHktQaD4HOcFDVARCPVaPdNeR5uGW9keNgI1FUI7WPuPVKyZrG+yqSuNg8Dx5KG36q5zO3IFox7J3IHh+GmH/D8MazBQyj84HFQuBB9kUGSW2BuiQnwGhu8=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6144.eurprd05.prod.outlook.com (20.178.205.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 18:27:00 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 18:27:00 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Thread-Topic: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Thread-Index: AQHVV6dBDphG1i4E/Em8IqEgKFP29acF7LiA
Date:   Wed, 21 Aug 2019 18:27:00 +0000
Message-ID: <vbftvaa4bny.fsf@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-30-willy@infradead.org>
In-Reply-To: <20190820223259.22348-30-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::36) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caf37651-d152-42b7-fa04-08d7266527df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6144;
x-ms-traffictypediagnostic: VI1PR05MB6144:
x-microsoft-antispam-prvs: <VI1PR05MB6144C8B30144D45AE6F9F209ADAA0@VI1PR05MB6144.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(189003)(199004)(186003)(5660300002)(8676002)(81156014)(81166006)(36756003)(6246003)(486006)(102836004)(99286004)(478600001)(86362001)(25786009)(66476007)(3846002)(8936002)(64756008)(66556008)(66446008)(71190400001)(6116002)(71200400001)(53936002)(386003)(6506007)(76176011)(110136005)(66946007)(2906002)(316002)(6436002)(11346002)(7736002)(446003)(66066001)(26005)(305945005)(14444005)(4326008)(6486002)(256004)(476003)(52116002)(2616005)(6512007)(229853002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6144;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6zLOVkduL7RZcSK0Z0CKk0uenPPOLvx6hS4EeYtEcJcrIORA7RjeQmfAKKC0xHbPtDmGH6bK7jPhCU9BCpPtNKcXh6ytmEB1b650SyAqX+o+bU4I2ccwOK5AxxsXq1n+/Wsz7dNn7mJnoYdp/NAL97EZosZYGW2jbxyw/9iXi8SMf0EWcws1WaRadP6ZRky0X9/NPTFz/Ab2chQRz07FVmpnQkyGNylGtyBwdmJW9b8G6H7/quQGSOXiJWOyy9FhLsi1vG25F/Zzhkcrr9HtifnX10zaZDCk7Mr0vsotAO4c3+ZbQy6nM4SI9FroklwUp9zOX2JQv52snO7mRhLKoVPHD4yQpywxEN2jTmMT4vhg8XtnSKMAZoVecY8JvMaUzEQthVyOWmT6pES9wYmYWZ2Q9kWxluNPQ5p/dCGcPEc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf37651-d152-42b7-fa04-08d7266527df
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 18:27:00.2204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HWJvL4ZqMb+YddZi1v1nK4MBQiMoIaR8WXmja+WX70q88cyDVnHP8/aoggjb/FvBDPh3ws/C2ZCkYk5spDZB+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 21 Aug 2019 at 01:32, Matthew Wilcox <willy@infradead.org> wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Inline __fl_get() into fl_get().  Use the RCU lock explicitly for
> lookups and walks instead of relying on RTNL.  The xa_lock protects us,
> but remains nested under the RTNL for now.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/sched/cls_flower.c | 54 ++++++++++++++++++++----------------------
>  1 file changed, 26 insertions(+), 28 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 054123742e32..54026c9e9b05 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -91,7 +91,7 @@ struct cls_fl_head {
>  	struct list_head masks;
>  	struct list_head hw_filters;
>  	struct rcu_work rwork;
> -	struct idr handle_idr;
> +	struct xarray filters;
>  };
>
>  struct cls_fl_filter {
> @@ -334,7 +334,7 @@ static int fl_init(struct tcf_proto *tp)
>  	INIT_LIST_HEAD_RCU(&head->masks);
>  	INIT_LIST_HEAD(&head->hw_filters);
>  	rcu_assign_pointer(tp->root, head);
> -	idr_init(&head->handle_idr);
> +	xa_init_flags(&head->filters, XA_FLAGS_ALLOC1);
>
>  	return rhashtable_init(&head->ht, &mask_ht_params);
>  }
> @@ -530,19 +530,6 @@ static void __fl_put(struct cls_fl_filter *f)
>  		__fl_destroy_filter(f);
>  }
>
> -static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 hand=
le)
> -{
> -	struct cls_fl_filter *f;
> -
> -	rcu_read_lock();
> -	f =3D idr_find(&head->handle_idr, handle);
> -	if (f && !refcount_inc_not_zero(&f->refcnt))
> -		f =3D NULL;
> -	rcu_read_unlock();
> -
> -	return f;
> -}
> -
>  static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
>  		       bool *last, bool rtnl_held,
>  		       struct netlink_ext_ack *extack)
> @@ -560,7 +547,7 @@ static int __fl_delete(struct tcf_proto *tp, struct c=
ls_fl_filter *f,
>  	f->deleted =3D true;
>  	rhashtable_remove_fast(&f->mask->ht, &f->ht_node,
>  			       f->mask->filter_ht_params);
> -	idr_remove(&head->handle_idr, f->handle);
> +	xa_erase(&head->filters, f->handle);
>  	list_del_rcu(&f->list);
>  	spin_unlock(&tp->lock);
>
> @@ -599,7 +586,7 @@ static void fl_destroy(struct tcf_proto *tp, bool rtn=
l_held,
>  				break;
>  		}
>  	}
> -	idr_destroy(&head->handle_idr);
> +	xa_destroy(&head->filters);
>
>  	__module_get(THIS_MODULE);
>  	tcf_queue_work(&head->rwork, fl_destroy_sleepable);
> @@ -615,8 +602,15 @@ static void fl_put(struct tcf_proto *tp, void *arg)
>  static void *fl_get(struct tcf_proto *tp, u32 handle)
>  {
>  	struct cls_fl_head *head =3D fl_head_dereference(tp);
> +	struct cls_fl_filter *f;
> +
> +	rcu_read_lock();
> +	f =3D xa_load(&head->filters, handle);
> +	if (f && !refcount_inc_not_zero(&f->refcnt))
> +		f =3D NULL;
> +	rcu_read_unlock();
>
> -	return __fl_get(head, handle);
> +	return f;
>  }
>
>  static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] =3D {
> @@ -1663,7 +1657,7 @@ static int fl_change(struct net *net, struct sk_buf=
f *in_skb,
>  		rhashtable_remove_fast(&fold->mask->ht,
>  				       &fold->ht_node,
>  				       fold->mask->filter_ht_params);
> -		idr_replace(&head->handle_idr, fnew, fnew->handle);
> +		xa_store(&head->filters, fnew->handle, fnew, 0);
>  		list_replace_rcu(&fold->list, &fnew->list);
>  		fold->deleted =3D true;
>
> @@ -1681,8 +1675,9 @@ static int fl_change(struct net *net, struct sk_buf=
f *in_skb,
>  	} else {
>  		if (handle) {
>  			/* user specifies a handle and it doesn't exist */
> -			err =3D idr_alloc_u32(&head->handle_idr, fnew, &handle,
> -					    handle, GFP_ATOMIC);
> +			fnew->handle =3D handle;
> +			err =3D xa_insert(&head->filters, handle, fnew,
> +					GFP_ATOMIC);
>
>  			/* Filter with specified handle was concurrently
>  			 * inserted after initial check in cls_api. This is not
> @@ -1690,18 +1685,16 @@ static int fl_change(struct net *net, struct sk_b=
uff *in_skb,
>  			 * message flags. Returning EAGAIN will cause cls_api to
>  			 * try to update concurrently inserted rule.
>  			 */
> -			if (err =3D=3D -ENOSPC)
> +			if (err =3D=3D -EBUSY)
>  				err =3D -EAGAIN;
>  		} else {
> -			handle =3D 1;
> -			err =3D idr_alloc_u32(&head->handle_idr, fnew, &handle,
> -					    INT_MAX, GFP_ATOMIC);
> +			err =3D xa_alloc(&head->filters, &fnew->handle, fnew,
> +					xa_limit_31b, GFP_ATOMIC);
>  		}
>  		if (err)
>  			goto errout_hw;
>
>  		refcount_inc(&fnew->refcnt);
> -		fnew->handle =3D handle;
>  		list_add_tail_rcu(&fnew->list, &fnew->mask->filters);
>  		spin_unlock(&tp->lock);
>  	}
> @@ -1755,23 +1748,28 @@ static void fl_walk(struct tcf_proto *tp, struct =
tcf_walker *arg,
>  		    bool rtnl_held)
>  {
>  	struct cls_fl_head *head =3D fl_head_dereference(tp);
> -	unsigned long id =3D arg->cookie, tmp;
> +	unsigned long id;
>  	struct cls_fl_filter *f;

Could you sort these by line length if you respin?

>
>  	arg->count =3D arg->skip;
>
> -	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
> +	rcu_read_lock();
> +	xa_for_each_start(&head->filters, id, f, arg->cookie) {
>  		/* don't return filters that are being deleted */
>  		if (!refcount_inc_not_zero(&f->refcnt))
>  			continue;
> +		rcu_read_unlock();
>  		if (arg->fn(tp, f, arg) < 0) {
>  			__fl_put(f);
>  			arg->stop =3D 1;
> +			rcu_read_lock();
>  			break;
>  		}
>  		__fl_put(f);
>  		arg->count++;
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  	arg->cookie =3D id;
>  }

At first I was confused why you bring up rtnl lock in commit message
(flower classifier has 'unlocked' flag set and can't rely on it anymore)
but looking at the code I see that we lost rcu read lock here in commit
d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()") and you
are correctly bringing it back. Adding Cong to advise if it is okay to
wait for this patch to be accepted or we need to proceed with fixing the
missing RCU lock as a standalone patch.
