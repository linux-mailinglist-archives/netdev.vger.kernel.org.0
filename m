Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADF82D3829
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgLIBOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:14:55 -0500
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:62976
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbgLIBOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 20:14:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQnE1/HNk9TFeJGDiIinv28BEGm0e1VqeN/PsKWmlSHl7212XgmDU7p9G9/+kR6A+MQAk6a5ZcSZPJNMQdhhNPFcCslhiofYgdG5marK4FnlXlok1tZWRNA6ikpT/jyR8KjINCan6K1+sFzmpLUpouhKIvB2PJp5XdZnJz3nBxHEjQErvwgENXdfZ1kvDwrgb/7CznjWccQDS3h87L4iahGUL5Hw6d8IZYDRktdQc7n7v0Lfd/56gjkkxZGm3Ea8pQLup6EDzVAlZrG9ZAo8UtlVytARcBzEEC0ZIYqsiWH5jcHbmai/NKL/ySFJg8tc1EsR9uI/BvrsfpbD8QwSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+5uSerJCXOdRGGkmTn+/BAbuilkh0K77RzcXxb4Bfo=;
 b=EE6AEwMMLO640RJcJzfE2Fd9kv9i1iNYBT+htk7XYC58GFo3uKdQDBf5nr2Iruv/yuDswbI7Q6mCp5wkZOhub41TrK0tm+jmcSFwxDNGoO/+EcXOLTvP/N8b2e4phQ8nJgzromVInwau9Ei6YUz0uJhr+CwprRKoM1t9kfaB/+i//Hc/UtguAyY4hgXAofivGMzo7wRELFM+XYo0bljByluuMhaxjxj8FaKlONMlUKhgzf0Xzz8nKYDadtLRJbkS6NCp+KcLAnzdtBpbhKzVJN+6thX5dbqr4a3WTDnARQAI64jmBaISbptMn1rqDQHjDDWLWqxPRyyK/ickkn1UEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+5uSerJCXOdRGGkmTn+/BAbuilkh0K77RzcXxb4Bfo=;
 b=XXHg2bAP6mtOkyYt14Kd+AlqnySEl3Pg0li1TjzHmd+DOL63MAOjfX2184P5hGBDUzRE9SAQ2r1PEYKLFXZM6Ktpe6d3Q5srN0MtoDD5+PHg9VzmKQ/mNDZlmsodtUCXfmkijsQq15W/CJTX8asQOiuIFu9eazQNEbUEVrUnr4k=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM5PR0401MB2643.eurprd04.prod.outlook.com (2603:10a6:203:34::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Wed, 9 Dec
 2020 01:14:05 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66%3]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 01:14:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Topic: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Index: AQHWzCvp+5zpZdZumUWV00Rtz8jGw6nq0GsAgAMTFACAAAG6gIAAA9SAgAAPxgA=
Date:   Wed, 9 Dec 2020 01:14:05 +0000
Message-ID: <20201209011404.lkglsvtq3k45fxp2@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-6-vladimir.oltean@nxp.com>
 <20201207010040.eriknpcidft3qul6@skbuf>
 <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201209000355.vv4gaj7sgi6kph27@skbuf>
 <20201208161737.0dff3139@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208161737.0dff3139@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b576c70a-4a7f-4115-f90a-08d89bdfb8c6
