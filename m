Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2E5BB471
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiIPWkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIPWkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:40:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534FC5A8BB;
        Fri, 16 Sep 2022 15:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZSsH04xGUV3+Y0adAdwNA21yUs7/YnU6suwZUyiWB5XMXwCCCSizs1jaKWFyJDI+roPvOXcC8dMTLA8YRMwXzomoKVj8WE3y7LMhKoBMze9GBTqiCO82nqtOCjrHCoJ9Ub8YMfyi0q4p1CiSai3EGTg9knf5lLF18/n0jvInDvPyHo76+xhEdOW21fqTR7BP2WqnCKVBZRk+k8rtdwsaM39ck54DDlantLTpkIITzVUeiPZF2ZAeePe4b/NIg+tsuz/iUjtjn5rdGi3ZMwkw5memEO/o70LP2pJ9CPIRaKg7hTpyQoaw7v4Cq/jQwqEQfhwOJZDyPSfT2/PXQgN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2weH8/LaKlldU9EV455PhlIjYz7YLoIXmt1r9779Zs=;
 b=Fa7Elo2KLG30EHK0jpX7SKgf1lLr1OR9kUm2FoI5TWRxsljVrDZuDbgl8UapRp7cNuGscOBaoxrBgHmDic55WXgaVmM0zZr/xlH5UbQKx7Aij4Dapi0F/Dyp4R8WLmRtaViS9uQ3ZgvQ3rzGa0S/a4eBQR4uJCEo/pk6De+HT/gSKJSVfqIiAaSq20MjF3RXYmMbEI/9qXllhYrOYnmhNGyabd94htZr9dHpN0BxJSyOjeBXva/dBU6b1VB9dtssQct2EIX79W4MKjJVhXbl0XEb/yXhzYZeeQk7QSNxpX9emgybqPn1ubLnqnbhitDVy7Azt3wPUvU8c597ip1DGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2weH8/LaKlldU9EV455PhlIjYz7YLoIXmt1r9779Zs=;
 b=Cabcn3kHhKeTWU2tYLoPzKnpX6d1mN7e2y33SbizqF6XNvxfdypQtyxLudnGlml67oVJQ/uC7x95dmUdtutGTW7xb0hNhdkTx6r2rd5SqM4vMp0PNPX4VtdV5uXRf4nKLin81alveKABQg0TBOxsBK6ubKco8KMpjsrPfX0xL88=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9340.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 22:40:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 22:40:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 2/2] net: mscc: ocelot: check return values of
 writes during reset
Thread-Topic: [PATCH v1 net-next 2/2] net: mscc: ocelot: check return values
 of writes during reset
Thread-Index: AQHYygB+3lNUS9Vav0i1SxPnUbd9eg==
Date:   Fri, 16 Sep 2022 22:40:10 +0000
Message-ID: <20220916224009.g4prlpphnji5i4zi@skbuf>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-3-colin.foster@in-advantage.com>
 <20220916191349.1659269-3-colin.foster@in-advantage.com>
In-Reply-To: <20220916191349.1659269-3-colin.foster@in-advantage.com>
 <20220916191349.1659269-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9340:EE_
