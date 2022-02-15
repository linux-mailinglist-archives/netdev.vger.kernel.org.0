Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B509F4B65B8
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiBOIQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:16:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiBOIQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:16:30 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60103.outbound.protection.outlook.com [40.107.6.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879256D4C5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:16:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcV+jtxsTeFxLL+Iht7RmnlsSTxcnA/etpRSkG9vIFaJ6eVyfDRsVYgrLQ7gU9h/E+iaLUqE/RyMbIC00GtpYYG8FhmwgwFJlZETzt21uRtWfy7nMmO0D1WRMlvpVD2oI6XQVMiWWPuEEI7JdujgSmx52vG4U0cEGoHTA6X7j3NFpK5aumzoixx5LizbRSk5KQsvb0cq/lTKvGvdnmGYC84OyerjhmYY0tvRPybP5/sjHV4aZRCFOMUVKe5YObl8fiNMagCzJFIgHpAfdAPZrfvwxMZWa7zmaK1Uoj5gtF0kKW/SlipK/vfguhjQlpmQsJR8e6dI1kyM0LER2R9Jyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZIhGgvLw3hojm9EVj5LQG7kaBTKrDuWF28tTsTsBhw=;
 b=P0YlfoUA5LlgJzLV7C8Y2FhD4QNmdLeuET06VOqFoAxtRLllzJs303b5ayv6n7tmYODwELwN0VacPCBX52IKqMYAmqAQIFBvSuV75NRmMWD1cawcJdbRdDQQJeU5tthPIm9s9Fh1IbIrjrJp5HlgxmuGAlsJKUplCakqcUSJrsADL8B3zZwuFM0y9K3WgDrgRNpJJL7Us29YDtunPGFUCB3emnB+jUhWvB1Ou9sW0UmEr0tCYYwpTZlPKIUDWhxj2rbS8MmTnrqLGvfT0FUI2Yfimk7jvtpsVbI0Z8r7FnfTs4S+7ybE4fUrfAJDCRppXKIYZCWA/MNvk4T+52ViXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZIhGgvLw3hojm9EVj5LQG7kaBTKrDuWF28tTsTsBhw=;
 b=lvpVCVhbB9gc1E7nTuxEvu9LOjx8puFhSAUN0u78DG0JZwR9NR8HDDTG0L/2H1OTeaxt+ex07YDUAZeiq5ERX4joLF5jZZL5AdNtzjZmsLHDQfNQbE+q4RAd0BGeTMqWO/1j+p7Rhmbd6eSwzGH3qIfaI8bEMWHDa4BLuFrGgMU=
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
 by PAXPR05MB7998.eurprd05.prod.outlook.com (2603:10a6:102:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 08:16:18 +0000
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::a5d1:a575:60d9:b831]) by VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::a5d1:a575:60d9:b831%7]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 08:16:17 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        Tuong Tong Lien <tuong.t.lien@dektech.com.au>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "xinl@redhat.com" <xinl@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "parthasarathy.bhuvaragan@gmail.com" 
        <parthasarathy.bhuvaragan@gmail.com>
Subject: RE: [net] tipc: fix wrong publisher node address in link publications
Thread-Topic: [net] tipc: fix wrong publisher node address in link
 publications
