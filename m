Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC45A9BBC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiIAPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiIAPcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:32:16 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E101F607
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 08:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMvmFeDFMB9XNNd+Z+RRe+9B11SKoE7aRhwN8D4IkFmSMfhOse84RG2ZoIfwWy9KqnK5hFD67eQ1ayChe1fXqFbzokKaHFHzrqNeJtIjMzpuqS/RSBpiF5eOziBH4dD3Eg39Aw/9DUPE9gwlgFCxXKChVTKMec1Sr1ayHx6X/EfnaXH+3Hrib9hieu9i+69wJIjcQ2o1bAJgPfleTtLouEkp735I5zugDQ9360vSA63wr90MnXQld17WVvfeX4wOfGWokR3BHSu/LZOjQEyM/Rrsrb4JRzsHQLJILmB7FdPcZG5UpI/W/NZr2Z+kkFQnFBTgm7uDobSdpUY7neEmpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBEZuvQnkmp2Id/fm4tbjZxFycBn00AGfpKsU1d44gs=;
 b=Zr2TRZZsbo0HINlIQDceEAzAZW0Pt5SjHtF7reIjYUKu/s+26ExR8RtCdGtLZXRtR0GJlgiGvThqA6Xl8JWAa7yWu5bJK0ZE3/qbejqTYAUrxdzb4GOV9c5Y2j2TeZ2xNS5MlijoE9BZDXR59/1TUY+ctQPg88IW2ek9h8mID6uvGF8AnFfMun/qo9oI1FCCCQDcDoJ9U9txQiSSLeGyt1VCEcBF8C3M2IecEosdgGvnhkLJTkfRb9nJcSFpiAywJe6GR6u81tslcHj8Sp5nIU2wPHITJEzBBOzl393Mn8wtpBuXwezwlvmkcfo4ddYQC1QzQwT4UxXoSAB/kMiRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBEZuvQnkmp2Id/fm4tbjZxFycBn00AGfpKsU1d44gs=;
 b=mRKXso6OHrvsAw/6yUb3ZGdXmDHzP6YYQe19aBB5rYPgVGoWmayqm0fkgRQmW/M5yWeQB54h7nUD3+w132D8Bv36BlOVVygx6VsJ9Isr18TeyFWTSKKo/EKhMFGDf2VLJomkzyffGiraFOX2tr6jQzFW7TNGyWgTUd1OhmcHbp4CDAtUoiqplf1yYO2YDl0KrfGE8FuK4CDh/qr98G7sNF18c+XKl0El9UpRZo162/jSi1JQ2A8TSEXz42Ux06szzQjggv1Qm4jAQb5nFeMEoihvfY8nFRrWG78GkxZ76eVU09zrCA68issblFNgRbNp4o8GNwzeE45xqmz/nLhXqA==
Received: from DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) by
 SA1PR12MB7103.namprd12.prod.outlook.com (2603:10b6:806:2b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 15:32:13 +0000
Received: from DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::c90e:91a0:682f:57a]) by DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::c90e:91a0:682f:57a%3]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 15:32:13 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cai.huoqing@linux.dev" <cai.huoqing@linux.dev>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>, Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Thread-Topic: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Thread-Index: AQHYuWTPwTyQqWx9eUSSqm08blvvFa3B+6sAgAjA9/A=
Date:   Thu, 1 Sep 2022 15:32:13 +0000
Message-ID: <DM6PR12MB553413FEE0C3C357010CDBB3C77B9@DM6PR12MB5534.namprd12.prod.outlook.com>
References: <20220826155916.12491-1-davthompson@nvidia.com>
 <20220826184922.030fccb3@kernel.org>
