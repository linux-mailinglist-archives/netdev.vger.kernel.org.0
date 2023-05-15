Return-Path: <netdev+bounces-2593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F647029A8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5048A1C20A77
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F50DC15A;
	Mon, 15 May 2023 09:55:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE9883A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:55:46 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C569F1;
	Mon, 15 May 2023 02:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684144542; x=1715680542;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0J8sFcUu8h9XepBpDuS0updXIYHGLqik4q01WLoIsps=;
  b=1gHEn5pyFKaZsC6vcT9jIkzGdmHFlwLQaarGkmytVv8cMu7dRKxTUTaC
   IY5Iki4BbLWTaOXCtssVlmwIFPNSwfCTfSlORDXSVK+d5yBb5h4wr6Ssq
   U6KRkRsNjT4zmFxWi5FW9HrKVoWy/Y5d9fkSLpRsYwxMwkToNfZdstlQa
   XwO2X+DFA6ZOa5t67rMxJjDBCpDU9eHjurDdoCz14xJBYqALk2izEHfgi
   AlKTNr6j+ABsncy+c+Wief3VLb+HrjggbFH/lTNFT/SnzNyLjOBbS5lpQ
   9pb/Z63J+B1Q/Htxt+8+lTPirufzLGp/70Uf9uejb8Bjsu+AH9WQEM8QK
   A==;
X-IronPort-AV: E=Sophos;i="5.99,276,1677567600"; 
   d="scan'208";a="213318915"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 May 2023 02:55:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 15 May 2023 02:55:41 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 15 May 2023 02:55:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJzw/wuUJ0MD2DWGGeQLZkBU5bENtBEW2jYFCjKVb55EnbU/p2Rttg/GT2MiXbNy2HPHOPFR1+SxH0N72vlO42CRe+qIYnHNPpK0dfoSopAN0pxDFgZZvSk2+gi6cj9vu4d5P7KJ9/PMdBEEMfKkbQYfAqJ1/rfDnOX1xUNy7zlJn0elMojz8tZbRgPBbZjJFDtAbVaQeciM/wEa3EoAdRltvJ/oAQPLCmOH4JPlZPPBu4WjPZFkVa45v2lunPwjeGFKEljHxUL8GhfcOm4QtoHkoaplZ2T1h3UEqSxVoK0/lk7EDnxFWtURX1v/4dW9ZEMpGXCwTwO28OaXt9PQvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fZSa10Ns0WYXciEYYvpbYmrCoExiF3AM/hM3Vmc6hk=;
 b=UPJg69RGY/bhSFEDpikB0ropDEghi1/sZRaWxA8+2tjJGBfGlnyhhsiizny4ztc3kdrCbKut2qYb/cAkAC1g+gDZf5dZX3ljiqiad5NoyzoK9ljrnxiSqHzEZ+r9VV8aE3Cs9uxEeERfrvhaPXoiyp8uDbfO/SWJPq11JJOtE9l1t8sVHfOdG1KM5SS4CDhkG1VlctyimW8Ll4i4Lbjb4Y1OYbjRooOW+XHj2Uv6qskEtyDOfTSoXrBE30cXpEOraIHh0lRKzAVJY2taZqUePu4rRrTY4wTZv0SMyTuCEIbxlIYEpVlOxxzGzMsegk2+is+WdcPU2yiZur6wCEI1gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fZSa10Ns0WYXciEYYvpbYmrCoExiF3AM/hM3Vmc6hk=;
 b=auTH/JbmN7AAAaCzdPAU7WGyOeHsN2mdGi4qUzcMpy4pMUgnUWyTKDzjCz/tja1MAdi5F7mOFj5k7cmdvxVUYxWrerJ/eaCu2ztQSFgy7uQ7k2ZcWeCbFKQM7ZYefhW5oAaJU2IefbBB1e09o7/ItISBClQgN9F3XpN7w/RUcDU=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DS0PR11MB6397.namprd11.prod.outlook.com (2603:10b6:8:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Mon, 15 May
 2023 09:55:38 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 09:55:38 +0000
From: <Daniel.Machon@microchip.com>
To: <Horatiu.Vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 0/7] net: lan966x: Add support for PCP, DEI, DSCP
Thread-Topic: [PATCH net-next 0/7] net: lan966x: Add support for PCP, DEI,
 DSCP
