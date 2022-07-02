Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D03A5640A0
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiGBOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGBOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:08:38 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140073.outbound.protection.outlook.com [40.107.14.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D453101FC;
        Sat,  2 Jul 2022 07:08:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqIx2s2F3MkMTozP5FwtIl2qdQpY8YrzPHQu7oh/ZRNZqj4p+ZnC5URDuU/95u5jozhq3B7bDiJ0nA8ybru5mCBZnH9D9D0cG2dVhpLl23DrF9jkbfWW9ClB3ebMu1f/ulsX/YqR5TgsRCBF4m4BuoQdh36kopnhHFHDoE8lhTDhPrj+sGJGN9ctLnGgXaRdKTNDI203c34vDBpHPKN2MV7S0RFb/TOGqujeNydP0R7t+rpPuqZeW9/nahYRjfSxQe19OZBM2QNmYQX9UjMNEizbTbETYuph1IrmLjmsq50pA4lYhu6DoeqNM/iw8AcSdU2M2pkErP+6+BDcKGQ86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9xqrCFudURKRkqjjmcaXMDkcGp/atDxtWWD9nK3xEc=;
 b=GaFN9b7Jm3XXIL1C4GOzf51wnBVjsI+qnTXbALZdqiA1f8sI/lfTJ1xhCAJC1zGwW6V52olMy8USGdbjycrgJwRgImw+He3KkgCMhlV+EOcj+Dr7kBA/zDDVJIboxdaslnVqmCZ36xETTBZKA0xb6Ud7U9dhM/xndp8BVjl1AoFNA27FtBg62SyMYKGGJTA2A4VxOnoftiWokS1bVuUG3pb1RYtMrINxHNnf6a6t6ODglF577JNFclu+Zcuzf4XHUkgDt9qXCe1pYLDHxMhvpDZmamKpScCA2mnSTkYDvz1aR7hbWR6p08kRb6xj2r2wi3jKsouTHstAJ2z7Pfu4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9xqrCFudURKRkqjjmcaXMDkcGp/atDxtWWD9nK3xEc=;
 b=K3YOcPnvkAOiY0hYd897VutoIIEoZEFqLLlQaVPY0S7CC2L4ziF0AHxmNh1MfiwiEgeybK93uPRJERTIS4YBlkTot9plvE++ZNzCBD0WJzcthcjjVjUBWCSS6qcc96md4XnGTYP44NmlOR7GDJ2emxyHJlfKhEyFqEtbCMysFuw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.16; Sat, 2 Jul
 2022 14:08:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 14:08:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/7] net: lan966x: Split
 lan966x_fdb_event_work
Thread-Topic: [PATCH net-next v3 2/7] net: lan966x: Split
 lan966x_fdb_event_work
Thread-Index: AQHYjYwYTy88uj+oG0ahH/a0+KK7G61rH1YA
Date:   Sat, 2 Jul 2022 14:08:34 +0000
Message-ID: <20220702140834.gyqmtmaru6ecdamb@skbuf>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
 <20220701205227.1337160-3-horatiu.vultur@microchip.com>
