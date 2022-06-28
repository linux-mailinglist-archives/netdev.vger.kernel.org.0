Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062CC55CBFB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbiF1K2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344360AbiF1K2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:28:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0723.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::723])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351342D1C2;
        Tue, 28 Jun 2022 03:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMOn7gTuYIskvhqppSF9jCxO4tecTH71OVdPbjD5SpnGV/a1Wu1f+d/uXidLquMm4vleXDk4/Zs/oS4bZPeJ3ZfxqRGz6JIO1lz4S2KN/snJHwdEa4uCgTXX0a+KjcrAlsJARzir61HxxtIFw8LShhyenS3O9Y8uMO1Yi1eAL8IYQkJuJcAJ4iHolAkxtXx2Ma43u4kddseHdBasMIMz87WyOXLFGbGqvRFZNrzHHSkk/Vd6CdVXb7mkjAvszlPyR9W/wqowqa+0uMUF3oD0rkfhta0y3nSDprNuqW1oOrIEE78svuMy3Usv4ktWRGESnetROcY/iCpOdsXgiS5GAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNL9/gyF/pCOOaogkM6xvLMCNPzl7FsOJmhy0NTnbJo=;
 b=Pvm9Zeld/NuxnCNUvf+QQ/7VuV8v3yDG3TC1+mkiRX1ZL+/eaGD9k3zvQgzFZ1mtesWixVoGmMdsXzL0wn3aNxnzMc/1uJWDUSKoRquhSZF34Tnccdlb2reWXUlt+zI9t8LzdyEZ+3GwrfdEbj/+SnJvpMMrZlc2b011JWXnf5a/z6rTcuE04gZICrNNL4daVD1AGLi8OHu96LtUNd9iQA2pdV7upwlSnDMpJVMUpi0hxIIX2iOisvNBA2Jv+QXGrCkaFGiB3JfWOAjDrmWGuddZmRNFkrgqq7rKaVf9uv5dqECTgyA1LmSQPHGnb8/PMJSGrXNBLuux0PF8g428Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNL9/gyF/pCOOaogkM6xvLMCNPzl7FsOJmhy0NTnbJo=;
 b=BVMxwIl9Fyi66cymguzN+1xpk/uKWhGnri/nUfkCA85W5HaTFQUL1zehhL/zHnlY5n00CQlKMSutbm3Ov4dfldScFDuYbM3dw7+yaEr76WBrCNKCEGLygIj8toVPNv2tx5jyJDI5hVZkwxkXpdlV9K3mp/IogAxtVc0Butk4nAo=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AM8PR05MB7892.eurprd05.prod.outlook.com (2603:10a6:20b:360::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 10:28:25 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bdf7:50c5:5b0a:642c%8]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 10:28:25 +0000
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
Subject: RE: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Thread-Topic: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Thread-Index: AQHYisl8PAEBKXypW02ktgKhMaCmZK1knW4Q
Date:   Tue, 28 Jun 2022 10:28:25 +0000
Message-ID: <DB9PR05MB907813B07EE477FF7F45DC3188B89@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20220628083122.26942-1-hbh25y@gmail.com>
In-Reply-To: <20220628083122.26942-1-hbh25y@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e69fb6d-d096-4c22-8c58-08da58f0eeff
x-ms-traffictypediagnostic: AM8PR05MB7892:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wletI+HRXb2HLVrLTikg5Siy1eDELvdxrt1Kqgh0I/sPnhbXM8YH5S18hhzwIW2OYCN0sXyZC88n8/0qo8PMxEdArHMg+/TBtV5YiCCzyB4fhhpKS0GIvr/X3DefMlK9DKm6QSupYrddYILoR+6n8Zil3RTziC7TYSML+zZl37TK90SUzsCcW2Cj85cYx3FTj/16VeS/q0qZBR4TSym11LCz+zWfW4pYlsJoUPWTu0+HCFyXb7jErR+P6X73geJFIkMpqC2OmZJvecQd2pha45RJ+vV8oGWLmtYVIX4M1XGSDiGiGqXMnSFN//r5xH/wQZmintfMunRFFDO/T83PsituylKjiVBKbka04cSZ/rF90Nh9n0n7qyziOdfyFP/fwUE2msVpqKgMKp72nhOQXF2opdB+BM8Bm/d96OFeV2k1rZt0pkbvnUZqgSnt1R+tGP0yLLx8bhThR2o5ogM6dYkcHqKZt6VMaIK9vJ/vZJGLKaWx1H6GnDAvVSUxuj3SLtk5edjrL0stuCTZIOwlCm0NnxDg/8uU7bVgFzPHrEhUwwL9Mixh1DIHzeRk96IHySzruw7dRVZIzHr4yMYp1V+o0SiWXdMPNLaT+9hvEZ7Gv5QAtfi3YVRzkxBZIITnSVCdJVdVMhDmyqB9ZN6noE9SKbbl9Lyd6Hs3sN24SQO6mAtoa4fvs973RmO7Zl5/sPMYA1aUOeDPUPYLkftbiMvf+pIeIt2q/PDpb05afexy9cFficNT+pMgv01Pf1Nk0LATJal24nH8GxreWLgDQ7nz0wPul9pEzQGLiTQmGWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39850400004)(396003)(346002)(366004)(376002)(8676002)(4326008)(38100700002)(54906003)(2906002)(83380400001)(52536014)(66476007)(66446008)(66946007)(6916009)(64756008)(316002)(76116006)(5660300002)(66556008)(7416002)(8936002)(9686003)(38070700005)(53546011)(7696005)(6506007)(478600001)(122000001)(55016003)(71200400001)(186003)(33656002)(41300700001)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YnTMJWom4Pg8cqMulTjtlfScfOpjBElsX75KGASWU8KkEdbC9s7nh2CeyIZl?=
 =?us-ascii?Q?UI2on3jUyLdQWlQZWptc6LyFX2dU4XwR8h3ZVqzLy4waCZk9HE8JMC28VWHZ?=
 =?us-ascii?Q?cfRfvpr3XgJqIZ6Ub+HokfOdqJMOLxoigGEScNWP5oS8evdfOukB+b9UWPZ+?=
 =?us-ascii?Q?lpTzdZGxBdeyrnCkG48WnY9XaDNBPaRy1AszNaWNR37warw9CSY5IiI46R9p?=
 =?us-ascii?Q?Ixgqpz1I1ES8sOD8rQ4ktHX6yiV0qfS8j1+UPwJcbpcKjFtFHfDNgDgHqGgm?=
 =?us-ascii?Q?iExc3/7L6Uzsjk1uGIAklzHbkSpwu3BaN4fTYGfeIzND2pI7qZNp2I8SqNBB?=
 =?us-ascii?Q?3vhuaECVUSvGY/2NfMx760Csfvh7Dt6TzTSx9GCb4/FqaXqt5iTkQ9AoUPHn?=
 =?us-ascii?Q?LTHcfBY8+q9Nw9AmOTuHLkrfa53hMLYgRT9R3zZ/i67vyoHIbN2axIZD3J1s?=
 =?us-ascii?Q?jMozO9Pyt/80wdWj8MQHwlzTC7lmpoqrIa84bFGnRRVQ4bm4IvVm14YQVoQF?=
 =?us-ascii?Q?zETu7HsLaSDrbxLClk5TuKnAwaOMruUqMCzENTIIvGHB49EuPepbbj2/ttwB?=
 =?us-ascii?Q?7CwjNjgtSZOqYqK0rQgcN6eHqow9rEomfq8jvfBRj0ALneqAKcTkvjKBGYL2?=
 =?us-ascii?Q?7v27nFl3A0ETRGl+G/lkkliq0JatZVY9gh2czgijqmhiLq8IeJ09etgqp5Fa?=
 =?us-ascii?Q?2kX/fSDyUGHriVIKHtidRJE3COcerrzqNE43UFkbdZoDHaQ2BKTay8DcCxEa?=
 =?us-ascii?Q?/TL0pV4zjyKMUlXNvJan/i9o21EiBCgBvUp3W1D4uJl8K2ywMCBV6OC//B4T?=
 =?us-ascii?Q?fd4T1u69N/fDGxwq697t3bL4TZBi6/YopKfe9Z36KDm19FY+wX6zFdYgK1oW?=
 =?us-ascii?Q?0NsU3/t/Qnn5gdvTVaVHoJpqAhO+COJP3Q1qhpcx6147JTa55jSQCMrIiA6/?=
 =?us-ascii?Q?e99bIjG+xHG29wlYCyQNIRqTJJ3T7rP/poQkduDHqP84Z+My6emD88zE3PhN?=
 =?us-ascii?Q?olUySXcbXxzqOE1prkgX516bjMvPnPJqsxTYfHIMYnz88N4lzakfcqzfmXV1?=
 =?us-ascii?Q?peQl3U/9yR3Hmd3Tm710G8ByyupYhOk4CfjY4z5dRQhYLL4Th08rCxyxy29W?=
 =?us-ascii?Q?AZX4VfYOsRxJDfHzNVVHVbT7CAGVwUY3oqjksyNgD4Vug1jwXpAJ4DliBd6S?=
 =?us-ascii?Q?hGJE1NfuJgGQDRwafVo5q5rN3W31nEqeeUOP6wlCACgJO+Qhlz1DC36giF9C?=
 =?us-ascii?Q?nOe89YZqM0loPKj/P0F7Ezh1yRHoOl48uk3u6/MVoPKTP8WHZL21Vs+qhXix?=
 =?us-ascii?Q?S1Bb6muHe9VPBctXeqR4tGMB0tAiLiZqQtkOGIxBKd3mxSAVevdcIWGhv4lm?=
 =?us-ascii?Q?7eIJnGKYuY0gT2NdKyDGFJVsozuugH0/KOlOKhZj/8ogdsurIU5U8ot5dp6v?=
 =?us-ascii?Q?DGxxXDL9gYvj1nwse7FtBFvbVyotNgAI0CXpZcNOvsUe9Q3ROX4fHUH04Blx?=
 =?us-ascii?Q?pNzG4RVrphYXc5Cnhwrptr/q9Nv5bV9gFhGREN9yEt4hmDL6xIX7XB2f3EMl?=
 =?us-ascii?Q?YeKSZWiTzrxJN37vGWG69Vf0z/PsWfIZAtR0pVyrowXVBk9kGP1FOIYAZl5S?=
 =?us-ascii?Q?Fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e69fb6d-d096-4c22-8c58-08da58f0eeff
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 10:28:25.1154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nTz0u6l5Xa3J9svbuyQW6aem+LiKIjTzJmib25dH0IR7I7whA7o9S8ED8yqNTZHi3vbTf7iivRfv4n5A/zOHZAvhiWGFJiSTv/75DwdAOP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Hangyu Hua <hbh25y@gmail.com>
> Sent: Tuesday, June 28, 2022 3:31 PM
> To: jmaloy@redhat.com; ying.xue@windriver.com; davem@davemloft.net; eduma=
zet@google.com; kuba@kernel.org;
> pabeni@redhat.com; Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
> Cc: netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-=
kernel@vger.kernel.org; Hangyu Hua <hbh25y@gmail.com>
> Subject: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
>=20
> dom_bef is use to cache current domain record only if current domain
> exists. But when current domain does not exist, dom_bef will still be use=
d
> in mon_identify_lost_members. This may lead to an information leak.
>=20
> Fix this by adding a memset before using dom_bef.
>=20
> Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>=20
> v2: remove redundant 'dom_bef.member_cnt =3D 0;'
>=20
>  net/tipc/monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
> index 2f4d23238a7e..03b5d0b65169 100644
> --- a/net/tipc/monitor.c
> +++ b/net/tipc/monitor.c
> @@ -534,7 +534,7 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dl=
en, u32 addr,
>  	state->peer_gen =3D new_gen;
>=20
>  	/* Cache current domain record for later use */
> -	dom_bef.member_cnt =3D 0;
> +	memset(&dom_bef, 0, sizeof(dom_bef));
>  	dom =3D peer->domain;
>  	if (dom)
>  		memcpy(&dom_bef, dom, dom->len);
> --
> 2.25.1
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
