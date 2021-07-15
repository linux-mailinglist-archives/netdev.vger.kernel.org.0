Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902003C956F
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 03:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhGOBOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 21:14:51 -0400
Received: from mail-dm6nam10on2091.outbound.protection.outlook.com ([40.107.93.91]:54272
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229909AbhGOBOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 21:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDcH5vdMbq0bjRvjSoCJvTrtAZbtVWNKN5n17fm7Lb4NrMmAVPVZGngV0d19VMyI4IMXGrXByaZbT8O7NpyhfazBCCX9YqaLLb+PhZqAAmT5YQ82i1jpUVdwOStNVXvyDO49wJAJtLOsi8e9c6W6bjDp2z+OuIsRP/NkAWMgvcAoHg7+IYr9FhgjE3PCEjvyMnZ584kskBIDlv5Oh2NxGmrQLCKY/Tph7bpuRLv7Z9+8mGW+On9qiXupwWd9B9bjx5CNgVZVhCN+2TFA7OD3bZZzOZ9gPqgRQNPxt+bkjroBFxoV0vScz2NRAlk9gGnVK1vSQnuPa6PDZY8OxqbliA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjtP/IWiVInmU6j0I/o8MVO4MakrpNn+UXyEQDR6Q1A=;
 b=SfY310QslWhrLpc0PMtZ/4ZE7SnnnkzDodE0gpGwVMFwa5YL5lBaxD2L+0OMRwPNWE5MxRNXhWtUrfJ4OJHlWMVFE1LDsVJgxGGsss71DCXkctM9AT147Qx4P+JdIivhTUSCsdyKXbM3YYvpJM7xXgnK8pSh5krZG8cXUyUxr5c6mvpdRUL1aADVdOM+sQfanXEF+ZPB9bFWqgpsI+p3hPK3zTdAC5Xlq6jWxG52ooFhRPTRifa5zfEpkHo0HcTDDM2SUH7GhRZEYEfA2RvZ1n1x0EeHMcS76yRWPgHnNgddljBMUt1jnIjr+3eI+KAV6SkqtXhfPjX7AGJIzEZO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjtP/IWiVInmU6j0I/o8MVO4MakrpNn+UXyEQDR6Q1A=;
 b=UFYOhId9ad09yVa8ougAfNUVNISF7Sa55Ssi0weWRfVAqRAymP79S3qZkT3prGaS+aYDipKGUGw+ci1ncYMVlXC6xKtIaSS4qwg648POrJhU8JKh+bCEzrYF8YBKIoWCsYxXvwn5LEPmL4hCivR4LEXpTYE1zhRpTvp74MsbS9Y=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1719.namprd21.prod.outlook.com (2603:10b6:a02:c0::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.0; Thu, 15 Jul
 2021 01:11:55 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02%5]) with mapi id 15.20.4331.014; Thu, 15 Jul 2021
 01:11:55 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: Add5D8Zto2s5ndNhQDWxYbgsDd9OBQABZMKw
