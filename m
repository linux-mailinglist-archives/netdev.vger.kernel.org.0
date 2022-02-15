Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483BB4B6B83
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbiBOLvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:51:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiBOLvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:51:31 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4789307;
        Tue, 15 Feb 2022 03:51:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkS537Bwaex2wQb1to21PnEt1xVVYyQZ4mTeXZj5d5GfwCFm+0zzyQw6wKzCyqSOhnM0d+qSxBMdyVh4r0D9DazwuvxXnzi6o3v6xQTjX9U23MSWRa1kbAMuKLGmCr4i6bWYvDEABNXUBB5rtRHTObx7wpHgW8naq4R/dRLF7/w8297R71L6p36Aar9Wt1j8BOz/2hLUL5glp/YLjewbfoHv7n+NU+AlH+Q+4s6onQtTBnjBTslsO33w6dFtVACiblhbpbDle4aFuvTurSEScBmzH5UV+UJgx0/6rO+CDij1rDoC7Nldtev+coU0lE5S3u/wu1CJQLfsOAy42ahWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BOOJgIZOLBd+ek16E1YPVTpg1WVe2HP+ySsoJBlSVk=;
 b=fZ+JaHxSJ0pvYKqWWTfvOgCfpgpnGGC+E1ZEzHM9pTnPxYuwi5gY4o7RS9l1Ys9131cVn9eS9ZRuk0QJaj1CtrC5c/zxNV9JP4bg5MXsrRSxddjlRo8tILbXeTYNKL2w6wx4P3EPWzaA37P9x034iHoea67iCmRK/7vJX5sxYjKWo8kKh5K0JKy4Gma9Ir+oqWR4oWoUHJP2cbRAVnAZuk86QTcQhVV5kSCPh0yICErlZ2eXNX/ormu6bFnchP72HdZrxHFCiatlKKSNUXWUgbrMj4vqp8HYJdq1xhSkckwve0w20Cm/4raUftcjz+Vxgo1oaUbkIwnPaa4vZS0Rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BOOJgIZOLBd+ek16E1YPVTpg1WVe2HP+ySsoJBlSVk=;
 b=qRMR79lpCNsXAlydC0e0mLUWxs+PcegrYCT3EirML+WI2ixlRWEcQZyntk0fkdvOn8SKhnaaSrRiUc7co7EXWkSwaGA3LDRRp1GmCxnCkmJ7z+A6VQBzAeODYLRB+UQdyzTUCoXmUxYfs33PMccdYjIDu4B+Y97IEWwD1v/e5JI=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM5PR0402MB2705.eurprd04.prod.outlook.com (2603:10a6:203:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 15 Feb
 2022 11:51:18 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%8]) with mapi id 15.20.4995.014; Tue, 15 Feb 2022
 11:51:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "trix@redhat.com" <trix@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: Re: [PATCH] dpaa2-switch: fix default return of
 dpaa2_switch_flower_parse_mirror_key
Thread-Topic: [PATCH] dpaa2-switch: fix default return of
 dpaa2_switch_flower_parse_mirror_key
