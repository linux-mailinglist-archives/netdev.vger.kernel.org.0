Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A580F59A400
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350854AbiHSR1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354491AbiHSR1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:27:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EC4152431
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrqL6jZmrBn0/sXxGJA2C586Leqztw7Uw8H6FganziqSGfBosIAWOHpJU4fygfm5hZh1Qv7omog+GIbgU8xzayDt5xYBIDRkJJYzLFf/ZSSVnYMUX6V04YTdJgraDBTXBV1Hajsq9bI6C1Q4vpIRDPlevOpQawgJdIBTm3oyDhtbty80Aozp2QxRYpMSwx6L3kw+xHuq2brzYkv/VNupuKEJx18pV5fEkXr00CMYyFrIw4CKJ7uZp7IO42vSN6Th7dVMzaSLiookIXMtXpOgBmS7zS32lHnQ1krv/UNhtRCvzZvA5DEU1gsYZY2phz8vGHKbKtbnGo+IDmsmV7DvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgiEiQ8msB0KrR4GF84by2A3ivRK7v3XAMUMtJsacxo=;
 b=a6SsI08RCnBM2o+Ff2bJQYD8T6JLC/mYuVhm/DvbQD6EBnB23YVnOge878p2qIsPOQGJaIiGPuk5RojaZrb2MQQKj/GTDvMMfOrjO6Meo8Ro/CfuX0i5D5FaKSpqBpJzBazXH2VLHLsdL+XNTe7GMeMXNDQmrkTEp6p9HlzkTLZ+TQ1e/o3sQJ3rkpU0F4wa8hGJWlZmljplO+j5hdSX9Q8QiBLPFcSLi8cvSymxwJ3qHl2U5Jmwc4sbfGrc8hnS5/O3snHaaXkliFMbsiYEHzmKSAwQulLYhGvnGYAp3lOMKS0dPjqqOgv5jWd9yp03WpkJzi4+CERJqSMaKFpAEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgiEiQ8msB0KrR4GF84by2A3ivRK7v3XAMUMtJsacxo=;
 b=Asuc3Y75pWhqFU1nmkO0KQ2Me/jzn/YyjWCUz6of98s0zYSRzteFFuMsa57ttZBwTMC/G3JjPOAaHdDU1qsfPt2PogX4CVWqld2cLzLLzrXPXwx/iQcysi/B3JYZ1wV3ctsIvsCp8/E0QaTygb8NoJ6z/Mt+Mj4RYtZtrO1MGPc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4417.eurprd04.prod.outlook.com (2603:10a6:208:76::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 16:44:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 16:44:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Topic: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Index: AQHYswnglvLyEnQT3EOaMpXlfQkMiK21me4AgAB3bYCAACpYAIAAAEuAgAAB6ACAAACdAIAAAr0AgAAuf4A=
Date:   Fri, 19 Aug 2022 16:44:14 +0000
Message-ID: <20220819164413.bjpc6fz3yy6jwupt@skbuf>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org> <20220819110623.aivnyw7wunfdndav@skbuf>
 <Yv+SNHDXrl3KyaRA@euler> <20220819133859.7qzpo7kn3eviymzo@skbuf>
 <Yv+UDHgfZ0krm9X+@euler> <20220819134800.icr3qju7fdfdm5oo@skbuf>
 <Yv+W3IhA0d/0mzEq@euler>
In-Reply-To: <Yv+W3IhA0d/0mzEq@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7057c38b-e747-4875-d8eb-08da82020ce0
x-ms-traffictypediagnostic: AM0PR04MB4417:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwI/tyhUhPlP7jDs9t1ZAu48nqNHJDxRk60xwRtOhC2EDm1h+hoUR0e2AvaxukKZAc2XYk+huvw+f+9dbPs69WokSkehjo4mti30jRFo17is7D7gN9cOI+SHYPzXUQM2rGbWIx9FA6/W+hp3Pror7mrJJG5r23b0flif7zFj4rjqhXk7ac2PPyoE0ND/WNZV6JHOcm3gRWPj+I/DGd/BwEae6j6GmARyzKdTLCQFuHRdYiFmg6Ajv5NxJ3xPzGbLgUiXYzaE9DE7iQ6CoR4MjHfUFJLhkmM21aJstj7pTjZHO8EHuI+lU7pCY/epo8iod8svx2wSMIqfWNA5wRoz9otKCOpx45KQCc69aTxI6VjIYogS6b6uFoSDLJ4WVDehAlyWVdQWHKHEo12v3/D01Qixt8K91RlEKg88QE84v0Z4I7N3nElSmjVY+DI0z2dcnOicgDlxjeYQm17yv7y17f+FFv5OZ5sAVuXR79E2qGf0nEyiSgNX3da/qyIbkq65Ju+zZ0/vUThbC3BI+erkae+voEsGOId2CnE4PF2KlltkScFxUwwcOcWOWtQBOtta8mFwLPkFS6wYzFuMxoz8WKohqgOb5d+bT4mPq3CgzO6F1pAZsfssoVM4rTVx990u/OnwoYuoj74ldU09cU6QMBtnSr5Ha7m/wJ4wn9+C4pie4z9UJ2Uw6RI92WSXwvffI3c4FsJNYN803L/whJskjQs4xRkkJgnbHisLCQwUL1rebjUykJbBXS3jNMkiOKLig9ARsyNBIE44L8zMTJOeCLOE4MjpnjsGP6kJzGjxEzA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(39860400002)(396003)(376002)(136003)(86362001)(38070700005)(122000001)(186003)(1076003)(76116006)(83380400001)(38100700002)(64756008)(54906003)(6916009)(316002)(2906002)(5660300002)(8936002)(4326008)(44832011)(7416002)(66556008)(66946007)(4744005)(66476007)(33716001)(41300700001)(6506007)(26005)(9686003)(6512007)(66446008)(478600001)(8676002)(966005)(6486002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2/SRMRDOeKnfYox8KJXg/EbTgBN/F0q/rPtzRLlYpjvKfDdhm73fAvpRRVCa?=
 =?us-ascii?Q?yz9XN0FxIu26vPL6TvDEOrzUKsPmc+cLKngTEgWu00VBngiC4pO3eZCdCyuN?=
 =?us-ascii?Q?Oc2otDTGBuFMQ3pCTcqHNKLiiL0zmoo7gIZv/+g2UTCuYuYoklDwGfh5mhpp?=
 =?us-ascii?Q?qspMduuO8ABE09wCpI6qt7zFDlH7QzL3JzyEYV1o5YByINR3bjbugnyZiHBL?=
 =?us-ascii?Q?cpgqjUvl+fYJcVt4zBh/Bp0n4eVoLS0qZ1XkOv6x7JEnNfRvtKoBU0cw2Vxo?=
 =?us-ascii?Q?MHNMwOwT/aTr2yJMcdpGRJPFOksGR2WwECancIUTXqmBfrRI1U6C2VxoNlRC?=
 =?us-ascii?Q?4FcxExo1DuIMSkKhL672nYC//K0ZBjtkXtwpoBu39fSVnrUVOD4wzZ55TimW?=
 =?us-ascii?Q?6RhasxfmAow/+JXJVdAJKZLdgFpIfPnKXZEpN9RglJ1cXYu560imNe3JPTmW?=
 =?us-ascii?Q?ktG70WUYBl3OZgBY4fXCo8emKM82AgZByV2JeIwn9sfqNymnCC2COyYUkQnc?=
 =?us-ascii?Q?7Y40QzypOHBbjsDMBpJrVvvK4zZJhtfFF1eZ+8CzO1aMN9/SlQ7H+0wVAG2U?=
 =?us-ascii?Q?SjZfQ4SrXmOeUS/aNBvBeM0bc2SR0R8tJOUOHFv6IeUmuw/85dKATATSHPPa?=
 =?us-ascii?Q?bxJlNcKva2UdbMrf84fBm38q6+SLOiei8Y1zcbGbYVKaV+6NGEY4LYQMLCcw?=
 =?us-ascii?Q?mu7nUYHvbiYmlNnvWJcC+0J6I+50hfZ6y9Z7yDb1Y71DB7CqeHOfpLksitge?=
 =?us-ascii?Q?CNPT5UG3EtbSIljEkd0FOqTTNZCu7jWFsVfyTIGA6HbkC36CWHV7GWHwSoPN?=
 =?us-ascii?Q?48RP6axkrSoEjE93oFEUyO3eqqL5WeiOoXVU6u83nnpdVaCBtpYofoVfvdM0?=
 =?us-ascii?Q?ea5B6QUDPGZ2Xsxm09FaO7/ex+3a+LPvFBXRNsnXizo0sUFAUPimjODrom9b?=
 =?us-ascii?Q?hb2fOx2pL+AvDFN4Z3k05NKi+lElaDLD0sj1qYx0W615E2RWvImVzE4cls1S?=
 =?us-ascii?Q?rbEf2k++s3QyTMX4TkQerPrycDS8lFJ9I9YC1aXkiV3XinXnkHstPf1nu7xs?=
 =?us-ascii?Q?rSXrW0xyWXAw4GfYfYSldg4pdZ9g+VkaqmbWjG33GPZsDhUWZkzP56mWW7nd?=
 =?us-ascii?Q?asW8qLW01JWGly+Q0jCCN+EWWml0zxfk5GuoQSKdzqMPRtkZJJYoXN8kQsk+?=
 =?us-ascii?Q?UTllpRpW9BH6IaibokiB/cik19fVlUJeltz30aELJZJaUUq/Wd/p6SKa8fI0?=
 =?us-ascii?Q?2NlzC2a1ygx0s56oEWI7p+8N0sXCHqYofyILPQcckYO0ojkLSL/iOoYCsGs/?=
 =?us-ascii?Q?KdRDeNVTuieYa0ER/p+5bwY9IkhEg2gHSLlW6m8OSNag1bfPbwzve1D5+RT/?=
 =?us-ascii?Q?o7khvqSsfNCAJWuyyHP8mo6DKWCbM3NRhJO4qxkSFHbmmYUyYlleR7jC6r/h?=
 =?us-ascii?Q?uVmXhDPyS/KIgsCMcf9TplY5/+vMn1tRWlFd8v57KOi4INqPIQgRoymEcem4?=
 =?us-ascii?Q?QGxMNLj3lLZYA9Ylln74JpKzMGzREOXoQQnGHN0GBcwVU6GRjFMW3pobmOfM?=
 =?us-ascii?Q?FGgY6KcLGz2UZL1t+dO0bq5C1oeRNYu9BSdDMIh4U6F7yHuqebGz8ChYMkYw?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E60ABA7081C2E64D913B2089FACAA05E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7057c38b-e747-4875-d8eb-08da82020ce0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 16:44:14.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIbG+q8Q4f6w2rn9ZaQLgtPvdmLUmFKV26omcJhav7STxmRGDQ5fTIpbmYagpYtgZ5jvhRrpTyZPG2nREQRiaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4417
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 06:57:48AM -0700, Colin Foster wrote:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220508185313.22229=
56-9-colin.foster@in-advantage.com/#24849610
>=20
> From there:
>=20
> > +EXPORT_SYMBOL(ocelot_chip_reset);
>=20
> Please, switch to the namespace (_NS) variant of the exported-imported
> symbols for these drivers.
>=20
>=20
> I'm not sure the full motivation. But I agree, I can't imagine anyone
> else randomly naming and exporting another function of that name.
>=20
> Just thought I'd ask.

Ok, I'm not going to namespace a new symbol when 62 others from ocelot.c
alone aren't. I'll ask Andy what was the intention if I manage to find
that email in my inbox, and maybe I'll consider namespacing them
separately.=
