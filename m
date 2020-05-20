Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59A51DABED
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgETHYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:24:25 -0400
Received: from mail-eopbgr00049.outbound.protection.outlook.com ([40.107.0.49]:64599
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgETHYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:24:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1OXjMy7UfTan/KTD3Sb/3qtnr8OdhuPZYC4FDZHOThrWHHa8eDaRx9xsgZ8UJGAsU+nn+iJ+6YwXyYT4EUqvM+p5rzIGeFF0xobPkrm1arb2RPLcLeu5oKt+dA2mNu2PYlzOgQmBaz5Pgw5HCJnhxQtyOAUPwU2puA3/AYQ680OE1YTrdjwZXSLtUGOqjd0G9eVQ0TDJX2R5jqAivqt1IDNM7S7awM8c5cQ5hO3ylSV5O9XT6MZvR30iA9s41aBcUmX6OOacBGfgqCRuQe7ZzJ+G/hum01N7Oug2r2kHWJIe79NmUuT3IQg7pAi5GYGkQnSldotfiqpn174W2hqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVGlsDAUBH+/muDZHDZIb6ExNguNUgiT6MtYOueybKg=;
 b=THvsnGImGY85AHiCxmI0I87nf30B1eLCMU/Zci310xEtBVPsU6cx0vtmeqD9P8Wv68btTkczLq6XK/DU4KYAJj00AFgkAp5D8y7VMEtfTJIkiLaHIi9rlEIvo6peCpyHHXA4HYfMp5siuzsOcgQj2AZBc6aFWhr95mHfyN6y5tkww8wp/sDcVgKEMM0tCRPDEmxDe4by0Mk5eQuXss78uV4iRYhD7RT1MUl44ooHCkfr+g2KGAIQqH16E14YWYordalmIp7W6+0JAd9J69alr+2ADYVNCEQxEnvt0vnHZuKRujLRPyPYRUGfsOtCD+hoqNIrDpovSblvq7q5wNQPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVGlsDAUBH+/muDZHDZIb6ExNguNUgiT6MtYOueybKg=;
 b=eqQBsII/NqUT5+EKE6aLByAlXnlfapsoEaXomGNFxfUgqCYpeSKuYqIvUXdus5VPOIIkQ09xOZZ9iUXhc86r4xozFm4O1rsLHWWvN3ADi/GUh9QSRg1EEEY0hORH9woOEXJIIvpMB0rVYyaNJ1eSZ8Q1fY52QpvFgTUIukiG7AA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7058.eurprd05.prod.outlook.com (2603:10a6:20b:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Wed, 20 May
 2020 07:24:20 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d%8]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 07:24:19 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com> <vbfo8qkb8ip.fsf@mellanox.com> <CAM_iQpXqLdAJOcwyQ=DZs5zi=zEtr97_LT9uhPtTTPke=8Vvdw@mail.gmail.com>
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
In-reply-to: <CAM_iQpXqLdAJOcwyQ=DZs5zi=zEtr97_LT9uhPtTTPke=8Vvdw@mail.gmail.com>
Date:   Wed, 20 May 2020 10:24:16 +0300
Message-ID: <vbfv9krvzkv.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0019.eurprd03.prod.outlook.com
 (2603:10a6:205:2::32) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM4PR0302CA0019.eurprd03.prod.outlook.com (2603:10a6:205:2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 07:24:18 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a4511fc-9c7b-402b-fa6f-08d7fc8ecfb6
X-MS-TrafficTypeDiagnostic: AM7PR05MB7058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB705811FF8B3E4841A98E351EADB60@AM7PR05MB7058.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhX8tin7mbuWUned0wkCI/Lk49LDdU53XyZn5Appz7fCmZxZB04KnTtCU7Bv4gwvVtR8S4J17IKyW0ni5Uv7Fg3/4+Bw/n2GQY0P8zc59hSKSk/RVrHHknpaVmYnyMmzngyyPQoQnzLrD70BS1nEqcnNvZw3r0ellx21CR+7dirwmWXW3CEOcJHhUojo5Wn9dc4gwLGPPALbeiEJf0n4b2g6nrP9pVzz/OnZb2veA/352m9lv3dUG81YF5txRwb1/AT59tei6wGNIollnuSmYuyhK+ABsMhKUefHzTeznx6RgkwbLr72HNJRF9HUYSFpeT76l/kCARjK6PT4IyCTf9pjbDrulBGldSo9pDojj6jozCnUOUMN31zzHrrZtYSVrKA6qBwrSy0YfQ1AT/pc4jevEeHsVu7fhmLFD5n3LKPv9Li6yAHxkJyqddzuKikJL2rG+DxiMWbEn9shveJxUzgHIFvGU90GDar+9zSS91l8jHoIPezmfmtdPgjHamFM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(86362001)(26005)(478600001)(66556008)(956004)(2616005)(316002)(54906003)(53546011)(7696005)(36756003)(6486002)(66946007)(52116002)(66476007)(186003)(5660300002)(8676002)(8936002)(4326008)(6916009)(16526019)(2906002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ahIDogO64Orms2gFENgEovCmpTFuprB1pYIlLIHQPbXTPPYND3rQtpJaIZBD08QaUPGnzyXB0BGU+EXSQO63/qCk9eIkYLB74MjUieL4SzuNW10bTqvhoYrRpu1cwy6yj8ahmBfsCJUwNdd+TXYvZjDgMEzGOChvvA4kc3aCdMj6mPOnqzUjxcTSQkX21KPKhKYtPqy0UQDlXzvsy6a5O4BIjIQ+qgKkwf6yxb0FGDNiC7gQHYqxjyz7BcPFrZ3bTRUzEKTYZrglHAEBsaVVPtjRZE5B5svbOYtmImb21ndcGwrg1BXQrHGgmL026hJlWUli17+AtUGCKhLXJGTS5zVkwYua3qlevOfj82VscAbXXDxKH2BJFEJ/xwYd0DXnDJwKjPni+jXnNTODf+w5UwBFUjN4ZWYhcp/wFBoz28qztxwPcGbeg9RTy432cxHHK7ie+WGF//QdjJM6R7IRyKrJTd19NMA0gMELa/iXgl4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4511fc-9c7b-402b-fa6f-08d7fc8ecfb6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 07:24:19.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfMFcChZL+/WHwamaO+zDjcyWvcHBOgmDKbPzyJ/zhtlZv2qkzdOhJVqR6ZyTe+3eREGqBoX8WxT4Y2L/VdVIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 19 May 2020 at 21:58, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, May 19, 2020 at 2:04 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> I considered that approach initially but decided against it for
>> following reasons:
>>
>> - Generic data is covered by current terse dump implementation.
>>   Everything else will be act or cls specific which would result long
>>   list of flag values like: TCA_DUMP_FLOWER_KEY_ETH_DST,
>>   TCA_DUMP_FLOWER_KEY_ETH_DST, TCA_DUMP_FLOWER_KEY_VLAN_ID, ...,
>>   TCA_DUMP_TUNNEL_KEY_ENC_KEY_ID, TCA_DUMP_TUNNEL_KEY_ENC_TOS. All of
>>   these would require a lot of dedicated logic in act and cls dump
>>   callbacks. Also, it would be quite a challenge to test all possible
>>   combinations.
>
> Well, if you consider netlink dump as a database query, what Edward
> proposed is merely "select COLUMN1 COLUMN2 from cls_db" rather
> than "select * from cls_db".
>
> No one said it is easy to implement, it is just more elegant than you
> select a hardcoded set of columns for the user.

As I explained to Edward, having denser netlink packets with more
filters per packet is only part of optimization. Another part is not
executing some code at all. Consider fl_dump_key() which is 200 lines
function with bunch of conditionals like that:

static int fl_dump_key(struct sk_buff *skb, struct net *net,
		       struct fl_flow_key *key, struct fl_flow_key *mask)
{
	if (mask->meta.ingress_ifindex) {
		struct net_device *dev;

		dev = __dev_get_by_index(net, key->meta.ingress_ifindex);
		if (dev && nla_put_string(skb, TCA_FLOWER_INDEV, dev->name))
			goto nla_put_failure;
	}

	if (fl_dump_key_val(skb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
			    mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
			    sizeof(key->eth.dst)) ||
	    fl_dump_key_val(skb, key->eth.src, TCA_FLOWER_KEY_ETH_SRC,
			    mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
			    sizeof(key->eth.src)) ||
	    fl_dump_key_val(skb, &key->basic.n_proto, TCA_FLOWER_KEY_ETH_TYPE,
			    &mask->basic.n_proto, TCA_FLOWER_UNSPEC,
			    sizeof(key->basic.n_proto)))
		goto nla_put_failure;

	if (fl_dump_key_mpls(skb, &key->mpls, &mask->mpls))
		goto nla_put_failure;

	if (fl_dump_key_vlan(skb, TCA_FLOWER_KEY_VLAN_ID,
			     TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan, &mask->vlan))
		goto nla_put_failure;
    ...


Now imagine all of these are extended with additional if (flags &
TCA_DUMP_XXX). All gains from not outputting some other minor stuff into
netlink packet will be negated by it.


>
> Think about it, what if another user wants a less terse dump but still
> not a full dump? Would you implement ops->terse_dump2()? Or
> what if people still think your terse dump is not as terse as she wants?
> ops->mini_dump()? How many ops's we would end having?

User can discard whatever he doesn't need in user land code. The goal of
this change is performance optimization, not designing a generic
kernel-space data filtering mechanism.

>
>
>>
>> - It is hard to come up with proper validation for such implementation.
>>   In case of terse dump I just return an error if classifier doesn't
>>   implement the callback (and since current implementation only outputs
>>   generic action info, it doesn't even require support from
>>   action-specific dump callbacks). But, for example, how do we validate
>>   a case where user sets some flower and tunnel_key act dump flags from
>>   previous paragraph, but Qdisc contains some other classifier? Or
>>   flower classifier points to other types of actions? Or when flower
>>   classifier has and tunnel_key actions but also mirred? Should the
>
> Each action should be able to dump selectively too. If you think it
> as a database, it is just a different table with different schemas.

How is designing custom SQL-like query language (according to your
example at the beginning of the mail) for filter dump is going to
improve performance? If there is a way to do it in fast a generic manner
with BPF, then I'm very interested to hear the details. But adding
hundred more hardcoded conditionals is just not a solution considering
main motivations for this change is performance.
