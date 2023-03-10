Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2662F6B3ED1
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCJMKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCJMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:10:24 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2040.outbound.protection.outlook.com [40.107.247.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91D0FA8C8;
        Fri, 10 Mar 2023 04:09:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXLT10UHWEAgxqaPSjzv4UDzugE7tOR/QIErehz0f/8bprwa1O41PdaKwLGLHULsa65Ik2lc8NuQcrnekmBDfRWnhoN+wMw6+16Q3hGFJ31+nJ+2xIEzwHWcAtoM72PmM2fBn/RDDvWXUwEBQ+O6GbX1QjvNQhyEAxAr4lTvwKf7+RHuvfsG8ae6l9r1Sj2zACzz1l5Wn6laqpJ56dj4RbjZBfoqDHEg8qmidqGy9r2276gtAH6G7JAndVNJk4p6fkSckMNOVMigU/R9GmjOx+jmNC4KUunE27uc0D2tuo7Gmd2nvifR1JMwlwblEZ/qa0WwWzjKRxQepcRY6eWwow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIexTVkRx5ss/+9a0yHz7x3htmpDuPmimEAQEX7SeV8=;
 b=lMUQIgxIlZ/ZuLH3+i3jR+0/TSbNptCQ1QOSllvuqS1awwngKAR4H7cjzZE62qA3j1zdkHZoOtOA1n0LEPEwk2lY71W9POH/PzoO7U82mj0s0ytXFEhJU+A2EOsa8v8RQwM9ygiXOkzd3YQdBh7jMp8z++kpBbFdFxQwR21rc0225YFbgyQ/Piq40u57fDxMB85XiHwGyrdes4xW99yJXGbT+fZvmb1x5kqLSYwysjElr0kJUahn8pdnu7d+gE6fQo5DkdnMaGvQ0I1gLuk3LtqJqDc6L/K7GEa9bzqVHYYBnWU7ubic6kSRfuI0Ev/XqF4hG2vJUIPYsidRMmXPRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIexTVkRx5ss/+9a0yHz7x3htmpDuPmimEAQEX7SeV8=;
 b=eL0i25viPEePCsjUEd5deiPpI7FvgYcsTjMlyCBbMgQa4nOjo0zaIihU0/zvdM04gKFj/exkQczFkT8CHn+bKeR2HioQ0q7CGC29xdSNI/w7UxFuDT8JD17n/VW2bM4RxxVdoKdwjO8SKm6+FMjKm32kMYuH+K0srAU4LG41kwQ=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by GV1PR04MB9120.eurprd04.prod.outlook.com (2603:10a6:150:27::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 12:09:09 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 12:09:09 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Francesco Dolcini <francesco@dolcini.it>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for
 NXP Bluetooth chipsets
Thread-Topic: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Index: AQHZTFTz7I8HL7cZs0WTN4pxjl5wrK7t3v4AgAYME5A=
Date:   Fri, 10 Mar 2023 12:09:09 +0000
Message-ID: <AM9PR04MB860372E06283EA79BD341998E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
 <ZAX/HHyy2yL76N0K@francesco-nb.int.toradex.com>
In-Reply-To: <ZAX/HHyy2yL76N0K@francesco-nb.int.toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|GV1PR04MB9120:EE_
x-ms-office365-filtering-correlation-id: d17732a2-cd59-4f18-6acb-08db216040e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zh/x+VAXpElwu9hJZjP81lPs2f6U68JouEDGROVXOBqPhN/d1IDxfhf88ninnM99XGUdlaveJerJoMBa9+bBA42LK9l3vtsq1FfTxA9fM4nKg0UNIJClDErAbru8kKx1FzggI3bN+ieMpGUqc6ksjkDAkETmXcFy9tWelbPBo2z8/iPJ30kyVgYtLGycy2X/Tp9NdjxmfKqPDDyVNddpPgfBnzopW8CdpCQHgjTyun+ceF2B/xZZ6t0rYD0Hrfyibyv33MddD7G0PvCSlEYVIg9MWS4T2lM3m1ywLAJJ4jdXMq21g8l1aP5RdTRQPBziNzZ2r6ukUZBFgDtccSZvwp6k1S5gW7eTpwIo9h5HwQCBESvjBIfx4x8ZGca8XtiH0NYzVCXx3eez40tZvBGb/UX6In+wD/KizIe9KMAaOWyGdrZBCSk/U/2ouFDb6tkA/s3ySJekxfQUT3pFcvYI1uFYUjqtxTijaXiTRTpyrlTluN8R9yDCrVO31vlXu+qqmX00nGAoZhg1SQl1gmhxkN/WInR28vyUx6ldNkn38N2ttE2UNng6oMbb5Y3g0ZBH7RAHyEPknXqO2HHqT9O4zkiROUGY+jxVsf/A9njNhVyGMRHDQuPr+cXkoaEjx39ULDgkrpDZklcNyudh6g3+pcbH3B1cqgvGUA6Hc/31O7eWffrKJqbPUHLKFJzAyzB7rDb7OsrECFQhfjaTcw+kjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(7696005)(83380400001)(38100700002)(478600001)(54906003)(8936002)(52536014)(9686003)(186003)(55016003)(6506007)(26005)(71200400001)(33656002)(5660300002)(55236004)(122000001)(7416002)(4326008)(6916009)(66476007)(64756008)(76116006)(66946007)(66446008)(66556008)(41300700001)(8676002)(86362001)(316002)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yTYyHQAWjcNoc0k+vcsIytM4pIOlVz4N6n+kvTK1rDy8gvaNiszXNCNuY23Z?=
 =?us-ascii?Q?pFIQtHvKJ/6p6unY+gDbq0RlA2Gq2e2cgyg4sT8x65loW8dn8gp2614IHhu4?=
 =?us-ascii?Q?ucxq8lMdB85wpuZd4VDe2J/DpVL1zFWex5/Plb/qmvWabMS6JKLKKftmZZur?=
 =?us-ascii?Q?T+tmnKzBKXyQDO1FoQkiM2Y1G8sWJ8jFHpYD1kizL1Qvf1RrT2qw4DTrmmUD?=
 =?us-ascii?Q?YVTs7DxzqKPT6kMS/nnlCPWWWqv8UGpsJh2ongbfw9pjPfPEo4SlVqUUs6th?=
 =?us-ascii?Q?QzQdy6S7N/59fY/a2YwiC00a/kcRlF65dZpS+rDft8QZPm65dPPauuufF0FJ?=
 =?us-ascii?Q?FU86qpp6h669m4eYsPkQiZ05dd+Cpf+MdIZYcHMj0ux0Bnc2rlQsWPc8Q/+U?=
 =?us-ascii?Q?4KnbFEltF7UGO9FZwpCrMSMNqZD+AkoqKgwafs5UA9W1fgLrWQb346X2XTXC?=
 =?us-ascii?Q?LSXBEdd4FqFlYTiZsi43JwEh6rJFPUqZ5bkN6pJGRN2qDDJInjytb9UU8uYJ?=
 =?us-ascii?Q?eF1MPoS1g0jZjLnGd7ixmapohQ+ujLchU3jOuQfnMDLh7fuCZAMCaKr5A6O1?=
 =?us-ascii?Q?VMhhzuTYbgU48rY5kKM5JXCAvzXyNzTrHlvRf6hqWEeK+hATIPgaSaK2y0r4?=
 =?us-ascii?Q?h0PCVLEweIBftRPiLwueTXZ5cas0sumdYaB5xdgd25fk2oc5dS2SGp2CgUN2?=
 =?us-ascii?Q?jcUPEK30edGJaUraiGtPPPka7n8HL52Nrjtc4zooE57f3opz/IOuxPyTikPf?=
 =?us-ascii?Q?VL9dJzJq1KVPCMhcu7AyuNvvT3ZDil4hT9B0e/6UDPqNhAVC5V3roVAJ5LgH?=
 =?us-ascii?Q?fxpCjlA8pHouuMp/yd3mqwNooNGAR2bfnfMYAEm7sHjSO0/6lsyS7phcQTJ0?=
 =?us-ascii?Q?1TWp4/2fmJWwSuBd3DJCdx/v/nLqczvhm1rqLCMFrd4ggcmJJQ0h7dnDgIBK?=
 =?us-ascii?Q?MB+rB6ZgDByZlrzNNsB+tNYkBMpxPfUP7JLbv/5hvahuS7vLlYnfFSwC+YXO?=
 =?us-ascii?Q?QTUPNzYsIA+UfYt8E3q1uwLEV2fcs1105eJSmE6/wuDOqAfDVz870YW7VbPt?=
 =?us-ascii?Q?d4JHjSP4lV3y+pupZKO5/DY+HD8um+nJWRuUot4DaaNyD9iGee4SfYDhPPnO?=
 =?us-ascii?Q?mRw+pGGunqBW50mLxRvfHFJWMhLcDlqWfMP3QHxjLEASwu3dz6Muddc6NGq4?=
 =?us-ascii?Q?IXu6xZSiXG2TohTB+1CGRgMOv2I3TGvtWPyBlbhT7jffT7HlAwRJEcRYCfij?=
 =?us-ascii?Q?HHh5FKTlpAqNnp+lZM1hZWDqn/q0HHpGHc4t9ixqHU18G6bk+fcC+qDt3RY6?=
 =?us-ascii?Q?lLzApQg93pZ6ZlHp8SBxBhNDEyIVEebrv/u3kMaER8f6x5YL8a7U0A2GXBeK?=
 =?us-ascii?Q?NgI1Fq1YhNhaLnqNXt5aQH9x6I0/TlEFc168jG94ix+h4+bQhe785B0pJ0a7?=
 =?us-ascii?Q?LUxZZFSXzbh8jkYjA9PNB/3bwywQbkaRbWI0JAiBKE8kkUaE4NNFIziLolPt?=
 =?us-ascii?Q?DHyjWjjBRz/Ct2P/KBQDHp9gVhyI5XDnQevNWtOY2McshNEbfaqqkSBPhDys?=
 =?us-ascii?Q?N+/asFa8rf0fXkIPwKOZgQL1oMg3hGb/2/2evtrLw86oJ2ehfWrNFd0ZEmtj?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17732a2-cd59-4f18-6acb-08db216040e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 12:09:09.2517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2k0ZzS9ofRQK8AwdWF6uSy42iuFwD5a4+08J3PXG/kNbXrPkBFxLBeV9ztSdC3SCpY8hjO/L314prlwmfr0+iy21z079D/+HSmgP2s2J/rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

Thank you for your review comments and sorry for the delay.

>=20
> > +#define FIRMWARE_W8987       "nxp/uartuart8987_bt.bin"
> > +#define FIRMWARE_W8997       "nxp/uartuart8997_bt_v4.bin"
> > +#define FIRMWARE_W9098       "nxp/uartuart9098_bt_v1.bin"
> > +#define FIRMWARE_IW416       "nxp/uartiw416_bt_v0.bin"
> > +#define FIRMWARE_IW612       "nxp/uartspi_n61x_v1.bin.se"
>=20
> Where are this files coming from? Where can I download those?
> Is loading a combo firmware from the mwifiex driver supported?
We are working on submitting these files to linux-firmware. They will be av=
ailable under nxp/ directory once merged.

>=20
> > +#define HCI_NXP_PRI_BAUDRATE 115200
> > +#define HCI_NXP_SEC_BAUDRATE 3000000
>=20
> What if the UART device does not support 3000000 baudrate (think at
> limitation on the clock source/divider of the UART)? Shouldn't this be
> configurable?
We have noted this requirement and decided to design and implement on this =
in upcoming patches along with other new features.
We have a number of customers out there who have been using these chips as =
well as the legacy Marvell chips, which need FW
download at 3000000 baudrate, and so far there were no issues reported.
Using a lower standard baudrate affects the time it takes to download the F=
W, which we are trying to keep strictly under 5 seconds.

>=20
> > +#define NXP_V1_FW_REQ_PKT    0xa5
> > +#define NXP_V1_CHIP_VER_PKT  0xaa
> > +#define NXP_V3_FW_REQ_PKT    0xa7
> > +#define NXP_V3_CHIP_VER_PKT  0xab
> > +
> > +#define NXP_ACK_V1           0x5a
> > +#define NXP_NAK_V1           0xbf
> > +#define NXP_ACK_V3           0x7a
> > +#define NXP_NAK_V3           0x7b
> > +#define NXP_CRC_ERROR_V3     0x7c
>=20
> I assume this was already discussed, but the *_V1 looks just like the exi=
sting
> Marvell protocol, is it really worth a new driver? I did not check all th=
e details
> here, so maybe the answer is just yes.
>=20
The 88w8897 was a legacy Marvell chipset, while the newer chipsets we are t=
rying to add here are branded under "NXP".
Most of the newer chipset download FW using V3 protocol and few of them use=
 V1 protocol, which is still different from the V1 protocol seen for 8897 c=
hip.

Initially we tried to add support for NXP chipsets in hci line-discipline, =
but Marcel Holtmann advised us to implement this standalone driver based on=
 serdev.

Hope this helps!

Thanks,
Neeraj
