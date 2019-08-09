Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C89886F33
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405347AbfHIBQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:16:28 -0400
Received: from mail-eopbgr1310134.outbound.protection.outlook.com ([40.107.131.134]:44410
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404985AbfHIBQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 21:16:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5KHzKDeee8shw+MSNtrHEmkO2JovDlqwq5ByRgk/DPHMihRGSLeF+mrAvszYqgEY5N99k52LC17Bd+XgEEWveP6nRjyEiXvblUo85zASYQljyHIu0vDdkS7Od8oq0ga7nVw2fWTEKWsBQpb9i9H6WRaaiDfEpSN9YU3MobFY3zQ0U+gh5NQ1NSLXxy/IOTv7YPszrtLFj+f9S9EsPBQrZzOpQ8lmioL6QI+dtzJ2hyCqFxQVsI7Pe1X0U4J7Gvw0MpSjZ2AeBYD77aKy+poPbi187XGWj7inCA5a9zRWJU8fnLiFdwDWMzXN/RhrmDxJmf6dCWZHQYEOmXj4giFRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/KFFF8I8F5vWqJ+gtFvkdL1t5UTAKiMHkWiKpUIfyc=;
 b=FObFYv/pnt7xPR2yPAJgrdEwqTVFbiD3CQYw6PWI2BOQxgO6vr/6BypL8CauYGDixQvrITIA3ckTm/cGAG9Gezv76JeyIj6I7u2DbLfZ5Gk1JhM2qrLAJ1/qvQRtmTqkEuWz9bw95E6Nmib3ikFS1UnH3FDblwkqyT4mjZav8wnXI4X3C1YoJJhxH8nQ+s+1fUSusnaJ6DSC8jLtihlJuiHb9isZFfe/d788HDYh3qGCfUGKT/tauquV+Psfnss4NiHpj6qEzJNDNY4EwtLlzlLfKH4z2V8pEfhqgnA7MNcna76N0s84YmhXEtmbKMpPersvHK6L9j0BVh8oMByNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/KFFF8I8F5vWqJ+gtFvkdL1t5UTAKiMHkWiKpUIfyc=;
 b=TdIoBBgonCF+/DmsmcniuhzMrx4o8wCEyeHYCjcLSJjv/jvWVHwo00GhGVrYSNAhp6+3GNCDnfSE1NDpdKOM3Z1MUXlj8jtVVbdLWETyc/21sziUm68d9y4GNuREK0ASxatkpWWSKAaEYRzMmbHAktuZDaMx3fgRKm+9Mf6Ypho=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0108.APCP153.PROD.OUTLOOK.COM (10.170.188.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Fri, 9 Aug 2019 01:16:01 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Fri, 9 Aug 2019
 01:16:01 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: RE: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Topic: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Index: AdVMFVwGFODpycnVS02FuESxq+YKEgCOleUAAAAOXBA=
Date:   Fri, 9 Aug 2019 01:16:01 +0000
Message-ID: <PU1P153MB0169755705D5291E5E9D3A03BFD60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190808.181350.1331633709956960086.davem@davemloft.net>
In-Reply-To: <20190808.181350.1331633709956960086.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-09T01:15:58.0388211Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b3c71bd6-6461-425b-aada-43e5f758ed2b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:c9b5:49d6:29e2:b6ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d459aa6e-6b04-40c5-d718-08d71c672471
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0108;
x-ms-traffictypediagnostic: PU1P153MB0108:|PU1P153MB0108:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB0108E1F6247F1D209D05FB73BFD60@PU1P153MB0108.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:483;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(189003)(199004)(11346002)(478600001)(14454004)(2906002)(22452003)(66476007)(316002)(76116006)(33656002)(55016002)(8990500004)(9686003)(229853002)(14444005)(256004)(7416002)(6436002)(53936002)(6116002)(99286004)(54906003)(486006)(86362001)(6246003)(7696005)(8936002)(7736002)(52536014)(74316002)(4744005)(81156014)(10290500003)(10090500001)(25786009)(4326008)(81166006)(5660300002)(71200400001)(46003)(476003)(186003)(64756008)(66446008)(8676002)(6506007)(53546011)(6916009)(71190400001)(446003)(305945005)(66556008)(66946007)(76176011)(102836004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0108;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X0/UGWbnypCoMU7n72D/EMJeIxlJD11rMpoMgGx43kprKK6IBJ1BdM9v9HNGVHrl9rWbkIrXJ2Ul+5lVNQ45YdTs5Gelkhq6RGgiSdjjS661uyFavhNKRw9ZT1YB5K2KiYeKHcnJCzfmGUA4LgWAcbZmkEus0mPtj9YP77pt4yJngCxb3Har6WXXozdGCwBStkKLFjTwFksNWS8bAlqxZYk42K7bdhcPEad9hKEv/MTgXfL2DbCVNSMci/J9PKxkMvK/nFyhQfqXDH/wGplOX+9JuLL+RsSFLTMz5ky/Geb7N1sn2itNNLkiLxupqzXizrvW6njcKsyOmTqCdTRWDRcIxwhct7fD5YL7Y5NYwXZZ69SeltD4o8eAC0db+5Cz61kpkSUmOEfkSDoueXrA8U47IhaF4imc+GJ0iO5cc1E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d459aa6e-6b04-40c5-d718-08d71c672471
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 01:16:01.0646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xYreHWKSr9JxAEA+Vgw9bJLnyA50YB6Nn4QNmHspzWg3zd7IgbyjkaE4zRvmZp0Hd4c/45OxgL9yIH1p3/5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: David Miller <davem@davemloft.net>
> Sent: Thursday, August 8, 2019 6:14 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: netdev@vger.kernel.org; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; sashal@kernel.org; KY
> Srinivasan <kys@microsoft.com>; Michael Kelley <mikelley@microsoft.com>;
> linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.d=
e;
> apw@canonical.com; jasowang@redhat.com; vkuznets
> <vkuznets@redhat.com>; marcelo.cerri@canonical.com
> Subject: Re: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
>=20
> From: Dexuan Cui <decui@microsoft.com>
> Date: Tue, 6 Aug 2019 05:17:44 +0000
>=20
> >
> > This fixes a warning of "suspicious rcu_dereference_check() usage"
> > when nload runs.
> >
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
>=20
> Please resend with appropriate fixes tag.

Will do shortly.

Thanks,
-- Dexuan
