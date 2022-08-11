Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6F758FE77
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiHKOlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiHKOlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:41:49 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD088C46B;
        Thu, 11 Aug 2022 07:41:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnNnXlMmtVSl5bSorZLRmnQdOJdbsVOdX0S2/0qHy/V8Qyh8TEWtwQqP4GcsNZV2BZ1bArQexZ76on758Icyp6O8pS5vKghpLoEiaSfs/4Ca7SooMm6X9scmoi+6I2VjRTOpIHe/iyY/d2NESVgc2oRZYDBI7Q74ppuiDQiRuJIhqgPYfckWl15QZtt/VdU+7S5Seg5sYhEuY6IAdD5mWNDzaf0aSEgi2fW4M+6SlahAg6GW0AXvF6S5WgYoUTrTeVUd4i3i+f+BgwfTg0YE5m94hmNzKGPq2QoWcaOWpduaFNuaZD61cPHx31KnLF+y5IW0vNC8PXdg3jFSV+dP/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QSNwkwYVlVPMqSc+deyGR89Zi7AJqYIFaefmKhOyfE=;
 b=VgY6vZlJDxg5Zds5DTMRl+Gyd3D0C+5sQ51RujmOzW7cLFuJ9/vuTl6qWNz4GeHPWlsIJ5mr6Rfp3aMOlNni3Dax5w9rkjOxxRKC8ZAF1XdhM4JW3FN5doR0VgOrFPTME9GkwAxZXnCKLtdv9y7no2f7lCkxMYSWl6clmXljjQfEbG19lVDaBZmQyrMOFGymsAd2FbL/olzcAKxThXGvmv9UD7OIlwZ4kOpfzXo2zz7B/jojJRZhnLfl8ionRIotCK3EbQlYQkcWuckP9C6tQ7uIQVMLyabuwfPMZWdY6yzCe2HutxMAk40roCEzP850y5sZu5NUAlMZM361goeQNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QSNwkwYVlVPMqSc+deyGR89Zi7AJqYIFaefmKhOyfE=;
 b=OFDehb0aVzooemLl8zAvmR+gHy2x4aKU5gX8UJHaRMEXPlviYoAhdb2if4xGwVW0kOsISI5lx+FmJPXaYxkTGA+Ux8jVGWcu4jGsBB56NChRNniIbLF4Z0de7sgAuIO4Bldh7ss19JqeD9FN/fecMNrNLK7rs8bwvZLGnA+vg2k=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 14:41:45 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::51bc:4e42:f244:dacc]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::51bc:4e42:f244:dacc%7]) with mapi id 15.20.5525.011; Thu, 11 Aug 2022
 14:41:44 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Chen Lin <chen45464546@163.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yi Liu <yi.liu@nxp.com>, Chen Lin <chen.lin5@zte.com.cn>
Subject: Re: [PATCH] dpaa2-eth: trace the allocated address instead of page
 struct
Thread-Topic: [PATCH] dpaa2-eth: trace the allocated address instead of page
 struct
