Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9594D69EAD5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 00:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBUXCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 18:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjBUXCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 18:02:21 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60774558A;
        Tue, 21 Feb 2023 15:02:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaxO0l0zgYUaZR1nVrdlLyEE+Nlj51F1mMYj1ANXWcjsUtdHwltf4hNu5e8Ffec+5GvdINMn+8kIzZe3WczfMloy2XvpakARa69q4jtvmpk1k8/R+gDmwJZkQfSP4Qz65EnH9zl5hlQBtYdlUujo2Dac23vB/pbjjtaW9rmF5kLp3OCMT7L+5sNQPF5q+Rw31rfWTBFOEcUvlwgIG6XrZmXTFwo0d/gSGPLrsnrVx55CgyJu8aXZslQoc/HI0NBhm/8NO+toW0pAksZUd/A1tFIklqOpVI7UL4Q3SFXCduZpWn7wrpZO2XhEYcbIzp8UTH2GwEXPBcVv2aogj16D+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXmTA4BheZqlCfkbAplov6D9X/sS3kkP+LN6VeoO85Q=;
 b=lzph8WqoZ2ELIPm7odVsNBENIf3UK10kGj3d7N+izNEFLx1RaE1KId08+oo/SV+p9ow6cyT1UQWnzi0r65M7Dka1gEel2VrPRC2+BkzQDfXIcrG5yxynCJS2aglm6OvvMC4AXY6SsmB7HyrjHnx0nNRr0PUiJvIeLgjXtqpBQnOcz5imamk5GbRN0nHKnNR0AoQaX/FVnS/vbjQxOAKv67bdY30jXjM2J7xmH5VTrd6FoCrKueB13Ecic/h4CAdq2fg0k6RUiqSLjZq9/HqVmQturl56Ygrkgzq/roefo/gbQzD6qHsAf8iMHH0dfcwIpY7NBEe0Y/tpsSLNRJGr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXmTA4BheZqlCfkbAplov6D9X/sS3kkP+LN6VeoO85Q=;
 b=Das2A/bgtm5L92gwE0scK4mSmWDm8s5o+3RvI/yeKMR63C7CYbj+BBgv3dfF9ScZksfxrEOtrC7HKjn589TGhe6CJunEqeKxz4c+MAFLzF1Ikzvf0bbxH2V24DJWyqA7Ag/66zG1bVCDTcRgeYaHBvdLQvq8TmP9LqzwrwxkNpA=
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com (2603:10a6:208:145::23)
 by AS8PR04MB7671.eurprd04.prod.outlook.com (2603:10a6:20b:299::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 23:02:18 +0000
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::509:96a2:4382:6b51]) by AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::509:96a2:4382:6b51%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 23:02:18 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viorel Suman <viorel.suman@nxp.com>,
        Wei Fang <wei.fang@nxp.com>
Subject: RE: [PATCH] net: phy: at803x: fix the wol setting functions
Thread-Topic: [PATCH] net: phy: at803x: fix the wol setting functions
Thread-Index: AQHZRkWUuJYqptIixk63Rjx4R3ymc67aAv4AgAAA/hA=
Date:   Tue, 21 Feb 2023 23:02:18 +0000
Message-ID: <AM0PR04MB6289271A20D0FAA69F26D48A8FA59@AM0PR04MB6289.eurprd04.prod.outlook.com>
References: <20230221224031.7244-1-leoyang.li@nxp.com>
 <Y/VMLF0NGgO1F34K@lunn.ch>
