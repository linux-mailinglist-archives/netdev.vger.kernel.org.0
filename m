Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB859DCFD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353921AbiHWKYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354300AbiHWKVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:21:12 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2053.outbound.protection.outlook.com [40.107.105.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CC881B07;
        Tue, 23 Aug 2022 02:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P62CZIC9MP2RKriGEMIcFMiNwxgH9tkcTHMuK62x2yLNyrlxpjy/OSOFdbDqtU1hgCTHm4vXDLxHOGGRDmrC0qyy8yjt3cwf9HYOkCa5FCAoMik1B110bLDH5VXFatdIbg5YsdLVxTYWaM+JJkWOeYUpY2r3lqzM3KsH82S719jZzvHVg1yTYogXkCb5TQz/YH7bpegBvxuah4pvwGo/tY+nWfdqBHmuArpVBdHydOs4f+Dq83SZ+1nsHwi4mWQequY7RnhZwrjLhSYiiIO9b1xUJHjhsu+659ELZ0k8deC4N91DOYEmpCB6LYXNTvSCvH2z2v537+yIcB0nSu4TXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHCwmmW3+2XbA0oCtwecw0UMv8hqyq/ooUYnn8/bghU=;
 b=aj0yJHYpBTSBdaRHGPNsPyUR6eATZP7RZh0wVDBETmspZKXlH86wdtWlEsB0tHKi7WSKP0hzvn42fXnNVyB4mrm+/nRS/DJp2QCBta2YfwT73DxWr4La4ayw/pZwEB22OF0roIsu7fQEqglNEMX+VTypZjA0rgAtlUK/Kiqus8pSsJLCxJk6ZIIHX/5ZGAOvg8iGUJjQ+YlvGFf5HA/gsw+Ro37f7lvb4RrQh1iUEkEpERV75A0BtAiS07SVOWbar0RBhUeDvpfMO5o4XW2dm6fqICwnp+H3bj9hr4NnbJOX0NBn8Gp32q9EDC3tXfMp7lF44pxdTyqlIxfQ+eLmng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHCwmmW3+2XbA0oCtwecw0UMv8hqyq/ooUYnn8/bghU=;
 b=hhrblpFlYvsq6qco8AiyB78UAcC2iq7cCGeiN1kn4nASJx+XhRCiDST/xtPwjKJy17uGpoK8yt4Db1eOWa0MxbsVQ7FY9C1jgrsyUj/ItPcMo732Pk816kp/jlFQuRsQeyY3spexQHIGxG0snyhQBJKPl+8s805GrMLdyqVXrqs=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by PAXPR04MB9023.eurprd04.prod.outlook.com (2603:10a6:102:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 09:02:19 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::3c6c:b7e6:a93d:d442]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::3c6c:b7e6:a93d:d442%4]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 09:02:19 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] Revert "driver core: Delete
 driver_deferred_probe_check_state()"
Thread-Topic: [PATCH v2 1/4] Revert "driver core: Delete
 driver_deferred_probe_check_state()"
Thread-Index: AQHYtBlSt472JDIj90CIdKooit9jHq28NbLg
Date:   Tue, 23 Aug 2022 09:02:19 +0000
Message-ID: <DU0PR04MB94175300872F36E5DF2826DF88709@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220819221616.2107893-1-saravanak@google.com>
 <20220819221616.2107893-2-saravanak@google.com>
