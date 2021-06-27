Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE73B5506
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 21:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhF0TqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 15:46:06 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:64647
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbhF0TqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 15:46:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8Xulrzxa1p9gxHJVPSGLdEKMMzuVwGWyyOpMqoH6R3I85WqtiFOE+NeQO+AgFebBFIozL+YLuJvyXaFoCrRlMYLgIvZ1S322um0mF3frzZ4FSJaevDf/bxLN6i4GZ5wWjrfTK6uc5qs2ZQ3XOVrMlIsv/pxLlDWat8kv1Yf2ED6CeLT3yp42aepXhTR2lzR3zcVPa7uiIncvP+YP2vhrPYgh8kSdUy+MCmqDt8OLAQpuvzFCpRhroWrIl3EdIWjU+qGXoBw+/Ud7z0IwGJrB+oS4shcGc8VhoJ5qcB6VbVYUJ0hnVW9NzL/iGR37Nb2H+JpuIbXTaRFymE5myyyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWc44oqEq4z39bDKr1iO1Ibj5cwnSqmHlPqpItojeQg=;
 b=VaiGTb6NOL9tXvPMFbwaxCL0tZEs0RCM9dnm7vxq0P/gyJ1f/vh/x5xkgpOAI5H2I92J/Pdgx8PYZvIyQQMs1qTyPPQhvjVjsykAH0P97p9E4pfYneI0rNuvg/6LXUXzSP31MBTcc1bQapBnbezsnCOp3B0q4v9lYa2JfflUdmxhrten88j2fPTW2AhkcSCr9McUY7uE5CZ1A6WI2Y9UhqqXt14giw+MY9VtrBNHK75G7JbIe5XFIgtOt8J6HbvNq1EFWDO5izjkBIAW0nBcr2x6/eRy728gQUJZkMU+91MhBuYWy3LPKvIGZ0xlo4SjnnjAOe2SzHcRrDCCytEclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWc44oqEq4z39bDKr1iO1Ibj5cwnSqmHlPqpItojeQg=;
 b=AVwDPx43Xz+BJzqHMeT+MC3EHJEwBoOsu9zsg1fTscnjaE6eIv0fk94qo8r7+p07OhX1EmaYUXoSpwH4plPMIjf7FWuzwxIYGkUoE8NAbPu3tP0Gf9nKt/Rsbuo8HBRZN8974RHlNPryJgYt8C1Z3FcWhFs/3IuVKo8zV+NsD6Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.24; Sun, 27 Jun
 2021 19:43:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Sun, 27 Jun 2021
 19:43:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 01/12] ethtool: Add support for configuring
 frame preemption
Thread-Topic: [PATCH net-next v4 01/12] ethtool: Add support for configuring
 frame preemption
