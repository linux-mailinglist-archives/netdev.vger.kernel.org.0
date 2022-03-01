Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024734C9112
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 18:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiCARDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbiCARDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:03:48 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80081.outbound.protection.outlook.com [40.107.8.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC59965D6;
        Tue,  1 Mar 2022 09:03:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InLDce9oZF9A9B6J6ZJJv3opYf26ncbUiNwxL+8LzVZbD8vuRRXgkGIdGi96UkiZkus0vTA1nBwqeQ4DDOtUUlROvRRQZED/28QFnGXVW80aRp9DmvuBkfV19ZeQSFLNC61KEcan2BXJak917fMnPJBJObkYrm7Zh1FexzHH99Bfi4Us9nEgy8VfhoYbyp8yXtsi+QTGdcYBA2WPvZaypS6gx9Y6yo4D5P0xTjhwPNeunU4pitGNLjTneaVMBq11LRq60WU71EeglZYpDnf66ck3TdUWMU9FBmYYbS71y3H0DEYalQeesap5JZCpP/Oq+tikK8iD5uhY8vRvZwHwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bC5gAeNdAPgDPdBXuN3McBcHll4DZ8fgk4B9Gg+41to=;
 b=iRd33HhV5gMhzFX0hljoEYg+OZ9cgJ6F3ykRYwEdif+xz+roMVIGG9PJOJco+9ZBmCjZ6G9c/C7zXKiDFIKGvWgw/YKAO36AmArtL3ccZKL5Sj1Zl2l85YurduAp6sT/C+KzCB5Ficx5AQ7XVuB2yjHH2GWVo2pLf70zSILvoxGC/Wn6g0ZYd+X587q/SvuiRkF5El4V4W21m3dYY+6m//QbhQLyPZOcoqlRQBkF+HoCiIcNOx1db0menokFCuoQhPiJg/mxD9t0+KTg8ZesNK2VxJaxE9jbxbhiK8EdJXObDYAT9UR2QtVMZCKPpHpztqVPEthWjt3D/LK9ZoS/bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC5gAeNdAPgDPdBXuN3McBcHll4DZ8fgk4B9Gg+41to=;
 b=UXBRJaLh5QeXkiBowkFoXA9YV0JHyMr40OvB1N7Bf9QopccsPVu04hX+NhrlfFK8EOMi7VpkP0VBnhvkGBkrtl0kMhfGD14ZwpPxZndfxJSDxGH+QV8vfuOO4Empb21rPmpS7K9Fi3Hy3vWieSIjpnWk9NUzAmauvZtM7vDuPwA=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 17:03:00 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 17:03:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Yeqi Fu <fufuyqqqqqq@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yongzhi Liu <lyz_cs@pku.edu.cn>
Subject: Re: [PATCH v1] dpaa2-switch: fix memory leak of
 dpaa2_switch_acl_entry_add
Thread-Topic: [PATCH v1] dpaa2-switch: fix memory leak of
 dpaa2_switch_acl_entry_add
Thread-Index: AQHYLXbrpNoj7tadT06hGmO+VilhEKyqwXqA
Date:   Tue, 1 Mar 2022 17:03:00 +0000
Message-ID: <20220301170259.zvcriwpmz2j73gyi@skbuf>
References: <a87a691a-62c2-5b42-3be8-ee1161281ad8@suse.de>
 <20220301141544.13411-1-fufuyqqqqqq@gmail.com>
In-Reply-To: <20220301141544.13411-1-fufuyqqqqqq@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7296c38-f0bc-4f83-3fd0-08d9fba5573f
x-ms-traffictypediagnostic: AS4PR04MB9507:EE_
x-microsoft-antispam-prvs: <AS4PR04MB9507ADE72E2ADE09AF4DAFD1E0029@AS4PR04MB9507.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prnUFlxBvBhRl/JEJgoPCbaIVUN0DEiNUrASKmV7fWRiklJJPlkh0DOq9Zc8MgwPapMP0bELT30P2anOJOmX0wmPk5DPeXB2vsfT9JPbukQGBfAkRoNcLCJs+VowwOSmmczcDeDkLtFTGqmFuJ7P2L/R/EpTsTQ4W39oBwKq5dcr+Q11m7Nj62/aAhGSDXW0JQ49oxcTfL2rfZMLQyWzfNFK+Dyyw1CXQDM4ELp599ESDY7FvgIW5pzuARDLeqLQuh4OWFQuZVwx5Wj+Q89iVSBxsSCI1CWAYH9RV65j89e5bVefpjPSquEZ4din7NlUkE9J2MY+24eBPghZ/lk2zB90Hyq+JVXJ6t0wTt+CRWGt5Z9O+DrfSa0O+5eZXeGnAsd9KdJYsv6mQKT89OP7X1IzBLXGaNsXw2P/2zxRtuT/JfLBFzGM3lITgidH48wqZo5ZMPOnBXkGF8ezOLFIj4sC8Ak2XWMzstJc+lHobKkA/FHnbvrqcIEbouphR7eOVsZ1cr9fe7fI/tpc7XvPslJz3hqoBmDebyALw1pMoE2OFLqHVAG+tibNDV3bye7ilBeGh5wnJUEg9akcwngvF1gubq/fimyPBmQfphjz79EBOU+dp1RoLiLHybaMNGQvyhbIWLF3dAjk8utwoNQlt+SeZMTaxasDWoWHOIDEzuysK+TPqK/lz+pLBgFtoYadtz6tQ6hBJtpbl4IwlgXuNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66446008)(66946007)(8936002)(71200400001)(4744005)(64756008)(6506007)(9686003)(66556008)(66476007)(6512007)(76116006)(91956017)(5660300002)(86362001)(1076003)(4326008)(122000001)(44832011)(8676002)(186003)(26005)(498600001)(6486002)(33716001)(2906002)(38100700002)(54906003)(38070700005)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wNKzhRrQwzBHRzV7CWLkX7b5FTo7BodIMbUN+8DKzMvwOn/qacQXE8qfZM/w?=
 =?us-ascii?Q?4mPlb+79KtRQDWbN8O5BOwyS2IVBSTpQ3+1971pk7g+D2CD/6PKgu29eksve?=
 =?us-ascii?Q?AZeprDzfYfFBmdiUKK3ae7YbCqbf3zvkhXtuZqviOVdfsOsvtqrVqYw05agg?=
 =?us-ascii?Q?jZDOCD24dhx7d+1AKukx1DsobnXKpMQTUsUkzwBoOC56EiafPipnu0/mLsN6?=
 =?us-ascii?Q?d3i3sy+UB9xj0KYnFAXkJbyMKTAOSdZickDcN/MscVSZ9+Xr9pB7WLEzkjiK?=
 =?us-ascii?Q?00NGVE/v62GNfMuJ9dWdLJr7qcLhvNhZoljKWWauiKed4DP9GbYk3dezYUN9?=
 =?us-ascii?Q?j3CaS6pofJu6wbkZp1EeX2XLeBddM2MJ/B+nxfxDiKb+Y96KTRzb1shcz9Jd?=
 =?us-ascii?Q?vVBrWBwYKvglafqwH3KVYIaOdpkDc7bQQQygVFtYiwxcgl/Mp6cb87A47tgD?=
 =?us-ascii?Q?vaQ0wlrYJPrw7pBUm3VyTgdkNd2KKWIth1lF9Nf8ZAFGh0YKLo6l+IeGGp+J?=
 =?us-ascii?Q?wjpoYF2TLKJQWOrMnnFNWJQyzhL48TNDZzN9/BXwBan5sRZjdi1fQOT1swpZ?=
 =?us-ascii?Q?Iic/dysX50qcfSwcOGzeX95Uswa22h6T+CHQUuU/H6FN3gwnbjHU2ONE6LAp?=
 =?us-ascii?Q?S8TcGURy5WIMGGdJWS+tkIgbk4neoHWPmscJLXFoWyulFiupvw6uwGJhQGGq?=
 =?us-ascii?Q?5C4LI2vMMEJiIg5IhEZw2Afk1XQs7mVf5eEggs9kEPEyqnkfo75d7TP9fOTv?=
 =?us-ascii?Q?7iyKlYXMKylcY0JUDn5Ih3PPL6bQ5gZWRzXdv2/m/98XhIXy5YxkD3VLPaGe?=
 =?us-ascii?Q?wVoxTFS06NCHl4wxuVbcp4Cm7Sil2K0FWu4nE15MVOfNlVLIKw/S8HMifpcg?=
 =?us-ascii?Q?4lVBMjRlkwl9x0zkcqU/kXUSXE3TybPJe6KyFSaApZKWg8aWtJ96bmbOnucM?=
 =?us-ascii?Q?+Tuk30v06ZquxdvLjpg4UUHD//Qtfe5RC0odPSj3DNFkPeIXDycU3/OWkmut?=
 =?us-ascii?Q?9QAguSDmolwboZl0o3Bm5+hwtaqDJnRH1K+SxLOBVn58IzI2XK4Z+I8mLE7l?=
 =?us-ascii?Q?bXoZV1t37yV8H1CD2aYttSYbutfE3nqNoEP64s2FwETG6hs/h0iQVvttbJG0?=
 =?us-ascii?Q?pmyU0Q65Q9uUcG24k+d3qtrF7ADEj6EhJhlBbEC5aq4Uj1L4+I1ZwbzXRK/J?=
 =?us-ascii?Q?pgLsuvbuAiG93ksquCmyhOEYHfvpqdcq4LMg3nZJKl58knEQWY3fuPxMI4LN?=
 =?us-ascii?Q?Cv8FvdB+M+vF/IOtGmkJw/JfROhxyZW2zqYVnO+p9PEkHuENjb2nf7kXYamD?=
 =?us-ascii?Q?OYdSjhF95laLQt/SnsXkKt98YThPLT3FfaZCyvEzdrS/vXIH4kJbO5NPtQkk?=
 =?us-ascii?Q?ZDFmMdOfzoGDCpH2c7PYrzmWxnOqo6ounePj7l98UohFbEosM5feJkOpCH3Y?=
 =?us-ascii?Q?Rqtgb1FAv2O+txnIhoPBngtORv0N/+ZT3p1GTaCDmfcxubiVxpnLaqUqYmVz?=
 =?us-ascii?Q?xndAFnTZ8OYur+WwcVo1WStlm+jRXW6Lxo3G+M4hplKFzS/V2FSelOve4Gm0?=
 =?us-ascii?Q?uxZVtrv2I1znDPCaLIwwS4u9Sa6fyyrzeMy30MtbVuB7pkyJ8aCoBIZomjZT?=
 =?us-ascii?Q?zO3XSTfedE2wbvZmchJm4mY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B40B3B38ADC14488D46113D484578FB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7296c38-f0bc-4f83-3fd0-08d9fba5573f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 17:03:00.0480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZwLLeDliIcCTbYeIwAnctfVWh9BfBwnGQLWsxWzgq4Xp90vAxZrno/k1JjTaL7oeiOmnX+QnZkwtsyrd7XzFfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 10:15:44PM +0800, Yeqi Fu wrote:
> The error handling branch did not properly free the memory of cmd_buf
> before return, which would cause memory leak. So fix this by adding
> kfree to the error handling branch.
>=20
> Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ing=
ress traffic")
> Signed-off-by: Yeqi Fu <fufuyqqqqqq@gmail.com>
> Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Just as a note, this should have been [PATCH v2] and not v1.

Ioana=
