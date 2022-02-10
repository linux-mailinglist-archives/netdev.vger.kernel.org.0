Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC64B09BF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbiBJJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:40:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiBJJky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:40:54 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30084.outbound.protection.outlook.com [40.107.3.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7977510C3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:40:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1hTFj1GQHSjN1dPlo3OamRnUfsiiRVVUKniVolUW/KIhkJFVmakYP1kVa3VfsJKXsoDAC49A9dmQ9lbv7WbwqnWBnAlhiAgS3tuJbIUxtsWMUDijCSS1bS14G7Q5/h/IAP2PY5yOdQLtJbTQhyXwMKXPyd8OJRh/0kg1yCBO5jEMSL4Dl7VYDo3n65sjzqi7NkSIKghXUDB0exmkgC0huGu9HPrrxgFEk/OLyc3C4RCcmag+JTeTuMZuhrOQ8G2yvKfqxWeF85FqBuFz4pORpVUZ+CYcMqfOR00vl2GR4K/vjYCudENxRThPB9Znyw6Utt44xgg+qvZ6mjmOKQ/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pXMSaX4y7zTlbhyg0uHVe0KS3SVbJ62C2P3fK9CAmg=;
 b=ewf9fO1gvBZj33ZU9V1a3TgYfxz9PIufIO4gmMlebrK5pz9T0BmyVDGTvPlHqdmozKvB+2+ncZn056/97ZT2qAhcDZSR7vse/DBZgMyeHaCdYJzhHWkMp4kOOF6aTCg10BXvLUkt1r5+i1erJeC9KXAHQDRXKpRRr+uutlX8rnWJF34kTc+traxAbl1PrKUbn4r+ab1XANp1df+/73s3tdclXE81t+m+L07VQSIiDUJodtUDct9ORjQ8FjejRHKGCgfrVrWzTPHuN52m7b0SIOHjoPBe+S7ot+o7nVIkcbgNoTX8U5n3liSjqVfaNefpM89yQXoigsxXJSH7B9AcHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pXMSaX4y7zTlbhyg0uHVe0KS3SVbJ62C2P3fK9CAmg=;
 b=Mw2tjyRz4/7c5oyur7vc0W1IODNOk4TYX7Laelpb2PnSjPyVtA/fjlUOo6h9EQRjrYRQHu7spl0gDXREt+5HZD5RWuEjieSJIjuWW/xpIeAo8oZMV9VmM3Ksq5WaF/l5nG5RXoBZ5J+DSb+rvBete0FASH44L8RS3NsJkMBFqao=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VE1PR04MB7231.eurprd04.prod.outlook.com (2603:10a6:800:1a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 09:40:53 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 09:40:53 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Richter, Rafael" <Rafael.Richter@gin.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Klauer, Daniel" <Daniel.Klauer@gin.de>,
        Robert-ionut Alexa <robert-ionut.alexa@nxp.com>
Subject: Re: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting
 from the PHY
Thread-Topic: [PATCH net] dpaa2-eth: unregister the netdev before
 disconnecting from the PHY
Thread-Index: AQHYHc3R+Hv7+puOBUubY22EfutTXKyLjlOAgADttwCAAAzwAA==
Date:   Thu, 10 Feb 2022 09:40:53 +0000
Message-ID: <20220210094052.64o52akouoh33m4j@skbuf>
References: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
 <1644432224486.73494@gin.de> <1644483274017.7612@gin.de>
In-Reply-To: <1644483274017.7612@gin.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7536880b-83a0-4243-f2ce-08d9ec796e2f
x-ms-traffictypediagnostic: VE1PR04MB7231:EE_
x-microsoft-antispam-prvs: <VE1PR04MB7231AA80673B0E11B8A35F8AE02F9@VE1PR04MB7231.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbWUBCuTzieqOZM/++sQ9WhsTWkTkZ4SFxVJczO76Kt8WF0cZb+dX1TGheGv8DauL7saF8LucDavbquTh2dVsqXDqJ8bMIKljmlIaM3byDQ2eGdC3I4cgwEZKfCBMnak7ow7RcumTaP/Na0pHBX3lp8o35d3aa877eoGcUeDbp2DO0C1xSRcnhXmNtHB0RKoa7agUnTRxazuwHn6B/IhRZxdHD7pgvMf7C4yu/XO1diXy7AMIjoZF1m0S58HMQrkbX6373B5MUe3n17z4Naiz6ciS311tRfRidtHqYzLaGIq7oBXrHsJCX5ypKK9j7IIk5ax6LXKFs7eyCiSKKqgqXs/2CcECchyIPoeil6fIBXmbruN+UlecmkXFiNabaR0k8/WmTZfj0k55UnujDm30LACfqHzGwBBhguKn+uCPacA5cRyxwHq4wKJwCnian12mC0zlITjksiBLsmjMcoDcYP7ANFKxTHrBClSXY5F+LEj4X+CakInESWEuQQo7NXozEi1925dRkpYWApXYvCKEA7p/Bqy4VdMem5xf2c6wJBZyz4Cw5nUM8tRx1HF64Bq74uUZG5M1mbm+/rHHQ3qetp15/lTHVeFnzAE9F0aRtPLP+0QmXs0d6UQEWGZVF+HawqIRz1H7J2W6WKb1lna8tgwJHzzuKSUe4JUA2vdGGAQyl5C9f5mousiJK4lX0KSGlU3DkVeXVLRtUlYghw+rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38070700005)(508600001)(1076003)(5660300002)(66446008)(8676002)(66476007)(4326008)(66556008)(91956017)(64756008)(66946007)(76116006)(6486002)(71200400001)(8936002)(6512007)(9686003)(86362001)(26005)(2906002)(122000001)(33716001)(4744005)(54906003)(6916009)(6506007)(316002)(44832011)(186003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tbbw1N06+VybKB9viqkNe/ePz97TuMIjSK7ovoJ9LiICOv5HQd1+03dIpgNo?=
 =?us-ascii?Q?gpKgQSmch+zsJvWJwDnk72qOXSOl4gwEe0qR771CkbfsJ3X2CHtegAFgIP9l?=
 =?us-ascii?Q?p6cT4rV/zH5D6uos2YupY0Se3tXcg9YODSUZW4tNGIkn0tWCzhrFSZMoW6m3?=
 =?us-ascii?Q?h+5Gg6UAWSDl9if4VPzlTTTFjMg5Z6kdkUnuGwJwcGqQGmDYwGNckj/JFzdH?=
 =?us-ascii?Q?xCU8BYTLoIkLMK9U+NjUq/tY8pr6ELtAd58+R4TRc7/d/hGBR8yVb8sMe7jJ?=
 =?us-ascii?Q?KuVZj4UEzou50ucaMsU85dfw1v1J+PspCuSwlfd9mRU7+h5+1cLz6QtWvek/?=
 =?us-ascii?Q?oXxG1fIXuaiMr6VS66Eq2zv3wAFmXlq3KaMp0KA2FwtDek0zTRNZm2qJAge9?=
 =?us-ascii?Q?/BsQW0aZHxnnCvlBDJLMmb4DJ/8Qp9+LfALrlm22N6yWdN7JMdeexPoZj/0k?=
 =?us-ascii?Q?x8W8e03zfFafDCc1ScXURrDttOomH7tzBR50x4rbaaDRPobb8XiSP1kffeHz?=
 =?us-ascii?Q?RPEZEA34OUlJ0EJxSz3GS8zbx651/1nPn7Fty2sbnw0FkoIj77Y3V188QyM9?=
 =?us-ascii?Q?Rjsglr90Zou1gsGTMizLta4I830qF4HQ+5tfO5EOdNPeXVYPGDfwhZj35DSL?=
 =?us-ascii?Q?/Ok1VX94D1KSHukus9NqkL55UKXoQ+vDebQeZWtN3lJ7Gs5xpm4Ohr/WTbtY?=
 =?us-ascii?Q?MaMZkmb3oCvautknPTgiYuS0BlBHoP2IukcErObxhvrqs3ctlejwN/yi3dff?=
 =?us-ascii?Q?DBs7L29eIeBzacIbUt3RuakySC3N18HP49ds3EKemQF+SNBERTa20XcQFn/J?=
 =?us-ascii?Q?/RnYxQo84Hb3Iy7h8xfvO3lx0UiOCbU+alXqgrwU2gpNfzUX2nNG5TPBmEi6?=
 =?us-ascii?Q?MEaTd4VshtkMG2HtbUuj1AIMhonqQtWg0+bpDOBJMvSQ6qhVAwzCRmev+s2e?=
 =?us-ascii?Q?lc/JlRD+if5VxQXiyO8N70jCZX+tT9km8pMAjKHR/LUYcltVEzAcd3kyXg1X?=
 =?us-ascii?Q?nEzuRMfFtdiuCtgElC0TarWvJ0eG7/yUVJNdjU3h29ykSUksbyJ5LQfTy0lB?=
 =?us-ascii?Q?q9jZDKMObg20huJ0KUjljzMJKY30ssiVXPfVhIRELqrVZNt3LHSpu1NWmkWf?=
 =?us-ascii?Q?RJmyV9Vuh76Nczle+pDnaXljSbootk7DWCA2mwNZWtwJ994h0Oe/KL/NAR/O?=
 =?us-ascii?Q?yh7vo7morasSTdnDyMjMfp/K8Y4tcR8/XK26G6jvfONomzLupokymEPPtT1z?=
 =?us-ascii?Q?e5f5Wt1+37tkXpn+CYRF7t7Ov2oIPMrGp1jH6rx6SR+HugOtZpcd1skIsWpF?=
 =?us-ascii?Q?teqCsGVPhk/EygI5LYT6tMEyAw0Nd4m0xI72TctejUrziKDKRLww4H0vm2xe?=
 =?us-ascii?Q?rvMayPf/dbmzB60bY09vjR7zqp+wYRXUfeB546p3+h8puyp7o4SthjDtj/hO?=
 =?us-ascii?Q?oy7vB4tKigb/YO3/kXe1c2/FzY7jpoEecc8p9n/5KmqlBtZbdmYwaQqbYKSf?=
 =?us-ascii?Q?ndEJQoq6H0GW8FqQl/Yt+HeTug5pKIIok+jqyfoq6D2Rjm8iU3yuiuyAuXNS?=
 =?us-ascii?Q?IhX2XFMif1D+UlN6mwrdqspBh5EKUfPCccirPeRtqttsUvyvCeCZQ+V0S74C?=
 =?us-ascii?Q?sTob+1XvmLTn+iZR6n3M2cA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FB17ADB46748140B83BEE8D2FDF769C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7536880b-83a0-4243-f2ce-08d9ec796e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 09:40:53.3001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b14MwGAt6prn+ie+H8ncJvJXl0pjnf11EZgDhw5f0QKXQmngVr7+3KyD5PdgmRezp5bY7Jz+1e5NkLXUWcOOWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7231
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 08:54:34AM +0000, Richter, Rafael wrote:
> Hi Ioana!
>=20
> please ignore the previous mail. Everything works now fine. It was a loca=
l issue with my setup.
>=20
> BR,
>=20


Hi Rafael,

Great to hear that the patch fixes the issue.
I didn't respond until now because I was trying to get it to reproduce
on my end even with the patch - to no avail.

Anyhow, would you mind sending a Tested-by tag?

Ioana=
