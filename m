Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C71582A86
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiG0QRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiG0QRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:17:36 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130044.outbound.protection.outlook.com [40.107.13.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D144B0EC
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0Qj7ggvsWpdP0hHG85AgQcq/FDhVMOv9sLzJWRcGUNwrTSVvwmofyDmSjTRFMA59GvPT66zoLujyo6uFBUrLc4AO3YvT0wQuflOYc3sAz276M1+bB99rRL733Ry/J4HvuicN3OMB/ZMAtmS5CnNF2uQS9kGidA/yi5/VzjWNmTraQkZeMPLKiEJHRpcav/O3YizHkffiZx5uPIHpOztGFBMqjNTRS6pINLHzwObFXDpGwTIm4btzWnGDb5uRnrkhvMZhaxgxIMGP4kAjwEHaOu0aQXKP2iBU7Dl7S3SnFWmdMyldFM2frk0OVyM/dIcZ+Ju7tOoAztfe7OBouyNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDvteq7ETuKm+nDWMDozvkY0rxQUyuLUUUSmJG8kVLU=;
 b=JERCAQU7sFdvHquOInyf7TsISRHzkePQba+WNYA15P8uH7jTB+D9gBvSUEh9iySd/QnZg7ax9x8VRdFc78jOA2ZW3Lab0sPMRQQXPCLzbX9hnOn/muPvTZHAt/ih1VX7LqW6t6BBBkaJgEvULYYww2LRr4ROcnLqdrg/p6Tdb51VBJjfElG2SOIZJmLA1e9udXTivYfa+lDItGhTpz6c8AfSPfA5Kg5S3FPHYMJDrs9jA1HcLNWVmB5P9TVgIsL6wc+BDItgmVbI1Mmn94tO4RaTcbg9ZZpvW2Gn3gL2j+an0QYnCvvD2Kh0/MNxcXT7MB2dj6L3iox4Qae4DgulEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDvteq7ETuKm+nDWMDozvkY0rxQUyuLUUUSmJG8kVLU=;
 b=GqH8fcLCLtiSGBPtI4GHXNddxkMcgmDq0p8hM8+8IygM5Gif+2org5+lun6zRco0hebX2VQkk0fJf75s1C0an/Fx6npBhhzaj3GR3gv6wYn+XBnhFTIzQ9fUDqwNtQRB/6+A65gBmVwn31+9A5Dc3QYBcC0MhKIB8FJorDwjs8k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4186.eurprd04.prod.outlook.com (2603:10a6:5:22::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 16:17:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Wed, 27 Jul 2022
 16:17:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net/sched: make dev_trans_start() have a better
 chance of working with stacked interfaces
Thread-Topic: [PATCH v2 net] net/sched: make dev_trans_start() have a better
 chance of working with stacked interfaces
Thread-Index: AQHYocxfY0zFlkBS9US2dNx8wJa6i62SW80AgAAJUYA=
Date:   Wed, 27 Jul 2022 16:17:25 +0000
Message-ID: <20220727161725.jalgpkk4zvskdfh4@skbuf>
References: <20220727152000.3616086-1-vladimir.oltean@nxp.com>
 <20220727084404.34ebf5e6@hermes.local>
In-Reply-To: <20220727084404.34ebf5e6@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49636341-808d-4c23-4a23-08da6feb7ea3
x-ms-traffictypediagnostic: DB7PR04MB4186:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H2+hDLRGo78Cx/fZvi0CzqH24Uy9Ugixe7/NQ2wnm6fCL4C+IMbdQpVOgg4lzl6zHsWbWwzldrB+J01K3OpIB4GD7ApzNGEi81BXMKf/s+dT1BSxZR/pgVFyfkTzu0D0g1+v0W7ZxiD9rkvvgzlCKvHMhBGFH5XtUPX72pbYklRUavhuUeI4ClGz06FBi19GmEjKvutbLusT7PQYpxK3qyWFu+viffPf5QJbKvTP3QbR1VjA4QDUCXgjJCEMB6mDYgE8mNpIuHRWoqiBotJNJ9HZRItqMTsqNviPTcqRuMH8U5jj7zkCSDsKdJVUCxT45zrxymJzrhHnmJqokUhYtHqO7whknvgARlhzq8jmKWQIeKZmZ+MnB/OK+Mt1J0vywZmiyGAsSKW5sleXgfwxAymugiNnobFGOcjF7/bFOUWnJo3ACkbA/bRMxMi9V3zGYTuKOP2Uy6BwmXZ8fyE1+QFRvO1TQ4XnXDM3VeWwKVi3tPcXB4DMaVwz80+KNYXMODMxb1sV0BIOJmzFwp4aFyWfIYMvzLHi7EpL1Icfi/yQ7BH4Avyt3mbmouFzrlrh2uStzo3aOMOMXxWmhEB1ubjNtAyhBromJU61+ZJWJUwM6fUB62jl3c0e7fDXV8n5q0/cX1Hz63mSGF8WeI0a+O2/ryVWUQCrrqivoFigtXInRKQT80Jh8Hwb8J4isfwJTtQ9nLZNkBH+hf/b3hdct0kznovrJ/qyixc5tXTDnpZH4XHTZsocYgF0UNkiji8IviuJE1r1sVCN6CAK6SQUTGCLO7K30szWJRWwmbszuRk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(136003)(366004)(39860400002)(346002)(41300700001)(44832011)(2906002)(76116006)(66476007)(186003)(33716001)(6916009)(8676002)(66946007)(5660300002)(64756008)(316002)(26005)(38070700005)(1076003)(66446008)(9686003)(7416002)(4744005)(6506007)(91956017)(8936002)(4326008)(66556008)(6512007)(71200400001)(38100700002)(54906003)(86362001)(478600001)(6486002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ivsSFJzfuZJuIY1IzJmJ6TdHAmWsWzPz3LffDsfyXlG/Jv5Twpuju0MYOKeZ?=
 =?us-ascii?Q?1FR8n2FNFZ96k/fN0ChXRY1KxdbcsCPGmPkSvNGiiweCq2gD/TlYcyo2jxwQ?=
 =?us-ascii?Q?xl/12n9ZAihbtZZNXvcISkQaDMC91wea9opAoPNB/XrgmB9OJwAYg69I/KI4?=
 =?us-ascii?Q?7aYbJvgJSl1IQse0LubcBmwq0UHAtrTAbVIbtzVTdl6jI1JAL3NBHTNODmpr?=
 =?us-ascii?Q?x6Pv8UVzZeIxCkcepkTlPEXBf44DVdJUyM57el1d2N+lfjSZCIvS7CR0LPZ/?=
 =?us-ascii?Q?iC4PajReSQk51BhCUnagjeKJHKiv8m5Lan9WRi8t+ChEOBQgvViAcAok7OWS?=
 =?us-ascii?Q?u/+yk6k8xK0I38eeg85UbXa6Gv12ITuTdNIUktIB6n3Kfmr4YAE3ai2+dcno?=
 =?us-ascii?Q?zictRsXhb9ZwmXljtRdtpmtzQ7sIY056e8WjnqkJwNEzNHuK8/WIlhneJvaG?=
 =?us-ascii?Q?IPI9gpzefSlvELZdD0XpX+kv3MN5mfHNtV4j6Pcov9S9yzFyejY63BJjJa4c?=
 =?us-ascii?Q?21HDnnlrP98IubOY4Gm/T2CKqxEeXaArcMdOjryqt7HGM2p17SV7jd1E6SK2?=
 =?us-ascii?Q?el7r0ls1Vp6TbaeJPqBvVDyEtSg1YvBAa/hwBirksn7HjWY7NmlZNERc6wyj?=
 =?us-ascii?Q?K+afjoz/jzcEHIjmhwqUl+na4Ft32yi1aEQ1SKIcYQHWeHvbLTv1WJO0dRMo?=
 =?us-ascii?Q?qNSx7UgT+bsxYd6E5DuSIrX9IbgsUNwPV6vZSt2LoSOTMaE7Ryu6eB9XHLSV?=
 =?us-ascii?Q?rd+xxJOEpuDYxaAm8n4uCtmuq2Kw7k4lKzlmVQpMwusQETAClc8sF9q39E+W?=
 =?us-ascii?Q?+ULB96FHIvVIv1r89LuUdpqvIl6vwu2887fbjCUDQ+DXiMNrrJUNXufAjhkd?=
 =?us-ascii?Q?IkZlo0gr3hLswYM5r6CSf6SuWoMDXnIiJUJgG/oyIyNoCUQvYmuHlIuj/QqH?=
 =?us-ascii?Q?g54gM5Krh4/rgr70qwR3cyPa9TcEAM7cbucJSix7wRFiuNDcvd8SaA60+yVY?=
 =?us-ascii?Q?W1h4vScTd9w4Dz0G+cKbToHlcSLDWy+cCrlShkLpW7X3cOr4WN1s7Uw9pBt7?=
 =?us-ascii?Q?0WDev5CzNgUReJvmC9nSe08V2ZxjwTiHj8fgkrBZ5z+bEu/j3sJUWjcgxs6b?=
 =?us-ascii?Q?Ij5wviQ6tIgbmnKHrqaLQOjiQYVl+kzxPKCI1Mr+nvFh2NWOBvWZkca2gPYs?=
 =?us-ascii?Q?RQLgiFkFdlK9Cl16xxod2XzqlXFDLtBKiP1etNnKBG1X0ni/xU3AL6M4KbN0?=
 =?us-ascii?Q?nWEuDgjD355bzWuh8gB2VtLhpvGOYjvBT+KQVbOHeS+qnmr4YjshcOcj41F4?=
 =?us-ascii?Q?KChfRSxbYiBfQUDV+JUUGA6vaMc6Ed42Fl4qkBRvlN/cE2SjZe6spBRaWsRB?=
 =?us-ascii?Q?DpKp1HZxrr7tNnkrI0i4nuabN2F0q4/gYRQZDi/ySevcU16tT9T5EcWymECc?=
 =?us-ascii?Q?emnJXf7HPyaPVNkUz8xUU3aX9FuRA4KzNBfksdPXIPdKJ/knLputLpeMJ0+N?=
 =?us-ascii?Q?RwFK3PTxBLhunD0KlvSur0113OiiJ6zAwHLnaV1nLLvI5pVTKcxue8HcDxE3?=
 =?us-ascii?Q?AjvHx/t2hNC7ejqicUKpFIFIcQXJzRf7oNrgUQJfDVc4yqWuL052YTuLEiIB?=
 =?us-ascii?Q?LQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <254717022BAC5341BE902F39E95CD032@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49636341-808d-4c23-4a23-08da6feb7ea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 16:17:25.8349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7qG8x9A0ZhlgEbcESMXCiE887VRJPRkLUjuYYxNjV/aXGnpVNdd2LbRaOmRdlmdEAGX1+FTybbQEA9N2M3NGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4186
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:44:04AM -0700, Stephen Hemminger wrote:
> On Wed, 27 Jul 2022 18:20:00 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> > +	do {
> > +		have_lowers =3D false;
> > +
> > +		netdev_for_each_lower_dev(dev, lower, iter) {
> > +			have_lowers =3D true;
> > +			dev =3D lower;
> > +			break;
> > +		}
> > +	} while (have_lower
>=20
> Would be clearer if this was a helper function.
> Something like dev_leaf_device?

Probably dev_leaf_device_rcu() I presume, so that the caller takes and
keeps the RCU critical section for as long as the leaf device is
actually being used, right?=