Thread-Index: AQHYrRFxybr4KMs4J0qGvHSGa/QgEK2pxs+A
Date:   Thu, 11 Aug 2022 14:41:43 +0000
Message-ID: <20220811144143.b4mlngr6x76bozwg@skbuf>
References: <20220810232948.40636-1-chen45464546@163.com>
In-Reply-To: <20220810232948.40636-1-chen45464546@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b4c3cc2-f9f0-465d-6081-08da7ba79c69
x-ms-traffictypediagnostic: VI1PR04MB5134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83fbWtQIXVPaLgiIy6UeeyBD4vPgxk4MV+iQl5zlwe25s/V6uR7QgOEt4cXz2F9MthfD8fjTlIvh96D9kzrRqvyWPmY/Pe4hPUiT23Gktd17LGN+DD3pxFwgoP5aomSh3yjfGv8Ph08rI6I0IF0fSY9MSYWfCjdqigwuN5Tr/DonBA3qB4GPvO0osBpUxLLZ5S35VsJ5WsCKp/9V7Jw5XyXzcgnhKXyFOGnPtNx9L+TE6moQ65PMEP6dPK/sjCwR8byANs3uL/JVaJBOGr1IUHE3KfoS/mHZrMZ7meDS4S5UyuMrV+9qoEFjvQxr/lJl9Ox5mldt19qIjSQG+vJrSHWofiTNDvEn0yFxcrOf3LVQG7EOe6c8/4rWG4WIVh93AemOmuxubeWRdwonUXwuulHJellHtj+axCc5GJAqLFef63rrgoTFDlTZ2ZPrWzDOvcOygkOpx+VAqUWDjplc/QAw3fdtd+oMybYY5DyuBzfEY+gj8udNUMDtZSxB/GoPBzPVeoj0H2UIL/wGvHTxacXf6dZg9yaKYZan+xsv2Bwts/FR5Yy1LYGtr/l/g97yOlwBCldQh7W8UpoVrBvqwFcHEzT/wRQBIa18gHxCWldwz8r1Q6xpVR4Nd23exkqd3DLYXmn5szqVlEBBA9MD5VCNudEPrqDs+G4b88fkuk/uBoqTDGQM9MbP2wCCHDJYhjz/PitUk/H/d8Zs5dHmksMUoCSkcKzHncXrfk0HYhF3LC6sbRBHaZa02u165Vw3iITZqVEbus3Ln54/8rxS8JnybLy0goMfpYSK5LhYjR+pFw0G0moflvcXwvUttwha
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(6506007)(38070700005)(6916009)(54906003)(316002)(6512007)(9686003)(186003)(26005)(1076003)(41300700001)(478600001)(2906002)(71200400001)(86362001)(4326008)(122000001)(33716001)(6486002)(4744005)(44832011)(5660300002)(91956017)(8936002)(76116006)(66946007)(66556008)(8676002)(38100700002)(66476007)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FMuKirAmRVncqpmSPQrVl2ixsPIyyIr7kIRhINyJH2zzMZUpLVXi+VL1pTSQ?=
 =?us-ascii?Q?W+xOf6MMDXbil630nZ4PEBc4hbKTXrgrv9Mo7irkGEvkOkQkVjLtC8HilTvA?=
 =?us-ascii?Q?aedj8tpK24iLkKZLW40ZBaKIldS1I2VlhIXS9kwwRJdtwHqvYgc5WtsrzwJ0?=
 =?us-ascii?Q?3np5W/xEjElLpC6gDujIyjxunFHM5y7Kvjfls1+odE/MMO4cmaIPyE8WS7ov?=
 =?us-ascii?Q?MCIZU/MZI0lub02ZurdbU+LbX5q85OE/2OMlY/0cmVAh/0p6URpb0PsEFcBV?=
 =?us-ascii?Q?ZZoJ2JwT+nQQtFfdhyS4+4uplrLbEhwzVA5FLjtGoRrmZ09U3nAOHOWhl2F9?=
 =?us-ascii?Q?2sXh/dZY8UmflXMb4TvmLc5cYaiNgtHDpJondrjcHjPGKbIWd7mTKTC4z9+w?=
 =?us-ascii?Q?0ibuQIDoDuuupT7ogLHoc/5GRsLyiPUFgse/k0AXNXNkz4NVKiPNNnJXB070?=
 =?us-ascii?Q?J9b1d0z5pWlt+T38EXh3dC5ObQmfPXryJ3hFFmwA8gSxy4MOM2ACuMkvuPYS?=
 =?us-ascii?Q?lMKLrrT1fMkHV1G7JMhkYsUPK4hyAGFW0Z5ou0n+tWkMWDD+L1Ywp8ysg8s8?=
 =?us-ascii?Q?jkGsro6BklpVQczk4Aa1tcRtndRJ7Rsz8ZDNkg/17v04Ij4j0JUO7f6JHNmk?=
 =?us-ascii?Q?X5A0raEeLn9btAyGLACgGbYCJEQ2yLtHFI8JPsEWqoTLUctWo/gQ4wIqCjvU?=
 =?us-ascii?Q?jIE5it8Q1uPPgWgZl/ckt0hmNUqWvCOu/e/8wRPa1sYOfeoV+FAsflK4Dwcp?=
 =?us-ascii?Q?xlXM6BAEBX9Owg9oRUy5k3NCRN4GvwElp0C5/+sA7wptgFKU5GFPInBZpB5b?=
 =?us-ascii?Q?/QzCzx5065UIfglSMF5MmWJa8fS+aT8L+iz9qH3FwOE6S+do9ffIOxWmElyz?=
 =?us-ascii?Q?auFG1k+5jxzjguGy1YlrJmPoAPgiD5W1p49+mqZ+2FIVpjRVMTe2D1IEHjbD?=
 =?us-ascii?Q?ld21ygA6Tqb3GFzuS9xK9QdW4NoFOW55S++wa0TgeocpceEBPWbPU16WIKzB?=
 =?us-ascii?Q?JsWsyrA1Px46UhdiEIrTO9MZ22zYSiNEPi0b/BvLT2DofCYPPdgKVQxybnXA?=
 =?us-ascii?Q?Vzc28zHUeO1rNpWSUhS3KEHzYKUHu0qa95VPDMNkMa++3r9P++uROlJ2DVT0?=
 =?us-ascii?Q?HjGsvbun/IUvEbX0yNimrHfUgcWnVM2ucgM0kuVbdBFBdnPXLDz4LpmrTndQ?=
 =?us-ascii?Q?fSMIh57xtRnRBSgcuKofEHXujc0Y+2J4FIpuYQbE8x9TomXh8zrpCHC7IIaz?=
 =?us-ascii?Q?RbKycuj81rt/11ZqAtlhN8tq++7OFkfY85k0nvYn6KpTp10tQiPzlIfU27pT?=
 =?us-ascii?Q?mYgDGibFxd8Uxms1IxCH9EFVqlrVf0Lz0tZt8H0Y2xTLbNE8fEdqO3eRk1fo?=
 =?us-ascii?Q?N5bxJeGAoUQkF6EL4ip2byygJhhRpH1OlISMK6sX4qZQNuJboUWEAYRzLD5R?=
 =?us-ascii?Q?6UrI8o7cJMdixyUYvxx++X4iXD2pyQLwymNaydnIO4VFEaqpiw4mRBlF+p/s?=
 =?us-ascii?Q?IIoN8VvbDb9HI1sBvOQXzOb++Dw6L1lqP5OjoWSx9HhAAcgSZHbGM1hW5h0g?=
 =?us-ascii?Q?k/Pzh/SXc6ckMk9ds0vKGcMxgYaLftGEFEe17cOf7cK6o8yeH5aTPq3ng9c7?=
 =?us-ascii?Q?Dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29CB40617277B346B2959B797F46D417@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4c3cc2-f9f0-465d-6081-08da7ba79c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 14:41:43.9628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLkQdd8iaEr11lDnLzTpO2HxjZtQpK6D+TmCYPakc3jf+i+D0L/iT2U4QbY+56wEatXAgVeNuzMxoArdkqxHCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 07:29:48AM +0800, Chen Lin wrote:
> Follow the commit 27c874867c4(dpaa2-eth: Use a single page per Rx buffer)=
,
> we should trace the allocated address instead of page struct.
>=20
> Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Is this intended for the net tree? In that case, maybe it would be a
good idea to add a fixes tag to the commit that you are already
referencing.

Ioana
