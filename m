Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE22D08AE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 02:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgLGBBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 20:01:30 -0500
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:37729
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgLGBBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 20:01:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKiogl7ncTtslc1zh6A56MNLJAlTapNsUDFd9Uh278JJ0OboCZCldIk5VdsC37NOiWcXhQ9gPf1agu0EdTDCy+mogywcIGCPfMYNS9gcDackgWAz9s/YRyOAolXW/QVpCRhMWemUH/yXBqj0yx70oYnnPOiNYF2o/BTOIyNY8pvSZqkdok2tth/7+gJ9TDyWgiIhF5TxdSALXKmZenYKdqvcrEYYSmgKhre+Mk9vGnL0aRKlrTjJjYstX9gF38YGVHvcyw/pjS3DmdXM2MSBhi1mJURiaZjB8RtQsD3WKMDr4eDr1Z2WggdMW+8EVqtJgWq5Qvo7ssZo0n8AkT9wiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw2IfYhIHoiRNdzP97yhIXQSfycaerbj35libbQ+Vos=;
 b=cFyYfZ0s+W+j/EihCk/FhBz6w36RtCUobLLuOhYI2kXHxT32eQfmsAUSU4l1SBzBYzqzDlsGwsJsxfIfkNw7M2wVoRbUnbsNwocxeWD0qCd5po3FiaqdExdvb3r4ng/RIuffncZzjy/0cYZzptKJMy9UWh58EELMwyOITu3myOwkbXFFSkAsWNVcivkdTZrey41ZaPw207eoMpLWAYXWL/Nczkda46vmEyCN+VB/kzcVYiiRjK0DcgYEL4FHYJx1xKwXjp9N57883BFX10CAKmH6H+8FXIsw4nakRe8hUwB5fhbhdbHLSXU5jTwhQ8a+32oBjm0BohwHs0xwPOhX0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw2IfYhIHoiRNdzP97yhIXQSfycaerbj35libbQ+Vos=;
 b=f9ifdFRwS/dLfUY0aX2dxC2Mxj9aDisaqZvPb8aBB8PyyiT88j0mSPCkaJ55bxGwtBVcl+JKI+r1yh48LrigYqBVHeFkKoHQOVfLgD4dCUWkwBVr6U1PV4FElBYwH/4z2xMh5xoZmFc1m6z7LEjl+V8hxaorFDNa3QUWUcba9BY=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Mon, 7 Dec
 2020 01:00:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 01:00:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Topic: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Index: AQHWzCvp+5zpZdZumUWV00Rtz8jGw6nq0GsA
