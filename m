Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FCD276374
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIWWB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:01:26 -0400
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:52357
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgIWWB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:01:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRDV2GRGNkbJSKplLqDmEwQZWbtcW+pWbsrpHGpW9ZmSawoTLayNmhPwCFdvV5IptCQFYUJ5EeN9/DQCkJuVD+pFfjk+Crt/FBMpq4yU/ZUaDQ2q1Eqc2t0P/D7IsXrGYTjsVrae2icUtQx440oOcplVy3+CjgpF/Fnath7zBmGiJl0i3UHKN2cFtuIiZF5VTMTnVymNzeSDQR6/JKRlJPg29bJtVOSjRG4tsDljbPErb3c2iWdhNqvm7lSimp+RU64lIk7aEde7VU4gmV/R/TnaByq2DX2l/1lnc5jogEGOQcuPUveKEWJo2JZd1Ps3G9cUTZASojukN4ev4hWMLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7FLkqftNhHlXOTs2DI5xeX2iT8mkvkwedQv6KFRSow=;
 b=Tn/AQA3y2lrfQR9d8N0PBjwy/LXgvIdEcX6007yBjeonqQ1df5VvzQW2ADNv96DZ5zZVgFOegdFuzd2V8HJ7ZDtXiOFbFvU5vKzhPWqwkzNxJ+6afvqesxvN9VUcVXCYYDgXcoMdGjMX5uv1t3mnDQz+ONCztYsMLz5z4kjGPpbiQcCnq9JtFiepGe772AIK48AmgTUKiPPeXZh1CnDDNFuyGXz34QSVVk/MHpXb0rFFQ2Ue3hf8VMMYvMxgzW/+U8hFSA+ZMw8evt47maBSPklo+ysGa2dPKAmQSrzM3kmYCQAIA+l9l2rcGiXzxH6bNQcVV5x4A7jkeB9Tz2aMqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7FLkqftNhHlXOTs2DI5xeX2iT8mkvkwedQv6KFRSow=;
 b=lVm5ALBDbfiDAzWq93WN7iPBknhpurxk7+sgAGUIWEsONuFm3FBjvXBT8XOkp6WWXhSvzvVhyrltdz8EtSqnUeALCc0BZgXLjl3rs56shZuMmAi5Jt082QJev8le2lLDX0UO6I3Jj0VYQp7G9Bz5prjqsX0lJb+yU+64j/3sU2I=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Wed, 23 Sep
 2020 22:01:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:01:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Topic: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Index: AQHWkfI49n/dW6yWhUaSsyNzEyjVval2wsIAgAAApICAAALZgA==
Date:   Wed, 23 Sep 2020 22:01:21 +0000
Message-ID: <20200923220121.phnctzovjkiw2qiz@skbuf>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <7fce7ddd-14a3-8301-d927-1dd4b4431ffb@gmail.com>
In-Reply-To: <7fce7ddd-14a3-8301-d927-1dd4b4431ffb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: adec063b-aa83-441f-a435-08d8600c3526
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-microsoft-antispam-prvs: <VE1PR04MB737498686CC84CB50DF09686E0380@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BmRAaVNkpX8wgtNxCz8/KMQrnqAU/Qz+C/cpNPx9qzRrKADCUndd93h1p2B8VfvR/dgzWC0uCtfTqMZJS+4AKaz3Twxs6zXXUTcV4MXdvP9biPTaHwNpvSg4N7EwTh8FdVjV41tFc29RK5vWmHM+uPLqQ+6GEzoRNKtT9qlKTh+fQnDTOER/mCkhOg5ZakKAX+yKC6olCpYXOc8e1x4reTh1D35pkZg1sYdSGb6cYy/6v2Y0+g+pSjRDDjMl2kZkGcXt3xiD84cyN7/ZI87CQcjhdWJ1W33Gzn+pi0UnT1DtCYzDa0CJCP9qibv2oZIO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(6486002)(86362001)(33716001)(5660300002)(1076003)(54906003)(316002)(186003)(26005)(6512007)(66476007)(9686003)(2906002)(66556008)(4326008)(66946007)(64756008)(8936002)(66446008)(8676002)(6916009)(4744005)(71200400001)(91956017)(76116006)(478600001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LWPnqrw1PGsBU8/CnNXtUo+fzN3dKdcvPed4ZHasx+0ytVDOvW657ej+vcqrP0H9lCQiTet5g8uvpmWWbEpDPSUbPtc2eyuwLalLt4hqS/ncG7VrgQM8Q/pe/MEoqBYDN9rbehAtZ9BlAlpFaz85xGJSdavbILvTZUX2Evq41V+g4p23ydgu//FOdB2uDaQ6tNTrIxubx/PbYXWM4YPSL0/bftl9yXwfyWAFke54HXmu0Vc0oC7ciUB/Rvpi/OW44PzatiH4ak1jRHkrtsiGKoevHlTD3JXDhwWqSE6Jki84fmB9sOt+8tHpv1DTT1W6KpKfuLTW5aS5+0CwxXf73zi0tEcTGslheBLlTCRCzxBqI09ZxkKd0Szhp493oYuFzVmRA3Y+4qCVaVvBhBrNhc6wmGdoDgykWWDyjXmacajL6ZRiQZZFSxZskraft+vD1x54N7sF6EChdDQDjDHFHmxYPrXvRakPdQq0vbrucuChiunRrzDdOI2HyhZWus0YzvZmSaxoxWDe27by5zXPfd96xUmOLwucHeb+cVI/K9+U8qwdP9kbDEAmOUwwVreEbqWnq1+RccVXkNGQUD1f7KkuxNL5R08ExV1s9PH+BnYDoMbnGlWy7LTjYgqqz9L34rrwrK5ABK8RMKwXNVzCTw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E9AEABDAD0DC14DA9BB1F4BCBE2BBB2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adec063b-aa83-441f-a435-08d8600c3526
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:01:21.9234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpZs2ZYCnEyPlLIH04CCgqZnNt/8Up5QCiIZAXIgcn+VQQsO6++F7X6uRxaKIigSnTulSD1ttVjT4LXzgH2MCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:51:09PM -0700, Florian Fainelli wrote:
> Speaking of that part of the code, I was also wondering whether you
> wanted this to be netdev_for_each_upper_dev_rcu(br, upper_dev, iter) and
> catch a bridge device upper as opposed to a switch port upper? Either
> way is fine and there are possibly use cases for either.

So, yeah, both use cases are valid, and I did in fact mean uppers of the
bridge, but now that you're raising the point, do we actually support
properly the use case with an 8021q upper of a bridged port? My
understanding is that this VLAN-tagged traffic should not be switched on
RX. So without some ACL rule on ingress that the driver must install, I
don't see how that can work properly.=
