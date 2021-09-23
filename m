Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFDE415FED
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbhIWNdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:33:06 -0400
Received: from mail-eopbgr1400108.outbound.protection.outlook.com ([40.107.140.108]:7488
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241451AbhIWNcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:32:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFXPKStvnk9n4N06mbVgca/8lkU9IWOYxOsJUPwmtoml5EJ1PiXS8WqDkynEBUN1o68S5rt7dGkg+QLuqOxosQgqWC9hxT9Zsh3M/hV2+eU9P6drSiEc2Vgbx8vH6D8S8a8t0UrlKmOcCTKT7CbrQL+gv4mdDxKHlZXvU7mmGYVzxNwBZGk3POlpuVFnFtKtorOdvvQn7kr8flyhp0K9COmfCr3gG/pIBSsOozcO877cJrOsSFR9vFOyV/d+do1PSWFDn0gRBPxGBbKXtrcZvXl8QR3N4BiIdP2EoGfvZXwLHjo7LIt4wv4OpDzr1OkRwsWY8Vyc2DfhTCmSv14+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jiva/iwAtLpSBKKQiiY0L63LGs2X85sVCZIxxSO1qwQ=;
 b=L5+e3WydNLEPL0GW62s7KPol2WLtz+B6KKDwkr5MAWlbsY4i6KSahRncitZzU01N98x96OihHDARKBceoCEgPvxo7CAiAVVTJ8ti3PEH00xeE+zeR3204EEzCzUo9O/rtmEmNxEo2NFpUo0nlFLuG/4268NjA6r7+q4/AdX5Hbtb1WwXwRek9pULA0q/heb5PcewcpBpeGN2RFkn3xgUPQJRCA/6TmyvlJ2MEOYFMCD0bzsNT1gVrXIodRcf85PChx/6s8Q19Op8Pah10Hiv1OLQt9iYXlSv9L/7mSGdtFHw6VZkYFaAJsjd4Rf9hquvxltzSA+zt3eAiuKYT4vqKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiva/iwAtLpSBKKQiiY0L63LGs2X85sVCZIxxSO1qwQ=;
 b=f0Xw6Ve7ancpFH9Kfo+COiv3DpQVxqAOwmMRS3Gzn0+Zp0aUhaIWgb+VUpD3YMwCoe4HgZhYzxjo4oYn55Y61RbWD60mIS+ORDGmfCLxml1FORqcLAPJQS3a1amVsw4GfGuM6JMcjytWxa9jI1POZRvrPoGA8Cq1AlUIzlaphyQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (20.183.20.197) by
 OSAPR01MB4980.jpnprd01.prod.outlook.com (20.179.178.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Thu, 23 Sep 2021 13:30:29 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 13:30:28 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Subject: RE: [PATCH] can: rcar_can: Fix suspend/resume
Thread-Topic: [PATCH] can: rcar_can: Fix suspend/resume
Thread-Index: AQHXrqkXDIxIFqtdv0+BkqxQtc4jFauxn80w
Date:   Thu, 23 Sep 2021 13:30:28 +0000
Message-ID: <OS0PR01MB5922F0553374BB1889E29F6F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: renesas.com; dkim=none (message not signed)
 header.d=none;renesas.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cece32b-049e-40bf-233d-08d97e964f38
x-ms-traffictypediagnostic: OSAPR01MB4980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4980DF5D0E4605DC9EDDB21786A39@OSAPR01MB4980.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXfIQ4L3pA/f4lGYy01rFGL0IuLguUJrDjxD3U7X+cl7SpTFuW24aSCFa0nF90X9JLO9LsoOJrd3hKfOdOo2PHbykqEbSHYUQSCxYknZglFWhZY3nya7JqnTlFMtoeQc2bFWqwfxHNLFkN6knLB4C9zROtDkdKa6x6Y46lhRIV4WXvveMFkyR6li1I3D02DcDhDZ+cIIS62atJQW2aKIiaGpa6EiIWEJKqtr6l+h1jN0MkboRHdKcL+kwMauAmEzKYMrf/DyTotS9PYl863BGX9NhEnS5RkkQh5V5yGtn3vfbOwpFho+Xt+9iC0jjlGjcFetF2uVxffQfEWqqYZYb0Hbms9wXPwk/59VCIX5DZ0F1km3VaOdosmZdx3bn94HyewKW2Xyy2y2abF5QIcK+y5XjCvIqyDGU0USZHBDkKCfdwS05A4vSRZKCZpdIhCn4MaYKCNsp407l7+4O9oOWJP/tA3T9xPHtFvASXLQlK4IH7pao9oJs4wdEkVNP8tszxdgT9iPwuJD+zzr1CpO7lwsmXwykavsUz5diFAM6N0GGu+Z5HFNCSraMaXFXpXMMZ9k2Cbf8g6fJtWw/jFn3CBcz8RNybcZ1tC1fhR8SEawXKUaERC7zbxFY/X63pjAZteL2I5ytYQtgz4wEKtWo+2lj86udPNE1UndBNydTgSTBF4JR3nI2YSmM8/4GRPHXYBvS7tv0tcn1O7EQ/GJMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(55016002)(66946007)(110136005)(71200400001)(122000001)(107886003)(316002)(186003)(2906002)(15650500001)(8936002)(508600001)(38100700002)(52536014)(76116006)(7696005)(33656002)(83380400001)(4326008)(38070700005)(8676002)(66446008)(64756008)(66556008)(86362001)(26005)(53546011)(66476007)(9686003)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WMnrWIlHOMFssHn1FJNX88mPX6tfgOvUoGLCMD/6YmhGF4IzLp/7cJkiM0uA?=
 =?us-ascii?Q?+59qfILf8VmI2HUJzkZ+Nh/jrLf5m+U3V1TPMWDNizODjuFiiU/cSVbB7Kp9?=
 =?us-ascii?Q?9AazH4dwO7Wy+vIz7psJOc+dyXaQGKfZtxbkwIZtS0CSMBvHyxoBzeQGdiTp?=
 =?us-ascii?Q?TQfsZWSx6P5XS4jlv6dEpq3aw35EVfF76RMOMCVY71IY/7BLnSyDvTx+KtWw?=
 =?us-ascii?Q?DOuTd5o2PR5zTY4rL5/ob198mrMje2RO2p1zKsz2AKOm54ok+r4ML/9BWVe5?=
 =?us-ascii?Q?0xbtFa/NPhrWhhFIxQEU3g46bg/pBN+KczGpuom5nisVVtHhEMhIzTbdJDAd?=
 =?us-ascii?Q?CYzYBGSfTvWREmXqvYrGSTjgBnybko3WR3SOypx2rL20XMR/5gHySO1JfpVn?=
 =?us-ascii?Q?5zFBPNOkn55KfX8prdozvVbryRkKOv/3hrYq5ssYyW/ms4n5LPaS1RnFIrOB?=
 =?us-ascii?Q?vl89QM6v3GOWkxGfQxiOEPyLh0Sid0QpdSmy5TTls5tqIU2MWNeIEbJfODJs?=
 =?us-ascii?Q?XHhSb9Qtf6P92qMG446dEfYUvgYfl3WZeDHf4mlIRnJ9NpyxijAsUrjhHael?=
 =?us-ascii?Q?9K1SXs0C16x5L80wv/rZ4htRkMChpHzA8AMLgKMLNFX3f4QA1NCT3GGNRsL1?=
 =?us-ascii?Q?99gDLT646Dgw8uuIPnIOlFtDuPsfiUtFscF+o6pOE/u0batt8MJAkXFFrGs4?=
 =?us-ascii?Q?7s9QVkhN9tPDO4gnwcIUFZQ2pEIEM0CdqIJv3w+DORfVtk+LJiOMiOHkApSB?=
 =?us-ascii?Q?uFd/ghUA3e+XzRKr6lX/6xhc2GD8wLPhJXnCj/vOjsTZNaX0cvDlAhsaWc3N?=
 =?us-ascii?Q?lBnTTyTvciFIw4W4IzIfdBaADmIudZxYLaFILKezxCv+FIB/daFSGPgw+IBt?=
 =?us-ascii?Q?P4SWA68r909UQUQGlBK2UmKkAWsymx5S26h9pSmrOsxLqXUF6dXqgD5ZctpS?=
 =?us-ascii?Q?xwbmqBgC94SqbgLd8OY0nN9Q/7L1rWO3Kj2fJfkcw+I+j+JKHVlrUw43B6j+?=
 =?us-ascii?Q?foaHw49hJ2SNKedQGuQfKSsAS9cHZEdKXqTJIYzNtvfIDJZRoqnYfxiuXAxI?=
 =?us-ascii?Q?3YTtXE80AgTeNUnaJq8gfC6PQq3lw9/YG9IAhjOmuqKiLVGC0MvLf0Si4ijL?=
 =?us-ascii?Q?6cPosE9KQByPXedOgyS+nx5fV7jWD+gt2dcLJ6Im5ehUPxoDOvKTJvzcoy73?=
 =?us-ascii?Q?R5pfPFL0pZP26LByKOAvv9GvLYETYg7Zyfyx26HBSmcdJOlncXzd32Tt6k1P?=
 =?us-ascii?Q?1e/QkovupydzshNenKPgMhTSWN6Qo/sMukYhiwE0FYhUxu1um7KLYLehyYmr?=
 =?us-ascii?Q?xNak4amGYGCld2WE7CcVwmN1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cece32b-049e-40bf-233d-08d97e964f38
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 13:30:28.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PYdYH2W+r1tNve7UNyriLpJkcR0LyZN9BUDlP9zEdlEAu4i6Lmiia35JLeOTG7nb6Kvj9Wh9QYi05kjImMzlg4B4x8GK2FvQbJBjB388MqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4980
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-San,

Thanks for the patch. I have tested Wake on LAN(Magic packet) on Hihope RZ/=
G2M board
and this patches fixes the warning messages reported by kernel during suspe=
nd.

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>


Before applying patch
------------------------
root@hihope-rzg2m:~# ethtool -s eth0 wol g
root@hihope-rzg2m:~# echo mem > /sys/power/state
[   92.220742] PM: suspend entry (s2idle)
[   92.228123] Filesystems sync: 0.003 seconds
[   92.248521] Freezing user space processes ... (elapsed 0.007 seconds) do=
ne.
[   92.263935] OOM killer disabled.
[   92.267265] Freezing remaining freezable tasks ... (elapsed 0.004 second=
s) done.
[   92.279787] printk: Suspending console(s) (use no_console_suspend to deb=
ug)
[   92.310223] wl1271_sdio mmc2:0001:2: no wilink module was probed
[   92.541847] ------------[ cut here ]------------
[   92.541885] can-if1 already disabled
[   92.541932] WARNING: CPU: 0 PID: 480 at drivers/clk/clk.c:952 clk_core_d=
isable+0x250/0x288
[   92.541962] CPU: 0 PID: 480 Comm: sh Not tainted 5.15.0-rc1-arm64-renesa=
s-00402-gf0c16ee77cf1 #297
[   92.541973] Hardware name: HopeRun HiHope RZ/G2M with sub board (DT)
[   92.541981] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   92.541990] pc : clk_core_disable+0x250/0x288
[   92.542000] lr : clk_core_disable+0x250/0x288
[   92.542008] sp : ffff80001263b980
[   92.542014] x29: ffff80001263b980 x28: ffff8000114ea508 x27: 00000000000=
00000
[   92.542037] x26: ffff8000113b0b48 x25: ffff80001115f000 x24: ffff8000114=
ea518
[   92.542057] x23: ffff0005c0b5f010 x22: ffff8000113b0b48 x21: 00000000000=
00000
[   92.542077] x20: ffff0005c0d09800 x19: ffff0005c0d09800 x18: 00000000000=
0b948
[   92.542096] x17: 0000000000000000 x16: 000000000000b94e x15: ffff8000115=
c5e68
[   92.542116] x14: fffffffffffc63d7 x13: 0000000000000003 x12: ffff8000113=
d3e58
[   92.542135] x11: 0000000000000001 x10: 00000000000000f0 x9 : ffff8000111=
619e4
[   92.542154] x8 : ffff0005c67a4380 x7 : 0000000000000002 x6 : 00000000000=
00000
[   92.542173] x5 : ffff00063f727bf0 x4 : 0000000000000000 x3 : 00000000000=
00027
[   92.542192] x2 : 0000000000000023 x1 : 2b864f21865f9400 x0 : 00000000000=
00000
[   92.542212] Call trace:
[   92.542218]  clk_core_disable+0x250/0x288
[   92.542227]  clk_core_disable_lock+0x20/0x38
[   92.542236]  clk_disable+0x1c/0x28
[   92.542244]  rcar_can_suspend+0x74/0xb0
[   92.542257]  dpm_run_callback+0x5c/0x2b8
[   92.542268]  __device_suspend+0x110/0x5d8
[   92.542276]  dpm_suspend+0x124/0x438
[   92.542284]  dpm_suspend_start+0x78/0x90
[   92.542292]  suspend_devices_and_enter+0x10c/0xbb0
[   92.542304]  pm_suspend+0x274/0x338
[   92.542312]  state_store+0x88/0x110
[   92.542321]  kobj_attr_store+0x14/0x28
[   92.542335]  sysfs_kf_write+0x48/0x70
[   92.542345]  kernfs_fop_write_iter+0x118/0x1a8
[   92.542352]  new_sync_write+0xe4/0x180
[   92.542363]  vfs_write+0x29c/0x468
[   92.542371]  ksys_write+0x68/0xf0
[   92.542379]  __arm64_sys_write+0x18/0x20
[   92.542387]  invoke_syscall+0x40/0xf8
[   92.542398]  el0_svc_common.constprop.0+0xf0/0x110
[   92.542407]  do_el0_svc+0x20/0x78
[   92.542414]  el0_svc+0x50/0xe0
[   92.542423]  el0t_64_sync_handler+0xa8/0xb0
[   92.542431]  el0t_64_sync+0x158/0x15c
[   92.542440] irq event stamp: 46832
[   92.542445] hardirqs last  enabled at (46831): [<ffff800010c960dc>] _raw=
_spin_unlock_irqrestore+0x8c/0x90
[   92.542459] hardirqs last disabled at (46832): [<ffff8000105b4964>] clk_=
enable_lock+0xcc/0x118
[   92.542469] softirqs last  enabled at (42392): [<ffff800010010464>] _ste=
xt+0x464/0x5d8
[   92.542477] softirqs last disabled at (42387): [<ffff80001008f480>] irq_=
exit+0x198/0x1b8
[   92.542490] ---[ end trace e2078d4610595648 ]---
[   92.542527] ------------[ cut here ]------------
[   92.542532] can-if0 already disabled
[   92.542556] WARNING: CPU: 0 PID: 480 at drivers/clk/clk.c:952 clk_core_d=
isable+0x250/0x288
[   92.542569] CPU: 0 PID: 480 Comm: sh Tainted: G        W         5.15.0-=
rc1-arm64-renesas-00402-gf0c16ee77cf1 #297
[   92.542578] Hardware name: HopeRun HiHope RZ/G2M with sub board (DT)
[   92.542583] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   92.542590] pc : clk_core_disable+0x250/0x288
[   92.542598] lr : clk_core_disable+0x250/0x288
[   92.542606] sp : ffff80001263b980
[   92.542611] x29: ffff80001263b980 x28: ffff8000114ea508 x27: 00000000000=
00000
[   92.542631] x26: ffff8000113b0b48 x25: ffff80001115f000 x24: ffff8000114=
ea518
[   92.542650] x23: ffff0005c0b5d810 x22: ffff8000113b0b48 x21: 00000000000=
00000
[   92.542669] x20: ffff0005c0d09900 x19: ffff0005c0d09900 x18: 00000000000=
0b948
[   92.542688] x17: 0000000000000000 x16: 000000000000b94e x15: ffff8000115=
c5e68
[   92.542707] x14: fffffffffffc6ec7 x13: 0000000000000003 x12: ffff8000113=
d3e58
[   92.542726] x11: 0000000000000001 x10: 00000000000000f0 x9 : ffff8000111=
619e4
[   92.542745] x8 : ffff0005c67a4380 x7 : 0000000000000002 x6 : 00000000000=
00000
[   92.542763] x5 : ffff00063f727bf0 x4 : 0000000000000000 x3 : 00000000000=
00027
[   92.542782] x2 : 0000000000000023 x1 : 2b864f21865f9400 x0 : 00000000000=
00000
[   92.542800] Call trace:
[   92.542806]  clk_core_disable+0x250/0x288
[   92.542814]  clk_core_disable_lock+0x20/0x38
[   92.542822]  clk_disable+0x1c/0x28
[   92.542828]  rcar_can_suspend+0x74/0xb0
[   92.542837]  dpm_run_callback+0x5c/0x2b8
[   92.542845]  __device_suspend+0x110/0x5d8
[   92.542852]  dpm_suspend+0x124/0x438
[   92.542860]  dpm_suspend_start+0x78/0x90
[   92.542868]  suspend_devices_and_enter+0x10c/0xbb0
[   92.542876]  pm_suspend+0x274/0x338
[   92.542884]  state_store+0x88/0x110
[   92.542892]  kobj_attr_store+0x14/0x28
[   92.542901]  sysfs_kf_write+0x48/0x70
[   92.542908]  kernfs_fop_write_iter+0x118/0x1a8
[   92.542915]  new_sync_write+0xe4/0x180
[   92.542923]  vfs_write+0x29c/0x468
[   92.542930]  ksys_write+0x68/0xf0
[   92.542938]  __arm64_sys_write+0x18/0x20
[   92.542945]  invoke_syscall+0x40/0xf8
[   92.542954]  el0_svc_common.constprop.0+0xf0/0x110
[   92.542962]  do_el0_svc+0x20/0x78
[   92.542969]  el0_svc+0x50/0xe0
[   92.542977]  el0t_64_sync_handler+0xa8/0xb0
[   92.542984]  el0t_64_sync+0x158/0x15c
[   92.542991] irq event stamp: 46852
[   92.542995] hardirqs last  enabled at (46851): [<ffff800010c960dc>] _raw=
_spin_unlock_irqrestore+0x8c/0x90
[   92.543004] hardirqs last disabled at (46852): [<ffff8000105b4964>] clk_=
enable_lock+0xcc/0x118
[   92.543013] softirqs last  enabled at (42392): [<ffff800010010464>] _ste=
xt+0x464/0x5d8
[   92.543020] softirqs last disabled at (42387): [<ffff80001008f480>] irq_=
exit+0x198/0x1b8
[   92.543029] ---[ end trace e2078d4610595649 ]---
[  148.223753] ravb e6800000.ethernet eth0: Link is Down
[  148.242725] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: att=
ached PHY driver (mii_bus:phy_addr=3De6800000.ethernet-ffffffff:00, irq=3D1=
99)
[  148.809790] OOM killer enabled.
[  148.813013] Restarting tasks ... done.
[  148.824071] PM: suspend exit
[  152.628415] ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow =
control off
root@hihope-rzg2m:~#

