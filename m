Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203313106B8
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBEIbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhBEIbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:31:03 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFA1C0613D6
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 00:30:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFB2+A5a/2PFHgTm2ICNRUmsJoNdzbSAnj7zNtzfr9rjpnRBjdOz84qbyEQLxPKXk3lhsnA+EU06UZIs2fnztpckCgCrgIzsRlChap8TjddNm3NjncD8N187pLTIFL8L5xyJsVpkitkH/woJ1kyyZ1AnT+mpIOkubxPCjYKnQADOznT0EW2VcE715iC1p73JkDGH0tlEngPJ2Pc9ClNgQe+JjSmqN9VQrXk2UrJcflCBPediNuq7F824OYdtZocSX3NMILC8jnD11uSxo2IFtubibWwBCSwlv5HAAdHb1xhDEs5x0KtNtQl0owzsm2d3Ez88dM2Ct1SXZI5neNKmXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep47n/kiq09OmGX474Rxv5bQ+/UG3S8F2cCWN1Fbe+s=;
 b=jP8sQ7AGX7EkAyeij49CfkZUFyoSOuM+cY5LB28osRAT5ir+3t2adSNC2/UVJC/z/UuIRfYwPP52fvRtNj70NSNuPVqSmMM3/JmXjnBCdnzvC1UMpwVLewu9zIUOxs+72LS91bdbLSmJaP7T00Kmnm/tNAcf60L8pxDYv8LGv7pXhDhBe00FV+JRqfBJtyoHG24vGuKQr1b/v6rTPSj/HEdZukPaTRdIP62m9/oC2OjTOcr6r5f1Vzzzdn14eo8YYsp+JGmU0mrNIjd2dhJGSiPJtZakX1MHOPdpZAnYiQ+dIwTTNy8O2g8yi+GPUzZ5G9rdziSwsGpNMcUHFtuZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep47n/kiq09OmGX474Rxv5bQ+/UG3S8F2cCWN1Fbe+s=;
 b=a8vo6tlIAwEhE3MJgFSRv+MIzGy0ZxLs9xtjBONkk/dKKHcrzB49Dbq64P88YpeOrL8yZSZhHBtqIChe2U3PzU1to7/+33Z3PB19dVPEhaUDIe1O/wdWLS2p3LkvVcpAmBkiC1C5WjA1tdMp66H1p9KbyEl7KGdfNmVvem2lKMw=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB4743.eurprd04.prod.outlook.com (2603:10a6:20b:2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Fri, 5 Feb
 2021 08:30:00 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::4891:3a13:c2f5:6527]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::4891:3a13:c2f5:6527%7]) with mapi id 15.20.3805.024; Fri, 5 Feb 2021
 08:30:00 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes
 under XDP
Thread-Topic: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes
 under XDP