In-Reply-To: <20220819221616.2107893-2-saravanak@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd3d0005-c439-4608-9c73-08da84e62f4b
x-ms-traffictypediagnostic: PAXPR04MB9023:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lLVsRswrGJQqQfknEPx3jA2ZBJ7GNLT2vaON+wKj1pVRVDTXz3mHoLsMEPSwwaU7rFiLukb1OdnJ9tS2+QGi3jnGZ3fJAyBz5UvxAw0/8rBMYSSgQ9swwY2TIEFPx7CrMZqopppfkf9KazkWWtbQxfn3w8N0kNdVncsuVnZk47+LIz7RTFyio4NGlWCiWryDeSel2diiadv8dEAqDMvBPMDrQsjbYkaJBLkbNqqej7VwLxR0PDebirB2sskIkNX27jtItdL2cGhPiMqxc+dSeAdlxy3q+3AedHdjluqNlWWnpupqTWSsNZvaXguD2CHWZz6sxSGLhvtOYjWjQx+q/xOZgEqQsUeYyH+zesdpkKEQiUb0lgG3owsPzs/bwqtjZmK4P3XnGXTvDcyKwYUEt4NplVqGUDFXr7RHN5fei0Lh89o7hBbZEEk8WdCWqIJNicbb6m5UVm1HDz6Jd1rdOJn2BXScbVpi27fjmaLebAlggBpCP6DZo+tDY2zvxWZ94UaRRTTVS2oETwzXHAttkA4FlC/7LFgDtmPsSEYdn64ZCfYTXM5RZZbR6XR7JAfgquRPyYsCh/Jyx9Jyu21pxjdQoiVPYNDdIRj++FUU7tMOZQ/Kk2k0haZnx49Fkidgz7HZOHuCZJFcTq2G8nNGVYLKpF3PwhcJ8y1bo+PanNJzgb0b8gdoF8CijF4KzfOlEqJDKLgdwuQjPujzM3m8G17fvdZFk/hnxlEBBNMsLdd7x4ipFbegIpDUM9vgR3cKLJ9PZSV4If5rFGura1IV/3DYSnErPW+rFCn8sCZntaUHLQO4ldkvCkfNrof0E+lJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(2906002)(9686003)(83380400001)(26005)(6506007)(186003)(33656002)(921005)(86362001)(38070700005)(7696005)(8676002)(55016003)(38100700002)(64756008)(122000001)(7416002)(966005)(66946007)(7406005)(66556008)(76116006)(41300700001)(44832011)(316002)(66476007)(5660300002)(54906003)(66446008)(52536014)(478600001)(110136005)(71200400001)(4326008)(8936002)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7rN9VzQG8jcUZ7ZJRXSnEU3hdFUCJ19JyIPHnFSsMRoali+LTHUzzXpafnPH?=
 =?us-ascii?Q?FzTcMpXjDaCfOLvbTFCOM+cSmJXJXl22UxDPw/z6g7wuNILoPUkCyAryRFgL?=
 =?us-ascii?Q?uhZixBNA3m3nB1YwUIwcywTdZBY0hzYyWoRI12nKj4fwqC05nVxTIuOX6HeE?=
 =?us-ascii?Q?OkyeUCxnTohYjQodJPlo4K5CLeojTBUdzeTMu4yUArU4cAFM1ixsamPPslc2?=
 =?us-ascii?Q?dEo/HmwNI58/PI2E7yRu/LJipw1hq9GRcPelpFiQveVUaGISE/s29Z4UIzF6?=
 =?us-ascii?Q?6HdZnfO7mh4vb77DkOYDzOFVTzvQJHFbNIiJHy+t0uakz/zfeQ/tgsle8GJY?=
 =?us-ascii?Q?MTs1ICrjrL1EqLPpxeUojVJe8YfsKAE3YlPwWl4MAo0F/T/ES9O8NA88TPaQ?=
 =?us-ascii?Q?BOysS59TIxmnUsK+Bc8240UkVA74qrwI3OnFbL39skP3nReBX5huTQ8IgIRC?=
 =?us-ascii?Q?TIqIrOvGIlErM+hxrHmnKBpyxv+eIE5N0CeLvmQmzO4JImgIN/Mbd5eJln60?=
 =?us-ascii?Q?x25qF8mFS5bUWZ+wHMAH42IdkwfDT6utqpg+fVz06twQICfHpIDwEUBwWj5l?=
 =?us-ascii?Q?vtPw88ePJ+4df6/9CYrQH1s2CkqVYFVstVlOsUlXaLtkMcZQzsZvi2GEC/8k?=
 =?us-ascii?Q?p5+UBloRW9rc1bnl1hpF/0abIrEq5GB2eTxJnqUBKSbRIw4FGRU+wko7GCsL?=
 =?us-ascii?Q?h3ZKEhW4ih0toKsKhcOvMj4Nu20ZY3pmYlAHyDiNraFKNEe5VpwmFQ0TqL1v?=
 =?us-ascii?Q?3yg8/s52wixf6NMGoL4s146qsZLP/Z0BZ072FcS1XtanDbOMucuXhe0srGsq?=
 =?us-ascii?Q?AWLySj9PwV6LH+0MRAIlnWOp36lJX0IdF/gbVnVPa2DkfagVrasUME88BJvT?=
 =?us-ascii?Q?l39dLQ3540wAfHsQcQ+4VYZpdNwj5yZs2xN/+dNkdjpg9x9sFdkBWv2x86sw?=
 =?us-ascii?Q?ufx/gaSSt1a1btXfWEs+zDbS0kY5HsHsYzAYD83uNN8DmEz6LmL6FpWsdRal?=
 =?us-ascii?Q?ACNfuyISINbU9HelXLm0EoJsownfg9rfEoI4wVi3yHK9eITI8geKteokWRU2?=
 =?us-ascii?Q?Wa+TTHMv8iiEjG0zEuXXatuOueK3SUyPQVsDLFmnRyGxPA8p8R2jNlFfOhXy?=
 =?us-ascii?Q?+jbfSziTgYT1fb4VsQ8rRSJr0Bi7W7wuDCsdqwQhUNrO18YBWa/qJD+eDMhA?=
 =?us-ascii?Q?PSWxD3nqMNWLCHNnUoI8vAkNBCrJT5IIHE2u9/tKNmgeBOqxKPxHzN3ElEaf?=
 =?us-ascii?Q?M7Wm9Td1bl2fDk8MaiSallIYRRhjMEmHt/MJYQOJE4gAxFdjtU36vGnejMqG?=
 =?us-ascii?Q?Wnt4cJ5Igt5+lFmJMHvMB+38ki4yFEjJsT6Oq00hsRoeiFbYAXM2BwsYgayI?=
 =?us-ascii?Q?zqd2tbK0KxgU6zYJxhHnHcu7Mm1RxUtZjHEwqULfE/sk/Dme9tbvYqCXw7Jj?=
 =?us-ascii?Q?TgCmAjvAu5awBbXl/zu0zot09Cd6zAd4Coc4Xh8mpqjKdiAsZjTW4DbypCY8?=
 =?us-ascii?Q?q8UNr5yhh94+ERPVOCY2C5IMvo7CMeC1es3p3ryDyRoS3AirKnhpdXay9kVc?=
 =?us-ascii?Q?+dxb0oSdsk3/PEPTCyQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3d0005-c439-4608-9c73-08da84e62f4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 09:02:19.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ckVf+sJO9FxgkPkJPt54GPja9AiOP3ejM918u5AxkD1LdrpLE2dyO9P9tKwQNt4TgB8pMp5clICE3WIiThsgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v2 1/4] Revert "driver core: Delete
