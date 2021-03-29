Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD2434D1E0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhC2Nxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:53:36 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:52960
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231825AbhC2NxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 09:53:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KydMdasuX8oPGCj0A21QBq1RWY1wd6hFheogEXKtsFBE71+Ruwi8WHMyWQkYxlgJJXaISdSHSKBLA/BzgyJowh8YXV9zz2xn1NxaXQqDafRNsouQfdddV+gUyNTS/xyNDqvpdvz77+1nyuw+X48NFEeM/3oG5U4Ff517ksH/JdfZPotv5VKYOphibPnr0PGp+fXTbrVDuxmWOzKIjFmkaf3/wwGFOTU2+OL/o1km1SscBO56MNomyR3N0ZKe8hScijhUyE5UXf5sITXRpgz40vyj1r8g3V7RYorfHgWbz2qWdGwOrY6dNzsgtz3GZXvweXxlSwbZIQRjVZwSSyzyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaL0H+mHCYOMIDKL+IXLpy38v7FIKLmcBd1urtWD5DE=;
 b=imlutELRXKk62rylqz/KwZyxSdJKz3MXVNpojxuSzuRgpJEDNXNy/QK384XtqfcWSIJuPwD5O9v3AHPB5e8vu8j7Z5SPrmGVqzaU2iiIHsW1GYlukkC/EbUDm+KXuUyxhl+qoctqu4UpbtcmbRTkzLxq/xD4NGLxVoyV9bS1eql16zn2RQxFfjmqCclVcacuvmTGJHgFFxbm9fCEv0xN1dK8wZ0DLeKZL/863unNkMXHUiPQC5ju303zjDoCHbZpjfDGY6fWO26qOu+O7y4lgsETZSWQiLNd4p/lFj62hryuPJoThwkoHr0Qm923TxGehM1AEFC8AFYmhzMXz+H++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaL0H+mHCYOMIDKL+IXLpy38v7FIKLmcBd1urtWD5DE=;
 b=jG/YqbSx4pF2ocGeGVZA6Kf7bDkPW/LRrUkjeh31zNHZefBWKJ9yIbM8ORUjfPyOMtpQPZWeUmXfNjO0ddj3E0gUvfnvQ6fgZZwNCM8Mt6Ye8ZGYy1zcMFtdt4FP3TOnUCjDh4LzfWa4WtSxL29xq/p78H+vTl/oALj/ZtMrp4s=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM4PR0401MB2257.eurprd04.prod.outlook.com (2603:10a6:200:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Mon, 29 Mar
 2021 13:53:09 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:53:09 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net] enetc: Avoid implicit sign extension
