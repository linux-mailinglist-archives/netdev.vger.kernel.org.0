Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A3ECA3B7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfJCQST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:18:19 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:14657
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730093AbfJCQSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 12:18:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e322r0CHI0JNZaPO6bPP+ZCGFe3kItNBnPNxlfwpoWNYq1KVOs+ItKK5VU86BMZl0JPQ7vZnlm6SNxS6EI0VSs3aeOVKVzwm58tBqFJAetw0oT7LH8FV3m9fXnIMBooz6SIjwO/paZ5YS4yPPSThxp83V0FEITyEhG4/R0EOJ4iCONQvrEcTtbRWSmlfi8iDNE/2T3GrKiZ7ocVGTBw0iWdLM9AP6PwCzvOHHU3VLcWpH5/BDyP52l+LumN8x2jHf/ODivui7mmokdkxw1UfYjiaVK7CuBnDiT2XENGRbCLhz1tw+795OTFpITwPApyF0QGDUiLCYtNZKHXVUXye5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VpLGVzxlstak3VkS6rIpRucugCs3QCg9N2QnWe2Ais=;
 b=Ay05LvO/GVpoh+udRALySF6zIUnDbhlW1oajBQ48UZaGifl6ZMhdJbeMKufFZSjWHmoI8XYTBehcW6yu+51VchBY5D/h+x1mXkg09D80aq60n8MDK90KEnnT36Bhw+SASIKiCMQzhPG14DkJHgRXfUWanv3sGGG0lT9w4Lm4DuAK0O487OPEXBnfB4xLua64cXa/pdzFHSfDyz3y1AmJ+yHwxppP0P/wEpjmzi6rLERwdIllnl0oK2OXOlo2jqzTa36UopKPVUVWeKGweOLYEY7kc5jrQ9ZYq+zu19BwxzBZ8weWR4FdaVdrHI4mFmxLbQgBk5KG6I0BpokUk2GSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VpLGVzxlstak3VkS6rIpRucugCs3QCg9N2QnWe2Ais=;
 b=mrDbrjtJ+SdNeib4CudZKI1RzeCXrYeiWOPQzSvA408/LsD1Xz5wyAO5punIiwVl+rtCnT2sBHtZOpYZnKbRynPE5AjHIQ8ODdEO/LMlGzc0249GXYVCi6WyF2mA/gu1TPEOPIhSNtNgsfZT374STHepsiH1vqWY+wwmNh+O7d8=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3327.eurprd05.prod.outlook.com (10.170.238.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 16:18:12 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:18:12 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next 2/2] net: sched: fix tp destroy race conditions in
 flower
Thread-Topic: [RFC net-next 2/2] net: sched: fix tp destroy race conditions in
 flower