Thread-Index: AQHXaiLt1oRehZqnY0+RdmtDxrn0Q6soRSmA
Date:   Sun, 27 Jun 2021 19:43:36 +0000
Message-ID: <20210627194335.vrhwurg43esnodi3@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-2-vinicius.gomes@intel.com>
In-Reply-To: <20210626003314.3159402-2-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a66d1093-babd-4da3-013c-08d939a3db47
x-ms-traffictypediagnostic: VI1PR04MB5502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB55027545D22A8C3754BB73F4E0049@VI1PR04MB5502.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QDfSsNvgG5ozFTB1G+CJBgONbTvdG0m4TmjNbpG8VFDPyI/LlpYyhqTFgZ3EIV80AMVyeFUR0HLF4A4mF6payy2aqOZ0BqSM/oFgTRsPQId1D0AY8o6kNyKz7sRZR3xKciQdByYNABgU/yuSnVrQjIjmNzyWAtWUvAVAlL4rHVIAecTW7NWuxpVyl30RvpvbMUo2uH0q/yoCnRka2uUJwfi/7lFYz3KQTuiOrxI+kx11jt1o+Ei+ulmXPZt8BGwjtxxkE296qeprg129/hm6HAmVwL84SlCEjuZHk4MTloYPecpL8ZjIx+1tXQt4cJcbAkOYGLTx6lDMR1XC9xgMwwWnbqMFqhc7SEcyDlUqRgdxkAKNtablb+7wzcJL9W7lQrgUphWamgDlxPt+ByD9ttyCo72bdHLTCTPyQwNI75q4UNpTnPD9LF2i9Uz/1lVuuYUB0xcQ0CR+iNgL4N3HmlgkJaJghEU7OMEVngJgeIZbfyB4eL+8Gtdgz7gra8WoUbOZcF23tW2GXFNKcrEQvvr3DcdKtTarHFFcC0C/QRHb2WTinIF7btdmtc8ZcFSzeUoZR82pKTBgvOC2o3tVNWpWDoKUWUu+Bd79wea8alIGL8TfhJUlrZCe8Djnziw9W9z0n3yr+aaLdPlaNmhhBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(136003)(366004)(346002)(39850400004)(376002)(4326008)(76116006)(91956017)(44832011)(186003)(9686003)(66946007)(6486002)(33716001)(64756008)(66556008)(478600001)(122000001)(6512007)(54906003)(2906002)(66476007)(66446008)(38100700002)(316002)(6916009)(8936002)(8676002)(5660300002)(1076003)(86362001)(30864003)(6506007)(19627235002)(26005)(83380400001)(71200400001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ja6noxo2OMiuKbQxlQd9gqr655P/Sgh3OmLqSIav2Zc45i9T1Os/lQP41kXk?=
 =?us-ascii?Q?KwHXBdBR6ZMT5F3kIceEPjvf3ffsdlBE/aeq4ffVTfPkOYnwF7v/LpSTb3gw?=
 =?us-ascii?Q?ci6/nXmw8dG1IhSp0UESkdDcUXJBdV02FtwhqPGDvqCZ9fH8Cl8psqRSC4rx?=
 =?us-ascii?Q?tRnWXlvSkQ4lOz/2glgkPz/4ZQO34ly1jQEvTX5FIY4B0phoCZc4T62DxUbK?=
 =?us-ascii?Q?/sqCQZ6jskD2JFK0QED+Y2HbGAPMkeCU07F+BC75OBGou6ZMUGgoiIZPryL/?=
 =?us-ascii?Q?e0jgdkIAVWo5Kq/bbZOjbzJeYV08klrRq9i7gLL1mAkfLfjJUp9O0oqCewGr?=
 =?us-ascii?Q?8gcghbkGYb6AGrZQF78IAWas/buDEF11h+Nd3APRmsNOpxBnI995fW58jiyu?=
 =?us-ascii?Q?K8IS39LUMfr7BFAGsDs1SS6FrGlBgrWtNKArYv5h18mD0nd2EAgVIY7ZvTjQ?=
 =?us-ascii?Q?uJdGPqcSIY64OYO3+2gjAzHSXevdvqzlATVCuO1WmON02lfCtO0/l5tGonQk?=
 =?us-ascii?Q?hDbWC8tZx8p8poZMwxJwiz2XDSiZfEWtGyISydbMW8D9hlWCb0zfP6e9pqGc?=
 =?us-ascii?Q?uKLbQ7cHN4IUOJ8GAnWgXz4tofx6CAD0gqtrPcvwopRcBcvSeqsJWYSzjjsj?=
 =?us-ascii?Q?BpC7t9O24ExhzYEylUCzNW7W4f1SJb05zL64W93hE0MVr/yUxDIomfYHYbJV?=
 =?us-ascii?Q?CmZfBcDerST70RZrC4/wapygmJRKoIIIvNFgxdoazKUxBL22ZpbcOZWfn/WD?=
 =?us-ascii?Q?3EjbnU8zq3LeHcaRmiXf5T/wrml6nSOEQEZx1t7HTRWDRxvhwFYz/v7AW88l?=
 =?us-ascii?Q?enzop2ZN3LMcNSdaDZ+UIPOLg+JNnYz9ncFQClwf8kD3O6ImdpvlzBCnjh95?=
 =?us-ascii?Q?zjIdjyWRd3zQkjZhoztKc9la3deVnDQ4h0RH7C5E1ej8Hput+lZyaUSqW3Ni?=
 =?us-ascii?Q?cqWxohqkAccgA62I3sk+VBctCrdNNgnSrmvVZQdQuTZLCNEOiBpfiyR9gnt4?=
 =?us-ascii?Q?PQp+gNFuuSV1Yx0CErqL/xTJRpXfZNgm4nLvWjVC5eWRvRlfUpA/oAsT8Kd4?=
 =?us-ascii?Q?qU+waZjaHnjwFRHQgB4IUvkUTJKNWDFAxJ+OVaLB1rMJkhZqQEt13Tq5cTFz?=
 =?us-ascii?Q?rJMhZ0QfkdEcTGcUvslNMNJK0kefHUsIeV62njhMSH0YvuzxmlJyXQ/6x3hY?=
 =?us-ascii?Q?79hvchheX0D/rKHPauQBRgd/12v7GfTJUTy8zjU8zQ1Z99theIZZs0m2wFKs?=
 =?us-ascii?Q?TcebQ8Y6R+rmSPVuXm/GsHdWNUTCo1kXfpL98yV2zzPEyd3iL+C/BU0HYxcB?=
 =?us-ascii?Q?KswcIoK+gWAACu45jUf3s5Rm?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87EC0A4C3B774640BE94CBE106B41955@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a66d1093-babd-4da3-013c-08d939a3db47
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2021 19:43:36.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIK05Vub7r4e/SvW24h+46jukyq4/kcxi38I1w2JTmxvsR//Lk6nytBaqySrQ3+jGQkmXh3iV4KeAUV0ulcnEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:33:03PM -0700, Vinicius Costa Gomes wrote:
> Frame preemption (described in IEEE 802.3-2018, Section 99 in
> particular) defines the concept of preemptible and express queues. It
> allows traffic from express queues to "interrupt" traffic from
> preemptible queues, which are "resumed" after the express traffic has
> finished transmitting.
>=20
> Frame preemption can only be used when both the local device and the
> link partner support it.
>=20
> Only parameters for enabling/disabling frame preemption and
> configuring the minimum fragment size are included here. Expressing
> which queues are marked as preemptible is left to mqprio/taprio, as
> having that information there should be easier on the user.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  Documentation/networking/ethtool-netlink.rst |  38 +++++
>  include/linux/ethtool.h                      |  22 +++
>  include/uapi/linux/ethtool_netlink.h         |  17 +++
>  net/ethtool/Makefile                         |   2 +-
>  net/ethtool/common.c                         |  25 ++++
>  net/ethtool/netlink.c                        |  19 +++
>  net/ethtool/netlink.h                        |   4 +
>  net/ethtool/preempt.c                        | 146 +++++++++++++++++++
>  8 files changed, 272 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/preempt.c
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index 6ea91e41593f..a87f1716944e 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1477,6 +1477,44 @@ Low and high bounds are inclusive, for example:
>   etherStatsPkts512to1023Octets 512  1023
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D

I think you need to add some extra documentation bits to the

List of message types
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

and

Request translation
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

sections.

> =20
> +PREEMPT_GET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Get information about frame preemption state.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PREEMPT_HEADER``          nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PREEMPT_HEADER``           nested  reply header
> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enable=
d
> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag siz=
e
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
> +fragment size that the receiver device supports.
> +
> +PREEMPT_SET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Sets frame preemption parameters.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enable=
d
> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag siz=
e
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
> +fragment size that the receiver device supports.
> +
>  Request translation
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 29dbb603bc91..7e449be8f335 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -409,6 +409,19 @@ struct ethtool_module_eeprom {
>  	u8	*data;
>  };
> =20
> +/**
> + * struct ethtool_fp - Frame Preemption information
> + *
> + * @enabled: Enable frame preemption.
> + * @add_frag_size: Minimum size for additional (non-final) fragments
> + * in bytes, for the value defined in the IEEE 802.3-2018 standard see
> + * ethtool_frag_size_to_mult().
> + */
> +struct ethtool_fp {
> +	u8 enabled;
> +	u32 add_frag_size;

Strange that the verify_disable bit is not in here? I haven't looked at
further patches in detail but I saw in the commit message that you added
support for it, maybe it needs to be squashed with this?

Can we make "enabled" a bool?

> +};
> +
>  /**
>   * struct ethtool_ops - optional netdev operations
>   * @cap_link_lanes_supported: indicates if the driver supports lanes
> @@ -561,6 +574,8 @@ struct ethtool_module_eeprom {
>   *	not report statistics.
>   * @get_fecparam: Get the network device Forward Error Correction parame=
ters.
>   * @set_fecparam: Set the network device Forward Error Correction parame=
ters.
> + * @get_preempt: Get the network device Frame Preemption parameters.
> + * @set_preempt: Set the network device Frame Preemption parameters.
>   * @get_ethtool_phy_stats: Return extended statistics about the PHY devi=
ce.
>   *	This is only useful if the device maintains PHY statistics and
>   *	cannot use the standard PHY library helpers.
> @@ -675,6 +690,10 @@ struct ethtool_ops {
>  				      struct ethtool_fecparam *);
>  	int	(*set_fecparam)(struct net_device *,
>  				      struct ethtool_fecparam *);
> +	int	(*get_preempt)(struct net_device *,
> +			       struct ethtool_fp *);
> +	int	(*set_preempt)(struct net_device *, struct ethtool_fp *,
> +			       struct netlink_ext_ack *);
>  	void	(*get_ethtool_phy_stats)(struct net_device *,
>  					 struct ethtool_stats *, u64 *);
>  	int	(*get_phy_tunable)(struct net_device *,
> @@ -766,4 +785,7 @@ ethtool_params_from_link_mode(struct ethtool_link_kse=
ttings *link_ksettings,
>   * next string.
>   */
>  extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, .=
..);
> +
> +u8 ethtool_frag_size_to_mult(u32 frag_size);
> +
>  #endif /* _LINUX_ETHTOOL_H */
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/et=
htool_netlink.h
> index c7135c9c37a5..4600aba1c693 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -44,6 +44,8 @@ enum {
>  	ETHTOOL_MSG_TUNNEL_INFO_GET,
>  	ETHTOOL_MSG_FEC_GET,
>  	ETHTOOL_MSG_FEC_SET,
> +	ETHTOOL_MSG_PREEMPT_GET,
> +	ETHTOOL_MSG_PREEMPT_SET,
>  	ETHTOOL_MSG_MODULE_EEPROM_GET,
>  	ETHTOOL_MSG_STATS_GET,
> =20
> @@ -86,6 +88,8 @@ enum {
>  	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
>  	ETHTOOL_MSG_FEC_GET_REPLY,
>  	ETHTOOL_MSG_FEC_NTF,
> +	ETHTOOL_MSG_PREEMPT_GET_REPLY,
> +	ETHTOOL_MSG_PREEMPT_NTF,
>  	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
>  	ETHTOOL_MSG_STATS_GET_REPLY,

Correct me if I'm wrong, but enums in uapi should always be added at the
end, otherwise you break value with user space binaries which use
ETHTOOL_MSG_MODULE_EEPROM_GET and are compiled against old kernel
headers.

> =20
> @@ -664,6 +668,19 @@ enum {
>  	ETHTOOL_A_FEC_STAT_MAX =3D (__ETHTOOL_A_FEC_STAT_CNT - 1)
>  };
> =20
> +/* FRAME PREEMPTION */
> +
> +enum {
> +	ETHTOOL_A_PREEMPT_UNSPEC,
> +	ETHTOOL_A_PREEMPT_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PREEMPT_ENABLED,			/* u8 */
> +	ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,		/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PREEMPT_CNT,
> +	ETHTOOL_A_PREEMPT_MAX =3D (__ETHTOOL_A_PREEMPT_CNT - 1)
> +};
> +
>  /* MODULE EEPROM */
> =20
>  enum {
> diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
> index 723c9a8a8cdf..4b84b2d34c7a 100644
> --- a/net/ethtool/Makefile
> +++ b/net/ethtool/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+=3D ethtool_nl.o
>  ethtool_nl-y	:=3D netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
>  		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
>  		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
> -		   tunnels.o fec.o eeprom.o stats.o
> +		   tunnels.o fec.o preempt.o eeprom.o stats.o
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index f9dcbad84788..68d123dd500b 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -579,3 +579,28 @@ ethtool_params_from_link_mode(struct ethtool_link_ks=
ettings *link_ksettings,
>  	link_ksettings->base.duplex =3D link_info->duplex;
>  }
>  EXPORT_SYMBOL_GPL(ethtool_params_from_link_mode);
> +
> +/**
> + * ethtool_frag_size_to_mult() - Convert from a Frame Preemption
> + * Additional Fragment size in bytes to a multiplier.
> + * @frag_size: minimum non-final fragment size in bytes.
> + *
> + * The multiplier is defined as:
> + *	"A 2-bit integer value used to indicate the minimum size of
> + *	non-final fragments supported by the receiver on the given port
> + *	associated with the local System. This value is expressed in units
> + *	of 64 octets of additional fragment length."
> + *	Equivalent to `30.14.1.7 aMACMergeAddFragSize` from the IEEE 802.3-20=
18
> + *	standard.
> + *
> + * Return: the multiplier is a number in the [0, 2] interval.
> + */
> +u8 ethtool_frag_size_to_mult(u32 frag_size)
> +{
> +	u8 mult =3D (frag_size / 64) - 1;
> +
> +	mult =3D clamp_t(u8, mult, 0, 3);
> +
> +	return mult;

I think it would look better as "return clamp_t(u8, mult, 0, 3);"

> +}
> +EXPORT_SYMBOL_GPL(ethtool_frag_size_to_mult);
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index a7346346114f..f4e07b740790 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -246,6 +246,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] =3D {
>  	[ETHTOOL_MSG_EEE_GET]		=3D &ethnl_eee_request_ops,
>  	[ETHTOOL_MSG_FEC_GET]		=3D &ethnl_fec_request_ops,
>  	[ETHTOOL_MSG_TSINFO_GET]	=3D &ethnl_tsinfo_request_ops,
> +	[ETHTOOL_MSG_PREEMPT_GET]	=3D &ethnl_preempt_request_ops,
>  	[ETHTOOL_MSG_MODULE_EEPROM_GET]	=3D &ethnl_module_eeprom_request_ops,
>  	[ETHTOOL_MSG_STATS_GET]		=3D &ethnl_stats_request_ops,
>  };
> @@ -561,6 +562,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] =
=3D {
>  	[ETHTOOL_MSG_PAUSE_NTF]		=3D &ethnl_pause_request_ops,
>  	[ETHTOOL_MSG_EEE_NTF]		=3D &ethnl_eee_request_ops,
>  	[ETHTOOL_MSG_FEC_NTF]		=3D &ethnl_fec_request_ops,
> +	[ETHTOOL_MSG_PREEMPT_NTF]	=3D &ethnl_preempt_request_ops,
>  };
> =20
>  /* default notification handler */
> @@ -654,6 +656,7 @@ static const ethnl_notify_handler_t ethnl_notify_hand=
lers[] =3D {
>  	[ETHTOOL_MSG_PAUSE_NTF]		=3D ethnl_default_notify,
>  	[ETHTOOL_MSG_EEE_NTF]		=3D ethnl_default_notify,
>  	[ETHTOOL_MSG_FEC_NTF]		=3D ethnl_default_notify,
> +	[ETHTOOL_MSG_PREEMPT_NTF]	=3D ethnl_default_notify,
>  };
> =20
>  void ethtool_notify(struct net_device *dev, unsigned int cmd, const void=
 *data)
> @@ -958,6 +961,22 @@ static const struct genl_ops ethtool_genl_ops[] =3D =
{
>  		.policy =3D ethnl_stats_get_policy,
>  		.maxattr =3D ARRAY_SIZE(ethnl_stats_get_policy) - 1,
>  	},
> +	{
> +		.cmd	=3D ETHTOOL_MSG_PREEMPT_GET,
> +		.doit	=3D ethnl_default_doit,
> +		.start	=3D ethnl_default_start,
> +		.dumpit	=3D ethnl_default_dumpit,
> +		.done	=3D ethnl_default_done,
> +		.policy =3D ethnl_preempt_get_policy,
> +		.maxattr =3D ARRAY_SIZE(ethnl_preempt_get_policy) - 1,
> +	},
> +	{
> +		.cmd	=3D ETHTOOL_MSG_PREEMPT_SET,
> +		.flags	=3D GENL_UNS_ADMIN_PERM,
> +		.doit	=3D ethnl_set_preempt,
> +		.policy =3D ethnl_preempt_set_policy,
> +		.maxattr =3D ARRAY_SIZE(ethnl_preempt_set_policy) - 1,
> +	},
>  };
> =20
>  static const struct genl_multicast_group ethtool_nl_mcgrps[] =3D {
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index 3e25a47fd482..cc90a463a81c 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_pause_req=
uest_ops;
>  extern const struct ethnl_request_ops ethnl_eee_request_ops;
>  extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
>  extern const struct ethnl_request_ops ethnl_fec_request_ops;
> +extern const struct ethnl_request_ops ethnl_preempt_request_ops;
>  extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
>  extern const struct ethnl_request_ops ethnl_stats_request_ops;
> =20
> @@ -381,6 +382,8 @@ extern const struct nla_policy ethnl_tunnel_info_get_=
policy[ETHTOOL_A_TUNNEL_INF
>  extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER=
 + 1];
>  extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO +=
 1];
