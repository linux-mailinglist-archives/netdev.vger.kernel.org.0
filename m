Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121DF27189B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgITXdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:33:47 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:31744
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgITXdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 19:33:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AElUldIf2ZC6p3TYZW5MpJv6PQPJSKwESZiHURGfQqi/ZhNb8DMUTp6ZYrmDxhHPbqagVSPucLmnvs9GbK8HmAT/s4pWhpVoCFP3A6ibh4GrsNcPi7XHxdt00XAQt27x/UN+BXjs2tT+VDbyKRDnbwDKFHwaOr8o0sOJ2haUCCKcYJXsvTQVlp0X2Ssihp5OJ0QsKLrixA66bodIQ27KI+hctcybnwryGsgvYC7Er08allxbrrM5udtKpZlNlAglIh2mAnp0V58jPIybR3kD8+gkiax42+7BioLeXbokfLxILp9tR5L3Sditw1r7h0y+iqXZv7jAaQvExPw+FLejHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzfW0e4+rkbOPnVMbOi0o+6Pw1KZGQoGuwuGz7N7UYw=;
 b=ng1KneOzDPKvuMGJdTCXra2x1eDIMQTs79VTi9kViUmRr+BYtdMTDw6XSiQi2KxO7l8vQINsxyef0q9Mu+3EjwxIw7dtHzVoNFIAiujzhAienOhfZ2bUaXLpJ61rN+e1yvcVIK/Zr2U/T7GZA2Waczkpnkno2SrF5iaRHg3LStckgPP8R8Fp9RFtgU8BTAXsg0QZuz9gmZR2c5xL/xN8Qa2+0zRbegzREeFEKVZp9YjO9fi3nurSfUts0yFSVQUdacvRKiT22kUI4Lu/rGL4GuX0YIJrTbOD16unWkGrPA7pdAUhHOYqp/t0hHnblmwzYAatK11YiGQoVQnARG05cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzfW0e4+rkbOPnVMbOi0o+6Pw1KZGQoGuwuGz7N7UYw=;
 b=ZIdZTIT+VKl3/6flXI6sh7yR/U2u899tfNWa2JEURIS52DjsCuFbfMO4BO2mVuf+wf/AaSmZBRirBg0aOed0bNfmDKDB0lG5el+Yq8krxJdAA15dkOC+3f8Ala1xeqK2+wSW6GrYkCunJFtC8PradXTNdhgJ0noUXbp2f+531WY=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Sun, 20 Sep
 2020 23:33:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 23:33:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 0/4] Add per port devlink regions
Thread-Topic: [PATCH net-next RFC v1 0/4] Add per port devlink regions
Thread-Index: AQHWjpNShEuM6J40ykCHBdk1HVwdsKlyL8oA
Date:   Sun, 20 Sep 2020 23:33:41 +0000
Message-ID: <20200920233340.ddps7yxoqlbvmv7m@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
In-Reply-To: <20200919144332.3665538-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1f50bc29-edf7-44d6-3413-08d85dbd9bae
x-ms-traffictypediagnostic: VI1PR04MB5133:
x-microsoft-antispam-prvs: <VI1PR04MB51333E7273BAF984208C3646E03D0@VI1PR04MB5133.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c7dxrqa26N1E6/WZNm4vLToO4lBpLI2AbqhExQZdcuHEj7MPhJiMS0kG6lj3TnN92SXd/pQHJnlLOrpWJPuzT74NJd/3llF/KXTr68v5yUA/IdBHwnY4BrGhaQwEYc4+Frc8fPfZqtVBWAD4oqHN/rctbYWBD9WxAFJCZlQLlkeKQVDlEH4qAz4qn/LHg/zpfzCSPdIIwf96AN0bIZFb8bPbEALtWMarV95lWfVDptN5go9A4Xl1vFm5VFQSHLUtm4Aj64Q7bcjwUuf4a6NLa4OcIF2DMffBr/glJOJ3IjfZ73SGwro3w/MFE9Mv7XYBYZfDkU0o8OCP8yKUmjZa2HTgt7JrO3V9TzYlcibqnxor44NDPRj3f61xxBKEM+vE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(71200400001)(83380400001)(33716001)(66946007)(8676002)(5660300002)(8936002)(76116006)(1076003)(66476007)(66556008)(64756008)(66446008)(6486002)(6512007)(316002)(54906003)(2906002)(6916009)(86362001)(6506007)(26005)(186003)(478600001)(44832011)(4326008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jsEF9wfswHCGCLzztRkpHJwEnyX4SiFME5t3q5tKn8zOj+sIT0eQImAOCpNW7CnurBoSvKvAVy9FUOfs3o7KAKQWGf8fjeh7J0Tb1YRGy5FhjK8l9f/yHmHtNHfLRs50OFNk/0/PRmY2G5RlEo/0Am0NwYzU99xRB6HRVrqilSw06k5gh2lJ5L+1mxc0UBQGZkAlOtSXj/aSpLmFFgRSeeIQvkqNDcQPzUUM3MKFAr8Yvhu8SHcHaufqfBJRaVtDtppWw+h/JSZMdHIY+UC5DUbxEtBxDPWaOFd4wnffzuNDH8fxfkZSkvZ8bl6MhTBkoq3DkIPyNm5Ne9/RTaC+UG6+urwJd+UXn2WMChQ9ldyv6s9DBSSvwAnQFmC4s/nqHDKRVugJC/2atexcW/8DAnC4wgiaYHt205ivEqdW+1a54q6YhLvRs8Y4K5ZiU3Wz5gfofUJslq+09rlrB1lO1BPS8ONkfnlpaRa4c1a85d24+0qzlQs98ctJOf5XFQH1LXjscbX8wbnmYQjd001Vm0CQB5Y8JJua0HQyYh/42vkhm1CDAs04Oqmti0upO/AffdVs/vOWfA464GnXqeXcbrvf/C9GQvj1KUjpFuKdeVy4HCDAwsb8O89qzgpBuSvUX899dAOhlVUZpHhaZ9FbCQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4AD85F00E1F81F42AA3D30AFF2B10049@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f50bc29-edf7-44d6-3413-08d85dbd9bae
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2020 23:33:41.4672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VX4K+lwLIY+Q1lT/hGie6hpVr7QtRLxMS2wWbOnd2OFCBErwryfIA88OCqJo7HgEb4T4ZK087SpURS46CdyoAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:43:28PM +0200, Andrew Lunn wrote:
>
> DSA only instantiates devlink ports for switch ports which are used.
> For this hardware, only 4 user ports and the CPU port have devlink
> ports, which explains the discontinuous port regions.

This is not so much a choice, as it is a workaround of the fact that
dsa_port_setup(), which registers devlink ports with devlink, is called
after ds->ops->setup(), so you can't register your port regions from
the same place as the global regions now.

So you're doing it from ds->ops->port_enable(), which is the DSA wrapper
for .ndo_open(). So, consequently, your port regions will only be
registered when the port is up, and will be unregistered when it goes
down. Is that what you want? I understand that users probably think they
want to debug only the ports that they actively use, but I've heard of
at least one problem in the past which was caused by invalid settings
(flooding in that case) on a port that was down. Sure, this is probably
a rare situation, but as I said, somebody trying to use port regions to
debug something like that is probably going to have a hard time, because
it isn't an easy surgery to figure the probe ordering out.

Thanks,
-Vladimir=
