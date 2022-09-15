Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98F65B985A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiIOJ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiIOJzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:55:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A94F13F56
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:51:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQYjuvCRzJyN6f0U5H1EUMPuZ6Hbhethx1owRUjEJT9LzlYZo+DWnEYnVV/y3b3WewkgdAMDOXFYp5cNy/MSeMAPsN0jzV4MUQGJ2pXBIjjMkG9R4EwFCw1L6ocYf6kZRgIDgUL2AHzw1Q3guNNHJv2s8cu/O4IGa6c3/KHoJJsw7kols8bBb5ap6WUOoLcn7Mqp2Yu+f0fTB28atnb+hm9z0b9PCGWEIcCGEutqKovjMAYOK1XoCeeN5sd6VWs4n9ZOlPZmvnE6E5olfRlPcRr8zQo+2rEs0m20hNj/VcKI8fyYI/P1j/I953Khy89wUrTnOe1n7Y7+/o0NFUTtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyk0X2OMaZdtxzpdHwNhgnqdupKeBrWawXEnQce+x0g=;
 b=h8KQMh93XYmkaGN6B0KQUSDfxXAM9AZUQ11aAAG/1X/HIW/RA7NAx+T/JEKjBKOSJNfvSROLP1S+zlu/xI1OuovmyiLfHoD2yuFZwoB87dy0a6Ob+JU3AGbx1bwBgTlisXkvOqfmGB4mZ4XpxqoMZd+Tu2qfpHmA2fiO2iWApBZ7kvBJeJiB4PLlt9a4oIhb6IcE5tNri7rH2ajEiPJ7GkRiMcvF4d3mgre+z+nF8oIp+nNhyG+fvWIcZnydUsVuJzp0NrwwZi7NS5ktIs4XynoJjQdwoP+4tq0ef9PkVKiel6esp3arK4I9tENGMK5z9CMbE5ef14m9M8aPK2G7DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyk0X2OMaZdtxzpdHwNhgnqdupKeBrWawXEnQce+x0g=;
 b=I15FyTpbRr7xxU30r7geFLMtJXEWBVNE0R+rqMDiV64OHVIIQHFal1PxjemLV0WZe/nGDMzlKXuOphJGUjynRX6Oq0PU9/4B2iUQNx4MLuqc7HsHKIJoKWYXGSIYC2qwVpkghE8xWT9NWf9HGdnvmq/PabpxkLo+EkrDrQwQ5Kg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7268.eurprd04.prod.outlook.com (2603:10a6:20b:1de::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 09:51:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 09:51:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH v2 net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYyOhrDBFQUt8lrUmd16tG5itDla3gP7aA
Date:   Thu, 15 Sep 2022 09:51:46 +0000
Message-ID: <20220915095145.jbqchpfiu7hyzk6a@skbuf>
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <20220915095757.2861822-3-daniel.machon@microchip.com>
In-Reply-To: <20220915095757.2861822-3-daniel.machon@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM8PR04MB7268:EE_
x-ms-office365-filtering-correlation-id: 9dd0048f-8678-43e4-111d-08da96ffe71a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SgaAZxJ9QvaF6DvmFHCzy2eB7Vtu+cYM2W9hahH3WjDT+vn9JB4yZ9DSSj5hBSkO9i6ft0MEEsFhlE9SFh8R+DaF5YqbmUWgmJtLBXHCnzHqQc97nhYaqDd4y+0Fs9XzbjrgxepJIr7dOgDYTbN3nYO/G5Y7VptGE8rCDlDuuLDW5iz734f65Pjptwzlf8H2mpXJlylSZTdlHQWZYSF4zb8sy24SsqoSJQ4qj3MauBOqpDxj1AtQtIs3ZPgLwDGKr/cRkMMeYeJo6xagN1DW/Avy2+0N7FOh0nmKCfzggrt95RpwBAnUvP4SzGIosTgZ/RBJLpvQfL0NOeyKpV9+tvV2B1aIxX4/o0pfI7zuIzrrNxjug998YDYaYnIsKU2LImwzo4SX3Olee+SSFh++OejMk3yz8YsAXK9qVR6uomJMec9IxMyDr4tyS+OweoMFeEb6G5ghL7nStgBx1mjIq2OaTkC6qdCJ36BO/87y/HuSTzonfsBTN8g97nkRbF5zK2Jpjkmur0zV/qTdNToLOwrt+TDE5BWBTwuNuboBRHTntSHdr0II5g0RbACz80SLCv2yyHR4AmzEErbQ/RM7sdM3UHuIOStdBxS5iglZqMBGHxRgBrjZ8WD9sBdqaaGe1Vd17jowdoS7a6J652aKTf84y55z/CH+ph5cmhaUDNf+RmjNlNnLXugspTbgW+E76Hn72jq4nmt3DeVGv9gR0q3CNatF5ZZnFG+ITmZ/3vC6FYFHe23O0se6aFLgnzbt3SP1oxhBuqpFVJyD+VpNhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199015)(41300700001)(38070700005)(6486002)(26005)(33716001)(9686003)(6512007)(44832011)(38100700002)(86362001)(316002)(478600001)(91956017)(66946007)(66446008)(66556008)(8676002)(66476007)(64756008)(76116006)(6916009)(4326008)(122000001)(54906003)(6506007)(4744005)(186003)(1076003)(5660300002)(71200400001)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pqVZ8edMMXqE1mBoh5+cv1xwnt+KK4z/e/aiMlkcCimG9oar019QmlecSghd?=
 =?us-ascii?Q?i/zn36tV6Pm+La9EV5wv5nx5vW1OP05mat7VADm0cNLmTxav/PvNShPj4Xyw?=
 =?us-ascii?Q?OF67SFkP/fFYqrohqE0LMg1RLFQOmap+5WamAqXdbNHD3joR4vAs3fdjLm6q?=
 =?us-ascii?Q?lziMc8GOva9lRvHxIhcx9dDAUHgQCIO2kDGW66YCMP69bItj6dydV2QbV+ZY?=
 =?us-ascii?Q?czoZwFAwqDvSVROKR7th9pWl4ECvT39UY4K9KpiggyjQUEOsJynrwo916TQv?=
 =?us-ascii?Q?WO8LqmRSjdoS8ij+1j8LGt2XiofcEkf/eiPyLNamWY5v1t2Cql4y6SgVaCVR?=
 =?us-ascii?Q?iauL5i3OJMQ2mNviGkr0WQSjN8e0StJRj2GGkZYT7t7P7D19AqQGbEX1nlYk?=
 =?us-ascii?Q?3tc1/XBkXufp5pEw8SMY/Hz3sZ8WLbpE3CYuj9FHCZNjbFjFRYFh77+waKcx?=
 =?us-ascii?Q?Fl8nWP4ErkuzR/q77nrZlJe0li5+Vuob5fhk1/ODFKGev9R4VcoAthbiZp7g?=
 =?us-ascii?Q?6BvCSoEHGE0l/j3fBVoRzDMCG/SQP2ZTYrcrIOYy7/5c1jfpt9JnUVFQR0VO?=
 =?us-ascii?Q?fiAwUZktgw0Ung67DzFeSdW4O8WwRuGVynwbrokFaLymVBX4RXKYnJXm91EV?=
 =?us-ascii?Q?O2dd2gUk1p/KU46SHZHqHVAXnxzZ5sFM+OS/gNtVftMNmYnT80oOotUVvsiU?=
 =?us-ascii?Q?+tTThp/4w+vmkU5A6MZ8UrZG1EW6q5fN2NSTMpnkiCF/BhLSOSkkI3402M+o?=
 =?us-ascii?Q?045oww0y2UFE/9JEF/vqDsDTsZHafhgvYhjgn/iR3eKeMAGaPIjWgB3to+O6?=
 =?us-ascii?Q?OUH3YG4a99mAXhpJkS1c62E9cctUuojGTpRACl2KBGvMVD/b1hkAqbSkVQdw?=
 =?us-ascii?Q?1otqrYcsDw9pnIFh4Z+YByAFTHjvNrg0wwB7sxg0mQNetlmPgUVK7IAnJGsu?=
 =?us-ascii?Q?sLxnlTaZISkcNvXVkhfUV1l65igQkN94eAaW71AlG8xw4pcn9yZJm1+D9/a3?=
 =?us-ascii?Q?7JyXVsLOZOvaIFdJL7IkJQmCMFiXZ0IAlgmJ/0UtZf12uay/yaAN7SU2U86A?=
 =?us-ascii?Q?0b68Pp2JBHpo/v7sS4KMZvlpY8h9cFtXJ+SDNnpuunbtn3jS0Lx+gfGAbErP?=
 =?us-ascii?Q?7nCMNEe59VM0nywLj5U0QVGRfoQa2uxVwacBRse5QP5ls/JuDDIQ3XkwT6RS?=
 =?us-ascii?Q?Rmqh+H4f2QxxiN3DJdJIYhKJW2CUAGARLYsQpTO4DY/7MFgqBy23S/oGv3LZ?=
 =?us-ascii?Q?YBV7/wgoo5sqDeD8OR8BtZ/O2DT/gcgdhcOMsmr8eDzPV7jyqQIDqpQfazPV?=
 =?us-ascii?Q?Bchmk2CSF+WehQzNLcZQb0vt/iMOrE8pHl8qevZjD6xQR98Hq//tzTljvBuy?=
 =?us-ascii?Q?aaleDaOZmY6p1ZZzn+oWTilY3AKBZ8R3VYc0ui9f3beupZf8s2zsLzUgl8sn?=
 =?us-ascii?Q?fM6DcHGAv/LlSR/3dcyYMcqWsy7gnIDPhT86ws6psALWm+BoRsvqlMOqUJp7?=
 =?us-ascii?Q?jU1+nxvrWlbmxF8MLIUzfxRgyn9C1fe1PQ/Ez2hcnRQtcGhxpqHqXNpxPEP3?=
 =?us-ascii?Q?JFmfrQZoyW9284WWFyDZUr7fn434kNYt0VgCk4euSDGQwBhpOQUgootq69Dw?=
 =?us-ascii?Q?Qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D61176FC818B344F9C1711553BC11A91@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd0048f-8678-43e4-111d-08da96ffe71a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 09:51:46.4106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hdBqmZ0yQgOMN76PJw6NskspKXCKoscJRixRODgISpDhANsCRr8q+EX/vAR8TpgG1aVlvr587S3lIlICVCKeBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7268
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 11:57:57AM +0200, Daniel Machon wrote:
> +	if (ops->dcbnl_getapptrust) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] =3D {0};
> +		int nselectors;
> +
> +		apptrust =3D nla_nest_start_noflag(skb,
> +						 DCB_ATTR_DCB_APP_TRUST_TABLE);
> +		if (!app)
> +			return -EMSGSIZE;

Should new code be creating nests without the NLA_F_NESTED flag?

> +
> +		err =3D ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> +		if (err)
> +			return -EMSGSIZE;
> +
> +		for (i =3D 0; i < nselectors; i++)
> +			nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST, selectors[i]);
> +		nla_nest_end(skb, apptrust);
> +	}=
