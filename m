Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5DCE4410
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406477AbfJYHId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:08:33 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:22390
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406260AbfJYHId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 03:08:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDVUiCMbBuJS8XUevlE8SjfjkdH+z21cHkWcCcw+2dIesL41B0zmxmO6+e52+LbFABO3ffsW5rG1cOMUU29tmEVVBDR4ZTL8NUE0L6MCDmediW87OqFTjoVJVsiXzkXeI4zpQ2bQx6MPG2CgQn6GBOemzOz86b6Kz8brMw49N8eoSJ2MARDqg7NRjtPCnWK4+vwOOwjRhAL8P+FdMBLBypB3D2RjOBl9i7CnYFn5oDuIGjmFY9DCbm4exCXjulukBT2YNaciqdUtGXYImis4WX+czHXwWaB5gOjUiTLIUIeUmyUjKwQnzCIOlM7xq76Pnau5q2yJ2HjrltjiR+oa/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbM+hfk8lfdEQEt8LbomAakf6uQvBJ4jiU6KKfEVDKU=;
 b=U/kg0aEucN03+E6JJvDms9G2oXCJqjYT76y3zWkGrYMChw2ywhme13O/1fhCdyCsXbHx3C7t8FIT6mpFflpQNw+r5PQx275682N4wvA5rxchbl3LFg1CyX7JPQFxr3pUcUIcuREHevZW80axHk3tEpwEPusBNwUCaFEine0wA1QiFPXe0N9FoeaI+7JIjBP75gch+3AOTc97QSixTdGhCUh2nc8Vpc4Ko4W9+IXjoHIU+jtVfrvyJTzKWwM01YJ3mI2uJguhSt7QqB7T1SHGivavUKKkhuSLf59sDkVc8Az4aaYwGXtTOSLi0+uP4J8UIJ1coGdtG46OgbUwTCjOsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbM+hfk8lfdEQEt8LbomAakf6uQvBJ4jiU6KKfEVDKU=;
 b=pTUk/5jZ3nkZ0/AHhq856fZ71iiY1mokif2Xp+qdT9pW0eHRrVL9ZBpJKQgk3cnzV3TocFLciMU/m/Fg+QCnsWmeZuSAmh6dKcdn/oIi+x13Knv0ZJQxinorcuPso2Dw4cyyfsaGq//HmSk8LmJ6xUHbYax95gNW/S1/tireqOE=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6558.eurprd05.prod.outlook.com (20.179.25.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 25 Oct 2019 07:08:22 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 07:08:22 +0000
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
Thread-Index: AQHVilpyuzfssO+/BkekEz17pxErBqdqH+iAgAA/5wCAAJFsgA==
Date:   Fri, 25 Oct 2019 07:08:22 +0000
Message-ID: <vbfmudp715s.fsf@mellanox.com>
References: <1571914887-1364-1-git-send-email-john.hurley@netronome.com>
 <vbfr2326la0.fsf@mellanox.com>
 <CAK+XE=mvAjBYKpqGnraxk=B5axAgTDoN3mntsne63g351nanug@mail.gmail.com>
