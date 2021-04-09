Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B018359F03
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhDIMq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:46:26 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:20001
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231127AbhDIMqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOTzMXr5hoxb8lfRqO3raed1FsIfQ5TbTQM5B8ffx01qZ2ALSjes5K4HPdmrBME72NxYexbW04yj7Jni4/e64u5bTs3bdLdOWtKMuF006Z06ObEIC38V/JZicxj8p1jvDM36xoShblLpoF/21Pv0OARcDWhwKJc87TrKo+TqtFjimoxpNb9Bv1wBLE6iiWvQslHET/WqHg/GdxWIRvW/s9aQ4X6uCTH6aqCzJfmezGXaq0uXfurK5whUqxWuNtWwMvo9KVURnVPhL8rYegrfDKztXaZuF1WLapmq1naL6uI/lTZy6w4cKoKOSr5WeN2sLOJSVe6/ebFTAYv+LDfIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7kX7H4bSg0LdmAX2ESWgSTbqqnejNMJESOyhoERrPo=;
 b=ROnulZw7PlwnP/iXiU7LBBvsgqrRqOYiBLfEkRBYoqn2KbgcaZHbg+DjugIZikbbEFn/6WWojmEd0hJiNFYapR9AsPItDY+qysl1A6uy+nKx1StCVoGjWcnVYWnufbgdADzK+WBlZ/9Rg3fxzJk0mSDiJM3eItj2SDDFMxVwSMeFEFrCHq1kcy4A7z4Gz8bbZ94Ks5seIDO2NRptAtuCWnmpYeMVUdzpiBXYdsVs+IduHsJ7WSBn1sYjHdSHc9hyhCnBOybiG7BfkHg9lg2idIcC9k6boS2SJy1Mt9zRU0fC7xe7+0Hr3xwhXS+/KsSfsrz9GwcL2Y07CeA2K5hKOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7kX7H4bSg0LdmAX2ESWgSTbqqnejNMJESOyhoERrPo=;
 b=dm1Rx5sBMY9uNCDfTKylhkaeRjwxe3rPVcQS936+6sxc1g5khk9GVA5hUYP2g66xYNf1TwgXEmmBwRCvdVn3SCPLGndeLWdhZBbui7ssVlIlBgI93wSkKuxWvJlERVz4csBteRksIRo5u6AMRcTyx74qIE70ZVP2GgwoUcrVb28=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6578.eurprd04.prod.outlook.com (2603:10a6:208:16e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 12:46:09 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73%6]) with mapi id 15.20.4020.016; Fri, 9 Apr 2021
 12:46:09 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net-next] net: enetc: fix array underflow in error
 handling code
Thread-Topic: [PATCH net-next] net: enetc: fix array underflow in error
 handling code
