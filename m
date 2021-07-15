Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01433C9535
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGOAlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:41:52 -0400
Received: from mail-dm6nam11on2139.outbound.protection.outlook.com ([40.107.223.139]:27232
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229928AbhGOAlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 20:41:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPflpS56ypc+gbki1GpfWMfYh6eXVczuptpmJ89nGlzVJmwREyzCwdWznybfptwOYWEDb3Yxfswu7U2Ka79q5LU+oS8ihfb4WOWMAz1s8NimJPNiniTA5JtDdqxBfA94pEXkU/O1Igrj0glAkTXzL6EFq7ky6jwbH/y/+TudioRILo9uA54YaAqIo8DyNbqL+/5HBADKPKrvDhrBsVy+huLhOCw49jtxTTjFntilgvY24E4V1zPMKH6vS+d+De8YRbKhUr23hDWMV7aJd/I/cKRUnug1AtgY5+qPvAvSwut8TWWo70p9XR2BK2+xHY9ueU55YIXZVG6QE+QY53+ZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJX2a1dn3Q36PdmXkCSPBkXqLYbLGDXBtRwdfXkOAMg=;
 b=NRbu4jPbh23XdeTXROM4xJRGhm9F8XnAXRNIZPlBFv0CAfAFDYoKnH4Vs9jo2SvPa5dmLEqaV1x6thw5ympkS9IgWCM2NtF6Dx2xEH+p+nBm47A7+hIf0xmfZevgbmtVNTaxJgOzPl9tP2XDxNgS7vhhjGmBD/4RW3gKqNyYv6LIG7dHfy1FZcIbew0EVA56RLWpncMZCC7/66+BNbz+YumluOf6mdekMzlv07Jj55FWqQk+7kuNASBnFG3YUjmgP+lNRblZ0shrb00lki9BDyZ/L9JZPrGlDYivCdH9A1KWUiSZMKpOoL6WqPq95RUea79bvxWzDjLbbrryf8+wVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJX2a1dn3Q36PdmXkCSPBkXqLYbLGDXBtRwdfXkOAMg=;
 b=N5GAB3bhs0BNqf9CXnMMOnOCuReOigBVVNGHpuOgAOUPCsYZyuDlDzZynKS3i1Pjdfyx+3V/4R9janbhkUfNry7dD8HisAYPzsOf3dll64NvR8Khd9t+HWvb9c8UqCjvyWyDF5AaSbQvdTU3AtW0kN406FP5UhYf/ROAGuwyPC4=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (20.179.56.207) by
 BY5PR21MB1489.namprd21.prod.outlook.com (20.180.34.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.6; Thu, 15 Jul 2021 00:38:57 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02%5]) with mapi id 15.20.4331.014; Thu, 15 Jul 2021
 00:38:56 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: Add5D8Zto2s5ndNhQDWxYbgsDd9OBQ==