Date:   Mon, 7 Dec 2020 01:00:40 +0000
Message-ID: <20201207010040.eriknpcidft3qul6@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-6-vladimir.oltean@nxp.com>
In-Reply-To: <20201206235919.393158-6-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21bff840-631d-469c-1f03-08d89a4b8462
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-microsoft-antispam-prvs: <VE1PR04MB7374F028BF9D224B8E6B52F5E0CE0@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mwdVg4+pwYmKvlsxOPgVwt/Q8umLSBik3U1Drxpb/h4LXA6Oebpz7tFi15tHn6vVnbfyu2gK9jL9ogNnj4j+O/E7L5zN3b/73si7TrcUTkhkbPokCCXsDe6p91XuqgCa2RWXnZOFvHppyP/iI6NAVRkrjBeQn0yedfCo7d3wgr1LVD+GwrOUIYJAMPlr1vS0dPnKljgIKIP06HSjQKLJsAvADx4Dqn0ZJQNcSOKdwY0H7GBBaXFj79ku5pgCaPA7C9iTISbI99PQq2sgud5hD0KwK70AXaYkfTu0tmicCZGOuV0bHYG4Bt06wXYbCpoW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(366004)(376002)(39860400002)(136003)(346002)(66946007)(8676002)(2906002)(110136005)(86362001)(4326008)(66446008)(7416002)(478600001)(5660300002)(26005)(64756008)(83380400001)(6506007)(76116006)(33716001)(6486002)(44832011)(71200400001)(1076003)(8936002)(54906003)(9686003)(6512007)(66476007)(186003)(66556008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ltKWqBPeK1nDbkIJrgfxYbMHIthzOCAzoYNs4VAem+NGPg9nl7yE3Jm++LWT?=
 =?us-ascii?Q?Ky+ZckiVThxaRuMBfdiyOO1ACdOTGXg0RBZpKR9ob2uyJSTe/fdPWCvYtxzB?=
 =?us-ascii?Q?QuycXVVVLeEBuAdVGXqoIa4F6M20iOsa0OM0QdBWCom5fJyG6VOtLjtXlfet?=
 =?us-ascii?Q?PqMwYhqHKNT4qf7SNmJcPf4dbw2Tz+x8cdXG7v0TCBXF8yJJAoKaw9fVLe4B?=
 =?us-ascii?Q?V691fKmlX3jWDerr+CpUItGUvtIO9zy++OktwBwWGH9cR3XSNtkOllHNyJ1o?=
 =?us-ascii?Q?SyzHhlYyKDE8EO2JbdxQPWvRaSMN95JyGmQp3C9my2lxGf0QLCvHfbLMBzHo?=
 =?us-ascii?Q?fWqIkStLpy+01N/WTDRab5e1NW7jFqiLCIkmFzR5VKS158nWHTxMtwVDR+Fl?=
 =?us-ascii?Q?NADH7b80KrF8DScDTShSP5vEULeC00Vbkm6nAW2H/sbLz0sYsLXHcUltlnW0?=
 =?us-ascii?Q?dKUZAgodhietd4ljAO/O1r7noQXRWkDFSPIrvNUhzQR+WXM5qd+cqFprhbPC?=
 =?us-ascii?Q?Uvsvr9hioK1ZBkD9SOnicq4HxDGJcUQgDWt0ByNhv7UEDvVo12zBq4rqsTnt?=
 =?us-ascii?Q?YD+VXrN1HDDTKPEbXcJK9O28Gdxc2/D4F/BKeNcskKTUA/yvzonxXalTbPIP?=
 =?us-ascii?Q?Ww8l5lfAurNVmfk7/gAlWMtzVZzja9cPXtnEiZ7pwfLv7jRA6j8qBlVbpAP2?=
 =?us-ascii?Q?v6OCphciBl0eNW7v+T+ArwFeDmdthKq14ibqoOD3fcSshotkv/WHVBuD5jKa?=
 =?us-ascii?Q?rD9L/cxsk6tnupN/xzUreUkajEXNWCyjldJfW9dkHkDaPDDVX8skC9B7arN5?=
 =?us-ascii?Q?V/4dqK4pvgyesC3TvCueL5uJambwfvrAWnvs0VP0S2PhW0z1/mOnuAXkd6Ld?=
 =?us-ascii?Q?mjOOUFIeV2ws9EwvXFMPXdsMrSy7qadQOvzpNPlqKxfdqc4+qWXIDAf/CWPO?=
 =?us-ascii?Q?1239dw411w+fxe4F8WRW/U3ZdkmW/knCU2W3O5xxBjaOfzPwsvC5hZxkRiIL?=
 =?us-ascii?Q?u7Yf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BECB9BD18EFDC44788AA9C7F3BB279EB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21bff840-631d-469c-1f03-08d89a4b8462
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 01:00:40.5893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZ6BirfqSuppNhCbSisKLDyFaLrDkHYoGDXbPXQLkAabBCpozH8ubur9mV+p4jLrFzY3SqiR9tNxwtrvE82C7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 01:59:11AM +0200, Vladimir Oltean wrote:
> In the effort of making .ndo_get_stats64 be able to sleep, we need to
> ensure the callers of dev_get_stats do not use atomic context.
>
> The bonding driver uses an RCU read-side critical section to ensure the
> integrity of the list of network interfaces, because the driver iterates
> through all net devices in the netns to find the ones which are its
> configured slaves. We still need some protection against an interface
> registering or deregistering, and the writer-side lock, the netns mutex,
> is fine for that, because it offers sleepable context.
>
> This mutex now serves double duty. It offers code serialization,
> something which the stats_lock already did. So now that serves no
> purpose, let's remove it.
>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

There is a very obvious deadlock here which happens when we have
bond-over-bond and the upper calls dev_get_stats from the lower.

Conceptually, the same can happen even in any number of stacking
combinations between bonding, net_failover, [ insert any other driver
that takes net->netdev_lists_lock here ].

There would be two approaches trying to solve this issue:
- using mutex_lock_nested where we aren't sure that we are top level
- ensuring through convention that user space always takes
  net->netdev_lists_lock when calling dev_get_stats, and documenting
  that, and therefore making it unnecessary to lock in bonding.

I took neither of the two approaches (I don't really like either one too
much), hence [ one of ] the reasons for the RFC. Comments?=
