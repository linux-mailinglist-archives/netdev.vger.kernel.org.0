Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C071A2FBCD5
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 17:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388955AbhASQrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:47:08 -0500
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:42562
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731769AbhASQqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 11:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i05HlaPHrs1czJu3aCo9yF2p+6ApnU8oQ4y0aTtdc80Ha86CoURukZMOspciGq2GF6f8FyD95kuQyXzSeHcF0zaGls6liMPbJ6k0hr8PhL5ZlEs+Pg9c/G1S5m5vhvbZPYRE0NL5+0Ke8x3L1kYugYP5LdkMZbMcflLgZ/eG8/V/Hrlv8r5G/Eyq2eXR9EFyeTsc4dEtvkiguks/GRhbbrs4r3/jZVQY3AAeKn327MQqJChbQoq28Uq576Nh3+FS6IO4lFtyQSFIXRwiVOxGePYpgPqfM4T4PvQSmU3so8z80cUi7tXKCJ7TWtlq/dyGYkjNpY6ev7KHKi7mbEGSoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10iwHlD7oZ5dA6uy/6nvfJd5fAJgrk0zCLY7/6loHw4=;
 b=KWgB8lb4fJ6o1sSZKbmkUz6bZC8A+a2rCzTjItucEUllUgOQSjB31WLnAhoHQWVtRY2bTzVGa6sVmA3MWAVIpBryhJa94XVozPzQTNgJMB0Nno3EP0+RzX9y9Yu9E2J252x1vdXnBdxBIfie8pGGkDgv+jLbibngKnkQGpL0KWDv/ZpzFmsu09LTdUbcMBgPtTNX9nY2tPLTlIYVHXs3+FKC8EbeMmzKQbGIWRjNzCJ1VlDE6ulyF+m/OV9ct2GQyMoTWWqtjcsJ8N9ZtqoQ+qDZFEcPKjPzs06YF0mMTmry2lIORtaF1XLLa8WttqBszCvL4DN1Vk3jBpT/rFs8+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10iwHlD7oZ5dA6uy/6nvfJd5fAJgrk0zCLY7/6loHw4=;
 b=OMSo0v5JRjKnasbcAU0eiJLw1YyifSEMyd4yHCTquNvqd4Zl5opxOPWwl3lL4iTDquabp8k0ljnxv/Jo4QsXS6lnm5EKVJesiSfw3U0WNlR8WbyCd/wMp3PBUKtjSCaMBxDC9uXBcMCy6Fj6PFmBHoC4Os3aE4y+793Fh9llWT0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 19 Jan
 2021 16:46:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Tue, 19 Jan 2021
 16:46:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Bedel, Alban" <alban.bedel@aerq.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Topic: [PATCH net v2] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Index: AQHW7mxY7uaoYquUzEO/44xBBVvQwKovKEqA
Date:   Tue, 19 Jan 2021 16:46:01 +0000
Message-ID: <20210119164601.dplx4js4wzhnmw6r@skbuf>
References: <20210119140638.203374-1-alban.bedel@aerq.com>
In-Reply-To: <20210119140638.203374-1-alban.bedel@aerq.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: aerq.com; dkim=none (message not signed)
 header.d=none;aerq.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c7465ba-c001-49c7-c666-08d8bc99b49e