In-Reply-To: <CAK+XE=mvAjBYKpqGnraxk=B5axAgTDoN3mntsne63g351nanug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0084.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::24) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62789238-8a56-46d6-fd48-08d7591a1f28
x-ms-traffictypediagnostic: VI1PR05MB6558:|VI1PR05MB6558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6558FFE59A220F6CE3F83801AD650@VI1PR05MB6558.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(189003)(199004)(51914003)(305945005)(6512007)(256004)(54906003)(30864003)(14444005)(6486002)(316002)(6436002)(3846002)(25786009)(6246003)(386003)(4326008)(66066001)(26005)(52116002)(6506007)(71200400001)(5660300002)(71190400001)(6916009)(229853002)(76176011)(478600001)(99286004)(2906002)(14454004)(66946007)(36756003)(6116002)(446003)(53546011)(102836004)(486006)(64756008)(66446008)(8936002)(66556008)(66476007)(186003)(476003)(8676002)(81156014)(81166006)(7736002)(2616005)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6558;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D3LmtqCNtu6fdKdeeVBvXAz65MVWHqjlOpyUz8v/8UAwkCy6sk7NCcVm4GjBVHXS3NwTrWV3GBXsJkonpTvgA/POsjFqswrXwoFQbrqImEvXsakQQgWi/OLCL6TSSh/4/HFiqhTQasAYLZXRxgHAQIR5NTVP0gLaqwKDEKocwMB2hXxBxYzKRf8ytSRDO1TeQtJ1Su8a/RZ5nkMSlLLMbTd88L046KtYOIdibPk5Mw9lQgL8Sf64cwMD+5w20EGOUQECsn7L9AuSXsOh96yvQhjXrcxl4PMHmdD6JOrDmAePl36y4xS91L9gUHHUyr9uYgrkaqDLo30XHy4SFLMus2/AOPLmK3oTtXIaNs6uYh5fUIisedCMdfvLF0XhmQQIuYKIzK3T1ySAiNv/iJ3R7GFNPFTcvPM0wN4fXnqk+cpSUVJn4DzQZAPyUXSSKUu0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62789238-8a56-46d6-fd48-08d7591a1f28
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 07:08:22.4865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+/U2j4/e9GqMMKXAodxSQ/+BVKvEyCSfli5rvP8qUcKT1/XNbd+5TqQH8mB1BQZsGa1QmA6wKJyRCqgQ4gIQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6558
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 25 Oct 2019 at 01:27, John Hurley <john.hurley@netronome.com> wrote:
> On Thu, Oct 24, 2019 at 7:39 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>> On Thu 24 Oct 2019 at 14:01, John Hurley <john.hurley@netronome.com> wro=
te:
>> > When a new filter is added to cls_api, the function
>> > tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
>> > determine if the tcf_proto is duplicated in the chain's hashtable. It =
then
>> > creates a new entry or continues with an existing one. In cls_flower, =
this
>> > allows the function fl_ht_insert_unque to determine if a filter is a
>> > duplicate and reject appropriately, meaning that the duplicate will no=
t be
>> > passed to drivers via the offload hooks. However, when a tcf_proto is
>> > destroyed it is removed from its chain before a hardware remove hook i=
s
>> > hit. This can lead to a race whereby the driver has not received the
>> > remove message but duplicate flows can be accepted. This, in turn, can
>> > lead to the offload driver receiving incorrect duplicate flows and out=
 of
