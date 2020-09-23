Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772E72761F3
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIWUWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:22:36 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:59701
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726621AbgIWUWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 16:22:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXVjzyAe3AZA/Gt/yUTvOnTkc4hBtECe1uE8mDo9xFcD+W47A0bpUMx9CHZ/qvv4fASVZdRVoetLj/3SK9miE67RY4QpmiIObb+Dlzm1x3Uc1KWOuk6eJAvdfGUkE+Yg9ft7IOUccZFSz+P+mpzdL9OsIXeHK/lImAHDd0tLKWzBLo5/EhSMqFhX4KVwOAYIsyHVORLL97SObspiNz6h0qAHuOxAcjPn/WTU9QNHnZFjscVBGk9z63yDsv3QcgvpJixCFzvpyCCFbfeXdpyg6EHk3q53h/ZnCxwdttvvUiqBL93qCv3TWOkjawOpjZVyCIuIvhm/qb9ZSxGOZHvQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjmDPLXK/Vvyuu/aCHisrMPpPrh6CtXwwMeVNhKEl38=;
 b=HbH6eeIvu5jRrv2frWGCy4FZURlj+zRmA4EXaos87Bqft38yLfryLcksLgPskcjKMAPzEkE1WtiuXaXgQgw9EVzgaTJoj8PHURz74l31TgCbwlNOBmpa3OhmaoTC898Yubc2EoFasIy0R3LLQv/BkDnkUKIPzbrtE9ndnPPxBATxbGUSmX4lbhM5wOB8AMh1xsPCYOx8SAtQKA+FiaQsxvP8Cc6HXVq16QuM13oDz1a7zT/Z3pS37hVyZulEZdzMQEBGtnZOdOPWR7d0cvNlpssX8F0Auyo/oRd1mlQvLaF6iGvfWiMomdVgZQW4j4LvYR/aKuz69QgpcIjXdjlsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjmDPLXK/Vvyuu/aCHisrMPpPrh6CtXwwMeVNhKEl38=;
 b=lcYqAsayq701cUuAmo2MlUj+wqy/RXvarMDOpsg6Et6f5piHFx8O3Dyg6iQkr3h0EcAY5DaYAXEyG5e3r8csrUOvEmiF3f8qS0ZAUhHMh5URdYyJwGUKYxwWI3eUdDlMPAal8AR8fNf9s1wFTAC7dz5qm9CEyUUvJhtbkzsFpMU=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 23 Sep
 2020 20:22:32 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 20:22:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Thread-Topic: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Thread-Index: AQHWkZwgfSWJjFtWWU2aMSGYdOEjdal2p0AAgAAEDoA=
Date:   Wed, 23 Sep 2020 20:22:32 +0000
Message-ID: <20200923202231.vr5ll2yu4gztqzwj@skbuf>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
 <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
In-Reply-To: <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97c88a48-9b01-4506-9c7f-08d85ffe66e0
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6941BD72878675143311DDA6E0380@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p5OJ28u4yzo76TCUnV5MdpLfBvwSNCD3/HZbSUKUy11WBLHSNmww3FByoVRNi9V3J8lM81Qz6Zt8SZn5/smg+SKeC+YtTvziEz+cdY0Hejp5lqiyR/Go0WBbm8YAXN7IiqD6O+vrGq5sDih5NilNOy1LAMrNM5VeOuBjN9ruIkmzH6hs4CIbJxBjLC47E3E6nNSnzOKaQtihDfVolmB+NJttWvpRhiSQeLDLeu/HN8LYLcjqXhjAfg5Qr8NBiKWK7F8o7BU9Wn+Yw0E9ZuLBOfCehxA97WGpS7TAFy2/QvrPj5HtyNSgeBJ8A+dyqjBqVhhLFN8Ay1UZCekZOHbTDzlsLGi93hYuJXhSy8S41VkD8fk4QSwTfOzk4ACNYi9G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(83380400001)(8936002)(1076003)(6512007)(7416002)(4744005)(2906002)(5660300002)(6916009)(8676002)(6486002)(9686003)(76116006)(91956017)(66476007)(66446008)(64756008)(66556008)(478600001)(186003)(6506007)(44832011)(33716001)(54906003)(86362001)(71200400001)(26005)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PgjiJrFXOvZ4ObXnnmN5/io1yTiO5KeGLz8+EI38xE6JvKWAwYEai4bbyFCEZDq6LRrkyJ51vJe7OL5yVYttCHF6jlWT3ZPhsAn6v8UZSGE++AqBgSYNosQuruL+qTvmh7qL/6awgBd9tRlTT1IOeF/xKOE39CyfVRvxhHg9JNaMtq0zHFcVJk63sFWXt1WwLD7/LohmRzHBzHIp2q/3eeSvDMOTgjyU/TG8s2jWWjfbt8jttrmWfPTZ5SidKIJ1vuc6+XCmYna8VAKL1+ZosSRSHx1tQxWMKoEN+CgsQlLgp5BVq5ydyfVMAcva0U5RZM7CujF7NJxWbQBCN+PkGMwUERQfJqS79415bOR3LPmDUT+AGe4sYxFe7FeEikpSrDtwgF45VPw0cnrWZHT/QAfHq1ORmdsreWrwndCA/ojcJntI7YOwPrqaZgRe9PoWovk1Q4KeBPmHRoh5x+W6bhFjjtnnK2NxBIlGcelO1g4Jc9fchyz0DJIWR3ph8h2yeA2GagCCY03lgK9oZ9dhlzHpJhOg14FM6IDlEdBziScbIJygOfV+JPK6NagvCleom7wNOvotPeGtEBMx481HSpmZC5mZDryucts8jyihJgBAIvbcnZHBBw/pN09R0GwvoEF9mzie5gbcCf4Gmj0wcA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25F2F3EF9EA74249A4087A61CF5E649A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c88a48-9b01-4506-9c7f-08d85ffe66e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 20:22:32.4753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKpKWn+7rqWiYDNzWhr/JhUr5sdwnyxNyO/0l6jYl5H8Ytv9dZwBTuBRxbCKWtRF00C6J894dIUPthywTO3uSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:08:00PM +0200, Horatiu Vultur wrote:
> The 09/23/2020 14:24, Vladimir Oltean wrote:
> > +               if (ocelot_port->ptp_cmd =3D=3D IFH_REW_OP_TWO_STEP_PTP=
) {
> > +                       struct sk_buff *clone;
> > +
> > +                       clone =3D skb_clone_sk(skb);
> > +                       if (!clone) {
> > +                               kfree_skb(skb);
> > +                               return NETDEV_TX_OK;
>
> Why do you return NETDEV_TX_OK?
> Because the frame is not sent yet.

I suppose I _could_ increment the tx_dropped counters, if that's what
you mean.

I was also going to request David to let me send a v2, because I want to
replace the kfree_skb at the end of this function with a proper
consume_skb, so that this won't appear as a false positive in the drop
monitor.

Thanks,
-Vladimir=
