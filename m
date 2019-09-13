Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1E3B2681
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbfIMUOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:14:00 -0400
Received: from mail-eopbgr1310101.outbound.protection.outlook.com ([40.107.131.101]:29216
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730962AbfIMUN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 16:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx+RwSdxphrUcI9PZBZaZcXcAdYqqaXZYmgKgjvl+/a8i2DA+Uc0UzQO9XXAO3xWVRo+5WiXCi46bpKuUs42+Bd3Ns67fzw80D1waaWRzcbO2dzAtl84db8oRI9djcrFiMa2WtKv/CZsbI4SO5R9BkXATPkKL/ukfN/KBpjTm1Hnf+SFDoGbDlGpLrjlIpfWQt1TRJluBRcAIWh6KgSEfbtI2GXTd9O11oDBtkVlz1rAwMvR/XuNMBbkOKADxIIVFl+V50U/qAcRzrrXnXl9P2WxWIql3l+ziQFIDfmPD16lx+SYBPYvTIiacK9VaMgImqh9lHGO4rwkojEjMXh8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZEt1Vt1aGzamiHxMchWWEfePNe9vQOJzziJITgNIIU=;
 b=V6krcTCfEeeu15/fGTNCpuMxAdL1PcId/eqJLiNuJDzEKGS4eHYWx3s6prgmawd28N0Kv+B2IABfp542UuI5JfBwS2LaQ+L0Yb7tNqehJYasW4S0jPNGrjX9alTyDbRWVabFIpY/UluEayfL7Xx9j1hmTt6xmUegqyLWI7M9vbiGsXXmMTt3xdPW+S5Iv6ZAXBUecPiYMYdgsoekIDOWeKoICZDfXq+NVUjkcO+4n3cOZz+mkX9MVGM+s+2stP7qAI5b18r9wojRxqV1PGTEeyFdruNjgHZmv2DafY5pz4nZSk/WpKO+C/IKm8oFIL9V8wEg7/8Td/8rw0QYiQDa9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZEt1Vt1aGzamiHxMchWWEfePNe9vQOJzziJITgNIIU=;
 b=SZTN8S0NgZrjSyBhuJxwsk5TjF0VBJt2mTVPFIl/g3fpmG5B7QhnqJeKBiCtACEmIkLHgXHXXFbjOVdDMmFdaq2I6UDuW0jkNhQYNYiNakemIMWvDV68PA/qYM0tJB4FCd795+wbWlQchAgz7aktpFHoSgTHOZ4N8T+r90Gl+EE=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0105.APCP153.PROD.OUTLOOK.COM (10.170.188.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.10; Fri, 13 Sep 2019 20:13:51 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::3415:3493:a660:90e3]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::3415:3493:a660:90e3%4]) with mapi id 15.20.2284.009; Fri, 13 Sep 2019
 20:13:51 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH][PATCH net-next] hv_sock: Add the support of hibernation
Thread-Topic: [PATCH][PATCH net-next] hv_sock: Add the support of hibernation
Thread-Index: AQHVam5fuqnF5X0xdU6fz1Wd/qHCbKcqCTvw
Date:   Fri, 13 Sep 2019 20:13:50 +0000
Message-ID: <PU1P153MB016988B39370FDB76C365614BFB30@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1568245042-66967-1-git-send-email-decui@microsoft.com>
 <20190913.210343.724088723062134961.davem@davemloft.net>
In-Reply-To: <20190913.210343.724088723062134961.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: sashal@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-13T20:13:48.4838727Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3861a32e-9692-4bfd-8b02-1416e49afebb;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [73.140.237.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24b1364e-19c4-4f4c-1ceb-08d73886e4d1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0105;
x-ms-traffictypediagnostic: PU1P153MB0105:|PU1P153MB0105:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0105B8303424205B7A1930F6BFB30@PU1P153MB0105.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(189003)(199004)(6436002)(99286004)(66446008)(52536014)(66556008)(64756008)(66476007)(76116006)(66946007)(76176011)(25786009)(86362001)(229853002)(7696005)(186003)(22452003)(26005)(8990500004)(6506007)(102836004)(486006)(5660300002)(476003)(316002)(4744005)(110136005)(4326008)(107886003)(446003)(33656002)(11346002)(10090500001)(54906003)(10290500003)(6246003)(478600001)(6116002)(3846002)(74316002)(55016002)(8676002)(2906002)(53936002)(9686003)(305945005)(71190400001)(81166006)(81156014)(71200400001)(8936002)(14444005)(14454004)(7736002)(256004)(66066001)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0105;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t2F7Y+NiHrOXQdKk+VKJBL8wDawwLDlFbtiUcL6SBbWKwapd+jpwARZSypA0qhqCZU0/RyMkr/KFqeNB0UHmqed7qe7fskRkkMvgVFXe5ektGX4ge7tDxXqkRGYR6nd1Zy/s1scWJRNaxkueaTGjjaJuzt55wzVq3hpqFphSZvpqLZlomjN+ieeWuAvK70Q0vke9s4f/KK5l5mtYXCt9NDz0Vwa+WiSwO1Yu720TdL2JvaS9wRfko+JbcbsqFV/kgCTMumF6L4rjNbbIbt9OJ7QTpl+KQSxinNT5VbA8nSW6hJ99PPN3/H9ET4JhqFb8HVJ8GeYCyQwj5QlwLXviJNJ8XQD5DdmvSj+t8ilTsWdGAN8zaOBd8ZhxdUAyTEoJJEz4hdV22TB+s1lC7WdiLSFkOWKe/BWppHCsaFISRnw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b1364e-19c4-4f4c-1ceb-08d73886e4d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 20:13:50.8109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 60IuVhvwtqwakYwNwrTLXhM2jrWFUWcEB9cQ68cjctaZdY4buafwJgiha//Mv+tC7ylxgaKsvBGWV+Cp3MwMoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: David Miller <davem@davemloft.net>
> Sent: Friday, September 13, 2019 1:04 PM
>=20
> From: Dexuan Cui <decui@microsoft.com>
> Date: Wed, 11 Sep 2019 23:37:27 +0000
> > I request this patch should go through Sasha's tree rather than the
> > net-next tree.
>=20
> That's fine:
>=20
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, David!

@Sasha: I found a few typos in my comment below. I'll post a v2.

> > +/* hv_sock connections can not persist across hibernation, and all the=
 hv_sock
> >  + * channels are forceed to be rescinded before hibernation: see

forceed -> forced

> >  + * are only needed because hibernation requires that every device's d=
river

every device's driver -> every vmbus device's driver

Thanks,
-- Dexuan