x-ms-traffictypediagnostic: AM5PR0401MB2643:
x-microsoft-antispam-prvs: <AM5PR0401MB26433593668572A72E3C1270E0CC0@AM5PR0401MB2643.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9fOhNNO0A1+J9oWmhaXY8edO0x/p+8F+xv/f0aHVx8yOCmTWD/EUzvmI0TDuIm2FRdeyPbJcog+ORpG1dV9TxnULquIS6U+2tbaiF5DslVsBY2RIqcCnfU8MdZqRazW4KLtuygZ978ml4jTEvJzcU79yncOIeIOa8+ipi4EBiE23Dh8TOjkw6bdgHfidGLxcHRhbFGUnuMZiGPHq67FcbsOvZ+/7m1ee2u4EJKoGEFwrh3xIS23cMOBKsyeG031Ul4ONjyBGeIWeeai5mtXM2IJ8PrTRplfzaIuWe8GNL9mvtzHF57Vf8sXsFe1zHKROVCy6+RK/gxGKwWalEWT1gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(346002)(376002)(71200400001)(91956017)(5660300002)(8936002)(83380400001)(66446008)(66476007)(8676002)(66556008)(64756008)(4326008)(86362001)(26005)(76116006)(186003)(33716001)(7416002)(6486002)(6506007)(1076003)(9686003)(54906003)(66946007)(6512007)(2906002)(6916009)(44832011)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Jn1k/VFMk0X/2/xG4+89LnKt4PFj4Ouqcz8zTP+O5A6z56sUuYUxdrFgq8Y9?=
 =?us-ascii?Q?X9zMVypRSwgP3jXqg0og4oXqyLSpg8ERHKGZxPae7E3KKsiSxwyu3zij6Q66?=
 =?us-ascii?Q?g5BO+9qZ+ia5V9GB99AZ7g+b2QS+10W+BzogeJu9QSRCR+v+cVJJ3I0XNo48?=
 =?us-ascii?Q?9XtswYXBctp6PRsDRCpXMHhhjnR0ckxTzmNz8swlm1fi+rr9YYqzS1T60yZA?=
 =?us-ascii?Q?eNFTFjHvxxgYHespm/Hl/hTLmrT7Z3L5/e3jNFLE7vpg1O8ylHVBPAa7yVIa?=
 =?us-ascii?Q?DzBKmNKkPpkMl5ZVEHqJ8Pk9ilJXDpevMsWkossCwyKuGOYJqcbLqYjJzgL0?=
 =?us-ascii?Q?FvTvRIX4ozt22iC0K8/LfoC+LulIFlbP0brj87OJTqDiJQCDiyVProy/4G+N?=
 =?us-ascii?Q?K8pNZ0HqbUQfIr4/JA2xOk+8taf++yWLwqVprqukwStc2VIJO66Uy2haSEtd?=
 =?us-ascii?Q?JInU9UuY7oYPLHa22cPxjiHREeohe7wI6EEAac5RSznYWn7EAl+kMfsUXtSK?=
 =?us-ascii?Q?TZZ8X0p5fa1p+1Edo4+N0k9+1UD1edeixmrW3ILePbA0sxtF/fTadXznV9F3?=
 =?us-ascii?Q?oHuvlk0O84CQO83TJT24EE4OSw3voWwgBTmlN0f0ALRz3i9TZhaBsYyIQ8Kj?=
 =?us-ascii?Q?r5o6xwQ+soXN+fhl937ZW4jgwlbzBr6kRicVXyE/YSZiyuCv57zUHnIbSB/j?=
 =?us-ascii?Q?b4i29nPH07EfQCjiZ8Dgq8yuM56UChnVAkx5s2n09MptZ8o+q0n3ZLf7FwxL?=
 =?us-ascii?Q?onRf3CZnwaEaWugYGwCo4LmDEdUUMifL54UFypi1HeA175ePo6KF9vluJxAT?=
 =?us-ascii?Q?GNP9W3inbQP6fkeNdfL6Ico0o0g0smNPbV28y/DMJiQ8GWoEjc8sS8Uq5Jjk?=
 =?us-ascii?Q?iQYdhHimQ7idxxmI403aeJA6c49b/fXc66N8u6GMi88+YxslJEX1gT+tVFJx?=
 =?us-ascii?Q?MPRc6egoPRS59vi5YZrtBF74JyAgQJ+2iDAcBYBZfjaznb++HChniI9IXjZ9?=
 =?us-ascii?Q?kVDQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2C62B266C7B4D4483260916697CA0D2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b576c70a-4a7f-4115-f90a-08d89bdfb8c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 01:14:05.2005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOspJmr8XhRKSTEZ0Fl0PdqCvTc+eDf0mMvjGmrIcRVGgHIeGfRzoyceDQdBOmH6ZI+VBVChEZ9n10acnpdZsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 04:17:37PM -0800, Jakub Kicinski wrote:
> On Wed, 9 Dec 2020 00:03:56 +0000 Vladimir Oltean wrote:
> > On Tue, Dec 08, 2020 at 03:57:44PM -0800, Jakub Kicinski wrote:
> > > On Mon, 7 Dec 2020 01:00:40 +0000 Vladimir Oltean wrote:
> > > > - ensuring through convention that user space always takes
> > > >   net->netdev_lists_lock when calling dev_get_stats, and documentin=
g
> > > >   that, and therefore making it unnecessary to lock in bonding.
> > >
> > > This seems like the better option to me. Makes the locking rules pret=
ty
> > > clear.
> >
> > It is non-obvious to me that top-level callers of dev_get_stats should
> > hold a lock as specific as the one protecting the lists of network
> > interfaces. In the vast majority of implementations of dev_get_stats,
> > that lock would not actually protect anything, which would lead into
> > just one more lock that is used for more than it should be. In my tree =
I
> > had actually already switched over to mutex_lock_nested. Nonetheless, I
> > am still open if you want to make the case that simplicity should preva=
il
> > over specificity.
>
> What are the locking rules you have in mind then? Caller may hold RTNL
> or ifc mutex?

Well, it's clear that calling mutex_lock_nested would only silence lockdep,
there would still be this non-reentrant mutex that will be held from a
potentially recursive code path. So it a non-solution, and even worse
than using plain mutex_lock, because at least that is detectable when it
locks up the system.

net_failover and bonding are the only drivers that are creating this
recursivity requirement in dev_get_stats. Other one-over-many stackable
interfaces, like the bridge, just use dev_get_tstats64. I'm almost
thinking that it would be cleaner to convert these two to dev_get_tstats64
too, that would simplify things enormously. Even team uses something
that is based on software counters, something reminiscent of
dev_get_tstats64, definitely not counters retrieved from the underlying
device. Of course, the disadvantage with doing that is going to be that
virtual interfaces cannot retrieve statistics recursively from their
lower interface. I'm trying to think how much of a real disadvantage
that will be. For offloaded interfaces they will be completely off,
that's for sure. And this is one of the reasons that mandated the DSA
rework to expose MAC-based counters in dev_get_stats in the first place.
But thinking in the larger sense. An offloading interface that supports
IP forwarding, with 50 VLAN uppers. How could the statistics counters of
those VLAN uppers ever be correct. It's not realistic to expect of the
underlying hardware to keep separate statistics for each upper, that the
upper could then go ahead and just query. Sure, in the cases where a
lower can have only one upper at a time (bridge, bonding) what I said is
not applicable, but the general goal of having accurate counters for
offloading interfaces everywhere seems to not be really achievable.

In case this doesn't work out, I guess I'll have to document that
dev_get_stats is recursive, and all mutual exclusion based locks need to
be taken upfront, which is the only strategy that works with recursion
that I know of.

> > But in that case, maybe we should just keep on using the RTNL mutex.
>
> That's a wasted opportunity, RTNL lock is pretty busy.

It is certainly easy to use and easy to enforce though. It also seems to
protect everything, which is generally the reason why you tend to not
think a lot when using it.

To be clear, I am not removing the RTNL mutex from any place where it is
held today. Letting me do that would be like letting a bull in a china
shop. I am only creating a sub-lock of it, which is protecting a subset
of what the RTNL mutex is protecting. By sub-lock I mean that code paths
that currently hold the RTNL mutex, like list_netdevice(), will also
take net->netdev_lists_lock - never the other way around, that would
create lock inversion. The plan is to then require new code that
iterates through network interface lists to use the new locking scheme
and not RTNL mutex, and in parallel to migrate, on a best-effort basis,
code that runs under ASSERT_RTNL + net->netdev_lists_lock to only take
the net->netdev_lists_lock and be RTNL-free.

But is that any better at runtime than just taking the RTNL mutex, will
it make it less contended? Nope, due to the indirect serialization
effect that is created by the fact that net->netdev_lists_lock is a
sub-lock of the RTNL mutex. Say net/core/net-procfs.c holds
net->netdev_lists_lock while dumping the statistics from a firmware and
sleeping while doing so. All is rosy in its RTNL mutex free code path.
Then there comes along another thread which calls for_each_netdev,
something else which today requires the RTNL mutex but could be reworked
to use the net->netdev_lists_lock. Let's assume we are at a stage where
the gazillion places that call for_each_netdev() have been converted to
also take the net->netdev_lists_lock. But they couldn't be converted to
also _not_ take the RTNL mutex, or at least all of them. This means that
there will be code paths that try to take the RTNL mutex and end up
waiting for our net/core/net-procfs.c to complete dumping the firmware.=