>  extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_=
MODULE_EEPROM_I2C_ADDRESS + 1];
> +extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMP=
T_HEADER + 1];
> +extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMP=
T_ADD_FRAG_SIZE + 1];
>  extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GR=
OUPS + 1];
> =20
>  int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
> @@ -400,6 +403,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struc=
t genl_info *info);
>  int ethnl_tunnel_info_start(struct netlink_callback *cb);
>  int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callbac=
k *cb);
>  int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
> +int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info);
> =20
>  extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
>  extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH=
_GSTRING_LEN];
> diff --git a/net/ethtool/preempt.c b/net/ethtool/preempt.c
> new file mode 100644
> index 000000000000..4f96d3c2b1d5
> --- /dev/null
> +++ b/net/ethtool/preempt.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include "netlink.h"
> +#include "common.h"
> +
> +struct preempt_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct preempt_reply_data {
> +	struct ethnl_reply_data		base;
> +	struct ethtool_fp		fp;
> +};
> +
> +#define PREEMPT_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct preempt_reply_data, base)
> +
> +const struct nla_policy
> +ethnl_preempt_get_policy[] =3D {
> +	[ETHTOOL_A_PREEMPT_HEADER]		=3D NLA_POLICY_NESTED(ethnl_header_policy),
> +};
> +
> +static int preempt_prepare_data(const struct ethnl_req_info *req_base,
> +				struct ethnl_reply_data *reply_base,
> +				struct genl_info *info)
> +{
> +	struct preempt_reply_data *data =3D PREEMPT_REPDATA(reply_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_preempt)
> +		return -EOPNOTSUPP;
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D dev->ethtool_ops->get_preempt(dev, &data->fp);
> +	ethnl_ops_complete(dev);
> +
> +	return ret;
> +}
> +
> +static int preempt_reply_size(const struct ethnl_req_info *req_base,
> +			      const struct ethnl_reply_data *reply_base)
> +{
> +	int len =3D 0;
> +
> +	len +=3D nla_total_size(sizeof(u8)); /* _PREEMPT_ENABLED */
> +	len +=3D nla_total_size(sizeof(u32)); /* _PREEMPT_ADD_FRAG_SIZE */
> +
> +	return len;
> +}
> +
> +static int preempt_fill_reply(struct sk_buff *skb,
> +			      const struct ethnl_req_info *req_base,
> +			      const struct ethnl_reply_data *reply_base)
> +{
> +	const struct preempt_reply_data *data =3D PREEMPT_REPDATA(reply_base);
> +	const struct ethtool_fp *preempt =3D &data->fp;
> +
> +	if (nla_put_u8(skb, ETHTOOL_A_PREEMPT_ENABLED, preempt->enabled))
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE,
> +			preempt->add_frag_size))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +const struct ethnl_request_ops ethnl_preempt_request_ops =3D {
> +	.request_cmd		=3D ETHTOOL_MSG_PREEMPT_GET,
> +	.reply_cmd		=3D ETHTOOL_MSG_PREEMPT_GET_REPLY,
> +	.hdr_attr		=3D ETHTOOL_A_PREEMPT_HEADER,
> +	.req_info_size		=3D sizeof(struct preempt_req_info),
> +	.reply_data_size	=3D sizeof(struct preempt_reply_data),
> +
> +	.prepare_data		=3D preempt_prepare_data,
> +	.reply_size		=3D preempt_reply_size,
> +	.fill_reply		=3D preempt_fill_reply,
> +};
> +
> +const struct nla_policy
> +ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_MAX + 1] =3D {
> +	[ETHTOOL_A_PREEMPT_HEADER]			=3D NLA_POLICY_NESTED(ethnl_header_policy)=
,
> +	[ETHTOOL_A_PREEMPT_ENABLED]			=3D NLA_POLICY_RANGE(NLA_U8, 0, 1),
> +	[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE]		=3D { .type =3D NLA_U32 },
> +};
> +
> +int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ethnl_req_info req_info =3D {};
> +	struct nlattr **tb =3D info->attrs;
> +	struct ethtool_fp preempt =3D {};
> +	struct net_device *dev;
> +	bool mod =3D false;
> +	int ret;
> +
> +	ret =3D ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_PREEMPT_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +	dev =3D req_info.dev;
> +	ret =3D -EOPNOTSUPP;