Thread-Index: AQHW+xXNEKYTr+Aee0m3+J1ETTpgLKpJO4hA
Date:   Fri, 5 Feb 2021 08:29:59 +0000
Message-ID: <AM6PR04MB397672A03823B075C3E79D87ECB29@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <cover.1612456902.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1612456902.git.camelia.groza@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.196.28.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e463d884-1cf7-4606-242c-08d8c9b03a57
x-ms-traffictypediagnostic: AM6PR04MB4743:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB474382B38DDEE3A6808C7C56ADB29@AM6PR04MB4743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wzTzI7bZazpfWtfMRHQhVPk1zn9xFpnRly2Qm55O8uRaVFKsZyuoLWcXZn6pknFbGOgn668JNGSG0aU4knGQpHJLPTNKkD2pCYlecwhTpYn173AJsRvZa8VurLc3bGP1amvYHWIio5rR0rQLNtyPaZddk39ardXFgk7Eo2Q6NRzTS4Ce2tblE5kEjgu5TQbJTFX7lRGG0IiRQA1guyNovknF6aVpCiaHkZfYsmEEEozzyLIyq+5o/G/MtR6Cnoy4bvUXtFVLyB5B04QbC4Se96qqUUN0XQKGxfBBPZNro7JbdnMkxZ1EKWosRsRc2L2f3yUZkD34w0nYMEy9gRZx8nZ+WPAuYACn32UlFvw3P+lynG2jv8gJOD2bt7HHQPSNKJurXazPSv+nbabKmHUWH++LzUQDIoc5hwwTTVjP+olfZqt622wWu1VakdRhhVv29bBHuogKxOPNwPxRkgCUUHLLdT2FM+0PwxZLqHd9pc6J7Ya6kHMvFNl00w1/qUSU/akruCxG/YC4LO9N+AE9RQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(76116006)(110136005)(52536014)(83380400001)(316002)(26005)(186003)(478600001)(6506007)(66556008)(64756008)(54906003)(86362001)(2906002)(71200400001)(8676002)(66446008)(4326008)(8936002)(53546011)(7696005)(9686003)(5660300002)(66476007)(33656002)(66946007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E4kfVV5j+n1lJHEZRXqVptSpduYSRdTEx7VmjaAMvjY6u5xth8+J4zeXY25d?=
 =?us-ascii?Q?Wul2HFnsXk277AvoapI1hAtjhsIYB89k/u8MwRksUDO4+Djmk54Frb51kcqo?=
 =?us-ascii?Q?BwxloZlHnHmTebZO7N7IFfLiwplKKxObCcIMqqx8EdDNDNfXqKTGdBkgAW63?=
 =?us-ascii?Q?GDC/TOrb3nt0qMXn496m0Lhpv2RpbjtEN2qxP0FrEeYlX0uEWku/e7IcrQ9H?=
 =?us-ascii?Q?OX2IiKUlgR1URBpPLw/KTaiRLHcMX0IAOECN4Vf8njsoBLIW6DoJr0Y1eWqi?=
 =?us-ascii?Q?oswMbJZzcPk+VR/s6aJJH0V4kEbA6+xhDNkO/hUIQSEDS5nZCuSXfArD0Tdx?=
 =?us-ascii?Q?f9NxqjUwchLy0gq3PlV/6t7pT8jFuS1mGkcDfLq0D1dcl3mXY3Rzhk75Jb9z?=
 =?us-ascii?Q?y5gkQicy42ECGz0b0NItOqwRpEvQKU8YFymhXbECd/EarC08AE2Xu1qBjT1q?=
 =?us-ascii?Q?0YXVODkCUgcde54vHvtSgvy2AkFdxH0wMeEpPHs3J6Lf7O9td7fYAyAfX2py?=
 =?us-ascii?Q?/OWPlbzpWK+0lUPWXky9AfdEZS6OLHdt97vzqM0fN1RZg42TqqigqEvqWl+n?=
 =?us-ascii?Q?7F4svoQTY9dkAO7ipQe0Ces2as55SBwpA2PvKUGatVSgGSnGjP9fjEVoeBPS?=
 =?us-ascii?Q?RQW/wMQjKCwJtFcXR70DoUekNMBh0+alwC3tE6Ck/bQWV8tRgeB3Ipn9idGf?=
 =?us-ascii?Q?A6eR+LwTZAPqC8xIbBNOcNhz/WsKvjvJSx1VlfPrHmVguxJAGlne2swcvlKz?=
 =?us-ascii?Q?k5obkAxT4fRjgAQ6vkRLwsy0KsGp8zuxwtd4v/S6DhbscdlXau5HFbtgY+XD?=
 =?us-ascii?Q?1MIeekXbz+KVgPE5RvFMSCqazhUWl877Yz+deDPzSuhwn/QAPXqCmNiMO0G+?=
 =?us-ascii?Q?pZSMMVkvvN2lsUKpcIi4zP98qpZCz80XuLWD7biYZ92/v4LTXu49JX7KKsuR?=
 =?us-ascii?Q?rOQduGAx9nrBn4l5aTdWOlUXe8pkPlB0SShQ2HEq3tSRXr+oCihZBazDS3cy?=
 =?us-ascii?Q?9ext8xNZblY3E3hIbjGjUMQCfhjoYA79RXF2q0BffkbONTpZy+BYIwEpzVaK?=
 =?us-ascii?Q?1aiU8v+sA5t863azUKoKbRl3zmeUxIAErOAg921QnfbwZsj1qnqmzDw9ggk0?=
 =?us-ascii?Q?MPaegQgHkWXtEpWMqYtT9eblPpaaJO7zoglC+qdzjnKwQye7Sy1au/EBXdQv?=
 =?us-ascii?Q?RMhDo7rvt0qTJgbuqeZb8eYxrLQE9L0bTR9TkdTYR22fU/QQHb7hnTLB7eEY?=
 =?us-ascii?Q?SP7nJNn8sqZ3XYzXf5n3g3nR8EFsvBS56wjpEwgnw+HYCW6iD7hl3EhNOhq+?=
 =?us-ascii?Q?1O+HyU/DR9wHgUv5dmDOwl5j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e463d884-1cf7-4606-242c-08d8c9b03a57
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 08:30:00.2492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qVIs0o28yjLM8tqav3+9blIDwXccfvuWA1/HQKQA3bTt9p0vrUEBDVfrPYF5mVMI1WrRzQRY1mjecy9yEcwYog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4743
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Sent: 04 February 2021 18:49
> To: kuba@kernel.org; davem@davemloft.net; maciej.fijalkowski@intel.com
> Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> netdev@vger.kernel.org; Camelia Alexandra Groza <camelia.groza@nxp.com>
> Subject: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes
> under XDP
>=20
> This series addresses issue with the current workaround for the A050385
> erratum in XDP scenarios.
>=20
> The first patch makes sure the xdp_frame structure stored at the start of
> new buffers isn't overwritten.
>=20
> The second patch decreases the required data alignment value, thus
> preventing unnecessary realignments.
>=20
> The third patch moves the data in place to align it, instead of allocatin=
g
> a new buffer for each frame that breaks the alignment rules, thus bringin=
g
> an up to 40% performance increase. With this change, the impact of the
> erratum workaround is reduced in many cases to a single digit decrease,
> and
> to lower double digits in single flow scenarios.
>=20
> Changes in v2:
> - guarantee enough tailroom is available for the shared_info in 1/3
>=20
> Camelia Groza (3):
>   dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
>   dpaa_eth: reduce data alignment requirements for the A050385 erratum
>   dpaa_eth: try to move the data in place for the A050385 erratum
>=20
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 42 +++++++++++++++++--
>  1 file changed, 38 insertions(+), 4 deletions(-)
>=20
> --
> 2.17.1

For the series,

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
