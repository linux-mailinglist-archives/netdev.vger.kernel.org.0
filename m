Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B57557D6D
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiFWOAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiFWOAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:00:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3843CFCF
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:00:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRAS0trvzbdqbAKVPyXDLatckgCKHA4k/VRvu/262XIyQ6/gaq1rKkjmy9rlUJtXA5u3CX2EEpMNqZGOelM3NzlNQZtMecRM7ZTMzph8fIV0qhCvAV4nN+k5QWZ0ktqdYbM+7cyQdHTHzDoAERHMP/4aiH3voR+M6qJmb6wkCH3g4qnXCfJ3Wey40whJfp/HF0scc47exd9BICb4xwD82QsnMc+WRxxjXhihSkzyn0qgxh3UF+2MyxQEv7Lxf1Qc+nSpXN/ND405pHLLwGPAgugur5n9gtHIZQl8S56P/lxbKf1zxbcGtJxDwEYeH8vw4ls0fNS06kHRDpM1Wp/cpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIDR5On7uGDo3wPGrqaKFodkEDrcBapCzmQUgh3r4iI=;
 b=B12YzHFnmSeYZtI00LPWOaOPmPVLI8tIQaZ8lyjTRP5mf7uDAE7T0TH/T29zJ5rsRO7vIvEsM6prIjMuVJn1RbjT7mNr+Ayq9WIWndF7Yy4Lw7g9HhTiM+X1/27bN/K7wTxAgdgV40Z53VXalxgJ5bOZ1QCvP6Y/FRChFGBXfM7VB05gEb+GLy+JAWtVAGSnl+5Hsej9s7rDz0ygi/mrha7WTYbj/k5rx62FDJn0OIM3rM7IjyjSYwX1Sxx6fwdxV/MHiE+t9uWC3vuumWAe9OPGy06JadYOhZEV7ehY0xM9V9cOJHUJs4miHjjbR7H62u5qBDD2yCL4xJJeYG8c8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIDR5On7uGDo3wPGrqaKFodkEDrcBapCzmQUgh3r4iI=;
 b=iUPEstIPM0Ia/tGBck8x1PzoMA1AOKSlls0RhhLyeXsEfZTmvd5iKzFdi1z/mE8E4gK5I6fmiRwsw4/mtLITSzXysGmHRl8exzdev3S48K21QNY2+bwFxpW2C6O8tLkO4bU7xleA081+/H/WdPDGn15MyBeibfq+1gYkzzBrQ2M=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DU2PR04MB8550.eurprd04.prod.outlook.com (2603:10a6:10:2d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 14:00:08 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%4]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 14:00:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] net: pcs: lynx: consolidate gigabit code