In-Reply-To: <20220701205227.1337160-3-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18935c0a-4c9f-4893-51ec-08da5c345a54
x-ms-traffictypediagnostic: AM6PR04MB6088:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U31PgXgqSc/yeHxwrft07hkINNNKce4xH3qOYO+kw1dRWcYdvLLJy40L4SuAN9lWbFAMmvam+xRujADX/9f77chKTkO6MR0k+N5ecKjJFDpIonDLu5GZkhJuB1P6mJxhzApf3Ct2CzpHXRzrGrRLEvqklV+DsdrQHZ2N+0NbNVxpmcfXyUjtyw8qBxzEf7epyMpiqhmSmxOgti/uIDm36Bq4VHrrpiGHoqIFpTwox1HDs6E3dwsAFAV116NqN4eAgfEZH6inB0rYBiG+b8+6FAvOunY6VxOjcPJCpw8aSyWkd2DsoD/jsFp1X+hO9PgomwkGPUnnjCqqASqQIpMUIaiLfHggwcAJSmhz62zNKgdzO4qjtQL54p8Kl6uS1GSBKGJNxsTmzYQrPkbBHhrHkWy93atvf4UqKxYQ4trucKj7AkyQjW6tKWsRZvDbPjLYtxrVENGrWacjDvnbUwWMNGA65g4fw6+HQEfkTgcRDiMWscta52Dcnbrw9P2kNA1s/RnY72cEDtEXPdrXZClHPzF+B+cLnR4bGxaUbnDTGVi7fcHjG5sTG5t1Hqs16XeiDYwekhmVTmb+cM3M30XIiBffoIH3/Xt6+9hSPRIZZRsZ5aLnain7XldJGdUnqHszUHf5/8hQlHQHMNw4oxT8F5tKazMk2Vp/F4uiyumzDjdTe/C0Z+NYyRVDgt2scNYelCvFhEBoyNIYY11EaDx4/hDbJjclboMYT3womXtGIXI+vDdfNZGLdZvxtTou0Yq7BQYDgEKwnZDUeEuHBAbYhPtcfA97wYPs7cewk1I96w+HeRBuCabDbptqhM6AX7lV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(83380400001)(122000001)(316002)(8936002)(38070700005)(478600001)(6486002)(1076003)(2906002)(9686003)(44832011)(5660300002)(186003)(6512007)(66946007)(26005)(91956017)(66446008)(8676002)(66556008)(76116006)(64756008)(4326008)(33716001)(86362001)(41300700001)(38100700002)(71200400001)(6916009)(66476007)(54906003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KHpQQiJr1IbJzvUQtshDlJ/QiooMQAkyoA2Bt4pyc3rYA271uD/5ShGg4RRm?=
 =?us-ascii?Q?Rd34OJUp/3ckrhdXpNUAfvnKoXG36RHIYMYK2eDBESbxpZ7L3okQiO7BMBcM?=
 =?us-ascii?Q?nd6MJ/iWgEFkIF4H5ogczTY8lA4TN8gwvUx4XUx76UBx7gXeHfDak3Ih0f52?=
 =?us-ascii?Q?Rvr+lQwNCOeyYfw3dfnLgqXs4G9r283lVC4DJQxrWP7KHAihlv1syb/Jf/Ou?=
 =?us-ascii?Q?iAs/BG6GrXbg1DSD/80ZPzpts/Tn3HkxST0ZHIPOnRlXE7xsBd8A7TuYdvIA?=
 =?us-ascii?Q?PS2JTh6trFNXBbE60mbtmt1Zc7sQuJoQ4hbAVOLFJxjWCHcn4os7E32Ov0Hs?=
 =?us-ascii?Q?fF2bWt3BeIOcpYy6GuNQW5RPOuqHWCP60fJBNJzdUIT8Fo6NiCGUd62Rv8eH?=
 =?us-ascii?Q?VT9ZdZLBRe4CIeRgnV1UReF3dJXtPUJFaqSuGk/zMolGCCQH6LWH5jYqTORL?=
 =?us-ascii?Q?XCkerM8HkCpHYEXevgl9gpIO6n63WHhTkkL+oEHVfagSJmbnRNWm79dXdFlZ?=
 =?us-ascii?Q?52dAqo4DpeEXL+w4G0IYWaJOYHEOnxoqeVOLFTQ5qRqFgrzfmGP7RaakXyk3?=
 =?us-ascii?Q?cIqgghet5Jhpeq6X7I1QkZe3kCHf9pBQFS7iHr6ALWmA1xQPRyO4Y4RbcpMl?=
 =?us-ascii?Q?TYUdZCBtacHhp8sSe8NSqzuKC7kMROGfa76W0nnahycs1m5WfNqdND5dN6Lm?=
 =?us-ascii?Q?XtLAr3MNc5j/udoiBkGpCURKUGEcjjtQ3LU61iB4oH8b92U9CoaH5Q9TEHuM?=
 =?us-ascii?Q?BLjRY2Q3xfDKASUf7zZ1vDOkovy39HygELDpsH+t5NyMQ6nRgFyb/u9nFTTi?=
 =?us-ascii?Q?QZ9psow9w72IjC69gFh3QIankttOONHdb/ac8wtbA8NWI+Lozsz0cFX2g2P/?=
 =?us-ascii?Q?qqdtDtqkPRoo7OSN2fV+tgEPQH5KCRIV6coBZs/eJi/Phv8Ea3X+piBSPuST?=
 =?us-ascii?Q?IzOVfDEu6CjZAIXPTnYg228+CVrmzzx7liCwf5/GKaK21tCUixtKXLpT2AFi?=
 =?us-ascii?Q?PBwfKsw9bvPMpD5Rj/4TtB5gylDh4nOMJUOEX7YQYkTwPRsEyOyD5J2rOCjP?=
 =?us-ascii?Q?kfA3OuAe1rmBSt3m3sTPjlnzynA8Dalc7iZ2pog4+BXFEjOP6iNUa4aTgyXI?=
 =?us-ascii?Q?c9KsgQKDIntceWgw5G1Ip7/fwT9i7eepKum4+vbU4R1TmSC0cyJWhOeODV6P?=
 =?us-ascii?Q?KcXqWWEq4U5b7EtggDl0AodxGZulG0ymJ71CI0VIPFnlMmwIcSl5asr2XXUn?=
 =?us-ascii?Q?a1WAsZNfa9KUoqMjHWOgMuQuyQvvDJzWtuS8ZhRDGjsl70xbIxVNJCzGLgsq?=
 =?us-ascii?Q?a6JLkHkU7Q2Lwu2OzHv93CKdK1kOulVa5UrpQ96MiDk4Nof9x2TaiM8HoqWk?=
 =?us-ascii?Q?ioJYoC+LQDqnm7E9fWOAPwIU0SZVBc+55OrZherM8jOEt+APOliJVx+xkkJx?=
 =?us-ascii?Q?vfwt1kOayPGM4IGV8145kobU658wXotiITOj7u1CEcXez6xyUE5Wc8WQ5oX/?=
 =?us-ascii?Q?Wi3+WBkqNw5hPJixqqIjginmj1z4Jtmr99NA7TNiJbP5+JelUSWcurhggQm7?=
 =?us-ascii?Q?mHru9Fb31JadAqZzoQBBSBCIa0vt+M7lK3xnkDug0i+xNQ1EE4gavS1Awj9t?=
 =?us-ascii?Q?0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67980FCAD59BFB4D88BD9FE654C80DCE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18935c0a-4c9f-4893-51ec-08da5c345a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 14:08:34.9720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kG+KFMBFWluGVTgE4qxjXhrVotgGnNikk8kqeeZsezFdUgtPinC43NMmasfxeVDJpP4oBnRWEKXe2+HurMUOEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:52:22PM +0200, Horatiu Vultur wrote:
> Split the function lan966x_fdb_event_work. One case for when the
> orig_dev is a bridge and one case when orig_dev is lan966x port.
> This is preparation for lag support. There is no functional change.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

> -static void lan966x_fdb_event_work(struct work_struct *work)
> +void lan966x_fdb_flush_workqueue(struct lan966x *lan966x)
> +{
> +	flush_workqueue(lan966x->fdb_work);
> +}
> +

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index df2bee678559..d9fc6a9a3da1 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -320,9 +320,10 @@ static int lan966x_port_prechangeupper(struct net_de=
vice *dev,
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
> =20
> -	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> -		switchdev_bridge_port_unoffload(port->dev, port,
> -						NULL, NULL);
> +	if (netif_is_bridge_master(info->upper_dev) && !info->linking) {
> +		switchdev_bridge_port_unoffload(port->dev, port, NULL, NULL);
> +		lan966x_fdb_flush_workqueue(port->lan966x);
> +	}

Very curious as to why you decided to stuff this change in here.
There was no functional change in v2, now there is. And it's a change
you might need to come back to later (probably sooner than you'd like),
since the flushing of the workqueue is susceptible to causing deadlocks
if done improperly - let's see how you blame a commit that was only
supposed to move code, in that case ;)

The deadlock that I'm talking about comes from the fact that
lan966x_port_prechangeupper() runs with rtnl_lock() held. So the code of
the flushed workqueue item must not hold rtnl_lock(), or any other lock
that is blocked by the rtnl_lock(). Otherwise, the flushing will wait
for a workqueue item to complete, that in turn waits to acquire the
rtnl_lock, which is held by the thread waiting the workqueue to complete.

Analyzing your code, lan966x_mac_notifiers() takes rtnl_lock().
That is taken from threaded interrupt context - lan966x_mac_irq_process(),
but is a sub-lock of spin_lock(&lan966x->mac_lock).

There are 2 problems with that already: rtnl_lock() is a mutex =3D> can
sleep, but &lan966x->mac_lock is a spin lock =3D> is atomic. You can't
take rtnl_lock() from atomic context. Lockdep and/or CONFIG_DEBUG_ATOMIC_SL=
EEP
will tell you so much.

The second problem is the lock ordering inversion that this causes.
There exists a threaded IRQ which takes the locks in the order mac_lock
-> rtnl_lock, and there exists this new fdb_flush_workqueue which takes
the locks in the order rtnl_lock -> mac_lock. If they run at the same
time, kaboom. Again, lockdep will tell you as much.

I'm sorry, but you need to solve the existing locking problems with the
code first.

> =20
>  	return NOTIFY_DONE;
>  }
> --=20
> 2.33.0
>=
