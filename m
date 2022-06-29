Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1474255FC92
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiF2Jwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiF2Jwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:52:50 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2136.outbound.protection.outlook.com [40.107.104.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEEC3D1EE;
        Wed, 29 Jun 2022 02:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR7PUhwLNpDziekbW8IGAt/Q9dY4ryuykfg3wgQCiSOpXKqbR99RSYLXSnat/LA6ZtkfLtv10JhGQIKtFSUUJvfP8HL/GL//iHITcTX1vdn+UnPJCUXzFU3hn2SA6Um+t8qjj9YyCWxWktiFn1dF7HKDRxDbnHB6FT87eeYoqeYbLuD3QacQrM1VDHJd2J9zU6h6Sjli77ZH6qXbVzH5jPzFNPfjJ1cUBR5gNaK3j7qi0R8BnUc8gXVsiu6rdW4hHrr4HcyIgC/zgjKFGsN8ifv+VEUXdAReR70PQtXL0bEKEjuJPBUXPSgrCEibDZXz7meG8UNVvHg2WTVanLw4Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7xMGmB6hWudxG0nYiWXq1GGG/Jf+BXathV7N9e8EfM=;
 b=EzCFgsrHS17wcNXPWz/NS0GYD44Lu7L6pw8e38No8wmmPIY/eOWqx8k7ITRKvOMZiob3umi2H9Wff3Z8hGTSZU2uHBMwdUMzgA8CZQ9aC0iaifI3CMTy0yrgCXuzEYYssL95PGFMYkNvHVdNz7XbQoz+kPLTd80U20an8WQ4yP7MRH2AgNF56y2iWWOPqN/fOZQ3MSl6mIX3eJD7I/YIhnoDhwI4yyzygC/IavHreweLXrHM/ddVieKFAf/SnP7C1yHzdA384kuVprHstIgPmer51Zkqt3rGJizCczZQYCMms3wfjgugKofCi4MJkNYkzTkuUavuodtvHNm6V+fwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7xMGmB6hWudxG0nYiWXq1GGG/Jf+BXathV7N9e8EfM=;
 b=u4rFdwPeqNw5EjyTyoWFfq7D7WKHcPuHy6Fjda1vDrJZazPabMDOEPN/MdOPFU17L9sbv8GPb1+c4t7awTnzi7nHxIEv6a1MDENuA5EOe1N8eFT+j9IF1lVtM0nOvNGEkh5BJanSnbT6jB+FRcH7hybcHOKJslljAH+EnZ2VM+o=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AM0PR05MB5028.eurprd05.prod.outlook.com (2603:10a6:208:c9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 09:52:46 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c%8]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 09:52:46 +0000
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
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH v2] net: tipc: fix possible refcount leak in
 tipc_sk_create()
Thread-Topic: [PATCH v2] net: tipc: fix possible refcount leak in
 tipc_sk_create()