x-ms-traffictypediagnostic: VE1PR04MB6701:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6701F48187917B0C8414D485E0A30@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qVbfHRoeLPxIf4QS0KfPcB3jQmvEnwJhVT56Z32uTv49un1b9NlqjyvdMvLP39fH58aPrIg+x9HugY1vE1IEg1Mj408muz7C0PY6Nqx4xtGqMkkCdPnIIzBa+akpfq/tEXjvzJhVAdDArzN7k3XQh1HUgYzAw+6oRDDoR0INNWgXsQNUJgeXhuGWyBrwEpsBt9PyLf88Q7P6wC3c+kHQ9fvokuBczMtMDQNVWN/cLFkzxhNneeGTIrppD3bW2MbiXBSymjphrILodCLejYgRIp5dVOE1cDjb6x3SiKaIC+NfEK8DxtJFnCNv9aHMQYwb36vOKrkKz+gtPyYZLgEm28ah4VJm0ySERzhMO5sXfQAMejsx9uKnOzRoazbC65ubznWrLrn+LEe5/ps4GdqhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(396003)(39850400004)(136003)(366004)(6916009)(1076003)(2906002)(6486002)(44832011)(316002)(5660300002)(478600001)(54906003)(8676002)(71200400001)(4326008)(66946007)(186003)(76116006)(66556008)(9686003)(6512007)(64756008)(66446008)(26005)(6506007)(8936002)(66476007)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0J7sl+rObeoRLq7TZpaZKra4e+dsiDQtwoFPHshtU2fZLUkqc68pdsEtuBSv?=
 =?us-ascii?Q?g2SGDZpMfDT/HkLSH+GLx6opZo9U3/e44edznFXavEBYrGeIBlLCGcZV+t2u?=
 =?us-ascii?Q?6o56uCwZsCyQzI6DYIH9UMoDtGrfapj+Xt9dpiZdCQSoFXpWjA0ppx1h7WVH?=
 =?us-ascii?Q?L+Icio6C2FRVwZB+qejxG4Tbx3h5hYbc9L8qTVWgcERu8c6gthEhfww4WSbx?=
 =?us-ascii?Q?j53EQG9BUOHaAt/ggOblDGBGy6AdLNUW84TGWJYk2MuGaP4uFzedxdcu1doP?=
 =?us-ascii?Q?UtwfTY+w1XtKrkamnJbV0aETT7129kyWg7LD3O0MbWj4jVuqG9E3zWm3KcMZ?=
 =?us-ascii?Q?VbOvqkzochrYXHfcOMegWzyq5/iRBjN0m3XwLFG3Vahx2RO+XJf8t7LIdMz1?=
 =?us-ascii?Q?eBoCynvxeCPjJGtHxjdPWopf+ZzhsEsRTa54u6DLZ8rTTsa3bLR5xcpa7frM?=
 =?us-ascii?Q?k50OKqDSMqB+ZAmmek+dLiVRJQcbLRZ1MtV+O+rWYuTVyQ9xZ+77/RwJCBDE?=
 =?us-ascii?Q?ol3EQvAhr2WhEBdPOuTOvyZQ3N7R0uyEHeZFCM9EDeWDBB7FbTrLvswyJUIo?=
 =?us-ascii?Q?xfR0zxWXJb1Z+TFIGrcEVPdZOtERZw7wRjRgWUn7Bsm5n6/kPWjDxjkIdghL?=
 =?us-ascii?Q?KAEPnscGI4+yOwKc86bFxHnjPdi9XOqgwiqeZUOZ0hCdWTH2CEkOPAkCB+nY?=
 =?us-ascii?Q?Pa8JN2mUMubC6703DzwsjdA0dX8aj2mCfI1EdjMHB4KlNZVzmdiIonSGQOTd?=
 =?us-ascii?Q?PJSeFz4LyDwC08kmbygUdld/TaaEeqh9wzH5Y1654Ua9AHCu6hu/60rsUd8j?=
 =?us-ascii?Q?ZhSIaI4HczUfq6v+slsrxPm01iVrFrSzk4d3cV2p0NAnkZEQwD3zyp2+NKr/?=
 =?us-ascii?Q?E+7HaSrP/0MzX6CAUHmnkV5uXN2qpvyeu2JKCrJ8mMdelLgxzm48GE4MMU6o?=
 =?us-ascii?Q?z5jyWr69EkLg7xSvKGhYRy7jb+L39P88mej2PhodDm/1mw25wbrOrIwPOzgR?=
 =?us-ascii?Q?Mv7d?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFA47A8F6B01E145B71C8F1672496301@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7465ba-c001-49c7-c666-08d8bc99b49e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 16:46:01.8278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yl4zNiBDpH7OmR5Cu2gFEmkO10hewzhHeMW+3qnCETfpejF8Aez9x10wZwPPmCr3AFU11QKggvJQYx7oUiYeRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:06:38PM +0100, Alban Bedel wrote:
> Multicast entries in the MAC table use the high bits of the MAC
> address to encode the ports that should get the packets. But this port
> mask does not work for the CPU port, to receive these packets on the
> CPU port the MAC_CPU_COPY flag must be set.
>=20
> Because of this IPv6 was effectively not working because neighbor
> solicitations were never received. This was not apparent before commit
> 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb
> entries) as the IPv6 entries were broken so all incoming IPv6
> multicast was then treated as unknown and flooded on all ports.
>=20
> To fix this problem rework the ocelot_mact_learn() to set the
> MAC_CPU_COPY flag when a multicast entry that target the CPU port is
> added. For this we have to read back the ports endcoded in the pseudo
> MAC address by the caller. It is not a very nice design but that avoid
> changing the callers and should make backporting easier.
>=20
> Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
> Fixes: 9403c158b872 ("net: mscc: ocelot: support IPv4, IPv6 and plain Eth=
ernet mdb entries")
>=20
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!=
