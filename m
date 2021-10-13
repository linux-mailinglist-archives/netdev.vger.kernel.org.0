Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AD442BA24
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhJMI1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:27:52 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:29435
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231208AbhJMI1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:27:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0j0zLrYnM+L/mYqdkEIq0QT0dibzlzcyhWNr19FTk3xLe4PNtfcIODgR3prus1ZZHEc0Ziz1EKUTGIQ5H+gvLDXiwmwE+HBKTH6Fro6yLdObWVPSAu46oBMp5PyEYT8Of+umWBFFiX7tlU5C3wFzY9Pj032OfLUVvhZekEW8vomNGr+x07ctFwU8M5+Ow8m2wDkHxctPMfnfEG96yJx336RwOmtpfVOUT4nBSiSGUQlQfzCyCUj8yqQu1rBHfC4SUy8HeivbQk1IY5qbWP+7cVKN6QXD4x+fKHK56+h/du3CshoqVeuSyTTI8wDueLysdBthlpVkYAfLQzQ/fywFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAzbMrT8bh24hkXl9osDwsFyEDgzYuwxjhCYGdlcYZc=;
 b=UPOiLEiJFnn4V8OuQAhyrgj8V6M4oNElEDWtAIZpQ6QPSSJFG74nKrM/+0igICXTclJYhCH2ImMgX9ggdNTy75FVmDFqkxm4kKEQ4ixzAHQf+WxM/qn35B+LFJNPZY/see1yRLw1HWhsr0MZ060Ql2sRf78VVntGjrUA59xaR+DLkRa/SXH4BCK3j/Ggnw6ls5xRs+hsYmzMUuVjLmQj1IJd9UNnjQ3nZjooodP32BpdtNthQaoFYIC3VWO2ul1vowVVdXC7RzQ6YzT8KF7ULW5TebXVlUK7WEGtVqzjREGPAm83gJXu0CvvAPtxHdHWK0ZCy0wgXM+2jDiZUQFa0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAzbMrT8bh24hkXl9osDwsFyEDgzYuwxjhCYGdlcYZc=;
 b=DlD9Cc1/TgYe61YQuggFKJin+ram/Ivkj8YccTUfRC3vo7XcgnQsGE1K0+1+hOMiZmVPGLml/vndpwlWU4duHWyJOfOm0tTz8Yfn/zwH9sl8n6uTpH6xyJAzyH6xw9lSBE+xxKe3gfHsbzAU+o7WO6ztELvecXasq1XTtlv46pE=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5329.eurprd04.prod.outlook.com
 (2603:10a6:208:63::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 08:25:46 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.029; Wed, 13 Oct 2021
 08:25:45 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: enetc: fix check for allocation failure
Thread-Topic: [PATCH net-next] net: enetc: fix check for allocation failure
Thread-Index: AQHXwAkQ/zNBgcEmM0OdLT0vS0a6sqvQl8IA
Date:   Wed, 13 Oct 2021 08:25:45 +0000
Message-ID: <20211013082544.kcs66twfxvhld3fp@skbuf>
References: <20211013080456.GC6010@kili>
In-Reply-To: <20211013080456.GC6010@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4edcb8fc-5e79-4201-5874-08d98e230dec
x-ms-traffictypediagnostic: AM0PR04MB5329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5329DF02A52CEDCCC0CD3DB0E0B79@AM0PR04MB5329.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m4mwZAUImeaZM+L6J5v5yl3+nP2aBUeH4f0s6B1rwSkKzX9SHEyOJcf67poF2wBDgyfczfb/9Z3fzZl/1fAxpF7rzQLzL0ZBd0gt02CqZ91BkZTGUaYYY9wWeadLYRpgJD5VNLygqZJD85HK74a2vHKueW0hWY8NNcmrbInX4+eL9IeUizueRRkvrzu2FOTgqdfV0YUwwY+qGnlCey0LCOe39M2VNPjW+2UJ7SWs4PPJRsnCB80duE+RJxVP7+K6uYtAP9lCCvdVdMU0XfVGlmbpMogWUPBQlJ7xBvawCxfgnDF96rrDeHvbypQksCnxl1+R/SzwZhZEEF7d62U5sN/eyOp3DJBV5tl2i27T7Ov3E6sFLVSE/f6enKwYIb/2CevOIvW0iL9vhpEDPSrElF3a3nQLvpXH9pQsC4Z/cEd0w1B+DBDG/HMkS2T5tFb1kyDR8PSsQJoYYFphieWvwisXdArXxypvVvGY7NmELwNoQRJ5NKzzkI0/AV1ueb9jikxZ8hBvsOm4I1vn1Tk+NCyiZZWpliL48Vw2VoZ1t41K+zzTrvwnsD9gjphhGSRivr6QhwYwA+nA8u+et1TCEj1uz60kGugRNmyCH654qvkra+S/VpbtGJVv42h8jxwvajO+Ow/mGCdtkfNHDS97EpU0U/xVeOxcudLVdMWCV3YKmenbOXUnr8uQee6FhcqN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4744005)(71200400001)(8676002)(508600001)(4326008)(66476007)(2906002)(66556008)(33716001)(9686003)(66446008)(86362001)(64756008)(76116006)(5660300002)(316002)(44832011)(66946007)(1076003)(122000001)(6916009)(8936002)(26005)(38100700002)(6486002)(38070700005)(6506007)(186003)(6512007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N+6ux6+IOzl4pQ2n+ofVUnKvPyli6mIzxHcHyI+Dog9XqsDNX+HBIKNzqr3d?=
 =?us-ascii?Q?3vD13io+CWJumYeejeDDnxByEx+bMEs1X/UHB4/26dUje/on/inZd6LJWO/E?=
 =?us-ascii?Q?njpHUSfgf/ErJv2emCBmgyVGNcLykbzcheIodKcKwgy2SB1j6TVZGGA4hdoZ?=
 =?us-ascii?Q?uzBZNaowvUGKAR4MQLTqPCC5QdpYF2oQQELpkVQHCB7tsaXEes4xXH6CkS0t?=
 =?us-ascii?Q?zr1U1EnOWQniuGSFG9aZIoFs7dj9qdY8+7KpJjXXXIfrk53AKc7j+YkTZYpO?=
 =?us-ascii?Q?7eElrBR538cx7/W9vRb1dqIXoWVDNILA4EpqeoTqv5AsC60rlJETiYZvtWVP?=
 =?us-ascii?Q?qvK/ay7V8Vbt3UIk7Kk3ydw/u5fLXjKyEMgQi+M5lyccPvLcgeKTR78Giod6?=
 =?us-ascii?Q?RBLI1WiAHsBCi3+5lFDfuJH2UJ4J6o9XKc+akS6KJfzLhtAfJaz4T9CxKcu2?=
 =?us-ascii?Q?TpiSR4HeoQHyLHnXojzqFDG9BScyLj1yA5ZaOoyhc+CGEZdwlHxFU9+yJv8Y?=
 =?us-ascii?Q?b699qm649qtL++o+JQeD12pRN3zvkORzc1wZvCl+l3ihbXqhN2T9FKMHuWyp?=
 =?us-ascii?Q?S1XqM7NH9xMe/R4f/xTGnLbx3knA2qayMVaoGNU34EBm7FLxxxIsMeViRl2B?=
 =?us-ascii?Q?VzKARB5UEfTaoId1dRjuQnR0mMzsfVh0No+2dHhTsswLLwuW47F2G165KBrp?=
 =?us-ascii?Q?ZocESKTY/cd8Oy5MtUILc7oukwoCXkj6URzy5ZSPM+RqdSzH0EJ3SQoHbDSQ?=
 =?us-ascii?Q?gj6zqZH5YJk2cGXVlhirj5K3w55c9ZpbTgwHh7I4hhZPvSIQs6NpIbVnxd7K?=
 =?us-ascii?Q?MvYehma4NnoejnNBhlJj42DNdB6VwCi9MBfdE83BWNGyrxa+tyqK0i3oflTn?=
 =?us-ascii?Q?s6xVURFS/fP+y8LcmgEbmezFC/yeLbFk+s1VBgUOoxQFkF7h5wKY7JQ00boq?=
 =?us-ascii?Q?x7sVRrFZ7KFXmrRROmnfVhtP5S0oT2NUAPBhkjAKp3ZOIaRrzJfy5hbdztsY?=
 =?us-ascii?Q?C7VqKrEcNDO1zXzx94qgmffa2pKw68Yqg4gP0UxRGLiYSSJ/CS8ex4QV8fCI?=
 =?us-ascii?Q?ysHsaIyQrqhQn8l9Sbcyu3StX/jZtalk2hfWs05sarEIhgkSzn710N3QJogO?=
 =?us-ascii?Q?/qjJSMxsGaOTz+WzOTq54sGsKSQSMKAPKpAIOrQrz3meYYwOho0wUs9tRvrr?=
 =?us-ascii?Q?AGcWQLAmJj0WTv/KDFM+SQI8me/El4xqeg1stDcWW4xiv3yZBHOUcsz48HGK?=
 =?us-ascii?Q?eljwy4E/BsTAR2G76F0G7nB1Tdm498TlepLf2WgZlNmEl8m4mz0cFrQiOMe3?=
 =?us-ascii?Q?QqP2+7UJG8dpEEQ6xyF9/rip?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FA29EE12B09DE438CDE1E1AD0F3330F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edcb8fc-5e79-4201-5874-08d98e230dec
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:25:45.7588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MPEINw1O+BOneizELyLTBdI11d423Ui/ZxAJ6PPqW//CfLFwoQQVg3NpkNJaK45ST+BsXuBbaJQ0P1KZ0pLfCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:04:56AM +0300, Dan Carpenter wrote:
> This was supposed to be a check for if dma_alloc_coherent() failed
> but it has a copy and paste bug so it will not work.
>=20
> Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>


Thanks a lot.

Ioana=
