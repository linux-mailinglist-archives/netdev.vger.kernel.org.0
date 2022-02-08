Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE73C4AD9E8
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbiBHNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378699AbiBHNbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:31:21 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140040.outbound.protection.outlook.com [40.107.14.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6CC0302D0;
        Tue,  8 Feb 2022 05:30:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOyJ2By/jEOOxoi5oBgba1aWDQsFiYFhw43C3w6r2oJ8bQFxTCB+gI4Jci5tmikqBOY+h8RiQogKSSR+Mqy/piEKc4q5vufRRQ4i8iPy+e6pOzjB+m2CdisXBwSBgQGfipxdsBYdLR9fkwBBbLicgiAMqEXc/NdsGokMywU371fmkZTX0ch0v2LylVBL6VCtZX1mMGA+Byf9xSy+lecFxa59472Uc27/dwiU88XumStr4lzO3HEVG/jdxw+1g+ZG1F7Kn+4LCJpePsLaUJSDru7xdraPdH6Ic1r/4Ez5yM0dfSinD/lb2AzDjAi78k57Jh8drDW0ZqTrTocUE/C7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptpL/nbpk9T+v+jTg3kHRah552jRDfEFyh+P+CPVQ+I=;
 b=ngB+Lf3g3cbVFqgAKox3dabKVImFYu3caZndkJE+A2nh5rXvvS+WDQZjf+Ejn/CRm8paEzJEPZqeG5T0WaFyP9l3rUoIls9AqRiXdTTkohjy1asRbVpiYLdVdWG3rmPMjvUSSlbqzqgAF1UgCFeDKLdngjWUBMa8p+sb8hRIjHA6DQiGccUumSo+r2JOw0FB8VlKlQwXT0cOReYDyajpE1tdNa4eZ1KlLQzcO4Xl8yC4E1NuBgfEgVzHn4Oiq0esYkD2Ono8+MMNuAaNdCWg0DShRjxAOWVP2oQeDb5jKpXIrJ3rtlqbqYOtCa/aEuNNDDqB6SohDc/2lDSireaPtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptpL/nbpk9T+v+jTg3kHRah552jRDfEFyh+P+CPVQ+I=;
 b=Gg90XSmTUrkOIWm+gNIza3gyBX7VmNSI61AbY6xg8diqLe0M/uGDOq7w4tTxZmdfkfX1w03UV7EOJjlOyRApegbGd8BgtZMWrSzz13f4QnoouGYUjhwBvwh0RyFoXC/X6fr/E6L9furp3Y0u6p4imdSvaqcYmB4A8pGdUQ0pBFs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0401MB2500.eurprd04.prod.outlook.com (2603:10a6:203:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 13:30:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 13:30:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Thread-Topic: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Thread-Index: AQHYHKbrycuT10vzCEeS0T0tAzVYxayJprYA
Date:   Tue, 8 Feb 2022 13:30:16 +0000
Message-ID: <20220208133016.axi7ruhop2lc65ly@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
In-Reply-To: <20220208044644.359951-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af374180-3757-4810-d967-08d9eb072525
x-ms-traffictypediagnostic: AM5PR0401MB2500:EE_
x-microsoft-antispam-prvs: <AM5PR0401MB2500465DDDF84386A5DA7DD3E02D9@AM5PR0401MB2500.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BMzfba7sCjl1AIa5C8ST+hGE3Q0rSrKtQn3QYw/bPEPOdGtZ3JSzg30XzO8ljXYgC1U0m2/vmuBIKlfQ9DE3w9pbqp6o+PK3y0CFLgqbzpKpLQzFG++VyxqRRFo/K7o5zX0qC2t+26hdJJgiG06wvXcpDg3YYaI3fuDCKoin6VHYJZal+6/o8cbfyY0C6RimrvXxX/sUf1wy1bwF14QWahqUeU3HI7Vv6IJGGhgXSZwUqambhYB8lrnBmZUTfEMfWOoUR1gGQjrCRIPfgQw8OaQhrikIVnAph6aqrI1TuQDEoAvz8DSf2NSXIhPdd8gqR8jRUTHXPL7/x3PGK8Kqy9PeQfQLg4TFProZwKeQCRG+Fo/HhIHVOiUXpd7Em86m59fl0O4LiZ3oeXKNXQ92PE9/xKjVkSghM7ach2f1mgBbNGQpTyMBNYrq90jNhJBAlfYJP5ZYQWje++5Wvbez7LsvDQUzcUo/sDlLAzuk60TE28GePmmjmebG3yAnLEgXQAecRsOOdxOuPkzK4kaiSwze70r4t56rvNaqM5Qgwo5R+qsBYQM5Prr6n623arQ6kPCCejno7Z8oxjQGXyS+AEIkTrd8yEwVv8Biq6XOniDmD97YIoFeiGVkoO4zDjke/cK6CeqPNQYfJps22jWm7nXVgfFmNTvkvoJ/rnRfJUkqz4D+oKDR0YncgPM4iATwCMGULUzWxIHEIp5dzrv/KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(6486002)(1076003)(2906002)(186003)(45080400002)(26005)(5660300002)(38100700002)(91956017)(38070700005)(66446008)(66476007)(66556008)(64756008)(6916009)(83380400001)(316002)(54906003)(9686003)(86362001)(6512007)(71200400001)(8676002)(44832011)(33716001)(8936002)(4326008)(66946007)(122000001)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CdPARb22MfWqGol5orGEETjUb8Adl9KUuB97kRHPAQ+O4Zhelk+rWRJhGHt+?=
 =?us-ascii?Q?o8jK8c+XSm/cUtPH1BrWR0OTOignIuIc3JqxoXBAhXRtR6qDnFMbnn8e2TSB?=
 =?us-ascii?Q?4XV9SBfKXYKGz9Xx+ZI6X1xsEp81R6XB//YZ+4dM2N8EaTd6PfaI6uw3P/f7?=
 =?us-ascii?Q?s6cjc3hGVCCxro58r/89m+idW1NyZRbhP7a9vI6cAgqgFyfAvO8uYjUDYeGc?=
 =?us-ascii?Q?yNyYHybbzhnFPnur3DdkS13joIWtBJtJBIfJ7K1YmzPbWJkS3VigKc/sqQM9?=
 =?us-ascii?Q?H37apc7AyWZI7L/KvxZOaddC09oW7v4Ie4nWSHU82CdWXiihSuq0CG/wk1iw?=
 =?us-ascii?Q?3yZZFndrHkPa5xtGglw84YTe+l+K8OcN9BVvUzl0be5BeIGEbK41xQqAU4tn?=
 =?us-ascii?Q?S/53QQlCSziMRwlTrmFnaHs+5QcTI991eiUZlF5ojBL2uOyCNkV8WY/gytdq?=
 =?us-ascii?Q?P8fMqkl5hnV+rsKtXaQpfYj0NJ9t49WxSW7RQQ7q9+MYbjELSsB2zCIqsF6v?=
 =?us-ascii?Q?QlrzarCDU5a8wO0WWJLC6VDHnjTucZymw/QLpmmgxRv7zqmSCRX4VpynaiWV?=
 =?us-ascii?Q?aLYiOWcvOa14w+E/0WLG23ohurbkRHoZR3xhuzhm0hfCrDhp2Z+pIMLrnXTo?=
 =?us-ascii?Q?PdkFFKlns/R00ceDz1Ss7RpshPbivxcHVHMqS7Q246J/kfpEyXH3O3/GyaT5?=
 =?us-ascii?Q?Xv8sz62qe7Z98JIu2yUMk/X/y2b38Dnt4xBpFAL0oBXvubZRW1MfigoXUbq+?=
 =?us-ascii?Q?GEvbIb9ivdWDyj7LGtGIY6ag0WqO9iuMe4NQ/6dsKVXfXjY5PMH5dyk7qmU+?=
 =?us-ascii?Q?JS4N/j5c+mCuMhckiYowUTWawDxnOILGaiIjQnznFko2rD/7V/gkcfmqs2rm?=
 =?us-ascii?Q?dnyU4nMxuxfNshNeRD6MGbLCLx14gCkSEcjCDNbdlJY+xsMLoQSShLMVxv72?=
 =?us-ascii?Q?4GR5m13SWK+bQILY288mNas//ETUcseZWnhrX0KwY/P3aWZUh57phovKIixR?=
 =?us-ascii?Q?zUROmrg874Kwzh4q32Xiy+Dwy1/CzgN8ZuGiAOXnmNhTxnnHftWD8Mv+b4eO?=
 =?us-ascii?Q?a5VEirEzPAK2GunQAL6mj4LZW7hkF7K1Xzxzghk9px4ghIjg7zBrkTBFpknP?=
 =?us-ascii?Q?XLNDevdtc6EOlo87DnPd1tOai6ifhuJhuFvIU5dK2UZpJdVhaC5wTvGdOASA?=
 =?us-ascii?Q?mi2qfw1tG9auDvmPcQLjL3Q0XmyVmjiju3N2vsZjnYMxj0D05c6rAkMqyPh9?=
 =?us-ascii?Q?UymcN2HmQvm37VuEpbZ0ap1FEvD/KUeDcIsXzMcs1B0VyRPUy8QcaYEDxBTy?=
 =?us-ascii?Q?3Daji6HVmFhsyjlM5N5aQy9WDXEM4C/lCoYxrG4JksifEI+yP8P0IpjCEZz0?=
 =?us-ascii?Q?+oZcgl0ASqtKD3jEsgZ7dzZ6hvkRM0fc1PLcqf/5q0WSk0HoXNkn3K1NgMJX?=
 =?us-ascii?Q?vUzn9i8yUhdqc0WqKoXcaBxK7Hfku3Trkz13NLu343PmC0K2rYoHHNnakmgA?=
 =?us-ascii?Q?jl5+7z5Cc62UdwKEoXxWyxseoIOCPyMYhrf1HE3V4tUWDTM5hdjXOYzK4rF8?=
 =?us-ascii?Q?sTr9MMz74UWX7hOYX7nyvKKVtSgY/RewP3CIYmFtxIFJGIohnWxS+BDcwDdC?=
 =?us-ascii?Q?U9fvxHHF6vMm5iMtO6EgeZdm2WykGJR3E0lg2//PSNqP?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7432C49C2EDFC54F832E585C5EFBA77D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af374180-3757-4810-d967-08d9eb072525
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 13:30:16.9390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79uaHUbq/7xgIUQyOacorj0H7P0TjWNNXHRZ6YkXZ08lnYYmxDx0cTuZ7wYO6fFMAVojOPZKHEa8o+JtVoouDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2500
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 08:46:41PM -0800, Colin Foster wrote:
> Ocelot loops over memory regions to gather stats on different ports.
> These regions are mostly continuous, and are ordered. This patch set
> uses that information to break the stats reads into regions that can get
> read in bulk.
>
> The motiviation is for general cleanup, but also for SPI. Performing two
> back-to-back reads on a SPI bus require toggling the CS line, holding,
> re-toggling the CS line, sending 3 address bytes, sending N padding
> bytes, then actually performing the read. Bulk reads could reduce almost
> all of that overhead, but require that the reads are performed via
> regmap_bulk_read.
>
> v1 > v2: reword commit messages
> v2 > v3: correctly mark this for net-next when sending
> v3 > v4: calloc array instead of zalloc per review
> v4 > v5:
>     Apply CR suggestions for whitespace
>     Fix calloc / zalloc mixup
>     Properly destroy workqueues
>     Add third commit to split long macros
>
>
> Colin Foster (3):
>   net: ocelot: align macros for consistency
>   net: mscc: ocelot: add ability to perform bulk reads
>   net: mscc: ocelot: use bulk reads for stats
>
>  drivers/net/ethernet/mscc/ocelot.c    | 78 ++++++++++++++++++++++-----
>  drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
>  include/soc/mscc/ocelot.h             | 57 ++++++++++++++------
>  3 files changed, 120 insertions(+), 28 deletions(-)
>
> --
> 2.25.1
>

Please do not merge these yet. I gave them a run on my board and the
kernel crashed on boot.

[    8.043170] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address =
0
[    8.050241] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address =
1
[    8.057142] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address =
2
[    8.064021] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address =
3
[    8.128668] ------------[ cut here ]------------
[    8.133315] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_vsc9=
959.c:1007 vsc9959_wm_enc+0x2c/0x40
[    8.143107] Modules linked in:
[    8.146181] CPU: 1 PID: 44 Comm: kworker/u4:2 Not tainted 5.17.0-rc2-070=
10-ga9b9500ffaac-dirty #2104
[    8.155355] Hardware name: LS1028A RDB Board (DT)
[    8.160079] Workqueue: events_unbound deferred_probe_work_func
[    8.165945] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    8.172940] pc : vsc9959_wm_enc+0x2c/0x40
[    8.176967] lr : ocelot_setup_sharing_watermarks+0x94/0x1fc
[    8.182568] sp : ffff800008863810
[    8.185896] x29: ffff800008863810 x28: 0000000000000308 x27: 00000000000=
00001
[    8.193079] x26: 000000000300001a x25: 0000000000000008 x24: 00000000000=
00080
[    8.200261] x23: 0000000088888889 x22: 0000000000000000 x21: 00000000000=
00000
[    8.207441] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e2afa=
23b28
[    8.214623] x17: 0000000000000015 x16: 0000000000000041 x15: 00000000000=
00000
[    8.221803] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 00000000000=
00009
[    8.228984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e2ad6=
ce0f8
[    8.236165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 00000000000=
00001
[    8.243345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 00000000000=
00000
[    8.250525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 00000000000=
040c0
[    8.257706] Call trace:
[    8.260162]  vsc9959_wm_enc+0x2c/0x40
[    8.263841]  ocelot_devlink_sb_register+0x33c/0x380
[    8.268742]  felix_setup+0x438/0x750
[    8.272334]  dsa_register_switch+0x988/0x114c
[    8.276713]  felix_pci_probe+0x138/0x1fc
[    8.280654]  local_pci_probe+0x4c/0xc0
[    8.284423]  pci_device_probe+0x1b0/0x1f0
[    8.288451]  really_probe.part.0+0xa4/0x310
[    8.292654]  __driver_probe_device+0xa0/0x150
[    8.297030]  driver_probe_device+0xcc/0x164
[    8.301231]  __device_attach_driver+0xc4/0x130
[    8.305695]  bus_for_each_drv+0x84/0xe0
[    8.309547]  __device_attach+0xe4/0x190
[    8.313400]  device_initial_probe+0x20/0x30
[    8.317601]  bus_probe_device+0xac/0xb4
[    8.321454]  deferred_probe_work_func+0x98/0xd4
[    8.326004]  process_one_work+0x294/0x700
[    8.330037]  worker_thread+0x80/0x480
[    8.333717]  kthread+0x10c/0x120
[    8.336961]  ret_from_fork+0x10/0x20
[    8.340554] irq event stamp: 50432
[    8.343968] hardirqs last  enabled at (50431): [<ffffd8e2ade442b0>] _raw=
_spin_unlock_irqrestore+0x90/0xb0
[    8.353581] hardirqs last disabled at (50432): [<ffffd8e2ade36e44>] el1_=
dbg+0x24/0x90
[    8.361448] softirqs last  enabled at (50148): [<ffffd8e2ac6908f0>] __do=
_softirq+0x480/0x5f8
[    8.369923] softirqs last disabled at (50143): [<ffffd8e2ac728e3c>] __ir=
q_exit_rcu+0x17c/0x1b0
[    8.378577] ---[ end trace 0000000000000000 ]---
[    8.383304] ------------[ cut here ]------------
[    8.387942] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_vsc9=
959.c:1007 vsc9959_wm_enc+0x2c/0x40
[    8.397729] Modules linked in:
[    8.400800] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W       =
  5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
[    8.411369] Hardware name: LS1028A RDB Board (DT)
[    8.416092] Workqueue: events_unbound deferred_probe_work_func
[    8.421955] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    8.428948] pc : vsc9959_wm_enc+0x2c/0x40
[    8.432975] lr : ocelot_setup_sharing_watermarks+0xc0/0x1fc
[    8.438573] sp : ffff800008863810
[    8.441900] x29: ffff800008863810 x28: 0000000000000308 x27: 00000000000=
00001
[    8.449081] x26: 000000000300001a x25: 0000000000000008 x24: 00000000000=
00080
[    8.456262] x23: 0000000088888889 x22: 0000000000000000 x21: 00000000000=
00000
[    8.463443] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e2afa=
23b28
[    8.470623] x17: 0000000000000015 x16: 0000000000000041 x15: 00000000000=
00000
[    8.477804] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 00000000000=
00009
[    8.484984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e2ad6=
ce124
[    8.492165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 00000000000=
00001
[    8.499345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 00000000000=
00001
[    8.506525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 00000000000=
040c0
[    8.513705] Call trace:
[    8.516161]  vsc9959_wm_enc+0x2c/0x40
[    8.519840]  ocelot_devlink_sb_register+0x33c/0x380
[    8.524740]  felix_setup+0x438/0x750
[    8.528331]  dsa_register_switch+0x988/0x114c
[    8.532708]  felix_pci_probe+0x138/0x1fc
[    8.536648]  local_pci_probe+0x4c/0xc0
[    8.540415]  pci_device_probe+0x1b0/0x1f0
[    8.544443]  really_probe.part.0+0xa4/0x310
[    8.548646]  __driver_probe_device+0xa0/0x150
[    8.553022]  driver_probe_device+0xcc/0x164
[    8.557225]  __device_attach_driver+0xc4/0x130
[    8.561688]  bus_for_each_drv+0x84/0xe0
[    8.565540]  __device_attach+0xe4/0x190
[    8.569393]  device_initial_probe+0x20/0x30
[    8.573594]  bus_probe_device+0xac/0xb4
[    8.577447]  deferred_probe_work_func+0x98/0xd4
[    8.581997]  process_one_work+0x294/0x700
[    8.586026]  worker_thread+0x80/0x480
[    8.589706]  kthread+0x10c/0x120
[    8.592949]  ret_from_fork+0x10/0x20
[    8.596541] irq event stamp: 50450
[    8.599955] hardirqs last  enabled at (50449): [<ffffd8e2ade442b0>] _raw=
_spin_unlock_irqrestore+0x90/0xb0                                          =
                                                     =20
[    8.609566] hardirqs last disabled at (50450): [<ffffd8e2ade36e44>] el1_=
dbg+0x24/0x90
[    8.617431] softirqs last  enabled at (50446): [<ffffd8e2ac6908f0>] __do=
_softirq+0x480/0x5f8
[    8.625907] softirqs last disabled at (50435): [<ffffd8e2ac728e3c>] __ir=
q_exit_rcu+0x17c/0x1b0
[    8.634559] ---[ end trace 0000000000000000 ]---
[    8.640586] device eth1 entered promiscuous mode
[    8.645499] Unable to handle kernel paging request at virtual address 00=
000010400020bc
[    8.653496] Mem abort info:
[    8.656340]   ESR =3D 0x96000044
[    8.659413]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[    8.664784]   SET =3D 0, FnV =3D 0
[    8.667855]   EA =3D 0, S1PTW =3D 0
[    8.671044]   FSC =3D 0x04: level 0 translation fault
[    8.675979] Data abort info:
[    8.678875]   ISV =3D 0, ISS =3D 0x00000044
[    8.682762]   CM =3D 0, WnR =3D 1
[    8.685795] [00000010400020bc] user address but active_mm is swapper
[    8.692272] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[    8.697865] Modules linked in:
[    8.700928] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W       =
  5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
[    8.711490] Hardware name: LS1028A RDB Board (DT)
[    8.716206] Workqueue: events_unbound deferred_probe_work_func
[    8.722065] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    8.729051] pc : ocelot_phylink_mac_link_down+0x70/0x314
[    8.734381] lr : felix_phylink_mac_link_down+0x24/0x30
[    8.739536] sp : ffff800008863840
[    8.742856] x29: ffff800008863840 x28: 0000000000000000 x27: ffffd8e2af8=
ef180
[    8.750022] x26: 0000000000000001 x25: 0000001040002000 x24: 00000000000=
00000
[    8.757187] x23: 0000000000000180 x22: ffff2d1703a92000 x21: 00000000000=
00004
[    8.764352] x20: 0000000000000004 x19: ffff2d17039d8010 x18: ffffd8e2afa=
23b28
[    8.771516] x17: 0000000000040006 x16: 0000000500030008 x15: fffffffffff=
fffff
[    8.778680] x14: ffffffffffff0000 x13: ffffffffffffffff x12: 00000000000=
00010
[    8.785845] x11: 0101010101010101 x10: 0000000000000004 x9 : ffffd8e2ad3=
d0814
[    8.793009] x8 : fefefefefeff6a6d x7 : 0000ffffffffffff x6 : 00000000000=
00000
[    8.800173] x5 : 00000000ffffffff x4 : 0000000000000001 x3 : 000000000d0=
00007
[    8.807338] x2 : 0000000000000010 x1 : 0000000000000000 x0 : 00000010400=
02000
[    8.814502] Call trace:
[    8.816949]  ocelot_phylink_mac_link_down+0x70/0x314
[    8.821929]  felix_phylink_mac_link_down+0x24/0x30
[    8.826734]  dsa_port_link_register_of+0xa8/0x240
[    8.831454]  dsa_port_setup+0xb4/0x180
[    8.835212]  dsa_register_switch+0xdb4/0x114c
[    8.839581]  felix_pci_probe+0x138/0x1fc
[    8.843515]  local_pci_probe+0x4c/0xc0
[    8.847275]  pci_device_probe+0x1b0/0x1f0
[    8.851296]  really_probe.part.0+0xa4/0x310
[    8.855490]  __driver_probe_device+0xa0/0x150
[    8.859860]  driver_probe_device+0xcc/0x164
[    8.864054]  __device_attach_driver+0xc4/0x130
[    8.868510]  bus_for_each_drv+0x84/0xe0
[    8.872355]  __device_attach+0xe4/0x190
[    8.876200]  device_initial_probe+0x20/0x30
[    8.880395]  bus_probe_device+0xac/0xb4
[    8.884240]  deferred_probe_work_func+0x98/0xd4
[    8.888783]  process_one_work+0x294/0x700
[    8.892808]  worker_thread+0x80/0x480
[    8.896480]  kthread+0x10c/0x120
[    8.899715]  ret_from_fork+0x10/0x20
[    8.903303] Code: 52800202 f874d839 52800001 aa1903e0 (b900bf25)
[    8.909417] ---[ end trace 0000000000000000 ]---

Investigating...=
