Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6755E1E0D72
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbgEYLi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 07:38:58 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:44185
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388753AbgEYLi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 07:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8GULasSifn7Kg2GyyihMqOQCaAHEhJVabqDBpsbR5txSbQLdV3vLM42LyctGZbWyGPsKqMqGlB6GO++cNwqdm//FmjSzWXxrwL0wETPi56PM+3sANCdmcJi3siZEBj8pRUxemro13v9T4ZJMm5elq6byfS2u7nAhmlRvIy7f5YHMWOelJzFyrPDGumNtS8vtW33ajMjYkldNU1hjlJqp9jZRYSp07ntrj73LKh2cUE3R1mETN1LQXOBy0zhTKo9ou9l5z15Wdyu2mtsCjXmLeEij5dCjHCo1Nge8veLYyJgHEeiGSglnsNS5X4JP2RsAiDDU6Yxp9d+szgt3ER1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GluhF1itj49+ClT9v/JvZar+0rs6N9/KcXfI9Y8Yuro=;
 b=FfOTIxRlcOgoaxGlePkgYAYzeAI5ruafqYorWCPP2eF1xd1QVkMXRZrPTgFXvFHPqJ3612Qz47tQQPxLHS6EPN/h8fMrLfhoprSNl9/T34QZ0drHfMo5HULzgiuykZSeZc5jfDrB8t7ZQJ5a6+oyN1W6SmRa4hlYQ+tHrcVYCmJtAM7MubuRAA5aclBaxGos2ZEzegQpqTtPoClQTmDzsGqA5UrzygBgwx7IHlwbkW7jc/BLnS6PSGixLh3h1p8Z+NMD60birWU8yy9xQo67UiVfjji4e44ByJdmBHIurzXBytSbl+xUoledRbzFA5WVYb0X4/UCKc4TrtNWZZ8A4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GluhF1itj49+ClT9v/JvZar+0rs6N9/KcXfI9Y8Yuro=;
 b=OIM909eYU3egMRnf5PQArX+lM10uZEPZohx+yNCCRVHu+6blQBdahKHjjONpTuYltTefj0d1RuX4ccTIec0lszhhXvRg55ioqYt0no6OvAqSr37Z7QdP4ue7oO26aEQJhdbEpcXrm/TyQX5ntHwYFGrEa2XSoABGUfmKSwpKd90=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7012.eurprd05.prod.outlook.com (2603:10a6:20b:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 11:38:53 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d%8]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 11:38:53 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com> <vbfo8qkb8ip.fsf@mellanox.com> <CAM_iQpXqLdAJOcwyQ=DZs5zi=zEtr97_LT9uhPtTTPke=8Vvdw@mail.gmail.com> <vbfv9krvzkv.fsf@mellanox.com> <CAM_iQpVJ-MT0t1qtvWBp2=twPq6GWsn5-sAW6=QVf4Gc97Mmeg@mail.gmail.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Edward Cree <ecree@solarflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <CAM_iQpVJ-MT0t1qtvWBp2=twPq6GWsn5-sAW6=QVf4Gc97Mmeg@mail.gmail.com>
