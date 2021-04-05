Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DDC354686
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhDESG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:06:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:57773 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhDESGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 14:06:25 -0400
IronPort-SDR: D7FmQOSSR6hDgFfbXIWmF76t6Guqv5dKHOADRjV3cgUduVIInvJqu/fAqTx34c4KwtOTiRAceX
 Cn+Yuy/DlMLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="189678685"
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="189678685"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 11:06:18 -0700
IronPort-SDR: Wid4jYaT7iR6HusUhyJU8OHYpweLwxHkvGEIKF/czBO21TFa9pS7R7o0IijhvU/hbFOGZVgyF5
 CHymeLuWBqvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="448153126"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2021 11:06:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 5 Apr 2021 11:06:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 5 Apr 2021 11:06:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 5 Apr 2021 11:06:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixW3BVbb7pWZA3y3UMbGaalN88sS0tD4ovb7w9KPo6xif45Z9seY7kn7idLfh0OBCrYQC8S+ObYEYEOIpY34bq+1ynqXteHERvbhemFlrVLogqKC5LuKoPLKtAuIhecnDXvk7gJsns8dGUj39y8boDvP1Ng0L92wE/FJLtmefJk85TH6wsOAmP0xJsu5zJxSWhnJUSb2xPFSPB5Bk/H2k133Q4AJU9mkZRoKqBSvhPq/33paDdrd47W+BqslLCtA+cgRDozVH6epqRZXzWJHZYEkRaBObAqYvHkcVDvrYG4p/96bLin/RdaQQXy0zUQrBSp7ixVFjUHvgcmOybrlkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZxD7zKCAT195Qz69Etwna9smxfz8LfXOF1XyWDYbHI=;
 b=ltO0VI/uMFzCLqTP8/N19uJOWUPTmsEO6nhEiCYe6Px4sxwiDYSrXYbkfnFNhliBpL0cpLgpD+Gr6rhF4ebyTXxEj5jTIVeD9EkAUl8NEpELB+r1QtqW0PHgTYrID7TXvQMpXuXCf+vzVtkjsgCChXhGDpOzRtVUrseokTgTuVDhT6FkhWBz89V5NDynHduN73c8LFirmxEs+bo1cLFFISmzYXcbuUypygD4tcMFBRyT+I8IHwHpqupHe+rXWhJ8iwZg3Z85FJ4Ub/EpuPMWuLROymau1dXocT/WoS+bHu91ep8wLybg7E+okWC6gHvU85E/RPtDAgpQNCVTvGBHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZxD7zKCAT195Qz69Etwna9smxfz8LfXOF1XyWDYbHI=;
 b=rrgKZm26OsB82q1zFQ5rvvtvG21XclQjE11kiSq6LkbQTQFh12JUQ3NcmSDvZMbce/RuS8vwxr7joru65syx73UiSaPHjaqQlQN5CkPsxA4faSUyW21kT1n75TTizXHc2XlmqEcDc5UtJQYr4cRAfNe4hl1qVDYS0bmKdn9h1Rs=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Mon, 5 Apr
 2021 18:06:16 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::e9ed:af43:83bb:e111]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::e9ed:af43:83bb:e111%5]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 18:06:16 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH net-next] net: intel: Enable SERDES PHY rx clk for PSE