Thread-Index: AQHZhqBNX84lQm0AXUiEdanfIVPlcK9bGYuA
Date: Mon, 15 May 2023 09:55:38 +0000
Message-ID: <ZGIBmSLEokFGvgkM@DEN-LT-70577>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DS0PR11MB6397:EE_
x-ms-office365-filtering-correlation-id: f8f47638-3864-4880-065e-08db552a8973
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HtddXQ37+83Fr2+jgGExTnybATzZuojnp1/CB5hIzZ1LV2ag3k4WbQoIiknlghiex7KPdZ1bfjE+4ZYdLpgOuIcPvP4r7xbh589XqrUZB6/4Q38Yvq5rqkIxQfZRubpCmLhVBXLNWJkyCBoANG62dPDvtW2j3AQT5hsPJXNJ7TulhzFtB748G8raeD/obVi/GRTa4SSUkuX4bXtWtj9k2iHkPvZNfOdYg91YvejIQCP6XOU90RAy3kEO9NyyyGCHpt7pIiWN+M8JIoHTGgo7GnATBMfVTCzD9+9UywSDzopUN096jg3fGy/FPAbnqecadfpzkSFjpPQ6SCjuaNek4rpo5M2rkHsd+YSPdht5J3586fIyr1OdiF6k+DnkFPargyW2c9ap7gOrD19CAwBD0PLEPF966iNMXLcDWzIAGYQuV3dM4QESY7mlI7O6RXgqBtnP4c6CdHMnq+vItXQpmL1Zdp9KsKpOemkqMikIF6cPthvov0iCdojgHy07GrC8QD5uQ6pCPi0qLdiOcTPDHiy7lKQt2RgxYl599T/t2B1XrCibzFnJok4x0o1H7ACLSFRAZc4HfqCB48jVS2kLnpnFjaJFSUmPNNB5CQxCBSuK25CGbVbbCcwcz/zMFqYP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199021)(9686003)(6512007)(6506007)(186003)(478600001)(107886003)(26005)(83380400001)(8676002)(6862004)(91956017)(6486002)(71200400001)(5660300002)(86362001)(122000001)(316002)(38070700005)(38100700002)(8936002)(41300700001)(6636002)(66556008)(64756008)(4326008)(76116006)(66946007)(2906002)(66476007)(33716001)(66446008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ujUzuTlfzFXM8VdFFqUENMZki0P94xusiR3YOtAXCsySeTBDFqV/K1yDYY0X?=
 =?us-ascii?Q?8XBijQUQJnyNWvAWry62e6+wu+VC176aJESG9QQ5nlLVxPs62Lb2k+pGH8OU?=
 =?us-ascii?Q?txNPwMRPxxx8/9V8v7Ltll78PETtH9V0Z4LaWJq6DPUxNN4ECFaO8u5jogGr?=
 =?us-ascii?Q?a6qb8RvYlT1VY64gAMquptdL++j5jvCZzVOyD4qz3B2vegGIuAYU5/B65fsY?=
 =?us-ascii?Q?Nv+QZ4Wx2AuqRkRe107Noec7q1NfeH/IEf4eoT2e+XTXjHFtKR8Aw5RjVDLG?=
 =?us-ascii?Q?LV+CIZeveBhLNf94JVcRKFK6BGwyyzJt814rSuL0g1wB23f+N2nTMoFAPxEJ?=
 =?us-ascii?Q?jcvoRjZFSC/IVmFTCmCOEML9kcwTJvIFKIvKdbvkFkIYEifIgjo7/PwgeP9/?=
 =?us-ascii?Q?7gYeGywOj6XQPyJEj4ScrkturApx3og/7Eo84aQFM02TE0NdZm56/Tt6FgMb?=
 =?us-ascii?Q?BssCFctxhhesutqxKlIQr+FA0VneR68UB4Mgr2AJAIxL45KXQWQyB7MQvxrw?=
 =?us-ascii?Q?7MlBs+P9d2N3pYLy4JJezuDAB0KzyGNLEpsjB71CIJbPfqD0VQb/GSUJtQxN?=
 =?us-ascii?Q?+Qs0o39SSSHyMwkCh9V6BQoeHiZjNNHFQvbcQwsTr40h0RNVgwaP8R5f4VpO?=
 =?us-ascii?Q?e/u6mHKLWh3foXSZvVAzTmINJlcK8+V9J+Xj8OoST965EWAUxC7WvWBm79Td?=
 =?us-ascii?Q?mZh4Gytt00UZDVtIHGQzQDTPdIu0KXqUqicTgROXPc7ECRT5wjoYzTbymAyd?=
 =?us-ascii?Q?nxmmwxg1SsjRv/3eO04MN9ZEY8htU9OGvIXHW/cEu23wtOD03LfctRG5Y5OW?=
 =?us-ascii?Q?GKYuZyEqS/i7nNBUsOHvQDHhufPe406J4xCuaMV0D/ZNlOBgajwkjKs92SEj?=
 =?us-ascii?Q?Zdbf6BNsRZrCbS6qnhNNo89FeKvQwreCkNGHKfDsBDY1r7WyIC4G7mhBOMYz?=
 =?us-ascii?Q?MrBXXXTE8V8haq//0hWf4FFt17a3xsyGqcadOy0YSajfEK1wtec3Lf+aCkSt?=
 =?us-ascii?Q?GQc159R+FyKmBuaujhfKdiF6OcibG5fpvj6K46T9Kr5PHodzxRtT2j+JoqHG?=
 =?us-ascii?Q?PtzzA+TOGLefhyUNEJ8cQjCJnrEtLzw14sw4Ah1xEfUtqefmLhgD5mW8r2u+?=
 =?us-ascii?Q?CUiVyGPesz7/h8NFILTIZN9Ef524vCED8fISyALxE8VpHzyTVTK9U2A9M0RE?=
 =?us-ascii?Q?Ene77887ku1DgsveMDZGNdNodwlOxfr+3HVSDsgZqAJ8TN5GwdpBVbcp06/R?=
 =?us-ascii?Q?I09v0Fzav5KlNY0+JSC3eHz2qFsa+Ay8GUgtVJzdHswcyk9/yo4LuHwwZ3Hv?=
 =?us-ascii?Q?nhcuvDxhheCeYlV+yndK0rBRjvcgohymLCClWouy+525KD1ktzxSwn46CXxY?=
 =?us-ascii?Q?gXQFGNBSmbDXzozJM4o8eOPx0gQbR0Bh5IhaVv04YCxciXy31is9ahVpk1tL?=
 =?us-ascii?Q?cjvSqJP0N0JtoaQIuL/X4sNXf55WMZZRYNsOGVw8JIz2kKEMs703QmmRe0pa?=
 =?us-ascii?Q?+jFHATtfDJgz1eHlZpJ76lnbjwAARl6HfhtCeajp3ZX9FE2opsrCRmCOfkTb?=
 =?us-ascii?Q?Nep9UN2cPguRt2Tn8HGgssiG4xCRQ6QODgS48Gh6m7FsXGggzbAgoJyR4u+o?=
 =?us-ascii?Q?VA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F444415A4A82824EA9A89EB3D11B5199@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f47638-3864-4880-065e-08db552a8973
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 09:55:38.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uT8l+VPffit/yf9979omwyVSqBes2Wg/Fn0UL+mTbvghlQKP317JI2/LsLtVY7g8tzXVBm5Aujt8W70khgYCX0XNwC0G7s1V9MZ6hYGOsps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6397
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> This patch series extends lan966x to offload to the hardware the
> following features:
> - PCP: this configuration is per port both at ingress and egress.
> - App trust: which allows to specify a trust order of app selectors.
>   This can be PCP or DSCP or DSCP/PCP.
> - default priority
> - DSCP: this configuration is shared between the ports both at ingress
>   and egress.
>=20
> Horatiu Vultur (7):
>   net: lan966x: Add registers to configure PCP, DEI, DSCP
>   net: lan966x: Add support for offloading pcp table
>   net: lan966x: Add support for apptrust
>   net: lan966x: Add support for offloading dscp table
>   net: lan966x: Add support for offloading default prio
>   net: lan966x: Add support for PCP rewrite
>   net: lan966x: Add support for DSCP rewrite
>=20
>  .../net/ethernet/microchip/lan966x/Kconfig    |  11 +
>  .../net/ethernet/microchip/lan966x/Makefile   |   1 +
>  .../ethernet/microchip/lan966x/lan966x_dcb.c  | 366 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
>  .../ethernet/microchip/lan966x/lan966x_main.h |  57 +++
>  .../ethernet/microchip/lan966x/lan966x_port.c | 149 +++++++
>  .../ethernet/microchip/lan966x/lan966x_regs.h | 132 +++++++
>  7 files changed, 718 insertions(+)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
>=20
> --=20
> 2.38.0
>

Hi Horatiu,

LGTM. For the entire series:

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>=