Thread-Index: AQHXLTtXGAUDNqJrxU+vENCaPc5U+KqsIdBA
Date:   Fri, 9 Apr 2021 12:46:09 +0000
Message-ID: <AM0PR04MB6754E3B8539225BF459DD2FB96739@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <YHBHfCY/yv3EnM9z@mwanda>
In-Reply-To: <YHBHfCY/yv3EnM9z@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98345ca8-2e9d-4f27-e4a8-08d8fb55735b
x-ms-traffictypediagnostic: AM0PR04MB6578:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6578F68006FBD96484E6C0A596739@AM0PR04MB6578.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QeGue6+fq0x82bYezk753SMe+vbrDptcz3wBVJXjjiNH4eYgBp2W9D7VexOwTp+BipnkjE3uS+aC+ZaJWARMZGA7DMTUbgIXsv9Zqk0MkPuvSt9s8u3TMZRNxjLSkJtFp9KEfSwyDPg4gagjy2S5iQRRcQNZo6ANM3+aV0na+aA9/T4aC0KB1WI2Vellqupym4ZmYXkGDVdYZtu1ehALnLE58orO68bGC7xgitGp3q9OQw7YzhaEXxkn9QARoLgn7HKGKQTL1A97zulS5A8txxFVYwnFW8c+FkSFy+X/Fg4bnWPCooG70aO4or35WPEg4a19HJbVfdkU5Fx0eBplt4DUtvvSYVMDs6p036VqJ7jO3MlOJRkT00e7s9VNBxcNX9u1DKB9lDABUvafFNj8s/z4F2Q67/zaGGHSQxMvbbQT6QT1r+6K16u7VD3uEjUcaogacuBugJ5Kx+c149zjXX9VLx6vLtV+xhzLnVQRNnHIKtbVSBW4iqqo3uP9w97E8LqUxDo6gO3AXlADMKkzQUh/rPLY3u2ySGvAgL2ZuyVVdBy7bm4HdjZj2c8/Zx93Vd5ova6hIO3rDcPDu787clUkQu4PTEJGCoeubsVaWx9IwwkTEfdUOtFKJaIyj84LWw0Mmp89FgOVNvQ0M5QTacrcpMjgxszHepPFT1fUEGo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(66476007)(66946007)(52536014)(66446008)(66556008)(4326008)(64756008)(86362001)(44832011)(478600001)(33656002)(83380400001)(76116006)(71200400001)(54906003)(2906002)(6916009)(4744005)(5660300002)(8676002)(6506007)(7696005)(8936002)(38100700001)(186003)(26005)(316002)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+R7bA15rsqd5HTj/ilcr0cgz6i2kkdeaIRuw1RoPXvJv6s7gHRtRl4YPczOr?=
 =?us-ascii?Q?zGrESCBUhmdZNQzgOxIDE9U/6rotwefHSO7KoLbhsAyQ5AYIcKnU4p6ewTcL?=
 =?us-ascii?Q?eErbW33EXVzQ7IL9zHHsppZC9QjSz1HVRUR9gvO6DMJioQQhw3YTysC7tKMc?=
 =?us-ascii?Q?TVCNVPVvA6+evIL8sngLil0fIm6xWSzrDEUPya51FyEReNeVLf3Sxifhc1yp?=
 =?us-ascii?Q?xPETLmgUJslUVqMUV3p+NBSEzzmMYlgMI9uiB4IbpYw6E9YbtqkO1ir2Jpb1?=
 =?us-ascii?Q?9318t0IaDwZBBo6jl3MAsAMILbqwuTJCMJq/Yi70/B/ejDJvhsBeRcf49QU/?=
 =?us-ascii?Q?wsGPC3NvmVQV+ZcB+9muydhR2WvClVPqukuSkYj56hi5QSaGujqa5fQ/nECo?=
 =?us-ascii?Q?nmDedKkgmbQt69wi3Rya823wQc/IXaKUacTcJ0z3w4dY23ARObigVITqlkBQ?=
 =?us-ascii?Q?Ffs6bbYMa+RVzaJt9A9BPrc7Qgxq8s5j2GNNpH7mMSX/SVJhuj4wVu41TdIn?=
 =?us-ascii?Q?T5TMe+TIlVqEX9bVgi2VsrDVYSFhdtiHKpVoBQbGSzIjyE5rxI62nkS6ILHg?=
 =?us-ascii?Q?+jAfY9zAXPJdr6qNoZ4fbbcavwKqPhYtBQZ5DINyk2ffLmS1xR/DbUIEvMqI?=
 =?us-ascii?Q?gqj8wqaPY2QUJ6n+NqeAMT+2bG5HJSHu2uaCmFiDIyGkbnXxwSh4Q8hFtBZQ?=
 =?us-ascii?Q?E2pQyRbDfV06j/cK7+bDVKNzpkMiS6LRKiSXsB/5SenjEYZoe+y6RLJwlzrf?=
 =?us-ascii?Q?Q0mSPUyaaRJnIf/rQEG8EGHMDsaTTIp9/Yrdz3HZ0oyC8RiXOvzlpKEtbnic?=
 =?us-ascii?Q?keEvASpptqaUuKm27kgAIxHAAGAKkMWVkgE++ZK7nv7yPJEimyXMqSgb1CJW?=
 =?us-ascii?Q?Hlz9laX8qHLb1SL1flvNf1w0l/05TVGt1r3l//veLP3+qj+BEf8rXU/c23Ox?=
 =?us-ascii?Q?1xJUog8e1BVw0+mLljBofiEBFJEYzIvIvknLoRtUtyvboZE5i8aZB2OjaKXH?=
 =?us-ascii?Q?Zy1hOQbfHhIwUPUgF9sO0/pxpDLFYsYvtYoDWBFs3vlhl5qQY+txwro/r0k1?=
 =?us-ascii?Q?L4v/8SQwC33sFqWBhgaZDjyAI14XNdxJnOtsnDF1Z8TmvjFXOyNRc7fzB4rq?=
 =?us-ascii?Q?udm6+Z5v+4jm3F4LzVauChoueyBaivdsvgxiWI/JhOkrSMCMGXsST66mGDFK?=
 =?us-ascii?Q?zp7+4RNy6lIrw6k2bnqRsowNwi4bJhTb3JRDlO5Mj2BxQGsKcdVMM8SVRA3E?=
 =?us-ascii?Q?xEW+MRXxD8qrLaRHh8n0FX7sGyfy02hVqossTRrYEQNYq/SR/oilmcOTC8Z6?=
 =?us-ascii?Q?mUD41w8Z6E9MTkb91tSR/Ymd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98345ca8-2e9d-4f27-e4a8-08d8fb55735b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 12:46:09.7979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A8zhRgUPlhFNfw/HkVlzgurOqVcqyIqWSE8BTVeUxaaUkUR2bLQISGyacf9XEnbgaT1ezf0ZtIuWIHgB7GBRHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6578
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Dan Carpenter <dan.carpenter@oracle.com>
[...]
>Subject: [PATCH net-next] net: enetc: fix array underflow in error handlin=
g
>code
>
>This loop will try to unmap enetc_unmap_tx_buff[-1] and crash.
>
>Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
