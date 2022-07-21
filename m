Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9157CB40
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiGUND4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGUNDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:03:15 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2085.outbound.protection.outlook.com [40.107.21.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B397078DDA;
        Thu, 21 Jul 2022 06:03:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsTUjo7mh8TrIaAOntec05EV78T49ltFUbitBVSpAnhYQ2R9RiI0gpTVEzXUm3erJ/lMB3vA1GAxkIkhykQ5LZWSma6rZl3U/SFtPFx8VIJfC6N/rcJt9TTvAIbdUamEk1zL+W10ZJOLxK5wWsywIhOG+ZtynE4zeJ53JfwmHQ2osoc6OJeDDIrv8DbFMwgxLXPEHIIIYZv4npcNclpyA7qPSiKsCoOFIqilwv9ri/mg8xCi/+ZqgZZYpy2OMjEBylVcutl7T+dE+y5EAF9W+JaYJb6ydhfzUjILkKaIrlC92HzNbjkRGhPGWARzbro4GxAur/y6hwDKbiB8DSSAaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgU6NgXmdHu4vcgXVx+yroVwrLqv9Bqyr60o2/DCYec=;
 b=HAaXtbVZE+qI/vllkLPdrQdyxHR7we62d4WKxtrfiY2ERDdkzANVhGglkGfAPy0ok/Y/p+jjqT3U9uF5WjU+qVgkK/u3p+FL9C0MUSaBAKboUrDNIxLXU+rsu+tek5SsdDp3fLHRerwyZD+Vta6KpRZYI6ZvDWUnmBtzbSzoVI5hemjn5xo2gJTOXRkGxVrASYxMHPGRtNsL2TfB8K5Bm1qpHm5YDuapcgUmNdS6r+TEd3F6zW5fshTVLfMH032BRzhhtI6iVCkJdFOxDYd4gpaxfOwnefuHapRp+2rm4qET03u5czs4E2jvUpFk+lP0SO+Jr2xsMDMrAoodui2c5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgU6NgXmdHu4vcgXVx+yroVwrLqv9Bqyr60o2/DCYec=;
 b=rizZfZOJQh9XKlRju/J5PJZ/SKqANEx4dxHDbDswbTdPzI+z4NJcBKahD+mgx/tEx0tOt7xpyy7MPHGfvJlGLFxz1wtUfOG+ne8FTVaeuEQlxyoZ+RtMRPL/ysXZRwXeaJC/uR0UNRyoqw5QhQgux+tCBGEuwfPS4Amc8kokH7I=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6814.eurprd04.prod.outlook.com (2603:10a6:803:138::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:03:09 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:03:09 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 28/47] net: fman: Remove internal_phy_node
 from params
Thread-Topic: [PATCH net-next v3 28/47] net: fman: Remove internal_phy_node
 from params
Thread-Index: AQHYmJcPi8XPyNKQZkirG9TQuhmMgK2I0sxQ
Date:   Thu, 21 Jul 2022 13:03:09 +0000
Message-ID: <VI1PR04MB580746342360761B06D85E5DF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-29-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-29-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2932933d-296e-4806-1bd3-08da6b195c7f
x-ms-traffictypediagnostic: VI1PR04MB6814:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RVwXFQd1qwO3BerAQ+zDCqNpd2g8XIDxnx89kQkGo0ZjmnwkOQ4H09ZeE8G3NtKXDVxnGZC+RFx0XRpANKusBzPxPajVSzfoLvdKjfBa61X8S1G5ZWnl2hr+nWO0W/9PBO5TgWIYipRdWCIbNK4AXwepwNNOXZ7UMk2gkpxo5NSJrlgsgxEi+3r9VlChWROkyyaNanZQaNNQm3Sg6S3WJ/BrPxOh2uxmh8zXfqxx2NWVSPl/pnUq2LZDhbjzCOPextahNNuBU6ssTZg93mCz1tMhprYs0nP2tmPlDx7mgtzoiemI963FVwJWN19D21zbLrikfIcLsU8U+iT0hT00rXDw2id1pWS+MqtBj6RvvQrTARJ9BgaLUYzQTSCvJIWC38DpKzxO4cpQ+ZhN8EVx0BLGJGypYWkbZr2bovuMAo0/bXVbYC+9oteuTc6qpu44tKa53J/jer/pcVqhfnmzv0ahE3/ywSmnIulPUw5DHW5GyRLGCz37deQMO5Cw88gD+F8Z9sYFEC1y9ll4xIOGlI7MxNlQf4lkvRhPMzcE7/ZpTkrPQy76WRoZN4ZWgJ4K4uYDbPW2ViD4yqUiWUFYK/bwQ391oDrP5L13nidPTvSqOFqhYZSkdjBwiSVMzzp8xPcFFreMXXekvqj6avJ9Od4fY+4cpTekgAmq6O80naVPG6lBoY433lTuyxpfC7S28tCoyR3BgWY5mDAwfi4Vbrp1jzv7b+IGWwmtl031BmafrMwO7/a7iDmh2nIOOjz9Jg26/q4zwRQn3EQmFI/Os5v2gU7IJxxYYeC3sRlyhic8/genKJ4pVdAYBEVhYQqC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(71200400001)(6506007)(7696005)(41300700001)(8676002)(4326008)(2906002)(55016003)(64756008)(478600001)(66446008)(66556008)(66476007)(33656002)(316002)(54906003)(66946007)(110136005)(76116006)(38070700005)(86362001)(186003)(122000001)(53546011)(83380400001)(26005)(55236004)(9686003)(4744005)(52536014)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cuA8rDg483c2IigEtYBTQJkcOYgPObovecWECLD/bLdmhwit8Lv/Metpu+ui?=
 =?us-ascii?Q?CoRSIkH7j0WnFu1XNgf10jU5HGRx9qyc4B3qLDpkQDy6VfRN6+g32TSU1k/w?=
 =?us-ascii?Q?Ye8x/jJ71c2Rig1dtCyfqBYYyw1utjvebbDoqwXLanY0PyyNx3m3wTzp/jRY?=
 =?us-ascii?Q?H/9qhoir0e4VtTAhsAWSZhW2AHLG+lyEDlOCagnSHWhVkrqjlFNm5JW8snlS?=
 =?us-ascii?Q?p9vZCU8MWA/MD33ny1UBpTqoZ7hUxTmQU+1hXpsHZwBhF9bWO5UrFdLGQeOl?=
 =?us-ascii?Q?tmfrsU4a9VChzWbc3UXn2EiYDo2A/HjaUyd/8u3IbY71DEWy7wkWBoNmj0vA?=
 =?us-ascii?Q?kpNYmlIJBtmL9qAhfmrXC93Yui1Qrw1Kaytf3KPPCYfa1qCDWFXqrolMG0KD?=
 =?us-ascii?Q?4P3ZTT/SBWywDi49af/Me6i3oW60lvfIqS9zdxNYWFJZguPQt+CaN8Xnfq4y?=
 =?us-ascii?Q?xerPN9h6OxUX4CzWCK2SjgHsxdGqhb8uBPE+s/Lq3cqIn+IvvTk58S5aTk/h?=
 =?us-ascii?Q?cQzbmfTHQNRw1tzjSFtsoQQy//7CxenzEAZl8dfIf/lcEqtn+cDqaEp0zHSy?=
 =?us-ascii?Q?QeMnQQVxwme+kOqkfi3UvtxhFEmpf93yDv+uotTuoOOEazdC6bac6GmiY3Zr?=
 =?us-ascii?Q?ggwQ8n5LSCxyzEl6kMQm8x+bsIIieYFzbUhoVWjVHGJstQ/eGYUzcc3m3rnl?=
 =?us-ascii?Q?PQymbluQ4fDNqLnvZElSDx9rOnYQYJLiy5qOxeEvWnykMOIdNbtx8kFO/vbZ?=
 =?us-ascii?Q?DzG2YLCG/dCTxQfBsy8n3k8F7TIU7o8XgGy8dT2qhkrCpjBWzE3nLzrIOt5V?=
 =?us-ascii?Q?eC6xSpQtzKXu3lyqA+1qoGZLG51C0qfIuBDAd3kyObZ/oSUP7rh2tJDnl2dL?=
 =?us-ascii?Q?CbnZsPDyQBvjrM15XKQv9Ze1XDQsNaO3l/LpyoXSgzySwVNYTR/CPGrVDETi?=
 =?us-ascii?Q?n1NIzWvjxsVpChvkz+F7RoJW/fIBbqPqW1lKvKHNhSpE54eZ6ub12YpGZgo+?=
 =?us-ascii?Q?XMUndHDJxQSI0TAP8c4jLHiHeJH3Ls55fEm/oCXkuwxYQEEAuKcUt4TPq8kw?=
 =?us-ascii?Q?0VzwMreo8YcOfelIVVjsQBWMB6kXA9IICsN0iMIOHqE5QA7OU942r0rnV5Ih?=
 =?us-ascii?Q?v99XpXUaAgx2fvPzfsh2mM2wbfoFPx9n9fxdaIknSiW5lXzHUogBerNK0QrX?=
 =?us-ascii?Q?IOXgKwD15ODeSkQUhxAPx+n8S7/+lcLDJDku/G+2SfDIJ8jp7XO420R/XlT+?=
 =?us-ascii?Q?8U5oV+dbIPfKcf7KNM3LtUUplGsf634L9hLu8NqMW80nls7Dn0ZIX1396Lx7?=
 =?us-ascii?Q?KJe5QbG1TtZKXxztnOyiv6tqjjeac0ftW9Nt3dNml1GwDysPrgKc2C8kOHlG?=
 =?us-ascii?Q?FV/Q2BVO9Td5FTLMeo8gHTQbVIEyF4Y+vj/Nc3nYSTpDELyIiUaoTAuhgkNG?=
 =?us-ascii?Q?3u3R6977cLBth3kb4fRmU0YJJVhpnW2uEvx0X8/iPI0jQV+7lOGHUEfGFdwj?=
 =?us-ascii?Q?XHpwYkmAtUiTgYq9QA43ixKy8clHdimxnMfU9pXCIR+5R/GS0MTE+GTvTtFH?=
 =?us-ascii?Q?PUZX8lwPeJHeZFIaqTi75B+XuEOIbW3NLERNi7bA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2932933d-296e-4806-1bd3-08da6b195c7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:03:09.5910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykNqjw1qlwzmFKaL1kStgfnLq+1s6jm0X33VemwyB+w7g7dIgSynSfjojYLi/m4gCudDkoEP4zEPZ1pJaS+R2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6814
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 28/47] net: fman: Remove internal_phy_node
> from params
>=20
> This member was used to pass the phy node between mac_probe and the
> mac-specific initialization function. But now that the phy node is
> gotten in the initialization function, this parameter does not serve a
> purpose. Remove it, and do the grabbing of the node/grabbing of the phy
> in the same place.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
