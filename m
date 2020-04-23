Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8EA1B5840
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDWJdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:33:22 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:37409
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgDWJdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 05:33:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrFZI+M0A8udvYPgBR1orh9eZhTwAYNsPWKdlzl1F/4l5ZLYusqmNOkDOJ/7m4Tsl656fgP/+Uv8Z6UhHcuG4HTTY1hV6gsTPz2cGOF3Yifw+HdCTNzU4ijCNBJ3pRPgblmDniel2qRSLczZyoSwmKsspR5qhtBgydnHfOClNG/LwLbc7ujPqYrzf6Z9/na/HbhASaR9jVZqLkPBDmtz7sYWrzWnQudgIhDapvBFDATGR67imq4CJWW0PiPN5R1LBONL/AhvMm9ncvrCHL9KvMLf5gpI96cepOLZsGvThq9qXBLUWVhOAUsmcLs1YAXcMVc+ikqUh0AE7SPDLaIAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVXmxWRS1Rq9LbIKtBBqMDVoi5gQUJu2eWiF27Fmb6M=;
 b=Gw5Ex+GKaFwFh169lenG/k3If8RdHIRsDoxI5TPfCEf8tkX4DFVZtu29d3HWBcjmUU9IxiYOZm+q4qHF3ozyeNPX2Vkiqe9QEi6N2csAFA/ZCt3cMy3mYhUeIKkMPJNxnRt42lH4jJlyOHU31UT6vVJ7CqF+nCyzSIMbmm+DjDrSaF6uHXM11OntpuPpjV2fwiLYktdREiCkn9SlCR3XZzZnsQsoQTDvuCtmtSL5dTy4RQevVpx6M4hP0ORNQSPyLhGIdmLHmNPgLxPeYm85QgHV+pATitB1cyDH707kdvMJ7veG52cLxn5QyA7dx6HGSDzPQUUZqCes6UwqJwRTSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVXmxWRS1Rq9LbIKtBBqMDVoi5gQUJu2eWiF27Fmb6M=;
 b=EH6jkrcTvRSPHAitUnXlEQaq4xb6aBVY6GgO5szKGEAY1VqmYHEF3QIqvnljj+3kGlAx/ATU15wT90ELgcSYueJeve4XJ2F+SZkn+ntUOxCl508nenmr3lnhC3xPxzBtEQpOHGaoPV+qqjGIVDKwhSl0G5DL9i7rI4pFW8isULc=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB5165.jpnprd01.prod.outlook.com (20.179.187.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 23 Apr 2020 09:33:17 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06%4]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 09:33:17 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] driver core: Use dev_warn() instead of dev_WARN()
 for deferred_probe_timeout warnings
Thread-Topic: [PATCH v3 2/3] driver core: Use dev_warn() instead of dev_WARN()
 for deferred_probe_timeout warnings
Thread-Index: AQHWGOU70+TFUkow3UqLZ0sOeOMv7KiGcj4Q
Date:   Thu, 23 Apr 2020 09:33:17 +0000
Message-ID: <TYAPR01MB454456FA2EEBC3A989BC8B5BD8D30@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-3-john.stultz@linaro.org>
In-Reply-To: <20200422203245.83244-3-john.stultz@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02ced91a-5d2a-4faa-0f26-08d7e7695a92
x-ms-traffictypediagnostic: TYAPR01MB5165:
x-microsoft-antispam-prvs: <TYAPR01MB516522F89812AEB0E26081E6D8D30@TYAPR01MB5165.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(7416002)(66946007)(4326008)(66446008)(9686003)(55016002)(66556008)(76116006)(64756008)(66476007)(71200400001)(33656002)(52536014)(86362001)(5660300002)(8676002)(81156014)(7696005)(55236004)(26005)(186003)(8936002)(316002)(478600001)(6506007)(110136005)(2906002)(54906003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwyLe5tSEYNqjQ0yoFo0euUBmIEFobgItiGhSiobEa/EBL+otlLAPQd7ouf1c8/xpogu9RIVUdGZevCthMo1UKbT8l/6kz3Rtq0mZebCwtj8tNl2nhtXnoBywVJEe89YbtuzyjoT9thBUuV+36Wdv+INI66JYlD12XTgXOSwQNXZMO1eF+Ts5cm9RrN1VXN2LnaTndULUny7QFQOQNfW1zvDt1I69oaR7bS8SJVEJ1VCINJeNPV1UlDppTUBwFyg0U4iiudYLNpUeR+M1lTLCjZAGDua9JJMkah++kLVnJDMKplVyEIW9IA2Z8Irg4LOj9upZQKifHg0a3kc/4HxXNVskAb4E+UQHxLhXHTbDWMwIUGCIj2NJJ1nFZU4uoNSj+/vu0oHRUD9+G9Vu26olkTZa/K7FcJdQV8XTlJqohyyP/hSDZev0TYwxh5h8o84
x-ms-exchange-antispam-messagedata: XmU6O57zphrxY1YM+L/EL1VoTeek+KcjKcYq+2gLhdhCaf2y8n+C5Q96fbinKMEFKm6Y3s6LGfORAvnoyTCvGAzIc9XQMA203UbLCTmmR9MvQeq4SJ0B4Q8iFrhASeP968+OuktCYAJt59nquCaYUA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ced91a-5d2a-4faa-0f26-08d7e7695a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 09:33:17.1159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H0zMO+j0LLoEgZmuP1qIYY/J9qggJpTo8TzirChX/mwI5x659XJibNF8XN4NGUp3OvVC6KdPJuLHVK/3q7SwfzFvCMPR4S3Hna42Pc5URf2BkDAiOsHcn4QTq7Y3G45U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

> From: John Stultz, Sent: Thursday, April 23, 2020 5:33 AM
>=20
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic") and following
> changes the logic was changes slightly so that if there is no
> driver to match whats found in the dtb, we wait the sepcified
> seconds for modules to be loaded by userland, and then timeout,
> where as previously we'd print "ignoring dependency for device,
> assuming no driver" and immediately return -ENODEV after
> initcall_done.
>=20
> However, in the timeout case (which previously existed but was
> practicaly un-used without a boot argument), the timeout message
> uses dev_WARN(). This means folks are now seeing a big backtrace
> in their boot logs if there a entry in their dts that doesn't
> have a driver.
>=20
> To fix this, lets use dev_warn(), instead of dev_WARN() to match
> the previous error path.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state(=
) logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---

Thank you for the patch!

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

