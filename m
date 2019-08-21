Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD3C9841C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfHUTNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:13:00 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:2469
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729620AbfHUTNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 15:13:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aW8UNsEW2b3OcabPfM8y1MqcwL2gU0T8yvOaXNUPw4mwYInTw8xSPmsWkuO6GU76B9E8WIvYLxwzwgZO9vm6AChI91tC6VyfnIQAW7QkETw0TUzqs9Z7bpl2mjD3Fz4xDQH8crLBCu94vYFEy+7LlX/Y6m9lgatGE+cAKz0WzqQ+lPgBwMaU9gNCiCKbs3mrHNIPgcLiC8zr+wgZmr/rM2g3cL/CKtrnrMQnmGSp1gH5Uv7oIb9g9pguD4cyWHXAOTftIcqbdoZRyPZR/qLqkRSIZd0XGxg61X9+bgpPcKbm8dYZQp7VM0rBqcAZnn7meeNxqNurN9VIOczcyJq9wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh22q43IHxOQKCMzBsC/X2mlngcX6RuStj5SLglhPPk=;
 b=nSIkoJewV1miGKBw3MTwfZuRS1NPHGxdZxu+iIYj+mR143kooaUENkXPIrxqGTX3ttD3E8b+S8Vb47l7rzl8IUM39H2U7j9X4awWBxxbDo098ECDbCxxCqBTctMa/1gqF5ixfIXZsRGlWrTyoUkHl6PDfn7Ois4itek0E5Cj3ZNHcjz3Jg/sKSjUisUA+435UPgDWcOfqoO3lB6vx6kDt1c/6/JPqoYZy/YDtMjMNyScDVRklq3Okq3RVtx2lvZbYX1BKkH88b1hN3eCJeTepQW+dEeAnK02eWKU/bwtTNOd9CCFRcYAcUFyDVNkvnQHyMhsfcGtKFCvkUJDAPw66w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh22q43IHxOQKCMzBsC/X2mlngcX6RuStj5SLglhPPk=;
 b=TyHossh+Xn6AB+Ug1F918nbdwhV+XDtVzLWL7NIOAvSQesTOUAImzQU3s3L9cUrYpUAw7nLmMsjLw7M5gLZQXfLa/vbv+M/qNHN2TEE0pB/q+nuMX25Thj3IU71U20Qh15W7/sK2jsg/A5J6KPOn6COTR7Gz8jlfmUcJfMnqtTk=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5232.eurprd05.prod.outlook.com (20.178.12.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Wed, 21 Aug 2019 19:12:54 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 19:12:54 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 31/38] cls_flower: Use XArray marks instead of separate
 list
Thread-Topic: [PATCH 31/38] cls_flower: Use XArray marks instead of separate
 list