After applying the patch:-
-------------------------

root@hihope-rzg2m:~# ethtool -s eth0 wol g
root@hihope-rzg2m:~# echo mem > /sys/power/state

[   38.607753] PM: suspend entry (s2idle)
[   38.616233] Filesystems sync: 0.004 seconds
[   38.638404] Freezing user space processes ... (elapsed 0.007 seconds) do=
ne.
[   38.654476] OOM killer disabled.
[   38.657879] Freezing remaining freezable tasks ... (elapsed 0.004 second=
s) done.
[   38.670526] printk: Suspending console(s) (use no_console_suspend to deb=
ug)
[   38.698823] wl1271_sdio mmc2:0001:2: no wilink module was probed
[   45.828031] ravb e6800000.ethernet eth0: Link is Down
[   45.846544] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: att=
ached PHY driver (mii_bus:phy_addr=3De6800000.ethernet-ffffffff:00, irq=3D1=
99)
[   45.888434] OOM killer enabled.
[   45.891614] Restarting tasks ... done.
[   45.901692] PM: suspend exit
root@hihope-rzg2m:~#
root@hihope-rzg2m:~# [   49.468617] ravb e6800000.ethernet eth0: Link is Up=
 - 1Gbps/Full - flow control off

regards,
Biju


=20

> -----Original Message-----
> From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Sent: 21 September 2021 06:20
> To: wg@grandegger.com; mkl@pengutronix.de
> Cc: davem@davemloft.net; kuba@kernel.org; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-renesas-soc@vger.kernel.org; Yoshihiro
> Shimoda <yoshihiro.shimoda.uh@renesas.com>; Ayumi Nakamichi
> <ayumi.nakamichi.kf@renesas.com>
> Subject: [PATCH] can: rcar_can: Fix suspend/resume
>=20
> If the driver was not opened, rcar_can_suspend() should not call
> clk_disable() because the clock was not enabled.
>=20
> Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
> ---
>  drivers/net/can/rcar/rcar_can.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_can.c
> b/drivers/net/can/rcar/rcar_can.c index 00e4533c8bdd..6b4eefb03044 100644
> --- a/drivers/net/can/rcar/rcar_can.c
> +++ b/drivers/net/can/rcar/rcar_can.c
> @@ -846,10 +846,12 @@ static int __maybe_unused rcar_can_suspend(struct
> device *dev)
>  	struct rcar_can_priv *priv =3D netdev_priv(ndev);
>  	u16 ctlr;
>=20
> -	if (netif_running(ndev)) {
> -		netif_stop_queue(ndev);
> -		netif_device_detach(ndev);
> -	}
> +	if (!netif_running(ndev))
> +		return 0;
> +
> +	netif_stop_queue(ndev);
> +	netif_device_detach(ndev);
> +
>  	ctlr =3D readw(&priv->regs->ctlr);
>  	ctlr |=3D RCAR_CAN_CTLR_CANM_HALT;
>  	writew(ctlr, &priv->regs->ctlr);
> @@ -858,6 +860,7 @@ static int __maybe_unused rcar_can_suspend(struct
> device *dev)
>  	priv->can.state =3D CAN_STATE_SLEEPING;
>=20
>  	clk_disable(priv->clk);
> +
>  	return 0;
>  }
>=20
> @@ -868,6 +871,9 @@ static int __maybe_unused rcar_can_resume(struct
> device *dev)
>  	u16 ctlr;
>  	int err;
>=20
> +	if (!netif_running(ndev))
> +		return 0;
> +
>  	err =3D clk_enable(priv->clk);
>  	if (err) {
>  		netdev_err(ndev, "clk_enable() failed, error %d\n", err); @@ -
> 881,10 +887,9 @@ static int __maybe_unused rcar_can_resume(struct device
> *dev)
>  	writew(ctlr, &priv->regs->ctlr);
>  	priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
>=20
> -	if (netif_running(ndev)) {
> -		netif_device_attach(ndev);
> -		netif_start_queue(ndev);
> -	}
> +	netif_device_attach(ndev);
> +	netif_start_queue(ndev);
> +
>  	return 0;
>  }
>=20
> --
> 2.25.1

