Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9EA4CCBAC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 03:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiCDCVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 21:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiCDCVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 21:21:20 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2097.outbound.protection.outlook.com [40.107.22.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B06170D43
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:20:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaKXKDYEYsX48B+pYiY5y7FpV/kcIS7H+a+694uASw643GGgf34UjpDO67ZUcXl/BoLPm7Yo57biecKCkHckxt/q7gPcSmMrGHn+u22OyoUnAkZrEJrSh327Ydzlpxez9Tj5w7aU1To4V6MDc7+fYC0beVyfND6K/GX8BTpCmbd4kUdzbwvYSyapxP9bsk8OiytBAanzZxAsvq4j7S0xs1Iz0vlEMGQmrJBg08H+ow8+X+TlF9VaZtaz7StG8UsgrD6y7Op/YZ7nQLTJ4oZ+EkEreMYRsk99HC4PZZxViviU+8DKR7IgRpP1s9GEzu+0kou4aULkBZRVcgMPT1IHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWlVSPOubQe9uWl+LLZ5mifljlYF8jWztZuOuyP/j2k=;
 b=EgzIn3YtIdG3z7V7LYplRcgtTk2ukQd5u3NPQXnEz065DlGOqrgcSldHCQZcnvOW+jElkE7tTwyBPzgzvMpuXt/vynXdNFtGkYh9Ooen8mNs6RkXtfR8B4/Jd256KhPgYINmnohpk9bvje10fe4sql/dcyj79S1g+OqM5WACcZsGfh0qGaJM3ZuTZcuREqApZr6Hk92VourLSuzMiBvxINIgmy446Z84fMz+gA66oE2ReT1DkyOp/xBxfmQF9+1tjEa97Buon69vESPsqTRydrvZVw3oNoArpcNmntcWPQ9OE0M8HDklBh7UarmLPio+nu7U68xogbkq8SZ47hGKIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWlVSPOubQe9uWl+LLZ5mifljlYF8jWztZuOuyP/j2k=;
 b=ti2mkTsfAQcU1n074ZqXJosLHiKNSfvu5wsbT8mePkjFElpcZ1Rg8yX43eNDPUYFAGKoa3iF6uNzwWuhOa+OJ/jl+GGiKq3XassN/GjjI0/RgelDIVK92i+evmvXtjVY7kPDkD/c2/qZbSVpx9Fb0aCi133bq4X/dsH8NVcR6M4=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS8PR05MB8759.eurprd05.prod.outlook.com (2603:10a6:20b:401::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 4 Mar
 2022 02:20:30 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::f19e:3be:670d:9d13]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::f19e:3be:670d:9d13%7]) with mapi id 15.20.5038.015; Fri, 4 Mar 2022
 02:20:30 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shuang Li <shuali@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: RE: [PATCH net 1/1] tipc: fix kernel panic when enabling bearer
Thread-Topic: [PATCH net 1/1] tipc: fix kernel panic when enabling bearer
Thread-Index: AQHYLrsxOvJ8/Ucc70SBy8iceidY2qyt2WiAgACleLA=
Date:   Fri, 4 Mar 2022 02:20:29 +0000
Message-ID: <DB9PR05MB9078043829EC119527F36CE588059@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20220303045717.30232-1-tung.q.nguyen@dektech.com.au>
 <20220303082629.6f6be6a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303082629.6f6be6a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3a6be73-599d-4eeb-67ab-08d9fd858dcc
