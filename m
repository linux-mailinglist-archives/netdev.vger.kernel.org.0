Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D021D538
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgGMLqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:46:18 -0400
Received: from mail-eopbgr00049.outbound.protection.outlook.com ([40.107.0.49]:40182
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727890AbgGMLqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 07:46:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsChKgmk7m+IIC+3lkl/o3FY+mkmVlF1+IjTWo9rH0sVSbG85EUTu2h4w+Ldly3mfRe6YzZieKoSQWTwClb3lSt25twVnUYAEaIBOxL4pVUnPvRxRYA4a4BNUgI3W3iuDcMvynNcjFlNPCdjx/fZ5QCQOqspNUr9fQPmvVaGRAFEQ6KJRbUYX9AIWUVAndTvmPmREtmlYwue1vcQjpYvFqXVFISquNml1Uw7v+cg8HByuWiW+n94Z7FgXg4s6ZbLMitK8nL9nzAeJNE+xklpyFz/T6auDqFRI/myCr/q0Geeeet/qUfe2Tgs3DG28thfZiuzi7kXP2Mi1gK+fCZWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW6s9+HQ1YR43nqHa8HUXhZeHTP1SaBUXoK2RzoSxlo=;
 b=jpPUyU5/DjwE9VrESWoFp4ePFEQrDx1H5PLLwYSuHSb9IUMExI05C8KrtMNJeHbGLnSkf2JiHsQOG4NkstENvzuKNgBnyR29Joxk0qjRrTqYTwcRHEqXoqbpMPPO9h0r0qguJNlbS4Mwm9yhN4wiTb49q59e5y5500eINriikhwiZsfutRW7Gw4NSrataV2HMpanNZd41DO7SFiP5J93BY4Gx4oOmMzieuTemNz/sdZI3gdBd+HMUGS5Z5LXs9U8M/ycLyMy2Z2LsZCCaz/EobtDUNNSC2W3NMYA6NStm/k7LOEQl1tJ6K/0taZl1kWjxkxAXYZvs9RcjYZq+/ppew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW6s9+HQ1YR43nqHa8HUXhZeHTP1SaBUXoK2RzoSxlo=;
 b=RcKTLUUOpk1PnIH4Us+u8L3KX6KnIX6mp0koYepGzfai5yxXe9BGRiRjFF13204IDpiw18Q/M51+/30KkimK1ncJp65ODl0WiqN4sycxwV5abN9527TRkB+fHZmZ9rREE4Jx1MDuopy5G4HKmeAPY1Cm9s7hAdFIn3Ia0wjFWa8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4651.eurprd05.prod.outlook.com (2603:10a6:7:a2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Mon, 13 Jul 2020 11:46:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 11:46:12 +0000
References: <cover.1594416408.git.petrm@mellanox.com> <a5a3ccf7bf3a097c6400d64f617ee7ee9fc6156c.1594416408.git.petrm@mellanox.com> <20200711112256.4153f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
In-reply-to: <20200711112256.4153f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 13 Jul 2020 13:46:08 +0200
Message-ID: <87k0z7fxj3.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0015.eurprd03.prod.outlook.com
 (2603:10a6:205:2::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0302CA0015.eurprd03.prod.outlook.com (2603:10a6:205:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Mon, 13 Jul 2020 11:46:10 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2d7c07a-63f9-429c-bf0d-08d827225708
X-MS-TrafficTypeDiagnostic: HE1PR05MB4651:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4651DEFF8764776C20C94580DB600@HE1PR05MB4651.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: erTKiwcBGcYeFUaqeO5rOdhPhxHa0w2+GUUX5OErCYyKjRLZz3CFccMWazM50AYzplFQfeX2nzT+EhwTNRaBlDtXj9WEhvBGTulw1hUki7w7bZ5KW2byPH30sLwjPi3Y4lFPMO6Hx4x/x9EdKhZOpsTR3yOTeqKlGJ6zBwhFCC6fmV4aa0PXBqM5OwqE1Yfcoa4YYTKZnfmuaoUxjo1Rer+rFHTpi0iOMMORB0gxDRbV0NMqGlvr8wX6fP4og3MwyZyR2bcEFG20Iv4xFNdv7pnF5prba+Dn+2/ch/w8y53UJwUIdm9bAuhBKF49WsV7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(54906003)(6486002)(83380400001)(6496006)(52116002)(8936002)(16526019)(956004)(316002)(2616005)(186003)(2906002)(7416002)(6916009)(478600001)(66556008)(66476007)(86362001)(26005)(5660300002)(8676002)(4326008)(107886003)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jHK6Hf3si/OQoUWZffE/BvPK1HLNNLMmUO20DmZDnybywJAvwxqXf7r23nGng0V/3HQJaW8TOKZFFOKU+InvbXGjaVQkekQK8GOFBQlS1UzuoZHuY2AP/0mJy9qFlb9ZORS2JcwC7cDwfrZEBdqEqd3a+zsbSqZZAwVmqbD+l5WnmR0P4p7ZYMSOT3HWCg7ufeBdiKl1WeSKeD5pU7QQAgJV/iDDBqEJoZ1AxS6z0uqD9xg7l1cnKP+FKKUUPDuHWtLsHF7JGFETqaG7lgxYhLkhg0zfuBG0J4P5DQg6yeOxWBsuEAQkLtfyMJ6U1xhE71HpKdW+lJWrNCFfqLWRbRlFxMamfdSEQUCc5NTYjxmv7Q1Rn4D7jVWkue8AcK8ujK9gPwDdX3hZ5azyMEi7t5vEtZUy+085ZRVyzc+D+IOTCJiys8otPbJt6ULqM4qQaatS9Fafl43AIbkawzB6MbPZ9U1hgRM6e/337Y/LCtZR59pETGgAe/KcGSSYpiMO
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d7c07a-63f9-429c-bf0d-08d827225708
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 11:46:12.1823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjOuMxzFKKCSDzj8ufQWD0n71MN5QWvN3WASiMV76p/ChLbdQWI0ROlg6KSq2ZSh0GUdA7F6UIQ3UtA7Ok9/7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4651
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 11 Jul 2020 00:55:03 +0300 Petr Machata wrote:
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>> index 0a9a4467d7c7..e82e5cf64d61 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c

>> @@ -1911,7 +1911,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
>>  		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
>>  						    cb_priv, cb_priv,
>>  						    bnxt_tc_setup_indr_rel, f,
>> -						    netdev, data, bp, cleanup);
>> +						    netdev, sch, data, bp, cleanup);
>
> nit: the number of arguments is getting out of hand here, perhaps it's
>      time to pass a structure in.

I would say that adding a distinctly-typed and distinctly-named argument
does not make the other arguments less clear, or increase the risk of
mixing them up in a way that the compiler would not catch.

Taken from another angle, the argument list is not passed through layers
of other functions, so the structure would be assembled in
bnxt_tc_setup_indr_block() and then unpacked again in
flow_indr_block_cb_alloc(). Nothing is saved in that regard either.

Also, flow_indr_block_cb_alloc() is a simple function. When a structure
needs to be introduced to carry the arguments, it might be more
straightforward to just open-code it.

>>  		if (IS_ERR(block_cb)) {
>>  			list_del(&cb_priv->list);
>>  			kfree(cb_priv);