Some new lines around here please? And maybe it would look a bit cleaner
if you could assign "ret =3D -EOPNOTSUPP" in the "preempt ops not present"
if condition body?

> +	if (!dev->ethtool_ops->get_preempt ||
> +	    !dev->ethtool_ops->set_preempt)
> +		goto out_dev;
> +
> +	rtnl_lock();
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_rtnl;
> +
> +	ret =3D dev->ethtool_ops->get_preempt(dev, &preempt);

I don't know much about the background of ethtool netlink, but why does
the .doit of ETHTOOL_MSG_*_SET go through a getter first? Is it because
all the netlink attributes from the message are optional, and we need to
default to the current state?

> +	if (ret < 0) {
> +		GENL_SET_ERR_MSG(info, "failed to retrieve frame preemption settings")=
;
> +		goto out_ops;
> +	}
> +
> +	ethnl_update_u8(&preempt.enabled,
> +			tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
> +	ethnl_update_u32(&preempt.add_frag_size,
> +			 tb[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE], &mod);
> +	ret =3D 0;

This reinitialization of ret to zero is interesting. It implies
->get_preempt() is allowed to return > 0 as a success error code.
However ->set_preempt() below isn't? (its return value is directly
propagated to callers of ethnl_set_preempt().

> +	if (!mod)
> +		goto out_ops;
> +
> +	ret =3D dev->ethtool_ops->set_preempt(dev, &preempt, info->extack);
> +	if (ret < 0) {
> +		GENL_SET_ERR_MSG(info, "frame preemption settings update failed");
> +		goto out_ops;
> +	}
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_PREEMPT_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev:
> +	dev_put(dev);
> +	return ret;
> +}
> --=20
> 2.32.0
> =
