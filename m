Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9D63A10A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 07:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK1GG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 01:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiK1GG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 01:06:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EAE10FE4;
        Sun, 27 Nov 2022 22:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669615586; x=1701151586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/2KNzK4npNcT+Xcdik/MF59FkG5BcdBbfLuTR4JirZU=;
  b=jetfV9qmBToGvBmHKms7/H0p9RL7Zkm1cFemj39hZte0sg8UzdXXbJII
   PtjgfT5TO4ZKRL2IbT0emEkvGoyMh6OamvaVz5z6eOhjTuL0vlc4ccoxv
   qjKXQYgzIEMFwm7NEgG6W3a5sSBCCE/kZIvtYqhlY++gu/hJcg+jcIaqD
   k1YPNWqA2p3RiL1CxTfV7eQQogbjrzVrg440DGjjhV6cjP1ARRnooalh6
   pum9kL4jrwvS6g+1DYnjCOXqT4+LM7AinN7NYwglJL1f9roAdMl42q8VA
   Fx3uSjCX394SUgtczf3udcDsKUrGiuOvtn2Uh7MtkvRZceaw4n2beVVHw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="401044304"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="401044304"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 22:06:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="767922261"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="767922261"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 27 Nov 2022 22:06:13 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 27 Nov 2022 22:06:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 27 Nov 2022 22:06:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 27 Nov 2022 22:06:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjkDC3B4FIM+kluwFnHKLvmKy45DZroi3xzjr8ZQ9Rv5Gnk7UGVyFulpaHzf2owV7HETvNnp8vCAJhqiR/7Cw37Ub5/auLo93IlOg32c/Y0e8+P/jax2/Ni1wmbZKOWVYbhIzsdJbn03qk0qYg6i4InHAZ5Q9A+ywSL/0hhgKIIDRFiigwPekRPp8tzM2bZp6CM1vzAwycYrgfjo/E5Us+vpQrAtadGVDh/qTl/Ox6NyhOUKsNtBV3xAiIvECjj86T3RgwDHpw7H3h2zo3pw+cmsM1MheZwMt2occ0oJhGmK+qVsFcyJE0IJQr2jVddB3PaSbP7d6pNqM5tjFw7WgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tX7iqUV6Ml4u8wlCl4SPjIjvg0TXntfwrsGA9fcifEo=;
 b=c+c7dH7xjLBmZzApjkHDJ2aa8wce3qsxCdGnRAGfwTz1tUflSeOlj7svdIk2jZLArVyakfTyZFyjsMWVTYje5KJC4VHD2VAZwuidVXHayhqUzLhTCTpvVOSEgJSo75MtziOHBzLrOyDk2CLDshTd9Y5p9K3Gc4sTTW4VQAto1juYbE3zKiTNG4qg8wNPo1f2tUPCvZ3uqVuFnYlrT0Rk9nO1Ql2BoxJeBmHrh5I0TfIKfXQQ56gqABS6V8AH9bB5u9P88Zb/mpW25+GxaNb88ZW3Pnz7sIOS9auwc37pJGtK1pfcgusVm7tGJoqX7foMtx+3PatpuSVCIEgXniUBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5590.namprd11.prod.outlook.com (2603:10b6:8:32::8) by
 CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 06:06:11 +0000