Date:   Thu, 15 Jul 2021 00:38:56 +0000
Message-ID: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=db47dedc-4fc3-455e-8eb3-f852bb4a6534;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-07-14T19:38:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57638ef4-860e-4859-95f0-08d94728ee2a
x-ms-traffictypediagnostic: BY5PR21MB1489:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB1489EBA1CDFD07D9DBF499F0BF129@BY5PR21MB1489.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FHBrHJ6l8JPlkATu1bb/lxxnWyRiOCw0ZdGBdCmbwVCjQjkQhEyx56ByzG0+HunRBAcT1D0F8NWqBqkBBQO4u+tO52SZ4fiG5D5KtZVzKTZS0sGNgYaTRjoiP0Qie0x4KXXKIsThMn6+aI/PBc5NbTrOpfjyg+ZTdVJM7qZdR+vUrrfQrFgkHkK67/oNV5kJTg6k4gvTi5y4zEnuw1tGXLeLKZJNM8rGc/0xBtM3EqNeSpmtkyFZ+oAmAoty6AL2CEHAQA+M/cZssYNO/loIHbi0+2tHOUA4G10EiU0v84Gzyzr63pXbl82AusWoGIbeEFKLQwzIww5wUcUXFKOlptCD3OhcsvhKxflQ2xScPuI1osnZ85D6GrviOqPSBikicG4ZjNR8NCTAHaGu2sSaPSJfA2HHuFqlM6Dekey1a1PkN5g66ENPJEHRg1cd3yS6hqAfRrZcCRg6UuJkWga1Ry8x87m1lD2VDVe3FQ0zXW4OrcKQagb0N9m2sZtbKaq3e86kbr9kSFEANBcJ+iX6t6SfVtlVuU4Ku20kR16KMGRrTYJFd2KfVf7t/YfgmwW8FfX+sKKua9J5PCVZ0AaU6M6v0DzpzW1XJJhz+XAhGb9gE1c2ygY8/7x7YAuqpZ8MQDnV9MoXxHS0lRsDwTofAiG45+l+Dt52bCn+a49wiQexXc5JzQT94iCy3vhIiXKhLZCWzy6IIy4sjsh2ICLxrvCLUP85zIXeqcRPnUC8JPRvvMMB8GnI7HSxOWrXVGBE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(7696005)(8990500004)(5660300002)(478600001)(8676002)(110136005)(83380400001)(55016002)(86362001)(52536014)(316002)(4326008)(2906002)(6506007)(9686003)(66476007)(64756008)(66556008)(66946007)(66446008)(76116006)(71200400001)(8936002)(10290500003)(122000001)(82960400001)(82950400001)(26005)(33656002)(38100700002)(186003)(38070700004)(505234006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ijmBBHNT4kaRAEf0DcSjKZcfxAWrbqQbNqxMxem7no3XyYa9HFaVAQ4rXWEP?=
 =?us-ascii?Q?jRbta31UeZGRXmslvd5ZH0+bYot96v6Hf4YZuEWomMViR57agcaQNraaMLq9?=
 =?us-ascii?Q?jGg4r+XFUtiq3D4CwgC2tN1XEFlkEEwAPnrblen/204Lc+0m3wtqR27zLi+F?=
 =?us-ascii?Q?sz+JtziX6XNoZ3pfqRDmSJH0paTZFjlWwhdkYxHS5KrMbSdU31Qqbxno6yK9?=
 =?us-ascii?Q?xp4RwVZ1J94tEj2GWzDjEM3URoFHmjkaPLXWYegkSulNSluGmQx+biuAilx5?=
 =?us-ascii?Q?2391FURy4wZo4Qk6bg1mPi+/SsfDCltZfkykJRMHPmpurKifvqu8oTNfpNq9?=
 =?us-ascii?Q?TVOVfxGvYg4s/BlM2VTOU7UHfrw4cn4HtyMrzRpIcw+2HBXpdPw/orqkuQVS?=
 =?us-ascii?Q?ay5zakcCHVbun9yBnb5d74R0l08S/dSCi5YHyNr7N/aGixpLdXg7j1UizogA?=
 =?us-ascii?Q?z1ztntuNExbIi7XbPSYPx2JYUwztlyhnJjlAoEYgU0ap92lIZE6jMoY01zYV?=
 =?us-ascii?Q?fpjoKkhowa5U1BMNExkwqS61yomxXvcuivJUTJwk/Hl6IIzUYiJA2XqR5wKy?=
 =?us-ascii?Q?nR036iMO5v2bl3t/qZQwLhFpWio748RE/KxetC3llzoQxvMzwQZ1BxB0xtdn?=
 =?us-ascii?Q?PdVKKED4kSCZznhu5zAzGR82dUKz32RGpKikQqvqEa7SX8CSQQ1eeemdKjDi?=
 =?us-ascii?Q?+JgiTFtnVQs4zrkOMShMph7ARINjvNYiEIoNAQs98tDeSEW2ai9jkZbY0vpV?=
 =?us-ascii?Q?hz3rCSJcAxc/ypN8FsgeKwiaUh1Qc5FHkrYtvTpV6OIgnNPES+zDsu6AoPFW?=
 =?us-ascii?Q?Ddz4WBXITpBQ7XdhP+eYsbnBjIzxsGuneQCClNiDJeuJdquZGVYf71ZLp4R+?=
 =?us-ascii?Q?1FowVInw0obTDFuDeWWLgNRq68A939a4/pi0bpqkhCbea5XGTs4mfjB6T6tr?=
 =?us-ascii?Q?HAVRN9PeCGAkKl+74dGClekC6KpkS5YXUGA/rQQmDVMygYEbRIaOL+2gsjY0?=
 =?us-ascii?Q?K7d/XOsXTLP5ziBFvTjdxahQFrdmzVhfKaDEl60h8B6yYnUkw65Zzvim6ifk?=
 =?us-ascii?Q?WoJTU3TsKUQfgXSbESjgBzulbJK5mDLLo2rnGZSUnETAqDZZ8pjs9FbiS+Kp?=
 =?us-ascii?Q?+/5QBKWEoB7BlCbWn0XxSIzYvpIecCpG00S62pWtgJZwAqaGGVVOp8zY4PM7?=
 =?us-ascii?Q?UsD5ycCtZhYzjWGFbLLXwxpFD37HnQ/LGxmyX7+zLzFgr1yZlf2wHvyxBd22?=
 =?us-ascii?Q?HMvwUe+i4zGysXLP4oE4tEjCTYsllb9gwQ6EBa+S7QyYOFJGtGPSsIWBOahv?=
 =?us-ascii?Q?uOAZxtvk58EY/SXgJbF7dzuW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57638ef4-860e-4859-95f0-08d94728ee2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 00:38:56.7799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SAl9X2E/NyX8PF2P23/th5yaSPDrdjCGfWaL+wcFez4AG2P4owl6fdIpRGRFbifN2Lhv6jGgjsohlQmpxDQhEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
I'm seeing a strange "no MSI-X interrupt" issue with the Mellanox NIC
driver on a physical Linux host [1], if I only enable part of the CPUs.

The physical host has 104 logical processors (2 sockets, and each socket
has 26 cores with HT enabled). By default, the Mellanox driver works fine
when Linux boots up.

If I only use 1, 2, 32, 64, 96 processors by the Linux kernel parameter
"maxcpus=3DX" or "nr_cpus=3DX", everthing still works fine.

However, if the Linux host OS only uses 4, 8 or 16 processors, the
mlx5_core driver fails to load as it can not receive interrupt when
creating EQ (maxcpus=3D8 or 16), or the driver can load but it reports a
timeout error when I try to bring the NIC up (maxcpus=3D4). This issue is
a 100% repro.

For example, with "maxcpus=3D8", I get the below timeout error when trying
to load mlx5_core:

# modprobe mlx5_core
[ 1475.716688] mlx5_core 0000:d8:00.0: firmware version: 16.25.8352
[ 1475.722742] mlx5_core 0000:d8:00.0: 126.016 Gb/s available PCIe bandwidt=
h (8.0 GT/s PCIe x16 link)
[ 1475.991398] mlx5_core 0000:d8:00.0: E-Switch: Total vports 2, per vport:=
 max uc(1024) max mc(16384)

[ 1537.020001] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416): =
Recovered 1 EQEs on cmd_eq
[ 1537.028969] mlx5_core 0000:d8:00.0: wait_func_handle_exec_timeout:1062:(=
pid 1416): cmd[0]: CREATE_EQ(0x301) recovered after timeout
[ 1598.460003] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416): =
Recovered 1 EQEs on cmd_eq
[ 1598.468978] mlx5_core 0000:d8:00.0: wait_func_handle_exec_timeout:1062:(=
pid 1416): cmd[0]: CREATE_EQ(0x301) recovered after timeout
[ 1659.900010] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416): =
Recovered 1 EQEs on cmd_eq
[ 1659.908987] mlx5_core 0000:d8:00.0: wait_func_handle_exec_timeout:1062:(=
pid 1416): cmd[0]: CREATE_EQ(0x301) recovered after timeout
[ 1721.340006] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid 1416): =
Recovered 1 EQEs on cmd_eq
[ 1721.348989] mlx5_core 0000:d8:00.0: wait_func_handle_exec_timeout:1062:(=
pid 1416): cmd[0]: CREATE_EQ(0x301) recovered after timeout