In-Reply-To: <Y/VMLF0NGgO1F34K@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6289:EE_|AS8PR04MB7671:EE_
x-ms-office365-filtering-correlation-id: 8045ebd4-f25f-499b-c295-08db145fae40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKjg8b92dcfbgUbYNNKEEp7TJR7X6Xz9hjIBKOTFvek+nsYaPYWclQ9GSdnlrdjT8FC23uBfmEHogvijXQ4rXuWjJ7gT68zdcfNF84OnfssTlxTks57t0aBDRCyfS3lHmmGmHBHGyAeyw7mNBtBm2pSO2u/OCX9LH71a/Vytw3BqrYWe0XTTK6RQVd3WNaLjYp+b24zZFOmKjzGdUwiLATmvPDfAkQtizSk7cw4pv7qSSo9SJbFpRgXjaHHeUlGp59xTmdXlWVEmmUP+4tBHEKWqNSpyoJ4KzGCT4OuBUV6WOkfmbeoMvm8xpc3pHhHGzIUG1aoZVz4BEEPBVw6C9m98d86L3aav1PiLGhHsfYNEp9/XzOb82Tj1VEDh/bM5TPB64B0sgyhbcbTKCiERdBbvuqFHBcKHprzZmpPXoOddIO3fm8JOfrFZvyZP+cHsiMG1pGjixzqUZteoPvjUtHvTDUpaLyCHtear4VnS5Yznkrexv3RgDmA2CiGL70OMJa4Q39qD8CbiMyERv9aGf3GEFeP72ES2hv9HFNYYQtS5Bq6FaOF9/Ay3UXr8+AIsY4jZcbGP18BN8OASN3jyxplh92Ke0LL6XsneQKjPC7pLJc2orrrUKG+5+i4/HTuD/pZsfx0WRkb8n79BJX4HJ4nhyNnP7mU07Yc/baNOAotgjMdYx2sksiNFFS6gQm70NtLPY153/nkqrzgiDmygOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6289.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(2906002)(86362001)(38070700005)(33656002)(52536014)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(83380400001)(66476007)(66556008)(66946007)(6916009)(8676002)(7696005)(76116006)(71200400001)(478600001)(54906003)(66446008)(64756008)(4326008)(9686003)(53546011)(55236004)(26005)(186003)(55016003)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SosovIyhB2jow/F0StUD4q8aStPu7todOhnBoGJ8bdFMDTsOIN5MtPUSIsqe?=
 =?us-ascii?Q?jwZzHeKLsTMRV9ntTL3Vj+UNTVCL74U00ULlwiJPasR/7C+OPSICtKPnXwZM?=
 =?us-ascii?Q?K3Sex450nIKsRekBppNissd1vsxfEeFBMsGBFrIEpeFr2OrtNJPL4UUGRMmJ?=
 =?us-ascii?Q?XWuD6pBdSk6x661ksyB5KEs/wJ40i3qyhqSZwjLJy2KLhG9sEhvkT/tZYQiK?=
 =?us-ascii?Q?1/Wgo9Hm+5x+KcT9dXNcIwluJMngg2AX/oLYHY+4BbFzM99fDPkR7VBV9Z1i?=
 =?us-ascii?Q?uYzpBjAfmflaxrmC9V24HwNayiFTplyd1ZQznYfvh1M7rbnHQ3CO4nxhVtLN?=
 =?us-ascii?Q?2+OMnnEHS7HCOL4FcuvBLWL/nl1wEVXciB6Eh1gSW6M8jx0l0CKPhgOBrWWJ?=
 =?us-ascii?Q?iC2WTo8zlytHSCTsFkOEfiCeO/vpSx59Wc6ePlKJyiN+EpW1ZOJ+BHKZolkR?=
 =?us-ascii?Q?JJj3UJ3lRpzqU35MHEJQM/LfX2ZrxNKPPLk3lkxrdW5qbMrsTh4TMdyqsYVw?=
 =?us-ascii?Q?dnz3aZg1Xf+z+jtS14nL8FCBUoRraSe1JDRfCdYCXW32vgcI/2TOt8+2JDEY?=
 =?us-ascii?Q?lZR84tq/dioY6CieklPMPEkfuToJZYKKp36Qbp4W6Hlufo7TbseI+XNEW3pb?=
 =?us-ascii?Q?OjxItpxvvqtyqbEqyufYgL2qT0CnXnSO6q25k7hMZRo23BgDue70AzA+3ogs?=
 =?us-ascii?Q?ln61KSmDGSd8Jzj9s+i7M/baLyPQzPNP3R1DOANgxoIL1b85eOie/uMa2FF5?=
 =?us-ascii?Q?yK4P2n0blDsBjs2kTKwxmrB2Vf7qd50zXrJiQvMF8WVLfOzsZFIBGwyR3ZYX?=
 =?us-ascii?Q?gnFcsPdOgfco9iJuL2NagM48By+3mnwUU37GMeNAd+IhxnZJyelIsyx2TUjK?=
 =?us-ascii?Q?vfdYAEzn6DhFatAnSMNP3f9BW+dkgzwqVNT895r8veug0jwDiICHvc9hAzAh?=
 =?us-ascii?Q?Qk7wTniFyEhnAZygKRXwkxp24DxRcBioqR/dDsm2Cs697Sicl8utGJA4+4zk?=
 =?us-ascii?Q?BIAEVr1u/Ex6J9Sdy49Ai9lLGtU1O8y5EhUYIjCGXUK4p9meIcx59clN/Q4X?=
 =?us-ascii?Q?kBNStGnoMQ76d2fsVPFJIeXoZB99HIiaj3UhrseB5CfmCveJtR31FQUi2BN5?=
 =?us-ascii?Q?c5moKvcb5VZsK9a+8XIDqv8LYOmdRKfM9RmIxpAe65T8hgi8UpUlOz/i242t?=
 =?us-ascii?Q?F40HG+E++qS2CqsBcrT2Yvt9/3Xzzi9SHunQOEys+eeo/fmBa2nCHYTYOaMg?=
 =?us-ascii?Q?ZL46JA+6meOSUGGev5Kj4qja1jR92DWKbI1ayY2/gOGCCPBavPngg1P7r98q?=
 =?us-ascii?Q?RV+xAOVeeXsjLR+7JSZuvMZc4EGMonyIss4mBCCDRNWv9EY0PGh1m4sKUXzs?=
 =?us-ascii?Q?jwbmUg/a1rlnOlB1BPl3YXwr8cqRa6azjTQc4y0U6gjVDgkW/AnMYwxl09HO?=
 =?us-ascii?Q?SQEnS+jqsnztrrsmlkx0WTGV9iqawiFWGedCphs6USpjBBcebcJdE1+8A+Zq?=
 =?us-ascii?Q?X2Uc8ZNotihmu4oNziHWDq/Cb3UizIrOG7HJ73+zyfawCFL2X/07sc1h+NjA?=
 =?us-ascii?Q?5el+0SrMb4qYoZGPCGgr1tGZKLr4F2mAQoUvTh9k?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6289.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8045ebd4-f25f-499b-c295-08db145fae40
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 23:02:18.0829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ru3ZQBmN+QwbTI/i1MXneqjMd/tIAjxAG1pejyszmXd9zHnLwINreluzq4WJQnxM5txbJOt81ciwRR00BRa2RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7671
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, February 21, 2023 4:57 PM
> To: Leo Li <leoyang.li@nxp.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Luo Jie <luoj@codeaurora.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Viorel Suman
> <viorel.suman@nxp.com>; Wei Fang <wei.fang@nxp.com>
> Subject: Re: [PATCH] net: phy: at803x: fix the wol setting functions
>=20
> On Tue, Feb 21, 2023 at 04:40:31PM -0600, Li Yang wrote:
> > In 7beecaf7d507 ("net: phy: at803x: improve the WOL feature"), it
> > seems not correct to use a wol_en bit in a 1588 Control Register which
> > is only available on AR8031/AR8033(share the same phy_id) to determine
> > if WoL is enabled.  Change it back to use AT803X_INTR_ENABLE_WOL for
> > determining the WoL status which is applicable on all chips supporting
> > wol. Also update the at803x_set_wol() function to only update the 1588
> > register on chips having it.
>=20
> > After this change, disabling wol at probe from d7cd5e06c9dd ("net:
> > phy: at803x: disable WOL at probe") is no longer needed.  So it is
> > removed.
>=20
> Rather than remove it, please git revert it, and explain in the commit
> message why.

Not all changes from that patch is removed.  The remaining part might still=
 be useful.

>=20
> >
> > Also remove the set_wol()/get_wol() callbacks from AR8032 which
> > doesn't support WoL.
>=20
> This change was part of 5800091a2061 ("net: phy: at803x: add support for
> AR8032 PHY")
>=20
> Please break this patch up into individual fixes. The different fixes mig=
ht
> need different levels of backporting etc.

Ok.  I can split this out.

Regards,
Leo
