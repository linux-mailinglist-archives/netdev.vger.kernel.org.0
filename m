Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648B623E88D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHGIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:06:57 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:40694 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGIG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 04:06:57 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2d0b9d0000>; Fri, 07 Aug 2020 16:06:53 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Fri, 07 Aug 2020 01:06:53 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Fri, 07 Aug 2020 01:06:53 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 7 Aug
 2020 08:06:50 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 7 Aug 2020 08:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4Eh7RrxddgLodAuvB//cOYB4+e6YSn2M5iAOrLsrivpfc+yHX/bDqjpqXaoA65GLD4/3ycA1c6OfA6nv+ru2MaQ3COTtsduH/MDpB06pYCNLYDYXBThug9yHltm1ui5mmd4+3fWjVJLmbq+XgiBqrBDUVzFLF30uha1+IlL2qRuDt3+vPK3eg+7sOKCqFi3RxP3sdDc73GU/vZwmPSzYqRVBLv5NKhvUNRxedzRYJYu2g5/t6Xn8YnCwDN46weFqVfNf6dHz9qEvt6wzkz/pUudBTGtpknUFirIvmzKbukDnFO0lEJwQvb3jSvwyM4IzJjptMjR7ggmb7NOZOsgUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69Pgf2YAcEJwv8mzzuliq/NXwSm52cCm33prjL8rtww=;
 b=BJgJOwjVPsYIn9uCWcgthuvCCt2pYKZmr/DtfK0myRFSFZBVfFsJPCV3DO51OxFCOCbE75neU6t9wMZaBrdrM4Ru6h66jGBsS+aYuYhtjtGkOVV9MJvOpEvKlWhwYujFOhuyBjYQbG+p05DLD9xbu/v/rNzy1Y2KLfd7bAJYhCWv53Xjd2/31WDtX6rYgcy2G0jk5hIv9+oSVgcm+QAztJYiNisNkKdKjUyGScMum1U6sQIXRnk+8/46moAXE7SRkY3TiUuaWmJkWAQPooQBlI09cjMM48eCepXlhJTkoDJg9w19GE8ypXamyTDhp81DhX94vJlG4UimhPgDOq0Zrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CY4PR12MB1845.namprd12.prod.outlook.com (2603:10b6:903:126::12)
 by CY4PR12MB1174.namprd12.prod.outlook.com (2603:10b6:903:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 08:06:47 +0000
Received: from CY4PR12MB1845.namprd12.prod.outlook.com
 ([fe80::19e0:4303:2714:aedc]) by CY4PR12MB1845.namprd12.prod.outlook.com
 ([fe80::19e0:4303:2714:aedc%3]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 08:06:47 +0000
From:   EJ Hsu <ejh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net] r8152: Use MAC address from correct device tree node
Thread-Topic: [PATCH net] r8152: Use MAC address from correct device tree node
Thread-Index: AQHWbI2ZJMaQdnx8B0Wis8EPhOxCUKksSTgg
Date:   Fri, 7 Aug 2020 08:06:47 +0000
Message-ID: <CY4PR12MB184516578554206588482E2ECF490@CY4PR12MB1845.namprd12.prod.outlook.com>
References: <20200807073632.63057-1-thierry.reding@gmail.com>
In-Reply-To: <20200807073632.63057-1-thierry.reding@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=ejh@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2020-08-07T08:06:45.0776304Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_ActionId=a59ed5e1-b69a-4895-8b29-b01408fc699b;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [59.124.78.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06beff04-62e8-4d4e-fc51-08d83aa8d50e
x-ms-traffictypediagnostic: CY4PR12MB1174:
x-microsoft-antispam-prvs: <CY4PR12MB1174FF338DA55CA05DB05464CF490@CY4PR12MB1174.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4yN272zNmjkGEfGDzp+pv41Mn9mo9zo45KegHjKl+yJT5AIH8NhDtrG7vllIcmqwR2TJ/MVZRyqjPZlvt0/EoauKtb89qsmvr1Z4Tfvr89UfgSFyrSvE93k7NmcamJqw9dIEElsz2cNrFeMVD8aswTO9svBmmBxmLnTL/YXIiRBqKRLPwLYLV9M5lQswG65yilAZ2+gkn8HlLXKwUN19GH3LuXT0qSjZDZbMs6wQb6SC4F0qvaK4TkPAABxWYI9cf6m4xo7n0OQY/4C88DfJMaBjVqDtAg9eykbT1/8tcc1ybtw35hwjqEtaVSPAn6EYCnfdqoHgLW/apA4VMjs/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1845.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(9686003)(5660300002)(33656002)(54906003)(4326008)(26005)(66446008)(76116006)(66946007)(83380400001)(71200400001)(8676002)(66556008)(64756008)(6506007)(55016002)(186003)(8936002)(7696005)(478600001)(316002)(2906002)(66476007)(86362001)(110136005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AYzPLSTysME8emFmK0HO9gmBoujNVTnjIIsjTB8e7l5BxZecIWPZxWrI+k2FnxUTqqEQmmk+tBQLiIP8WLaxImYw4O/N8l+H4YZi93vrhk7DgtDhyzEobOUaGeREfLH6ly3awTqBZy8JvN3VCY7MQuZa+XUgHUFc4+j8k+vUhOnl3+wf+V1RS4/Bn71cWXqekApcVLYPHOIKYJ96QMMDQSEPigadNIrbM2hV14tqNV3eFvtb27win9w1a7PVhcTMKULQMfGw2IICnYDyuJteFU9s5gfEt3OkeKv7NjMIWLpQKTj+Je1z9YX9o7YFcLzNya7txTPEVkmGKzpsgWi5Q98mk3PGUT0ewuUMf50acnVVUsvrdau64jHK1Z7Jo+KjmysxsW3oSV8D+3bMkqWQVO49sgJzMCg57Cy7cw9xWEdtVH2+StjnxOE8EqbsymUmfZpZ3OkA2csHvbz+PG2ZtordpjBAE0f+Ovr9X2i838B0HUD9ku66Rcg0UYqu3tcQmNzftolzLJiujJ0Lt0jTL0wwqtRjkMQ+W/JiVJuJeOPrN/i2esPCWSURTiCfCb+Hy9/8sGYCRkK+UNfq0BIw3lnTTk4UVvdNVjsw+TFSY/xPCrtZmeDJ2pyPMWAxBMU5xJFmwPpmrhsomzy6reg2dQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1845.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06beff04-62e8-4d4e-fc51-08d83aa8d50e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2020 08:06:47.5121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MBUGKHZOeEfn2hv6x7+xuk5J4II4RkK6Tl3x9dTN8AkA36Eh/t5li3cuy8GlwjBB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1174
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596787613; bh=69Pgf2YAcEJwv8mzzuliq/NXwSm52cCm33prjL8rtww=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:x-ms-exchange-transport-forked:
         MIME-Version:X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=QUA/5q/6TtgSlIGG7F7iKMnoNwhK24176FUdvNbdipaAZ05OGJGzkLmmuyW/vl2C4
         o1erQkTpxlaDrGnsnL7saRjuR9YTJ3tMv9EBQbg5opTWacelMutKUC3t5AOFfzKHEo
         c+ShT90y0jdtlYg+ZWbot+QHy93ly8X4oJrF0VC9PkvBwqeCHVWGmjb6M5N1JqCg6z
         1RaHRUDSx9+OgyKtUixnYXnPpxpw3Rrj+q7kscSY7XMOCxAVZXoWc3cM7OJoxXzCKh
         kiVqlKfzwhyKWfe8GQVYTzezwgQw0+z7YPLOJIEVBaN6SMVDdlPJ6NKG4ECAUdGloX
         4gfYN4Mg8unkw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EJ Hsu wrote:

> From: Thierry Reding <treding@nvidia.com>
>=20
> Query the USB device's device tree node when looking for a MAC address.
> The struct device embedded into the struct net_device does not have a dev=
ice
> tree node attached at all.
>=20
> The reason why this went unnoticed is because the system where this was
> tested was one of the few development units that had its OTP programmed,
> as opposed to production systems where the MAC address is stored in a
> separate EEPROM and is passed via device tree by the firmware.
>=20
> Reported-by: EJ Hsu <ejh@nvidia.com>
> Fixes: acb6d3771a03 ("r8152: Use MAC address from device tree if availabl=
e")
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/net/usb/r8152.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c index
> 7d39f998535d..2b02fefd094d 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1504,7 +1504,7 @@ static int determine_ethernet_addr(struct r8152
> *tp, struct sockaddr *sa)
>=20
>         sa->sa_family =3D dev->type;
>=20
> -       ret =3D eth_platform_get_mac_address(&dev->dev, sa->sa_data);
> +       ret =3D eth_platform_get_mac_address(&tp->udev->dev, sa->sa_data)=
;
>         if (ret < 0) {
>                 if (tp->version =3D=3D RTL_VER_01) {
>                         ret =3D pla_ocp_read(tp, PLA_IDR, 8, sa->sa_data)=
;
> --
> 2.27.0


Reviewed-by: EJ Hsu <ejh@nvidia.com>

--nvpublic
