Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9460E3D688F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhGZUkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:40:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:10625 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhGZUkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:40:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="191914191"
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="191914191"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 14:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="474132883"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2021 14:21:13 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 26 Jul 2021 14:21:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 26 Jul 2021 14:21:12 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 26 Jul 2021 14:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAtOBCJYOpOGPIVG8+iZnY/3pNTua8UuiPhyLW6l6KfqzhBAvK5sHuqsYvBKkBXsmw6bGlYa8jrtOJGh069VNzJXhyyTwND5nNNL3mFBE7LlK1Q5bWWdqjOx10JMTpdRAG3M/TRyJGtCVcmIsJZtGQ/I1JA2VePdh7/yvVPYculJT5FNnDp3Pf3FZKFGlaT2B/YmGoep5LRZ9ADW5OPQBr9e7ib3mAK12gUATR23rH/yY9DTJrux6ekf0t/GEadqBVMJir3Z+He9w5xYfO+KO6/YPwrwQqP0DVc6vw1dE82ZpLqoSVyWzMW3hEJxTlkeT/mvENzusmexOF4XCyh//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcQ7pMH8NjeZPNLdn3MzvaqkijSl+6bW7Mjtce7iJCI=;
 b=TbAiuR30qEhhQkB/c6GL6U1TTzSm1LB4/fDpazFFBt6YiG5fBLsNb6mhPaDyhd4p1maeDJY26kQCuxUSrgiIMaFK9Xx9FrxYr5geT70GXWt9g8epZf4bxf59PAmwS7P54WCY/5ux1WsX5SYQgDauKIxK1lCCJd9fJrHvcBBxOmjHFI0IArHZwQ/eUZEKrphiHWwU1X37t13mq2tThcIiJPh+duHkqho1dGHdKj8fyh7G2fYPHYSUHdSZq9RPwrJA/G2eXVccod7hqMc5cZLp8+jdEJJBXMVV0n2pmYKRGejhryCey6VgAMeT1YXZiYaynUgre98skHPtZgerhQIddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcQ7pMH8NjeZPNLdn3MzvaqkijSl+6bW7Mjtce7iJCI=;
 b=lKpS/l5ujM1LRBfaH3XX4odTzJzDUemyoLWUbcWiZt/L4Bh+7+ecV1et0If4EevoxxUDgJezWlAQwibzAM+Mi26pYdJD+xZMp6vGew4I+9pgJYNCbFTYkomz++iXLpCiRxN94CO1N5NaYSEfeQ7TIE1jCZ6sqzqkJRvvXnCvahk=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 21:21:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%4]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 21:21:09 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