Thread-Index: AQHYIblgcwa2mr3+1UqnRzNxN8McnayUgTuA
Date:   Tue, 15 Feb 2022 11:51:18 +0000
Message-ID: <20220215115117.zz56xxvymbntumvi@skbuf>
References: <20220214154139.2891275-1-trix@redhat.com>
In-Reply-To: <20220214154139.2891275-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41573e99-fb4c-4fa6-a623-08d9f0797a9b
x-ms-traffictypediagnostic: AM5PR0402MB2705:EE_
x-microsoft-antispam-prvs: <AM5PR0402MB2705738706EEBD046515AF74E0349@AM5PR0402MB2705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:260;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OVbUqGgZVCRL8cz3qTI9pv/EypJ+VK5l+N3F9igduz/g/ZlFIiYzU1pwCKm6f+4FFs7++xobsSruaD9AvRrO7h6xBWNFTPHhwxdemJpZsglAot34s9DmvlAceFasNM+SDG6oE3gw+bAE/TSuvvrwnoRukqTdIQbOqDgj66RSsy9JQCw7MCmlIQpIX3Xqx09h6GLpv+3YxY0YeqYr+q5adG7FaKfiV4yvDHrULWDre9wICQCP2RLSevk1uqkcv7cER8h4lQiDw4DZv6YluMsp9mhELZyV8r1vyPoszaT1nN/+S71VHwwiEvhQKowdW4BiEqu+TdP07uWqrqUAoXwyn1jdSRQj3Ly3N0DqiCEJTigM7g2mXU2eeYbHzJSkgiJBFaJhhrGDbEV2StHg+PEGJNNyfWXjU6eBERU2u4u4gcn2mH8o+vCC/X1euXM1NKdXs/fERzaCSSAgvjI3QfEUQt6TGXrYP6DsMDDa2emWmfMuzlo/lHVxQUPL8plnZDfmmiJ05jjHFQEBpATepgts+5tHlWulhuAN2AJ59b5gyn54+gVPRqBOi5op21Bpmadb8QL5NkB/bWHwvduv8QbrHLDpu59uNNyX9+8hT4vmHjy0Z0PernSGwfU70bkNqHvWpsd/0OYpU5Ua7xDtIR2tRCp/2IoYsxsnrzr5EVocJFej+7V4E+AjkGa8Da4cNkyN2AtG7iF+HFe3hBXdvGFAOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(76116006)(91956017)(38100700002)(122000001)(8676002)(6486002)(8936002)(5660300002)(44832011)(83380400001)(66556008)(4326008)(86362001)(66946007)(508600001)(316002)(71200400001)(38070700005)(33716001)(26005)(6512007)(9686003)(186003)(64756008)(6506007)(1076003)(2906002)(54906003)(4744005)(6916009)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K5BgCHSqii7a34O2ZePzS08Sr/dMHtbSzwB7GANFMCcAG3MNnslXHTSd9lqo?=
 =?us-ascii?Q?MNBDx/XBD24l3/1szYOarLwc5Tk14lluj1Yms6CAiFKY+1mVUi30CyFYSfTf?=
 =?us-ascii?Q?kEb2iL/zVA8isqK1iJPhXMjXVY8jOA7HDdb1sfJPKsOdSa89YW3uKCcZFNA0?=
 =?us-ascii?Q?JFfIbyuNrKCK0VeC1slQs5c8Db/o5NVYB4XTpBCowmjtrwFdX1mC4OkTR3Bh?=
 =?us-ascii?Q?hwL29EqcNh6QSig5TGSBoKEnYJqgExmydY9da7aT593Ce2g0FxkpkQYs0eMk?=
 =?us-ascii?Q?HQLO+Fli1q77d1azK0ZnTv+mDVpLpuQoN5YBp777yUh2ROOp8Pk3hb8xtX/O?=
 =?us-ascii?Q?ThLPeuzX0pns8K90IC/q4TsTmWPyFBEu/V+OERIznnAoNQiwdKX+8suZIcrc?=
 =?us-ascii?Q?IODvcj7IPsubBdLbOoN/0IyzQ9DfdmwLkm7L4pfKac9N92b3yDSeZgefuzMF?=
 =?us-ascii?Q?T7VRPBLiYqVZPeKhnmdzp7OOpEX07NtTVz/3EK5jnwopPXf/2JXVfG2/g07t?=
 =?us-ascii?Q?4eoRbT/tzs8IP+TY8CT/kOUzk1nWWGZWQvEn6A9ELH6gDzxHB3d2/68Mdp7Y?=
 =?us-ascii?Q?TWj8WLkUBYsG/QNsXtmi3lbcIot7ccQFTQrWJOxWI1jivNtF5DdaKR1vRsan?=
 =?us-ascii?Q?SzPuztx/L11VBxfkzTW2wx0KJqveDxndZWGeSAdgJNF/Ge4GT9LjCV26Jy8h?=
 =?us-ascii?Q?hYY2jRp5bRM7eNB/LgD1QLVbI8rLbCnWByJ6yk5ti0rWlw62tIILpcDeA+DE?=
 =?us-ascii?Q?uwUCrWNnVBihzTqdzx/T6oxTLjFJ5lFx/M0+AcAunb3K5wknNPK6K8TCepll?=
 =?us-ascii?Q?DU8uoUxPcJVYpZGx13unt6zOngL+yfR2+NNK0YEeSxHMCt+v8f8MuWjMuu7F?=
 =?us-ascii?Q?YH01p4UzNFdXY/kYPRcbL2K5m7tnEJThQU6x9mQGwTFuWdbIJOTJzA52Xz9T?=
 =?us-ascii?Q?+n8lFfLD8rDfOP7Y8yTVMp8uRumJdsk3aBuKazrMqiQUHxd8FZYLbb6lP9Ub?=
 =?us-ascii?Q?vfmQoXgvpB72fp8xRUm83UDMO5aICo4+42n3BkRmMsJE/onO2uHyVYsbnorZ?=
 =?us-ascii?Q?3kh2Zh77lrZvQ18/g4CIcew9ANn8tSO/lVGhjXQH1MZmsZDu99hlNgUA66tL?=
 =?us-ascii?Q?nk+ZWgozUbNrQdz7Pr4HT50uqykgNTrP6L3C85yEj6bwTl304MGr8AcGHCER?=
 =?us-ascii?Q?Li2eX/QntnilOHP2ZFHNwlopBhEz4PTMRAaBB70l5Gy42paLZ3/z+4LNwrsB?=
 =?us-ascii?Q?BNOWEsGoXdqRYRne36YhYvOOFuUoLagCF8kHJSSlQk13xZDhA7P47/2vk/mj?=
 =?us-ascii?Q?nafl9vSFVKd+qGKIvrnvmqusGxHnAw2jhQSPfJc4pRandOcnjHDL6Ww2HBdE?=
 =?us-ascii?Q?xISi0cgq3dB3njTqhFdYIabRuYT7vXZAZxjrKa6sngUzMAqx/ZP57IYHUH5e?=
 =?us-ascii?Q?UtlXI5R72Iso1fgAEcwkoPxAWTDuD81HhTsuoJ14NCyAHtWWLm9HnPLHFLXQ?=
 =?us-ascii?Q?1oNXlDwUe3xpSCgr4U/JVAfh5e7QpqCIoU/YioUuTuH2JOExaCcEmO48oLtD?=
 =?us-ascii?Q?gKzAyncKyTSoJpDixjLqgML4hhTfVgcK2NT0Tx0RjDooir1MEKTLrx8KfIzJ?=
 =?us-ascii?Q?l+FLbRu+HE7KcvPEeo0yZ0w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89082DB9BEA00E499CFD3141C238E8F3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41573e99-fb4c-4fa6-a623-08d9f0797a9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 11:51:18.7428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrulDJF++XEXZtUHGe8rkRjjI20hkfViyS37bsOYwIo126aXjOE2G6ZOsGWAdW/2MRSHTLFfs1fyPbxtLOI8FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2705
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 07:41:39AM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this representative problem
> dpaa2-switch-flower.c:616:24: warning: The right operand of '=3D=3D'
>   is a garbage value
>   tmp->cfg.vlan_id =3D=3D vlan) {
>                    ^  ~~~~
> vlan is set in dpaa2_switch_flower_parse_mirror_key(). However
> this function can return success without setting vlan.  So
> change the default return to -EOPNOTSUPP.
>=20
> Fixes: 0f3faece5808 ("dpaa2-switch: add VLAN based mirroring")
> Signed-off-by: Tom Rix <trix@redhat.com>


Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks!
