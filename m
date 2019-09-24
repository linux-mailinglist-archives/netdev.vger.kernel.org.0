Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E442ABC900
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbfIXNiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:38:17 -0400
Received: from mail-eopbgr1370100.outbound.protection.outlook.com ([40.107.137.100]:48736
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729755AbfIXNiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 09:38:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMvffb8LotgEiNQCnAURuPwz28a6bumLSpH1GX2Qps1XiLhvwf6aVfKx6T7I7xanptWoUxjIU5g3r2RlYIK/45ggt7cL0/7bsPtFX6Y1CJvVvINjo+ikVjF7tDLFZ/kSuwibMyqQw9wdPPqUS2d4F+6tbg9/9LpM7RUM9NTiFuw+/lkax8jaIt6MGCVgXsDiML8KkxOJzpNeZjnpD+sLlOekxVVgirqkNQFnGEiLp8dMqKXc6l2gNZI/H4nUasSxUr9uM7SGd0FkDFvIZtfhbfM+VgtgXe4MKDVduMDkKo+VD0pN6SzADiFJmpW/JvOCsk8/Em/m7VN8Z5FWjH0CHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y75lJaKnJaee/OV0E3EHauu8hXqQym/VMovqOA7XEEs=;
 b=f8Fg3cUsZ6C2j4vPzPKsbuohyjbaN56advT1ZKh+4AGTXK8dRvhMP8gWlrjLKO6SzhU2YKGu6DG8jmqt/6eU4cH69u/U3Y18E0Dxng+YKxtu1VH80k0hBxTik1E8JgJ49MC4pqX9RLvRLKe5oMdooC/YX4K0GbngLvzTHOxJDptbCe3W+3nLDZld5yQlqmt8tC6wpqpcIarz69gr6laCiIg7gMxsd4Ia45qbjYE35ZV6ZkXpvAMcD7vYdkOJwWNZIWOxzOibT5B4JbBXGfJw4GsFVnOXH4AiQMgRFzplTSnOdwENO21xnZg6Fr5jBYMWsvdGCScUh76/2TYsKjfcjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gallagher.com; dmarc=pass action=none
 header.from=gallagher.com; dkim=pass header.d=gallagher.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gallagher.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y75lJaKnJaee/OV0E3EHauu8hXqQym/VMovqOA7XEEs=;
 b=ZUzuhCjCyjuILswDc0ukx1wiSDCwvQe4yHJvEstlFTVUgByWCn6OlEcZLt4v2E+naDeX/LXfc2MWfoXOxbhln0iLDaxN+hqxSKfk/rtg2Uo3n77Bm9vKCBm4RSjd9STtUQ7vVnmf+/KC6uMHmxnom4b7yAIYLjEe5oYNjt4SnaY=
Received: from ME2PR01MB4738.ausprd01.prod.outlook.com (20.178.183.211) by
 ME2PR01MB4420.ausprd01.prod.outlook.com (20.178.181.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Tue, 24 Sep 2019 13:38:05 +0000
Received: from ME2PR01MB4738.ausprd01.prod.outlook.com
 ([fe80::6de7:80f:8c28:c734]) by ME2PR01MB4738.ausprd01.prod.outlook.com
 ([fe80::6de7:80f:8c28:c734%7]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 13:38:05 +0000
From:   Ankur Tyagi <Ankur.Tyagi@gallagher.com>
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
CC:     "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Tero Kristo <t-kristo@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 2/3] clk: let init callback return an error code
Thread-Topic: [PATCH 2/3] clk: let init callback return an error code
Thread-Index: AQHVctU+ONvXcFNRfESvAcFRe7yg/Kc606oQ
Date:   Tue, 24 Sep 2019 13:38:05 +0000
Message-ID: <ME2PR01MB4738B127557AE20F6315AA7FE5840@ME2PR01MB4738.ausprd01.prod.outlook.com>
References: <20190924123954.31561-1-jbrunet@baylibre.com>
 <20190924123954.31561-3-jbrunet@baylibre.com>
In-Reply-To: <20190924123954.31561-3-jbrunet@baylibre.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ankur.Tyagi@gallagher.com; 
x-originating-ip: [203.167.229.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dac144af-cc71-4fe9-8738-08d740f46dd5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:ME2PR01MB4420;
x-ms-traffictypediagnostic: ME2PR01MB4420:
x-microsoft-antispam-prvs: <ME2PR01MB4420E9A89746FF2B6BFCDC3AE5840@ME2PR01MB4420.ausprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(376002)(346002)(39850400004)(136003)(13464003)(199004)(189003)(2906002)(6506007)(53546011)(102836004)(478600001)(74316002)(26005)(186003)(25786009)(14444005)(7736002)(305945005)(7416002)(5024004)(256004)(71190400001)(33656002)(71200400001)(3846002)(6116002)(7696005)(76176011)(86362001)(66066001)(8936002)(81166006)(81156014)(8676002)(486006)(229853002)(6246003)(54906003)(52536014)(11346002)(446003)(76116006)(5660300002)(476003)(4326008)(316002)(110136005)(6436002)(30864003)(99286004)(14454004)(9686003)(55016002)(66946007)(64756008)(66446008)(66476007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:ME2PR01MB4420;H:ME2PR01MB4738.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: gallagher.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GrAE5Kqadt1gj7twNSEA/hxID/RzakrfdsWTG0lHnlaZSNNSVMTljhVtjXOoqxo37SeXqZ+0+LF1O35ZadxNlsQ2wZM6/MNDXjrKDKU1nUBqFeiKGbnvFi66pwa6duh93sWrVzH2tflYYyR7m/2Su2IykR2obNZ13ENoR3saPRdXGcbsnSoCylXNYhoqpZmTKegU21vBNnG2YR2o/eJrlMjtukHx7a2v6b7NZnDoAtQFhQLMwmj/afUaph5L02dy5xDQVZ3Kpd+bnNeE4HR9Wc7Qb2qQc9H0+JXcDLWZNAKAWBiAtxJm6ZgUVXbgU+Svz/vqtI8oRidC1Dx8zYt6hN0IyUeVi8q+5c4x9gL/RDlwFUTOxsmWhD/4XO4usAo4vHBb210cAETFd/bVBcbhIQwj02RDK9w7OkPfB+1I1yY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: gallagher.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac144af-cc71-4fe9-8738-08d740f46dd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 13:38:05.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2156b869-431f-4815-b2ce-b4893b5c9aaa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F98JwQh4d9CpP9hNGcDicBVRyHYXhRrYj8hcuHmGY8wyJ9+z32hRwvs9bqfHkpCc4K5zHXercW1Go5lqv6sZe8tWbVwC9yTTyaE/jEgxeTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME2PR01MB4420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am no expert here but just looked at the patch and found few
discrepancy that I have mentioned inline.

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org <linux-omap-
> owner@vger.kernel.org> On Behalf Of Jerome Brunet
> Sent: Wednesday, 25 September 2019 12:40 AM
> To: Michael Turquette <mturquette@baylibre.com>; Stephen Boyd
> <sboyd@kernel.org>
> Cc: Jerome Brunet <jbrunet@baylibre.com>; linux-clk@vger.kernel.org; linu=
x-
> kernel@vger.kernel.org; Heiko Stuebner <heiko@sntech.de>; Tero Kristo <t-
> kristo@ti.com>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
> <f.fainelli@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>; David S.
> Miller <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> amlogic@lists.infradead.org; linux-arm-msm@vger.kernel.org; linux-
> rockchip@lists.infradead.org; linux-omap@vger.kernel.org
> Subject: [PATCH 2/3] clk: let init callback return an error code
>
> If the init callback is allowed to request resources, it needs a return
> value to report the outcome of such a request.
>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
>
>  Sorry about the spam.
>  This patch change quite a few files so I have tried to Cc the
>  relevant people. Stephen, You may notice that I have added a
>  couple of the network people. You need an Ack from one of them
>  since the Amlogic G12a mdio mux has a clock which uses the .init()
>  callback
>
>  drivers/clk/clk.c                     | 17 ++++++++++------
>  drivers/clk/meson/clk-mpll.c          |  4 +++-
>  drivers/clk/meson/clk-phase.c         |  4 +++-
>  drivers/clk/meson/clk-pll.c           |  4 +++-
>  drivers/clk/meson/sclk-div.c          |  4 +++-
>  drivers/clk/microchip/clk-core.c      |  8 ++++++--
>  drivers/clk/mmp/clk-frac.c            |  4 +++-
>  drivers/clk/mmp/clk-mix.c             |  4 +++-
>  drivers/clk/qcom/clk-hfpll.c          |  6 ++++--
>  drivers/clk/rockchip/clk-pll.c        | 28 ++++++++++++++++-----------
>  drivers/clk/ti/clock.h                |  2 +-
>  drivers/clk/ti/clockdomain.c          |  8 +++++---
>  drivers/net/phy/mdio-mux-meson-g12a.c |  4 +++-
>  include/linux/clk-provider.h          | 10 +++++++---
>  14 files changed, 72 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 232144cca6cf..df853a98fad2 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -3298,16 +3298,21 @@ static int __clk_core_init(struct clk_core *core)
>   * optional platform-specific magic
>   *
>   * The .init callback is not used by any of the basic clock types, but
> - * exists for weird hardware that must perform initialization magic.
> - * Please consider other ways of solving initialization problems before
> - * using this callback, as its use is discouraged.
> + * exists for weird hardware that must perform initialization magic for
> + * CCF to get an accurate view of clock for any other callbacks. It may
> + * also be used needs to perform dynamic allocations. Such allocation
> + * must be freed in the terminate() callback.
> + * This callback shall not be used to initialize the parameters state,
> + * such as rate, parent, etc ...
>   *
>   * If it exist, this callback should called before any other callback of
>   * the clock
>   */
> -if (core->ops->init)
> -core->ops->init(core->hw);
> -
> +if (core->ops->init) {
> +ret =3D core->ops->init(core->hw);
> +if (ret)
> +goto out;
> +}
>
>  core->parent =3D __clk_init_parent(core);
>
> diff --git a/drivers/clk/meson/clk-mpll.c b/drivers/clk/meson/clk-mpll.c
> index 2d39a8bc367c..fc9df4860872 100644
> --- a/drivers/clk/meson/clk-mpll.c
> +++ b/drivers/clk/meson/clk-mpll.c
> @@ -129,7 +129,7 @@ static int mpll_set_rate(struct clk_hw *hw,
>  return 0;
>  }
>
> -static void mpll_init(struct clk_hw *hw)
> +static int mpll_init(struct clk_hw *hw)
>  {
>  struct clk_regmap *clk =3D to_clk_regmap(hw);
>  struct meson_clk_mpll_data *mpll =3D meson_clk_mpll_data(clk);
> @@ -151,6 +151,8 @@ static void mpll_init(struct clk_hw *hw)
>  /* Set the magic misc bit if required */
>  if (MESON_PARM_APPLICABLE(&mpll->misc))
>  meson_parm_write(clk->map, &mpll->misc, 1);
> +
> +return 0;
>  }
>
>  const struct clk_ops meson_clk_mpll_ro_ops =3D {
> diff --git a/drivers/clk/meson/clk-phase.c b/drivers/clk/meson/clk-phase.=
c
> index 80c3ada193a4..fe22e171121a 100644
> --- a/drivers/clk/meson/clk-phase.c
> +++ b/drivers/clk/meson/clk-phase.c
> @@ -78,7 +78,7 @@ meson_clk_triphase_data(struct clk_regmap *clk)
>  return (struct meson_clk_triphase_data *)clk->data;
>  }
>
> -static void meson_clk_triphase_sync(struct clk_hw *hw)
> +static int meson_clk_triphase_sync(struct clk_hw *hw)
>  {
>  struct clk_regmap *clk =3D to_clk_regmap(hw);
>  struct meson_clk_triphase_data *tph =3D meson_clk_triphase_data(clk);
> @@ -88,6 +88,8 @@ static void meson_clk_triphase_sync(struct clk_hw *hw)
>  val =3D meson_parm_read(clk->map, &tph->ph0);
>  meson_parm_write(clk->map, &tph->ph1, val);
>  meson_parm_write(clk->map, &tph->ph2, val);
> +
> +return 0;
>  }
>
>  static int meson_clk_triphase_get_phase(struct clk_hw *hw)
> diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
> index ddb1e5634739..489092dde3a6 100644
> --- a/drivers/clk/meson/clk-pll.c
> +++ b/drivers/clk/meson/clk-pll.c
> @@ -277,7 +277,7 @@ static int meson_clk_pll_wait_lock(struct clk_hw *hw)
>  return -ETIMEDOUT;
>  }
>
> -static void meson_clk_pll_init(struct clk_hw *hw)
> +static int meson_clk_pll_init(struct clk_hw *hw)
>  {
>  struct clk_regmap *clk =3D to_clk_regmap(hw);
>  struct meson_clk_pll_data *pll =3D meson_clk_pll_data(clk);
> @@ -288,6 +288,8 @@ static void meson_clk_pll_init(struct clk_hw *hw)
>         pll->init_count);
>  meson_parm_write(clk->map, &pll->rst, 0);
>  }
> +
> +return 0;
>  }
>
>  static int meson_clk_pll_is_enabled(struct clk_hw *hw)
> diff --git a/drivers/clk/meson/sclk-div.c b/drivers/clk/meson/sclk-div.c
> index 3acf03780221..76d31c0a3342 100644
> --- a/drivers/clk/meson/sclk-div.c
> +++ b/drivers/clk/meson/sclk-div.c
> @@ -216,7 +216,7 @@ static int sclk_div_is_enabled(struct clk_hw *hw)
>  return 0;
>  }
>
> -static void sclk_div_init(struct clk_hw *hw)
> +static int sclk_div_init(struct clk_hw *hw)
>  {
>  struct clk_regmap *clk =3D to_clk_regmap(hw);
>  struct meson_sclk_div_data *sclk =3D meson_sclk_div_data(clk);
> @@ -231,6 +231,8 @@ static void sclk_div_init(struct clk_hw *hw)
>  sclk->cached_div =3D val + 1;
>
>  sclk_div_get_duty_cycle(hw, &sclk->cached_duty);
> +
> +return 0;
>  }
>
>  const struct clk_ops meson_sclk_div_ops =3D {
> diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk=
-core.c
> index 567755d6f844..1b4f023cdc8b 100644
> --- a/drivers/clk/microchip/clk-core.c
> +++ b/drivers/clk/microchip/clk-core.c
> @@ -266,10 +266,12 @@ static void roclk_disable(struct clk_hw *hw)
>  writel(REFO_ON | REFO_OE, PIC32_CLR(refo->ctrl_reg));
>  }
>
> -static void roclk_init(struct clk_hw *hw)
> +static int roclk_init(struct clk_hw *hw)
>  {
>  /* initialize clock in disabled state */
>  roclk_disable(hw);
> +
> +return 0;
>  }
>
>  static u8 roclk_get_parent(struct clk_hw *hw)
> @@ -880,7 +882,7 @@ static int sclk_set_parent(struct clk_hw *hw, u8 inde=
x)
>  return err;
>  }
>
> -static void sclk_init(struct clk_hw *hw)
> +static int sclk_init(struct clk_hw *hw)
>  {
>  struct pic32_sys_clk *sclk =3D clkhw_to_sys_clk(hw);
>  unsigned long flags;
> @@ -899,6 +901,8 @@ static void sclk_init(struct clk_hw *hw)
>  writel(v, sclk->slew_reg);
>  spin_unlock_irqrestore(&sclk->core->reg_lock, flags);
>  }
> +
> +return 0;
>  }
>
>  /* sclk with post-divider */
> diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
> index 90bf181f191a..fabc09aca6c4 100644
> --- a/drivers/clk/mmp/clk-frac.c
> +++ b/drivers/clk/mmp/clk-frac.c
> @@ -109,7 +109,7 @@ static int clk_factor_set_rate(struct clk_hw *hw,
> unsigned long drate,
>  return 0;
>  }
>
> -static void clk_factor_init(struct clk_hw *hw)
> +static int clk_factor_init(struct clk_hw *hw)
>  {
>  struct mmp_clk_factor *factor =3D to_clk_factor(hw);
>  struct mmp_clk_factor_masks *masks =3D factor->masks;
> @@ -146,6 +146,8 @@ static void clk_factor_init(struct clk_hw *hw)
>
>  if (factor->lock)
>  spin_unlock_irqrestore(factor->lock, flags);
> +
> +return 0;
>  }
>
>  static const struct clk_ops clk_factor_ops =3D {
> diff --git a/drivers/clk/mmp/clk-mix.c b/drivers/clk/mmp/clk-mix.c
> index 90814b2613c0..d2cd36c54474 100644
> --- a/drivers/clk/mmp/clk-mix.c
> +++ b/drivers/clk/mmp/clk-mix.c
> @@ -419,12 +419,14 @@ static int mmp_clk_set_rate(struct clk_hw *hw,
> unsigned long rate,
>  }
>  }
>
> -static void mmp_clk_mix_init(struct clk_hw *hw)
> +static int mmp_clk_mix_init(struct clk_hw *hw)
>  {
>  struct mmp_clk_mix *mix =3D to_clk_mix(hw);
>
>  if (mix->table)
>  _filter_clk_table(mix, mix->table, mix->table_size);
> +
> +return 0;
>  }
>
>  const struct clk_ops mmp_clk_mix_ops =3D {
> diff --git a/drivers/clk/qcom/clk-hfpll.c b/drivers/clk/qcom/clk-hfpll.c
> index 3c04805f2a55..e847d586a73a 100644
> --- a/drivers/clk/qcom/clk-hfpll.c
> +++ b/drivers/clk/qcom/clk-hfpll.c
> @@ -196,7 +196,7 @@ static unsigned long clk_hfpll_recalc_rate(struct clk=
_hw
> *hw,
>  return l_val * parent_rate;
>  }
>
> -static void clk_hfpll_init(struct clk_hw *hw)
> +static int clk_hfpll_init(struct clk_hw *hw)
>  {
>  struct clk_hfpll *h =3D to_clk_hfpll(hw);
>  struct hfpll_data const *hd =3D h->d;
> @@ -206,7 +206,7 @@ static void clk_hfpll_init(struct clk_hw *hw)
>  regmap_read(regmap, hd->mode_reg, &mode);
>  if (mode !=3D (PLL_BYPASSNL | PLL_RESET_N | PLL_OUTCTRL)) {
>  __clk_hfpll_init_once(hw);
> -return;
> +return 0;
>  }
>
>  if (hd->status_reg) {
> @@ -218,6 +218,8 @@ static void clk_hfpll_init(struct clk_hw *hw)
>  __clk_hfpll_init_once(hw);
>  }
>  }
> +
> +return 0;
>  }
>
>  static int hfpll_is_enabled(struct clk_hw *hw)
> diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pl=
l.c
> index 198417d56300..10560d963baf 100644
> --- a/drivers/clk/rockchip/clk-pll.c
> +++ b/drivers/clk/rockchip/clk-pll.c
> @@ -282,7 +282,7 @@ static int rockchip_rk3036_pll_is_enabled(struct clk_=
hw
> *hw)
>  return !(pllcon & RK3036_PLLCON1_PWRDOWN);
>  }
>
> -static void rockchip_rk3036_pll_init(struct clk_hw *hw)
> +static int rockchip_rk3036_pll_init(struct clk_hw *hw)
>  {
>  struct rockchip_clk_pll *pll =3D to_rockchip_clk_pll(hw);
>  const struct rockchip_pll_rate_table *rate;
> @@ -290,14 +290,14 @@ static void rockchip_rk3036_pll_init(struct clk_hw
> *hw)
>  unsigned long drate;
>
>  if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
> -return;
> +return 0;
>
>  drate =3D clk_hw_get_rate(hw);
>  rate =3D rockchip_get_pll_settings(pll, drate);
>
>  /* when no rate setting for the current rate, rely on clk_set_rate */
>  if (!rate)
> -return;
> +return 0;
>
>  rockchip_rk3036_pll_get_params(pll, &cur);
>
> @@ -319,13 +319,15 @@ static void rockchip_rk3036_pll_init(struct clk_hw
> *hw)
>  if (!parent) {
>  pr_warn("%s: parent of %s not available\n",
>  __func__, __clk_get_name(hw->clk));
> -return;
> +return 0;
>  }
>
>  pr_debug("%s: pll %s: rate params do not match rate table,
> adjusting\n",
>   __func__, __clk_get_name(hw->clk));
>  rockchip_rk3036_pll_set_params(pll, rate);
>  }
> +
> +return 0;
>  }
>
>  static const struct clk_ops rockchip_rk3036_pll_clk_norate_ops =3D {
> @@ -515,7 +517,7 @@ static int rockchip_rk3066_pll_is_enabled(struct clk_=
hw
> *hw)
>  return !(pllcon & RK3066_PLLCON3_PWRDOWN);
>  }
>
> -static void rockchip_rk3066_pll_init(struct clk_hw *hw)
> +static int rockchip_rk3066_pll_init(struct clk_hw *hw)
>  {
>  struct rockchip_clk_pll *pll =3D to_rockchip_clk_pll(hw);
>  const struct rockchip_pll_rate_table *rate;
> @@ -523,14 +525,14 @@ static void rockchip_rk3066_pll_init(struct clk_hw
> *hw)
>  unsigned long drate;
>
>  if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
> -return;
> +return 0;
>
>  drate =3D clk_hw_get_rate(hw);
>  rate =3D rockchip_get_pll_settings(pll, drate);
>
>  /* when no rate setting for the current rate, rely on clk_set_rate */
>  if (!rate)
> -return;
> +return 0;
>
>  rockchip_rk3066_pll_get_params(pll, &cur);
>
> @@ -543,6 +545,8 @@ static void rockchip_rk3066_pll_init(struct clk_hw *h=
w)
>   __func__, clk_hw_get_name(hw));
>  rockchip_rk3066_pll_set_params(pll, rate);
>  }
> +
> +return 0;
>  }
>
>  static const struct clk_ops rockchip_rk3066_pll_clk_norate_ops =3D {
> @@ -761,7 +765,7 @@ static int rockchip_rk3399_pll_is_enabled(struct clk_=
hw
> *hw)
>  return !(pllcon & RK3399_PLLCON3_PWRDOWN);
>  }
>
> -static void rockchip_rk3399_pll_init(struct clk_hw *hw)
> +static int rockchip_rk3399_pll_init(struct clk_hw *hw)
>  {
>  struct rockchip_clk_pll *pll =3D to_rockchip_clk_pll(hw);
>  const struct rockchip_pll_rate_table *rate;
> @@ -769,14 +773,14 @@ static void rockchip_rk3399_pll_init(struct clk_hw
> *hw)
>  unsigned long drate;
>
>  if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
> -return;
> +return 0;
>
>  drate =3D clk_hw_get_rate(hw);
>  rate =3D rockchip_get_pll_settings(pll, drate);
>
>  /* when no rate setting for the current rate, rely on clk_set_rate */
>  if (!rate)
> -return;
> +return 0;
>
>  rockchip_rk3399_pll_get_params(pll, &cur);
>
> @@ -798,13 +802,15 @@ static void rockchip_rk3399_pll_init(struct clk_hw
> *hw)
>  if (!parent) {
>  pr_warn("%s: parent of %s not available\n",
>  __func__, __clk_get_name(hw->clk));
> -return;
> +return 0;
>  }
>
>  pr_debug("%s: pll %s: rate params do not match rate table,
> adjusting\n",
>   __func__, __clk_get_name(hw->clk));
>  rockchip_rk3399_pll_set_params(pll, rate);
>  }
> +
> +return 0;
>  }
>
>  static const struct clk_ops rockchip_rk3399_pll_clk_norate_ops =3D {
> diff --git a/drivers/clk/ti/clock.h b/drivers/clk/ti/clock.h
> index e4b8392ff63c..adef9c16e43b 100644
> --- a/drivers/clk/ti/clock.h
> +++ b/drivers/clk/ti/clock.h
> @@ -252,7 +252,7 @@ extern const struct clk_ops omap_gate_clk_ops;
>
>  extern struct ti_clk_features ti_clk_features;
>
> -void omap2_init_clk_clkdm(struct clk_hw *hw);
> +int omap2_init_clk_clkdm(struct clk_hw *hw);
>  int omap2_clkops_enable_clkdm(struct clk_hw *hw);
>  void omap2_clkops_disable_clkdm(struct clk_hw *hw);
>
> diff --git a/drivers/clk/ti/clockdomain.c b/drivers/clk/ti/clockdomain.c
> index 423a99b9f10c..ee56306f79d5 100644
> --- a/drivers/clk/ti/clockdomain.c
> +++ b/drivers/clk/ti/clockdomain.c
> @@ -101,16 +101,16 @@ void omap2_clkops_disable_clkdm(struct clk_hw
> *hw)
>   *
>   * Convert a clockdomain name stored in a struct clk 'clk' into a
>   * clockdomain pointer, and save it into the struct clk.  Intended to be
> - * called during clk_register().  No return value.
> + * called during clk_register(). Returns 0 on success, -EERROR otherwise=
.
>   */
> -void omap2_init_clk_clkdm(struct clk_hw *hw)
> +int omap2_init_clk_clkdm(struct clk_hw *hw)
>  {
>  struct clk_hw_omap *clk =3D to_clk_hw_omap(hw);
>  struct clockdomain *clkdm;
>  const char *clk_name;
>
>  if (!clk->clkdm_name)
> -return;
> +return 0;
>
>  clk_name =3D __clk_get_name(hw->clk);
>
> @@ -123,6 +123,8 @@ void omap2_init_clk_clkdm(struct clk_hw *hw)
>  pr_debug("clock: could not associate clk %s to clkdm %s\n",
>   clk_name, clk->clkdm_name);
>  }
> +
> +return 0;
>  }

