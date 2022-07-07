Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4785696DA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiGGAWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGGAWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:22:11 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B242DA96
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:22:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+vmf3EHxQQfiS+SAB7UO6s61WKA+EYAZsUEiBF+TyIbnt5iUW+XLABW+hAUvsLYHEKKl5jCKBJUO3+0YYH1MrRuPHvpmPdQ+rMNjqNbrbyP8z4RVCEQqLA0h0p2irlgcEfBJ9m/e03WbgnuPhYune4DUGU/D/l63XOEzmFA/U0XUKuWW5uG1Kvm26nthZo1tdioGpawM9ZsnMf+eOqeoBqzoB85n3Zr/zN8y1ysTN0+B6T0GjLkeq4NKa6E3qaZpv319XvS7SJ7Dcxwf0yilOIneu0LAMB1f/BuFGy8bMEOZ402At2UWjgUflcqDeYY+tk/UoSxMpmNQkpInGb5Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnjoPrf/p9h/jrknQL3xKH0yfjMFYooN58WHz89VD0k=;
 b=CuOcAvGJW+1q4zZgBJoTvvXhDNQ/8HzCV/5oIdx/5CcK65jiOL71RtchruqbjagJxLY8wo2tNA2Roj5qLz8gyAD4S/y5H5nGNt7xRNniDEefqzqT56PA5PTL5442p0ZXrXtc6NF06VJPk5ai1VhBMDuKXDEBRWf9VSBXNKpPxnqSjb2xahEEkOzYaHUH2kCD8LVfa7an+zcZE9chSbzP84nv8nOvivAI82Us+ZwnY70DtUfrJewoZ47vt/XkQW97pMDSj1dLkZkFqI0LEm7D/KJ+fg/JCW/O0Fm6+Ax0jyyNNlfvtn6MmI+LBxJSRKbFEEhyw1NwExLskYqzufaN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnjoPrf/p9h/jrknQL3xKH0yfjMFYooN58WHz89VD0k=;
 b=T0fUviQb+34okAlifwvEX+u6kvrzBgVPin4iXXe7Au5uLPoBPkRoW0g0C2/Iap2QDMiXw3eNH0BC/sR58ZSEODVn6sHzl4OWhzfsHKnVOSZBbNWLAbyIs+5SXFXfR1XTxpOrm5Z9d8AQoXPenLlMPG+HhttaIDpT+0tsTqQgkUA=
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by PA4PR05MB9067.eurprd05.prod.outlook.com (2603:10a6:102:2aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Thu, 7 Jul
 2022 00:22:06 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 00:22:06 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com" 
        <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
Subject: RE: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Thread-Topic: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Thread-Index: AQHYkOsyB50XojkGrUyN5uJd+Qbw6a1xzXwAgAA+B7A=
Date:   Thu, 7 Jul 2022 00:22:06 +0000
Message-ID: <DB9PR05MB7641A853BC76A3DBBF2187BFF1839@DB9PR05MB7641.eurprd05.prod.outlook.com>
References: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
 <20220706133334.0a6acab5@kernel.org>
In-Reply-To: <20220706133334.0a6acab5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5d378a5-de84-496d-ff5a-08da5faeb928
x-ms-traffictypediagnostic: PA4PR05MB9067:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fogKr+yXfXk72Wt+7QrV4uZKpj8PljfyvWjral49D/PqWYJUl3Cgd6Mc+4fPK8o53wyo0LYyLFMKeE6GCBlwSxdtpMbOH786zu6RdwqFywR241gq64L2/VcyuW84hku6S89zvdEdoxJ3TKXle232ZIukS8GKpbTvAeI/Bcdc3GwjrTGK1hVVS+O84g26CSURxuHSt6wMrEs/qt+rYP3o4KVMB/nAv6GK3rbxcqzcJQWMn209snwaCkcOGzsvssY/RWoH0N76SeLPqgWOTY9OIk7P75yiYsS2HOtBi62fT3qTWrNQuj70TQeilZC1I7ainLlDqYnOmnmc48OdL1o+fg6aXbA4aUnOub4YUArDQ8VHrgl9pg/Z/MahnoUNg/nJUcaf9lmyzXXm83T5afMBvjvBq5KNQ9o5HGwMXblrGEQrWN1z/tWyUg98geNuIvEc0z+uto89JTyGXqpSVfj/QQ20j5YE0nM8D2eudiPwGCXN8Bp5vHtxjcuLqVXWe8kynGmhBurUblLvs+qO3c0sOOku8cMRDaMPo6KmJj4w4lu+WZREZFUVKjNhMNjEoQ4GrHgzvZpMS9qNkFgU2yemQQDDMHosZj4Ciso3Hv5QLggdCCy0S8IB2EAc/s1IJ4XenoDOVcnbC6AuFEFHDiXsYQSjKzXLSzOl3wGR3MIbH6igLIS2IvylcO4ym+9QUYRAMKgWlzKwb3x/0jlR45NwrovHs6qhsoibVBs0H3Uyz2/iev6j7RvQmBVFZzjRKdijkf0QBo77abeI235Cq+ln0c+Huvp/sOhvaTWVFdN+KNx/6LoMOTzwG7XeY84Iz2cc0YKMu92+y/tOB2No3PQz0R3P+367D/opp5Ej3HiN21g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(396003)(366004)(376002)(8936002)(64756008)(54906003)(52536014)(4326008)(8676002)(186003)(5660300002)(66556008)(6916009)(2906002)(66446008)(66946007)(33656002)(316002)(7416002)(66476007)(55016003)(76116006)(122000001)(38100700002)(86362001)(966005)(7696005)(53546011)(478600001)(83380400001)(55236004)(6506007)(41300700001)(9686003)(26005)(38070700005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3gvuLDVcauDjj6/EJt+W9glW6coKzU/sPy3e9t3WHCHIRTB1xAuN4LwnubY/?=
 =?us-ascii?Q?fegwj00xId6reZbcl/cevKSgUIeNOlwavWSNCRf96iAVx21JiwmEj1MMoIiB?=
 =?us-ascii?Q?CB3QnY2KIXvy2Zmp2M9pC2VOQiaUuHlGdzE+5S0/tU5B8f1E2mF6hY9cpMNf?=
 =?us-ascii?Q?ddAxSVQfJBmKwcq1xjVipCKYix5g054HlT0TCeEMO3KurWjOgd+TYOUmoJwc?=
 =?us-ascii?Q?oUa8GNsaQCbC6bSBVmKGP45HZYgpV67HYB+ks67dUhkl9BR/z76AbiTtko38?=
 =?us-ascii?Q?Tq9CsnaM/2ZpXQwspWq8EnPW3GhkpinUMD8V7F+Gtit7oAzLifsF89a791A5?=
 =?us-ascii?Q?6dd5v2JMxknfrgm2keizaqdYqL1D9HDX1i4gsYP5zqhgOi0IiWprgxvJqHC0?=
 =?us-ascii?Q?4Wn7DQN1nq/POq9RmxDKE3NFFOEGLaoMCmXJhyEW9j6Kw4/a8CKP1jNwCQN0?=
 =?us-ascii?Q?he+W3YUnZ8N4ZDoyTVhiAtlX/dfuJ6xBmLlHarVEt+sXUnXCrgnsqblmv7+n?=
 =?us-ascii?Q?yCG2IZ3oFXkv9v2ccFv0jpLWDqwfBioBEiU5EoNFJmPppf27o/8A5VaZLLr4?=
 =?us-ascii?Q?+6/1d6d3FRf7KK9ZsUoodj5JJhQVDb6QLKLdLNzEtxYy9UBZxQV6jmeZNlRL?=
 =?us-ascii?Q?v0a/y5Z9lHXLnZ1LK2ssmxRRJECTJodwuNFhbdaa5yVohdMH8AoKEoWx+ppt?=
 =?us-ascii?Q?wNW8cJpx/V4i4nJhbxULGsZD1jugWMCfoLKEXPKbDO9e9li/XqiaXZKi2kqR?=
 =?us-ascii?Q?xm0XDJsprqZlPYqTHoGV3clc+a1Z/Nf5bSb5guOG7w0/NE+xSZwic5VoEu6P?=
 =?us-ascii?Q?19B5c9bhzCIb8qoF0GISZ4TbZqcQIKGQ2xZUrxaP3bXdna3JUXF45HP0M7RO?=
 =?us-ascii?Q?ZHZDH/Vryee/Uqs0MQkmfNtwvbzWfLVUbG6TSo2fR3Plrti5G/Qc5S9ZJN1s?=
 =?us-ascii?Q?OCS8BrwN6fkviMFdk2Mm3LSEYmmzK48uRrpH+9h8TR008GUuNpT+yO9qK7iw?=
 =?us-ascii?Q?y8HiJMF6U4GPKWBbIPYOgdBPnnB44rbE8HKm4Z47gCxgyOB35mHjlEGMZOdV?=
 =?us-ascii?Q?apCB2I/6dmt6D6xR4hqq/mKwRuaEC3/UG/rTRy8vmfr5PJ5pQTVgFzrXYnEs?=
 =?us-ascii?Q?/h6t/EU4XEbJID+DeOej3Obcq3/drLeoVPoSM40PEd7euiWq2jwRP54q9fyL?=
 =?us-ascii?Q?srJ60ylw1yjDFaHMwPVvFcThBjyQ051m+8E8NoFl6Z5Ru3Tajt5DF1aEio5c?=
 =?us-ascii?Q?7lMa3IWvqk0EP97EYwsanYQbQlP4VoR/FyiS6kMFKP1MQyKHkuegZog9Rbe9?=
 =?us-ascii?Q?GycQxMuTaYOLA0UYLL8+8au2CzyMcFc1treCUO+//9Ux4pMwrzjdYq9qyIRX?=
 =?us-ascii?Q?AipRBB/TbmDaTH4n5zTI8U7O56p6z6seODMg6JyvTtjo4RsFPUw9t9+Z6ClN?=
 =?us-ascii?Q?iRtvqB6K/SRNFmgRnzDE6Fc8vAJ8RbXUiPM5I5eCLbMSPrs+uODzEXyjM0S8?=
 =?us-ascii?Q?Huhp6BMUTatyzYOtDb7TJwIlg9CpPiejEBIFA/PQi64c9HgpI7HIVbZRIJ/k?=
 =?us-ascii?Q?jNW2Zbp238dXy6VLr9EGSvwvve1orOi83GiXvQgbC6v1wUt2g6eLy/XmcfV4?=
 =?us-ascii?Q?yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d378a5-de84-496d-ff5a-08da5faeb928
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 00:22:06.1454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IRrRaATHiTyV0ouasZbh1EE2pm1za5/QF8EOZcnITuSLDTB+2B0zL0QeF2CXAYqiM2B/wLdzJzO6ScjdCTuKfc+eEXOS+k+qGotABA33PSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR05MB9067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 7, 2022 3:34 AM
> To: Hoang Huu Le <hoang.h.le@dektech.com.au>
> Cc: jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; Tung Qu=
ang Nguyen <tung.q.nguyen@dektech.com.au>;
> pabeni@redhat.com; edumazet@google.com; tipc-discussion@lists.sourceforge=
.net; netdev@vger.kernel.org;
> davem@davemloft.net; syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.co=
m
> Subject: Re: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stat=
s
>=20
> On Wed,  6 Jul 2022 10:47:52 +0700 Hoang Le wrote:
> > diff --git a/net/tipc/node.c b/net/tipc/node.c
> > index b48d97cbbe29..80885780caa2 100644
> > --- a/net/tipc/node.c
> > +++ b/net/tipc/node.c
> > @@ -2574,8 +2574,10 @@ int tipc_nl_node_reset_link_stats(struct sk_buff=
 *skb, struct genl_info *info)
> >  	if (!attrs[TIPC_NLA_LINK_NAME])
> >  		return -EINVAL;
> >
> > -	link_name =3D nla_data(attrs[TIPC_NLA_LINK_NAME]);
> > +	if (nla_len(attrs[TIPC_NLA_LINK_NAME]) <=3D 0)
> > +		return -EINVAL;
> >
> > +	link_name =3D nla_data(attrs[TIPC_NLA_LINK_NAME]);
> >  	err =3D -EINVAL;
> >  	if (!strcmp(link_name, tipc_bclink_name)) {
> >  		err =3D tipc_bclink_reset_stats(net, tipc_bc_sndlink(net));
>=20
> I think you misunderstood me. Let me try to explain in more detail.
>=20
> AFAICT the attrs in this function get validated using the
> tipc_nl_link_policy:
>=20
> https://elixir.bootlin.com/linux/v5.19-rc4/source/net/tipc/node.c#L2567
>=20
> This policy specifies the type for TIPC_NLA_LINK_NAME as NLA_STRING:
>=20
> https://elixir.bootlin.com/linux/v5.19-rc4/source/net/tipc/netlink.c#L91
>=20
> Therefore we can assume that the attribute is a valid (but not
> necessarily null-terminated) string. Otherwise
> nla_parse_nested_deprecated() would have returned an error.
>=20
> The code for NLA_STRING validation is here:
>=20
> https://elixir.bootlin.com/linux/v5.19-rc4/source/lib/nlattr.c#L437
>=20
> So we can already assume that the attribute is not empty.
>=20
> The bug you're fixing is that the string is not null-terminated,
> so strcmp() can read past the end of the attribute.
>=20
No, I'm trying to fix below issues:

BUG: KMSAN: uninit-value in strlen lib/string.c:495 [inline]
BUG: KMSAN: uninit-value in strstr+0xb4/0x2e0 lib/string.c:840
 strlen lib/string.c:495 [inline]
 strstr+0xb4/0x2e0 lib/string.c:840
 tipc_nl_node_reset_link_stats+0x41e/0xba0 net/tipc/node.c:2582

I assume the link name attribute is empty as root cause.=20
So, just checking length is enough for fixing this issue.

> What I was trying to suggest is that you change the policy from
> NLA_STRING to NLA_NUL_STRING, which also checks that the string
> is NULL-terminated.
>=20
> Please note that it'd be a slight uAPI change, and could break
> applications which expect kernel to not require null-termination.
> Perhaps tipc developers can guide us on how likely that is.
> Alternative is to use strncmp(..., nla_len(attr)).
