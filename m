Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED546DF57
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbhLIASM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:18:12 -0500
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:18017
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238337AbhLIASL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 19:18:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE2Vp/hHLYSh4z7bAPzTechQIh3r++D7RBiOkqA9ECGL4lT2gUrYlOvwEuPQfLt+qxwo7v54bLk3x9TYnk8Qu5aivcuWaZ467Ievki3BsZaZKrYsOjx2TBpt8WueZ4nsi6MiFhDEt8JFnb7sv09Y9HkiXwVk3Igs+1qKKByoYrMWWaglRgQUFWrcb0vDnSZNn1tRk6XkL1UJxFyq+U3nuJabIoOSAcBYt9wXV2QVDEGd9nraxt56ScY1e8+J0yrns/eph9DuvxHpJqWz064TmaihA1WgvPoaLUtgldMGpqn73NmtXbm8/zgEK5Xs/4q7YJMtOxSxtTBcw6q59j/uxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxPiiLfnCAd2yhNDdZO9WGC+hRB9EeXbOPoWVUuCOxo=;
 b=nrmohEVgRKlzbSjt5OBbFZmR/psUIGJAbWmWykAst9iisGWBG9kaJc1O7GlWBavHwM2uvAEab4MOeEyeG99qcySOqDaDOe2k0ERHCqFIcp02Blvho3aKI8tJGjKhI7N93yNN7okeTOz97EcVLvlfaBc2ToU0A/Ofp/fcG9fek4F12yoHZiZdxbxzBeIUi0HoGvhVXgSIbaAaNNuarnz0mqLfFM3AZY+1dyHsQw22LNv527YCovGApbyX8f1R0WxyBif04mHpZBFaqq4OVEYtZU6iJD2Cfnzc6jtzZEvaCWIsdG2qPsLyKVPXX2GNHFgTtU5OV0txspj3Kn/Q5Jtotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxPiiLfnCAd2yhNDdZO9WGC+hRB9EeXbOPoWVUuCOxo=;
 b=KDx0Jk6KboOM+7XhX4Q73u/QidCCkjH56NofriBIapsBTupHyoJm4aT4ZCFBkMdLR1bWvILSy4O2xc7LsyEpjJjYkZBuZU/dBdg9GJPwaZABZo6cywsSgXBEtFgL4eIIDT088a0uRZfrhED+K1HL2Xur3P3/uSccNaGvJxa2YyI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 00:14:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 00:14:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "martin.kaistra@linutronix.de" <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next 05/11] net: dsa: sja1105: remove hwts_tx_en from
 tagger data
Thread-Topic: [PATCH net-next 05/11] net: dsa: sja1105: remove hwts_tx_en from
 tagger data
Thread-Index: AQHX7G7/PnaODVfRrUmkutWWLhy7ZKwpSlAAgAAAUIA=
Date:   Thu, 9 Dec 2021 00:14:35 +0000
Message-ID: <20211209001435.je6ryut7mow75mok@skbuf>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
 <20211208200504.3136642-6-vladimir.oltean@nxp.com>
 <20211208161328.466a3cba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208161328.466a3cba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5195380f-ddf6-443a-ca45-08d9baa8e21e