Thread-Topic: [PATCH net] enetc: Avoid implicit sign extension
Thread-Index: AQHXJKBq1N3VhqNiJEOjzL49xj3ILKqa++aA
Date:   Mon, 29 Mar 2021 13:53:09 +0000
Message-ID: <AM0PR04MB6754BD655B05D9F5B66BC6C1967E9@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210329133528.22884-1-claudiu.manoil@nxp.com>
In-Reply-To: <20210329133528.22884-1-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.216.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5b470ed8-4ba5-44fb-224d-08d8f2b9fca5
x-ms-traffictypediagnostic: AM4PR0401MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0401MB2257CC3E69F8B8E2BED49D56967E9@AM4PR0401MB2257.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UqpTHZnywnHJheQ5IF41GnpHnDrsaVFMjVjtXrcMlSmq9ZSGuPFb7STF53A3D4e2zfAV2mFkIxHKLlx0yh8Blf6z6VY+34KGbzj0ou7rLSwXF9t90/BnCX7Mp4SeL1CKKeCF83b751p+KfxjwM3SeJVNv3XOdg5CE8GUje/0u+Aj2CKPYkBs6pRkdIhToc8BZI5PA55CExlkFA/LM40zmM6mpq0xxPqbbICyk6X6pGnOvQyMuL3kHLIRbI8rtyTFtbbYuv8lzYweOk49BBFLTNdCeFBGTRCnEK6GnqgYnLRzVE0zIJ+sxrPGOM8ISqCYEoKgq5EB3s3CnCRNeFIfKvjGqHNADM5lrNxLFTpvl+W1Y+p4Z5XwFNUfXKmPDpWYLjrK1kChpuyJuCCwSCm4FHCmHAu5++cFmxPCDetENIqoTJJqvP3xWHvR2BN4XACVuN4hJb3WE0anKwRJONVcimThALIshkf1CRA7d0Hmt/bKzUB0mpOWfYJA75XxJ29IFZhw/cL/ojAoXKw6qIQ4zZg5EOjoSYRMA2ITELMzbeEz1u46XEQcS22L7cSBiqN7l7J8J1pNyk+Fpnfj8kWWAKzpAu0sutNdnPvOcoQqOQ1guATgKh0bmp2qNDOQ2qmq4+7eAn1gF5KFshLFf7+PSTV+cjajkmxFROK+qWnNCCY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39850400004)(136003)(346002)(64756008)(66556008)(66476007)(52536014)(76116006)(66946007)(66446008)(33656002)(6916009)(4744005)(38100700001)(54906003)(478600001)(55016002)(9686003)(83380400001)(8936002)(86362001)(8676002)(44832011)(4326008)(2906002)(26005)(7696005)(71200400001)(5660300002)(316002)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?u2LROddJNkVdyArYvMnVdwwYoXGtry+hD5rji5nW/QBTGiwpw9F9s+Fa9DOH?=
 =?us-ascii?Q?HZ9i5HbF9+KTxV7unrdZcS5Daj7sRhM4rpg0GWU/6Clz6qqF880esA99JiY0?=
 =?us-ascii?Q?8n2U/j8gSxd2o9UDvsuKQfnMxtgE8abIXdc3HAF6U1NmTrWwpjrC5D+T12fx?=
 =?us-ascii?Q?TprsJFzv5hkdhEL1lmMQ5+tNoxV7PMht++7+zIFoZwb8u9/Kjo9waSj4Hfeu?=
 =?us-ascii?Q?QfVqnpXe4Hyvi0rsPgPB1jOO30PWXmrknUodz3VYOSrwbGOj1nIb2otd+Wj/?=
 =?us-ascii?Q?sNI1O1o01sqq6FkXmtbG2P1L63t/YXC2VLZFhHIeeFoT2eWoC72MyZuRwmWi?=
 =?us-ascii?Q?VZEDLcy52jfLECBTkVe9ox/VyIs4rWdCwQ9y2V8KocPJo2b4MyaW+wHwE8Qq?=
 =?us-ascii?Q?fY+2nHDwndeasl1pDz2QJcl5j5IvOaWUwK9jnZ45Ls1zz1mSy/ltAUMWnriF?=
 =?us-ascii?Q?O3r7P0s69arBpl6PgkSoLTWxkG/MhfTfZee6RtwDtVS+Xx71idWdrRg1iKwa?=
 =?us-ascii?Q?mDgKF3bZULXZG4vPwk+DWOdDTLr1W3ffGLHIHfMXicL/fh4AAUNwdp1CoHIM?=
 =?us-ascii?Q?WvNyw7BLNHKH/OgNPzMhcnUoY1CXdnVyqSLRKfHWWrhbzAxg3glmeLszFCo5?=
 =?us-ascii?Q?P6jqoeEO5M3gp+1j8KwM05mG4emCXD6gqiQVhyDsKVlV2Xdee7StmTKLISe8?=
 =?us-ascii?Q?E0bnpbypQptJ+dXx+jrFzCEeKR5J2Ln6JiKv/yAbGetXlskZQRDdi+naAnkf?=
 =?us-ascii?Q?EcWuySB4lfc5ywrlph7fb+oqabco5v6YlEPSqXkR+DTTTBkqB6ruqBOXuw7S?=
 =?us-ascii?Q?xKSvyxD9gn9QQpUjonKCgF53MFAuneuHF3DS8+oTT2RoYswCa4MU7J/4+yvo?=
 =?us-ascii?Q?V1dIZKLD78GfYJnMOzXKjetvV8WlUDlVVW1ESWh++vtoEyZinIY68N/DgXGg?=
 =?us-ascii?Q?CE4+IFQtxIjrrx1TJeSq9aD/0Sf206oFPtDQhPbV683uBD+YjBFQr0ghFvmg?=
 =?us-ascii?Q?pWt91EKx4Oon+SlXw3qFl2DsIpdoRLO9fycD30yvJtSIvxzUHUE2orihWi40?=
 =?us-ascii?Q?9/E9TLtjIKiS2QSo68jnha79BZsqzG6SbKgcPDMieBwtsQZd1mK2d3nn5xK/?=
 =?us-ascii?Q?2lQjEV0q6Wf3sEeJmgZbCTu6qj/fvfxO0cPpGp4maWq5zoRD1T9EoMSh5ub7?=
 =?us-ascii?Q?8TaMzzdPE/VxBdimdv78cXfUGIHsDUdfybf5EcG6q9XKLf7A618zTi/Cb1+/?=
 =?us-ascii?Q?sZelgw9ltKEGarW+Ju4sySigZ1mtCTCXcFYg/nMIaC6f2gV2hLljC+qLjj+R?=
 =?us-ascii?Q?HyA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b470ed8-4ba5-44fb-224d-08d8f2b9fca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 13:53:09.3328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4GgqrnnpMTClevs3ynPxFjGZPXsWytUvWjBfYPYfw6qHE7VCPXzTnd9Ahsc87xT7d6ue+awoZcKHVeXVVq2MZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2257
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Claudiu Manoil <claudiu.manoil@nxp.com>
>Sent: Monday, March 29, 2021 4:35 PM
>To: netdev@vger.kernel.org
>Cc: Jakub Kicinski <kuba@kernel.org>; David S . Miller
><davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>
>Subject: [PATCH net] enetc: Avoid implicit sign extension
>
>Static analysis tool reports:
>"Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
>unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
>then sign-extended to type unsigned long long (64 bits, unsigned).
>If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result
>will all be 1."
>
>Use lower_32_bits() to avoid this scenario.
>

Fixes: 82728b91f124 ("enetc: Remove Tx checksumming offload code")
