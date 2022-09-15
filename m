Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA175B9A3B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiIOL7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiIOL7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:59:38 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B013ED47;
        Thu, 15 Sep 2022 04:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKNRTajZJ7ZlpJ0zED1H7cXDojHFBynZ+HXm4DJlbpvR5ZA3GhM92ajX0C0Z+fT36UwCdC9XDM2myRbNMku7B3N9pJIMdwXiH6W9VpklUThIZwmQLSkjsaI8ONEleQF+/21EaZVQ6G525RdUQfEpeDGozFMgdtqz9IFpBfn2HPdl1jPPZ72PbcYPPdyY48wEREHi2RUSjTlYSOAhlufJbyLAyFBSWo1DUk4qdrtqwEAQgSoIJ4pPLJUfStlfnD5RPU4crOVwKYKHcvBTXwWa8VWG833zSNU5EBsoUQmmDpLUYqeZyPFWO6H4OBzcJO2p/MVKI2YHf40giffgcvcT4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w79YcrtU3recOW7ZsZ1w6mDzwd/ChMT6x6dazhrmaYI=;
 b=kQSR66byynpTVOgQjzSAJB1dD5vInriz8Cb5aChmF52nJH19BvnXOutR63pk/tYOlO3d2ll9hez0k6CL33b0nv2FDWxLLg7r7Ugufmtud3aG5/n55YJ7sCGmRhZTq/avizuvTyjGUCVuF3KLyXc8jxZbJb2vstMYIEXhdqDE3QVHtrF+S/NZnJMOj3D6v4ivZr4VVemq9abfkSnb80gAKwhZstgpYlbG37Ig0OPq56wnbJqCOxB+zrboRKSPcfB4LPtUGfJNxdv8NCqtUKyfV/7ARNfAjlLPHg+ivxbLS/HyCXF/Fd5qdTxy9BPy/e4YShNOAAdWfG/URDYPDQS8+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w79YcrtU3recOW7ZsZ1w6mDzwd/ChMT6x6dazhrmaYI=;
 b=KslzwADpPHBw0/xUVb6tyY+rwKvWerNi0/11ca0fooc+jmbUDvpclcd/GQBkRruk+eE5Mg5GZJ6623hyVNGyvVmgWnucGzNn2msphQ/QNwnwe+Lky/Tr/Zi2oQUSxHUVyQJpAXYmjtAdPLeCiS95VfRpw+W+Z1xMBfB/r2RTLpM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8638.eurprd04.prod.outlook.com (2603:10a6:102:21d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 11:59:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 11:59:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Topic: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYCAAMIyAIAAX/qA
Date:   Thu, 15 Sep 2022 11:59:26 +0000
Message-ID: <20220915115925.zujsneox4jqzod2g@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
In-Reply-To: <87r10dxiw5.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8638:EE_
x-ms-office365-filtering-correlation-id: 723c3696-82cf-4e24-1a1b-08da9711bcf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEHoQj9OAp+6J33wTUi2B+iwPdzTyQhqYCcYGx93Hp1cq9EKImG37wowdqwym7APsTCVcohGs/3bMJe4p0wHDqMv3JGpBbfq5AmpPwn3AfKJKMjYyQnKLYd8Z/zJM8/2VeDuUcBKyO+BLLp78Pr8xTgC7V4oNeWivf8NpLcqOBm4gRgL5NqASsfI2TzRFeeBbDl4MTVEmFdcOzIrKwS1y5/l/DbxvcIYcquFJrdVY3nLdqA4vMeW5fTS70FjwHgtI+sajC6S2xWY75wAKb6cp3TOKPWvkG/CPAz8a/w60yBgkK1vH/Xpyezw8TtKn1adUVa3E/w/DpNlL9sWSgNmpI0NGvWXHkPtdCwZVdHPqekUrjgCaGz0ZXlOVPsK27qJ7jWWzQTUCqehozOjOO/lLme5XKozmLARL479KUJBK0iwcxfh0ThfKgbrixgUsOVhYWAixB7/LmbpRgFgTiYG7AcGGTf/vcU2cmlyeQDBYF7JSuETmJ/c2B8x76futHT3R2pUtcA8JUPlQ82GsPHeaxhEzgcRA+AdIPaHx8MYXsK9BfDQ1QHvHex9EAIWEgVs4MUYsWv3Th3jv/05csgxpc2hAKFnF7JL48inr9XZTkMEkGu2rFpLaCtBCZy5TkD1qPlujlaLKYwG26AV7+8D4t4wJ4MoMTnwJ2WJXyC9LJ0jp95bNy0IkEjiKn5bz4u5oS76SaKIAIMO1iqTS8PPewrblsI7UuqXeyjrmkn143Cv++gtAE0P/GMFz94Qbw63urI1gSK4eYEXygEnvrrkcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(4744005)(1076003)(4326008)(44832011)(2906002)(26005)(8936002)(316002)(76116006)(66946007)(41300700001)(66446008)(6506007)(83380400001)(33716001)(8676002)(7416002)(64756008)(54906003)(91956017)(478600001)(86362001)(71200400001)(6916009)(186003)(9686003)(6486002)(66556008)(5660300002)(122000001)(38100700002)(38070700005)(6512007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n9rmdC3oxEksL5gNUgWljGjJw4Hdhw1i/bZcJr5+LdC77aJ1RPK5Er89LMim?=
 =?us-ascii?Q?v8HiW7A2huyiYvXfx0PimDVW2U6xvtKmncedexuMbZoc15+z02A82D+cLJWn?=
 =?us-ascii?Q?lxoVnigRyLFyY4OcTIl2Nn3hcOzfVcFW/PfpEn4g1z2Etro18YFZZ+cBOVnl?=
 =?us-ascii?Q?f09HBf0MUykV4NLuRYGRq14C59PSv+HDGNrzVtLaqZMJRrYqVO+YCoqikcZH?=
 =?us-ascii?Q?PpurTyAF+m+V8gTqVhD/bmtzr5z3NslzDJqPIOsiBAiExwVp/d9F29rti+UN?=
 =?us-ascii?Q?xDKZb6I6+qCFow8DD59MP/DkxO/ZttpI5x6DNCPjIf0yL6G0sfVa/ZxaJN2E?=
 =?us-ascii?Q?dsUZvvTa+9b3aOurnm9BRh+EamYzTDhLeaueqLl99zGFtxVqXCRkTg38ToRC?=
 =?us-ascii?Q?OTWtZD0twDV965jZRS5IzpYhp2thER5z/8F0VmdynyakingWk+MuAOBDVneX?=
 =?us-ascii?Q?NRuSt/LfRXDngn9U3DtsEGibFYK6u0kjCo9zy0NBfwJyDeejwufBujB8QayZ?=
 =?us-ascii?Q?Y0SSc+MvaH+T31JEO+aVKG9gRDzW3gro3mzU1bngB89iGif9tqPoX/L8tvMz?=
 =?us-ascii?Q?vqYkePUN13zad16JQEcYUP2Re4aaYadHITj9F/t2TPeLPenph03Dv7cb3ZfA?=
 =?us-ascii?Q?EpL39SxEPr0Mpq4P0Zb3iGI4+MEd+h2fM0GFRXtDEK801ryiKZhVXfje5rB8?=
 =?us-ascii?Q?Au5yH7y52alSIcE7IvH3B9TCsqv9WGpST8EajxrzjOYkAy7EU/BauzDyUkbP?=
 =?us-ascii?Q?ibl466NeUUfV56tFsek3uZ0XHF4SaynIboY7beNqJj7w8/WIKnAdCpIMVzjc?=
 =?us-ascii?Q?UwO0bMGInejAEcaM+wfkpgAaICFto07bwpIf0gqJ6T3+nEgVw7h4HWdvbM/j?=
 =?us-ascii?Q?mrLLeivnUwcSxnbPQT1V6dll16lyskLOHDJBVPXS4DQ6iav33BcOoFujcQhU?=
 =?us-ascii?Q?egCEIRUb73nUNUV9kBx0AW9FLhTg5KQNe2VYQatGM36HgcsxaCQcyXUI5XlD?=
 =?us-ascii?Q?BNlbY1t3WZG1t0oSG69P2ubj4OtuEzBf9Q5bvjcaq1WpMiyrVbGbTiDLPOSs?=
 =?us-ascii?Q?U4gQX76gHrT1bQ3isB+Dva0WCtS6jeqRo+vYxcJ0kQubaF5Fk9xYCOtPXUMH?=
 =?us-ascii?Q?u+M6L3WiShlgFnqxUBp6uiqDPTk8jyoBUeHVODhREchmyfBMWbJ13Z5VD7yA?=
 =?us-ascii?Q?++cy7+smUw6Hf/YcWMrgqAKrBhth/5JrObRK48m9GrAD48AgBJ1Z6WUCIFkl?=
 =?us-ascii?Q?iEDRXaA+DkB7WPZfHcid2U0ElYUgJSSoJe2K2YyMZ/qhilGkd0t5YTeDyrS+?=
 =?us-ascii?Q?52In0P9mQJsfRK9WxT9TkzR7k2+wzxowJMVFoLAAISKzuzYNm772cqxCmOxb?=
 =?us-ascii?Q?C+d9XmV8p4KbaW1y+O3HpcAOxTCoMv2RgpCb+ktcIMn8cmi7hGLlnisKSD8l?=
 =?us-ascii?Q?iFhrhklAzSyU6z8mS4Umu3rMtZZI3+oJ9dd2rjXMhiM8pSgzDZrkoEwr36Vi?=
 =?us-ascii?Q?OzoJyrYSATwt+I3lih5/2twMniB+d2U5b1u2JPt0tCWIGDv8JqcFOEHPM/qu?=
 =?us-ascii?Q?5d2Uf3fYZ9Qdr44I9Ja5dA4y7LLPG0f+q8OkXdxMFj7cz7vV7mE1iw7I9q2V?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <738D558986470B4FA11F01B6136EB6C4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723c3696-82cf-4e24-1a1b-08da9711bcf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 11:59:26.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +upSD9B9jbvNd2X/or6WmN/l0xnP7anciLom1xxlP1KtROrFygFYZr0M7ZVFE9Mt5YcWO3IcwMIPqRd2H3BQiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8638
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 08:15:54AM +0200, Kurt Kanzenbach wrote:
> > So the maxSDU hardware register tracks exactly the L2 payload size, lik=
e
> > the software variable does, or does it include the Ethernet header size
> > and/or FCS?
>=20
> This is something I'm not sure about. I'll ask the HW engineer when he's
> back from vacation.

You can also probably figure this out by limiting the max-sdu to a value
like 200 and seeing what frame sizes pass through.=