x-ms-traffictypediagnostic: VE1PR04MB6638:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VE1PR04MB6638EEC7CF9B675FC20A3A81E0709@VE1PR04MB6638.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jisz4RcnSA6rXUux7AMTh6Se3+mmGiIo49sF/UBt4hzHshgTB+V0s/fE6uVD2LUpJsQVEr59rP3K044JbVEeIv9ONHAsR9wWWWKoDGBA38FDBCBXkVOKd0j2fjprdjYZl5TSdqHtywgsmiplwWLzKqDSnfFZmiSDUWGxdK6BCwikuynDMgbahp6DRExLB4NofgGgQ+nfFrmbSHUSN38k+NY0s1fE8WLf9DQMJ4JlomAFFW714p+tBcVxBD/s3EFJa82BoaFog0gO/FY6pQEj2YTdMDxfVie7PT8zu2El3ghbC2So4+8NmMjZvIL3eRqIZb1QecY46zwgWOHTYXjePL2QlbmFSrIK50jM7Tq3PR/VFWqbADk3YWRE3x6Td9pOzbmec9NCBEBDS3hfCGg6zHcFCgSurc9aXsc7rWBH1wM8O7LeoeexeKkhVExiey1t7gS6zO5CwogQRrIPSK4+mChJmQZY0ND1pIaZ+3kpQP+XrLpiTx4i2ousQy1szmG95R/dFk25utzBrJdFcLATGZRe8jJCrr6T11N+/boc3dFMJQS/lR59xsGIIOOa0ofNT0warqOmH6EJ2pDFKpwU6yA1A8R3d5qig2PtkRCslyvYN1SxOBuvwga1lsL+4UJxXFmLzOyWvn7+ul4e5gll+YBiw8TvgoMu3cSuHG7p1A6a/Sot+iQy8MeoRXQotUJmXyq/C8rWDXognYnIWTsc+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(26005)(316002)(4744005)(508600001)(7416002)(54906003)(122000001)(8676002)(5660300002)(38100700002)(44832011)(4326008)(9686003)(6916009)(8936002)(6506007)(6512007)(6486002)(64756008)(66946007)(186003)(2906002)(86362001)(71200400001)(1076003)(66556008)(76116006)(91956017)(66446008)(38070700005)(33716001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/5l/+lJWnDdNLE+02pqEMwcp4fCr5GPJDAtBEZ5H7ANlpfYTqEbgrOy5B06u?=
 =?us-ascii?Q?C8mz/mMicPGWIVS5ZuKeYc9PVArG8uVaFe80y41gVBkw8a7MgIiWlhRalnEp?=
 =?us-ascii?Q?vOR8DTWsM3E6HcJRl/+D8TxuqpCIAB+Scbj07I8mweY82Ryxf3ka2PfoNZFh?=
 =?us-ascii?Q?mznCQmPiNwg5Y84NZF2SuDKgjxvhxAoylqIxMmPfESy5naEPEEzQrm3b8f4I?=
 =?us-ascii?Q?IJH9gOOqK3Dv3vnPSTvmHC8pYrzNDP+VF+f4LeK/VwHmdAws6y03XpPIhCjR?=
 =?us-ascii?Q?ZcNWv6abQ061Zt6qkrCmk/8+ILnLzGvDrzLY16lrke/4OA7XE6iAS7o7qYZx?=
 =?us-ascii?Q?eXPpqCaTIdHTfCWh9o68t3FEXNy9z7gdr+Fl9/PJmugUKOElUbc4iJm49k4a?=
 =?us-ascii?Q?9rJc4Bazsw5bLXy5Ef2nASwLfx4470VUV22YnudyoVhbJh/Os+mOY9euWy0F?=
 =?us-ascii?Q?//3itDzoMtfQk0mWJVwekA9Mz+7DeaRxAnqUDmgxcEh/HEuqN7e/p3nZr66W?=
 =?us-ascii?Q?efvqg583Z8C/Yq/FqE7huHGRWZxxD5IuPiqG+1sUl4qw9+pOCyuoLfIsSJ4t?=
 =?us-ascii?Q?5uTkQwob+c3WdkLOrVI9V0IXdD7pv6GfxAyspv0wcealJscunaFjK7mHUrPm?=
 =?us-ascii?Q?h8PWdeeVM3F8ewHlWifOTlJ1/2L/xIvS85CiggUIm+973dzJZfm1Q8Ri7gN4?=
 =?us-ascii?Q?vJpf7TkESLHf09HUrd2fYgLj/ijCaS2Lcc5vztU/sLq/f8eRHn+D5I/2wYSW?=
 =?us-ascii?Q?2Kk4P37XQhTHMkmAKzLVuLTYfLdIGjM+WIeoCZMeg4FYInJ2Ehfy/B9F0EFt?=
 =?us-ascii?Q?CosamUqViCfSKqxTPfoQOMMYv0jFjdAdTxV0QlWYT00zNgqIb0bf6gFSeePD?=
 =?us-ascii?Q?lm4eu62Dc8sjKRq9jLRUlz0Yl19Njt+PYe/4tP5TXojPIgtHNhlzJRxN9e6I?=
 =?us-ascii?Q?FanV5ryzKmkvfKYdKR1ODP10wdV6bal5P+Q4K9v44PgLfoOxBKM7i84ZO9cl?=
 =?us-ascii?Q?eyh4OqT/E/XOZRcWaB176WINp5ysqv+NdGLS3HeHhyG38gOVgaI5bXozUi4e?=
 =?us-ascii?Q?GRrla8Q5559Bnzl2GN2tIf9Gnmii24jpSFM1VkNQjjSFiuYtqZaRsP5P+pEe?=
 =?us-ascii?Q?BvkxmSR+yB/MP0DGKxNfZBdraIBwDUnFKDemHw3Gc+LeSLCQ5+WxLKlqkvVs?=
 =?us-ascii?Q?YLk9Evdc3IbYt6vO4gZk7Bz0bPEMqsiTYFd64J9OhMHJCO5bLBbN4p6d5TEg?=
 =?us-ascii?Q?ZkWs/fcOODOtulEK95qd/Gi6OSzPMjVdCrFOaZR3ui0qV44cMRQ86cVkuCyh?=
 =?us-ascii?Q?53V1ajca2nAiR3lLbJXlHt3c4GwJAqNnr6//DTD6E3ctc9L4cAid3bCRXw6q?=
 =?us-ascii?Q?fwNrkclh9hIGOUVPVZGhbpCg6XuVxabw1/G6neR5reVoC7CpwrMQsM6Ss1cM?=
 =?us-ascii?Q?taqTBfnOat727rjwRnDSML5d0JveZOFUbsJ2Qk9BJLGl9p6C/gT/Gp1dQKlY?=
 =?us-ascii?Q?hjsVSqDwO3//Stae3oryAUZ5AoufH//eBnIuypds3/BPRFhY3pYs7PBrGiJe?=
 =?us-ascii?Q?j/ix5Xxrjtm7Suao5XZ/hf9YSEyn9VC/VNsoRwU/NK3nhnItpA2yXuHH6yYQ?=
 =?us-ascii?Q?4R63hoRGcmSB7hgocL/1qD8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2F55C23500FD184CA79C5ADAFAD644E2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5195380f-ddf6-443a-ca45-08d9baa8e21e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 00:14:35.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6pArcetBuUKxZN8GhW/gTF/Jm4k6ZZXw66DN3X4/KRCALXBXHrFBSiWbwpIcyfzSduWn4WVOy1UXQ7Ulquorg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:13:28PM -0800, Jakub Kicinski wrote:
> On Wed,  8 Dec 2021 22:04:58 +0200 Vladimir Oltean wrote:
> > This tagger property is in fact not used at all by the tagger, only by
> > the switch driver. Therefore it makes sense to be moved to
> > sja1105_private.
>=20
> This one transiently breaks build.

I was just looking at it how it does exactly that and was wondering
whether I should resend or not.=