Thread-Index: AQHVeXc6WRozXQ4agkmSVzB4v99+V6dJGUwA
Date:   Thu, 3 Oct 2019 16:18:11 +0000
Message-ID: <vbflfu1olaj.fsf@mellanox.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <1570058072-12004-3-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1570058072-12004-3-git-send-email-john.hurley@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::14) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2823d66-d5ec-4a0d-4d9f-08d7481d4951
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB3327:|VI1PR05MB3327:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB332762CA7933919D9F466D46AD9F0@VI1PR05MB3327.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(189003)(199004)(25786009)(2616005)(76176011)(11346002)(446003)(3846002)(14444005)(476003)(256004)(36756003)(186003)(486006)(2906002)(66066001)(305945005)(52116002)(102836004)(6116002)(71190400001)(71200400001)(5660300002)(7736002)(229853002)(6436002)(26005)(6486002)(386003)(6506007)(66946007)(6512007)(6246003)(99286004)(4326008)(66476007)(66556008)(54906003)(66446008)(6916009)(64756008)(8676002)(316002)(8936002)(81156014)(81166006)(14454004)(86362001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3327;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cgjk50A7OZeEs9Eg+cMkUzYqWEgbaossoHg/n1Fgsv6KV3Vnqf8zRfN4lg0j3piZYONC6hXn7A7q+gHEpNhPEATgN9gn3SdwLeGjKkFP3MZGOF6TbynCHA39mSDXp/0dRdo7gqut024tmN/5EVNaFardr7QC8t9jCItBxlGgbE277Y0Vg3uLGh6ICb9QJShwehmEeEVzm1zWy6LktzmTrWba7MwXvqSstcR05O3495yofrs/lNLra5PJUaXeFNtxVG1TxhSI7avzk1ESj15Q42S7sX4Ho6m5nTKMJAxV2TJ45j/P4NpFttqfXn5wuj9iurFDRhdsiz4mfA17zoxVkWSPIqnHVADbPZGw1AcC72Ih3A/pVbJI64XF5cd3P3U7K1ahRzJ5QU99Mzn5bmnYbs702uKy7wIGj7pUw7jtkas=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2823d66-d5ec-4a0d-4d9f-08d7481d4951
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:18:12.0169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ag96aG5JGypVBSi5XtrtS/nOLM5PR+zoBTgEVm60APt3kT0qlHjID06WFxmr5PUJukDGpXO6Y4gdBSm3Nt8Hkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> Flower has rule HW offload functions available that drivers can choose to
> register for. For the deletion case, these are triggered after filters
> have been removed from lookup tables both at the flower level, and the
> higher cls_api level. With flower running without RTNL locking, this can
> lead to races where HW offload messages get out of order.
>
> Ensure HW offloads stay in line with the kernel tables by triggering
> the sending of messages before the kernel processing is completed. For
> destroyed tcf_protos, do this at the new pre_destroy hook. Similarly, if
> a filter is being added, check that it is not concurrently being deleted
> before offloading to hw, rather than the current approach of offloading,
> then checking and reversing the offload if required.
>
> Fixes: 1d965c4def07 ("Refactor flower classifier to remove dependency on =
rtnl lock")
> Fixes: 272ffaadeb3e ("net: sched: flower: handle concurrent tcf proto del=
etion")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reported-by: Louis Peens <louis.peens@netronome.com>
> ---
>  net/sched/cls_flower.c | 55 +++++++++++++++++++++++++++-----------------=
------
>  1 file changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 74221e3..3ac47b5 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -513,13 +513,16 @@ static struct cls_fl_filter *__fl_get(struct cls_fl=
_head *head, u32 handle)
>  }
> =20
>  static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
> -		       bool *last, bool rtnl_held,
> +		       bool *last, bool rtnl_held, bool do_hw,
>  		       struct netlink_ext_ack *extack)
>  {
>  	struct cls_fl_head *head =3D fl_head_dereference(tp);
> =20
>  	*last =3D false;
> =20
> +	if (do_hw && !tc_skip_hw(f->flags))
> +		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
> +
>  	spin_lock(&tp->lock);
>  	if (f->deleted) {
>  		spin_unlock(&tp->lock);
> @@ -534,8 +537,6 @@ static int __fl_delete(struct tcf_proto *tp, struct c=
ls_fl_filter *f,
>  	spin_unlock(&tp->lock);
> =20
>  	*last =3D fl_mask_put(head, f->mask);
> -	if (!tc_skip_hw(f->flags))
> -		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
>  	tcf_unbind_filter(tp, &f->res);
>  	__fl_put(f);
> =20
> @@ -563,7 +564,7 @@ static void fl_destroy(struct tcf_proto *tp, bool rtn=
l_held,
> =20
>  	list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
>  		list_for_each_entry_safe(f, next, &mask->filters, list) {
> -			__fl_delete(tp, f, &last, rtnl_held, extack);
> +			__fl_delete(tp, f, &last, rtnl_held, false, extack);
>  			if (last)
>  				break;
>  		}
> @@ -574,6 +575,19 @@ static void fl_destroy(struct tcf_proto *tp, bool rt=
nl_held,
>  	tcf_queue_work(&head->rwork, fl_destroy_sleepable);
>  }
> =20
> +static void fl_pre_destroy(struct tcf_proto *tp, bool rtnl_held,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct cls_fl_head *head =3D fl_head_dereference(tp);
> +	struct fl_flow_mask *mask, *next_mask;
> +	struct cls_fl_filter *f, *next;
> +
> +	list_for_each_entry_safe(mask, next_mask, &head->masks, list)
> +		list_for_each_entry_safe(f, next, &mask->filters, list)
> +			if (!tc_skip_hw(f->flags))
> +				fl_hw_destroy_filter(tp, f, rtnl_held, extack);
> +}
> +
>  static void fl_put(struct tcf_proto *tp, void *arg)
>  {
>  	struct cls_fl_filter *f =3D arg;
> @@ -1588,6 +1602,13 @@ static int fl_change(struct net *net, struct sk_bu=
ff *in_skb,
>  	if (err)
>  		goto errout_mask;
> =20
> +	spin_lock(&tp->lock);
> +	if (tp->deleting || (fold && fold->deleted)) {
> +		err =3D -EAGAIN;
> +		goto errout_lock;
> +	}
> +	spin_unlock(&tp->lock);
> +

But what if one of these flag are set after this block? It would be
possible to insert dangling filters on tp that is being deleted, or
double list_replace_rcu() and idr replace() if same filter is replaced
concurrently, etc.

>  	if (!tc_skip_hw(fnew->flags)) {
>  		err =3D fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
>  		if (err)
> @@ -1598,22 +1619,7 @@ static int fl_change(struct net *net, struct sk_bu=
ff *in_skb,
>  		fnew->flags |=3D TCA_CLS_FLAGS_NOT_IN_HW;
> =20
>  	spin_lock(&tp->lock);
> -
> -	/* tp was deleted concurrently. -EAGAIN will cause caller to lookup
> -	 * proto again or create new one, if necessary.
> -	 */
> -	if (tp->deleting) {
> -		err =3D -EAGAIN;
> -		goto errout_hw;
> -	}
> -
>  	if (fold) {
> -		/* Fold filter was deleted concurrently. Retry lookup. */
> -		if (fold->deleted) {
> -			err =3D -EAGAIN;
> -			goto errout_hw;
> -		}
> -
>  		fnew->handle =3D handle;
> =20
>  		if (!in_ht) {
> @@ -1624,7 +1630,7 @@ static int fl_change(struct net *net, struct sk_buf=
f *in_skb,
>  						     &fnew->ht_node,
>  						     params);
>  			if (err)
> -				goto errout_hw;
> +				goto errout_lock;
>  			in_ht =3D true;
>  		}
> =20
> @@ -1667,7 +1673,7 @@ static int fl_change(struct net *net, struct sk_buf=
f *in_skb,
>  					    INT_MAX, GFP_ATOMIC);
>  		}
>  		if (err)
> -			goto errout_hw;
> +			goto errout_lock;
> =20
>  		refcount_inc(&fnew->refcnt);
>  		fnew->handle =3D handle;
> @@ -1683,11 +1689,9 @@ static int fl_change(struct net *net, struct sk_bu=
ff *in_skb,
> =20
>  errout_ht:
>  	spin_lock(&tp->lock);
> -errout_hw:
> +errout_lock:
>  	fnew->deleted =3D true;
>  	spin_unlock(&tp->lock);
> -	if (!tc_skip_hw(fnew->flags))
> -		fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
>  	if (in_ht)
>  		rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
>  				       fnew->mask->filter_ht_params);
> @@ -1713,7 +1717,7 @@ static int fl_delete(struct tcf_proto *tp, void *ar=
g, bool *last,
>  	bool last_on_mask;
>  	int err =3D 0;
> =20
> -	err =3D __fl_delete(tp, f, &last_on_mask, rtnl_held, extack);
> +	err =3D __fl_delete(tp, f, &last_on_mask, rtnl_held, true, extack);
>  	*last =3D list_empty(&head->masks);
>  	__fl_put(f);
> =20
> @@ -2509,6 +2513,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostl=
y =3D {
>  	.kind		=3D "flower",
>  	.classify	=3D fl_classify,
>  	.init		=3D fl_init,
> +	.pre_destroy	=3D fl_pre_destroy,
>  	.destroy	=3D fl_destroy,
>  	.get		=3D fl_get,
>  	.put		=3D fl_put,