Where is it returning -EERROR as mentioned in the description?

>
>  static void __init of_ti_clockdomain_setup(struct device_node *node)
> diff --git a/drivers/net/phy/mdio-mux-meson-g12a.c b/drivers/net/phy/mdio=
-
> mux-meson-g12a.c
> index 7a9ad54582e1..bf86c9c7a288 100644
> --- a/drivers/net/phy/mdio-mux-meson-g12a.c
> +++ b/drivers/net/phy/mdio-mux-meson-g12a.c
> @@ -123,7 +123,7 @@ static int g12a_ephy_pll_is_enabled(struct clk_hw *hw=
)
>  return (val & PLL_CTL0_LOCK_DIG) ? 1 : 0;
>  }
>
> -static void g12a_ephy_pll_init(struct clk_hw *hw)
> +static int g12a_ephy_pll_init(struct clk_hw *hw)
>  {
>  struct g12a_ephy_pll *pll =3D g12a_ephy_pll_to_dev(hw);
>
> @@ -136,6 +136,8 @@ static void g12a_ephy_pll_init(struct clk_hw *hw)
>  writel(0x20200000, pll->base + ETH_PLL_CTL5);
>  writel(0x0000c002, pll->base + ETH_PLL_CTL6);
>  writel(0x00000023, pll->base + ETH_PLL_CTL7);
> +
> +return 0;
>  }
>
>  static const struct clk_ops g12a_ephy_pll_ops =3D {
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 2fdfe8061363..b82ec4c4ca95 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -190,8 +190,12 @@ struct clk_duty {
>   *
>   * @init:Perform platform-specific initialization magic.
>   *This is not not used by any of the basic clock types.
> - *Please consider other ways of solving initialization problems
> - *before using this callback, as its use is discouraged.
> + *This callback exist for HW which needs to perform some
> + *initialisation magic for CCF to get an accurate view of the
> + *clock. It may also be used dynamic resource allocation is
> + *required. It shall not used to deal with clock parameters,
> + *such as rate or parents.
> + *Returns 0 on success, -EERROR otherwise.

Aren't all functions returning 0 always?

>   *
>   * @debug_init:Set up type-specific debugfs entries for this clock.  Thi=
s
>   *is called once, after the debugfs directory entry for this
> @@ -243,7 +247,7 @@ struct clk_ops {
>    struct clk_duty *duty);
>  int(*set_duty_cycle)(struct clk_hw *hw,
>    struct clk_duty *duty);
> -void(*init)(struct clk_hw *hw);
> +int(*init)(struct clk_hw *hw);
>  void(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
>  };
>
> --
> 2.21.0

________________________________
 This email is confidential and may contain information subject to legal pr=
ivilege. If you are not the intended recipient please advise us of our erro=
r by return e-mail then delete this email and any attached files. You may n=
ot copy, disclose or use the contents in any way. The views expressed in th=
is email may not be those of Gallagher Group Ltd or subsidiary companies th=
ereof.
________________________________