Thread-Index: AQHYi4JUvStb54j7p0OvheO62IqSh61mJLIQ
Date:   Wed, 29 Jun 2022 09:52:45 +0000
Message-ID: <DB9PR05MB90784623C9C6206C3C44980288BB9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20220629063418.21620-1-hbh25y@gmail.com>
In-Reply-To: <20220629063418.21620-1-hbh25y@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89ce22b2-02a4-4c10-fb33-08da59b51e5d
x-ms-traffictypediagnostic: AM0PR05MB5028:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0K5qBshYUV51tuL4ald/gbn7oITw696IoTXZoMaem+gaAQCq6i/Doz5XMhYE+AscRlc1YvtKJBgZTx21QJVRw3iCDZXZ2QgZvZWvonTYtTPC2BgCSB3PpNhD9v9sT79ANfk7wlBNq3TPWq5iXx5SRCuxviBoRKpjZIrwvTLfaISM4y14S0/muuT9PI/j/wlSsXmciRV031hvAxIX6YCNXE7dvdMotuaGE0Oq0rQ9CWr/d0YNoDCjNGlg4AI1pHtex85R5VToYWgipWZmYrDydAUEkZKEh3/37EHODqK5qiixLrfOcykz/wq+s/WnrhHNwxxbXKEx7lzmM2SpZFD1zZlhMc2G5+Da0EUCvQ7NLE4ywsqEcA7t3vNTyZLs81ul3nk5J1EsDKlWdGqyspCA5TDusB+1kIHe6NQxxWEQftO+9QrV9zldgRc1XIGEn+LNlWn+NlWy9Qw7tsOY68Fq0VCfFchV5AQvIa1XFnS8YgSNqZKxuyU/oaC7CJnTHKXQa31zjqwwqtZ5C2BIyBA84pNORTuKH78kC2pyLk7/fNQIw91LVZIWBwpHj8/o+6tWW0nU5v/hE0Mlh8uG9/ZwzQnXN6tdcLzc4v+2+1pdAG4Fd+UGKoT+mVBI1fWgoyNgCbyATffuZNrI7yCUKfboEtRTUopWXRw5ANqxGFLhZ/Hnusdssp6YW6OKTw90S33iKSV5ho2LbPWTxc/WQ2x/FmfPdEjyIxJM5MP1V6dQdEkkfHSti9eT4vIKUHNLWKFOs2vJVXJmEIkWWOzOb7rzCiV3cktJvyoo3mnYxGcxuVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(136003)(396003)(346002)(376002)(66556008)(7416002)(66476007)(8676002)(52536014)(64756008)(8936002)(4326008)(66946007)(316002)(54906003)(66446008)(76116006)(6916009)(7696005)(6506007)(478600001)(26005)(33656002)(5660300002)(2906002)(55016003)(4744005)(71200400001)(38100700002)(9686003)(186003)(41300700001)(86362001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ekl7I76JFVRMX+lXzGwGZSHWahw7D7RunHfiZKRffUjADscfIiFYf94k7Wra?=
 =?us-ascii?Q?QeoO/Onrd9Tbni4hNS0dbgtxjIj7bdC7OCjk2fzo1ZXe2+l5wAOjDNcCVWYJ?=
 =?us-ascii?Q?U+0sfM8eEuQbJa2Np/D6bAGWFIW+poYD5CS8vcDn5gdKzcYrOr1Iqj95muPC?=
 =?us-ascii?Q?Bqswd9HHUccRYAXyrtw0EOduq0zwD1V6vadTBwqkHRM5+oChWOYeBR8A+857?=
 =?us-ascii?Q?FSVIVnkTaRxKbPaE67hxp0hYD85iGcqGAHk/nPhL8xb5JyHmFG4tgspRVseX?=
 =?us-ascii?Q?A0mTM3s/g0ESya6pTeoow6kliILb768kTVcRcdrlwH2fAsjy+y7FkM1Xix4h?=
 =?us-ascii?Q?e1UTKxTy5QrUTDeuP0SCbia4oUcK7nML56e6TFYcjmJ9RPJ4pto/7X+OCMmK?=
 =?us-ascii?Q?o13kaZQS/OiDEg8AxRkZQzY2TbFaeEf/MWXGLfeD50qDwuD1DzOHJMUszzxt?=
 =?us-ascii?Q?tP70p1y37vbbjUVldoHpvtPV/HDn6bh/GcgFg21U1LF+0DPNKTzqncEZXZ6W?=
 =?us-ascii?Q?oaSpE+pv/nANncGSCLu/v4NzmJ60of3uZ/NswTQ9N6NOHsIRGA/bBggMdnAl?=
 =?us-ascii?Q?PBxXiCNaOVEnuvRgtQ7L70iwCRsNMcsgQQyJChXqBz2cu9QwHa0gc6yM2AbB?=
 =?us-ascii?Q?SumkQ5Y67dWV1rsHz3Us3a8jGxspf+n7FgJU/2U4hY9wNLazXcv2BAzG7Qr5?=
 =?us-ascii?Q?z6jWnIfjm2zDHzHCmdK84ucc3sHrFV+nC5EQvCBBNX8GioskYA+N8v37xEiT?=
 =?us-ascii?Q?gdRK6zfCj3T/NAtNBirZgrnNEvaOYnlW3NIL7sTlAlIDRN1xMM+AmpQbakly?=
 =?us-ascii?Q?6EpZwlEyorgRSTRq2+qv0CoZOfJcmDCC5iQ6svXyECtNxGdEub1RaOP2UiYm?=
 =?us-ascii?Q?NZaX8V0QxA8U214zX85t/etayKEh0Znsz8O89qUQenWEaB7w2TP7/CHXaz6z?=
 =?us-ascii?Q?bajC44ryDH3qo1qQAD/r/hwvZwwcrjuCEz3e3jKDPM5cILVR1tmrRsTYPN//?=
 =?us-ascii?Q?N18N3/CABCZnDkamtFubFQYW+QHekxD0s1Jza1tbKDnNSTe12AEAuwiYsGtO?=
 =?us-ascii?Q?CXb4OryXrvNhB+ecrnDSwTS1NRgdFQkvYTlAjxyXZIyB//XbmHREjxDRKo05?=
 =?us-ascii?Q?Tzs3YzefE4jht2Ve3ZkkrxRwYufVEZzbUjtMkKYVKnfXqLbxBaNX+Bjqhr45?=
 =?us-ascii?Q?XsjdP+AWtkDpIRre5l6S4x1X2W+9COFM8EseFuGF57btKn40JYAesW27fMzH?=
 =?us-ascii?Q?mcV+ZSq7AxF+4KkA386Up/p5pMgv791jDIvml665OI1Cl/UBIHqJvSNBO693?=
 =?us-ascii?Q?0mtB6DXwJYNgURAUP97yQCsbukDTaNClrPO7WXios7tFdVqck+bLaD8HRMdx?=
 =?us-ascii?Q?qK023i/ddf12ZPL5yj8zFRYuV/yrawqCmAamMI+d/FsKHyJ+WIg2tccmsZ/I?=
 =?us-ascii?Q?SYHOAo9z5f3o8l+e0dP2x3Ejt48DnCoBHL3ccvNSz8QAWm0vIj/uhgCs+TX3?=
 =?us-ascii?Q?L5A8caVWDPwl3UX9SPKpKz3kwwPzFM1hiA8Gm+Gg+3Ah7re4RYzWVvH75lYn?=
 =?us-ascii?Q?ScEdcrfV9JNPKuK4JyAa8JRysMxURhU9fE33MswC70nyy2obq9rxZBFnSMDv?=
 =?us-ascii?Q?CA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ce22b2-02a4-4c10-fb33-08da59b51e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 09:52:45.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y/tMTUGNPgztiRl3NWUOk5EUP5i0wF7uSo9XFGj3cIaFAWKsU7mNCbU2vC2Fvx2ctkuXGPciM5MGnX0HMxk0SlfNszLRKYvoN2p4alWF8CE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v2] net: tipc: fix possible refcount leak in tipc_sk_crea=
te()
>=20
> Free sk in case tipc_sk_insert() fails.
>=20
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>=20
> v2: use a succinct commit log.
>=20
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
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