When this happens, the mlx5_core driver is stuck with the below
call-trace, waiting for some interrupt:

# ps aux |grep modprobe
root        1416  0.0  0.0  11024  1472 ttyS0    D+   08:08   0:00 modprobe=
 mlx5_core
root        1480  0.0  0.0   6440   736 pts/0    S+   08:15   0:00 grep --c=
olor=3Dauto modprobe

# cat /proc/1416/stack
[<0>] cmd_exec+0x8a7/0x9b0 [mlx5_core]
[<0>] mlx5_cmd_exec+0x24/0x50 [mlx5_core]
[<0>] create_map_eq+0x2a6/0x380 [mlx5_core]
[<0>] mlx5_eq_table_create+0x504/0x710 [mlx5_core]
[<0>] mlx5_load+0x52/0x130 [mlx5_core]
[<0>] mlx5_init_one+0x1cc/0x250 [mlx5_core]
[<0>] probe_one+0x1d3/0x2a0 [mlx5_core]
[<0>] local_pci_probe+0x45/0x80
[<0>] pci_device_probe+0x10f/0x1c0
[<0>] really_probe+0x1c1/0x3b0
[<0>] __driver_probe_device+0x109/0x180
[<0>] driver_probe_device+0x23/0xa0
[<0>] __driver_attach+0xbd/0x160
[<0>] bus_for_each_dev+0x7c/0xc0
[<0>] driver_attach+0x1e/0x20
[<0>] bus_add_driver+0x152/0x1f0
[<0>] driver_register+0x74/0xd0
[<0>] __pci_register_driver+0x68/0x70
[<0>] init+0x6b/0x1000 [mlx5_core]
[<0>] do_one_initcall+0x46/0x1d0
[<0>] do_init_module+0x62/0x250
[<0>] load_module+0x2503/0x2730
[<0>] __do_sys_finit_module+0xbf/0x120
[<0>] __x64_sys_finit_module+0x1a/0x20
[<0>] do_syscall_64+0x38/0xc0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