Thread-Topic: [PATCH net-next] net: intel: Enable SERDES PHY rx clk for PSE
Thread-Index: AQHXKjl+rky0JfTKSkKXgsaYG/rI46qmN/cg
Date:   Mon, 5 Apr 2021 18:06:16 +0000
Message-ID: <BYAPR11MB28702C161D1C95E0D5C3A64AAB779@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20210405163357.30902-1-weifeng.voon@intel.com>
In-Reply-To: <20210405163357.30902-1-weifeng.voon@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [218.111.199.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed84d6be-37d7-455d-775f-08d8f85d81f2
x-ms-traffictypediagnostic: SJ0PR11MB4989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4989AD54179C264ED8BA12B4AB779@SJ0PR11MB4989.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:334;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /pBv9re0HLdDluenldANEbX03p0i6tHJ0i5ugkgtrPtezHfX9XTzaiF9rsK+MaKs8e9kp1WuffXIDLsqQcPSGgMiUtfIIDi69f0dAyAaSMXBF2pKqb3x8oPS0DjcdoR0SH7Ix6Q0Um2BC/WjOayTxNmvHu9SvtUQH2ApgKMQTvR1WkK1EB+vK75IuYGYeW8o9l+HETGPuZtlTd6uD3s97A/Npmu73YoJRNv0RNhAeR6b2Qg+PtnDeS+hxMKUJDPspdrm1NfZa8b/1IUpE+IFsF271m9TIj6p0B9ZkRlk6jlgUxYcQCCse0+mNqBPqf1r60TEtgriF1kn8HmzTJFBQBP/M+laKliPO9hUOgcGGDEBHOsm6SE6NyoGvN7OBRA652AsooJcVLpfcegtZaE/l1JtBoF7SFtqMbXCuIGQh0eReLCAVWNtwRiQ0YErrpY1yPwvoXurp3luDqyA9Y8VW+TaX01cyYF7psW4XIBi1uQ8ykJzb4sdjOXr8cIC/pBN/4VDHgRGwOIOvZLUZ5G5Qe2vR4l6N7ug26/uV8M9fhFzQ2c5VVfu1GwXJzxLN2M0A1n3jfS606ZneXj2Z0Znp2HzlI3v/UZpeeGKjWOPXKePys/I0eU/aF1GNBPWLFifG0Aol+v03dJqWNKQK7a/o2IuIhXSB15N+zZF+ToXTMA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(8676002)(5660300002)(8936002)(66476007)(110136005)(52536014)(316002)(55016002)(4326008)(86362001)(2906002)(9686003)(38100700001)(66446008)(66946007)(7416002)(76116006)(478600001)(186003)(33656002)(66556008)(71200400001)(26005)(107886003)(83380400001)(64756008)(7696005)(6506007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E92luENUnEVJZO8w39/38gH+0q+RuEKeeHTiBO2kvMKjZLoREEOC/s6szKTm?=
 =?us-ascii?Q?YmbDFhzTQ1hPU4n2WoyVobAzCWjTXEZFi/rUz1OcO3IMXQe0ToqefJs03Cdh?=
 =?us-ascii?Q?H/1pErxpOQlX+WOi+xQnvbiPgJkXFSKiOJmGdh5bG3nS5W0zg4i7uusSQ15x?=
 =?us-ascii?Q?x8mgFoXSN7go33MauRnNmK+GvsbMHzH9juSdZfXv6IWmIVQzx0i5gJeLoIl1?=
 =?us-ascii?Q?O36k8suUNf0kuGlYikrZfYDras1EdVhy+nJLk2w6pjCZKUrd39u9V7FiGEnw?=
 =?us-ascii?Q?oAd4dMrLT2Fg1gc+2IqJbQW4uu/QeZr4N3QviCtt2PhKNK50m2pqhSl6E2vf?=
 =?us-ascii?Q?8XIbGyixQUikuqFoy5fyPMvMl2kwyLbuOQ7nMVoKO7od8iJ5miRwREiFRPp1?=
 =?us-ascii?Q?D6zPuv72sHBvi1Iv0dVHs5x3CnXjQIFqgui2KYEhX7/XeX5SlKciaByM4Mc5?=
 =?us-ascii?Q?IXEyw2T9AH7CGdjxc9ApGPyVrqgDNn+YpujWqooFMlRWrMj6cepdEjd2SGEV?=
 =?us-ascii?Q?u36oog5jwsfQMyjBKHQOBQnH24DHsWXLJqtcb8oys/prN53NG73/M60dnCkp?=
 =?us-ascii?Q?a+gZb9YhYhTaoSShV6hlmgkSTvtd5yigmApXEXv8s+pWSY0pP6QsHbOEcHXO?=
 =?us-ascii?Q?XDnM22Q9Pg8DdxRdMF4GER63CGWqUZJ2YkDF4dl3iKZT5l1Z7+r7tLKGenLc?=
 =?us-ascii?Q?ZLKk9AKHAffWrQqyLnPmDCR3+Qcn4ar/avfluGtSpllV+RLY95M6DVC8cCUN?=
 =?us-ascii?Q?EmwsZusFThXV57l4EOOO6N4pzeKzfGYM4OOf1hVcTgqmm99U4Lsmsi0zCxCl?=
 =?us-ascii?Q?UZ0dcaw4Rr5OUzs5qOcjnmq5yxZ3KRYPJQK5zFouOXcfnFcLhgzwWAxUEgjx?=
 =?us-ascii?Q?8dfL+jPxU+unSdoTTaD9qcLz0EZ/v9zR4BF2RKYnk0J7r3XmrzrLbcMPrPoE?=
 =?us-ascii?Q?ojLKVWCwVjZ0Rd3BqbL9a5HeEH0GdqJyguKqFzo/ODKplVj6PLf6a36G0r4N?=
 =?us-ascii?Q?2otMWi9bhXhSRDoWC44/S6yvl4jQS5i/+SqXMxkFa7PJTqZ/CFTiA8awD6fj?=
 =?us-ascii?Q?ZU1h5gErXqfBqrtK9lYN63KzHTKDMP/UbGZ5pS1rHgV5O/ckZsYU4kzsqUE8?=
 =?us-ascii?Q?eduaKqj7QuLNcCNimMH1j2ePNVbGHvUQTpUAGYTf94o6Mg/nTYkidJBCaqB4?=
 =?us-ascii?Q?9SKoFMVBqd+u8ei0Sh2zcymEtLj6++VX97HzWF3s0t/4wMkMY16A8CcNzRbE?=
 =?us-ascii?Q?2t7oAbPDTvQYKDyW+Tq4of/KbDos15uQlu3TAfij2bMp7UGc579+7d0jYcAe?=
 =?us-ascii?Q?JYBZtm9WY3LCgUoPLfj8Hh3V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed84d6be-37d7-455d-775f-08d8f85d81f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 18:06:16.7553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxDb8y6kv1m9hk2GueKo00nbzKl33s+TDEEr81QecKRSYFSoMs2I6TC41HKFqj4JtuyD/87LeY9O8+eqX9+MLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4989
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 12:33:57AM +0800, Voon Weifeng wrote:=20
>
> EHL PSE SGMII mode requires to ungate the SERDES PHY rx clk for power up
> sequence and vice versa.
>=20
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 10 ++++++++++
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h |  1 +
>  2 files changed, 11 insertions(+)
>=20

Why not use "stmmac: intel" for the commit message header?


> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index add95e20548d..a4fec5fe0779 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -153,6 +153,11 @@ static int intel_serdes_powerup(struct net_device
> *ndev, void *priv_data)
>  		return data;
>  	}
>=20
> +	/* PSE only - ungate SGMII PHY Rx Clock */
> +	if (intel_priv->is_pse)
> +		mdiobus_modify(priv->mii, serdes_phy_addr, SERDES_GCR0,
> +			       0, SERDES_PHY_RX_CLK);
> +
>  	return 0;
>  }
>=20
> @@ -168,6 +173,11 @@ static void intel_serdes_powerdown(struct
> net_device *ndev, void *intel_data)
>=20
>  	serdes_phy_addr =3D intel_priv->mdio_adhoc_addr;
>=20
> +	/* PSE only - gate SGMII PHY Rx Clock */
> +	if (intel_priv->is_pse)
> +		mdiobus_modify(priv->mii, serdes_phy_addr, SERDES_GCR0,
> +			       SERDES_PHY_RX_CLK, 0);
> +
>  	/*  move power state to P3 */
>  	data =3D mdiobus_read(priv->mii, serdes_phy_addr, SERDES_GCR0);
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
> b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
> index e723096c0b15..542acb8ce467 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
> @@ -14,6 +14,7 @@
>=20
>  /* SERDES defines */
>  #define SERDES_PLL_CLK		BIT(0)		/* PLL clk valid signal
> */
> +#define SERDES_PHY_RX_CLK	BIT(1)		/* PSE SGMII PHY rx clk */
>  #define SERDES_RST		BIT(2)		/* Serdes Reset */
>  #define SERDES_PWR_ST_MASK	GENMASK(6, 4)	/* Serdes Power
> state*/
>  #define SERDES_PWR_ST_SHIFT	4
> --
> 2.17.1

