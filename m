Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD7D60C58E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiJYHlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiJYHlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:41:15 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2043.outbound.protection.outlook.com [40.107.103.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC3011874D;
        Tue, 25 Oct 2022 00:41:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDAfKQ9liCYbUhai5JWcbHDAFhDdwCqai+zHTqNyz1qxEYDeJdrokv1ZaUwa72jk29E+qwIKyg+1H1j/dW7AEynuZxuheP2orvRStb3dMk1DOsRarC+Kok2am/K4yYhMcx2tnd4ed2k2juiDxLQbJhU2qWElVcSTqvk7ld/OTtiCaJU9BP4uUQvhGpidEccRWawqAEmAFIWVmL/kCgZyALda7EgkPli9nBloyhwH6YvWwoeiX3HRlmaxlCp/GwphP17igIGXr4pVrXP96mouVf3ESt9amIi94WQo6F7CBw0nUNL+K0IU7QZ1Ra9dBpSQlLzlYlrBIW5xmN42dSmM2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWvghMhC1NQmtB9/XIEkgL74rG3D1/81WDnWtiTDyIM=;
 b=ifzFSJgaQmvomOof2PYnP6fq6ItvK845E4B1s3L8TR/SFVo9Q1Y1zaHVmzbDH080k0gsHGdNoE9rLoSKEv+l8ubPCgmsbwBBrulr3xWbpau+TFTgu8BP10WNMEsadUmekPsJ2vRR8E9YUck3Oi4EdxuIMPa/NVbfmva4qvc3QDtw3HipfZwslXmR4lwFX2KjQulhPPq66EkBgScZPA92yY+G4JkSMiiuia6Qymgrkec/K7VshyvO3h/GyV4DFBwri27NOz1fp1SBw+rhkZDTds4p4HR8/wo/1GL+JwK00fwCFnzaTfn/xh1P2Mc7WCCOvCSTKuLWqUckJKZXIfOSYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWvghMhC1NQmtB9/XIEkgL74rG3D1/81WDnWtiTDyIM=;
 b=GdrSyJdulex06q8541v7KyK57qy04F4A8N/Q1Zp2NHT+wYo8LrbxbPE5lxTe6ssW7EmUZirhIWiVC3tP4rAfJgTXBd6jwSifWOxPlg8x0rCCbsp6DWINDYpisih+wuwRPmSiwdqs2HmLPRr9hCuCDaEl15BBxU8iNpLSL/5ZpGk=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by PAXPR04MB9328.eurprd04.prod.outlook.com (2603:10a6:102:2b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 07:41:09 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f9b1:83:c855:6c2]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f9b1:83:c855:6c2%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 07:41:09 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Topic: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Index: AQHY580AN98BLZW0GEKjvNxRt3wIMa4euhNw
Date:   Tue, 25 Oct 2022 07:41:09 +0000
Message-ID: <AM9PR04MB8397350EF076102B411906F396319@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|PAXPR04MB9328:EE_
x-ms-office365-filtering-correlation-id: d2a69654-2b3a-4920-7020-08dab65c483e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1qHqepRNNj7m2TbeaLeDWtLngs8J7rM3YBNYeRDWQibJbVO1CtgT+7ITBZyHRcesNXgf9WIwVEiweCKx6ONnV8aldg5C0JB+m00ORCGIfOB1MxJmAVu7JysYZV2ODslAS9H9jIdoHdoIXarRC1mbPmwQP3hHv1bIs4KoaX9Izm2uaYB8RXM+ekrMXQWYjeuxUy5+hKPGdHs37YKa+hkTag6UsH0V9IfQ+5JqbN1bhTT8X67m70D2ht3XaRAA6Ya8qlHWv3jxm5iwJtXWV87HvWnAViQocj8M+z3aJyuhsnnxZAOw2xJWOWJb+OQEFrS+U/XIrcOxWF4pSCyLJmhQuAxWF4hv7jFYmPB/DgKT4gzFR1tg0CwyloteFhpzK1iYTk9k59sEpDmDvuBNM6YevbMxP8OXfcApXPdwG0hQCtXbPm7ptThpuxhG11XcO0F5tF6JcUahB9Vj/U3NQqj7mQikCdIfS8dc8JTm2EJ52VIfuZOYqJTMK5Onf4njn5EacrG2+hPdyR2uW5KKvR6zaj7kkjP5ASUPExNYiTOq6BA9sVEMHLUzHbSkzFfiKun/HwNKG3wzEve9h32wanWRYYeLvBTdcZdzoJiKWSiao8+7rh+Ko/ociPX95CxS/GJPPGe1WxS/XqzzOaGYGaX3BTKrVQHTaC12mUkkKYKoM02eagdOwned/K0qRe7kQ9e/seJY65h9uEd5qZczSzGRr+w7t6HbkwS03VzcVl1qAJPKwZvY5zCZs9Tslkk2uDhGcKaTXeTSLDPNeNhqpOv1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199015)(83380400001)(186003)(38070700005)(86362001)(122000001)(38100700002)(44832011)(2906002)(41300700001)(52536014)(5660300002)(8936002)(55016003)(26005)(478600001)(9686003)(7696005)(6506007)(53546011)(71200400001)(66946007)(64756008)(8676002)(66446008)(4326008)(66476007)(66556008)(316002)(54906003)(558084003)(110136005)(76116006)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kCHZPl5H0r4/uPuLxBQj+e8wAcim1ke6Oxqj91axBJg/IOObbt1tB1n1peIh?=
 =?us-ascii?Q?qzibogmjTjrKrGir6X0JhnCcXmWUJiv9Z/R8x4LSJU/1StCYia6RZLNmFWaT?=
 =?us-ascii?Q?FDhP+so3wVrv4cp68ay4eYJvIRcb1q2Ww62yxHcdjO0fgIEjQZhCS+A3KeVZ?=
 =?us-ascii?Q?APtcKDn9ZktCWufgICnYILacXSzzvYNWce1AmxEtzf7yiNO9VNfiihMEFivf?=
 =?us-ascii?Q?alO08FGV4PrG5Wp0AFh5uBtV/+DhdY10Lg6VidfQ1A4/yBMRpIG9Hz2reJ6D?=
 =?us-ascii?Q?sBrzKCQuI4NN1sZjRcC2uaZaFBOk6mdKzG5hMoUwFdRLpvaHxPg6JHHKcsP5?=
 =?us-ascii?Q?dHoCnJ60BtXGQo9OtKw3ifjHBA4c5VwMFKdgNK83qSJ2goi42DRKlBbMPOOp?=
 =?us-ascii?Q?J3B1kv/GO2czZInEeudk5I+e9Kt5JcoBG0w+yhMmwSSVLt6nbeXu/Z1QNSyq?=
 =?us-ascii?Q?FMw7Pw5MT+/HEWpsp6oSebfgf8Gzwnvwx9kCKX311ebQTAuWx2SZw8S88om/?=
 =?us-ascii?Q?dfZg0MgEa7Z5oYVwtIBV1MFzD1aeagvTt1TLrxEpBzxP18ydGA7jLZZFrnmE?=
 =?us-ascii?Q?Ec+LH/4kdrpnfi4sP7H7GG+z9JiSJWq4Rdw0wk5BsEy9fLOTZgTxAy7F2L95?=
 =?us-ascii?Q?mn/ycCfhViSjSUR8Y2Vy5mRB31VCc2VW15YBzkBVirl99k37eDGhUVEEst3W?=
 =?us-ascii?Q?1nGzfDSH/Z268QU7mp9Iktjx9atflmZINzDb9vWGMYoVWSznhl13fZRCm2aQ?=
 =?us-ascii?Q?3z900TuJPi5ClTc7VC2RScaueUShYGEYCXzHckaC1M2nW3dtwS0el7L+878q?=
 =?us-ascii?Q?QxcHS4o759rfKqvIgasHCbVhL6v4z0nrPkPEAfifk5ZuMUwTsPBOlK0wqCjw?=
 =?us-ascii?Q?8eghmeQ+gtIMNttg/OXosydwTfx9tBHLgRKy1bmThKs5CVugbwJKcePTdILo?=
 =?us-ascii?Q?TE0j6bzj1XWws4C7MjIeAVLfNxL4tqfsx8tMkYXZ/cAUaUx97YajGvCdqnWJ?=
 =?us-ascii?Q?zCUlKzYfc1gEvPtfmq1zpnxbFUeEfAF25/EZlxZp8WP5r+1ju4llj5GN9aTh?=
 =?us-ascii?Q?zEHDH7D/cnRCe8CXLs/JccAXcGheQvQET0tNZ1w0jxCgPSeD2lZITU5lntk1?=
 =?us-ascii?Q?DTua9vCaseya1NmOe2nfbCVoMMLuf9cWcgryAygaiglyvPJsisER7GgpBfT1?=
 =?us-ascii?Q?/qB+4/F5B1RRhhyTagCfy2q6PRJvqK8pboEMS0amRgW1aMAHG+bA2PjaYoPO?=
 =?us-ascii?Q?QbBrvMALYTPkPo5p98ffjLy+mS7izmv/O+iNfqpotZQmsBc3Qy5j7aK9dB03?=
 =?us-ascii?Q?vpDLWWABg0fXga7h9GoYwLq+tBWCy39431RncANCX9ENj+I8VgtdiUYWmHLZ?=
 =?us-ascii?Q?V/Nt7zCED0RyZJb8mQvedWUvL2utSBknr/lHttD/Hd3WKwzyywlxWDJfIrn5?=
 =?us-ascii?Q?mxMmNJ8gH1Sq88CRKVWv4GZnBqmmiYVSfdd51JzCj2if1utzBldw/UxSuSxT?=
 =?us-ascii?Q?fl5q9K0Fb1Zo6o35HLaEJ+fIqL81ZJ8SoOOiohGaeLfcYx1qMrDbp3utemww?=
 =?us-ascii?Q?6isqu5SVSp74/UywGLgMjq+SnV78VfMSYJUGuqpO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a69654-2b3a-4920-7020-08dab65c483e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 07:41:09.1019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rW89di6OhJUrlD2jlwkrzeeSR/fKRAXH/Ev/Hh0lsKE4xVjEPrBC3XwruuxmsD6vm59TnPZe8xuIhUBYfBYM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9328
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Monday, October 24, 2022 8:21 PM
[...]
> Subject: [PATCH net] net: enetc: zeroize buffer descriptors in
> enetc_dma_alloc_bdr()
>=20

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