Date:   Mon, 25 May 2020 14:38:49 +0300
Message-ID: <vbfa71wz1km.fsf@mellanox.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 11:38:51 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcca91d2-4986-4789-d51c-08d800a0336a
X-MS-TrafficTypeDiagnostic: AM7PR05MB7012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB7012BE4053A5CEFB567B1049ADB30@AM7PR05MB7012.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9+otUJ16OhTmZNDzo3J7Dg4cF8b3ZfRGdE6v/9QJiaXr9rYgubbWe5C0xKPjfAA8sY3+WlGPr49jP78UwbUz/hCLQN3FwsBndixKPJmL5kADTlJZoXqVBJ1f8u7+d1ZRZiC+sq3yeOVK/ZD1s03x+pGnvKJdorWAezgs72W4fMRal4MF/TZRArd+Tr2+c8wzJenEU4Hk+fSG+UPVkYh4XxYQ+pxUR/s0927GGRkY01iMJtKsWKxOuO1eS6Gc2I5CZQoJqbI3/5Vu4SItgmsgYljEXa3zcUsN5rbmtic7UCbr6qd/ITydM/0Ohjpl4O/fgvqFaLgC0sy9IT6UvzR4BSH+EfKqlSpqcrQKwIiwiB6AvIANYAMn+1JwmdSdnfE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(36756003)(26005)(86362001)(2906002)(66556008)(66476007)(53546011)(66946007)(66576008)(52116002)(6916009)(4326008)(7696005)(8676002)(186003)(956004)(54906003)(2616005)(16526019)(478600001)(6486002)(316002)(235185007)(5660300002)(8936002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8xqnndzyP+dl5pQmXoc+TJq9j2788Porz3yH/F/HW31e8ZBsGQyD9S8XJYOvjkvsSlPiehajMQF2YmxEK6HGEIxiTBfea9PCsM7WH9VPV3Hf1thUFTz3g613PHlbUF3vfhkXIaJvMJfFs1bncpaITq854Iwm4sbOm0Sq2d/zRfStb8B32TG1+NerK6z0sPuf4IXG2YxBf1PKIKhX3svO2QcnE5wIz3h8AENyp6ZBp9GzqjekKgzLy+ucJSTqWTcHR4esYP8XYXOxIB0Z2bAfTHDs7CFxvauDFuMFT/UKXz1MvWMoGkB9DY5vy5IyN2SU1vRHTnQq0PkzP3xgbk2IhyfqutBs/QJDCiev9rbBZpKQwdidAWk8wWIc6RtLnY4p7HAAxL4e4tIURnByD9Eofp1+JePXeZM9oIDuYdgTV0akfhikh/HRmozDQ6tY8I5+bq/7cdamTQ/goagdBTGpjqnEHL0uhXJhkEPsYTlOJ4Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcca91d2-4986-4789-d51c-08d800a0336a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 11:38:53.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvnIMRdsECzhOTzerZSlrhv3pSurrYLQ/oOExq/nZ30BF7bc1x0GbSCW+mfBE5LOuMWjQL/skdHP6Q1zLzQmuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri 22 May 2020 at 22:33, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, May 20, 2020 at 12:24 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Tue 19 May 2020 at 21:58, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> > On Tue, May 19, 2020 at 2:04 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> >> I considered that approach initially but decided against it for
>> >> following reasons:
>> >>
>> >> - Generic data is covered by current terse dump implementation.
>> >>   Everything else will be act or cls specific which would result long
>> >>   list of flag values like: TCA_DUMP_FLOWER_KEY_ETH_DST,
>> >>   TCA_DUMP_FLOWER_KEY_ETH_DST, TCA_DUMP_FLOWER_KEY_VLAN_ID, ...,
>> >>   TCA_DUMP_TUNNEL_KEY_ENC_KEY_ID, TCA_DUMP_TUNNEL_KEY_ENC_TOS. All of
>> >>   these would require a lot of dedicated logic in act and cls dump
>> >>   callbacks. Also, it would be quite a challenge to test all possible
>> >>   combinations.
>> >
>> > Well, if you consider netlink dump as a database query, what Edward
>> > proposed is merely "select COLUMN1 COLUMN2 from cls_db" rather
>> > than "select * from cls_db".
>> >
>> > No one said it is easy to implement, it is just more elegant than you
>> > select a hardcoded set of columns for the user.
>>
>> As I explained to Edward, having denser netlink packets with more
>> filters per packet is only part of optimization. Another part is not
>> executing some code at all. Consider fl_dump_key() which is 200 lines
>> function with bunch of conditionals like that:
>>
>> static int fl_dump_key(struct sk_buff *skb, struct net *net,
>>                        struct fl_flow_key *key, struct fl_flow_key *mask)
>> {
>>         if (mask->meta.ingress_ifindex) {
>>                 struct net_device *dev;
>>
>>                 dev = __dev_get_by_index(net, key->meta.ingress_ifindex);
>>                 if (dev && nla_put_string(skb, TCA_FLOWER_INDEV, dev->name))
>>                         goto nla_put_failure;
>>         }
>>
>>         if (fl_dump_key_val(skb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
>>                             mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
>>                             sizeof(key->eth.dst)) ||
>>             fl_dump_key_val(skb, key->eth.src, TCA_FLOWER_KEY_ETH_SRC,
>>                             mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
>>                             sizeof(key->eth.src)) ||
>>             fl_dump_key_val(skb, &key->basic.n_proto, TCA_FLOWER_KEY_ETH_TYPE,
>>                             &mask->basic.n_proto, TCA_FLOWER_UNSPEC,
>>                             sizeof(key->basic.n_proto)))
>>                 goto nla_put_failure;
>>
>>         if (fl_dump_key_mpls(skb, &key->mpls, &mask->mpls))
>>                 goto nla_put_failure;
>>
>>         if (fl_dump_key_vlan(skb, TCA_FLOWER_KEY_VLAN_ID,
>>                              TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan, &mask->vlan))
>>                 goto nla_put_failure;
>>     ...
>>
>>
>> Now imagine all of these are extended with additional if (flags &
>> TCA_DUMP_XXX). All gains from not outputting some other minor stuff into
>> netlink packet will be negated by it.
>
> Interesting, are you saying a bit test is as expensive as appending
> an actual netlink attribution to the dumping? I am surprised.

It is not just adding a clause to all those conditionals. Some functions
are not called at all with current terse dump design. In the case of
fl_dump_key() it is just a bunch of conditionals (and maybe price of
cache misses to access struct fl_flow_key in a first place). In case of
tc_action_ops->dump() it is also obtaining a spinlock, some atomic ops,
etc. But I agree, "negated" is too strong of a word, "significantly
impacted" is more correct.

>
>
>>
>>
>> >
>> > Think about it, what if another user wants a less terse dump but still
>> > not a full dump? Would you implement ops->terse_dump2()? Or
>> > what if people still think your terse dump is not as terse as she wants?
>> > ops->mini_dump()? How many ops's we would end having?
>>
>> User can discard whatever he doesn't need in user land code. The goal of
>> this change is performance optimization, not designing a generic
>> kernel-space data filtering mechanism.
>
> You optimize the performance by reducing the dump size, which is
> already effectively a data filtering. This doesn't have to be your goal,
> you are implementing it anyway.
>
>
>>
>> >
>> >
>> >>
>> >> - It is hard to come up with proper validation for such implementation.
>> >>   In case of terse dump I just return an error if classifier doesn't
>> >>   implement the callback (and since current implementation only outputs
>> >>   generic action info, it doesn't even require support from
>> >>   action-specific dump callbacks). But, for example, how do we validate
>> >>   a case where user sets some flower and tunnel_key act dump flags from
>> >>   previous paragraph, but Qdisc contains some other classifier? Or
>> >>   flower classifier points to other types of actions? Or when flower
>> >>   classifier has and tunnel_key actions but also mirred? Should the
>> >
>> > Each action should be able to dump selectively too. If you think it
>> > as a database, it is just a different table with different schemas.
>>
>> How is designing custom SQL-like query language (according to your
>> example at the beginning of the mail) for filter dump is going to
>> improve performance? If there is a way to do it in fast a generic manner
>> with BPF, then I'm very interested to hear the details. But adding
>> hundred more hardcoded conditionals is just not a solution considering
>> main motivations for this change is performance.
>
> I still wonder how a bit test is as expensive as you claim, it does
> not look like you actually measure it. This of course depends on the
> size of the dump, but if you look at other netlink dump in kernel,
> not just tc filters, we already dump a lot of attributes per record.
>
> Thanks.

I agree that I didn't specify which parts of the change constitute what
fraction of the dump rate increase. Lets stage a simple test to verify
the cost of calling just two functions (fl_dump_key() and
tc_act_ops->dump() callback) and instantly discarding their results from
packet (patch attached).

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=terse_dump_test1.diff
Content-Description: Test patch

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8ac7eb0a8309..267ee76d3ddb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -771,6 +771,9 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a)
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cookie *cookie;
+	unsigned char *c;
+	struct nlattr *nest;
+	int err;
 
 	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
 		goto nla_put_failure;
@@ -787,6 +790,16 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a)
 	}
 	rcu_read_unlock();
 
