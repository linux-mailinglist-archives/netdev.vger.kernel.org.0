Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EFE5640AC
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiGBOM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGBOMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:12:24 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA49510567;
        Sat,  2 Jul 2022 07:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf8nVxGDxPtOG0f3LuXSYa8ihIO/hcto4TWTO98IDJyvtvqyufjNZ67x2D9fuMdVfv4ZrUvdBuPKLoxHgMkXouiJ4XM1irVdl7o3l2RPlMWUL056smLQHIo4IJN0oB++QYx7EwKNEpBRJG2XxKCo2Fsa1FEMeYWMYpJQ11k3yUNHP3cS3NkABiml68+x7MnCGUmIVwALbmpTxcnoVwo2jwZlq4PqQiSsBmPR0CVfWdyUbMiE3nfgjwVxszrtpzGdjWqsqGFkt/A+aBixNZ+SaFyLIINHzlnwMvcnNC0LPN3PFbK7d7hTCgv5545vZ8+UE7HsgZ4TAiYCJha2XByR6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSIOwXW8+ZL9oES2CZ2wV+k7hR98i4ogragHf4JqQro=;
 b=fc05hkTry/yU2tO0NTtfwBKePO/QC02guRnLPg6kYdvJYS0+LiGCXUNBxCE6CsATwPVQwiYO2XWbR8PHsav3uiTiF/CEnDQku7rDftOrlOCvmPDkdOw7Tw0kg0Yl+pVeoJVsf/pm7/4NL+zl4o2hMbJaYMNSnnpPeHzABKm0t1LY0H4aUD0UEvRQGHtfEWa1fgVef1rUbdNSvzTIcT6TBQyBsiEQ5w0plPAXEOqIJyNfjNmSlIgebMLo2NgGCZO4wYzRXhlM1sxp2dZS0SRXdf+O/m+kNjYjCldFstjXqDTzSN2gZb3n9zoIbJOyJ5NRote1B5u391GHyPPYWeKyDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSIOwXW8+ZL9oES2CZ2wV+k7hR98i4ogragHf4JqQro=;
 b=Hu5bVaCTo7jsQyr5aGVZ9W4KNybp2a9N5C2KnjfKhEyrtdp21aTNIROt5SDcQ25Mb7MPO4OL+yl03GZgCd9rwSZmJ1roxja65iky76Ln8zTf6X8HBQ4FqrvnZ/LP4bKH+cuYGLeRwoY8qyasNFqh+sHiI+swdD/AaCgWz6TlNns=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.16; Sat, 2 Jul
 2022 14:12:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 14:12:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 5/7] net: lan966x: Add lag support for
 lan966x.
Thread-Topic: [PATCH net-next v3 5/7] net: lan966x: Add lag support for
 lan966x.
Thread-Index: AQHYjYwcNm8cypwpn0eaifU5TXdZ+61rIGKA
Date:   Sat, 2 Jul 2022 14:12:20 +0000
Message-ID: <20220702141219.l75f46sx4hyldfyh@skbuf>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
 <20220701205227.1337160-6-horatiu.vultur@microchip.com>
