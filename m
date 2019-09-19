Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59443B757D
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbfISIyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:54:08 -0400
Received: from mail-eopbgr50086.outbound.protection.outlook.com ([40.107.5.86]:29319
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfISIyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 04:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2tNIrPQRLoMDfT6BOR7lfe7DRZGhjLGHANgsUCVEP+fqXxhjiVva2XqMOYt/fkK+vI6h0eWyiRlYEaxhUmWMmoeuox+ha/iUmicxIvrQbRcvUda95EGcRctN5RzlgFubHv+BP4pdzX1xx957y4JoRBY7sMcJooqjLkSATE9OLcNHcV2cjxR7h8uAc3FM7Mc0QZ/sEzWt9LBzT/96SFgVpcND/Ah1DCQeYh653GaRxgn+K5e3p6xxP842/7lEXqAfx7R0H+e50Vm0wERUO571KaJC1273hGkxEB6zWIADkdWoPa73ti9YiiQOCzAvqoqEFaxo0lMRVMX5BEaMLvB6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVUd2koVKJ22jY6xQ99RWF5wc7xxp+iyjR7LZS0hx7E=;
 b=Qf7/voofxdN/IG0wYsuwyTw+VIPYh3kTVWiH5MGLmAgUfLBxT7nNGmJ3JP5c2Z1C8o1nwtCM0K2hyMd57mtn2+4LDFlrS97+Wo3ayMwNCz5Zn1Qf9lwhYBHDqQfDvoP/fOeebS23Pb+ezJES25L2GZ7Y/65tf7CpsHrfO75FCvAdtUGJhK6EdhVY/1HmTbCfCmrvUwVklKWV/U1FJm5QF2a/gyKqm+6Hvr9gM4TGYzdOhcQS9qfOovBXLCyB/JU8D8XAk4K59LNi/ucRScgxw41Z+JxpAkmZDczahQBWnYn5yEYZN9UdN18J+wfC83bVeTlg7hpwR8BNtYAg0QDNjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVUd2koVKJ22jY6xQ99RWF5wc7xxp+iyjR7LZS0hx7E=;
 b=HnaYoIaj3LuXdgzdgq/068VwcjOF1KEB9Vco5UC69fjEQe6eDIEXOnLt/4PbHa5ReX862xV/yWppcrsmxhRL7VQbVOeLpsfzmrcnbj7QOdpqC9/9S15ZOnYXclgzpBuHDu+JodPMgdKzsd4bV37kk9qMaznpaG84CLLkufUFmpc=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3232.eurprd05.prod.outlook.com (10.170.238.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Thu, 19 Sep 2019 08:53:24 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 08:53:24 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
Thread-Topic: [PATCH net 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
Thread-Index: AQHVbfM3jYcQh4MqN0qF76LOS/uxqacyCvIAgACohYA=
Date:   Thu, 19 Sep 2019 08:53:23 +0000
Message-ID: <vbfy2ykk6ps.fsf@mellanox.com>
References: <20190918073201.2320-1-vladbu@mellanox.com>
 <CAM_iQpX6RAmf4oXLLJnhYpaXX4g7MUmZ33GZgwrYaiPLBGxmYw@mail.gmail.com>
In-Reply-To: <CAM_iQpX6RAmf4oXLLJnhYpaXX4g7MUmZ33GZgwrYaiPLBGxmYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::35) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.149.254.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4763f28b-c387-46e7-dc06-08d73cded436
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3232;
x-ms-traffictypediagnostic: VI1PR05MB3232:|VI1PR05MB3232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3232CD5E923D033EF05456EDAD890@VI1PR05MB3232.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(189003)(64756008)(66556008)(36756003)(6512007)(54906003)(6246003)(66946007)(25786009)(446003)(8936002)(476003)(256004)(99286004)(86362001)(14444005)(478600001)(5660300002)(316002)(71200400001)(14454004)(71190400001)(66476007)(66066001)(2906002)(11346002)(66446008)(386003)(6506007)(186003)(6916009)(229853002)(6436002)(305945005)(53546011)(7736002)(26005)(2616005)(81156014)(6116002)(102836004)(52116002)(4326008)(486006)(6486002)(81166006)(3846002)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3232;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UD+4AyfY8YpDANVkskfxasIocSlbtN2aCnzTE6YMATItS29WeOMTRlHWvW8VUs+MsYX1KmwNGYQXDI7f6m/zi5fYBMdJkY4w3PFKoVRtr/cc/tqZyrpQQUDzMbIXWULe9EKfjU6nXDlai7STqavMeV+oyTRpLgEKAID6LHpDH8U2ifTVl9u3+bzxzi269BOdVPlGhAC5BsYfnweUE+1ZaWN0B7ZtBdX5LuQJ/sjPVhAwo3qhkW4BKIl/1MoGLbeNhYp6wjkUxHwT9jgfhmOvYtyILJhF/m7FFOAtoc1TX9l4EnVb8pnmIR72i97+5VcXeugOzW4x7Xe5GZyHB3/8oUBv5GaeUR2vSZ4SsQMmpeB2ZDAO4O1z/vs9ziAT/BOdG6P1FuFAs2umMzofAibHv9hp3xL0VB9cN9W+S6EwhBs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4763f28b-c387-46e7-dc06-08d73cded436
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 08:53:23.8754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+q/tQDuURc3MoGcqg2EYUlVk8Q4Ar3EmcQUEBFLuIdfZDPScFugb5KsZKRaCuUxbILYh6fqIj+AOCyyXc5I1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3232
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Sep 2019 at 01:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Sep 18, 2019 at 12:32 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>> TC filter API unlocking introduced several new fine-grained locks. The
>> change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
>> APIs which need to obtain new mutex while holding sch tree spinlock. Thi=
s
>> series fixes affected Qdiscs by ensuring that cls API that became sleepi=
ng
>> is only called outside of sch tree lock critical section.
>
> Sorry I just took a deeper look. It seems harder than just moving it
> out of the critical section.
>
> qdisc_destroy() calls ops->reset() which usually purges queues,
> I don't see how it is safe to move it out of tree spinlock without
> respecting fast path.
>
> What do you think?

Hmm, maybe we can split qdisc destruction in two stage process for
affected qdiscs? Rough sketch:

1. Call qdisc_reset() (or qdisc_purge_queue()) on qdisc that are being
   deleted under sch tree lock protection.

2. Call new qdisc_put_empty() function after releasing the lock. This
   function would implement same functionality as a regular qdisc_put()
   besides resetting the Qdisc and freeing skb in its queues (already
   done by qdisc_reset())

In fact, affected queues already do the same or something similar:

- htb_change_class() calls qdisc_purge_queue() that calls qdisc_reset(),
  which makes reset inside qdisc_destroy() redundant.

- multiq_tune() calls qdisc_tree_flush_backlog() that has the same
  implementation as qdisc_purge_queue() minus actually resetting the
  Qdisc. Can we substitute first function with the second one here?

- sfb_change() - same as multiq_tune().

Do you think that would work?

Also, I'm kind of surprised that it worked before. Even though syzbot
complains about mutex that I added, cls API never honored expectation by
such Qdiscs that tcf_block_put doesn't sleep. From the top of my head
there are several places in the cls code where it has never been the
case: chain head change for ingress/clsact Qdiscs calls
mini_qdisc_pair_swap() which is a sleeping function,
tcf_block_flush_all_chains() eventually calls driver callbacks for any
offloaded filters which may sleep.
