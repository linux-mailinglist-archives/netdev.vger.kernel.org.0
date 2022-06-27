Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489AD55CADD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiF0Tqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240653AbiF0Tqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:46:33 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50044.outbound.protection.outlook.com [40.107.5.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F45C1A82C;
        Mon, 27 Jun 2022 12:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEwnkIXrME5ZypXWt4H0iCmMLTbIyVTfQmFNlPInyiTxa+pBq9QBYD4nuHPY++2PVzVVnCGlrN3RRB+fqJ3cpTrcZ9ln8d5dJ2QOzf/hyP8vgHKWKruySdrDB6ywPWNqFXy/XtyGCtKwBeuGmfmep3ZV3QIton8r2JGD2CNBrNEe8nBjUrY4OMB6C8vhye+/jT7f7OV9SR1EZCRbzTbuAl1iTriFuMjgmupRD6ysohOETGc0+18qxlZ5dJeGZ14Vi5KiDVacB6JkYgmqZjQyONhLbB8S/qKXzaoSHf7LnJMmQFpbfYmhE+UkiZCQbo1EO0RI2u+NhEwTSAHqUWRZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVQPzYUjYf9U4g9NaaYmdnL3pJf+r5KeoAqhVau4mvs=;
 b=Lt1/0gSXSp0rHM1MLNsLwMWpjNeIRbE8b9zNns4YbWKoFPcR6B9BCh2PTfg18qupws6tTFbmTs4mGPQ0cRnVpffntNY2i8kIfG8JxY4wgJUFp3xWxPfzzaZEpNQSHWVrPQP1wv2UZ5qAjsGnxob9upsf7hzuL6Lf+6HlcRNrtztja02lE8Ez3p43HeM/8uiNUDiy/AVQp3Ldk8i+pGu5g0sxLPpNpPJl9o018XbmrKtvFQn8mSY/nMm7e0iLamJvC3RWW4Jgxb/Xy2P7zSrjNolppDuUsRXMdBDTLbhjmPNfl7jvYi4oUzJttxHPB1nIiFsEyzuUrxhYE/2d9RN+yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVQPzYUjYf9U4g9NaaYmdnL3pJf+r5KeoAqhVau4mvs=;
 b=R1binfSJwt4jpoJTF7JsiJrAfaddxDsS/3VYJU4iHmd0aTC6asQlT6HTZ4HTor8vKlI7oqc0D+98bXW3V3+qDZyztuMCMb5XOg1/tLdUFZUyrqsK1G7WCPqLzev/g4UlAVeipUROCpvRiEk2liDw8qSgbVPDWFxx/kQRnIbD7zo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7489.eurprd04.prod.outlook.com (2603:10a6:20b:281::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 19:46:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 19:46:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames with
 tc-taprio instead of hanging the port
Thread-Topic: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames with
 tc-taprio instead of hanging the port
Thread-Index: AQHYiVUMDrzfbWhGTUGNTUf+r0GzEa1jmdQAgAAPBgCAAAGqAA==
Date:   Mon, 27 Jun 2022 19:46:29 +0000
Message-ID: <20220627194628.ixnrez5sod2l7grf@skbuf>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
 <20220626120505.2369600-5-vladimir.oltean@nxp.com>
 <20220627114644.6c2c163b@kernel.org> <20220627194030.uyaygut2n2sjywni@skbuf>
In-Reply-To: <20220627194030.uyaygut2n2sjywni@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b381f109-44ab-4f25-ee50-08da5875bac3
x-ms-traffictypediagnostic: AM9PR04MB7489:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G/Wa3xsdGHXRv+5849DL+ieGXdZ/D9mL4aO/YoD9zGU4h8PPG4NPAQwKuuFgPNDJnYSuCqdOTe7COcSjvMS9048AX9t0/Q0RpJl8+4YjwxQxuywbwIVd3WN6YYbA7XpIZOR2qXr+GoI1Tfx+32hYfEIFbhw++xPOwBakvUKYV18sLfdxYPZloL4fr7CdZht1cZWYEnZfThXyURUN+DjFFtKTweDc3Fn2/SEy04mWdDOZR10GwlDUSadLO6tUSk7HkjMo1IOm2dMf0eKdcNGappzp6CEEIosNE0zzwxH2PUVvpbMlVmiQ+T8a4z7DuAFTBrbqf1T746IzrfBTux+hvPypeyKjy7OWlR06WxUPxZvZBcBEtoWXp3AUV2Iczx4PylxMyUJwJC4NEMpDc7cU1hOjkCSmhgaly83HxoQm7H4BD/ShNZTOmVVOqbOAjzNtCukeHP1ICWYuSUTC5EY+8uZpOCUqZWYUdiOV3aSu2S51dhucQDu9WW7YGrSDL5ZEiNgC3mg+b1XzeJhrBwjk6Do+MSdvo1beZ7+zlgMZUNPuT0EGstUDNcZI+XS68bAf/CCYocpoXiLkYaOhfeGc0CEvDxjaRnUPQaJZP3EY7hqIun1X5YhyQmYGIGP+y+tthPL41Mf6lcR8EVBagyf2ur/66HgMeEdmuMvdFxWw8/1KX7TkwtAtZjmSMfPoNNdgsfup4cO2d8a1Z+wrVfBH/ID0SFjV1uQX/1VNFRNBTesTv1LBSbas0JJTj25p70zO6sCJ+5WTmG5Oh6w9jVzVMyjmIrLzhgUM4lv9VKmI7MU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(5660300002)(41300700001)(33716001)(86362001)(38100700002)(186003)(44832011)(8936002)(6916009)(26005)(71200400001)(9686003)(7416002)(6512007)(6486002)(6506007)(2906002)(4326008)(478600001)(66946007)(38070700005)(76116006)(66556008)(122000001)(91956017)(1076003)(558084003)(54906003)(66476007)(8676002)(64756008)(66446008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k712Zg3W6QeCeVM6NiflyA7p0O1glvMvu9hzf9Wuc9UquUNOH7fw/qHqvVsu?=
 =?us-ascii?Q?Axwa0ioPBgINtjwcgJr4jeSm/23KO/4GFTvmvmnaIGZRDfZx8AGnBmUE/XYA?=
 =?us-ascii?Q?Mv0yteyuxKUTqB+eGdXZbQXc4p11Aba6XZB4kS7zl8jitUdGM0K8oIrmv+hc?=
 =?us-ascii?Q?WtnIR/Hy/hKCDMoHLBp0Y26R2kLlcEzNl7ixs8KR1mL5cKrn1Tn0MXxUHXkV?=
 =?us-ascii?Q?IdqXPAMC3iRPmj7fNwXVQoGnXiBCZdOD/6LvXCuwEi3uQV3msc+Jvz3d8aoO?=
 =?us-ascii?Q?ujFmQPeCWOFvk+YhGdoJj0Wa3xhPTeb44UE856Ng2VRGdHFx92AUACqrIs9k?=
 =?us-ascii?Q?KVSQR81igZDqIZVPc7rRro1IHTuz/oHE/WGfnZog1B+ErnSdSTRiBoTOHgm3?=
 =?us-ascii?Q?0nHhYLXQOhmpeBuUKG59VI0GskAi7JLK8NcHCwVTEmgZ3+9mkQ6PS1m5552F?=
 =?us-ascii?Q?Z0uuR/Zs5yZqKatRhk43uvVgWfUHPeRNAMHVvP/9LME9ZGeovKsncvmU0APH?=
 =?us-ascii?Q?Og0uHoU+ImeP1BDhFDO/3e6VQde1fcPFvicvrTJMahdC4RF9NndvEbR3NNQd?=
 =?us-ascii?Q?NT0aDFDygRkSYgcl2SMROVkqzzyzvnOrxnmrrvRgGMgFRCermnpa4rcHAUhV?=
 =?us-ascii?Q?3Pk+eOZLOTSZVs93FOTRiTXVSkuSk9JFEqm7bG5lSGS6xhNtMn+x398rKwey?=
 =?us-ascii?Q?DpIxIt6gqIHOfgrLROjMmYjCMJJbCDvvBr3Yt6Vgi3YzmtMR7fTdbZC25lh0?=
 =?us-ascii?Q?vJR7MfGctgyAWflGNSqQbMQxNAbn871uBmTfw+ynURZ0GnrhNAgvZA6kPU13?=
 =?us-ascii?Q?nuLjKgypC80RWQMAFc/AEr49Srm3SYOTZ/0bCShJ58CZ09mmB3moNW5y0Wq6?=
 =?us-ascii?Q?Boc+kjJosU5UHTkqvFIhc1YMUXeundFNZwtey17f1wN4ccwcIupoeZWCSD6A?=
 =?us-ascii?Q?i27cY5HX/cem6+dyTwA0RECymw4rP6ALO0jrlzPzlM9Ms1RxKdBKxFS2VXnF?=
 =?us-ascii?Q?urRNMwWiwt2thoIjAETcgXILJ0xpDskaUCivYre9edRCKLGgPWTUswn1FCc6?=
 =?us-ascii?Q?KSpQVS9+7qcpCNfIN0dHWCWcd5HsvBulwJla0KCVHc8QnA/T5VwPByageX3e?=
 =?us-ascii?Q?d8Fy51rCAd2CyOjS7fYA/cTKN+JTCX9s7UlivCy/GHeEplxC5rvg/wwO1wHq?=
 =?us-ascii?Q?HwGIvbF9bCxjihhze4TzA7PFletyZ8m7UKfB+IRJ/WeW6VithBG388DBpiiA?=
 =?us-ascii?Q?m2NpwtS0kQ7Q8VZNx+zwMqAlrQfuJ8dxiXJ4S5uZGZpx6ZsArmj9ptExM6Q9?=
 =?us-ascii?Q?kh4TjbSFPSsuD4JC8oTBsR1hSH4bhGJazZXu9j/1yjd/HCTiKnVzctL26F40?=
 =?us-ascii?Q?5teO+ZGDSI+PvGSDMPVuT8EbyDSN0l4Y93mDgs18kkpvAUDjTBVE66TLfza4?=
 =?us-ascii?Q?dj4hMgnghlK8Ew2O/hDlPAwmIuO+C8F2dxzvVua4JhM/12rcgPMWAyuZMNZI?=
 =?us-ascii?Q?6pGEyZxv78aTyygbBx7xOf79/uqoU0Ae6p49Bsj4m0giOj+xKPnJ006Ncc5q?=
 =?us-ascii?Q?Bb/+zgGrqLqeW/SWGNK42FybUHpVdOmlDanM9rOnXKDhQlT7b7jjqTVYMU07?=
 =?us-ascii?Q?nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53001DAE4BF7C24986BF83AABC70BFEB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b381f109-44ab-4f25-ee50-08da5875bac3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 19:46:29.3698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ovC+p9CPUtTcFYX6/aJWc61GSjlSTJYQEP8ZBikP2yGv0jpsm4niEuVxDQoP0C9nKVR/uhxiaNp6sthQz+ex1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:40:30PM +0300, Vladimir Oltean wrote:
> I had even forgot this small detail

forgotten, blah=