In-Reply-To: <20220826184922.030fccb3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33fd3d82-6907-4eb6-3858-08da8c2f2492
x-ms-traffictypediagnostic: SA1PR12MB7103:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sEugoX/1WNVrBnQU7VCs1rhZfkmJwHuQnZy6++/vVogxfYk3RM2hxlSlnOVlmRQ7nchwgW06bKmpukwkoO3pgyl+LmnJOn6MJnHAsur2nypZR5j3RFJl0nF81EjNj4ODOtHU6S9sw0KlfiaUEwWwpahPxk9KQJvHGlL5A7Nw7/IZB+STee1Pu6ehm1PRkb9z6nv5/3W+M9urf0WfHcTa85683uHbxuhw4moej/OckHDMZ9CHOamL9+ysriJSld/ctpSAC8vnc0IxpxEQyEnOuaDogU3K51LuovzAcREefzHvvGUVuvXQu0jSVucFMfvfFfTefplCaO0YICTv7cGV76n6ZDbmkdDOAEfUXhwG1Yre/Tw9Iu1TyeSDgBChPXPrSetNnsyv+ec7Q290EaVQRNkQcNzWgsT9cilpQ1MEfL7QfUCvn4pOqLrJZ1komDsiya2oms6X9WEsYAr99vvYpFX4noPW1zyiYAiL0FpoineAndpSQ5rfQ9AeNjzCupd58KvEYXLSZ+f+nqMjAe7TAY4LBsbYOBxnd1shL/UBbqJRkN2EQJtm9E2B4yePqs/9RNAG4eHACkKWrbt28fKv4XPRDks9g2KSD78tZj62Jig95RyXm+r4CHIH4lLAD3jbeTWHKIv4IOHFiRU0XN5dw+VXwZB+Bh6YPFVeJ0bNpQQQ0Hq1bmXEfEz2ow4XrXTqkpOOjzEitej4HWF5CJsIWoHd7huwJJ7ktO3VgApi62GTsyvhAHS9n/RDM/c7TtH8ZoHrWoY1ZXccZRNHbtXS5j8ZesSUC+5Q41fDXNhlOdVIquRuKewkTH9EG30FfC7jAn/Gnu01yke2XhsPIFolW/tf2t4n8eyQ4SH+8nB1LQE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5534.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(186003)(55016003)(9686003)(316002)(41300700001)(86362001)(5660300002)(38070700005)(83380400001)(478600001)(71200400001)(107886003)(54906003)(7696005)(6916009)(8676002)(6506007)(52536014)(53546011)(4326008)(76116006)(8936002)(66556008)(33656002)(122000001)(64756008)(66476007)(2906002)(38100700002)(66946007)(66446008)(32563001)(473944003)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Rh53H69V6Q3/J7MEkam8T9c87ddZf9zDCGJG/1MY4mJWJlcHShhA6XIUeAy?=
 =?us-ascii?Q?eg89t5cU+ufIrL+y2BrxHGnjwFodBdq2BMqXOhyEmeuVxLCjsSPYF4f98XdO?=
 =?us-ascii?Q?DUiQXgF8EyJxlaQBuyen/mk7NNDn2DBjrT2SUqm5osc+fpjjZMZpmTsMZuRr?=
 =?us-ascii?Q?vvSK2xEn2Pd6M08UA7QQay69FuZYVnHev1CVX9a/YnftFsCW7bKPrguPkBhX?=
 =?us-ascii?Q?1Ucekv11XqU9wTl+Ae7MSLXPm9aE5VRNojX0Fp4VU8o5CLEgyJ0WzzuNcMy+?=
 =?us-ascii?Q?dGof5SbYU6f9zfRGI2A8mUxzFFxdwP11Pze5VWl6cIxa1WVW5BSZf1xZYU5+?=
 =?us-ascii?Q?HFez2ZV1oB+jv3fWHeBs57GkYLI29MukuPaIUeKz6FY0NYwZRrXJ3FFzL66v?=
 =?us-ascii?Q?N+Z6CtYwb+kNrtInamElE6XWd34cs8DPkvhq+xHGnDHdCzvZibzz8sAIHycZ?=
 =?us-ascii?Q?GY/B2Th1hbg5TBhT7rWGzgzcIU2MjUpUrnUb4NXbxrwlz8XXdB9TVPPo0CFz?=
 =?us-ascii?Q?+XW6NcM9P6aR5nP+30c6FO+BoJiS8Zf2GmnaxtZffrSC6+tIYI09BM3nrtux?=
 =?us-ascii?Q?qYFmcFYWUB9qd3FZz+s4Je4ChZdACPhAgnD8FTOMIL+qLZdJXA7EoI7BoHxV?=
 =?us-ascii?Q?7ja9tAEHe55lOMTlF/vO5bokd1AQ5NhU59XUPtddWVSxCMKh4g4zy0EhbtII?=
 =?us-ascii?Q?KgJ9m4GVMZK34NFjY5KCzIKqGSSSMCo5rqMrfKnO3JS96D7lu0ZdSYwmsXJb?=
 =?us-ascii?Q?oy6VILdaool5A1ENZO02aBvaISi8NnoafVU+qttPkUgNiteyHgVgPguhb2Jo?=
 =?us-ascii?Q?c8+Jl/yTRq68JY2S8ObKis/pvRwDBuDbPqOQlCyiRvpnDAK2rdkDgSvyJuK3?=
 =?us-ascii?Q?zO4MnGB7OcewtX64B66l+M3ajYq4omVaTKYDpbzM4bz05TEAq2GFFQsoGxEY?=
 =?us-ascii?Q?SUprc2KoTgjvsBd9eRn6BCqPcTPzCYdDHp0KgKm02RqCoJuPXQNk/lXnbIJf?=
 =?us-ascii?Q?sYYoCZ6+ORFcXFWXaPxQ4K1qTxPvjUrQ97Hiug01vZE6lv2DFrB2LkrHnjBD?=
 =?us-ascii?Q?oYL2oANcBizM/GXyRTHKpWUSiezz7sHFvQx4mq6XQhCFZOeQjRysZRXWPLya?=
 =?us-ascii?Q?mhllIptUr7zR21z8YRGSuipmw73F7rxPqnybINl/bzUo9lqld8fOdXrhdGuj?=
 =?us-ascii?Q?LEv1Vrjqi/xskgcQ+1uP9YoIZ1UzNtcCgZKFkSULA8TZA1QfnDD7wq7aaj3a?=
 =?us-ascii?Q?8+LVz0XCRDPA1HaAXISwFZcSmYcy9nQfRweWJowMKXQcivvHWYRbguxHAW46?=
 =?us-ascii?Q?GOVpYa4RgO7NA4Jr2SMTq4GWmdRdTxounaKb1DrEBgi0ixakczg8xCgTfjB2?=
 =?us-ascii?Q?mRjOJXDzRx0GOPesY7E3wgDfG6/qjosA+vu5wjP1op/eHEwxsT7rxwMD/siA?=
 =?us-ascii?Q?JYqI7wNE9K60JGBOmV0JjuLODULLFuJ5TU77jOh01sB8o3f11qkf2wfwQKuu?=
 =?us-ascii?Q?yzrVJzNoM7b4NBsndDn//GlK7CKrtbWG3e6Neymxa7IovVhONGm0+FSDWn2C?=
 =?us-ascii?Q?Y9Mnx3g5h4mP7syfpyPaRuGqrqZMEWoLaPd/py6SyobvnhKE4ll4WmfXZfNl?=
 =?us-ascii?Q?Qi+pU+KenOaCPzS6lmBotbGYQT2Z7HI9un4cUBOMG18K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5534.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fd3d82-6907-4eb6-3858-08da8c2f2492
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 15:32:13.1104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKbUK3tMjKCiRND15WFfzTU7b7Ss8LElS0WaDSqnIkYvh48YV7dNKsYl1SAwNnAEH1r1EyEYfKWdkbyeT/ov6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7103
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 26, 2022 9:49 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; cai.huoqing@linux.dev; brgl@bgdev.pl; Liming Sun
> <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1cl=
k
>=20
> On Fri, 26 Aug 2022 11:59:16 -0400 David Thompson wrote:
> > This patch adds logic to compute the MDIO period based on the i1clk,
> > and thereafter write the MDIO period into the YU MDIO config register.
> > The i1clk resource from the ACPI table is used to provide addressing
> > to YU bootrecord PLL registers.
> > The values in these registers are used to compute MDIO period.
> > If the i1clk resource is not present in the ACPI table, then the
> > current default hardcorded value of 430Mhz is used.
> > The i1clk clock value of 430MHz is only accurate for boards with BF2
> > mid bin and main bin SoCs. The BF2 high bin SoCs have i1clk =3D 500MHz,
> > but can support a slower MDIO period.
> >
> > Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> > Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
> > Signed-off-by: David Thompson <davthompson@nvidia.com>
>=20
> Hm, why did you repost this?

I reposted because the first post failed the "netdev/cc_maintainers" test:

	netdev/cc_maintainers	fail	1 blamed authors not CCed: limings@nvidia.com; =
1 maintainers not CCed: limings@nvidia.com

In the second post I included "limings@nvidia.com" .

- Dave
