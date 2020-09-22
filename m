Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEABC2740FF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIVLgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:36:49 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:27809
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbgIVLgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:36:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmC+YfMGqwmHGaByYFyQzBNyi+BcFlpAF4CZNryPVkDj88AjTv8cpDPzl6/IGH0SDefdEPrp9rP94Ep8cJy3bMFwhAAb2LRg5kwy8MKQ+fWXEUOs17HrZfCpqD0DbYlKtWs23tkJgJTGeHLWyk6PUWUjH+zSZ9MUPp8XO0h62ghirUjUwi13gtdsEi6/hNtJfPrCYcopm/D5CRPrO9o4gwR6i7zKucMWYOMxpyvr0iI23RP+qTSZxzL6lP9ypKvZ1MMoZ4clQotG+34/cpYz96T7dMHu3t2Tg/0S4l4lmZRKp1YuVhiMmX6qAHKgnZxRayindewn5yfSLoiHd+zNGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6NmHwsyBadnCBZkCdCRxgSTBPifc/8fHgQLl34HdwM=;
 b=cmUeHu20pxD83sUSec2AJNhuFxW/1EF3xrZ5UDoqOtWBrGDZLY+ZU/vzMnQxTUQdBuyJizXq/o2P7tWLo4K+Ow1IpJbdhMFa2bclWy9zqAG/mvYUoJbsb4BUMB884c6BZWKz0l+Yx5Pvzbf/yn5K6b5MhcTMtT9Bs4tDdYzFFuXYOaTbjjvOPKjowseazmByjf0/9jQGfk6RCfp/Yn+pQPdO1nByueTZsUMDD9xJJgXK+whbBwpyQcwxs+J8rIjOor4RppDwCJB8Yd5zsO4PSS50eXe5NGOEVo6mc61cb6ZApo4+J4voRtiX/j70DGbqJI+V7Kg5ae2hZOKCpduRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6NmHwsyBadnCBZkCdCRxgSTBPifc/8fHgQLl34HdwM=;
 b=nqcbd9wmK6IQ7pFNFWPo0+z7LZm1g/7yFhieXqApuD0UgN66T+D0+gH6ZmIk6WEOIj1wHvLaVw5frN+gCheNmcOFukj/ABi3YjkW5iuh4gZPpbzTteLAUX461Ju1lhCjKM3E/UaJE3uymd78c+tf3lw2FPxxtoACDyr5OCa9P1s=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Tue, 22 Sep
 2020 11:36:45 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 11:36:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [net-next] net: dsa: felix: convert TAS link speed based on
 phylink speed
Thread-Topic: [net-next] net: dsa: felix: convert TAS link speed based on
 phylink speed
Thread-Index: AQHWkM5TxPSfPwtzN0aAaqrvypiio6l0h64A
Date:   Tue, 22 Sep 2020 11:36:45 +0000
Message-ID: <20200922113644.h5vyxmdtg2dickpg@skbuf>
References: <20200922104302.17662-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20200922104302.17662-1-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7e74f436-ec8b-4c93-6a3b-08d85eebc935
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7374243CA6A00B8D50A89581E03B0@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CQNVYJp2LGDwB1YGVXTciwtCf6/DDj+mCkYyW98eBECs+DYDeqQDvauTOis/W7yMKasryu2LuncgWLxUUpWqaX9qUMV3HqsbtIHV7tiHvDbCKnL0VTrqLxEj/0rskARPqlrBDBAiOj8GIOUBlmUMuxv58rfgPlBVFSxC1Ql7+tjV2PJKKkwDvs1jO44WVND7OGkIuNysfFm9N83SMwVfm0cTaQsURJDSxmryp+kEx1xyQegCMcp1z1vkeFU5rfyI6WwSLqdjOhk5pFn84srfLZFvrzqE9YRE7A8kq7pNtpz3HtsnCyJ7iQxy1WTAr1bj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(39860400002)(136003)(396003)(346002)(1076003)(66556008)(76116006)(8676002)(8936002)(4744005)(2906002)(4326008)(64756008)(66476007)(9686003)(6512007)(6636002)(44832011)(91956017)(66446008)(66946007)(71200400001)(478600001)(316002)(86362001)(83380400001)(6506007)(6486002)(5660300002)(6862004)(33716001)(186003)(26005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qycE9ONsO9G+1uvw5gyaMOFoDaiUcnvXqi0KalFria+Migl6EnoFeXQahCYKZ6CtNWL1NC6NpQJOVWVY2b/GVIpZSkfDyM6chxwYCCqkJQg2xQ3htSHz9x7sPMMbXIp86M5IxZkofusqHGmfaV8GFOx2VT8Zv8g9IvjC4mz1JQFkgwPyoiP9u2IfJqA6ndtL8fW7mCuXtPYv58pwnbrDY/TLUJp5A+bQT+ljF6xvm44ztbAqSksEVF6Ky/kMvr3iMmLTdNnMFJ9ZUHqsLDh4RoQE8VOYePQLg3d51BpxDFy+A+G64BoFQ5U3uVNyBZe/vM/LwQQCWgMzGI6BCGuudjQfTDI56fFjbfhZDY/brSyrTuL6kPUlAYnxMN9hhYvX4XuU7qOIi5IW7DTpua4KZm5Cq5eZslVGJceyNtU9WFqjVHCtObw7djAe33hKv4vnsVFWPgYyvVcH+WtHizw1KN8HKdmpYvD74ZFowUP9JhG8z3emwvScCmUDBeHNTbfBv+2F07i5pREJFCl7y78Ltv8qSMrHTRFc1HtLFENh/B/ANx/gMcuYS0hoGLTErQg1Z5OVP4EbUuHo/DjYsdMLGfOnbtMiKBwZHNauucPo4CfH+k4z++E226jjlVyybJH0odbtJIRLiNNKz8lsXPMLqg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B85369DC1D064847A1B9792A27CCB895@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e74f436-ec8b-4c93-6a3b-08d85eebc935
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2020 11:36:45.7592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6/2JXJgJEuylbB+R4gfd/HQw4aLnQVcjiNX5/7c0mvtf65WCAiOqjYEG44ASxqO7GiUCwmUUhnDmW0l+2oUdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On Tue, Sep 22, 2020 at 06:43:02PM +0800, Xiaoliang Yang wrote:
> state->speed holds a value of 10, 100, 1000 or 2500, but
> QSYS_TAG_CONFIG_LINK_SPEED expects a value of 0, 1, 2, 3. So convert the
> speed to a proper value.
>=20
> Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via
> taprio offload")
>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

But next time keep in mind the following:

- The Fixes: tag should never wrap on multiple lines, even if it exceeds
  80 characters.
- Patches that fix a problem in net-next only should go to David's
  net-next tree. Patches that fix a problem on Linus Torvalds' tree
  should go to David's "net" tree. This one should go to "net", not to
  "net-next".
- All tags (Fixes, Signed-off-by, etc) should be grouped together with
  no empty lines between them.

Actually due to the first issue I mentioned, could you please resend
this?

Thanks,
-Vladimir=