To make the issue even weirder, when the issue happens (e.g. when Linux
only uses 8 processors), if I manually bring CPU #8~#31 online [2] and
then bring them offline [3], the Mellanox driver will work fine!

This is a x86-64 host. Is it possibe that the IOMMU Interrrupt Remapping
is not proprely set up with maxcpus=3D4, 8 and 16?

The above tests were done with the recent Linux v5.14-rc1 kernel. I also
tried Ubuntu 20.04's kernel "5.4.0-77-generic", and the Mellanox driver
exhibits exactly the same issue.

I have Linux/Windows dual-boot on this physical machine, and Windows
doesn't have the issue when I let it only use 4, 8 and 16 processors.
So this looks like somehow the issue is specific to Linux.

Can someone please shed some light on this strange issue? I'm ready
to provide more logs if needed. Thanks!

PS, the physical machine has 4 NVMe controllers and 4 Broadcom NICs,
which are not affected by maxcpus=3D4, 8, and 16.

[1] This is the 'lspci' output of the Mellanox NIC:
d8:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX=
-5]
        Subsystem: Mellanox Technologies MT27800 Family [ConnectX-5]
        Flags: bus master, fast devsel, latency 0, IRQ 33, NUMA node 1
        Memory at f8000000 (64-bit, prefetchable) [size=3D32M]
        Expansion ROM at fbe00000 [disabled] [size=3D1M]
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=3D64 Masked-
        Capabilities: [c0] Vendor Specific Information: Len=3D18 <?>
        Capabilities: [40] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
        Capabilities: [1c0] Secondary PCI Express
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core
00: b3 15 17 10 46 05 10 00 00 00 00 02 08 00 00 00
10: 0c 00 00 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 80 00
30: 00 00 e0 fb 60 00 00 00 00 00 00 00 ff 01 00 00

[2] for i in `seq 8 31`;  do echo 1 >  /sys/devices/system/cpu/cpu$i/online=
; done
[3] for i in `seq 8 31`;  do echo 0 >  /sys/devices/system/cpu/cpu$i/online=
; done

Thanks,
-- Dexuan