In-Reply-To: <20220701205227.1337160-6-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 790c317f-1cfb-45a2-2698-08da5c34e0ac
x-ms-traffictypediagnostic: AM6PR04MB6088:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tjMZtk6BNT/LswbeztT39OxLkWo/MlGatwTxHzPQpOrSNvNKLabp+ayZJmUkj1ZhjVpoMV8vDXOR6OoFGGaWDkXsB4skpkI146H55UMuADc+kGpzpkq/x+Y84yavoHaj07aqNN6gW1aa/qwmwuZSFFNLpYhafJ1bZTOsLSR+Ev2xwzeRVpeu9qwnu/3QI6tfdJA38TYdN4tY6u4Tm+q60ihQbSa0GGq0CaBS28WDkVgUonbmK8BNl9k1EDiasZ1XidFf+z7ZlFIUUiMzbjOn1OggMzir4VZ7ZENQj9y2/rS6XAVIxzkf9S3FMpXatnsU29Spl3dcIg7HNmj64HceBt5CzPwOj5CUeC02jBtMeQc2G8YBxtPAf2iYJ4pst0dQXkMuGhlKeM1nW8022vdlU/+sr4JMYDmT2JBmL+NAgNWAiNaDGoZioiXCjiPRkLFJKlhqZ0SqgzgP2kIfSBG58WnnIRAbFLdktnVEFauRstLjK+6IW9WoEghEFSpASgbAnlRqMai/Ot8D0htyeuv7tMvnMTt/DxuX1s3xdWtq4AbQ9Mnx5KlUbU/24TSP2pPG9Fr9PDK4D40xEWjYQk7J5K4NcFftggEPwS3c8Gqz8f/9gthLhA3h5IGN57H8W8TWh/mhZ2rQv4sS+2FBwhQbxRY+vf1b4SjHUprDbuE/3FKiwnVy2unlNWVc9Zj7evo9PgTQwN2KVoaqYYaqPX4v/A8nRouaSyVmRjanf7/9geCaFxQtIsAPwX0S2ErjTeMxI2DDEOF4Ozw44HVNkhyDGyQonHkJPovKfpZPSKNrN8JNbwnO0jmVnmKX2e5rTbgN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(83380400001)(122000001)(316002)(8936002)(38070700005)(478600001)(6486002)(1076003)(2906002)(9686003)(44832011)(5660300002)(186003)(6512007)(66946007)(26005)(91956017)(66446008)(8676002)(66556008)(76116006)(64756008)(4326008)(33716001)(86362001)(41300700001)(38100700002)(71200400001)(6916009)(66476007)(54906003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C+Yn2jK3TIPyPlX/c6lZZdY6R005GPIs8l5T6k0LpKeRD4WVkSPOqLzRLHxP?=
 =?us-ascii?Q?BriXswTYK99kjlr5faI+WsegcWJu3PiiY+3UeCD/Yx9+feGQ6wTjp7p2Bv9m?=
 =?us-ascii?Q?5NEZuBw13l5apNDwu/Ps1GIy181zh23Pl9ZDTqiGBht8jg1rMGAOLBFLU/sd?=
 =?us-ascii?Q?oqTTXhAWVAU486Rwm0o3wZ5syvAGv7sDVy27QEn+oJwpoHFqR11BwqrP6Q2d?=
 =?us-ascii?Q?HTA/AK4p9FVzhGxck/bhLxhi1Vz4RNI1qLBQko1Eo23dsOwd5Bru6ChQGE8b?=
 =?us-ascii?Q?vsFViC+kJbnGzJJz8I30NWyKM4ltd0sFQkMjaLp9jX8+Jx/fJ9p+3LIE1vqZ?=
 =?us-ascii?Q?J2HhRYZhBOM+HiS0PmuihnaacU9Z1O81dlEvcFpqr2UXsC4ptz/V7X5D/eUY?=
 =?us-ascii?Q?oTiTTpi3h1296Ggy3mLTFjOSvlp2feTa0Ny7b1evtS4bgvjjPPxcYTq7zVI0?=
 =?us-ascii?Q?WK5slqAAcdR61ywqpYXyvoyDPNe7N6+wLCD7ra4pxV4NrZUoTP8spjOdcWRK?=
 =?us-ascii?Q?HbOrlSM5NlkLpYyR53+IRzPyhmNf00d1J721N1zs3/x90juHfmuVO0JrGMPR?=
 =?us-ascii?Q?EXrnMZJGKk815llu/8KCjCNTTpJJ/YzxqxGeoUNATCCuYygpEyRLD3eDKpnT?=
 =?us-ascii?Q?3U4lNe/9k5P8XoDpHhKnXKQ7oXJSK62LRCtwVWThNG68yJfyKtUeEaqpeMsY?=
 =?us-ascii?Q?XpdLKpvIDTEe+sL+MNd3brJnJFTwSXhpHXGTbpbbkc5/HneevqGKmAh3OI34?=
 =?us-ascii?Q?odmtljLJkiRBqTTTsXURRW3D0tqk/Bb8e13ANq2wuNmDec5Kk6C+QG9SVh8f?=
 =?us-ascii?Q?Htb+jR9WnE27VAKiiB8HcnlsDpLglUEf00XIbQaKaXQM5RH8i4F3ulnkozZ9?=
 =?us-ascii?Q?UxGuacLwVEpxRgaGr7GgQtdDA7PW2twWIyGLjpw1kHaoxCgMC/8c9K9pJLvJ?=
 =?us-ascii?Q?y1cvkdiMQZfueVgI2wiLqvv1W44HwYpyYaexcB3K9/zfJkm3bWygQSnRNJg2?=
 =?us-ascii?Q?3kpai42HjJXb8irH7O0XFosiZG8JP+Ibi+K+5bPjaGzWVqf7UJ+roSbhQSVg?=
 =?us-ascii?Q?lJ8T9OTDYVaiN2UewQod7iCPnNq/NNBGj7g8qHDtNE7N5aVvi/pKgHYbQKA1?=
 =?us-ascii?Q?oPr8IC1UUZv880QbJWnJf+D+kRydNd0889Pevzdf0QbYxH7b2Krtuxlm/sjw?=
 =?us-ascii?Q?2pBx09GHQqLuc9Z4/gawsrweYSuVMmWsEXBk+1bYPm7EDLzwtEmDMRQOiYHj?=
 =?us-ascii?Q?C92KKz/qyKAYZP8cdqmHFaa5rovWIL5ubbPtk526CFeazX4e/g/6u6k2oXbs?=
 =?us-ascii?Q?LsQ+F4o+tb42wAc0ENODr/k7bQ1zWojnCkjjw0jlx0RqUO7PmyKLNhGcTvNn?=
 =?us-ascii?Q?QczstdHGHz0Unr5iuNWeNYKJRLXJQ1dy2qyYyxPNOi2jQ5XdANXDbZCC2hQ6?=
 =?us-ascii?Q?xF68aZOv/VR0a/mvaahJFjbN1JsuoF29zgvFVW6R6eA1LDLP50jdeoZCedlD?=
 =?us-ascii?Q?zooy2wRlrqVxYcsuqIy/wvBN1ok2mdyiqeSqTyTI88QZAhAF3AbOerOLMlLK?=
 =?us-ascii?Q?6bouS5+z5jQJ66xbRzzZMjxXbYySJV11sRnBRa6Qampc/jPDroBBHXC930Z3?=
 =?us-ascii?Q?9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B5F7B9A5D31EE419E101B7AB312692D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790c317f-1cfb-45a2-2698-08da5c34e0ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 14:12:20.3154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ja9f3kEwVnKDywT16js3mKq9WxeDN4LPudBwoAroZCHHMZ0TyuHZQRmVSPxKkzlIVv7e/MTEhouwhtd1mYrbww==
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

On Fri, Jul 01, 2022 at 10:52:25PM +0200, Horatiu Vultur wrote:
> Add link aggregation hardware offload support for lan966x
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Superficially the code looks OK (maybe if you could only remove the
trailing "." from the commit message). A comment below.

> +int lan966x_lag_port_prechangeupper(struct net_device *dev,
> +				    struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct netdev_lag_upper_info *lui;
> +	struct netlink_ext_ack *extack;
> +
> +	extack =3D netdev_notifier_info_to_extack(&info->info);
> +	lui =3D info->upper_info;
> +	if (!lui)
> +		return NOTIFY_DONE;
> +
> +	if (lui->tx_type !=3D NETDEV_LAG_TX_TYPE_HASH) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "LAG device using unsupported Tx type");
> +		return notifier_from_errno(-EINVAL);
> +	}
> +
> +	switch (lui->hash_type) {
> +	case NETDEV_LAG_HASH_L2:
> +		lan_wr(ANA_AGGR_CFG_AC_DMAC_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_SMAC_ENA_SET(1),
> +		       lan966x, ANA_AGGR_CFG);
> +		break;
> +	case NETDEV_LAG_HASH_L34:
> +		lan_wr(ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA_SET(1),
> +		       lan966x, ANA_AGGR_CFG);
> +		break;
> +	case NETDEV_LAG_HASH_L23:
> +		lan_wr(ANA_AGGR_CFG_AC_DMAC_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_SMAC_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_SET(1) |
> +		       ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_SET(1),
> +		       lan966x, ANA_AGGR_CFG);

ANA_AGGR_CFG is global to the switch, yet it constantly changes with the
hash_type of each new offloaded LAG. So a LAG that hashes on L3/L4 will
break the hash mode of an existing L2 LAG. I think you should implement
a system that disallows changes to ANA_AGGR_CFG as long as there are
users of a certain mode.

> +		break;
> +	default:
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "LAG device using unsupported hash type");
> +		return notifier_from_errno(-EINVAL);
> +	}
> +
> +	return NOTIFY_OK;
> +}=