Thread-Topic: [PATCH net-next 0/2] net: pcs: lynx: consolidate gigabit code
Thread-Index: AQHYhvw/GFocJg7s00KJOS37d4y0Ba1dBR0A
Date:   Thu, 23 Jun 2022 14:00:07 +0000
Message-ID: <20220623140006.blenkbqistn7rcmr@skbuf>
References: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
In-Reply-To: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 483c15e1-7343-4389-dd4d-08da5520ae8e
x-ms-traffictypediagnostic: DU2PR04MB8550:EE_
x-microsoft-antispam-prvs: <DU2PR04MB8550F9EAB96F726ECD7A04B9E0B59@DU2PR04MB8550.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+1wkdmgibWbQ1JNr+iIx0zzdseCiRmoVWaox6e7ubLTl/QdR27Hz/HLXYaVknJz3H3Qyv9+5pDrFWHDfEsZcjWzHsVAxFa3+m9toEK/b/V/pFg3I5V0Z0GJldCo6+rcszN0qMLrpclfg/02GlnXhbY0KcuogEkNFzmszR1v5f6cjnSeLPrJcy54g8IOsfUQpW/8MnUSq04pU8v+LaWg5ac3aTsAeG9Tda+w9mhLULqNlrzaC8RX8WmmHPYghq4t6g7nKjcsN49MtOHbbl4UzE539mTU6KvfqnX8NH/Rzm4GYl3leMD/8XKnk8D6eCTf5yh5gvOoDS2qBgqvZhZKQKdfoFa/quFQwNCnutLA/f4qvCJFPCsFiCEXqv1fiiVUdIwLwh0uuVMKUMpJKItoGdRWLLfy8i6bPbIkIyytaxeYI5xtnrnCxqkTkXbHc0GqqA++0qUlWoh5T392zYkDr4lmlII6Exdx8XRnewtD0w9U0Y4DGSotnLY8ZX6ePHMuZX/aSF1NEdzEe6WWSPRk0oy1LE6bMvGw9yKNg5pR9QaWfSJDH5u9Vqpkg8UsxN1BNSyJjrfurZXq8XZCJjYb3+BK7k9nvUSdNXK5tWkuD4k1/edtL4SIbr7pRi1v9I1GlJv/Ne/05ahWr97wpl89KcEdPV9nbKU3LkidqhIDekb1XqkVv5c4LYT1a5x7tAQgzAaPGfMLa+UE15DZN8NEZb+t4iZEz9ote52JN7We7N81n9NmtWkanwWdU1DnkVkW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(396003)(346002)(39860400002)(376002)(366004)(6512007)(26005)(41300700001)(6486002)(4744005)(122000001)(6506007)(5660300002)(66476007)(9686003)(2906002)(478600001)(66556008)(44832011)(8936002)(83380400001)(38100700002)(86362001)(33716001)(54906003)(8676002)(186003)(71200400001)(4326008)(91956017)(6916009)(316002)(1076003)(66946007)(66446008)(38070700005)(64756008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xqiuZuWJ3zaEpqc6DKAdPW9Vvo19509l/K1435eIbTJa2iKz+J+R3flyUbBU?=
 =?us-ascii?Q?QR2fN+AjmLZ6qGsPrVrnzlj6+x9WfHMdLDDzmHA4m/qLCVRrWEuTKe/3jxLo?=
 =?us-ascii?Q?2MoSzwNu+NNkdXm3DT9GvrDQqp2B1Zypt1GK4/FzohBk2hocn3Nw6pYO5noE?=
 =?us-ascii?Q?7di2DDApVRgl4jTirkolpzgKvbmw39YLemfqmEjBpDRRwtUe2JmnCThUSloi?=
 =?us-ascii?Q?7D0x+DYYxk5CiKBWuxciUMD8UoOWHWlS3AIYrmNpTdwI5SIzoSWZRGl+cE2f?=
 =?us-ascii?Q?9KkFf61O3k6y1rq33hiY83ltIPaCQtGhnhz+1HGVUPzyt0vfa8LPGJle/Fas?=
 =?us-ascii?Q?lW/UxMaUZd4DvBeCIXf/TjprT2MesscpRJ5GzrPFY+0NlpspKKAogaFYdxFX?=
 =?us-ascii?Q?iDngcHltQeFNBfUbrKHGWMQOIKeFQdPfmwyvnbyAaPGe9wu9yjfGV7goFOmK?=
 =?us-ascii?Q?dd+6urHDilH20eENNeDeCZg+XfugedalyJVbJ17rf6VL4OWN992d+fhft3ke?=
 =?us-ascii?Q?RZr9CRAHlW7PbA/zRRjX5viptBfW0EykstSJukkDBzc51jDtjgzZirpHrSse?=
 =?us-ascii?Q?2qqPh/NTAEtLRzgUN7BFreUSqmJCX2l5aG+533+K31eBjCtPRx63yM/KLSOO?=
 =?us-ascii?Q?m/kJp/aFf+nPp3urJhno+WWUunPR3/nNNLPQjDuKvZflbOZcuRqOsmFiG+iE?=
 =?us-ascii?Q?hKsEUPTTtiHnQhqa04Z8Wb1RyB50y7RD+/14vmcfW4YzbvsrH7Y+G939aDVw?=
 =?us-ascii?Q?ui5DqYPKBgZ/vUcQBvRVHH5vvPB5vRl/Z/ekRbS3TY0c8W+JaOHRw+XdUFmT?=
 =?us-ascii?Q?lwqoX2NEoEfEahRfVCl4JwKFsD11La+0exlkJLxvz1N5bQVPiBaLjOdkxAoN?=
 =?us-ascii?Q?bn0WblymD6gsA2vBbbmKjxDfmZMwsJujenCn3jWbSbjxJ4h+g4h9L4tp0kkj?=
 =?us-ascii?Q?sJTki9VggjDOjal8J58PjrZH/GFdr5QgBWL3ylacGHSGSQFzAkF7oSrLN1Rk?=
 =?us-ascii?Q?Afnh/4ZhCBxGJgiVKnjEmLH/bhy8TDLfwi4D2ws567O2+01vAMdq0Sbga48O?=
 =?us-ascii?Q?K9XgLr1WHfzSWEFfEG+wjm8wmCL6gn94qEVPYAJbEjNkN2i2BowYyl/tg4e2?=
 =?us-ascii?Q?9sS7faoEmuVqJ4yHS/fBhY+W93IqZJWD1RniUVkcnxE/3Gqqyme5I0Eru4Um?=
 =?us-ascii?Q?Ee7j6iR+2LUyApO67tNGHBmfd75/V22Q0o6ipGM+26u3+pQ6L2mcRCBAN8Be?=
 =?us-ascii?Q?vPSAa2vdQ7xMMWRSemKAOGeTo6CLGPgnbidkcqxkGM7Bg6L5Mma7Lzz9LkGr?=
 =?us-ascii?Q?vgSVXpyYqdC+NrpjUPBHgg02XnWgmLMV62p33uq+NlKD0izSgbRKSxykNVGY?=
 =?us-ascii?Q?Hm1SQIRsoGR+OXbaHuf2mfuRqH3qTdZ3J+RQFR9YSup+znVkyE7uFtltkwKu?=
 =?us-ascii?Q?FeFWwmgZmXf75NhQ2Ad61/ApKrU5yLQj0iMeLNYHdyQIRG2HtCw1KwDa2+Yf?=
 =?us-ascii?Q?0I60VV5ejVKuuHU1DbKb2mL0RmGZoSGlFyIOSIehpOMXF8mcelBOlr/HhBSE?=
 =?us-ascii?Q?tMkVNGX3r9OMNunNdvbrdVTGJPSw8jatYo/n/vYZVsKtTnDTJC3dnhxY6lDh?=
 =?us-ascii?Q?oA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <373C20B971B5074BBC96884098AAC490@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483c15e1-7343-4389-dd4d-08da5520ae8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 14:00:08.1790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVYChxsuimRDzC9Y6LXVuUJUauJtxgAIPNknxwRlip3JPy2TVJdQW4eb34gFHOKTRFQEvpI0ZK+IwdhliH0j/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 01:24:44PM +0100, Russell King (Oracle) wrote:
> Hi,
>=20
> This series consolidates the gigabit setup code in the Lynx PCS driver.
> In order to do this properly, we first need to fix phylink's
> advertisement encoding function to handle QSGMII.
>=20
> I'd be grateful if someone can test this please.
>=20
> Thanks.

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks!