> driver_deferred_probe_check_state()"
>=20
> This reverts commit 9cbffc7a59561be950ecc675d19a3d2b45202b2b.
>=20
> There are a few more issues to fix that have been reported in the thread =
for
> the original series [1]. We'll need to fix those before this will work.
> So, revert it for now.
>=20
> [1] -
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Flkml%2F20220601070707.3946847-1-
> saravanak%40google.com%2F&amp;data=3D05%7C01%7Cpeng.fan%40nxp.co
> m%7Ce9205a2ec9c049d2a68408da82307410%7C686ea1d3bc2b4c6fa92cd99
> c5c301635%7C0%7C0%7C637965441862478527%7CUnknown%7CTWFpbGZs
> b3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M
> n0%3D%7C3000%7C%7C%7C&amp;sdata=3DtGjnNEQ6BwaNrxug9ceThYOlj0a3
> Gmds8qpwNcHf%2FH8%3D&amp;reserved=3D0
>=20
> Fixes: 9cbffc7a5956 ("driver core: Delete
> driver_deferred_probe_check_state()")
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Tested-by: Peng Fan <peng.fan@nxp.com>
> ---
>  drivers/base/dd.c             | 30 ++++++++++++++++++++++++++++++
>  include/linux/device/driver.h |  1 +
>  2 files changed, 31 insertions(+)
>=20
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c index
> 70f79fc71539..a8916d1bfdcb 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -274,12 +274,42 @@ static int __init
> deferred_probe_timeout_setup(char *str)  }
> __setup("deferred_probe_timeout=3D", deferred_probe_timeout_setup);
>=20
> +/**
> + * driver_deferred_probe_check_state() - Check deferred probe state
> + * @dev: device to check
> + *
> + * Return:
> + * * -ENODEV if initcalls have completed and modules are disabled.
> + * * -ETIMEDOUT if the deferred probe timeout was set and has expired
> + *   and modules are enabled.
> + * * -EPROBE_DEFER in other cases.
> + *
> + * Drivers or subsystems can opt-in to calling this function instead of
> +directly
> + * returning -EPROBE_DEFER.
> + */
> +int driver_deferred_probe_check_state(struct device *dev) {
> +	if (!IS_ENABLED(CONFIG_MODULES) && initcalls_done) {
> +		dev_warn(dev, "ignoring dependency for device, assuming
> no driver\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!driver_deferred_probe_timeout && initcalls_done) {
> +		dev_warn(dev, "deferred probe timeout, ignoring
> dependency\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return -EPROBE_DEFER;
> +}
> +EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
> +
>  static void deferred_probe_timeout_work_func(struct work_struct *work)
> {
>  	struct device_private *p;
>=20
>  	fw_devlink_drivers_done();
>=20
> +	driver_deferred_probe_timeout =3D 0;
>  	driver_deferred_probe_trigger();
>  	flush_work(&deferred_probe_work);
>=20
> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.=
h
> index 7acaabde5396..2114d65b862f 100644
> --- a/include/linux/device/driver.h
> +++ b/include/linux/device/driver.h
> @@ -242,6 +242,7 @@ driver_find_device_by_acpi_dev(struct
> device_driver *drv, const void *adev)
>=20
>  extern int driver_deferred_probe_timeout;  void
> driver_deferred_probe_add(struct device *dev);
> +int driver_deferred_probe_check_state(struct device *dev);
>  void driver_init(void);
>=20
>  /**
> --
> 2.37.1.595.g718a3a8f04-goog

