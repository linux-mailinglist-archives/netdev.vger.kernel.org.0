Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD70AF067
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437048AbfIJRZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:25:10 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:50420 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394139AbfIJRZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:25:10 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2BEE7C29CA;
        Tue, 10 Sep 2019 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568136309; bh=Ph44MQ9XKynJLKZLZegBVnSuspU2un8Ep4rAHwifzWg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=FvRfTqKX3KWjbYYW2JNYXP2K3tStL7YMdXZwlAbCFjNpvhpdJEX0CkwmSO1/7IgHk
         rI0edlcJsqna284BtEItx8Ax7MouPcF8bvQ2A6ylJtMrIerYQ18OIseeAehgjJhedj
         Kv6/YglrZQDXI+q7rbPM3PKb5gC9vIhWT2GGVVyuJMXTDend7L94vTQbKBPn2Ujqkj
         hQqYT5xyVPobtG/f4bd9fzBURoN+ExaPS3Q5X4OAh0OqVdgoJ6l6M2Jk1LVLHf7H9G
         +3ZMgAYB6/7lTw5SdY9WL1lP4GWKsXe/WaN1vuGq2GVGwuCC/xlCKl8oahaMQmwOA7
         68zvUJwHf1wCw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0152EA00E0;
        Tue, 10 Sep 2019 17:25:08 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Sep 2019 10:25:07 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 10 Sep 2019 10:25:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ze1UUEJgjgp8jfcddWgUY6dSJGeoNEJt/p+99he3pGzzY8pXlzeLaqPPR/Es+gXFi9pnqL3lKVUA54/oIV+Xte3s+x25lan2ohGpxgDrl6QZqoIV0PxN/5cRB4pVkz9rgKpwF73ByRxF9Vmwhbujm5oMRYkNPYng4eQwgXaGRwAKzSO8i6Y5Oi7j/rSJN4dVBAgXJ0DolSkg78u/LcpYE0f3G7IRd7DWZitTgVYnNCuH1YC6METqbJW8dgSmiqYVJpexfCc6CqMmE7JeUpPzKbIO/GmG5GpGtRS6QxrOSM0jkO5OuY3us1hd58+Jy/TI+a1p4GP4N+PY1De9K4gaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wafg6W+0oC+Np5oCZtVdaq1sWgMBCBkFiLQzU0E8YJo=;
 b=mubBN7GtkfLJ03YuUBrWtAlq8rQv12YrDki6bIcAA7qmIiUAqMRJRZg3unAojRNHGa2W1dfuHye5BWZXV4yledtKp+4bjOQiZ9GTTXL1994Lc7ICfWcGDmhMSyEictOybTp2zEVwvsioNFup2QdbArvShwmimz6TuFyli0xKFwzwSPVkZPONHF32hl/D5JccUOU2Px7ajrCSg7D6IR4mzoF35WvwH9dzJLiY091ZF6krxRhS0nREcOv7jgYO2V2ZmtI0JD3/oqObYuXqw1bQcvYsKPBF1Hm9/00/A7p0QGAyivEG1vIUmGmTNmUltpv5QUF4AKH+FVCDD4aWmNWL6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wafg6W+0oC+Np5oCZtVdaq1sWgMBCBkFiLQzU0E8YJo=;
 b=R/EU86FGiQmr+AsR3wIH7GX1MMwuAN2tgsr1MYOi5e+xtZdTBiT+60XvYIXrEdY2eDRHNwu/4aU88eG9Me+lY0AKF1/YykIaYycruYandzIJTNxIxA8wvSOYQhNJIer/xPRNlwVnmtqMg+f7Yr1HFvM/nRhOjwwo0ekMFVGLa40=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3364.namprd12.prod.outlook.com (20.178.210.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 17:25:06 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.005; Tue, 10 Sep 2019
 17:25:06 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Topic: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Index: AQHVZyLsOFcggZ86CE2HdVeFQfSucacjgrwwgAAzwICAAN9oUIAAWluAgAA6FBA=
Date:   Tue, 10 Sep 2019 17:25:05 +0000
Message-ID: <BN8PR12MB3266DCD09369F3682CC38690D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191127.GA23804@mithrandir>
 <BN8PR12MB3266850280A788D41C277B08D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190910135427.GB9897@ulmo>
In-Reply-To: <20190910135427.GB9897@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb3dac81-51ab-4066-0c07-08d73613d28a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3364;
x-ms-traffictypediagnostic: BN8PR12MB3364:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB33642B26C76E099F6B4B3B35D3B60@BN8PR12MB3364.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(39860400002)(366004)(136003)(189003)(199004)(52314003)(81156014)(4326008)(99286004)(6116002)(3846002)(6246003)(14454004)(6436002)(229853002)(2906002)(486006)(71200400001)(66066001)(5660300002)(6636002)(11346002)(476003)(316002)(110136005)(54906003)(25786009)(446003)(76116006)(6506007)(102836004)(53936002)(186003)(478600001)(74316002)(33656002)(7696005)(55016002)(76176011)(26005)(6306002)(9686003)(8936002)(71190400001)(81166006)(66476007)(66946007)(66446008)(64756008)(66556008)(7736002)(966005)(8676002)(305945005)(86362001)(256004)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3364;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zTuToCsPTzoMv2HZQnQcC1U71KYFLm593LtKx2JUrOI6R1tHWkMUC/x+RINyVeea34BNT9YmpPhd+lo+HuwtcdRYZp/uEsBT94sbiwJhudflwOo9UcdfRw+u5x+f7uVK1z6P8PV1zEMfiAx2Qr5odrsR5Xy7k5YloN+vPrcn333TMyXiFr4A5nAuYJyN9bWGYbmYuk2wVIjS+9qL8E2uevjvTtoMhT7CLORPxevSAiZ4tmuAgijCJ+BxS+v4G5TQParcnhKFyulnOSJ0F9IbPNK3IBrTR70NGcsqAt+bT+IsF/KI31VxNJ+vrw8mn1n4mihYSLLs5Ln+30m2hoOd5cEEkhOBoiTdLxbLzNHinlFiKVEyZpWeqUJ3d1jew4ss08wiOoeXZvCrJ3/A+gWGt8q8+6E7nm1it69vOe3u7jw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3dac81-51ab-4066-0c07-08d73613d28a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 17:25:05.9126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SDawYLyrBc6r+uMPfHOUWtW9nbO7lHziVF1RElWadYLwMEXZxHwi9sNf5btUbB5BfTO7wZCMUQPe07MlffX9dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3364
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/10/2019, 14:54:27 (UTC+00:00)

> On Tue, Sep 10, 2019 at 08:32:38AM +0000, Jose Abreu wrote:
> > From: Thierry Reding <thierry.reding@gmail.com>
> > Date: Sep/09/2019, 20:11:27 (UTC+00:00)
> >=20
> > > On Mon, Sep 09, 2019 at 04:07:04PM +0000, Jose Abreu wrote:
> > > > From: Thierry Reding <thierry.reding@gmail.com>
> > > > Date: Sep/09/2019, 16:25:45 (UTC+00:00)
> > > >=20
> > > > > @@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
> > > > >  	int fixed_burst;
> > > > >  	int mixed_burst;
> > > > >  	bool aal;
> > > > > +	bool eame;
> > > >=20
> > > > bools should not be used in struct's, please change to int.
> > >=20
> > > Huh? Since when? "aal" right above it is also bool. Can you provide a
> > > specific rationale for why we shouldn't use bool in structs?
> >=20
> > Please see https://lkml.org/lkml/2017/11/21/384.
>=20
> The context is slightly different here. stmmac_dma_cfg exists once for
> each of these ethernet devices in the system, and I would assume that in
> the vast majority of cases there's exactly one such device in the system
> so the potential size increase is very small. On the other hand, there
> are potentially very many struct sched_dl_entity, so the size impact is
> multiplied.
>=20
> Anyway, if you insist I'll rewrite this to use an unsigned int bitfield.

For new code I would rather prefer "int" but I guess it's up to David to=20
decide this. I'm okay with both options as the check for this usage was=20
removed in checkpatch:=20
https://lkml.org/lkml/2019/1/10/975

---
Thanks,
Jose Miguel=20
Abreu