x-ms-traffictypediagnostic: AS8PR05MB8759:EE_
x-microsoft-antispam-prvs: <AS8PR05MB8759567558EAEE74FFCD378488059@AS8PR05MB8759.eurprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZaakjzFpIKzXgU/jKvfDJdeCHtUJTj16LApLt9IXHsnjtIs+ODxT6bqQt9ofsXdhCXq5q/DBXXDp3fZZMnOujruiDErX6llv6vrhiyA/A9siV8mbSZEFDtBNwvFDqYiD4jNvXucqVzhCo8t27NRkNivX5x83NYhTW5P/TINxMVrSOf2JuddEUdBbwqdtZGQ6OPOqLiJIg1/zsvc0Vm5tiqX41Al3eRioTyfyp55LY0d0oaz87rKKmeEqKE30YL9pEgBeXmENA4XVKZ0KyjVmlvM6ZMNpNeoe+Z53gL0qXFMIekfjSzF3xfwY/qpoS66CogzZSDpyVvGRZAiMoqKBylkOECoUpQM5mSsqq/AESFgbOv8eW92iueFtaL45V0z5/LBNb3N6+x6c6B33Sxku5Z7XBvyyjHkGu5M1DffPUPJIDIZ2wRRiOB/Sx6EYkZtpC5hdyWYclyoNT3iTVo3P6mYZLDw+YlENO4HSCL0NFtCdIXAV5bDf6+ziccrEMJBMwlYBBqfeaitJHpBumgoaorCnP6HLHfvWdX+x9TbmxpKG1treGQJTohO6n5h+ia4LKHEoX4I/Ecttc7Gi13nQWFmdil/FD99/tNYNmWdhmfFvUaFDHxHCh8OWVTrTWLX7Fq0Vr42e9jl9O4sL1MUNM25wZcqEp6v3WjyClP5tXmDn4Oyu6AFkwI2Kqsxe4yy8U1STOSxTR7XRhDWq9uStzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(366004)(39850400004)(346002)(376002)(8936002)(4744005)(52536014)(71200400001)(122000001)(26005)(186003)(5660300002)(508600001)(86362001)(54906003)(55016003)(38070700005)(6916009)(316002)(4326008)(6506007)(38100700002)(7696005)(9686003)(8676002)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?11koouCGis45DOdWv478FzVehhdWyiRvDl4hiU++Od+kKdUDpwPdZiv5eVmA?=
 =?us-ascii?Q?bUHE74VB6RvwQZ1RuFiNgWYugueIsUFKEgkwVx+gTGaAnTVh2uS5JgDAy8Xe?=
 =?us-ascii?Q?XCb0qqXJJ/tpeLCtCAUcrxLRMgrouRwIr+exJhsiySdMKb2qXZCBI2YfPVJN?=
 =?us-ascii?Q?oGGOD+fFhO+t082Na5Dd4ko6t3kbvNY8GikQcR++zDf1DOsqZ/WHcOh9LaB3?=
 =?us-ascii?Q?iH/zSte7zkjwnSr/jkW7CQsCTfxCUES0yaiKFOdpwDmrmu35V6jYFLdoZk64?=
 =?us-ascii?Q?iRMX06sNaazWOuDae2JZBOwcROnY0JJx+ePA2pvBkEzupIbmT7FvLfJbi3EV?=
 =?us-ascii?Q?BnbQw1wwbQi16m3BoYTaT+PXN84OhLSjfE6NG1rFlnVlIgZ+1rYx9qNj7HXM?=
 =?us-ascii?Q?JbN3L+qvbtL3Y/BW06Epj+kntWxODtDjt+LUA1rNpGSDHhTzWPSQoU0u1vtP?=
 =?us-ascii?Q?hLadid6cfKr0Mlxjd9ZrydnHxjfCd3BJbq/dV5QmFY/PgKsNKzVxk/BCHXeT?=
 =?us-ascii?Q?V9GBdy/3/aNDMp6edqbAyzG3IMqL1xo36DUC3fEhTTv3J6p483O4QzuNdJ2K?=
 =?us-ascii?Q?zpw0sZPytNqeTv6lb6nWY2Hlse4XtXbJh9G5FT8g2J2trhbY1xKLn9EAcQmq?=
 =?us-ascii?Q?9sG+3BrkFpR0Vo37/1F1Ql5olKdk0Urjw0BmBTr2phxINu5E/hroQSpkgtoj?=
 =?us-ascii?Q?pekFPk2WNBlK7OReLM7zpN52LrOJfgdKLg8BdxRNMrjNVTdiVr35FySGqE1Y?=
 =?us-ascii?Q?gAMFzBULL9OltCt3/vnTU6qJ0xSiBbiZp+6oFbcqodwxtfxNbwTFtUo85NmY?=
 =?us-ascii?Q?BsFq7C9u5X6ekoIzjnEEeMy8j8MJB8HrjeEGV6MGP1rdvWLFNVgDEu182CC9?=
 =?us-ascii?Q?KIO5hxV/c4X8WjTlsBK1ybfSA8HGgUFhENFtOx7Fy2VBy+ky3gEHWzukciB4?=
 =?us-ascii?Q?blolXzOU5wN7CCmRkVfSSSkQsP7hJlZtBeVhDfCi8cG1HVOi1hM4GXbZ6P2P?=
 =?us-ascii?Q?4YvY3u9OLqwczNPY8FT/XFOl9jYxV+qm81vHnwNPMEEEg2u3RwSFm+cDyzW3?=
 =?us-ascii?Q?Mq3kvfIVWMy9wPJVZpoH2Wrul1LtXtqsW0Apvz/qQa9y2IhPZvWEBJ4qibpv?=
 =?us-ascii?Q?M+xUVWbQCwXQguNAHWX/zdIIVFbwPJShERWOnLrkZxjtXrW0iId4DpybGqwP?=
 =?us-ascii?Q?9y4du268FvMYVf8rcScXe1d06uuKoqcyeOWEbeGopY9gy5hpoYpqU/KC81qv?=
 =?us-ascii?Q?NdNYOAqnR9694nTF5d84W1VleCMy77R291YMJbShg9MYEioN+49fDZjfxw+l?=
 =?us-ascii?Q?znKUGFGDIYhEMd6IMkwLDTgjeP6Y/AFjVw+7boo1K3/LsSGHwX238Vh12fhd?=
 =?us-ascii?Q?Ghionl2tduY59Xf/NATmYjZ33lDI2tILNeB1jFyPjFUkkfWNKfqgYrYeru8q?=
 =?us-ascii?Q?0mNkRakW/LoPf3xU5INulOsgDYT2xUvm8uujehR+osZS46kgKtBqQYlndKNo?=
 =?us-ascii?Q?TEL0qFRaEXdbHpZYtEKWeXHUPFKooyEpy/wea2IzM965AXn6iDj1c9jJ6z/K?=
 =?us-ascii?Q?cJQh1R32No6yNZyuVCEVnmT55DdrAP+3aroPTqxuvAVIG6An9nXaN57+Zw7m?=
 =?us-ascii?Q?pTqkOIIVOXYwsnfb1in/msfwGbkdPRzN86graNyrDplSTkHMAlUH3DmeOHyl?=
 =?us-ascii?Q?hrZVZw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a6be73-599d-4eeb-67ab-08d9fd858dcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 02:20:29.9691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s264PVBMK3aJKnyLOQzTf5LW39zr/AxoHExvrVE+3Bc3RYmRN85Sxw5AHRmSGAneMFaHF0WEz98vwuQeRZaYQFTjzV6bKuaMRNCU+O2jcF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8759
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu,  3 Mar 2022 04:57:17 +0000 Tung Nguyen wrote:
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 473a790f5894..63460183440d 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -252,7 +252,7 @@ static int tipc_enable_bearer(struct net *net, const =
char *name,
>  	int with_this_prio =3D 1;
>  	struct tipc_bearer *b;
>  	struct tipc_media *m;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb =3D NULL;
>  	int bearer_id =3D 0;
>  	int res =3D -EINVAL;
>  	char *errstr =3D "";

This chunk looks unrelated and unnecessary. The had previously trusted
skb to be initialized by tipc_disc_create().
[Tung]: OK. I will remove it in v2.
