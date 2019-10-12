Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89679D501C
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfJLNer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 09:34:47 -0400
Received: from mail-eopbgr710131.outbound.protection.outlook.com ([40.107.71.131]:6171
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726821AbfJLNer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 09:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPF3LDQkkUXlrZI0jfUwiYSeAOh4iLH0ZfMjMs/hvidDNPX2pETLYjDdMVLp9Cp2434JGBS+QpazOudTtFas7UcY2amg6TRl5lsgWelVQvOzJPRKqPnNJu1jX/hgilSbnyKnQzrwWjeeukULhnlsuoT7L4equK3LL0CsCNDyJUjPwkiFaPyf7Kxuvcm6ZqMD9vrX6EhPLKWNKEffSvHn1nW6vm3wdkB8exKkHZPYPLi5gqvrf7laM+K96b21ep+1oBxjrhtxJC6o2I+LAWYkInDzUmXLBCUSVdaVIqr8NYmCslzU6H63QrERngtAf2478jdfrCSDfCVjimxYPX6SGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH/w4b4CpBH5KUC7U7bWuVURBaWNVFfwXlx+WFT8E3E=;
 b=JoHH4IohYXH96zVZanoYx84Blj4JjSMcPV0b3dp+4Mu0qSdFSTQ2TbBQlFSNJ7Pzjpxqu9EmEZX63KJqKaL+1yRXrK51O1RTUqk9P8FOYa+t6atVNTNXSoDqRokmprfNNe9Tqk2RccElT/ag4ybMAZke3U+YLSsgSbYdyztOYSQngTGaEQxBPWLjvRZnW0noBDLH7VWMza80whyvBGq7qYD8vjcsHp2CdT5vVQBtyqONcIiGbwhjq6scBL1P6XHtCBHPpG9rVUNyEidQtSccMI6C0yK439em8urSOBsgEvCaGhpLYa7SOVKRB4JeQOE7GuVaLjBcfKznsVx7Mo40iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH/w4b4CpBH5KUC7U7bWuVURBaWNVFfwXlx+WFT8E3E=;
 b=PmDfA3YgssYog1QvRVdyzoPajyANKFAL1i6/Mmir+ecXUQCd9LzbeV40c2oAqy27b1zHb0H6lEeEyt4bEJ7zOCAkybDuxqk0umSZ51HfNqnHB1KFvRSNhwj2PBywsie1CmZx525dDdKOA6NpZ0o5DX/I9wjLQc3uS6ZjWTWECZw=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0153.namprd21.prod.outlook.com (10.173.173.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.5; Sat, 12 Oct 2019 13:34:43 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.021; Sat, 12 Oct
 2019 13:34:43 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        vkuznets <vkuznets@redhat.com>, Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v2 2/3] Drivers: hv: vmbus: Enable VMBus protocol versions
 4.1, 5.1 and 5.2
Thread-Topic: [PATCH v2 2/3] Drivers: hv: vmbus: Enable VMBus protocol
 versions 4.1, 5.1 and 5.2
Thread-Index: AQHVf4HgvATy1vXyFUC0tQ1s264IN6dXAtzA
Date:   Sat, 12 Oct 2019 13:34:43 +0000
Message-ID: <DM5PR21MB0137ACE07DCD2A6BBEC83665D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
 <20191010154600.23875-3-parri.andrea@gmail.com>
In-Reply-To: <20191010154600.23875-3-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-12T13:34:41.4247170Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=916a6818-2ace-450a-b146-ae9113aeebcd;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4356966d-e236-41bd-9340-08d74f18f0d9
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0153:|DM5PR21MB0153:|DM5PR21MB0153:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB01538962C01FEA4022A60064D7960@DM5PR21MB0153.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(476003)(4326008)(6246003)(7736002)(305945005)(446003)(11346002)(107886003)(66066001)(486006)(229853002)(99286004)(74316002)(81156014)(81166006)(8936002)(26005)(8676002)(102836004)(186003)(2501003)(7696005)(76176011)(6506007)(25786009)(3846002)(110136005)(52536014)(6116002)(33656002)(55016002)(9686003)(5660300002)(22452003)(10090500001)(64756008)(66556008)(6436002)(2906002)(316002)(66446008)(71200400001)(256004)(71190400001)(478600001)(66476007)(8990500004)(2201001)(66946007)(10290500003)(86362001)(14454004)(76116006)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0153;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0HF94iEKqA7zor03WTbAhQ/KA/neANmNAzaYuaaLGKEl5XdBhiXjYUyhm5Tli2gTaRNyO3NFl0kMSS0qllZ0ebBg+kHYOXVbRG6T7LoUlxJj13UnuPmX0B7rbcPGO/WFEH27tlh6d/2r03piiIzxEsPpiTnXXB5Dc8XFc5kDl4pwz4iFx4Ridrg5vVctpu6q5oqRmUgGmZkjhGbGZjO4pq7A4ejH/qRpAt9RXutLttX8eBoz1SwQWz0mIZ0Lx1ZKleC3vzfFPgAhnIN31XM/iVSvcpTJrdqYVKN5VoESNk8CkHgjzsvGLIaglISNOkszvUS///cqARktAUayYErpTiivcsdYjP4gKZYaBvkmmeYHjQF4hQ4vBDjzBaQrtyNaBrjMl6WAWlFkgbuS+xhzOBlhEhKwEWHx85JTgpmxKZY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4356966d-e236-41bd-9340-08d74f18f0d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 13:34:43.4095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pKey32Y5jBBHmQgI7hmZjlpKZxPIUI4TN3U4HabIIpuW5Ft4uuK1sN84hn2kFL+YC/67ZAW0fA/kPfzRz0dfZ5ciI10S7LBi2CpIJbTlyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com> Sent: Thursday, October 10, 201=
9 8:46 AM
>=20
> Hyper-V has added VMBus protocol versions 5.1 and 5.2 in recent release
> versions.  Allow Linux guests to negotiate these new protocol versions
> on versions of Hyper-V that support them.  While on this, also allow
> guests to negotiate the VMBus protocol version 4.1 (which was missing).
>=20
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  drivers/hv/connection.c          | 15 +++++++++------
>  drivers/net/hyperv/netvsc.c      |  6 +++---
>  include/linux/hyperv.h           |  8 +++++++-
>  net/vmw_vsock/hyperv_transport.c |  4 ++--
>  4 files changed, 21 insertions(+), 12 deletions(-)
>=20
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index c08b62dbd151f..a4f80e30b0207 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -182,15 +182,21 @@ static inline u32 hv_get_avail_to_write_percent(
>   * 2 . 4  (Windows 8)
>   * 3 . 0  (Windows 8 R2)
>   * 4 . 0  (Windows 10)
> + * 4 . 1  (Windows 10 RS3)
>   * 5 . 0  (Newer Windows 10)
> + * 5 . 1  (Windows 10 RS4)
> + * 5 . 2  (Windows Server 2019, RS5)
>   */
>=20
>  #define VERSION_WS2008  ((0 << 16) | (13))
>  #define VERSION_WIN7    ((1 << 16) | (1))
>  #define VERSION_WIN8    ((2 << 16) | (4))
>  #define VERSION_WIN8_1    ((3 << 16) | (0))
> -#define VERSION_WIN10	((4 << 16) | (0))
> +#define VERSION_WIN10_V4 ((4 << 16) | (0))

I would recommend not changing the symbol name for version 4.0.
The change makes it more consistent with the later VERSION_WIN10_*
symbols, but it doesn't fundamentally add any clarity and I'm not sure
it's worth the churn in the other files that have to be touched. It's a
judgment call, and that's just my input.

> +#define VERSION_WIN10_V4_1 ((4 << 16) | (1))
>  #define VERSION_WIN10_V5 ((5 << 16) | (0))
> +#define VERSION_WIN10_V5_1 ((5 << 16) | (1))
> +#define VERSION_WIN10_V5_2 ((5 << 16) | (2))
>=20

Michael