Thread-Index: AQHVV6dPtS5p63NMPUSxSQ7NdNv8sKcF+YoA
Date:   Wed, 21 Aug 2019 19:12:53 +0000
Message-ID: <vbfr25e49jh.fsf@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-32-willy@infradead.org>
In-Reply-To: <20190820223259.22348-32-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0472.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::28) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 927a7ccd-fe4f-4e9d-8dd8-08d7266b915d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5232;
x-ms-traffictypediagnostic: VI1PR05MB5232:
x-microsoft-antispam-prvs: <VI1PR05MB5232096B3F8856493572FEEFADAA0@VI1PR05MB5232.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(199004)(189003)(7736002)(305945005)(99286004)(6116002)(66446008)(86362001)(66946007)(66476007)(66556008)(64756008)(71190400001)(8676002)(6916009)(81156014)(6246003)(11346002)(53936002)(6436002)(8936002)(5660300002)(36756003)(256004)(3846002)(478600001)(25786009)(71200400001)(4326008)(6486002)(6512007)(14444005)(446003)(66066001)(76176011)(52116002)(186003)(14454004)(81166006)(386003)(2616005)(316002)(6506007)(476003)(229853002)(486006)(102836004)(26005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5232;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GYVPdwr3bt1pZhOrag9lC8NJnf6sfLf2S4CwuI5v/YBxdVS1taVF+9/JfvwekHrBd69loNDzk7XGRty7iy/z6pCLPPTp4bWUI0VczClCikhExTY3o86g9XJPdOYo6JUOPXdTsU3WG12VnK+OoshCn8drQ7w1dnfPnrDTH0jpep3//8UYGQmxe0ZMRnERV8hhiPnZB9mIBTUDprVTZl9H9gOivyunl/UzLLpVf4vTsntLE8Jj0ZaxVnEHPfsd+qZJAx1ACuO9jwQO1TouewzNM9VnKRm02xoN1VJW5kmVzTliXvfRP35jXskkEsLQNG6rW/WHGcTUPc9Ws1YheFfjFTy6jYv6F+W8N+TmSgi4UrIUnN5gZbKaqa+PornDQu4tkZFxg6VM4NAv/qCNVXt0pV08P0mkhbSV8nlXdk/0XCQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927a7ccd-fe4f-4e9d-8dd8-08d7266b915d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 19:12:54.0177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nlEo2MTgmal5m+PL2LnhOS1kGRwtWTuERgwwEUkAdMjZi0W9D6gy9oipuaX2LpeUbauAoKk+4mGWVFZeRGK1Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5232
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 21 Aug 2019 at 01:32, Matthew Wilcox <willy@infradead.org> wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Remove the hw_filter list in favour of using one of the XArray mark
> bits which lets us iterate more efficiently than walking a linked list.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/sched/cls_flower.c | 47 ++++++++++--------------------------------
>  1 file changed, 11 insertions(+), 36 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 2a1999d2b507..4625de5e29a7 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -85,11 +85,12 @@ struct fl_flow_tmplt {
>  	struct tcf_chain *chain;
>  };
>
> +#define HW_FILTER	XA_MARK_1
> +
>  struct cls_fl_head {
>  	struct rhashtable ht;
>  	spinlock_t masks_lock; /* Protect masks list */
>  	struct list_head masks;
> -	struct list_head hw_filters;
>  	struct rcu_work rwork;
>  	struct xarray filters;
>  };
> @@ -102,7 +103,6 @@ struct cls_fl_filter {
>  	struct tcf_result res;
>  	struct fl_flow_key key;
>  	struct list_head list;
> -	struct list_head hw_list;
>  	u32 handle;
>  	u32 flags;
>  	u32 in_hw_count;
> @@ -332,7 +332,6 @@ static int fl_init(struct tcf_proto *tp)
>
>  	spin_lock_init(&head->masks_lock);
>  	INIT_LIST_HEAD_RCU(&head->masks);
> -	INIT_LIST_HEAD(&head->hw_filters);
>  	rcu_assign_pointer(tp->root, head);
>  	xa_init_flags(&head->filters, XA_FLAGS_ALLOC1);
>
> @@ -421,7 +420,6 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp=
, struct cls_fl_filter *f,
>
>  	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
>  	spin_lock(&tp->lock);
> -	list_del_init(&f->hw_list);
>  	tcf_block_offload_dec(block, &f->flags);
>  	spin_unlock(&tp->lock);
>
> @@ -433,7 +431,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>  				struct cls_fl_filter *f, bool rtnl_held,
>  				struct netlink_ext_ack *extack)
>  {
> -	struct cls_fl_head *head =3D fl_head_dereference(tp);
>  	struct tcf_block *block =3D tp->chain->block;
>  	struct flow_cls_offload cls_flower =3D {};
>  	bool skip_sw =3D tc_skip_sw(f->flags);
> @@ -485,9 +482,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>  		goto errout;
>  	}
>
> -	spin_lock(&tp->lock);
> -	list_add(&f->hw_list, &head->hw_filters);
> -	spin_unlock(&tp->lock);
>  errout:
>  	if (!rtnl_held)
>  		rtnl_unlock();
> @@ -1581,7 +1575,6 @@ static int fl_change(struct net *net, struct sk_buf=
f *in_skb,
>  		err =3D -ENOBUFS;
>  		goto errout_tb;
>  	}
> -	INIT_LIST_HEAD(&fnew->hw_list);
>  	refcount_set(&fnew->refcnt, 1);
>
>  	err =3D tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
> @@ -1698,6 +1691,11 @@ static int fl_change(struct net *net, struct sk_bu=
ff *in_skb,
>
>  	*arg =3D fnew;
>
> +	if (!tc_skip_hw(fnew->flags))
> +		xa_set_mark(&head->filters, fnew->handle, HW_FILTER);
> +	else if (fold)
> +		xa_clear_mark(&head->filters, fnew->handle, HW_FILTER);
> +

I like how xa mark simplifies reoffload handling, but this wouldn't
work anymore because without rtnl protection fl_change()/fl_delete() can
be called concurrently with fl_reoffload(). My original implementation
of unlocked flower classifier relied on idr in fl_reoffload() and we had
to introduce hw_list due to following race conditions:

- fl_reoffload() can miss fnew if it runs after fnew was provisioned to
  hardware with fl_hw_replace_filter() but before it is marked with
  HW_FILTER.

- Another race condition would be in __fl_delete() when filter is
  removed from xarray, then shared block is detached concurrently which
  causes fl_reoffload() that misses the filter, then the block callback
  is no longer present when fl_hw_destroy_filter() calls
  tc_setup_cb_call() and we have a dangling filter that can't be removed
  from hardware anymore.

That is why filter must be added to hw_list where it is done now - in
fl_hw*() functions while holding rtnl lock to prevent concurrent
reoffload (block bind/unbind always take rtnl). I guess
marking/unmarking filters as HW_FILTER in exactly the same places where
it is inserted/removed from hw_list would also work.

>  	kfree(tb);
>  	tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
>  	return 0;
> @@ -1770,37 +1768,14 @@ static void fl_walk(struct tcf_proto *tp, struct =
tcf_walker *arg,
>  	arg->cookie =3D id;
>  }
>
> -static struct cls_fl_filter *
> -fl_get_next_hw_filter(struct tcf_proto *tp, struct cls_fl_filter *f, boo=
l add)
> -{
> -	struct cls_fl_head *head =3D fl_head_dereference(tp);
> -
> -	spin_lock(&tp->lock);
> -	if (list_empty(&head->hw_filters)) {
> -		spin_unlock(&tp->lock);
> -		return NULL;
> -	}
> -
> -	if (!f)
> -		f =3D list_entry(&head->hw_filters, struct cls_fl_filter,
> -			       hw_list);
> -	list_for_each_entry_continue(f, &head->hw_filters, hw_list) {
> -		if (!(add && f->deleted) && refcount_inc_not_zero(&f->refcnt)) {
> -			spin_unlock(&tp->lock);
> -			return f;
> -		}
> -	}
> -
> -	spin_unlock(&tp->lock);
> -	return NULL;
> -}
> -
>  static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t =
*cb,
>  			void *cb_priv, struct netlink_ext_ack *extack)
>  {
> +	struct cls_fl_head *head =3D fl_head_dereference(tp);
>  	struct tcf_block *block =3D tp->chain->block;
>  	struct flow_cls_offload cls_flower =3D {};
> -	struct cls_fl_filter *f =3D NULL;
> +	struct cls_fl_filter *f;
> +	unsigned long handle;
>  	int err;
>
>  	/* hw_filters list can only be changed by hw offload functions after
> @@ -1809,7 +1784,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool =
add, flow_setup_cb_t *cb,
>  	 */
>  	ASSERT_RTNL();
>
> -	while ((f =3D fl_get_next_hw_filter(tp, f, add))) {
> +	xa_for_each_marked(&head->filters, handle, f, HW_FILTER) {
>  		cls_flower.rule =3D
>  			flow_rule_alloc(tcf_exts_num_actions(&f->exts));
>  		if (!cls_flower.rule) {