Thread-Topic: [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
Thread-Index: AQHXgfqoenHufbyXQU60AsxIki/9gatVwt5Q
Date:   Mon, 26 Jul 2021 21:21:09 +0000
Message-ID: <CO1PR11MB5089F97937FF0141FD02D3B3D6E89@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210726084540.3282344-1-arnd@kernel.org>
In-Reply-To: <20210726084540.3282344-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51a0df4c-5ec0-4e8b-40aa-08d9507b4965
x-ms-traffictypediagnostic: CO1PR11MB4963:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4963E9C5D68E2C1BEED3EAE3D6E89@CO1PR11MB4963.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwbCZIZoidIe2n1mZ/3WIQ36UpiGAU8llBtcQ9OpvC6sSXzvS24kfRWt5iJvnBIZyT8NNAMSKLWwRhJHnX9aQjd3eWiojp/eHNj1Lgy5MIIRZMe9oyf096vnvGts2SwWAg2AWXAg1Sa1AsVKU2X0PVHszNubOMj/BJCzqp0umh0ugzO/XvP+nbXq0e1qOr2WOZ/9NyO3hShDKpimg1RpLJuSRAsp8tIeigXlIVLHptLGj2+QPstmxObIUkoN4mgw9XF1pspOurZO4LnICt3RDq9qV14bjRzB3N7xHgZD9j0E8Yw1PhhoFhbD+3+Qh4cUhh2HQrEnRUSqgqxjYjI6tv1xYM6OZvZ/GpKeYFTvRYT5Nn6cLUE5kEf+R4NFKcgYs3qQUdBua5KMyt+de9fT/GT4DsCvEgV6Dk48abSRjAtGOKNIaQFy3UjbLhdgdBOGqfWPKJObQ2Q5nYdTXc7vb6rxd2OUY9H5MWjE0Wwapginpb91f+u+TJ49ADueqXTI/R8fyAVCf/HIigqnTpLq+v+/sAcnTSDGvyESKBn14N6v7OzQ3EwdF+Jlg2ZgguZ+XeWUtUoAy5ACReWOcx69sZWHZ1geFkyGssp/ogyg9CEm4oH7H+9lClK9Z18xPj6C6nfsE19/Qd6Z6mhzpKklUhz5Pgm4QnxqjtN6DGLbB9HX6zejd2b3O1C/XPKLB0CRLc2pAOyUy0/U6AXHQl26bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(54906003)(4326008)(83380400001)(38100700002)(5660300002)(86362001)(186003)(110136005)(66446008)(64756008)(66476007)(52536014)(122000001)(66556008)(76116006)(33656002)(71200400001)(7696005)(55016002)(9686003)(6506007)(8936002)(316002)(2906002)(66946007)(478600001)(8676002)(26005)(53546011)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B57owayahNyp0NjnrryyEW2s2EiTyiCf7CBgijfzMFp3hr6KG3qrUMHFI5Cc?=
 =?us-ascii?Q?jtnJc21Z85Nv+TPZ36EZdwtKxxupX4tBsQTunfKoK5RfmynWgYpp+Y3FL/Zz?=
 =?us-ascii?Q?EtYYdU3QPNvdCOwnSsxx/d/vVWK8+mAa5K3Th1YZ7FIcJwarAkINF19pt0Eg?=
 =?us-ascii?Q?fsZasbL/vdClCIA+BfTI3e9xYbulPVaWKc3t5rhOBfPOHJIg+iHC2MDYygLI?=
 =?us-ascii?Q?pnTOlG+G70UPWHexVoRwktXrUBvMw4sOlc0IVKZCM54NHq2DMLLZWdZ6vuIC?=
 =?us-ascii?Q?uVkOmMKQY1sIILV5aDp/Eko2780T5Cc0Wn/YOfm/x0LypxL3CQHiXATELcTZ?=
 =?us-ascii?Q?InRniGtvoTR887wGSYre6dR2bVk69rtIdVz0GjXbvumedwoKbNHiC5/aLuY1?=
 =?us-ascii?Q?o4O1STioN3c1uxFa44YXJNWjvjDSorD+jVEw1GFFU/O2rU4OUhY6Ka0N5JPE?=
 =?us-ascii?Q?ytN03cQsEabXhcVaJ4OFbhBBXU3j1wHEvD0z+562jgOyKjQznHhLoeTh7B1z?=
 =?us-ascii?Q?ZTMsMuqBhyP8KQglo7DNp5opuVU1y0sQ7fKN2tdjFSYHLZsUz84nJg0OOiLs?=
 =?us-ascii?Q?I0CMrawYCODbrinjeSy507mbC8rquOro7KdmuJWSDPQ13wJj5iHam7fqgA/s?=
 =?us-ascii?Q?fUED3n9O5XEXdP4yBS3fI/an8FHCtPmyGLSG8g1UJ2sA9A1LFNjVd5kNA37m?=
 =?us-ascii?Q?lmTvq9u3UkSxEeuNKFK9+eu6p3R+9YCLL8BXeQN6pnxcl2ZuZQCDjIbRg/7G?=
 =?us-ascii?Q?JHO6VtrNK/IP/5JLPb6FXi/VgsqUlzksvg4s2XruSsk7DO47KjEgcCcwC3Mb?=
 =?us-ascii?Q?o/UT8IGZeLxtwX97AnX9F87PpUDkpqmeZS9xNyQy0ZkXQw+yGsbuiWkMozDC?=
 =?us-ascii?Q?HS6b6cveLgN/8ODWk4HQURPndBG4kdQox85YLX5+u06Du4zzo3n0xneT8Jhz?=
 =?us-ascii?Q?+gL5bcySpn333qCEXGA2PwxO5Yk2wUaXqbURbT4MedMWBXCN5SqURUecPqTw?=
 =?us-ascii?Q?G2VTeQpt6svxgh+yFVLZTcBPdKK7SmuDufokHXjSUFND604ScxKq3M2SBYkv?=
 =?us-ascii?Q?W1TnoEMDFXNvOOHyRl1xUbtrtUzhY7A/ZlcZVK/EdS/j2mp++OF9Hq2SzwA/?=
 =?us-ascii?Q?kW7mROvoTV24VBV2ZPefYO2DTkuIeOO2XlJ+FDbBbTpnrNtdA3veaXo3vosM?=
 =?us-ascii?Q?PL/+JwvfBrq5tkllKWvuLrblAWrebCAEx6rsMwKvVDoI2k0cXbhoccoQxbBO?=
 =?us-ascii?Q?vNklNjXgqTORCnw36hYcw8vKvgL+nw0p7H8PYol+bZjxTTaEacRN5bf7ayiw?=
 =?us-ascii?Q?/JE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a0df4c-5ec0-4e8b-40aa-08d9507b4965
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 21:21:09.1291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ap15PLRd7tsbdpSjQ7TyUCBh+ovZ14I7mN8zY0HdkYHimaOKZR+w3Z7rzhHfQFji2D1GGkROeYcUS+dJ5WFBfD3TtXZKHunwxFMEnRX63nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann <arnd@kernel.org>
> Sent: Monday, July 26, 2021 1:45 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Kurt Kanzenbach <kurt@linutronix.de>;
> Saleem, Shiraz <shiraz.saleem@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent
> it from being disabled manually or built as a loadable module when the
> user is built-in. In the ICE driver, the latter now causes a link failure=
:
>=20
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_eth_ioctl':
> ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
> ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_get_ts_config'
> aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to
> `ice_ptp_set_ts_config'
> ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_set_ts_config'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_prepare_for_reset':
> ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
> ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26 =
against
> undefined symbol `ice_ptp_release'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_rebuild':
>=20
> For the other Intel network drivers, there is no link error when the
> drivers are built-in and PTP is a loadable module, because
> linux/ptp_clock_kernel.h contains an IS_REACHABLE() check, but this
> just changes the compile-time failure to a runtime failure, which is
> arguably worse.
>=20
> Change all the Intel drivers to use the 'depends on PTP_1588_CLOCK ||
> !PTP_1588_CLOCK' trick to prevent the broken configuration, as we
> already do for several other drivers. To avoid circular dependencies,
> this also requires changing the IGB driver back to using the normal
> 'depends on I2C' instead of 'select I2C'.
>=20
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810=
 devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for fixing this!

It feels like Kconfig should have a simpler way to write this, and/or we sh=
ould update the doc, since I would expect this to be a common issue with op=
tional dependencies

Obviously "depends" handles this right but it forces a dependency in all ca=
ses, instead of being optional. select is used to ensure that some bit is t=
urned on if you turn on that item, and imply is supposed to be that but opt=
ional...


> ---
>  drivers/net/ethernet/intel/Kconfig | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/Kconfig
> b/drivers/net/ethernet/intel/Kconfig
> index 2aa84bd97287..ab75cde0c4ec 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -58,8 +58,8 @@ config E1000
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>  	depends on PCI && (!SPARC32 || BROKEN)
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	select CRC32
> -	imply PTP_1588_CLOCK
>  	help
>  	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
>  	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
> @@ -87,7 +87,7 @@ config E1000E_HWTS
>  config IGB
>  	tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
>  	depends on PCI
> -	imply PTP_1588_CLOCK
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	select I2C


Commit message said you changed IGB to use depends I2C, but the content doe=
sn't...

>  	select I2C_ALGOBIT
>  	help
> @@ -159,9 +159,9 @@ config IXGB
>  config IXGBE
>  	tristate "Intel(R) 10GbE PCI Express adapters support"
>  	depends on PCI
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	select MDIO
>  	select PHYLIB
> -	imply PTP_1588_CLOCK
>  	help
>  	  This driver supports Intel(R) 10GbE PCI Express family of
>  	  adapters.  For more information on how to identify your adapter, go
> @@ -239,7 +239,7 @@ config IXGBEVF_IPSEC
>=20
>  config I40E
>  	tristate "Intel(R) Ethernet Controller XL710 Family support"
> -	imply PTP_1588_CLOCK
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	depends on PCI
>  	select AUXILIARY_BUS
>  	help
> @@ -295,11 +295,11 @@ config ICE
>  	tristate "Intel(R) Ethernet Connection E800 Series Support"
>  	default n
>  	depends on PCI_MSI
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	select AUXILIARY_BUS
>  	select DIMLIB
>  	select NET_DEVLINK
>  	select PLDMFW
> -	imply PTP_1588_CLOCK
>  	help
>  	  This driver supports Intel(R) Ethernet Connection E800 Series of
>  	  devices.  For more information on how to identify your adapter, go
> @@ -317,7 +317,7 @@ config FM10K
>  	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
>  	default n
>  	depends on PCI_MSI
> -	imply PTP_1588_CLOCK
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	help
>  	  This driver supports Intel(R) FM10000 Ethernet Switch Host
>  	  Interface.  For more information on how to identify your adapter,
> --
> 2.29.2

