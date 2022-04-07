Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED04F815B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343829AbiDGOPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343827AbiDGOPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:15:47 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (unknown [IPv6:2a01:111:f400:7e1a::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3750C181D9F;
        Thu,  7 Apr 2022 07:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/xXwS4CgFQgvdYUYadAQ1SnNz1kgVCnuEYFJdasiTyx7PxVBDpS23a1CYe3N/lcqEq0laJvNiz9iXdNq0j3m2bymxdBxsDLRwhCyD/h5Cz1jcYqL9owQ6Bg2/L79VgxE8h2m25/l5fUghmM5Mm1BUG0w+sflpocX5Y2y2vwa8PgM8V4bPJ0DF/iT0A7kzBmmCuv4b85YF2Ee+ZiC2hRmLQSvuRxKQ8uEGs5PhtDUrsgiYesnN0uH+rFW9X4fajXSCc3tbKgtb9Bfh5s55aooKnpnXcfSEoTWK6VaDSGr1xWgcWrE+dXa4FH5BQP4ucgG3yW11vRhep6wH/kcRU3lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5AuSybM7lqpfDgIJvc2PnVUIt5WOR0RSMdtM/o6/5E=;
 b=F3zGThmn+xbqv+wtdJrFzFn3QfulRfzs5g/WPST8oh3Pr8DXRzNxZ63KlUsPRIarrOcGAgQOmz/tcq9lwJJfIGOtJZo8RPfQhScP0g/pSQVnHkhyolPctArijRiMK7KXdClfxh6HiqwnuSJTjvezxLFfFVrCCZoohMDFpVCXEVOhiAlvvhPC4MekjTeoF0Z4rK1g1Lk+PQpBx6WELko6rfHtmcHeHNKPdB1J3RwTGMKNsvyU+by/QQmZMwJ3vkRaCJUjtKwUf9XYsYjkFevsI+7B5MyqVibg6sFzlW+ACVKGoOO6hdJUeWwyXxt0ALvRyEjm6qmM+dStOmsKT7dNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5AuSybM7lqpfDgIJvc2PnVUIt5WOR0RSMdtM/o6/5E=;
 b=jWwK2UJaurqYN3Va0tuHSQxYe1ciiZW6nFSuzR3vQQA4Mpij3raXvHZKxBPFUtjpCMw/Ya9JeyBdSk5RiLwEfM4gQp4nOhjxZcWJ0x/KynZTuY0pRVJQ1HDotoP+OJ7ZMBfinFt21ynz300l2kHm0Wps2C8KJThZDwiDSnI8EAI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6542.eurprd04.prod.outlook.com (2603:10a6:803:123::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 14:12:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 14:12:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Topic: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Index: AQHYSoBPV1WtqVE8g0+FLgf3++d+o6zkeXuAgAACRQCAAAJkAA==
Date:   Thu, 7 Apr 2022 14:12:55 +0000
Message-ID: <20220407141254.3kpg75l4byytwfye@skbuf>
References: <20220407130625.190078-1-michael@walle.cc>
 <20220407135613.rlblrckb2h633bps@skbuf>
 <cd433399998c2f58884f08b4fc0fd66a@walle.cc>
In-Reply-To: <cd433399998c2f58884f08b4fc0fd66a@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b4c9078-aa35-486d-4c45-08da18a0b60c
x-ms-traffictypediagnostic: VE1PR04MB6542:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6542279A127656A8ECC0A527E0E69@VE1PR04MB6542.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WaENyO3fDwqPMz+vp6BHmSfR2TeveRa0XPqTNF+bMKZ92Ety4fhQGFrAmkCIsbkVrc3L25QPZ5BYvSDQ8Wqk8/vJTBcxFUsGygG67r3mEqGcbBmIF4rZSVo4XLZ7fzc62uB/y1u/gO5dmSDWz9aS65AVR1RlVLHjy66V5dqWp2N7yLswrWYmuRZaGYrLa1seY1Gjyn0h2fNL5KXinxXn2dWMCYRcgsbJA853AmY+BtKkZf9a3liNNxCQWGGcb0duoWLcETQYwzJLRIm1vS8GUgIloPEI+evPLcCHs34jMKqZuhYcyWP4x9h4fH68BEl5AOZ4aXxKMWYs+WlOBA8J3f0CuIG3omWZZvosBCDI2gp87K0UIiUf27iagj0y6Ied6+2kr/ujlQeeyloTrilRgBtR2hDaSMHjraDhsO4Yle/UUfVAnOsJqvBE/34jYxsZCEEW456XNDStp7CUMrKVSwhCz53mKnCJ2q1MLg816bD7tdwV51HM1eHyQtn8sWzCg8acYMlDsw/Jcyw6hbt+2xysdXIXDjfgCH3M62m5sqrIblBQLnMH7yfmY8bSNOvpT82tpnw5eOoMZ9FOLVV0uyX8lGbDVk5vE+6OYJcGnc6oGlqL7l7/hGTEWP/7yE9If5IZfOIenp7hNAgBqZ03Z1AZopPNmbw3nfHJwDJ4L8o7baHCgvZ5m5qJgX70e3TQKPMdpKVdZ5KE7vZ63tjGew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(26005)(316002)(6506007)(186003)(508600001)(9686003)(6512007)(33716001)(54906003)(6486002)(6916009)(71200400001)(66556008)(7416002)(8676002)(38100700002)(66476007)(4326008)(8936002)(86362001)(76116006)(66446008)(64756008)(66946007)(83380400001)(122000001)(2906002)(5660300002)(38070700005)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RvQ1GMLHTMy7YxW7f4w0VCeW2Y506dx2Qx6KZqizPJawHviboX8USZDugw4K?=
 =?us-ascii?Q?FdTIE9Cr+q3dqPNrZ3aepaE0mL/lGxyS2FI1wecl3waFp8e7+OT9aGoepo50?=
 =?us-ascii?Q?2NyckDW0+r9un+j/PY+kE0Z+pboFgTzZNXBylMfYsrhJTwbd2npfH/aZEsZu?=
 =?us-ascii?Q?ZhSDzzktJNJ9sgfGL5DEOOJvwIS/aInQwHBhyPvipAk4adk742fXCRw0AuEw?=
 =?us-ascii?Q?UMLKiQshwjstuS2KVNnmRaZRM5eq9yDfwN8ffo9OLmC5Hje3oBPrvGssVGPU?=
 =?us-ascii?Q?O7rj0mEhwMjPgRyMCZLW2Kc4BG3+qTJRN/gIXC2QjxCWBx+Ni7g2wPUzmSPs?=
 =?us-ascii?Q?GMxYFUgYkB5PKIV6TTODBquBpfbyjhXAjm/mjcaRj2Q+xYqw7OqKJsSPuGcr?=
 =?us-ascii?Q?EShtcMSMvcjeh+wqX40Dh5cxgcBAcK3TJs6M/YG/jqakm1Nmt/eGs+OktbnJ?=
 =?us-ascii?Q?xMkGz2BM+27TztIkQCsJC4vBNTH8NRJM7UZRB0fBydH2fhmvSW4J6DGeOsyj?=
 =?us-ascii?Q?kPuhAtYd0KykSrcPHwhqRo4B+8v+giqG9ssWSZHgvKM1Mh3c6ZkN2AS/QlMv?=
 =?us-ascii?Q?7UsHHsD8VyFJFxejLYDa/eljqp+XBNd3net681QlmuSwZW5+vL1hlsWUBIdL?=
 =?us-ascii?Q?ZzCghKJm2fgwn/f9ZY646X3RRVdSKfHqNX0QhCr6gpueWqEgp/IN6TP+opF7?=
 =?us-ascii?Q?k1Th/3BzML4Ri1hJEHUJObenW/7vR4n7KmvA8sR9/rQIT61SHW8wFl9dJjN3?=
 =?us-ascii?Q?1ycmIKpMqrU8KlcoxYniEaJZFNTI7bhLdZQxjXDqVydRESkvn8/XEfUDI3iV?=
 =?us-ascii?Q?41wnXPLgzHbUKfjAAZfXFOCfOP2ThioCcUTSGrDXhEbKxDI0lfTISZp8E1UA?=
 =?us-ascii?Q?seneBlXLRVXnz7UiwWweqzLUTKOJd8iErxMbYMvBzExHucYzkRbbslx+ghwe?=
 =?us-ascii?Q?WI+rNC5K0fFCJunB2kyNP4LgVydv2eePfDBlhUW/h74KJ1Z8V8DAcfGeuNaO?=
 =?us-ascii?Q?Nx8VpJT1v6AvVDg+UJC5ClF3DzxhiqA+30b3JhT7Fjp+8gnE+6syNZI48X8a?=
 =?us-ascii?Q?qi46Z8baWJrSLPEWIAWssXJYA4YeddGtBlWPOLBU9JmWLt5pdXgKaRY4Gpk7?=
 =?us-ascii?Q?VDGrZzfohr389ItCvm/C5WpBgLAqG3Q2iSbp5TMcjUlLjuplzAYXSNJFia3y?=
 =?us-ascii?Q?7nLMmOTYJGTjOF7koFxXy+H8SgJMN474DZBOdhQtTENjAZKvHOhJS8ay4AvD?=
 =?us-ascii?Q?XCrBiH3cF+tfRfpV7PBS1UZh/hAx+fih3yyAGZ59MNFYjZHspVOePVgb7aAU?=
 =?us-ascii?Q?JvVXlB7uElKMa/EIEmNd9zR/l9jCNkw9gOEcvMUmiAP2wKS3k49RuzQidtgO?=
 =?us-ascii?Q?V8Gg4fiRYCacie0jR/O7OA8EqpdiGOvCuTwiT/NAYvS4/kbfbHMZA0zyBbWI?=
 =?us-ascii?Q?t6C1SQtlweUco0Fu01VWwleNFIYhLlYOt7DeGvXpxfMRYMiM26pFZj6QHbNk?=
 =?us-ascii?Q?6To0P6+CmgRp6OPi8PxrQN+nPKfMIu7ANjaqxULx17xsUrTDqFcbChQ76pBW?=
 =?us-ascii?Q?Mn4gJ7jpNaoaei32NkvISIiZmsndDGTtxiSzt0psK62iHMNf/0udWhKksjuM?=
 =?us-ascii?Q?5OWH40aMuztPtRHln1/LCp/16qSqTRLyDcGA+8ktHGq5u7oI85Wnb3NLZgJg?=
 =?us-ascii?Q?BrGqK9zG4QxQt+GA1/do+ada7IkxPGC3drv0Kq08dtxfTDV62V7F+I6iht1c?=
 =?us-ascii?Q?EkXfzJx8K746nhZL2vOsy6JYi9P1YbY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F5262546C3ECA743B18F16727668AD5F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4c9078-aa35-486d-4c45-08da18a0b60c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 14:12:55.2721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWU7W+qLbnfXjEHir3PKXqnV0/e2QLQNPLgSBmBjd08LYv9POXxcGpgmdHPP/ts6XrNeSl3CCU735h2XKdP/LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6542
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:04:20PM +0200, Michael Walle wrote:
> Am 2022-04-07 15:56, schrieb Vladimir Oltean:
> > On Thu, Apr 07, 2022 at 03:06:25PM +0200, Michael Walle wrote:
> > > Due to missing prerequisites the probe of the felix switch might be
> > > deferred:
> > > [    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA
> > > switch: -517
> > >=20
> > > It's not an error. Use dev_err_probe() to demote the error to a debug
> > > message. While at it, replace all the dev_err()'s in the probe with
> > > dev_err_probe().
> > >=20
> > > Signed-off-by: Michael Walle <michael@walle.cc>
> > > ---
> >=20
> > Please limit the dev_err_probe() to dsa_register_switch(). The resource
> > that is missing is the DSA master, see of_find_net_device_by_node().
> > The others cannot possibly return -EPROBE_DEFER.
>=20
> This was my rationale (from the function doc):
>=20
>  * Note that it is deemed acceptable to use this function for error
>  * prints during probe even if the @err is known to never be -EPROBE_DEFE=
R.
>  * The benefit compared to a normal dev_err() is the standardized format
>  * of the error code and the fact that the error code is returned.
>=20
> In any case I don't have a strong opinion.

Take this case:

 		err =3D -ENOMEM;
-		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
+		dev_err_probe(&pdev->dev, err, "Failed to allocate driver memory\n");

(1) there is no need to print ENOMEM if we say "failed to allocate memory"
(2) we don't use the return value of dev_err_probe() anyway, we have
    actual teardown to do (pci_disable_device).
(3) we _surely_ know that -ENOMEM !=3D -EPROBE_DEFER

>=20
> > >=20
> > > Should this be a patch with a Fixes tag?
> >=20
> > Whichever way you wish, no preference.
>=20
> I'll limit it to just the one dev_err() and add a Fixes,
> there might be scripts out there who greps dmesg for errors.

Ok.=
