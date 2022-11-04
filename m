Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B940619D8F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKDQpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:45:39 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2053.outbound.protection.outlook.com [40.107.249.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFF531EF9;
        Fri,  4 Nov 2022 09:45:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI32Sd0uqajvWJYR0Q0G3pv80dvIXKL1qhgiXFsI960pPFTIM6hmk1cClEVq+I7RiG2u6bXMilrIUQpkxU+9Wr1eu5O7/K6juRuFSPqfTxIvxw4/Zr0wSKbeuOfX95iiuNvfYCco+H5FqKyMM47iF2blrWyFfg1GpjCTir5hifObPnwwJ6T4o0CuFit286SYpaldD1JAvR2u8BSSPfH4dNeDjXBIs5m6GkbYxYiYIm7iTkrCYBW1JEKUb8P4jsy9NVPp38zBDlkdbbS7S3L03fJgIgEsbIgp7W4vRBl2kdFO7ct2kBu8rf8cvC7rOhZcm53wIbg92htv66VhTVWW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XPEAJDFzltZ6wR9ECImrbFW7sGi6io1tcorZ8Z7apc=;
 b=G7Vrk90vpiuaEjj2RZiOreQv4xXT3dIAc4MEg2XDqkNFl0vSUIlGav4bcOhyidupN+Scw5zkkBIq0xrW33NpbJRr90WFIi1wfX5X3g1Pq/6RTrc+uGhzYQeqa83TfZKOd/Z6xta9hNpegKFpUOfxU2rja6eb3jJxUVV5HrkrqVCUyD+5+c1ZobT/FJSMR1LXd9JPAJCG3xt+VQm4IUpbpn8HvObf/DmhB+DdtrwQPZuKsPDVHVdOJ37EOchgjYDYKPcouEkm9vEpZ5ZoRErFdWORCS4ZEisgvbXLystyTrx8Dx/RRkfWqIsjeqRx0I4Ymf1AMEjuVMgi0wkg1a/kzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XPEAJDFzltZ6wR9ECImrbFW7sGi6io1tcorZ8Z7apc=;
 b=X8rVnGsrZV86ws11pcHaA3MogpbrAITtUcyxNokNwfE8Qq711DSwRiJY08cnM2kdkAQ/5OSVBZ8xDzIayR9Nqp64V9dA1v7o/6/oPJ+v/T2/AVLtHioP3UqAbgN6iKKPr8ZaydClZ4yxMYJeYCFwqf1Lh7W/2CSHR0DxvsWHmLc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7926.eurprd04.prod.outlook.com (2603:10a6:20b:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Fri, 4 Nov
 2022 16:45:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 16:45:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Robert Marko <robert.marko@sartura.hr>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Topic: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Index: AQHY8FmpmsPL59Zv3k23UVCewDzxaK4u+CgAgAAA2oA=
Date:   Fri, 4 Nov 2022 16:45:34 +0000
Message-ID: <20221104164533.32qelsphhcmnm2gi@skbuf>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com>
 <CA+HBbNHTmpPJqzja11OqS9J-37vdDiDLubrimke73x+oQKuoJA@mail.gmail.com>
In-Reply-To: <CA+HBbNHTmpPJqzja11OqS9J-37vdDiDLubrimke73x+oQKuoJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7926:EE_
x-ms-office365-filtering-correlation-id: c3066499-9162-4e35-3afe-08dabe83fe93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yv+uuKAQU+LmIOS5vR7X9cLldD5x6binK62T/479KG69YzlTcm3rC8V7iz/mZj5Q12UVqY4JeCikQ4zmZtkTvmzgMghY7r9rXr1fOBfoVMO0ig0lZwtNfFevMYenalTrDU4KC0xUFtkL9Ae5gEpGuOFoqqc0KuXLUiPa5kly3ACkXDO/PSUMIvNvMXT2vdWHSHpspKZlZ6+NcDHSDCKV8u7IKp9WGtDiM9gEFdTLswRcLZqZdyzONXKGwHczuYmt/h+o57WHknAMsLWYD1UuNDt3RjtSMHd9fHbpXQIMiqCCC007WKHNS8WLolRiR/nP+gOj8ue0o6Hhl7ICaKelsdCL+zxZd7Zz9niMLLEkvnlXVKqWZN2X9+jztHTwqMgRx/TORMSltvlDeshHaXcldr0fnpjEzyj0FqaL9Gez4+yg3HG554SzDJAk00ZMdMxlBVrUF7WWaUO9JeokRo7H6TXWLO8AIXoDbk37eVnBGlCzMADm00wMX7SCtFGlBJw3li+kSbIOHdz+YDjb9jcYmfe3ED/zSgIGAqlQjn5h/0oIU+6+QWwtFhF9pZV3ZMCeTvv3v1HunUsti6nr7NYCY9teoQbcPE+fmgMPs+bI/22r0M6Kk22kGQMLHGCoIuZ44nyVGqC29wqZ7ek8bAzn9ZU8MdUjKL532HHIxV6uSIEaBjjAvbHDuU5ZXKURnKTCnheeBFRWxmWpvx0CZ6xtQP2rDOuKHLZDYFnAfLykvQ+nPNhxR0DVHWyjz2hVQeaQeWHvQuZ6E6cuT0KyC+as6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(6512007)(122000001)(66946007)(66556008)(66446008)(38100700002)(7416002)(26005)(9686003)(186003)(2906002)(83380400001)(1076003)(66476007)(41300700001)(38070700005)(64756008)(8936002)(76116006)(5660300002)(6916009)(91956017)(316002)(44832011)(4744005)(8676002)(71200400001)(54906003)(6506007)(6486002)(86362001)(4326008)(33716001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FnqrAHsNw5kDqUPJRxOP6YKdhjr5sNxpPb2nPSgs1OmGwfnEc+8zyfcsyRdE?=
 =?us-ascii?Q?wFnWdLZvxQpBcylnZnk/Wmq+VaiI26IwYe11iU8oVsf2FiTXTlhOAOdcqsWU?=
 =?us-ascii?Q?kWBJnH+OZT8QQfiA/1O7AxiEQPRwJCl01dUE4ofswrTpNLNtnwY99uQihTAi?=
 =?us-ascii?Q?p6TA3NGwgjiPVrLsBNV+PJfMconGvCIy40CUjcVh4OOQl6fDQd4r3rZW0kEE?=
 =?us-ascii?Q?a8TMuCGM++EYPmj99bb8HhcFOWKCuQER31WX1TXk/R+EM0+cDCIcv5r71Xx8?=
 =?us-ascii?Q?aXqb/T3nkuS0MXMUCCLBpmB22PZVLzhX0UNHUmc3SKO4PX9uM7EznBPdMpQS?=
 =?us-ascii?Q?xTDJPrdlrz/0Q0ppmTDRQJSZhDY5qn7aCiMb8PsKdKhF6eLBXIwz3yQzOcR2?=
 =?us-ascii?Q?c1Dxo2xIdXdna095/SA/rKtTyykHoHelV1mCXaCfEP7v525r8Mx192SnlK0v?=
 =?us-ascii?Q?hADbzg1W79RI7XBAzBw5hjmijsRGipD+SnxHEZteEGlJUtNpuxp61PL/zi10?=
 =?us-ascii?Q?FAgtJ8xjyiSfe5R7IQ3oAjWfDwzg5TFaDEgpBHbp4pD9VE6kZe9nlSIKWapy?=
 =?us-ascii?Q?/4DwsJjC64UvCf83xGW8bumNqLF4lv+8373dKR1onEFwNCpl6KL3+OkTREOj?=
 =?us-ascii?Q?R9vBt49a1HmulG3nfCc5SYqopIiHb3aHOSmGWMrTaCOL/WW/tUAIIC+0jp2F?=
 =?us-ascii?Q?+qDPZWpCLKbp6pdcL1NH+1Zdo1AJTxXtTltEElUTip+aSMRub47vXqM9YRXH?=
 =?us-ascii?Q?2ljMk0R/H9jN+F4AYPM8le0BYgYBVoh3mIKKRN+dDXK8VfTA0v5RriULUpf2?=
 =?us-ascii?Q?4YSjzCkfSqFXvql2Ji09giGLKauE5FsmrYw00OM2haLabrRnjEG+usqTm7xT?=
 =?us-ascii?Q?Lekx2VtjSqvl4FdYCq0CSDNn76nUuhj5P7530PMYdTsKkYa+w+4ilZ/HNXxz?=
 =?us-ascii?Q?r1R/tHcDLcSESIEzzUsoB3zEgB5PRJ0CYkhSvW+EA9jzSaCmndK3OMeeAZ6m?=
 =?us-ascii?Q?vnbgDjykm/l/mUjlNUb4VKpuz8WPZ9v/ycS/H014ftAhD0YTGCTmwcOinL9P?=
 =?us-ascii?Q?x8GLQoYnd8fm+KedtxyDoWuuO93SxxNFWGgyb3pJUtFoySjfAstCyyHHrn3A?=
 =?us-ascii?Q?8ZjCQyi9JTugbsWw27ip4mWFnWDFqcIvPAvqfZuT4++Pkfxe+kUUV2E5UHOA?=
 =?us-ascii?Q?AEc3/qb1LHJZTDlRI0ibuX09Xhz7Uw2S2f3y2ViWMzga4piGpVHn9Qty8p1r?=
 =?us-ascii?Q?LlDDFa9hmm+oEcboXYjoeVymOi+9YtukTxc/wViM7Z7u3AcZkgwuyKsYyzZx?=
 =?us-ascii?Q?UptWKk2kI8CeCEtsdz416oWdQoxu8FVUkaCc1sD9bsWo08bHPJMTf3iX6gQ7?=
 =?us-ascii?Q?F33JOn5PwFqns05W+8WqyGP8S8HqPUqtiNFPbZ4miP45Xl+RPEXWtWMLUrxR?=
 =?us-ascii?Q?4FjueQDNy+DJrTUYRpzHr+TR7rMUL5EzPj3I+ZOXN+mWCA6UNqkR7VEVkdnD?=
 =?us-ascii?Q?Oh+iu3P3fMZff9SJe6JF5RwMce+n1uTddi/WxxnVCdeFT26pxt6IwJB9/NTF?=
 =?us-ascii?Q?mSyz3ILD9EOiL5fwLK943j4hkTAd1yiaCX9iP2TO5N9RVuXq69HcqK5ZSFMt?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68476D58274C6A408D4F4E7005F3315B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3066499-9162-4e35-3afe-08dabe83fe93
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 16:45:34.6932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zAi8FOu0lIwbftIxusspnfwixnsE25atMeVmCpph7d7hs4khr6t0PeXBw/yuxe9hozQWfF62VzcdJw/9vS3CyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 05:42:30PM +0100, Robert Marko wrote:
> > +                       phy-mode =3D "internal";
> > +                       status =3D "disabled";
>=20
> The fixed-link should be defined here AFAIK, otherwise it will fail probi=
ng with
> just internal PHY mode.

It wouldn't fail to probe because it has status =3D "disabled" by default,
and who enables that would also provide the fixed-link presumably.
But if the speed of the pseudo-MAC that goes to the switch is not board
specific, indeed the fixed-link belongs to the SoC dtsi.=
