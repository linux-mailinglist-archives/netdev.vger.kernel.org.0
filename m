Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00052342C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiEKNXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243467AbiEKNWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:22:40 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE4C546A1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:22:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLh41DpXE+WCkQbfDbdq7nJa1WsbqL+i4pV18fDXd7+qgPCRefw8/iFZxzrLHj9xEFIuT5tlqp7bYO6CJCKYchnjXO2XffRBmI59LoCmzAO2e+dGcjynKOvVsZFDFvGWWw1h4PCVmee+8D8ngwYrH+pgZZDnNtl8vtOfI47zG06lp63HE53D9gGAh4fn+11aF9uxKzdO9HOIjIMjAOyGPK4AL7o76hvh4mvOn51fSTyeHFWjWM/fSvpg3QCtMSQ+1nPA6UCX+qVEtXTVf0zl3/chL2WRcH7qdcCxa5A7B9NvZIlP8r7NqIzaf43zz13JIxpT161nsm8HsYslrlecxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7RoLMHumTHZWzDOMH1m6lkRluQTNObex3KVY6eNAic=;
 b=kyNYGL5JeKhs9HJoKGLrGtURhfbUvyxe9uW17rpuuUoD8qU+aAG3AWh3eLmQSkAL+WhwdRDgEDnjDWjSOfbEdOLe1wvbehtUqbnposlGmsE7pHvrFMhhBf4XbmKE6XTBmh8577SmwNKIwVbw8mZ5V4RJjWodtg3+x8BKt4Hl2c1yMn8HR40l2hSOHka6jDzurMZ1ykLowRkybHFfVy79P690IB47PHTsHHcF1brMVqlhgpA6jJSPNJzRmpZQscpCqFf1M8y/Fiu6DsBMjWKrrUgzILvJicC6o5bV9/4JH/GQcIc5GDPhmSx7n37z9u/GsjhY7Aos6iAFQ0l8d5lkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7RoLMHumTHZWzDOMH1m6lkRluQTNObex3KVY6eNAic=;
 b=gcDpVmnRwT/aA5FQeDn9tLEa6yBikbVlEjYVS+UBltb/K/aLrdvF7uBYsTxLFcA+UiBFgSTPMNoeDZeTV6WUHQ42sa822lbrEAKYeWf1d/mqcHO3Sh/ZEb5lGg4I80Y0IY4dqKa6zRqSFgjykr++Vzo9Tr/kVe90TulYmmC2xWk=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM5PR0402MB2691.eurprd04.prod.outlook.com (2603:10a6:203:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 13:22:23 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%6]) with mapi id 15.20.5186.021; Wed, 11 May 2022
 13:22:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Josua Mayer <josua@solid-run.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Topic: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Index: AQHYY6DnAmQzgFUDN0Gk/Ykea5Hhha0WswAAgAEq4oCAAc8mgA==
Date:   Wed, 11 May 2022 13:22:22 +0000
Message-ID: <20220511132221.pkvi3g7agjm2xuph@skbuf>
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
 <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