Received: from DM8PR11MB5590.namprd11.prod.outlook.com
 ([fe80::3cd8:7b78:42ad:fef6]) by DM8PR11MB5590.namprd11.prod.outlook.com
 ([fe80::3cd8:7b78:42ad:fef6%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 06:06:11 +0000
From:   "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>
Subject: RE: [PATCH net v4] net: stmmac: Set MAC's flow control register to
 reflect current settings
Thread-Topic: [PATCH net v4] net: stmmac: Set MAC's flow control register to
 reflect current settings
Thread-Index: AQHY/ymhvdEBGqbU9Uuf4VkJqqcsh65P0A+AgAQPEHA=
Date:   Mon, 28 Nov 2022 06:06:11 +0000
Message-ID: <DM8PR11MB55909F0270753517565B12A9A3139@DM8PR11MB5590.namprd11.prod.outlook.com>
References: <20221123105110.23617-1-wei.sheng.goh@intel.com>
 <20221125160135.83994-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221125160135.83994-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5590:EE_|CO1PR11MB4916:EE_
x-ms-office365-filtering-correlation-id: 9222e8d0-5142-4dc3-7153-08dad106a63d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0VDeNyWu5PvArqsoma63peStNEij8RU8mlsB+621BDzD7/bm8IWmm2Wlrc5HAX6prVItuxGFYbLdUiLLCQEtlrQA5yjpwMc6zSFo7OStEv50lO/QcYM+Fv8LVEa5hmN4FwcCJErxbvNJykNwAz4hHTSW5JL/pJK3a5pOADOEzFWdkLVErAZZ+ziGKh2qc5fx+Ih0+rjCCtaqHU+URHrr66AfX6IvDOW+DO965SFGX9eV5ogsYIGnXDlC5iKQYlhWNbQYAFa/oa9mHrlnALsvSfTCvOQ4gZROSkhI7P8w/wMDkvL3b4FNeeuDf4shl4j44p5Fd7sghaVwmrVMXO+PGaiQS1hkgmKTOkl5axO3x+oydokqNTPNhSSyx0LTZ8Hfa3xx/Guv78LvIDwsafnog4M6e+XChvdCQuOxhmsvxIl2N46Ngt9UPPGEQs58peU0dtWXV111Hqj6UyH6TlRIi2HZnQhdGgG69NVpPf36ySXtWmyBCZuZ9xDkv5HvG9fhSUrdezsf2/T1YjA1QSYrvmw5yL/iOHXDwB9IHfcqxYuZCI5WThIZHHVoIvokPjIPo2ibTYmOgkWNKV1goM4/DdaYi7oIVNo4dPWpv5toNrYR4Yjrpg7lMWK0jeSTfzS0u8elx09beo/DWuOcWs2P0yqQCPx/juPAuJ/aiO71ap3gtcm1Mz5MxUedo97ApCudVbC8xqy9JsP6nMhAXv+7jb73iJ2awzRpBekJc3KKaEw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5590.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(38070700005)(6506007)(33656002)(86362001)(55016003)(53546011)(9686003)(64756008)(66946007)(76116006)(66446008)(66556008)(4326008)(26005)(186003)(52536014)(6862004)(8936002)(41300700001)(8676002)(66476007)(71200400001)(107886003)(966005)(478600001)(316002)(7696005)(6636002)(54906003)(82960400001)(38100700002)(122000001)(5660300002)(2906002)(7416002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NPHg4quL1vgZoeENvqZfaH1Ts/Pm3CpYnniKWojcaCg53OqYpaWw+5+Dsh3W?=
 =?us-ascii?Q?Pz2zGS0qCL8xDNOpumHAOekYK/WaYynduqb/2F92dIMupcduUWhBlGoiX4eE?=
 =?us-ascii?Q?WaHzhVhwuKYlZDn5rOLTeGYqQhnlOzBJY0z4H7UCdZ+ENGbkq0j0No8S20rj?=
 =?us-ascii?Q?JJhh9MaCp+pproAbWCuaewCtNV6bWxFr6IfUN6k0BnsVPYnPnD+X3pdlCtA/?=
 =?us-ascii?Q?sKE5gD6Vk2njFxE6Qm2newxS89IUXNnvSG+956gQeHU9YRm+nw8EJIKIonU7?=
 =?us-ascii?Q?2BsWhyraEulUpSe8YDAqXHEEDKANoPs8BJT1geYGJZ91DhgS58Nk5P3RcmJi?=
 =?us-ascii?Q?g0w4Am4L/cG0v4gXpq6muW4/9sC5+aqC5qSH8zK6carzCd68ljHagfzgjnQ/?=
 =?us-ascii?Q?SPzppe4e8VuIwzCP+LjGvCTEHRIjSnGbNEm4GLCSVuGCddCCdsgpYlgoYZ9k?=
 =?us-ascii?Q?rZz+igLi+euf5l1zJOA8lLZkfwp5LYBFuiEPis399pF4VBzpvry3qDR5/6hq?=
 =?us-ascii?Q?TWjrP4hvGugeOVAA1ytUUEXJ78ifdfsmRI8q5+zhq4NcOLHV5z7/ahAjqL6S?=
 =?us-ascii?Q?yRheNYZaMpknAAcQYsCAWyXLIDMd9bipSLUNskdvCeIpXyA00NAMUfbfqHXX?=
 =?us-ascii?Q?z5wWmnspKjTjpKilmK9j565dP/BPG5woOrc/aHRkfi/Lh7z2CatCsErCwzh3?=
 =?us-ascii?Q?VPhDAB4dArAk9QLUzuK2jgbPOqI5eYK2urZyyXColpc1wxhbtdLRpKCOymGJ?=
 =?us-ascii?Q?ty/eH1fv+bYchxkZDOTQjdDut+NrWwmuAU3NQD1HUXX76DGd/KmKVUGDQ36g?=
 =?us-ascii?Q?kkmUWGZHR/Qz2vlXGtsEcIyjopqhZLfdqlB04sF1ADAp+mtHlnthrDfeJUW2?=
 =?us-ascii?Q?IVx7aEnD/13rVPJdHncWtUmlDAVX9wFO/qPUfz2LVnAkiVWUDekaJ1l6lHF4?=
 =?us-ascii?Q?60rO1CvL93QS4ygemNF6/i0Ej+D7o9z0nxYv6S2HcPxeZs7prNe79JG0CccZ?=
 =?us-ascii?Q?oN6GWb1XPP5pm7Sa11s/5P5Og240S292HsjaeTW5HE3FWnvzZnvauLLrGSuS?=
 =?us-ascii?Q?VPu3dJA20tW66Imq+QCbU/5aRnkm705YL1/1ts9sCx0ygx7q5IMbQ8jwtzKF?=
 =?us-ascii?Q?+VOMKlmCphvjYRNISJt8qx0GrkSbiYZDJjxNaZmkBjhUzKv5wi3EVH4jcEjA?=
 =?us-ascii?Q?WKLtT3tnGkIKSc0UrsR/mIOS46swKvG7/FB1MalHEwwYMfjWg7FeEOIHrksP?=
 =?us-ascii?Q?T/yOplyLMHPGbGzrNdDsGnlGu013HBZk8M/NgLHFhANky3Fn+saZHt3n/BSR?=
 =?us-ascii?Q?CIwZKZ2c1pG9ku8zWNsZfWX8vq+lssjWARCW4puY8PnSvMKvGfEilUPDD81r?=
 =?us-ascii?Q?AE6mLgTwC/mjQtbdNVrn+1Z7fHFSfTAO02lNUhy+TVpktzSqdnxHlly8stQo?=
 =?us-ascii?Q?BqcAwFfqREECSL5VgXnAq89sOK+pHuqa9OJnyVasoqIyNzDoEzC4sG0IhDDu?=
 =?us-ascii?Q?1u6xhpvfjj/ssrEO8nRNmiDB0fNdGNSkYO0SGEVzh9NaTsENCASBv9UKE8FR?=
 =?us-ascii?Q?AYvpYgJAJUdvPysAiT4/v3AKZ9+8RiCJHkLo0g3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5590.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9222e8d0-5142-4dc3-7153-08dad106a63d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 06:06:11.4932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TFZVppiJZy69WozyDmJg3gBHFBi151uVWO35NtxAk04HGzO0A7adlRZIqNjoCBX/eAzr9uOL14ZZl4GN9jfNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> Sent: Saturday, 26 November, 2022 12:02 AM
> To: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Giuseppe Cavallaro
> <peppe.cavallaro@st.com>; Alexandre Torgue <alexandre.torgue@st.com>;
> Jose Abreu <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>=
;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; netdev@vger.kernel.org; linux-stm32@st-md-
> mailman.stormreply.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Alexandre Torgue <alexandre.torgue@foss.st.com>;
> Ong, Boon Leong <boon.leong.ong@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Tan, Tee Min <tee.min.tan@intel.com>; Ahmad
> Tarmizi, Noor Azura <noor.azura.ahmad.tarmizi@intel.com>; Looi, Hong Aun
> <hong.aun.looi@intel.com>
> Subject: Re: [PATCH net v4] net: stmmac: Set MAC's flow control register =
to
> reflect current settings
>=20
> From: "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
> Date: Wed, 23 Nov 2022 18:51:10 +0800
>=20
> > Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
> > correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
> > is issued. This fix ensures the flow control change is reflected
> > directly in the GMAC_RX_FLOW_CTRL_RFE register.
>=20
> Any particular reason why you completely ignored by review comments to th=
e
> v3[0]? I'd like to see them fixed or at least replied.
>=20
> >
> > Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in
> > mac_link_up()")
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> > Signed-off-by: Noor Azura Ahmad Tarmizi
> > <noor.azura.ahmad.tarmizi@intel.com>
> > ---
> > V3 -> V4: Fix commit message and incorrect insertions(+) value
> > V2 -> V3: Removed value assign for 'flow' in else statement based on
> > review comments
> > V1 -> V2: Removed needless condition based on review comments
> >
> >  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 ++
> > drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++--
> >  2 files changed, 12 insertions(+), 2 deletions(-)
>=20
> [...]
>=20
> > --
> > 2.17.1
>=20
> [0] https://lore.kernel.org/netdev/20221123180947.488302-1-
> alexandr.lobakin@intel.com
>=20
> Thanks,
> Olek

Due to v4 is being accepted. Therefore I will submit a new patch to address=
 your review comments.
Thanks and appreciate your effort for reviewing my patch.

