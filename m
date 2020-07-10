Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35B021B933
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGJPQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:16:37 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:2882
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727932AbgGJPPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 11:15:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etYPnLb6Pmp1Edu2y1KrMeoTEYkeQalR0xG7zTRo08pwupfW7Gw6k+7rp5kBdIDCKFGqnhFZEzF0LvepWjQfBXDvLGlZplWMZnZpfhzl39WKUwDwi+Uzg1lAPcuitn1kjHm/dsE1SDfJGHVzUD3F2rzwoNOnn7evziWDrQpaZV3D8Gmsa8ZziD9OL5ZolujUQukJU1/Obp4QQLvBMVabfiBU7thSy6RW4rq4l9Ae2QSjJ4oAlB/PzTUAeoy6fUcDPYuohJZzAJ+7b/nthqnFD1G55kX3R9KKHdtWlwtz1psAyEdq5La2AOEN+VIscBGxTRlJoEqYvt88uvWxrbYPFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/JO7xzaXqeEUE93ro0ht7UDhLz9vP6coq0rEsf1u7E=;
 b=CTGXDVBENQ+W7W+vUWHnV7204s96gLsn+IU9wAEKMuNCT9725N3NMUbjlswaTMez3btWa8kDoX4sEuqXFzpR1rZKDk2Skd7oFq5ypfRpoQvu+Y3espZiKfJcw48gsV70qDpba7kfnGvkyXDuYQrg5hqfoVA4P4LnSk+xj74Fybxdri67+aQNjsgw7Bwn1KbqQ+BbqUAJwxhHO30RdVx/TlJZ/xGAYBKYuFEODwRiA+Jw4JPhRgknJFlHE6qpYgizcmy7p8a6UbJp3dHH2KdQZNVFip9i8v55zoUXqrdHeY+JqD51rhdiUL1MPE0b1ddKGNa/d1S+mlxJtMwyQMj+XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/JO7xzaXqeEUE93ro0ht7UDhLz9vP6coq0rEsf1u7E=;
 b=UiCc55CoLNYfk7rPLsZiniZTMFIeyeG4tJ0M9QQM+ttlMDR8B0hzof4UtRnGbkPE7LfK98d0mJjsUQw1RDj0eaABgmUVgKKz2iHxvKQ577hytju4tlWmkW43qqaASAZWvT5fqy+ON/HJ3QSD4juRaDeWPpbY39wc0gScn3bHPqw=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3355.eurprd05.prod.outlook.com (2603:10a6:7:34::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 15:15:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 15:15:42 +0000
References: <20200710135706.601409-1-idosch@idosch.org> <20200710135706.601409-2-idosch@idosch.org> <20200710141500.GA12659@salvia>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
In-reply-to: <20200710141500.GA12659@salvia>
Date:   Fri, 10 Jul 2020 17:15:39 +0200
Message-ID: <87sgdzflk4.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0064.eurprd05.prod.outlook.com
 (2603:10a6:200:68::32) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0501CA0064.eurprd05.prod.outlook.com (2603:10a6:200:68::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 15:15:40 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4ea22ce-c17d-4ee9-2596-08d824e41c40
X-MS-TrafficTypeDiagnostic: HE1PR05MB3355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335541F9CEB5E0BB9E4C85F6DB650@HE1PR05MB3355.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHjj64QDii45SWulyG8+cxVRHPwu9DzWZ/6Dk62EbXV2nK3taXNYpRga4JYnNMSKQTg9ovhyK3A9i7rOjDMLEGhVCCkfQo/lszvNSBMDHJfnxQo4+TMeR1j03k2LAz/B4khgCixFsGritMbjoLb3vpw+m9O8h7hw98MNn0jSH8OpZJNAwPJdFx6s/kjbZustVJwqzU2B64sg612eOdq5f69kdpygBWI+PFmc2Iz7+A/G9bwMc4TYa0Y30aIl9KdK8+KxsGNa0cwKZ+mk+va12HXseAQwJM/U1qpHgNDcEQyVdtRpsMwolIYjf1nqgXQUBP+MYL/38wgZYfdxR3YKqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(6486002)(66476007)(107886003)(6496006)(2616005)(956004)(52116002)(5660300002)(4326008)(26005)(7416002)(6916009)(16526019)(66946007)(36756003)(186003)(66556008)(2906002)(54906003)(83380400001)(86362001)(8936002)(316002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uZnOKgLeHKZuivAEhRP8LMgPFQvd6kxFidJNuJ0VAbt1KwBqOlNAl9ZbRBkzaM6s9Umg/Uq7PPlVl0nmgO0fgppDndOsxPE8G8ZsG1Rzxtw+L+Oz9Zr3/pfG7qouoaQiTP/iJS3EQv+/plajyo1ck17mmxX3o6ZAjmNfPYg4fbSgzfVztZozzPTazYf/DTSW0Lo9+i9LL7bqP12xN3QfVC7/gfcMThxPGWBd78O+/2ADkZQHu5h43Sw2vhSXDLURfwwUQhMez+ZQP6XpByNC7bY7OhGYZw7OSE2RhPxTqMthBakg0WL10EMkbQAnPbdroYxk2yrXTYTWWx6te5MNX5fmpMB3xBE6/9nRLRV0XXcoLu2XHN3EXqQmUIqkT0vBQDtNGP5SJ3QrEv6mGxwaZD0P8yUVt9/yJBxJArxIeUGiqENCmXjK0Ir23Zti5CjvRqMVRiUcZMfe9mSn3HsNZuNhOZ9wyTa4jXP79BTfkoYx+MA2u+WFg8dCgNsWpPf9
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ea22ce-c17d-4ee9-2596-08d824e41c40
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 15:15:41.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlHxXfbwCadS/bVujlKf52/bJn7uUxfvE8oM2rSEKH/AH/O57OofIEoxcOMe9DnPT0JETb2QMkWg4DC3VbGrdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3355
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Fri, Jul 10, 2020 at 04:56:54PM +0300, Ido Schimmel wrote:
>> From: Petr Machata <petrm@mellanox.com>
>>
>> Previously, shared blocks were only relevant for the pseudo-qdiscs ingress
>> and clsact. Recently, a qevent facility was introduced, which allows to
>> bind blocks to well-defined slots of a qdisc instance. RED in particular
>> got two qevents: early_drop and mark. Drivers that wish to offload these
>> blocks will be sent the usual notification, and need to know which qdisc it
>> is related to.
>>
>> To that end, extend flow_block_offload with a "sch" pointer, and initialize
>> as appropriate. This prompts changes in the indirect block facility, which
>> now tracks the scheduler instead of the netdevice. Update signatures of
>> several functions similarly. Deduce the device from the scheduler when
>> necessary.
>>
>> Signed-off-by: Petr Machata <petrm@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> ---
>>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 11 ++++++----
>>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 11 +++++-----
>>  .../net/ethernet/netronome/nfp/flower/main.h  |  2 +-
>>  .../ethernet/netronome/nfp/flower/offload.c   | 11 ++++++----
>>  include/net/flow_offload.h                    |  9 ++++----
>>  net/core/flow_offload.c                       | 12 +++++------
>>  net/netfilter/nf_flow_table_offload.c         | 17 +++++++--------
>>  net/netfilter/nf_tables_offload.c             | 20 ++++++++++--------
>>  net/sched/cls_api.c                           | 21 +++++++++++--------
>>  9 files changed, 63 insertions(+), 51 deletions(-)
>>
> [...]
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> index eefeb1cdc2ee..4fc42c1955ff 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> @@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>>  static LIST_HEAD(mlx5e_block_cb_list);
>>
>>  static int
>> -mlx5e_rep_indr_setup_block(struct net_device *netdev,
>> +mlx5e_rep_indr_setup_block(struct Qdisc *sch,
>>  			   struct mlx5e_rep_priv *rpriv,
>>  			   struct flow_block_offload *f,
>>  			   flow_setup_cb_t *setup_cb,
>> @@ -412,6 +412,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
>>  			   void (*cleanup)(struct flow_block_cb *block_cb))
>>  {
>>  	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
>> +	struct net_device *netdev = sch->dev_queue->dev;
>
> This break indirect block support for netfilter since the driver
> is assuming a Qdisc object.

Sorry, I don't follow. You mean mlx5 driver? What does it mean to
"assume a qdisc object"?

Is it incorrect to rely on the fact that the netdevice can be deduced
from a qdisc, or that there is always a qdisc associated with a block
binding point?