In-Reply-To: <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38393c49-42a8-453c-6799-08da33514876
x-ms-traffictypediagnostic: AM5PR0402MB2691:EE_
x-microsoft-antispam-prvs: <AM5PR0402MB269149EE91C3269E1AD96065E0C89@AM5PR0402MB2691.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vG9gPI0paOV939O4Rhz6yP3RzBlXpFuX+HchoOwnq3Pkhsa/Oq+E3w21DTGM+hIrxosewUvMS8O2XWMH5IcRXzZRcjwMYw3Ug4WZGXnIf4O+4oV4xFDNdnySNOksPFImTdnDIHEjHxLtVj361hvAcgKWQ0UxL1YL3bMwyDAqPkHsSRNfwbHXOLHJnU2zJCM0aq6XcnFscgEnqld/LoraCqZehtxVFc6ocqCqwfqq4t5nUQW77W1CJWHgPsuTMhyplYWGPViCKu56PoUSPe38Wb+5OSdgTZQsV/ZnntUx8WwYKL2XFx5zeb1tXp5yLxsccwqdvsudm4xNXUZ87ls5TLtM1Fi3rQ1aptCX0nZOZip8xymV0kQ+d89Jp5ihyVbVeRqTEfP2jDC2brQjVYM0PsrD4liEC3OwXC1+KWkiKM1DFBB4WT7dKuRMiBK3C3zDmZQf+n2VpTjt7nDerNCmmEolhH1MQvoq3Yyf/dIGPvRWwaY3s1tDXSUqTdn/0l2xhRNgGUNZi/Np5aS/tGo5FMEwhmi3q2UIHNFq/yYbQQJtqQhplZeVj7d9tnfdhfsnoM8eUxmNVywjmEdAl0GBkncX0YIDmrtTEZU+uiLLuyAVIfc9KUdaCyswTfOVtaNuXzCyx5qxU9+MCJIZxB2ROTgdsNTBti3zkYCRQECdXhZp/Vb5tC+j1VuA9me0xtYQ4ylpaOyHNT3cLp1G31/TvT2sPBr4Xc4VZoQ7rjHMJp8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(91956017)(66946007)(64756008)(66556008)(66476007)(66446008)(54906003)(508600001)(38070700005)(83380400001)(33716001)(44832011)(9686003)(86362001)(38100700002)(122000001)(4326008)(8676002)(76116006)(316002)(6916009)(6486002)(8936002)(71200400001)(2906002)(6506007)(26005)(5660300002)(1076003)(6512007)(186003)(403724002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IArRa9BnmkwujNuj5zFWzs7DMcFUC8W9+1TPwAbv7eo2yVrw1zJ2ngkTwWps?=
 =?us-ascii?Q?l9lh15jX7YVawk/Fr8J6yFR+lGUXwppt4U3xIYW6jRJ0KMR1wctaHLgg9NFD?=
 =?us-ascii?Q?2gzcMntzpwsMhHNSLKYxrl7FtFbxoa7aNUD82mAxSzToOukxAyFAPVfNkd4m?=
 =?us-ascii?Q?1Dgv0MflC4dpHqWGs8Rcg242wqBoc5uboVZZGYIr8f2BZq8R+gKTVGh3+9ZZ?=
 =?us-ascii?Q?cQ5wkYAAB6qVw3S6GHpJSmMlE2ICI1XRKhJhOlw8nmdbj0FTy52NJf0usOJ6?=
 =?us-ascii?Q?PElrknL/rMc5i+lm6tp9FAFse19lLPnkLsvHRVS4HkkRrmOvK5yVszp30L2w?=
 =?us-ascii?Q?vaf/vAiVbWCs0ggvezaf0YqP90KmJAouzzqWMk7TnHE5EXhqRr97zKM6BXMb?=
 =?us-ascii?Q?690ZBY9wjbKNNLjsAclU44CrII6fv58TQRdJNFB23jOpQn7mdqSNtBsSaCGZ?=
 =?us-ascii?Q?ZpiXKFGpMwxufIgZbcVP1t3jE9oDo3dTVnTozbLA7aCc/F9TAO2GQ1na6I+J?=
 =?us-ascii?Q?IsMtXKwXTWaV4ESAJkrNxVxe0bp7HWJWOfDDEv5chAC5JXfI4rbHEvfpzdvT?=
 =?us-ascii?Q?vA/f31wIewScIL02MSbCWVLGwGMTBU93gQcajkn/fcTBKokBPsTcQyxOXrDN?=
 =?us-ascii?Q?FYeuLlVBiUSCmzf+q22E8YleqjB4JAAb6krxG2oEWgwFU+2UbEoA7iXEKmx0?=
 =?us-ascii?Q?e0XbvY0+57ViCWWKpPO/oiUwF0WJBn/Q0VIWGk9w+RpYHKInsV2caHi5Rymd?=
 =?us-ascii?Q?hXeJd1nwceFX+0cTDmVaJ05Z5C9nfooxohb3+MD44uUQlBUNv4F1ozDvVQpC?=
 =?us-ascii?Q?hxmGf1agyALFHJP1+Cs/GeYrLoZ1rRMjtv9U2aV8wsr33cPeGhtNtdx0sAN5?=
 =?us-ascii?Q?PtnZdKjUvSg6ByxaHgQ00HalwFp1mQNJffPH0SJRpXQfIrf4oeGU/tHzwbCD?=
 =?us-ascii?Q?Wa2IFL+33J+QPca4kyn98Hieja4tBQ/9Ae5fMbhFEk9dS79Xa/k5MBh6SNSv?=
 =?us-ascii?Q?NRKlBecNkN6eWvO+QyvjF4LdZEZ3PhgQSumCa50jiMUK52n+ayH7vdghrGDG?=
 =?us-ascii?Q?bwUI6BLut9HrRZXTqsCdlUgPD0FsJnR18bkRMlfP56Hodh69bgan3CUsmUfi?=
 =?us-ascii?Q?98n5nsNpWB5viaFoELpjyt2xRUgWQfiSkr2WnXFDXz0tLat0HsP3FFgSHW88?=
 =?us-ascii?Q?NP6QJhoTlLfpR1liX4Nk+syEvBcrJlA8MS5wBCSUHVp9j7Gm1sM+08Uhv50G?=
 =?us-ascii?Q?jW1iwh6KgromfdO8bBoa8EqZN89bfbPUf1NRjbbrLxFLw6KjugoRgB3tKAFl?=
 =?us-ascii?Q?aE5xB1OySXSk7mw163XaRe8xskA6oTA4gZaRDZ/z3mYMxxnqtqUDDuAI5xj3?=
 =?us-ascii?Q?YA7jon93ZddPGFr5DwHpWXkwJYw0hO6wQ2o49L08aUXraXMg9yrTZ8VEcVyg?=
 =?us-ascii?Q?oVUcThVjuNiOrRG7j8//8QhYxbegxXB5bRYyTnmLJFtVUXxX3V1C/2X3T2xX?=
 =?us-ascii?Q?OzHmqBZX1qy8XpNcKrRZyvTy+RhX8sVTrkn6x8n5E3hZzTMFLNLLzz5Bz9NP?=
 =?us-ascii?Q?SPt0xiisTpXhiAwenHUfAm6RI8/xbcQLeWcZp7wiQeUVJ31ZgrVasuSW4xKd?=
 =?us-ascii?Q?lmuolBNEnaZ+FGD/ujTja/kMyTOsYXK1X4kI8MeodzXOtTPML16lwyrMUHK7?=
 =?us-ascii?Q?86ZwhKlh51VBUvMmRDDU/b2eA9aBObGqX4Jtj2zJr7V5agFk1rwAOJo7jEip?=
 =?us-ascii?Q?dQAe9/LLyIm7ril2UShR9P1iM8g8XIw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <297596077E684241BBF47AF971441DC1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38393c49-42a8-453c-6799-08da33514876
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 13:22:22.6808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8DpfcVaItLlSR74T0YvIax831n6KKTLPiZR0mQZ3Wpr4//HZILJAO9BU8JfA8TYFSwEWgTxSPldkLKNjstnJMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:44:41PM +0300, Josua Mayer wrote:

> One issue is that the interfaces don't have stable names. It purely depen=
ds
> on probe order,
> which is controlled by sending commands to the networking coprocessor.
>=20
> We actually get asked this question sometimes how to have stable device
> names, and so far the answer has been systemd services with explicit slee=
p
> to force the order.
> But this is a different topic.
>=20

Stable names can be achieved using some udev rules based on the OF node.
For example, I am using the following rules on a Clearfog CX LX2:

[root@clearfog-cx-lx2 ~] # cat /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", DRIVERS=3D=3D"fsl_dpaa2_eth", ENV{=
OF_FULLNAME}=3D=3D"/soc/fsl-mc@80c000000/dpmacs/ethernet@7", NAME=3D"eth7"
SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", DRIVERS=3D=3D"fsl_dpaa2_eth", ENV{=
OF_FULLNAME}=3D=3D"/soc/fsl-mc@80c000000/dpmacs/ethernet@8", NAME=3D"eth8"
SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", DRIVERS=3D=3D"fsl_dpaa2_eth", ENV{=
OF_FULLNAME}=3D=3D"/soc/fsl-mc@80c000000/dpmacs/ethernet@9", NAME=3D"eth9"
SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", DRIVERS=3D=3D"fsl_dpaa2_eth", ENV{=
OF_FULLNAME}=3D=3D"/soc/fsl-mc@80c000000/dpmacs/ethernet@a", NAME=3D"eth10"
SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", DRIVERS=3D=3D"fsl_dpaa2_eth", ENV{=
OF_FULLNAME}=3D=3D"/soc/fsl-mc@80c000000/dpmacs/ethernet@11", NAME=3D"eth17=
"

Ioana