x-ms-office365-filtering-correlation-id: e775d20d-3c45-4db3-6a09-08da9834698f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rgjN3srpBYCqs448V1Xyobrc2R/GgVXxNZJv3Mu4ncCF6OU/tlAw5T+JyO2TJo7LrbRE8Pyvite2dwhaS3GjkAoUrAnHpp4ota75fzYfpshZpXhYgeUolR2oIEA4nzhERUpxCypZHLanKZfFD2ll2U9/uHv5JLdx3nEhSfcea9zwNqoJ45aHkji2wu6tef5eTFBtMDLk4Ar5j4Jh9ygcI6dpwM19gasAvKYfhqCc2n3Bj58xQQtR316bVNQWq5lKGFtduy5U/CqP9keOw63gT+DTPaEmaygUW+5QRsbuIyVMWvE81ueZ5OyuSxwQJXcxPodFpLHXsenMeQl3hEqxyvqnehF5W6eqloEIcnlHLDKnn04YqsintwQrl7hUdhIYWxRnRTeDkPT3+Ou2fRUSdnbf9WyQI0trMVf7lcUJ/zRH8/rQiyFP5dXK+DTZPW2OV6hlLF2LiwiSo97+V+tMyRR77B95zW3LQHijPW1iw6/YxP5mWBzcOztIlHU6MYMar7U+UgeTgI1lUKY5hbo8cgp6S7vMx3Pl3IlxKP2yHUPbIk4JRVeTsdek9rEYrwajpZ8AXUvxbLeFrU09XlpxDUnwZmmIOgQAYhj94KBqMETo9rZEKTxDK9KZkf7ohNxob4XsVh/8hzwS3LO2BKk3xjfLtyNhEFV44abqUhU9JK5tSIt0MS1QC5+Sm/K4Lxql/jFAIO8zOK1HMWGHow+YQkwmlKqoSAm8roW/LGqst+WrY2McOq1G9IJt6qfhn0afVB6hyY6qkI1YXAYCqGMLeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(4326008)(44832011)(66446008)(8676002)(64756008)(2906002)(76116006)(66946007)(66556008)(4744005)(6506007)(5660300002)(6512007)(33716001)(66476007)(86362001)(8936002)(9686003)(26005)(38100700002)(122000001)(186003)(1076003)(41300700001)(91956017)(38070700005)(6916009)(478600001)(54906003)(71200400001)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z1P2MQ/pzUArJF0hx8l69LffYmoql0OXC4EUO7jD6bpk1FPTdj5BSlcIp+Rn?=
 =?us-ascii?Q?foWt2AKgcaL/KumDiMdnwJcQAcdQY2Bh7KREz1Ej6YbYf3xjtzgFYHze7j3x?=
 =?us-ascii?Q?aAoN7JlvJBeLb4KlOSb4i9KSFih3dVaa9X0c7/BDp4ibt2xQUyMpE1yhQ781?=
 =?us-ascii?Q?wziow//BA6f/HTPfRE78UgdaCwt1Kaj4l4EmThc4Rp58IWMoQMoHBGkU7Y4e?=
 =?us-ascii?Q?NZMmcy6J7WaVUbqw+Yu10lycwdG/RZHZcltlirymVWGkW5Kp51pn/sRa4b+s?=
 =?us-ascii?Q?i2zsRFweVz+Iniz8VF61zy4yt7GJMoNdSDvEoqVkVw+spNZSUgSDl3m9lyFC?=
 =?us-ascii?Q?iiELyV2gwn/lTB+VLjScMqPrGC1ohVX+ALlSXzCQUfEg5OIE+ZA/afM9yHM7?=
 =?us-ascii?Q?2jiEHWNfvBfp+I+1DWfLjV04e+iqn9sL7+IOe1UU78zi3c/INpIkdzHKuJhJ?=
 =?us-ascii?Q?Xji7yT7U65Zp3ZZzm2b5MovNzvgsYd4A6ez/2VNabgp0G6fTDaq/mFODcpXV?=
 =?us-ascii?Q?WPbxY+GCs+4hKKPBupGYUceRWTguBG8WISKOzqN4K/3aDZsEWJhnoNRyLO55?=
 =?us-ascii?Q?azaTROU1tuz0TaiAHgXmN9w3mELtIkDoGOxCxx1kobSkseFQBfbuL9zv0XaM?=
 =?us-ascii?Q?z3R+4XKClXakthLx3myWVZuqzYE/u86EPmLq8TnbuYMH5NnKr0kuSOwlMEN2?=
 =?us-ascii?Q?JtHPF2Oph7lHacNqy/HuslN0wWSsu2unef4c1FDpqRNPEQWx6zZTy800JVQ8?=
 =?us-ascii?Q?NPZWP7OqdvNdhZXdHvG+88lsT8doUxlOiZFkIS+QxIohN7/Yk2UsPQP++3gt?=
 =?us-ascii?Q?QLhaRUHvpdDC1HChDqd0mln8q0s3FVcZ983SewSc88A1k4HrH1DUnPSD9bsA?=
 =?us-ascii?Q?F1Yu7M6vMrN2SesRN0PKz0N+fp9pb5dtJS93B4jKSh/wj5tVtxbI71+y4aNx?=
 =?us-ascii?Q?HyGX7MchpgD21ml4itakqKKcK5HOmSXE71er/iVZ3tg1o2B+vOSga4pH0MTs?=
 =?us-ascii?Q?MoflrauvdYBaUnLWYexq1pq2zU6ZzYRrVtJNlC+UKKNGhDQT8pNmXQFFS0Xe?=
 =?us-ascii?Q?p7UfboGpPhL5lOOvIvkSQopDM+61XesooKa/kKYnHlFxsghXx1S/eUt2Tyok?=
 =?us-ascii?Q?vdB5S0GkUmV793kQYrHdJ6+z0u4DTYsJtBVLAiuabpn0AS8RkytIIQ7vusVo?=
 =?us-ascii?Q?wZcupgjX8HbA2S+J/nQp6QI65VySIUJV8DwYhlzX9UOp9Es9OI7hvdqVCHNE?=
 =?us-ascii?Q?9JjN577cjka/w+oCMXbPanOiy5h9NbOl+pyUGcUYmhtuBVYYXB1Evl7xMYWR?=
 =?us-ascii?Q?tIkG5soLEzAA5bMFQCBTjNTbwHlR+Imt4rdgRHzD6JNXbjnCA0ZkP1FL0SXH?=
 =?us-ascii?Q?B8laN7RJ6j7QpEkzOsTufXtOjMJPHAAuGPH6hw7offaVPTyDNEf0lk6iGHpL?=
 =?us-ascii?Q?ZJB/d4O1hRq2oKnFE082HjieHbvfJ5kjhkW/xpwn4KHPlQDv36yN02nuvKY/?=
 =?us-ascii?Q?AHCBDhbMryc3BRANl3wRsz2i77zwXAzDJP1MI4ORormmwATcEcO08WqODxFl?=
 =?us-ascii?Q?XoZ2Cs1v4r5u4fA9bumzV6ZPMm+AOOUVUC8Isrox08nzvZpNgqsXqcCD1JyN?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D52FBC02A2DF5745AE4822F04E3CC754@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e775d20d-3c45-4db3-6a09-08da9834698f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 22:40:10.2918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEJFTM2KrNYLAKdRokYUInMxSV3nezVtLgS1ltd0aEI0/F/OtYgPfcK4Q/5P5mPIsWUlR/LqjjAaJQojXkebVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:13:49PM -0700, Colin Foster wrote:
> -	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> -	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1)=
;
> +	if (err)
> +		return err;
> =20
> -	return 0;
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1=
);
> +
> +	return err;
>  }

A kernel janitor will come and patch this up to:

	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);

so it's better to do it yourself.=