Thread-Index: AQHYIUOviFMB/tgNBE+HwWuw6vPaz6yUQWHg
Date:   Tue, 15 Feb 2022 08:16:17 +0000
Message-ID: <VE1PR05MB73275F4CE76085AD3DFA4F89F1349@VE1PR05MB7327.eurprd05.prod.outlook.com>
References: <20220214013852.2803940-1-jmaloy@redhat.com>
In-Reply-To: <20220214013852.2803940-1-jmaloy@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07b8516b-20f7-4286-2140-08d9f05b70eb
x-ms-traffictypediagnostic: PAXPR05MB7998:EE_
x-microsoft-antispam-prvs: <PAXPR05MB7998AEE71861A29140CB6A08F1349@PAXPR05MB7998.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmJsU508RMF5vkHL1HXwZMj1D13auc/CcNxdG9S9rjaFnYx15iYnlGeufR4YTKZM/0yBNj8lUm1Jz8/f+Jt5jgZDCeM0U6ymfH5tMrizp4Ik04jSucrWfU2231hy9UGEGLeZSTkN/Ll5k9nNzVNlryT5EniGi3gtXfnJGEIFGYjafjVgnTtKsQx2dKYXypt39uriQMq5PQRI2O6n9OOrLhi5pJ/R76X+2XIL320ZGo3HtUGvo8NYr35Ly0k4C4bh+hRbR8jpS3R3z2teXhPo3QBlgguoCuz28SMTXv4hUOLZ2BmMsqdDxnLTl026IgCze3NmUliu8EjGgp4xFePZiOh+xKm3HrPzp8C5KQ2jQ0qXgU/GhkeJ/zcMhkcVV9W+o2+DF1/uHdR9Xot87rewHA9q98s4a8UcrkYhfR0X01/aROar6VFQIEOy4plUPNWJS7nUWr32KciNEq5ZNmLdTsK+Ae2Fm8kQmQmjSjidf9UUuajeOZQUV6LeB0er6PuTzdxHzBFaDK9uuhk2wCmBVJQ9voalfOvbC50VO9g97kxk+/ljYF2yAYO+0MCCcZ+JrG1g6OWraJptCdzl2rhpzoYu7H0qq/0hA/PJ1HrxJQ7Q/a013sQVF0wvfbp0+xHKkRTLlpmPMiChG3YqbhWNlnMTu9P3e00VvEh74KZUb7S2owvmdr28piXjQMmXuLwuCiNIj5oKSMb973YaYRyDeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7327.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39840400004)(366004)(346002)(376002)(8936002)(52536014)(2906002)(38070700005)(38100700002)(86362001)(5660300002)(316002)(9686003)(7696005)(6506007)(26005)(53546011)(55236004)(122000001)(186003)(71200400001)(54906003)(110136005)(55016003)(8676002)(4326008)(64756008)(66946007)(66446008)(83380400001)(76116006)(508600001)(66476007)(66556008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rj0iNd/jy8Gi63uuZKRwMIJWldbgPMShK8L5HFJ57ku0ZV/PpuSN9P03EMdz?=
 =?us-ascii?Q?s7JaQwpv0QXUP7OXB15oEwc5luxVJc2ITNMqnjlXcfbQl2BE+LVRaBqGQ5ru?=
 =?us-ascii?Q?B+pt/H6I8GdGfq+yDnuf5R86grSnDdE3n7dy1MXGJncyl4FRsMImeke2gbAi?=
 =?us-ascii?Q?JX8MoutIMiUaQStmnP7xliS8IJYr4ZoT5z5Qf1ww3mR2Olh8B3ZJampcb8Zf?=
 =?us-ascii?Q?8PGQoDBh6KXTAgmdDAraozOWMzi3Pza+sVASqUZnS84TfxvuZXBGtXUhN+2u?=
 =?us-ascii?Q?6hG1Lw6O9yPbcziPnjeTJKpGjY6bF/JAYE9TCJGy00ZHcXT9UvHc9cz8I/h4?=
 =?us-ascii?Q?d3yzlDhg4ZpO7CBkMxT6P8yJAeWeobDFo8kL4XgOYFSG2F8Smt49T/9F8B3S?=
 =?us-ascii?Q?i41rLLF64FHkFXqgQuXpyJ7WXo6TVh2an8Iw2kNB1Po3KIRE5boIKi63Qtox?=
 =?us-ascii?Q?cP22djHcDHZn/LMNgV7gTy2uWsdQEgOYw76ThVnz9ex4v0gZUWQzRUZqsonU?=
 =?us-ascii?Q?sZnvldM4ba3kS/IGMzDuRrHnHLynlXsuuITnVfOcfeTrvd1pgkS8h/U+D5md?=
 =?us-ascii?Q?u9ECcQhgYqKr6jGiQ8amG4ITqkRROSA72em0LQ5HTm2QOzASH6hC4lXIzE5k?=
 =?us-ascii?Q?Nj6N37UMfDqsdhPNjd3jiec7eqZ5jrE+oIdfuM3UgF6U8Q83TkYTTbzSg2du?=
 =?us-ascii?Q?iC1Je3Wf4kR4eC2auhau5ZQMVld+zMyTCthZhjgSmlWH7fPUNZ2RLfgolka9?=
 =?us-ascii?Q?+kyDtmSZQej4KnOy4C8igk47uoTfVonuVfD63WCaiHnuYJHArQ0DATZkT+I3?=
 =?us-ascii?Q?W/bWTBh0n6L1oIyGVw06yDT7kXRn+Y8+m+M0pxTynd/x2zNhRo65EPdq3SD7?=
 =?us-ascii?Q?YrCLvAffQR8K50hp75Tzs5Z4NYQnfEbqSnGbAaGUORozb4+RLGjh2eWH5Dbt?=
 =?us-ascii?Q?KOP3hVa2pI+2wIDsxhNMCHZ6QeKZArAZGCDlouxsg9KZ0fCuVHRRw7OY2PHi?=
 =?us-ascii?Q?OW3ODYJ0Bepx+CWDjkbujAsD+tQCHdVm7U8Cx2PtlowpKVLt60eg2q1KqY/r?=
 =?us-ascii?Q?9epMZR7U9V+x8xo3SF/v0ps3fdV891lm71UJEuWJJcUiddohdN/TJCnFOa2w?=
 =?us-ascii?Q?coXOXRv2qBJra1xzyqqQA2aw6f/PXFVOcA4TCk5EK/KAraykd9DFNBfcSJYX?=
 =?us-ascii?Q?fZeNCAJGjO7gUQZmCQo9oUnkmqvDj2THlsgQsbbHt/xz4dDEzqxjDd4wEL8P?=
 =?us-ascii?Q?cmaWr3GHaoloHglcfvVPZFIu8gBSiQmb88XwQaUIUxkFjjPpoUQ+dQ5RuF0c?=
 =?us-ascii?Q?V6/U/u135hhlf4+PTic4Ufj/8e7KMXogMZPBMkivBUPsFf9IS5HYxwNmFU6p?=
 =?us-ascii?Q?/Q4D0tsudqyfTlqfeMHKubpA597+IfDWgSk9y3NMH37Ihd5YaMDhUJhIJvbO?=
 =?us-ascii?Q?EcPQfYVjGNjU4qe7kxSViInlBHOCnv0vU5a55d1Wz2z3MCdxYNx6k+3zwaSq?=
 =?us-ascii?Q?WsybkS5Qixxj9lvV0gx9b6yxzSxh40ME5GMp+0cnRWVdWE6qYd2cJWKOb9Zt?=
 =?us-ascii?Q?PKrz6Xz8ScEaqtF0+iWhnJ1u/3RbSQQdxQCqoUtQbPMJBOpmKlOwAFunonm3?=
 =?us-ascii?Q?iM+3Px/VT9bSvW6V9PeV4h3QIcUeW5FWENrIY5rD3cDKjMpovxtF5EzxO19X?=
 =?us-ascii?Q?L0yHCQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7327.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b8516b-20f7-4286-2140-08d9f05b70eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 08:16:17.4597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2EOIJj3juSVWJIRr7FbceOB9OPpBNWqRDQZUq2Vq8Xuf0X6HBlt1vUycOCUzwy5snZniwQNV4vYwjXHjEbX0DS+taFcrqBudaJFnPQFJLqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB7998
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

It seems this fix caused a problem with user type service as its always tre=
ated as node scope.
The sending side does not know a service binding on peer node as it looks u=
p on itself node address.

Regards,
Hoang
> -----Original Message-----
> From: jmaloy@redhat.com <jmaloy@redhat.com>
> Sent: Monday, February 14, 2022 8:39 AM
> To: netdev@vger.kernel.org; davem@davemloft.net
> Cc: kuba@kernel.org; tipc-discussion@lists.sourceforge.net; Tung Quang Ng=
uyen <tung.q.nguyen@dektech.com.au>; Hoang Huu Le
> <hoang.h.le@dektech.com.au>; Tuong Tong Lien <tuong.t.lien@dektech.com.au=
>; jmaloy@redhat.com; maloy@donjonn.com;
> xinl@redhat.com; ying.xue@windriver.com; parthasarathy.bhuvaragan@gmail.c=
om
> Subject: [net] tipc: fix wrong publisher node address in link publication=
s
>=20
> From: Jon Maloy <jmaloy@redhat.com>
>=20
> When a link comes up we add its presence to the name table to make it
> possible for users to subscribe for link up/down events. However, after
> a previous call signature change the binding is wrongly published with
> the peer node as publishing node, instead of the own node as it should
> be. This has the effect that the command 'tipc name table show' will
> list the link binding (service type 2) with node scope and a peer node
> as originator, something that obviously is impossible.
>=20
> We correct this bug here.
>=20
> Fixes: 50a3499ab853 ("tipc: simplify signature of tipc_namtbl_publish()")
>=20
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
> ---
>  net/tipc/node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 9947b7dfe1d2..fd95df338da7 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -413,7 +413,7 @@ static void tipc_node_write_unlock(struct tipc_node *=
n)
>  	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
>  		   TIPC_LINK_STATE, n->addr, n->addr);
>  	sk.ref =3D n->link_id;
> -	sk.node =3D n->addr;
> +	sk.node =3D tipc_own_addr(net);
>  	bearer_id =3D n->link_id & 0xffff;
>  	publ_list =3D &n->publ_list;
>=20
> --
> 2.31.1