>> > order add/delete messages.
>> >
>> > Prevent duplicates by utilising an approach suggested by Vlad Buslov. =
A
>> > hash table per block stores each unique chain/protocol/prio being
>> > destroyed. This entry is only removed when the full destroy (and hardw=
are
>> > offload) has completed. If a new flow is being added with the same
>> > identiers as a tc_proto being detroyed, then the add request is replay=
ed
>> > until the destroy is complete.
>> >
>> > Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concur=
rent execution")
>> > Signed-off-by: John Hurley <john.hurley@netronome.com>
>> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
>> > Reported-by: Louis Peens <louis.peens@netronome.com>
>> > ---
>>
>> Hi John,
>>
>> Thanks again for doing this!
>>
>> >  include/net/sch_generic.h |   3 ++
>> >  net/sched/cls_api.c       | 108 +++++++++++++++++++++++++++++++++++++=
+++++++--
>> >  2 files changed, 107 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> > index 637548d..363d2de 100644
>> > --- a/include/net/sch_generic.h
>> > +++ b/include/net/sch_generic.h
>> > @@ -414,6 +414,9 @@ struct tcf_block {
>> >               struct list_head filter_chain_list;
>> >       } chain0;
>> >       struct rcu_head rcu;
>> > +     struct rhashtable proto_destroy_ht;
>> > +     struct rhashtable_params proto_destroy_ht_params;
>> > +     struct mutex proto_destroy_lock; /* Lock for proto_destroy hasht=
able. */
>> >  };
>> >
>> >  #ifdef CONFIG_PROVE_LOCKING
>> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> > index 8717c0b..7f7095a 100644
>> > --- a/net/sched/cls_api.c
>> > +++ b/net/sched/cls_api.c
>> > @@ -47,6 +47,77 @@ static LIST_HEAD(tcf_proto_base);
>> >  /* Protects list of registered TC modules. It is pure SMP lock. */
>> >  static DEFINE_RWLOCK(cls_mod_lock);
>> >
>> > +struct tcf_destroy_proto {
>> > +     struct destroy_key {
>> > +             u32 chain_index;
>> > +             u32 prio;
>> > +             __be16 protocol;
>> > +     } key;
>> > +     struct rhash_head ht_node;
>> > +};
>> > +
>> > +static const struct rhashtable_params destroy_ht_params =3D {
>> > +     .key_offset =3D offsetof(struct tcf_destroy_proto, key),
>> > +     .key_len =3D offsetofend(struct destroy_key, protocol),
>> > +     .head_offset =3D offsetof(struct tcf_destroy_proto, ht_node),
>> > +     .automatic_shrinking =3D true,
>> > +};
>> > +
>> > +static void
>> > +tcf_proto_signal_destroying(struct tcf_chain *chain, struct tcf_proto=
 *tp)
>> > +{
>> > +     struct tcf_block *block =3D chain->block;
>> > +     struct tcf_destroy_proto *entry;
>> > +
>> > +     entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);
>>
>> Did you consider putting tcf_proto instance itself into
>> block->proto_destroy_ht? Might simplify the code since entry is
>> destroyed together with tcf_proto by tcf_proto_destroy() anyway. If such
>> approach is possible (I might be missing some obvious corner cases), it
>> might also be a good idea to use old-good intrusive hash table from
>> hashtable.h which will allow whole solution not to use dynamic memory
>> allocation at all.
>>
>
> Hi Vlad, thanks for the comments!
> I don't think we can use the tcf_proto instance unfortunately.
> The purpose of this is to detect the addition of a new tcf_proto when
> one with the same identifiers is currently being destroyed.
> Therefore, the (in process of being destroyed) tcf_proto could be out
> of the chain table (so tcf_chain_tp_find will return NULL) but the
> associated filters may still be in HW as the delete hook has yet to be
> triggered.
> This leads to the race in flower with adding filters to a new
> tcf_proto when other duplicates have not been deleted etc. etc.
> Using the 3 tuple identifier means we can detect these tcf_protos
> irrespective of the chain table's current state.

Yes, but I didn't propose to change hash table key. struct tcf_proto has
access to all the fields of the 3 tuple: tp->chain->index, tp->prio,
tp->protocol.

>
> On the hashtable front, the rhash seems more intuitive to me as we
> really don't know how often or how many of these destroys will occur.
> Is there any other reason you would want to move to hashtable bar
> dynamic memory saves?
> I may be missing something here and need to give it more thought.

No major objections. Removing/creating tcf_proto instance is already
quite heavy, so couple more allocations likely don't impact anything.
Its just that currently tcf_proto_signal_destroying() fails silently, if
it can't allocate entry. I guess this might cause the problem to
reappear in high memory pressure situations and root cause will be
unclear since such case doesn't cause any explicit errors or generate
logs. Don't know how important it is in practice.

