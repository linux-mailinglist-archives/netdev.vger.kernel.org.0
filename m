Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841EF1A1ECB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgDHK3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 06:29:24 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:3584
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbgDHK3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 06:29:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ2sNAYv03BDmOClbzhksPkGWTbmHGsGev7R2WRctMK4cX66Hdyq8U1je8A9FTgqgdUHWCK1iZZibL1c59WJrioxpdNB1lV/9fnwBXDNunLC3XLoFdZQaYJvkQkbkvWmfYAEPutUiCoj3d+PEE+gTkjmu4fXrq+5L8u2BZhw9lnVMnMucGbmTKY/+FHbYG8QX/yQkY87Fe8SqA5lrcj2+Lawo6pZunWrg7DkqdZUTdp1VzaVlTJXjMR6iQikvlaNfH480o97xdINS5hFxLu7MwubfYSoszsVQs0NJJBiz0MRwr4DB+GCHesW/KX0bwnbwMkQpgSdLI40w1Il1+CP1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pw18AfjmIHG/6pjUcqblLv4PRbYJAnF/RYGjCb6WFJU=;
 b=Q3nqKOoIk+XLaRp4od2WtXCyVC2dMuigyPlARlG9UDwNv0XSh/H6NjbuJhjHHuOKNSJSQJsqxJ+tnqTyWJiPd0bzZpQVs86X7N4zx84W/K1FzfKdqOc2+Z67ZMQOeoc+6tuhchI2DGsDtK6XpXerRp1R2HZu80RUJNw24Rzrdl+etE0G5pfklLyuhDsPSfv/NRwWe+YRCoIKO1buM84LlEcWlZwzjYDC0lKqma6YrHniMlQGm//0WJK0ygLmBK3EmKOIMwo7WZCmFcjJ+rpHh0zMPTdobKprkU3egkoipJXOg4SVoNjxddSf3xTG3lA9dXWlSZc/KvpeQtQ4Fzfkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pw18AfjmIHG/6pjUcqblLv4PRbYJAnF/RYGjCb6WFJU=;
 b=j67QxUSD8fBC/CjS6hpCxjbiXoRO7ULJ2S2i+V/9UkyKWFuMgHqhvI7oJyx/jBPmkBDM5FVAH6PmyRUTRiN6wOd5b0kKBiRQ78MsnnKv48DDKmvUMcMZ3jFp7DZBNAWZDN0ID8tTpewFlO37IOZrSPaDb48y713dMCxu+4Se7E8=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2735.jpnprd01.prod.outlook.com (20.177.101.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Wed, 8 Apr 2020 10:29:20 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06%4]) with mapi id 15.20.2900.015; Wed, 8 Apr 2020
 10:29:20 +0000
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
Subject: RE: [RFC][PATCH v2 2/2] driver core: Ensure wait_for_device_probe()
 waits until the deferred_probe_timeout fires
Thread-Topic: [RFC][PATCH v2 2/2] driver core: Ensure wait_for_device_probe()
 waits until the deferred_probe_timeout fires
Thread-Index: AQHWDXcYaRasF4w8J0WGvexXGfCK66hvBRAg
Date:   Wed, 8 Apr 2020 10:29:20 +0000
Message-ID: <TYAPR01MB45443540F0A3729AD2B98A96D8C00@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20200408072650.1731-1-john.stultz@linaro.org>
 <20200408072650.1731-2-john.stultz@linaro.org>
In-Reply-To: <20200408072650.1731-2-john.stultz@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 09470796-8ad4-4b05-6111-08d7dba7b30c
x-ms-traffictypediagnostic: TYAPR01MB2735:
x-microsoft-antispam-prvs: <TYAPR01MB27359C92C2554E093FF67057D8C00@TYAPR01MB2735.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(110136005)(52536014)(54906003)(316002)(26005)(8936002)(9686003)(5660300002)(55016002)(81166007)(86362001)(186003)(55236004)(7696005)(66446008)(6506007)(66946007)(4326008)(66556008)(8676002)(64756008)(66476007)(33656002)(7416002)(478600001)(2906002)(71200400001)(76116006)(81156014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H8bR3nAJpSZLlB/zKB1Tcx5M4lIZTZR62GynDjt0NR7D425TIG+MCAihPYRHvqU4a0Y7jfRyWAbB5aKfuGh9yKTSGsDOhQk8k+G0CBqaZSbXiJVbgnNoK95ycs3r7ghFU4rzgS40hnqCSW2/Q820qjCNHLR6BtGWK0n1W0VvARbSZwIwjl7h57TjFAGpya2gxM3wZPcNzlOKDA1k5qxlCsP5PrjoTjkuil25GK7BWcqTds4BmsihflvfycejmuqKQIn/mLmhAhrEiJ4J4di/7Oadhu/cHVrwMDY5DRhqjnA47jG1vfpVLWO5mE6NJsFG8pq8XcNztF2ugk9kj1w6TjhrN9O+VPKpwZlq0UGRQ5wBB2Q1XIZSGAk6OadQd5Juibn8CbjIOYLyYyaFjwBIXUjLMw4fJom1vPCDuCHZGhiOD6gwkMNoIYDFCKlYBYVb
x-ms-exchange-antispam-messagedata: DpQENT/GPCeXeH5bImRgsGT4IIGBKe3X5bObCEO/Q2sUpOKhW9romjv/Tqo7s6fq4Q3bV2XCTI49Rl+Ry3XWay9M0tffYqeDoixMZLfTGxZ2TG5N9qjfgq8S9EBvd56r5u16BhTomBZT+OLg/xskgw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09470796-8ad4-4b05-6111-08d7dba7b30c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 10:29:20.4989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCALL4+8Ftz43rBN1wRRTbslE5lrMS9pfOIcchNdYAAAIKlAIuVBEr02KaR4bO9uJj/irJQ+y22bhPzLEystF56xlPLmZAgQQtKRK8LNJY4OYWweWWDCNAMdpzVWkaq7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

> From: John Stultz, Sent: Wednesday, April 8, 2020 4:27 PM
>=20
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we set the default
> driver_deferred_probe_timeout value to 30 seconds to allow for
> drivers that are missing dependencies to have some time so that
> the dependency may be loaded from userland after initcalls_done
> is set.
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
> This patch tries to fix the issue by creating a waitqueue
> for the driver_deferred_probe_timeout, and calling wait_event()
> to make sure driver_deferred_probe_timeout is zero in
> wait_for_device_probe() to make sure all the probing is
> finished.
>=20
> The downside to this solution is that kernel functionality that
> uses wait_for_device_probe(), will block until the
> driver_deferred_probe_timeout fires, regardless of if there is
> any missing dependencies.
>=20
> However, the previous patch reverts the default timeout value to
> zero, so this side-effect will only affect users who specify a
> driver_deferred_probe_timeout=3D value as a boot argument, where
> the additional delay would be beneficial to allow modules to
> load later during boot.
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
> ---
> * v2: Split patch, and apply it as a follow-on to setting
>       the driver_deferred_probe_timeout defalt back to zero
> ---

Thank you for the patch! This patch doesn't cause any side
effect on my environment (the value of driver_deferred_probe_timeout is 0).
So,

Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

