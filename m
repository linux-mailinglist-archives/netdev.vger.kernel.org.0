Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47084F1C94
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfKFRiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:38:11 -0500
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:54216
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727286AbfKFRiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 12:38:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff+E+omuFr3MAmn+si75ZOw3Wd7n6rj2y5aLRizcCuNisME3DGKuZryeWPZHVoBjKRzjisyb5LVimbkp6gdQM4uC+D1UK8gncTJkAUxIKRejow6WBFsPXJsDWKG3C0Tt5NyB++p2YIz0t71+vdBp718ta8QhAf0zuA2+h6es7d3x2EnEcJiI2P1cij+s/wrAMuM3C8vVPv0q/bp/Yd4ok+CAOI3ajMTL/90GXMLbmHUopFC5ZGeUcW6TsfhDlcZJkQH3J9nfE24BsuhZHGUiQ5dI8KvjO9UvgRVkZi7RE/k4rt1j0rcbIajV28/if+GvNshxtrvukPI+Fr+hStSC3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWKIk6sPuWOxm8O+Mz0Yd82ZQa8tb6pb00wCPzLBc8g=;
 b=UOmc9YSYu6Xw+hrbVCxLPj9wslp2rWVhPG+2UDWnSyBrI9GB65ka9rbQFxA5s4RrVkOkGtKlSvPqVNBibKkG5nPTa9I46iQJcFGSdAEzJESoWLdt+2JlLGXph42yMBilTlWY7j2TdAO0AHGFjXuwrsFROQ4EX09Ubz2icCSbqM+ckqi+YGLgajhQ2dfmoCv+yGwVB+d2Wl0GlLpjd9CXcxnNX1So3xRbwZCZGu+XYiQINuGde8jX9JiJuR2ceZ4U6UxAdoLFvKOhOndA6R22zc+B0OMxi4EpyTqBt6qCcfUeIUIZc2bq0VcbcOqpTwZKyC6lVouNFjkTU+H4c8bruA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWKIk6sPuWOxm8O+Mz0Yd82ZQa8tb6pb00wCPzLBc8g=;
 b=PxlH8rerTWEfv5903PO8EDUsLPbmkdqcBY6JQiZbxjM+KwAIfZZfe3IjTBTNeptEHp6XQ6pOnI9tQ2ydHeiRm1tBv37agDryJVfYqkWSlPtoSk+I34znX42q4fb6QPc1soqa9C8cJXHqzaysTRzwBnsJ8vBnoTAY9FOBoOr1qek=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB4334.eurprd04.prod.outlook.com (52.134.31.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 6 Nov 2019 17:38:07 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::50c3:42e6:9aa4:8744]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::50c3:42e6:9aa4:8744%7]) with mapi id 15.20.2387.034; Wed, 6 Nov 2019
 17:38:06 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Daniel Walker <danielwa@cisco.com>
CC:     Sathish Jarugumalli <sjarugum@cisco.com>,
        "xe-linux-external@cisco.com" <xe-linux-external@cisco.com>,
        Daniel Walker <dwalker@fifo99.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers: net: gianfar: Shortest frame drops at Ethernet
 port
Thread-Topic: [PATCH] drivers: net: gianfar: Shortest frame drops at Ethernet
 port
Thread-Index: AQHVlMQbSvI2s56BgEOMA4u7iC3YB6d+Y0Qg
Date:   Wed, 6 Nov 2019 17:38:06 +0000
Message-ID: <VI1PR04MB4880B060847C1CD175B998DF96790@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20191106170320.27662-1-danielwa@cisco.com>
In-Reply-To: <20191106170320.27662-1-danielwa@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28546c04-5b46-48f7-4091-08d762e0158d
x-ms-traffictypediagnostic: VI1PR04MB4334:
x-microsoft-antispam-prvs: <VI1PR04MB4334DBBBF4DB824981A5065196790@VI1PR04MB4334.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(13464003)(189003)(199004)(26005)(486006)(76176011)(6506007)(6916009)(256004)(476003)(14454004)(44832011)(7696005)(25786009)(305945005)(74316002)(7736002)(11346002)(186003)(66066001)(446003)(2906002)(229853002)(99286004)(6116002)(33656002)(76116006)(6436002)(66946007)(8936002)(9686003)(86362001)(102836004)(71200400001)(55016002)(316002)(71190400001)(5660300002)(52536014)(6246003)(8676002)(64756008)(66446008)(478600001)(66556008)(66476007)(81156014)(81166006)(54906003)(3846002)(14444005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4334;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: edgl5b63XmHn8Xqek3BAymWZlPlCP7aodwJ+lRzxRiVbKdM//dAq97YxwCtrRqZKxxwtzdqxB8UGpuVV2zOlIDNYZE3gTB9D3qPZ851tuzegW4uTdAXPH59DLjSSpdsFRCouu6ZSU9xlehCIu/8Z3rhaqRhdPfNuqsr0EoSSo3pQXr6syoPSvw+pYttKz4SOMPgFS8mKd3Xk6j1IlhVYYn5XBTq/Fmwu94Z1Ys5atPFeGt79aqCwmN46YqQWYmeHQcK1bcB3vzQUa+64j550Z3aWS5PK++v1auybQxaFyNWq35D8KBarrv+pN/4NMMtQJYKYMTeI7ZW+q/lTeCzZExcHOuQwZooDS2dilnlmixWDmMhkiipzRHu32PnL+FRVMetCP7bt64cqwKvsNwW20nRlQ38zBu++bn/f8sb4f/4TG7nce41zehJ+CZdYwvUJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28546c04-5b46-48f7-4091-08d762e0158d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 17:38:06.9160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VvvvEYQ6mXltIjrvINH1WqLJPubixdFk1YzYKstrKdgkTMlouzcWSu/aGOyKSHNhSbT2Ha+fWuustaqQ3U30lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Daniel Walker <danielwa@cisco.com>
>Sent: Wednesday, November 6, 2019 7:03 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: Sathish Jarugumalli <sjarugum@cisco.com>; xe-linux-external@cisco.com;
>Daniel Walker <dwalker@fifo99.com>; David S. Miller
><davem@davemloft.net>; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: [PATCH] drivers: net: gianfar: Shortest frame drops at Ethernet p=
ort
>
>NXP has provided the patch for packet drops  at ethernet port
>Frames shorter than 60bytes are getting dropped at ethernetport
>need to add padding for the shorter range frames to be transmit
>the function "eth_skb_pad(skb" provides padding (and CRC) for
>packets under 60 bytes
>
>Signed-off-by: Sathish Jarugumalli <sjarugum@cisco.com>
>Cc: xe-linux-external@cisco.com
>Signed-off-by: Daniel Walker <dwalker@fifo99.com>

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Normally padding is done by the hardware, and it works at least on my
test cases and boards.
But cisco seems to have hit a case where h/w padding gets
unexpectedly disabled (concurrency issue writing the config register?).
This patch should go as a workaround, until root cause found.

-Claudiu

