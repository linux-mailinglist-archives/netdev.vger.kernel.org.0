Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294EA4225F2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhJEMJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:09:25 -0400
Received: from mail-eopbgr00059.outbound.protection.outlook.com ([40.107.0.59]:41318
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhJEMJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:09:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBuIZr9VcT2iy2YjUKQ2CNe7s/kLRFFvmCIj+C258H/pRHbeUcUskH/cGMZeJ7a0InyQslmAkY2k+vxeFjtNUeDr5XZ4rZddBa2m//2YuhKnznaljv04r4JFg3BSvbuSUeYawsBWWQp/W+XseTHd9KvP1fwGSZqizxlnkbU8qIfSdPNsrBspZe9nFP2caaX3f+NAENCgJNlpZX9F3B9YAvJUcfJyqXJbR/ZfKAJaJLhGHrjyoOID834NZ4UkRFR/0HzE/bnGqXBamHZS9z1O+qCYGKC0dJKej8/Qi54vd3dMdzJsbYgc+A0/NTBmlm2SK7ViqROaUffcejgBDsKQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVF/VpYcyt0HfzIeYdYdLmTpEzicV1UL9sdIGX5pjNk=;
 b=Ufd9BQU3BE8CcElJ6Gb4dA5UtKS7kIeLLNYxoMpHtwZT7SeZoD/B1jF2uQyUolLvSKi+cDqzI2bhCaCnwxiJt/9rZQiUkWoloTooal1o+tLO3hbAj+ESOjhKt+FH+xsDdlVR8UPNaWfjvMUWKu93aHRKMfCaiQuY9fokyF3Hj1wKE5kN7GWDFKUeKI/nUC0RO//hpgZIxK0Bitd+gpTZ0zh2BQrSWRwpF1iUI0C/zsTFN2lwpr6OJyTL7lhjw928gix63DRxVMjHuw15GrEbpVlKfKXHJPRBKRM7J8xs82xzxfPF8KfNgx7lsg14CsVD7bBmCwaP2GKTChEsX5Cyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVF/VpYcyt0HfzIeYdYdLmTpEzicV1UL9sdIGX5pjNk=;
 b=pqTlFnH3My+g6RP6Os1JOKqqX2BmGpgEIRLlNFItu53p9cscMQSTFEWqLlqgoA3DYXicoqcasAYS6rQIzFrg+eCtu3YZ0fbRqnE0/bP4Ul/R0ylp7cH7DHKniUQVaWo0UanfEwtsG7CyLULT4C/TmcuKV02Yx12MKTIAK0v4wz8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 12:07:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 12:07:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v4 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Thread-Topic: [PATCH net v4 1/1] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Index: AQHXuZqSKFnAl2vn0E2anKGAoPgHTKvET+wA
Date:   Tue, 5 Oct 2021 12:07:29 +0000
Message-ID: <20211005120728.uquop6zj2dueqbd2@skbuf>
References: <20211005034521.534125-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20211005034521.534125-1-vee.khee.wong@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a1f41c3-1ea2-4750-1611-08d987f8b427
x-ms-traffictypediagnostic: VI1PR04MB4814:
x-microsoft-antispam-prvs: <VI1PR04MB481485CA058A830207938BECE0AF9@VI1PR04MB4814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3NCKfX0viGbffDVPwYYY50bgldItS7NkDhtg2O5R0mL8zF3h0C52tUXltA7Ysi2TF0pH1ABcn1a6fxbeoXIwqbp3EOUoUjb0tYmZ5tf2Yrluljh1pf3yCPMyXsKZ3HOgrKbYmxegmeaUTGAseag2RpkXl8DdcCsnpstpy7SNUudZWD9xfVIZC3RQMq9hglEcvWyF6Nvs+7pi++m14zLksLkB04bONgYmjHYBXxw40HXpzow/NmxRSUxI6UrFyKgQJkmuX4bW7wv84qRQO7Pz1zQvtZeg0aHgd1cWkeXlFXLdqyzqqXALDF90KExo11ZMv291YpRVcV1XjrG/6oN7+Vd7E2VNr4kIsJH52CTKRX/z9yzwMx9kUQrZBmvZreruEULYF3E0dEwJytxL5XdNWcbfyd6nQ1fgn18vDFzoU8EIL6az0fBwEW8CKUzy2kiSrZ7OXmWA7Sf3asn2uowAU0Jf9Dpn8CW/UCYH0RyC7xgVV02hRvJAZ6PmMeT/qN2/WwJh+uhXPSLdCT8D6TG4y+ngmLs9bmIrgGQZxELaMYdsQV7cNfQSS32xTdF1+Tz/beyseF+wiC03Qx5a6ZKeS0qV+JWrK7dg5HQLFJbrMIy5eV/Y0JK5hBx0wxZgi7tQnC4a3DyXewKEbX5CauX3M+/KqSIoWEkoGb03/Rx4d6kah9FWM5a+PQIjcu9xyzP4cO9ThzzaIVvzmPN9jgcWcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(66476007)(66556008)(54906003)(66446008)(5660300002)(1076003)(76116006)(8676002)(7416002)(44832011)(38100700002)(66946007)(64756008)(8936002)(508600001)(4744005)(316002)(4326008)(6512007)(122000001)(9686003)(6506007)(186003)(26005)(71200400001)(6486002)(86362001)(33716001)(38070700005)(6916009)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fSOLP1pDbl2+VHewprFviELp0reaZji3Ki7o7SOHgu2q2bwWFsBK6v/iDgJR?=
 =?us-ascii?Q?Db0buKXvIB3hCdM0c+QuS1zEO2v55ZQLz2UHQO0Qgi09u6WDtT9SZFAY8+PE?=
 =?us-ascii?Q?yhIXGSw3l3XtwYmxCVYBAyBj6EUZ93UUIGJ34mF7FQFdZQUuMKes0oARGeSr?=
 =?us-ascii?Q?/DPXQ11+HXw8ygLExFvl1RE0kIzi/nhDigjqDKmCm5YIdIBHEUPjjPLTWO6z?=
 =?us-ascii?Q?+sTIaeNmdQGFUY+i6IHZPEZk2/UWLx0Xj/ffftO05ik8q8Tg8dqyIMxfh6Hf?=
 =?us-ascii?Q?NPnbz5dMgO1Cj4t0ez2W+Yzux9n/TR5SbdtBHTt1Rmi5gHATb4kZ2ikAtVrK?=
 =?us-ascii?Q?GLXYWdiVWpvWTrxTYwtrWmC2EB8XGt9hnv8x7X0pXQC2AQsRpRGXkyuGnt3k?=
 =?us-ascii?Q?17Z04UihpmZsjBtm/x96CMn7Q/SpTEMGhMjIVy0PnewMb/LzKWkC56fgMPeE?=
 =?us-ascii?Q?T6Ytb1qajAL3j5Cgs5ZomOBERYPlu9iA7X8PTMCX1+x3Rk+TugWdjlIzYJ+w?=
 =?us-ascii?Q?MywEap/9rVzSzAz2RU8EgBQgRs7QXL605jKLc9tjRoUV4yzWyTKokPvY8LY7?=
 =?us-ascii?Q?ZdfgztnK+zNkiv11HT4UGkYxHt0C8hk+nFYLh7UwIBjoVlXIHjM11wLCDJcZ?=
 =?us-ascii?Q?eCBIKnHx27FzWs38YvdxFBqOwkrEfc6lyj10xLqgTf4lIAOh1Ikpt/CuyNUh?=
 =?us-ascii?Q?RFHxM915CMhQaMMagAQCBDtivTxfxaZOidWxlHyI0E5CYWXuTCFqQC0KQnGa?=
 =?us-ascii?Q?rZMQsukuCpD0B79VtcnwZ3lZhg2SsoawacKF8lndKM5CrfpE2QlR/hztGj0G?=
 =?us-ascii?Q?wmjNbl/HL5w7jQc1vxR3mKorBlELKyGUGMVOyLrpBc4zjX7CkY+Hd3Oq5tDE?=
 =?us-ascii?Q?KyTMa+4JpwfY+i6ObGyQNGvqyD7+uVO3Ko3xjwdubHCoY4rtiuX2LCR7dAbs?=
 =?us-ascii?Q?/oQEUHIczmyyL41TzSn74s5ZsY1qUmbNtHRjtU7GEkAysdzwzcAKvZNBqVz2?=
 =?us-ascii?Q?MPc12djZU5gX6bxlSQ4XNKUxCaCcc8QPS9m6BtV0D2BBUe6w71JTFmTfIEph?=
 =?us-ascii?Q?4eEgNfaeLZxk2H6nMPORwtwM8ucXc/cIMQ6tidMcHU0xcOwY8xU/WLW1sbGm?=
 =?us-ascii?Q?DwLU7zhtVb4z6Stdn6j5uKylzDGEstYGfIz5mqZk5iXL+eZQSMpda4K5Kk70?=
 =?us-ascii?Q?BW5s/TSvlirL7sNKTkvUgqj2L7T38JB3GbRmg9UaHWbouUF5pX7hhuyHHp/I?=
 =?us-ascii?Q?WeYEDTvhwKYRMcl/xqK5dUe+uKp0idkMtc7TAPq0VS1M7CarHpohE784QQ6w?=
 =?us-ascii?Q?/KhBtP8mCSyFATs3HF3QhbKY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F4B3F99F6E97248A4E153724A891714@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1f41c3-1ea2-4750-1611-08d987f8b427
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 12:07:29.2176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtyU24J2CRaJv+Jgn9y4xsTeIhynZ+6KREyldJX+cn19CBSbxnf03W4Ik2QwZ/9tTBGzYLFQe2np1Sf4Q19dvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 11:45:21AM +0800, Wong Vee Khee wrote:
> According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> required to disable Clause 37 auto-negotiation by programming bit-12
> (AN_ENABLE) to 0 if it is already enabled, before programming various
> fields of VR_MII_AN_CTRL registers.
>=20
> After all these programming are done, it is then required to enable
> Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
>=20
> Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE c=
ontroller")
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> v3 -> v4:
>  - Removed redunctant 'changed' variable.

s/redunctant/redundant/

> v2 -> v3:
>  - Added error handling after xpcs_write().
>  - Added 'changed' flag.
>  - Added fixes tag.
> v1 -> v2:
>  - Removed use of xpcs_modify() helper function.
>  - Add conditional check on inband auto-negotiation.
> ---=
