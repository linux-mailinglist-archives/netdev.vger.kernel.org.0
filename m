Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903CA279CE0
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 01:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgIZX3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 19:29:10 -0400
Received: from mail-eopbgr150109.outbound.protection.outlook.com ([40.107.15.109]:37535
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgIZX3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 19:29:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuwVJVHwOFtqdldYyKSHlUedZc2LO6uieAhWyJdDqClLYgSjTqoPnftC7cM0hggU3O4V02xlhB5kC5i9n8xjDCcglWGTtMTprNkYVsXOMqS05gEUyWJvWIHltiu+zVig0I04a4xtqZHqVb8ZrmPU6kTue2VCg1Qo+exFpeNbUc2LkvTz3jHFH3bW2QEtAj5jkYC9w61rK0r0lDixSeiyWk/8OEMzhMicBIOd044o+FPITdabmqxkqSoybgomqm02tl5BevezW6GrZ9n4MWMWuciF+K/DvYiTooFJYSHFtvm2WxM/t4PPAbafv6UkPbrfhkVvSsW9hHfiALTSy/j1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBDEpOizTekhT1+QVXTc2l0/jzu/zRaZfVpO3+hkQlE=;
 b=aBXD88wVed2fGVtVO6RA6XZ1N6TtsCaPS6Wi4aMXhe8l3KtKV17RVjLmjQq6P+933y5qmpgxi5HaRMG+cyVUi1JNPWhhGF4+8a1eW3UEqxrrZlCbaXyFnnIjIRu9LPtO12V4P3Qg8QPncmWGMjVrABbIC+DEUOxfhOc4OcOvxs5vFxNNgxjBW8wbNMM8Ke3e1HRcgyNyicvM6caEpC2zB0iMBcWuGIc4/3pP40pgvPP6hOX02eMQ4oVsN/adZNVqtKpkPhS9OpawOVWs73DysX9tqpL4Au/YYoQe4qr/BpBMKOXnxn/o5uRODKH+r6GV+RkQv9HSCe/3C/QvX41YfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBDEpOizTekhT1+QVXTc2l0/jzu/zRaZfVpO3+hkQlE=;
 b=ThgvqiWnucTUoZuKle79b/zeKttLvatSLY9SYS0qwB6JA/pPESyF7UpNx0q8OMtm5GgPOf2y9uXkKm/cqg6mH/skg534ILTa8GIcujRHw4MdkFz+LrvyWFM/2sMBuT8iC8BaGBXwHuVc3cjeeKvlILM75wKDvXrLfMsq4xyPNyU=
Received: from VI1PR83MB0477.EURPRD83.prod.outlook.com (2603:10a6:800:194::5)
 by VI1PR83MB0205.EURPRD83.prod.outlook.com (2603:10a6:821:7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7; Sat, 26 Sep
 2020 23:28:58 +0000
Received: from VI1PR83MB0477.EURPRD83.prod.outlook.com
 ([fe80::a4d5:60e0:398e:74b7]) by VI1PR83MB0477.EURPRD83.prod.outlook.com
 ([fe80::a4d5:60e0:398e:74b7%6]) with mapi id 15.20.3433.028; Sat, 26 Sep 2020
 23:28:57 +0000
From:   Matteo Croce <mcroce@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: marvell: mvpp2: Fix W=1 warning with
 !CONFIG_ACPI
Thread-Topic: [PATCH net-next] net: marvell: mvpp2: Fix W=1 warning with
 !CONFIG_ACPI
Thread-Index: AQHWlFzOu9Co4U3Cf0GSXJkcud0n6Q==
Date:   Sat, 26 Sep 2020 23:28:57 +0000
Message-ID: <PR3PR83MB0475DE959C4C67541960B685D4370@PR3PR83MB0475.EURPRD83.prod.outlook.com>
References: <20200926212603.3889748-1-andrew@lunn.ch>
In-Reply-To: <20200926212603.3889748-1-andrew@lunn.ch>
Accept-Language: en-US, it-IT
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-26T23:28:55.408Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [5.95.179.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c2db3e32-6c18-442a-7063-08d86273f0dd
x-ms-traffictypediagnostic: VI1PR83MB0205:
x-microsoft-antispam-prvs: <VI1PR83MB020599119BF17B1CDEBA756DD4370@VI1PR83MB0205.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVUJl7ofaHlvbP2BAOHdsthc4wnWXiUT8ycC5ahmedG9iFFT0kiz48i2YUNj1J3eC53VaJeKymr7BjFQ7BVgaNnzetW18jmUdFPfww9C4ELNPv1YWBa/gIlZLUkTkDNB1thAVrDPFyf5Kuyo3cDGVqIwppBYkDH2mOUEoWV40h9WGn4FKCYGP1cl17DZ6FA4fYVMk+tjjTzmFYK5qfeLG/C/gZFW1R8J9nv4on10pWnyLZMzutub0VFK9McUdaDorp1yqRhX7mXdDyFkHcn7FQyJMHlsybYzRJhLcM9Qy1d4F89tKidNwRemm2CsMROeveD0vzD95gn3Yi3JtvRnVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR83MB0477.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(83380400001)(33656002)(6506007)(2906002)(5660300002)(8936002)(478600001)(8676002)(9686003)(186003)(316002)(26005)(6512007)(10290500003)(110136005)(52536014)(86362001)(8990500004)(71200400001)(82950400001)(6486002)(91956017)(4326008)(66446008)(66556008)(558084003)(64756008)(54906003)(82960400001)(76116006)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: etfh1OX0VKd9H2as8gnvBfp9NEs2nytHQ8ZUP1x0fD9QgfyNvrAtyVD+7Z+raAdcrxY9TxY74h2LvK2ZCjH1qxPwKlKQOOSBU81rsk0NmYYMIkagTbJpC7VtzAtYLmWiKcnZdzfkKXgNMtJoLWOY05YU9p28Knhpgwa+4JM4rRqROQCGjwsCWaBATWWKXTYrKm3lhX77WnbajmGcl5GD2HkpPC0NcqzjIXs8OEhQuDFoyfUazmRyup1l6OCp0FOrqE3nnDQpqfZak6Xwm7R+adMi8Jd5+/F/rqmBC5UYh/1yKrbAK/v/fLhPZXgYhh71atkEpKzwpp6pJGXDyT0SI4ToeyTa+U421G1qzUnJCf/DlkZC/OKi84FHUuwmGc2GdP4Aod17axfPJ2Dc2mMcuOW9KBf+hIf5FRikgwIwvUkPs/XuSZrCxoNLhF5riLtWxKByNY9HegFE1dOA9t2252zgv/HDs6oD+aCMhojKUKs8TZK9HAFLW56zKH3KZfHZo7JsGR8W2lz/w1rZE01R6D3n4qEr5GpRHGWK41oNST83QqFLRna7g6no543/FVCCJTK18X1oxF86+N9ssOxYxA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR83MB0477.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2db3e32-6c18-442a-7063-08d86273f0dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2020 23:28:57.2052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rSm1s86nIFN6p9drHVLv+wkrc0L4oGoxGxcG+/gat+ySa9nb/nlMv3V1izgRD+8FdTGGGdx7LHHKwvYm2fU95A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR83MB0205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Andrew Lunn <andrew@lunn.ch>=0A=
> Subject: [PATCH net-next] net: marvell: mvpp2: Fix W=3D1 warning with !CO=
NFIG_ACPI =0A=
> =0A=
> Wrap the definition inside #ifdef/#endif.=0A=
> =0A=
> Compile tested only.=0A=
> =0A=
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>=0A=
=0A=
Looks good, ACPI_PTR() should be NULL if !CONFIG_ACPI=0A=
=0A=
-- =0A=
per aspera ad upstream=
