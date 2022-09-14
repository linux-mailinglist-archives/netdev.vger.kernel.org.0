Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF25B8F9A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiINUNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiINUNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:13:37 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20056.outbound.protection.outlook.com [40.107.2.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E2715FDA;
        Wed, 14 Sep 2022 13:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFcLmXAK1gs2glL9Ef1mzYOfY9j2t8HR+5Up7xze8Q75891u4FXdNKl4w2gvuILqfLfqrgSezu83n3xwSlnKsJSivE/XaI8i7M3WfdcLccWMdvhxo0Ica9X0vQNqcc6ML22J+7dOTcnNEYVODGFFC4ac1AjJWvj2GYYk74pQ+eXo2XceeQkH+KvtNMcVBpY0c7bZYUp7rUSs1g51krAkPqxOdLfDCHF1g4mcy3usr4UgkVZPw0B+9o7tb/3HODUrqUufjTj37CODmRlejeS+X76KtqO24Skribb05KAOXTtnU6h6/Dv1nDGamIeE5na5ml911nxCXgtN9SQuVNQ+kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThkSPqrSDEJsB5a/nnx/oBtALfrnxRRCeKcDFAdTzRM=;
 b=ZJEBRfsoSDo/yQJd0D2zL0a8syTH/UJiidLV+KJ7304KoxKouryT6a7poMB5frxbPR+Qp7FrQUnIazvjg0bo0IRfGNXBC8k35m8s9Y5UxPaYeso4rvCrRzj17fYRQIwxDDk87+eZOrIREXoBvpAI/4doihalcQKRzXSysprS2YgS6TPGC6L2RCMBDGpkmAuDAtbsVX1mfsc4jjJRQxgTNRBMip2QZwrHKAiW/ADlpoByQ745W8Ori7fhfj4rjZoo/6w7yJc6MA7lLAKRau8Vt4GNwvXtZHUhChMa1ZWT4KScPiIvqgizROsLxKySIXXuXduWfmGwKjsqW2ilrghGwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThkSPqrSDEJsB5a/nnx/oBtALfrnxRRCeKcDFAdTzRM=;
 b=oxkGUNTsTOyJk6CF1lW0tt+VdUiJ3EetRptK0Pz5j7qLaA+jCvS4Nmwc605leekdkxmI1QHBza2RSg8k9Ro4eR2M+m3RVO9m3BumC9d3Es33T3XzgR24kUt3JOTSoMk+l7DX9OlMGNLwMwrWkRuADpwFm/yet17D/9a3rCLSOVI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7242.eurprd04.prod.outlook.com (2603:10a6:102:91::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 20:13:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 20:13:34 +0000
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
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYCAABnmgA==
Date:   Wed, 14 Sep 2022 20:13:33 +0000
Message-ID: <20220914201333.6o3u33jkxize5u6t@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf>
In-Reply-To: <20220914184051.2awuutgr4vm4tfgf@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PR3PR04MB7242:EE_
x-ms-office365-filtering-correlation-id: 94e12fe9-14c5-4a9a-02f3-08da968d99bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3DKFd3B9mhOa3NbmhvfXAYmbQgKkl4stzCBKL288VJV3qgBzEwb4tq6XaeopQJ1z9whSZ61zueOmJ7K6eOKDuYkS+bcY4KwDVNTG4x8KQvwClN0VBe9CnE6vfe0KrNF1qTXv3cNfua89Bljc2oaH5V9D1R1OCJWsf5uhXxlhPignEQ+U3/PfurGIm4VZpD/8MGRZWDdrLzLpVip7g1JoZl9tXMkrNUBp446mZPvNC1wIaJXcsWEOWqG7h+eR/yg264cElq+HGk7YWzWQLhnJQtoTMcCnqSiXcd4uk0hIoSYBXvPSCyApCAn4hOpgHm6pF/UOG0zZ26crXczasAyBmf79N1kRQiZyYeXxzxp0MIq0RkhIAllqgFFiOtpo1d4rGHKHtXuL9PAVxQ9zSTsbWu6DkdL+uzPXwZvFkYbrfwYengpPfSlBA51m2872v51puwv3wZfh4Pqiv68oT58TgqLhcKfUIL20G7UwjwL+P8W5zdDpoqQSHuKkrPrmYSZA8UNGDcm3bbcswRIsCXKtKCaI7UjFH1mGAu1XjFROUYBXpnLQdmnkJoKB8ty9ouH3cNhCZV2cfhIdwNa21IM/FGoLuEEu5ThRjfxx+D7+fj2X69BAmD/d2svjjkN+dx+0dNVzPsuE46PgnsyNckPSaonR4LM/MqNyCSAp2M2zWHDD66Cw45Id7BxVGVwypaq905f7Idma1fAbqr/4m6IM0Py/WX7M1AuTL11WMd3jfz0RhlaJRuWiBUba6/LO/JNyQEqdu/f9hzrzZE64QuMjCguWiaTn2mrUCRDVCnxvjDI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(66476007)(91956017)(6506007)(8676002)(7416002)(38070700005)(6486002)(2906002)(76116006)(33716001)(6512007)(54906003)(186003)(558084003)(86362001)(1076003)(8936002)(122000001)(38100700002)(5660300002)(6916009)(44832011)(66556008)(64756008)(66446008)(316002)(66946007)(71200400001)(26005)(9686003)(41300700001)(478600001)(966005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0g0bI6ayPEIFY3PpiTtBRtzHKBSQc1IgHCwa/X5wxZHY/BpTcigoWd0KHcy?=
 =?us-ascii?Q?X+xkOXyZcCfAmHRPupaf81gcwXhGnDZYFwRiLemIijoIt0UjDlA7m7kW5rxJ?=
 =?us-ascii?Q?CgifApU7rY3HZP52UovRafRotazbqWBhNhALi13Lmeg3E2nciXHbKe6bNeHZ?=
 =?us-ascii?Q?PwYollgVWKGyK/V9QTZJTh6Hd52uhRZly2pr/ouiOjUFXkIkO0FaWbB8JkAu?=
 =?us-ascii?Q?dB46uyYRgWlIF6zXl8sN0vFxD5mbbH8xKR/yQHYt3I1+M0WepRaFYVc8cF8V?=
 =?us-ascii?Q?XyQ1jHX3APrUWjetFfaqyOMIK1YisCEh9Uyt0q+8Op0qmDy4FelzqrunKiPz?=
 =?us-ascii?Q?lmKYQwtXvM8pZjNTctERVVlWfcAVmLF61WOGM7+VAwPUHOfh1u6CB6cVMHqo?=
 =?us-ascii?Q?9hJAuMKcXRp7ybRu80rEW9msbtvWtqIAZqTEL3Fpkej10sUK5av6bsiN25tV?=
 =?us-ascii?Q?fGfAoOxNLDfzG7XCawj9lhreDOzj7XX/bxsKkSQWWvmF2KIwNaSGUBEyWW4R?=
 =?us-ascii?Q?q33NY/CSz5BxQb6olxKhIQc6A4y5uP+xLUTaWRI3VkzlRQ+n664cnziJoz5A?=
 =?us-ascii?Q?CvRB+QrpT+oU1qwrgj3R5j2AI7rsA1NyfVfNeBzm/j0+9Oq8+Qf+B178cwja?=
 =?us-ascii?Q?6QKXK5H5OD7CFJIoqVCxwjW0wn0xraPeFRsoMWXn9BAGo7ISHzlxg719JO/z?=
 =?us-ascii?Q?YAB2Ay98/vRcnFlSk+X/aC8Bg6aTiocOAEZ/yGx6mxzf9M5BF1RVqdTiR8tN?=
 =?us-ascii?Q?DZItUBhSPqj+3O0rdzhmr6Wnsf8GLYU9uSrkGGIMiTU4/iB/NsyEuNz5Y2AX?=
 =?us-ascii?Q?gRj4Twg1YbWeCtGyJZPelO7rDxn3ntANZgwKALRoXBFd/OA3NUaOMdbZlJaB?=
 =?us-ascii?Q?9Zs9biLPRuY9uZ928ePlfeB8dL7zrBy2O5EOgUWrUNZL0YiVIJEd94nOcidP?=
 =?us-ascii?Q?kyNJk7iAY2xw2JwEHHdNu05cn0rDeYmch+O/rKNJ7OiWGm9ycfVu2A7c0iZa?=
 =?us-ascii?Q?z6S36UXogT6qztV1C0+2ocMShsCk+ugyCEsUhGGzb/MixSiLtaEdXe9gGptz?=
 =?us-ascii?Q?k56wcXx2sK7NHO7tyNM/OYhps421RhbV4+FBMzuW4yaZSOOAU3sUQYckpip1?=
 =?us-ascii?Q?sawu+/NCtCgEkmmSYFhyBgIUW8oic+y4Ef7krNQfenhloQ7VNKjkAVzu7QR2?=
 =?us-ascii?Q?hfdqMsFmtDEJVxhUFGisnrY911z93o+nZmG4TiP8dkz99+TWNehZBldb21Ep?=
 =?us-ascii?Q?PP6Cecqtx4H0vtFG/Iht5V4tYLnX+dMzU+O0WUmbAm7UVHt+ZAj2KNMuWg20?=
 =?us-ascii?Q?LOyI0JvvV68fvk4A2q9/9saTog1z2sdMBoaSFxbHLRxcUm4lu4bPv0aZdV5i?=
 =?us-ascii?Q?Dx1Rc+2/BcFiR2CsFAQ37r4WDLlEpqoiSPZUngHFvchHStZgUxiZMefQvtPg?=
 =?us-ascii?Q?1NXuJNQ4+aVdzZ5FxG1s/D0Zj8ARTkCmRMhG3Crlj7//42HthJEDviY/0g1Z?=
 =?us-ascii?Q?qopoaXfdKjM0NP8STmxnDNq3/PAD7U6V+eKmUUKW1TwmTz64VgX8HyqX6Ds4?=
 =?us-ascii?Q?EHP5W2rEUqUqdesAcj9rgISUDiVAR3k8DB9dCOvYM2u2LRQpoi3l9iepGQvQ?=
 =?us-ascii?Q?rQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <882325540B21F748B61946EE5AC089C4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e12fe9-14c5-4a9a-02f3-08da968d99bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 20:13:33.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffnT6VJ2OswivHOztzovWKwtoI7uu0czDol29QYnaqQU3ekYPHFEWDbSY9AwfY3gCgAmyl50X6YQkvy/2GYv3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7242
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 09:40:51PM +0300, Vladimir Oltean wrote:
> Nice :) Do you also want the iproute2 patch, so you can test it?

Need it or not, here it is:
https://patchwork.kernel.org/project/netdevbpf/patch/20220914200706.1961613=
-1-vladimir.oltean@nxp.com/=