Date:   Thu, 15 Jul 2021 01:11:55 +0000
Message-ID: <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=db47dedc-4fc3-455e-8eb3-f852bb4a6534;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-07-14T19:38:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df258fe2-5710-445a-408c-08d9472d8949
x-ms-traffictypediagnostic: BYAPR21MB1719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR21MB1719047A19CE88F4F5449663BF129@BYAPR21MB1719.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JX+J0hRS3pmRguaT7Ew8eIbwUOFzxk2SxAHX+ClOtN5BsFXA4eCBHep2QiIozHUD6VOy09BTg5TvZHw8Li7Yn7qi/WC6Kxny4U4yoTubyvsYTo8EVsTa4YxzSdu7CWxgToJd4lUKuNN9oMLmqGKcX+QLrFSQOzMEVCqdanX62hm9C0UHarJeGDu9pWadSfC2INxK5wQoCrFR3viclrccNtz48Mm/k7h0xltiVAeqczunYsmkWgwJsGI8z4Le5SehpyD2BblFauaKoN/48aDxAYv3HYEfdKB99Dknd+kiVqPLOZJeDeo/Q1LZBytnO2Ze1bICYjBwGlM0ejyW/s2DMpmtfG3AhsTkizeGafNs34zW03PtfWyA3HvXN0LjwDwxrlwhSyBi0sqzMP3P55nLKDmFld/JvWncQwcrBctflpRAkC/Nx6zw8/FBLPeX1KmfOAQ2XtUWrbULLWLKFRf11e0C9wMeu1xc+dRrBUylrsAlZJq7I+wIfkwmTbmoIH4VaWoHc0v0GXJLJqm6mCaN9ELje1scXl3nT88RnLcQ/UWKeUtXYKxZQ4PXHRzRElrvPCfzRdPHdIXakUyGtSucfrmBJKnNLnC8ijrRDXwjuYLMnIBKiOM2nx2iIOKwLpKM6Gp65rHb6Y0cOHdnraq722sJd2QGw3H2O6rSy/rMFcZzV/Di81dZeyNF53RfiiGuQtKnvF7hks+Pd/IgK7Won36DpSuWcNQeieeGtqTl/S/NAE/wi2Nw73uDfhUeb1H+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55016002)(71200400001)(110136005)(2906002)(7696005)(186003)(5660300002)(66446008)(53546011)(26005)(6506007)(8936002)(52536014)(8676002)(83380400001)(2940100002)(76116006)(66556008)(64756008)(122000001)(66946007)(82960400001)(4326008)(8990500004)(9686003)(478600001)(316002)(10290500003)(66476007)(33656002)(82950400001)(86362001)(54906003)(491001)(38070700004)(505234006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Dl1CjpG+acKBKengQvINZzNiNOJ7tqpfYvw2wKn/cFuQRSsPEpYTyGyU+Cg5?=
 =?us-ascii?Q?ECW4XaQ52uN+ap3c9Z8mSIo1Mvv29J1bZ+ODv7oXZnc2yvN3tPAqVMGIV5rZ?=
 =?us-ascii?Q?28k5tVtOPqnF1tVGAi9aYThdgLfOCy/bhPoBVLYDFnlC2W4B3PPSwmQJaOXm?=
 =?us-ascii?Q?FxcSXgCUKt76G/+8ZUgss/fP0Lzuwj/dL6v8ifOuDMIx572TaLxZwG356xh+?=
 =?us-ascii?Q?ETmPqfgd2mxkoXQHxqgdsruHG3RU3Pafkr1sF7MMHaI/2KHeeRwWSFVUP5Pe?=
 =?us-ascii?Q?JIgDXI7TbsRLEur/BtMxwpulVZZiTBO9P8229I3BzrdHh73B+zvsLqIGg+Ji?=
 =?us-ascii?Q?i9+4eT2b+YVaLBSsNt8P2XEHjiWkT6IsNhKsfbS3a5PXoATEjdvEXULsJDiC?=
 =?us-ascii?Q?m9RSCuN5PNGFqpehM1ucU3FSOi6axtV/sSu8/ZW3vDKZRKoLFNEFIBoHFFM1?=
 =?us-ascii?Q?p1kYz3knwlM+RX18cqySUH1Wnq7oPRRsyGWHbwmb/RqlFh+azONQXJAEZjCf?=
 =?us-ascii?Q?NyvKJe1bBerhoJoyHJhsHH85If+F+tqwh7jxeVDoOGPsRL9u1tuPQLXFQ67C?=
 =?us-ascii?Q?H89tccOCBCinc4jEKl9o1vlULRTeASJkxh2J4ARFzDsKDpoWHyju78985L/M?=
 =?us-ascii?Q?r1lNFMz2ArzZu/xpt3U1q0mSyKUdoZODUdWYpkrGSHUGMZu5dMkcQFxii/56?=
 =?us-ascii?Q?rwh7fpDyOOCnWJ8D1Wz7B+DY4wOPPDVWTcJsUlAPqp4cW75Y5qTZKeDuMZtw?=
 =?us-ascii?Q?d5m+dCTwJdlpOHvfOzq2VQkqeCBPTyNsK/rqQQycr1UeuFmxnj0vj7hPbXby?=
 =?us-ascii?Q?Qd2iWADWxw/v7sE1ypUis3pbyFIFAhHKBHu70gPJhRwdnhXQpw26K7c7oqtm?=
 =?us-ascii?Q?xefvCarl50zbYQUCJs9xfhcb/2GoIp3Sp5xQhbtHmTKwv2gPgudxcfl2gb9C?=
 =?us-ascii?Q?Ei4J+Uz6cWjVC5MrbEhEErOrDTXLd/qE5n0MvvXqw79B0Lx1WYL80q27FMSZ?=
 =?us-ascii?Q?3/BEqwuNCylrEtv6iKUwSJN2r8M27jehzMvjvlALDlLJKg/Ia9Rys04BFqbA?=
 =?us-ascii?Q?ouRb2zmW5Zw+5ZCQgVY08HL9YgVIV6OaR4l+oULj9pao+SqOJNRFYcu4DaZ/?=
 =?us-ascii?Q?fO7H8urkZD94q7tLjdbs25joRpERgHtpDT9HlRohTj0dVoS+/2EWMy+Wq2++?=
 =?us-ascii?Q?3ioQxHmXEl5QzB5d53Hf/y8/pYn6CaJMBwzdI5aO1DtLNBRq0oGBsWNP0rZc?=
 =?us-ascii?Q?td84QRmHZ05/7MW9Cek6QmmsIGC2/4+rwFwd0q1q43P4P54Zdix9Faf18TeU?=
 =?us-ascii?Q?VjMsnQiTR7CNQh2XHO1tF9ag?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df258fe2-5710-445a-408c-08d9472d8949
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 01:11:55.0596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZS2gkJvgC48ymhosWFLz3rIAqUZNc9rDZj8Z7pWtQULeuSoYbUquwXS6X1QTezijKE9+ppgElJ+OAlXkqzbVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1719
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Wednesday, July 14, 2021 5:39 PM
> To: netdev@vger.kernel.org; x86@kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; linux-kernel@vger.kernel.org
> Subject: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=3D8
>=20
> Hi all,
> I'm seeing a strange "no MSI-X interrupt" issue with the Mellanox NIC
> driver on a physical Linux host [1], if I only enable part of the CPUs.
>=20
> The physical host has 104 logical processors (2 sockets, and each socket
> has 26 cores with HT enabled). By default, the Mellanox driver works fine
> when Linux boots up.
>=20
> If I only use 1, 2, 32, 64, 96 processors by the Linux kernel parameter
> "maxcpus=3DX" or "nr_cpus=3DX", everthing still works fine.
>=20
> However, if the Linux host OS only uses 4, 8 or 16 processors, the
> mlx5_core driver fails to load as it can not receive interrupt when
> creating EQ (maxcpus=3D8 or 16), or the driver can load but it reports a
> timeout error when I try to bring the NIC up (maxcpus=3D4). This issue is
> a 100% repro.
>=20
> For example, with "maxcpus=3D8", I get the below timeout error when tryin=
g
> to load mlx5_core:
>=20
> # modprobe mlx5_core
> [ 1475.716688] mlx5_core 0000:d8:00.0: firmware version: 16.25.8352
> [ 1475.722742] mlx5_core 0000:d8:00.0: 126.016 Gb/s available PCIe
> bandwidth (8.0 GT/s PCIe x16 link)
> [ 1475.991398] mlx5_core 0000:d8:00.0: E-Switch: Total vports 2, per vpor=
t:
> max uc(1024) max mc(16384)
>=20
> [ 1537.020001] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416)=
:
> Recovered 1 EQEs on cmd_eq
> [ 1537.028969] mlx5_core 0000:d8:00.0:
> wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]: CREATE_EQ(0x301)
> recovered after timeout
> [ 1598.460003] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416)=
:
> Recovered 1 EQEs on cmd_eq
> [ 1598.468978] mlx5_core 0000:d8:00.0:
> wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]: CREATE_EQ(0x301)
> recovered after timeout
> [ 1659.900010] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416)=
:
> Recovered 1 EQEs on cmd_eq
> [ 1659.908987] mlx5_core 0000:d8:00.0:
> wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]: CREATE_EQ(0x301)
> recovered after timeout
> [ 1721.340006] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416)=
:
> Recovered 1 EQEs on cmd_eq
> [ 1721.348989] mlx5_core 0000:d8:00.0:
> wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]: CREATE_EQ(0x301)
> recovered after timeout
>=20
> When this happens, the mlx5_core driver is stuck with the below
> call-trace, waiting for some interrupt:
>=20
> # ps aux |grep modprobe
> root        1416  0.0  0.0  11024  1472 ttyS0    D+   08:08   0:00
> modprobe mlx5_core
> root        1480  0.0  0.0   6440   736 pts/0    S+   08:15   0:00
> grep --color=3Dauto modprobe
>=20
> # cat /proc/1416/stack
> [<0>] cmd_exec+0x8a7/0x9b0 [mlx5_core]
> [<0>] mlx5_cmd_exec+0x24/0x50 [mlx5_core]
> [<0>] create_map_eq+0x2a6/0x380 [mlx5_core]
> [<0>] mlx5_eq_table_create+0x504/0x710 [mlx5_core]
> [<0>] mlx5_load+0x52/0x130 [mlx5_core]
> [<0>] mlx5_init_one+0x1cc/0x250 [mlx5_core]
> [<0>] probe_one+0x1d3/0x2a0 [mlx5_core]
> [<0>] local_pci_probe+0x45/0x80
> [<0>] pci_device_probe+0x10f/0x1c0
> [<0>] really_probe+0x1c1/0x3b0
> [<0>] __driver_probe_device+0x109/0x180
> [<0>] driver_probe_device+0x23/0xa0
> [<0>] __driver_attach+0xbd/0x160
> [<0>] bus_for_each_dev+0x7c/0xc0
> [<0>] driver_attach+0x1e/0x20
> [<0>] bus_add_driver+0x152/0x1f0
> [<0>] driver_register+0x74/0xd0
> [<0>] __pci_register_driver+0x68/0x70
> [<0>] init+0x6b/0x1000 [mlx5_core]
> [<0>] do_one_initcall+0x46/0x1d0
> [<0>] do_init_module+0x62/0x250
> [<0>] load_module+0x2503/0x2730
> [<0>] __do_sys_finit_module+0xbf/0x120
> [<0>] __x64_sys_finit_module+0x1a/0x20
> [<0>] do_syscall_64+0x38/0xc0
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> To make the issue even weirder, when the issue happens (e.g. when Linux
> only uses 8 processors), if I manually bring CPU #8~#31 online [2] and
> then bring them offline [3], the Mellanox driver will work fine!
>=20
> This is a x86-64 host. Is it possibe that the IOMMU Interrrupt Remapping
> is not proprely set up with maxcpus=3D4, 8 and 16?
>=20
> The above tests were done with the recent Linux v5.14-rc1 kernel. I also
> tried Ubuntu 20.04's kernel "5.4.0-77-generic", and the Mellanox driver
> exhibits exactly the same issue.
>=20
> I have Linux/Windows dual-boot on this physical machine, and Windows
> doesn't have the issue when I let it only use 4, 8 and 16 processors.
> So this looks like somehow the issue is specific to Linux.
>=20
> Can someone please shed some light on this strange issue? I'm ready
> to provide more logs if needed. Thanks!
>=20
> PS, the physical machine has 4 NVMe controllers and 4 Broadcom NICs,
> which are not affected by maxcpus=3D4, 8, and 16.
>=20
> [1] This is the 'lspci' output of the Mellanox NIC:
> d8:00.0 Ethernet controller: Mellanox Technologies MT27800 Family
> [ConnectX-5]
>         Subsystem: Mellanox Technologies MT27800 Family [ConnectX-5]
>         Flags: bus master, fast devsel, latency 0, IRQ 33, NUMA node 1
>         Memory at f8000000 (64-bit, prefetchable) [size=3D32M]
>         Expansion ROM at fbe00000 [disabled] [size=3D1M]
>         Capabilities: [60] Express Endpoint, MSI 00
>         Capabilities: [48] Vital Product Data
>         Capabilities: [9c] MSI-X: Enable+ Count=3D64 Masked-
>         Capabilities: [c0] Vendor Specific Information: Len=3D18 <?>
>         Capabilities: [40] Power Management version 3
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
>         Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
>         Capabilities: [1c0] Secondary PCI Express
>         Kernel driver in use: mlx5_core
>         Kernel modules: mlx5_core
> 00: b3 15 17 10 46 05 10 00 00 00 00 02 08 00 00 00
> 10: 0c 00 00 f8 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 80 00
> 30: 00 00 e0 fb 60 00 00 00 00 00 00 00 ff 01 00 00
>=20
> [2] for i in `seq 8 31`;  do echo 1 >  /sys/devices/system/cpu/cpu$i/onli=
ne;
> done
> [3] for i in `seq 8 31`;  do echo 0 >  /sys/devices/system/cpu/cpu$i/onli=
ne;
> done
>=20
> Thanks,
> -- Dexuan

(+ the linux-pci list)

It turns out that adding "intremap=3Doff" can work around the issue!

The root cause is still not clear yet. I don't know why Windows is good her=
e.

Thanks,
Dexuan