>
>> > +     if (!entry)
>> > +             return;
>> > +
>> > +     entry->key.chain_index =3D chain->index;
>> > +     entry->key.prio =3D tp->prio;
>> > +     entry->key.protocol =3D tp->protocol;
>> > +
>> > +     mutex_lock(&block->proto_destroy_lock);
>> > +     /* If key already exists or lookup errors out then free new entr=
y. */
>> > +     if (rhashtable_lookup_get_insert_fast(&block->proto_destroy_ht,
>> > +                                           &entry->ht_node,
>> > +                                           block->proto_destroy_ht_pa=
rams))
>> > +             kfree(entry);
>> > +     mutex_unlock(&block->proto_destroy_lock);
>> > +}
>> > +
>> > +static struct tcf_destroy_proto *
>> > +tcf_proto_lookup_destroying(struct tcf_block *block, u32 chain_idx, u=
32 prio,
>> > +                         __be16 proto)
>> > +{
>> > +     struct destroy_key key;
>> > +
>> > +     key.chain_index =3D chain_idx;
>> > +     key.prio =3D prio;
>> > +     key.protocol =3D proto;
>> > +
>> > +     return rhashtable_lookup_fast(&block->proto_destroy_ht, &key,
>> > +                                   block->proto_destroy_ht_params);
>> > +}
>> > +
>> > +static void
>> > +tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto =
*tp)
>> > +{
>> > +     struct tcf_block *block =3D chain->block;
>> > +     struct tcf_destroy_proto *entry;
>> > +
>> > +     mutex_lock(&block->proto_destroy_lock);
>> > +     entry =3D tcf_proto_lookup_destroying(block, chain->index, tp->p=
rio,
>> > +                                         tp->protocol);
>> > +     if (entry) {
>> > +             rhashtable_remove_fast(&block->proto_destroy_ht,
>> > +                                    &entry->ht_node,
>> > +                                    block->proto_destroy_ht_params);
>> > +             kfree(entry);
>> > +     }
>> > +     mutex_unlock(&block->proto_destroy_lock);
>> > +}
>> > +
>> >  /* Find classifier type by string name */
>> >
>> >  static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char =
*kind)
>> > @@ -234,9 +305,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
>> >  static void tcf_chain_put(struct tcf_chain *chain);
>> >
>> >  static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
>> > -                           struct netlink_ext_ack *extack)
>> > +                           bool sig_destroy, struct netlink_ext_ack *=
extack)
>> >  {
>> >       tp->ops->destroy(tp, rtnl_held, extack);
>> > +     if (sig_destroy)
>> > +             tcf_proto_signal_destroyed(tp->chain, tp);
>> >       tcf_chain_put(tp->chain);
>> >       module_put(tp->ops->owner);
>> >       kfree_rcu(tp, rcu);
>> > @@ -246,7 +319,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bo=
ol rtnl_held,
>> >                         struct netlink_ext_ack *extack)
>> >  {
>> >       if (refcount_dec_and_test(&tp->refcnt))
>> > -             tcf_proto_destroy(tp, rtnl_held, extack);
>> > +             tcf_proto_destroy(tp, rtnl_held, true, extack);
>> >  }
>> >
>> >  static int walker_check_empty(struct tcf_proto *tp, void *fh,
>> > @@ -370,6 +443,8 @@ static bool tcf_chain_detach(struct tcf_chain *cha=
in)
>> >  static void tcf_block_destroy(struct tcf_block *block)
>> >  {
>> >       mutex_destroy(&block->lock);
>> > +     rhashtable_destroy(&block->proto_destroy_ht);
>> > +     mutex_destroy(&block->proto_destroy_lock);
>> >       kfree_rcu(block, rcu);
>> >  }
>> >
>> > @@ -545,6 +620,12 @@ static void tcf_chain_flush(struct tcf_chain *cha=
in, bool rtnl_held)
>> >
>> >       mutex_lock(&chain->filter_chain_lock);
>> >       tp =3D tcf_chain_dereference(chain->filter_chain, chain);
>> > +     while (tp) {
>> > +             tp_next =3D rcu_dereference_protected(tp->next, 1);
>> > +             tcf_proto_signal_destroying(chain, tp);
>> > +             tp =3D tp_next;
>> > +     }
>> > +     tp =3D tcf_chain_dereference(chain->filter_chain, chain);
>> >       RCU_INIT_POINTER(chain->filter_chain, NULL);
>> >       tcf_chain0_head_change(chain, NULL);
>> >       chain->flushing =3D true;
>> > @@ -857,6 +938,16 @@ static struct tcf_block *tcf_block_create(struct =
net *net, struct Qdisc *q,
>> >       /* Don't store q pointer for blocks which are shared */
>> >       if (!tcf_block_shared(block))
>> >               block->q =3D q;
>> > +
>> > +     block->proto_destroy_ht_params =3D destroy_ht_params;
>> > +     if (rhashtable_init(&block->proto_destroy_ht,
>> > +                         &block->proto_destroy_ht_params)) {
>> > +             NL_SET_ERR_MSG(extack, "Failed to initialise block proto=
 destroy hashtable");
>> > +             kfree(block);
>> > +             return ERR_PTR(-ENOMEM);
>> > +     }
>> > +     mutex_init(&block->proto_destroy_lock);
>> > +
>> >       return block;
>> >  }
>> >
>> > @@ -1621,6 +1712,13 @@ static struct tcf_proto *tcf_chain_tp_insert_un=
ique(struct tcf_chain *chain,
>> >
>> >       mutex_lock(&chain->filter_chain_lock);
>> >
>> > +     if (tcf_proto_lookup_destroying(chain->block, chain->index, prio=
,
>> > +                                     protocol)) {
>>
>> Function tcf_proto_lookup_destroying() is called with
>> block->proto_destroy_lock protection previously in the code. I assume it
>> is also needed here.
>>
>
> I think we are ok to avoid taking the lock here so I purposefully left
> this out -  this helps as we are not delaying concurrent adds to
> different chains/tcf_protos in the same block.
> tcf_proto_lookup_destroying() uses rhashtable_lookup_fast() which
> calls rcu_read_lock so should find the entry safely.
> While the function returns the entry, we are not accessing it (which
> would require locking), just checking for non-NULL.

Makes sense, thanks.

>
>> > +             mutex_unlock(&chain->filter_chain_lock);
>> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
>> > +             return ERR_PTR(-EAGAIN);
>> > +     }
>> > +
>> >       tp =3D tcf_chain_tp_find(chain, &chain_info,
>> >                              protocol, prio, false);
>> >       if (!tp)
>> > @@ -1628,10 +1726,10 @@ static struct tcf_proto *tcf_chain_tp_insert_u=
nique(struct tcf_chain *chain,
>> >       mutex_unlock(&chain->filter_chain_lock);
>> >
>> >       if (tp) {
>> > -             tcf_proto_destroy(tp_new, rtnl_held, NULL);
>> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
>> >               tp_new =3D tp;
>> >       } else if (err) {
>> > -             tcf_proto_destroy(tp_new, rtnl_held, NULL);
>> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
>> >               tp_new =3D ERR_PTR(err);
>> >       }
>> >
>> > @@ -1669,6 +1767,7 @@ static void tcf_chain_tp_delete_empty(struct tcf=
_chain *chain,
>> >               return;
>> >       }
>> >
>> > +     tcf_proto_signal_destroying(chain, tp);
>> >       next =3D tcf_chain_dereference(chain_info.next, chain);
>> >       if (tp =3D=3D chain->filter_chain)
>> >               tcf_chain0_head_change(chain, next);
>> > @@ -2188,6 +2287,7 @@ static int tc_del_tfilter(struct sk_buff *skb, s=
truct nlmsghdr *n,
>> >               err =3D -EINVAL;
>> >               goto errout_locked;
>> >       } else if (t->tcm_handle =3D=3D 0) {
>> > +             tcf_proto_signal_destroying(chain, tp);
>> >               tcf_chain_tp_remove(chain, &chain_info, tp);
>> >               mutex_unlock(&chain->filter_chain_lock);
