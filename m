Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433B8E3B1D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440074AbfJXSjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:39:15 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:8551
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437068AbfJXSjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:39:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMck/5zUYGhGYagx8xqFxVG5+GKqMfYTkkQC1GdapIe75B3d7olJTEtE3I9KFtxtaTMCSpHDdDixCTUcCqtclfwYt9BgUvUKHN+/haZJ4i39jSQRo5exHQz+BRsKM4my8S9+P/gInsu824AMPhf6qvTknyPxMVFNNtdEqU1njjUzrQYkVNC6d/pCaJgqFzNMDHubpmvUiv09eGl+qnHlfbEn6DjeBE4ZEgBxzhyGG7XVhRviGk60pd/d938UTxYDq3nb6b7aKus/8jAYJ8PqjMRNfEuoJ3BFL6a7rhHc7QIkABb1X3zt/vSwQjDwE8twfUwX618XS2p7iVcIE0/Q0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdiWInNCUaexhjMWq8rihYAVlFUSBLoILPEcZvSSwy4=;
 b=IEAn7oIhuzykqjke86qL4vVXK8VEBKOQOWYC2u1PfurBKvYDDLf+emKw8jb5pzp5IXrDmU5GaUSlSEQJn2qvM+gCli1bIqHd6S3qjr/lQOeWqJ5z/HH6ct4cMn6w9oPBlycziLe1N8xbo4NItk40XjQhFn3zdEDf5ouKNrTB2V2b9CC2wjJbmAzHPa76WoumgwjDp9hXxzgHhNKCaKu9yWLPIvl2ldrr+v5lfgCpveviYafNeJL4Vw+FSIkQQmcedyliPkOPGSOsem2AwiUxBIoaFmAvmwx2s1liyfZU2hNrZs55EiDBIKnXWAy+zqyONBN8qAdw8AXvnHANPuFWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdiWInNCUaexhjMWq8rihYAVlFUSBLoILPEcZvSSwy4=;
 b=EGEOAGSht2F4WOv8+g+V4nX+N+EksqYASsxeYv6J1fxyvNzZYnoyJ9Uz7+7/dwfQwrSyMCGv6zeYr6mY0CAzBBA0gkJ1zhwq8dwwKuu2W5BLTGzhq4F1HrPJwbUO4lyqq4n4xEJ6oZ/0Fotb9lSQ6/By63/XbUbrBrY6yyfzGDU=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4205.eurprd05.prod.outlook.com (52.134.122.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 18:39:07 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 18:39:07 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Topic: [RFC net-next 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Index: AQHVilpyuzfssO+/BkekEz17pxErBqdqH+iA
Date:   Thu, 24 Oct 2019 18:39:07 +0000
Message-ID: <vbfr2326la0.fsf@mellanox.com>
References: <1571914887-1364-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1571914887-1364-1-git-send-email-john.hurley@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0302.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::26) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f0d261b-cd72-4343-ea9c-08d758b173ef
x-ms-traffictypediagnostic: VI1PR05MB4205:|VI1PR05MB4205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42056899849B9AA328825FABAD6A0@VI1PR05MB4205.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(199004)(189003)(446003)(11346002)(71190400001)(486006)(476003)(2616005)(8936002)(66066001)(66556008)(66476007)(81156014)(81166006)(8676002)(66946007)(66446008)(64756008)(52116002)(25786009)(229853002)(71200400001)(6116002)(54906003)(36756003)(99286004)(76176011)(6506007)(316002)(102836004)(386003)(6916009)(3846002)(26005)(186003)(86362001)(6486002)(4326008)(14454004)(7736002)(6512007)(6246003)(478600001)(256004)(14444005)(2906002)(305945005)(6436002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4205;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Ui+KbxjcjaFaJJAMXSTgv4Q6adyiQPHwKUxRBsG0g4r+1SKjOTyodLv79SyKM2zl9M5VFtss5rjQaTL03lvFE4q1vx0z2BfUb/KU219KydD2nOmbiFvWIP566MGKqsXuwACmxQnevjIO43ezuXAi77F8SC4Q09xGCVN34OVgN9C0TcgBaOwWoEavr9TF65AThEHTfR7SMKxI73EXmbZz0poIR+jdP0f2cSC1bB56xiyu7CcLWRKIaB5vFBIyivfke4rmjzzcHQiPeFFPIfcd5RGT0gMOp6c8LfcOrYKuIyzm/9hHKv1U2IEk56LVuGNwLf8aC6+x6BYlMhkpe3tgrnUXxh8NlRq9HLjGwMXigrjOLMzuGdxLlurmpSsuhS1iHWdpsixDuCXvUtIwNF3fafwAmq8r+TfeibClCQ0EL4gp/zjPUcG7oZtJcZpBPjM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0d261b-cd72-4343-ea9c-08d758b173ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 18:39:07.6171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MeozVQpQgIWEfADZ4Bk1+atp2etc97fDVm8gVnfc4FOLQ51lZFe+Kw9HL0xgXyuSW+do7J1jQJZ/KErF6Q/j1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 24 Oct 2019 at 14:01, John Hurley <john.hurley@netronome.com> wrote:
> When a new filter is added to cls_api, the function
> tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> determine if the tcf_proto is duplicated in the chain's hashtable. It the=
n
> creates a new entry or continues with an existing one. In cls_flower, thi=
s
> allows the function fl_ht_insert_unque to determine if a filter is a
> duplicate and reject appropriately, meaning that the duplicate will not b=
e
> passed to drivers via the offload hooks. However, when a tcf_proto is
> destroyed it is removed from its chain before a hardware remove hook is
> hit. This can lead to a race whereby the driver has not received the
> remove message but duplicate flows can be accepted. This, in turn, can
> lead to the offload driver receiving incorrect duplicate flows and out of
> order add/delete messages.
>
> Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> hash table per block stores each unique chain/protocol/prio being
> destroyed. This entry is only removed when the full destroy (and hardware
> offload) has completed. If a new flow is being added with the same
> identiers as a tc_proto being detroyed, then the add request is replayed
> until the destroy is complete.
>
> Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurren=
t execution")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Reported-by: Louis Peens <louis.peens@netronome.com>
> ---

Hi John,

Thanks again for doing this!

>  include/net/sch_generic.h |   3 ++
>  net/sched/cls_api.c       | 108 ++++++++++++++++++++++++++++++++++++++++=
++++--
>  2 files changed, 107 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 637548d..363d2de 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -414,6 +414,9 @@ struct tcf_block {
>  		struct list_head filter_chain_list;
>  	} chain0;
>  	struct rcu_head rcu;
> +	struct rhashtable proto_destroy_ht;
> +	struct rhashtable_params proto_destroy_ht_params;
> +	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. *=
/
>  };
>
>  #ifdef CONFIG_PROVE_LOCKING
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 8717c0b..7f7095a 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -47,6 +47,77 @@ static LIST_HEAD(tcf_proto_base);
>  /* Protects list of registered TC modules. It is pure SMP lock. */
>  static DEFINE_RWLOCK(cls_mod_lock);
>
> +struct tcf_destroy_proto {
> +	struct destroy_key {
> +		u32 chain_index;
> +		u32 prio;
> +		__be16 protocol;
> +	} key;
> +	struct rhash_head ht_node;
> +};
> +
> +static const struct rhashtable_params destroy_ht_params =3D {
> +	.key_offset =3D offsetof(struct tcf_destroy_proto, key),
> +	.key_len =3D offsetofend(struct destroy_key, protocol),
> +	.head_offset =3D offsetof(struct tcf_destroy_proto, ht_node),
> +	.automatic_shrinking =3D true,
> +};
> +
> +static void
> +tcf_proto_signal_destroying(struct tcf_chain *chain, struct tcf_proto *t=
p)
> +{
> +	struct tcf_block *block =3D chain->block;
> +	struct tcf_destroy_proto *entry;
> +
> +	entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);

Did you consider putting tcf_proto instance itself into
block->proto_destroy_ht? Might simplify the code since entry is
destroyed together with tcf_proto by tcf_proto_destroy() anyway. If such
approach is possible (I might be missing some obvious corner cases), it
might also be a good idea to use old-good intrusive hash table from
hashtable.h which will allow whole solution not to use dynamic memory
allocation at all.

> +	if (!entry)
> +		return;
> +
> +	entry->key.chain_index =3D chain->index;
> +	entry->key.prio =3D tp->prio;
> +	entry->key.protocol =3D tp->protocol;
> +
> +	mutex_lock(&block->proto_destroy_lock);
> +	/* If key already exists or lookup errors out then free new entry. */
> +	if (rhashtable_lookup_get_insert_fast(&block->proto_destroy_ht,
> +					      &entry->ht_node,
> +					      block->proto_destroy_ht_params))
> +		kfree(entry);
> +	mutex_unlock(&block->proto_destroy_lock);
> +}
> +
> +static struct tcf_destroy_proto *
> +tcf_proto_lookup_destroying(struct tcf_block *block, u32 chain_idx, u32 =
prio,
> +			    __be16 proto)
> +{
> +	struct destroy_key key;
> +
> +	key.chain_index =3D chain_idx;
> +	key.prio =3D prio;
> +	key.protocol =3D proto;
> +
> +	return rhashtable_lookup_fast(&block->proto_destroy_ht, &key,
> +				      block->proto_destroy_ht_params);
> +}
> +
> +static void
> +tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp=
)
> +{
> +	struct tcf_block *block =3D chain->block;
> +	struct tcf_destroy_proto *entry;
> +
> +	mutex_lock(&block->proto_destroy_lock);
> +	entry =3D tcf_proto_lookup_destroying(block, chain->index, tp->prio,
> +					    tp->protocol);
> +	if (entry) {
> +		rhashtable_remove_fast(&block->proto_destroy_ht,
> +				       &entry->ht_node,
> +				       block->proto_destroy_ht_params);
> +		kfree(entry);
> +	}
> +	mutex_unlock(&block->proto_destroy_lock);
> +}
> +
>  /* Find classifier type by string name */
>
>  static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *ki=
nd)
> @@ -234,9 +305,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
>  static void tcf_chain_put(struct tcf_chain *chain);
>
>  static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
> -			      struct netlink_ext_ack *extack)
> +			      bool sig_destroy, struct netlink_ext_ack *extack)
>  {
>  	tp->ops->destroy(tp, rtnl_held, extack);
> +	if (sig_destroy)
> +		tcf_proto_signal_destroyed(tp->chain, tp);
>  	tcf_chain_put(tp->chain);
>  	module_put(tp->ops->owner);
>  	kfree_rcu(tp, rcu);
> @@ -246,7 +319,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bool =
rtnl_held,
>  			  struct netlink_ext_ack *extack)
>  {
>  	if (refcount_dec_and_test(&tp->refcnt))
> -		tcf_proto_destroy(tp, rtnl_held, extack);
> +		tcf_proto_destroy(tp, rtnl_held, true, extack);
>  }
>
>  static int walker_check_empty(struct tcf_proto *tp, void *fh,
> @@ -370,6 +443,8 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
>  static void tcf_block_destroy(struct tcf_block *block)
>  {
>  	mutex_destroy(&block->lock);
> +	rhashtable_destroy(&block->proto_destroy_ht);
> +	mutex_destroy(&block->proto_destroy_lock);
>  	kfree_rcu(block, rcu);
>  }
>
> @@ -545,6 +620,12 @@ static void tcf_chain_flush(struct tcf_chain *chain,=
 bool rtnl_held)
>
>  	mutex_lock(&chain->filter_chain_lock);
>  	tp =3D tcf_chain_dereference(chain->filter_chain, chain);
> +	while (tp) {
> +		tp_next =3D rcu_dereference_protected(tp->next, 1);
> +		tcf_proto_signal_destroying(chain, tp);
> +		tp =3D tp_next;
> +	}
> +	tp =3D tcf_chain_dereference(chain->filter_chain, chain);
>  	RCU_INIT_POINTER(chain->filter_chain, NULL);
>  	tcf_chain0_head_change(chain, NULL);
>  	chain->flushing =3D true;
> @@ -857,6 +938,16 @@ static struct tcf_block *tcf_block_create(struct net=
 *net, struct Qdisc *q,
>  	/* Don't store q pointer for blocks which are shared */
>  	if (!tcf_block_shared(block))
>  		block->q =3D q;
> +
> +	block->proto_destroy_ht_params =3D destroy_ht_params;
> +	if (rhashtable_init(&block->proto_destroy_ht,
> +			    &block->proto_destroy_ht_params)) {
> +		NL_SET_ERR_MSG(extack, "Failed to initialise block proto destroy hasht=
able");
> +		kfree(block);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	mutex_init(&block->proto_destroy_lock);
> +
>  	return block;
>  }
>
> @@ -1621,6 +1712,13 @@ static struct tcf_proto *tcf_chain_tp_insert_uniqu=
e(struct tcf_chain *chain,
>
>  	mutex_lock(&chain->filter_chain_lock);
>
> +	if (tcf_proto_lookup_destroying(chain->block, chain->index, prio,
> +					protocol)) {

Function tcf_proto_lookup_destroying() is called with
block->proto_destroy_lock protection previously in the code. I assume it
is also needed here.

> +		mutex_unlock(&chain->filter_chain_lock);
> +		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
> +		return ERR_PTR(-EAGAIN);
> +	}
> +
>  	tp =3D tcf_chain_tp_find(chain, &chain_info,
>  			       protocol, prio, false);
>  	if (!tp)
> @@ -1628,10 +1726,10 @@ static struct tcf_proto *tcf_chain_tp_insert_uniq=
ue(struct tcf_chain *chain,
>  	mutex_unlock(&chain->filter_chain_lock);
>
>  	if (tp) {
> -		tcf_proto_destroy(tp_new, rtnl_held, NULL);
> +		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
>  		tp_new =3D tp;
>  	} else if (err) {
> -		tcf_proto_destroy(tp_new, rtnl_held, NULL);
> +		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
>  		tp_new =3D ERR_PTR(err);
>  	}
>
> @@ -1669,6 +1767,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_ch=
ain *chain,
>  		return;
>  	}
>
> +	tcf_proto_signal_destroying(chain, tp);
>  	next =3D tcf_chain_dereference(chain_info.next, chain);
>  	if (tp =3D=3D chain->filter_chain)
>  		tcf_chain0_head_change(chain, next);
> @@ -2188,6 +2287,7 @@ static int tc_del_tfilter(struct sk_buff *skb, stru=
ct nlmsghdr *n,
>  		err =3D -EINVAL;
>  		goto errout_locked;
>  	} else if (t->tcm_handle =3D=3D 0) {
> +		tcf_proto_signal_destroying(chain, tp);
>  		tcf_chain_tp_remove(chain, &chain_info, tp);
>  		mutex_unlock(&chain->filter_chain_lock);