+	c = skb_tail_pointer(skb);
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (nest == NULL)
+		goto nla_put_failure;
+	err = tcf_action_dump_old(skb, a, 0, 0);
+	if (err > 0) {
+		nla_nest_end(skb, nest);
+	}
+	nlmsg_trim(skb, c);
+
 	return 0;
 
 nla_put_failure:
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0c574700da75..1bc6294c5c9b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2771,8 +2771,10 @@ static int fl_dump(struct net *net, struct tcf_proto *tp, void *fh,
 static int fl_terse_dump(struct net *net, struct tcf_proto *tp, void *fh,
 			 struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
 {
+	struct fl_flow_key *key, *mask;
 	struct cls_fl_filter *f = fh;
 	struct nlattr *nest;
+	unsigned char *b;
 	bool skip_hw;
 
 	if (!f)
@@ -2786,8 +2788,15 @@ static int fl_terse_dump(struct net *net, struct tcf_proto *tp, void *fh,
 
 	spin_lock(&tp->lock);
 
+	key = &f->key;
+	mask = &f->mask->key;
 	skip_hw = tc_skip_hw(f->flags);
 
+	b = skb_tail_pointer(skb);
+	if (fl_dump_key(skb, net, key, mask))
+		goto nla_put_failure_locked;
+	nlmsg_trim(skb, b);
+
 	if (f->flags && nla_put_u32(skb, TCA_FLOWER_FLAGS, f->flags))
 		goto nla_put_failure_locked;
 

--=-=-=
Content-Type: text/plain


Result for terse dumping 1m simple rules (flower with L2 key + gact
drop) on current net-next:

$ time sudo tc -s filter show terse dev ens1f0 ingress >/dev/null

real    0m3.445s
user    0m2.087s
sys     0m1.298s

With patch applied:

$ time sudo tc -s filter show terse dev ens1f0_0 ingress >/dev/null

real    0m5.035s
user    0m3.289s
sys     0m1.687s

As we can see this leads to 30% overhead in kernel space execution time.

Now with more complex rules (flower 5tuple + act tunnel key + act
mirred) on current net-next:

$ time sudo tc -s filter show terse dev ens1f0 ingress >/dev/null

real    0m4.052s
user    0m2.065s
sys     0m1.937s

Same rules with patch applied:

$ time sudo tc -s filter show terse dev ens1f0_0 ingress >/dev/null

real    0m6.346s
user    0m3.166s
sys     0m3.108s

With more complex rules performance impact on kernel space execution
time get more severe (60%). Overall, this looks like significant
degradation.

--=-=-=--
