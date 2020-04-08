Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8891A1EBE
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgDHKZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 06:25:11 -0400
Received: from mail-eopbgr1410117.outbound.protection.outlook.com ([40.107.141.117]:25520
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbgDHKZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 06:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIileUYx2ujVRzzqiekNonmMNJBV2atI91vSdQGuaozhL/u5sod1G/pyamIEf4TB03w39xQQV4cZ4r7NC9hM6vv3stgyUo1aIz8K+Uw0q7vNRtT0zYYL8JisPFrwJl2ZwvYt3sS1HKkxD5MFGY5FYlpCBwzbX+1rNx8lmCZGmaAk5iF+MTOZkcRKvH163CruBxi2ZPatlqJOUE0BsY341RW0zcIz805wGjaIGe2N3kRTyS+NTKxVVancPMaVailQtZFGH/0rNCQPSGWkSZ9RDGdeQl+TVBAdIZmJECVHP1XkDe4u5UJ1lSzbyp39LsoAyOrWkt5Ma1ZXTMvCl2qk0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bvMIfu4bNVmo90Z4RETSA6+xb42chgYJiM3N8RXqX8=;
 b=BBHBTkzMZoX8cpL0Joh2nU9MPgWDz94lOk2Tnzt+rbQQ9Tt2Gz9/0XO+3kpPWMUByvAHdxTNeeQFcfHHKH6HIaIuYFfkGOCvifFo7uLJR8PKEAj4QGpOSyB7IV9ZoL/NU47hM6QHbRLei7iq1d+SXkOYnOOy+8qzNC5d2tPTDzFclczXdfiFwKOiZza4A0YIp7ByPJoPLt+Uv0hPzfQVP69pFbTYBNudcyAoz4o016XUBDH4SEeq2LzBBdm06o7hpA8OdiueFPlSxjomSazkBJonYrAqOgDom1n9UNgDcONUzesFtm58PAC8QQG0paqIt6c1WlNvPXMLP0iEIohGrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bvMIfu4bNVmo90Z4RETSA6+xb42chgYJiM3N8RXqX8=;
 b=AMHkf43h4Fn1Zz7oPeuMcZkya32VPNVz8TaxJGx3qDy/aQZmoB0bSgsvJgRfatjil5qQ4YdDu7xT19gP3fcxoylZ6XSYz836YzYyLmEKmDbS8ytTGhNuBQLAhGEPk9L/4uY/qzyY33ZUifE75jP6uNywv6HX/2hhXGloNURRF7M=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2735.jpnprd01.prod.outlook.com (20.177.101.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Wed, 8 Apr 2020 10:25:06 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06%4]) with mapi id 15.20.2900.015; Wed, 8 Apr 2020
 10:25:06 +0000
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
        netdev <netdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [RFC][PATCH v2 1/2] driver core: Revert default
 driver_deferred_probe_timeout value to 0
Thread-Topic: [RFC][PATCH v2 1/2] driver core: Revert default
 driver_deferred_probe_timeout value to 0
Thread-Index: AQHWDXcWXye7D9W90EKkrusU1lNNn6hvBE8w
Date:   Wed, 8 Apr 2020 10:25:05 +0000
Message-ID: <TYAPR01MB45442402CC541A01A623F8C4D8C00@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20200408072650.1731-1-john.stultz@linaro.org>
In-Reply-To: <20200408072650.1731-1-john.stultz@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 420cafd8-0f3c-4e8e-74f1-08d7dba71b4b
x-ms-traffictypediagnostic: TYAPR01MB2735:
x-microsoft-antispam-prvs: <TYAPR01MB27359A1927A17E8886C28950D8C00@TYAPR01MB2735.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(110136005)(52536014)(54906003)(316002)(26005)(8936002)(9686003)(5660300002)(55016002)(81166007)(86362001)(186003)(55236004)(7696005)(66446008)(6506007)(66946007)(4326008)(66556008)(8676002)(64756008)(66476007)(33656002)(7416002)(478600001)(2906002)(71200400001)(76116006)(81156014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iudkrUzifjIHL/KFpCdfRuLdeXMDhNnTGHjz5fM714s2eejcLHxXgDup+dEZO50LDOFARYLkLUVSwWDnyeOj2M0EQUhsc0M9pkpqeZT9WFo3HWcUeQADGXrm6eJjWuOzwAAl6xqJDwLqQI629FZHF2yaujaqoAtEYxMLXcT73IidFNEtrgWap1XqTJm7+i7djBcoPZyCmqQdaFAsujQpl/S+xJuUNeM1MROcRDTnhlNKd8jxYdXgGo4v6plWMP3SqkSJjkl3aLIWXkkThUJoOXeuH91I6f2ZixJBrpYO/kyPlqouT0/HBg0muESdlW0oC8sY/4Mf+gIJ9krsNI0YMrwrURHAtqcsrS/0/+xfDIvNDrWB3syVszHfbH4FGW68x8mlOAHSk6QgprQmZ1nue3rD5TItktDJX8IC1lRx7ja60MA1R+VlqLn1bLdTfq9N
x-ms-exchange-antispam-messagedata: Mh9U3V2hHSPwIaoL7SvQUOebOFpRI9fIdB7kSB9MUVtviiWw69+Nd/JAS1NyhbyqrsAuvpcSqf2PB9SbSSEEnL8BLw9tUhLrqlHEXRSP8/2+dQgdieHQMQkOahJVBH/2t6PaGB/7HAxG86buobpOsw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420cafd8-0f3c-4e8e-74f1-08d7dba71b4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 10:25:05.8286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXctKMTY9uJkIE29OV3cRyvokZUPcRS3inyuuvt7PKAZkQP/Nw1uRt63Hyg4RgAKakyL3H64Nw/W9TXEfZOCiF2nFBtkg2Ognq7mKgs6qafp2d0/gNfh3DcSuL3hqJXZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

> From: John Stultz, Sent: Wednesday, April 8, 2020 4:27 PM
>=20
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we both cleaned up
> the logic and also set the default driver_deferred_probe_timeout
> value to 30 seconds to allow for drivers that are missing
> dependencies to have some time so that the dependency may be
> loaded from userland after initcalls_done is set.
>=20
> However, Yoshihiro Shimoda reported that on his device that
> expects to have unmet dependencies (due to "optional links" in
> its devicetree), was failing to mount the NFS root.
>=20
> In digging further, it seemed the problem was that while the
> device properly probes after waiting 30 seconds for any missing
> modules to load, the ip_auto_config() had already failed,
> resulting in NFS to fail. This was due to ip_auto_config()
> calling wait_for_device_probe() which doesn't wait for the
> driver_deferred_probe_timeout to fire.
>=20
> Fixing that issue is possible, but could also introduce 30
> second delays in bootups for users who don't have any
> missing dependencies, which is not ideal.
>=20
> So I think the best solution to avoid any regressions is to
> revert back to a default timeout value of zero, and allow
> systems that need to utilize the timeout in order for userland
> to load any modules that supply misisng dependencies in the dts
> to specify the timeout length via the exiting documented boot
> argument.
>=20
> Thanks to Geert for chasing down that ip_auto_config was why NFS
> was failing in this case!
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
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state(=
) logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thank you for the patch! This patch could fix the issue
on my environment. So,

Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

