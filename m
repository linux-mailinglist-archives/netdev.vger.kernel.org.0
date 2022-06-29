Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD855F452
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiF2Dty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiF2Dtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:49:52 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50106.outbound.protection.outlook.com [40.107.5.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABD51F2DE;
        Tue, 28 Jun 2022 20:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2ciyloXmuxWP8ZC3T5MHhWRfHNhQICW0QIvyNmaRc9g7+zIZC9lPrUNWEdHQMrmy+rOx1UkpLEZcHzbqBBq+IaTygQaEbCD98/V1Qyf3MejpWPdZvHkuv7+Y9LbsGY5zH4CRfJIE5KTo6nhVhDBXGZ7ew6UJ6kmTqgqzfD42FT2luJn8rxujIIo/cdh2/7UVykuXXpyKIqIvsuEhKMpI3Rb/2N9zRujJlxbnu09VRmqdRaSmf/gAb1oQ9HqxxibLID4iT3NIg+zrK9rTS3IHgoIK/wk1vBsjIbeoOiWxX8AudCbM99QyDgNPDEROvVOdtPdUqbJOmlnqcmmEFRlKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1h02NenE5md8XyJ/jt5d8GGgQuE1ml+EXwMGR6MfmoU=;
 b=BAjdBMF4Prf4FFyvtMlIteGneNOIsla6xv3W+sDtwuriIkGsJ4/gIaSm2K0FUiRK6MNSIUPirbTIfezkl0T8prEmtcAjoCfQY3waAGMIf8OcsekCFn7NxcCl3rAZqxmM7HeHPi0seeuCnGObXZQr5y9o9LcsMuuQXu7COPaQdYmif66+UBoYE6nWzE8s0TWFJShEKpIbGA72O3/jiigJ6o/h7d+IAj/V7vsFmKOpALl7gm6Sn13954BRkPcOWO1uK8hao/9Gb5yXlH2mbNa28D2MnRdoo+HNaqylAJqXWnImwlRSot/wvWjPHapVjkclgYeFqCuAJmfeYyu4dZ2PGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h02NenE5md8XyJ/jt5d8GGgQuE1ml+EXwMGR6MfmoU=;
 b=CUnKZLFEri02tFyMAR0+tCrAF5hCX3njJdtaDvNp7IQ92AvSf4SJpP2IyexodPwotP2KveROi3fHYwrUhpqnuBRh7voBICyHREL6/HbXKa9/ARvVuSXlNnNSXx1sY56wOXNXOGvwhqF6iHXLQJCVOzAQSnPiZFWM1NcI4kj9SAk=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB6PR0501MB2806.eurprd05.prod.outlook.com (2603:10a6:4:85::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 03:49:48 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c%8]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 03:49:48 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>
Subject: RE: [PATCH] net: tipc: fix possible refcount leak in tipc_sk_create()
Thread-Topic: [PATCH] net: tipc: fix possible refcount leak in
 tipc_sk_create()
Thread-Index: AQHYi192N51RUX/j7Ee6L+syV7EEZK1lvebQ
Date:   Wed, 29 Jun 2022 03:49:48 +0000
Message-ID: <DB9PR05MB9078334A4067BF8F84DF60D488BB9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20220629022402.10841-1-hbh25y@gmail.com>
In-Reply-To: <20220629022402.10841-1-hbh25y@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee8302bd-1ddc-4e9b-199d-08da598269ec
x-ms-traffictypediagnostic: DB6PR0501MB2806:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XI9TkFm0CQ1LUqnPVMXyeT/ryMd8ncY05I0out631E4zz5j8AjfPEyI/KcudFXGlni+9m4QIZBvyrz/63CTueGTrU1m4K+LI3y/cIvTYUoWKwWx6OPSt8eKFTNWTpfU7YQyZXUpOok5UBMBGpOqdBZvYFs5zENjuBKHrt/H9M8khbkA1fUOwQ8Lsig7HdcMsUtvYvi5ZpP/nYtSeWbDYh+E9iAAZAq5dgdGrLqZBHB/iL3A2KHYe3QRjCmlGX8ozR+0EdaeUG1z/zmhahhf3X09uLeDM5kd3+njNBHSIYG203LjTZesSc06GUrEN6rK4WCBQeLMjCN29dlKfisAtbzYSpdL9RDujmQdB1CORQoPKaGZwZe5SKcgQkV74IVNSZbCj0DomRtkbjIJoAVyNfmbsDIRhxAA6yYk+mS33L5mGTWytfBfG4+PvDAwHFoJfleHtPXRnEMb8Qm1YNj2TKgAtEJa99sEGsdzAE/4QAO47RhX6+nrTOR+WqyrYgHWMeIhFiPCx0vLEZRhKlXLuSRFOasX/RaQKzhIb20Lkd0QiWpX4FSyKpd5PnRvYMqvhHMsLz1Tg+loZp3p5iQ2r+5MRLnYmS4VlSpirlN58ER/wgqqFE3cHVBNpv9pQDckOvJ01jnpiGgzxgV1VtHSXOgMbwUCMh1YxO+vUwA09sakpqLVTPPSFNAodZ9sksJ/6DaOx3Ge9vbNNFvGEUWP82NDzU6YGHun4W6hEuC82O7aWa1eXlFTW6irHcxQnRRuTnR4tM0FCr2VYnj4QwAT4MXGb50wg9xO+lozv6OmAcE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(39840400004)(366004)(38070700005)(55016003)(66446008)(7416002)(64756008)(122000001)(186003)(8676002)(54906003)(66476007)(38100700002)(316002)(71200400001)(7696005)(86362001)(52536014)(5660300002)(33656002)(4326008)(6916009)(66556008)(4744005)(9686003)(26005)(2906002)(8936002)(6506007)(76116006)(66946007)(41300700001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O2AiBNotSky3mq99/0eTluw85oFTSPZa3G2yCq/As0DuzS27XVA5QNibg+l1?=
 =?us-ascii?Q?4C3DVgJdTJ3sbe5Xn+pAE2nRAkiK8PIbNJu+hN3sFUgQWzg+P+rJqxQj5Yq3?=
 =?us-ascii?Q?vNHqpVpFw0aLcFya2Vkl9kEMWQYWOHHTImlrccTdYuvk656S5oiJ3+plvj4E?=
 =?us-ascii?Q?+9cW7QjNBeGvwkINTA2yXJLw4CFNmQY7KJwyu8M7EEKj3CVNsLxMwGmEu+ob?=
 =?us-ascii?Q?DrWyzUB+VKHjXIpAoxUc9odDmVCmpwr+D8edZUy0tngukGOHVP6SxnhKbBsN?=
 =?us-ascii?Q?3X5DrM0XDnPI2S/9LaNWKYamdyU+q9EcL1WqZtxSQRv/nDZesxwrSpJrgezX?=
 =?us-ascii?Q?vtF5/Y9LDz7B/myBE3AaeCfHc98Iyk9WgVUGtzOyiLdk3REstByV43r72mIL?=
 =?us-ascii?Q?mS6QiemF4hoPYd6hpP40okZVna78vUk1toHKof3FCiUw0m7m+i+YgjxBN/Oa?=
 =?us-ascii?Q?Y3GfxXwtP35Aun99WuROpzSoURbCUivBWQskrsy3QZVXdlgmI8tRrUV7xz9B?=
 =?us-ascii?Q?wQ39I/fgzq5tCOBZcvCQWmk06f8HZ8ePhjJgOZbhB768dQTXsMnV4TksKtOI?=
 =?us-ascii?Q?YH3U8/iQM4eUoykJF2oQFgDuw6fhOrLARJLLYZZQFSZZn0kOpINEPLJJHHh+?=
 =?us-ascii?Q?I8kN2EgDPYrC+IbVYZwQrXnJilkpbsn6HteUuWgWaG/jktn0Xscrdnk6aZp9?=
 =?us-ascii?Q?TjryCJGloKPjbM4muccrugMHe/oxxV1kPg7ug60LdDEaNT0I6QD/NK8c311Z?=
 =?us-ascii?Q?e+eTLPSfxJ7Jf4R5csf2pG9iAzPpp/NK9xOk88pLCwxQaa5m5p9JXGwagtvF?=
 =?us-ascii?Q?XTUFLgtHq5lbOazYv3qgOfzqEIB/7KAdQYVtc4GWWj34PQAhkZVBfFOBQ7vi?=
 =?us-ascii?Q?kzz7YYSip1Eoyudb5gXvkRqAvSoEmdJ/AXzGtwzzg+eq7Eoh5Ts8mXVBSgas?=
 =?us-ascii?Q?3x8ALW21nGbBsSB01zVa0ZB2DKJ9iH/IrBAAcLbQM613uRkF4yI/J5jrH+tF?=
 =?us-ascii?Q?1ExKA4uI5BpGYAxnRQRUxX3ibSNuB/auDwWWDcsgXL1JUYJqbQyBVQvwfRBc?=
 =?us-ascii?Q?w35nYj8CPpxde9C39xB5itGWhri+aFmAcVJPgf30vp4BrJZItqR3b2goYflA?=
 =?us-ascii?Q?iRAmaAongRFOZlroCOAnlcxa0/SSCBHGZ5GvAaLW+Www0Yll0RIUDF1wixhw?=
 =?us-ascii?Q?AC3I5/iWKxa6ILXcrEMZNUKX8mI5qTX0bo8g2rG/DS/YNP5EBg6gNf/cRATC?=
 =?us-ascii?Q?hbi7R+f6QXwkRQhR4zTitXxNy2r6tMDDHlBC/CEgoNY0mobJKdwM7bnkiB/X?=
 =?us-ascii?Q?1mbdy998l+stbuiK9mC8Ru9fMjK9iFcF2iiNW+pFiNTfZleA8+pSPgNqE9Ny?=
 =?us-ascii?Q?cdzNewiGG4aZ4Zxj4WzGEeHN9qVA002I161UkS6GdaWjHoxI9JSY8uLHPWtL?=
 =?us-ascii?Q?UfFvseaGcuKIrj2B7qvTZmkCfyPIEoL61NRSowjd1jP6QTTCkzqvLeoUat2c?=
 =?us-ascii?Q?NY+Tl/FUYud0eJX2DM6EhtTLW11+bQn15dAL0GOpc2yWfFcz37Fvw3pMpgOr?=
 =?us-ascii?Q?FvsmE9LWl1yeXZVjaI0p7bPmdzCB6Qz7SY80MbFWW8K42uej0yEuJpB7WG8j?=
 =?us-ascii?Q?iQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8302bd-1ddc-4e9b-199d-08da598269ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 03:49:48.3498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NdGuMhQA6sIicz/OfX4OjYgIzBAhbiEkF0WMnebKjnvLl8DjB7NS22Gnvr/sIlgSST0TFPkXOxay2H6I3YzhpM6QTIUoYOqh2nq//KaiAOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> sk need to be free when tipc_sk_insert fails. While tipc_sk_insert is har=
d
> to fail, it's better to fix this.
Incorrect English grammar. You should use a simple comment in changelog, fo=
r example: "Free sk in case tipc_sk_insert() fails."
>=20
> Fixes: 07f6c4bc048a ("tipc: convert tipc reference table to use generic r=
hashtable")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/tipc/socket.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 17f8c523e33b..43509c7e90fc 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -502,6 +502,7 @@ static int tipc_sk_create(struct net *net, struct soc=
ket *sock,
>  	sock_init_data(sock, sk);
>  	tipc_set_sk_state(sk, TIPC_OPEN);
>  	if (tipc_sk_insert(tsk)) {
> +		sk_free(sk);
>  		pr_warn("Socket create failed; port number exhausted\n");
>  		return -EINVAL;
>  	}
> --
> 2.25.1

