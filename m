Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6945685E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhKSC6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:13 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:39814 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229998AbhKSC6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:05 -0500
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2D4rr025337;
        Fri, 19 Nov 2021 02:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=rFtMd0Z4fJcTElFwCM7fAYRoU7JnNijaCSPfnriETqQ=;
 b=ayJqu5zaEQhPBmcjkTFoXjcE6pwIQOga9UZsMwXrj3st2Vt08FZNC7ennKcAh1Kbqpo0
 8aNvWJYRGCzL5/vdaM/wwZn2wFXV7K1eOwuLmnppSp0bEKJlwWExPR/zfxKwV3n35ehT
 mze2HmJiEAfZMm37xKqAuRiJCh7Ym0po1K5PqM0xJZsu2KPF7TC5yn6JxIiPmM2Lvlku
 UGMdEFSfuahueOkOTZXF/o1tCOlV/MMI3z1xLm0a3csmtSwiHgZFSLb2Bd7exA5E0y0U
 LuXGpxXr2ff8fgHvFJgjRz/fM2TZ5k/0qmI9qSN5LKRtMZi4XpBmCJxo1LcvUspPk/YE Gg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ce2sx00xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 02:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vyx6Db3NlWefRORbdBpJBGc0HODAwcPbsuBPaCtLSYNZz/J7s8+KLgb6Lpf8McgfQ15PlS6UqbxgOU83YdnAd/RzFLloJuoYbrcfbRMOGpFbMRckP0pWd9ri2Q9tzE6BH4QpSP4AH8sb4v02L0dIBXDQPuQmSCZRunan83SY1EH1sk76+ueC8AYwTJ1o39jpcH89HaIuvnekpCwqht9Fat1fpfGgT4j8tkJSLGstpjTlKYFcJS5oBx7v+ydqphhC52VUkSetnxK+n/Oq0iyDbvUBY7MDzXXsmmYZh2DHWZS2/zlLupux97RGGj2ZF7KUl6JqxV23Yeiz0Ho6+KfZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFtMd0Z4fJcTElFwCM7fAYRoU7JnNijaCSPfnriETqQ=;
 b=JQVmbtpWHP1AbjWn9d+FLuSbCUEbHzJuf0r3eMH4rDS1azCWflyNW2+qjGZgphs/8ElEbGlCITxxRyj8cDcVDlzKRUzGcZc1rY55FNKuSLszQsVL60mIW7HLRXHLATrsDdr1GpTM/9z/ESVcxDWhI5vA79wIKnmNhNR4d+l7zBeeLCAwT07UNR55A2meL6+hyIrkLhFu9OIZSeFIry5K+YHcqOCY3Mb9uQt1yPCFD9Y36splgmpDl5ElV9Ui+rH7lDoUqPNRDbK7B1QTLfaF6UhY4Odg1JQHGgdKL2isQSPz/VB1VsVjlVyGa9ajp+UngDCAOmd7YXQpHuiNFxl56w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:35 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:35 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 5/6] net: stmmac: fix issue where clk is being unprepared twice
Date:   Fri, 19 Nov 2021 10:53:58 +0800
Message-Id: <20211119025359.30815-6-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39d3e34b-a1a1-4b62-806d-08d9ab07eb8a
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB49514DE8D7D396275E824EA3F19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:132;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KmkN0+Y+wSonUq9Eb2nuhsrZvsvT8Y4YxBkQmHSQu13MoAm5mhKcgx26D7z2v4AUmx7HR0Z3rUswsr19Zlai6DlZjFe73fktHLlEZsdizwNqGs+9ubCMCTCfFRvIiquLbTVnp43QkPC5gS7PBILFW0IM9n1qXloJnhtyghvUh9BHt0RSNa6oXBafpzGLQx4YqsyAvmFXDm4GNNLmOnL7QIq8TRRz2+irpvFPj62FKP77cZAqtg6qT7ynMHVTz00yVmwDb1FDF0X3U08Jl0XgWEi1wGOFS/RyR66HiItdmTjIi7NMm5E1hDR/2k1kqT/l7x09R8uqR32IWj+8OW1XxBnCXXWO4Ctpjv067xQRKjcIktB+UKTyfi6tUpKHZsNH5US/tpB1qLkk4oweBE+5Qz2js7znVFG1j1Zyy5bCHn8djF/M+IQp2j8RZqe3zfZ2IpG6fYSLbg0FNfv1Q8Wdu08KrHoltdd9R9heEDOjUoZuj1//CnavsmtXDkY2J/4bNQCaCc7aFZ3UYGwjP2c8vdnBht+rgbWUD0wt2XRrcKKX/KSI7C3HD8HVU2kzDe1dXSXjkxzjN1nGKAQsh4YpGWpddauDOI7BhF5rRjrVPw3oOc6X+6/DCIBXTy2xzL3NKBQQ+oUAcYn53vazKt/InF/1xGbFOkY469lQpykUV9QhbM2O77cB8MALxbmPWr88uwkusNoFHNhDDiVUN5zmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(45080400002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9QEQrWYBDi2D3toK1hD0dylGk7sVtXq/4jnexmwA2IEXBIVOkG2/3TJM5u9H?=
 =?us-ascii?Q?yjtVg1KU9K6HzAQhLJOiMI0ZA9L16cpuW8gU1JZEchUGcIZuPcFxNCfqFnZV?=
 =?us-ascii?Q?nyTvdVutk8NYMqtOm3eItBXDQJQotI+so1bY3b2WAmTGIdj073iw7sS8iFK2?=
 =?us-ascii?Q?oyCrAovtl+XKwKi9Y9bzuxg2fYd9pD8aM5r0J22CSsZ4JT2+2QvfxSTbMXnl?=
 =?us-ascii?Q?4Kb8oRm5hdrH9ccFUwO1aVLrFt1zA7LtXPe4DJdLO81LBSXAw7LJiJKljJjo?=
 =?us-ascii?Q?mV9H9k84dJn4jj6cs3zs9gQPLAW/0Sy+vv5EoF8R4tG5J5+qI/C0NrzhPvVG?=
 =?us-ascii?Q?iYlgii8cOhVbG6YyZpqcaaG7XVgeP/d0xoej2/HUH/PSjRzpkBhA5VytdeBg?=
 =?us-ascii?Q?MvDF0QAriYTYeIl4j6JXRyacF/wwNumdhmqmXBXGduE3xx/EybE3Hd/9A8Ik?=
 =?us-ascii?Q?kK1kuGPQ92vdVGz0DlTS7a1MW9nVIFBmJc1DBZH1rcfBEFAvSglGP71GHuob?=
 =?us-ascii?Q?HzOmV6/ZZLdfjfXWIECopV67OjlZAGtm3Edr7sg45eqPfEJRGGy1D4ezSR8W?=
 =?us-ascii?Q?mtwRrDcgpCJNh2HKulLYG8cU03oYoGohtuzCHcNAol89KKBl3wzWHfjuw/WE?=
 =?us-ascii?Q?IGTX4GrlcnA8dsn2fW04jdzWyIBOQhVRbOF2ILFyrhE5cl+1xVQpdS3mgZVt?=
 =?us-ascii?Q?utc7/850LGziQnFuQvHco0tXRAtICCiOPyS1TiQIPLYbV1MvwrnI3uwfPgGk?=
 =?us-ascii?Q?lqxX6wRzFx4NU6m2BAmOKuKh5ayiMKF9j+Vj4t1B/5W3DUF7H6vDAcMuaOMG?=
 =?us-ascii?Q?1LFX1JqbpwqdIsG5ht5S7EaR3DX+SyecVYaVUnSrLsuiXNMbiTsJGjvL8WUb?=
 =?us-ascii?Q?1F34eNIIIg7tvGrLWTAjv/YcTcS5G8VfnGTMiZYaK4GioDqf48OmwYFsQ3e4?=
 =?us-ascii?Q?f/P13Hdi7N8ragnbTrOZm550Z9I3saNEiGUNiK6s3AwP8FMZ4gBD1f3MgP4Z?=
 =?us-ascii?Q?2IAlgiwl4mp+4bEZ/SqcVRdy0R582AMute8q3wk+LN2LMU7Y/F6vpgr+K7YT?=
 =?us-ascii?Q?4PDu+Y3P4StqiYaGtxCOKEOaJy5LjPIERI7XB97u/XbPTDA3NIgWDzhMRlj1?=
 =?us-ascii?Q?Q+8fmCJsKoZgEkmbgwUHvDHwZVBtffZjvFY63m+PhaJ3M8otZiY3xWc9eWsN?=
 =?us-ascii?Q?s79epDEd+YE6e2DrwXk0WFVmRjJByv/Ka5vlzwcYEbZ7Hajach7MhrLFaDcR?=
 =?us-ascii?Q?3JVGhYn3iUUks+Q1k79ry88rcEP7Wtvnog+ycBou6YHwUJZHXlpMjCJMXc4J?=
 =?us-ascii?Q?4f4+hWNLxg/d+jv1xaPhVbrIB19r5LfLAH46sxs+f5IWFh2iru3nlbZ6FohJ?=
 =?us-ascii?Q?fHrmuyUaJ83ksbhEf3qhpKTZsfdwsjoyC0NIyK+Qyc2MxBZyn5RABBvQ+0T2?=
 =?us-ascii?Q?svw4KqMzTxjN3BebXOo6PJoibthlYgvvYBze6ecauH9c6T+iuQdJg2pM06UR?=
 =?us-ascii?Q?5eJD+n5SbaCzpXbPXc/JhwE+caNtzbG1noS1a6RgbvRKbR9XsxpiGOx7Be+O?=
 =?us-ascii?Q?RQNypI4hzE8HyPR9CpiRm7OEYgX3Dy7t/X3adCYU6HdlN9fNc60bx1jSZnDx?=
 =?us-ascii?Q?CnGr6okVKjXXk9PP5nPBir0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d3e34b-a1a1-4b62-806d-08d9ab07eb8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:35.5823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWqzewdy+xhCBUG4F6qFTXCagCuwhQ8Aa8MFTY6ALxjocFw54dKB5mgXf1bsplD6c2Xmpch8Smlz68voi4nKRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: bVP5aEyMcjMK_y-HnOSdJ7Y3xrWSC9Ou
X-Proofpoint-ORIG-GUID: bVP5aEyMcjMK_y-HnOSdJ7Y3xrWSC9Ou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

commit ab00f3e051e851a8458f0d0eb1bb426deadb6619 upstream.

In the case of MDIO bus registration failure due to no external PHY
devices is connected to the MAC, clk_disable_unprepare() is called in
stmmac_bus_clk_config() and intel_eth_pci_probe() respectively.

The second call in intel_eth_pci_probe() will caused the following:-

[   16.578605] intel-eth-pci 0000:00:1e.5: No PHY found
[   16.583778] intel-eth-pci 0000:00:1e.5: stmmac_dvr_probe: MDIO bus (id: 2) registration failed
[   16.680181] ------------[ cut here ]------------
[   16.684861] stmmac-0000:00:1e.5 already disabled
[   16.689547] WARNING: CPU: 13 PID: 2053 at drivers/clk/clk.c:952 clk_core_disable+0x96/0x1b0
[   16.697963] Modules linked in: dwc3 iTCO_wdt mei_hdcp iTCO_vendor_support udc_core x86_pkg_temp_thermal kvm_intel marvell10g kvm sch_fq_codel nfsd irqbypass dwmac_intel(+) stmmac uio ax88179_178a pcs_xpcs phylink uhid spi_pxa2xx_platform usbnet mei_me pcspkr tpm_crb mii i2c_i801 dw_dmac dwc3_pci thermal dw_dmac_core intel_rapl_msr libphy i2c_smbus mei tpm_tis intel_th_gth tpm_tis_core tpm intel_th_acpi intel_pmc_core intel_th i915 fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
[   16.746785] CPU: 13 PID: 2053 Comm: systemd-udevd Tainted: G     U            5.13.0-rc3-intel-lts #76
[   16.756134] Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-S ADP-S DRR4 CRB, BIOS ADLIFSI1.R00.1494.B00.2012031421 12/03/2020
[   16.769465] RIP: 0010:clk_core_disable+0x96/0x1b0
[   16.774222] Code: 00 8b 05 45 96 17 01 85 c0 7f 24 48 8b 5b 30 48 85 db 74 a5 8b 43 7c 85 c0 75 93 48 8b 33 48 c7 c7 6e 32 cc b7 e8 b2 5d 52 00 <0f> 0b 5b 5d c3 65 8b 05 76 31 18 49 89 c0 48 0f a3 05 bc 92 1a 01
[   16.793016] RSP: 0018:ffffa44580523aa0 EFLAGS: 00010086
[   16.798287] RAX: 0000000000000000 RBX: ffff8d7d0eb70a00 RCX: 0000000000000000
[   16.805435] RDX: 0000000000000002 RSI: ffffffffb7c62d5f RDI: 00000000ffffffff
[   16.812610] RBP: 0000000000000287 R08: 0000000000000000 R09: ffffa445805238d0
[   16.819759] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8d7d0eb70a00
[   16.826904] R13: ffff8d7d027370c8 R14: 0000000000000006 R15: ffffa44580523ad0
[   16.834047] FS:  00007f9882fa2600(0000) GS:ffff8d80a0940000(0000) knlGS:0000000000000000
[   16.842177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.847966] CR2: 00007f9882bea3d8 CR3: 000000010b126001 CR4: 0000000000370ee0
[   16.855144] Call Trace:
[   16.857614]  clk_core_disable_lock+0x1b/0x30
[   16.861941]  intel_eth_pci_probe.cold+0x11d/0x136 [dwmac_intel]
[   16.867913]  pci_device_probe+0xcf/0x150
[   16.871890]  really_probe+0xf5/0x3e0
[   16.875526]  driver_probe_device+0x64/0x150
[   16.879763]  device_driver_attach+0x53/0x60
[   16.883998]  __driver_attach+0x9f/0x150
[   16.887883]  ? device_driver_attach+0x60/0x60
[   16.892288]  ? device_driver_attach+0x60/0x60
[   16.896698]  bus_for_each_dev+0x77/0xc0
[   16.900583]  bus_add_driver+0x184/0x1f0
[   16.904469]  driver_register+0x6c/0xc0
[   16.908268]  ? 0xffffffffc07ae000
[   16.911598]  do_one_initcall+0x4a/0x210
[   16.915489]  ? kmem_cache_alloc_trace+0x305/0x4e0
[   16.920247]  do_init_module+0x5c/0x230
[   16.924057]  load_module+0x2894/0x2b70
[   16.927857]  ? __do_sys_finit_module+0xb5/0x120
[   16.932441]  __do_sys_finit_module+0xb5/0x120
[   16.936845]  do_syscall_64+0x42/0x80
[   16.940476]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   16.945586] RIP: 0033:0x7f98830e5ccd
[   16.949177] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 31 0c 00 f7 d8 64 89 01 48
[   16.967970] RSP: 002b:00007ffc66b60168 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   16.975583] RAX: ffffffffffffffda RBX: 000055885de35ef0 RCX: 00007f98830e5ccd
[   16.982725] RDX: 0000000000000000 RSI: 00007f98832541e3 RDI: 0000000000000012
[   16.989868] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000000
[   16.997042] R10: 0000000000000012 R11: 0000000000000246 R12: 00007f98832541e3
[   17.004222] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffc66b60328
[   17.011369] ---[ end trace df06a3dab26b988c ]---
[   17.016062] ------------[ cut here ]------------
[   17.020701] stmmac-0000:00:1e.5 already unprepared

Removing the stmmac_bus_clks_config() call in stmmac_dvr_probe and let
dwmac-intel to handle the unprepare and disable of the clk device.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Reviewed-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cccf98f66ff4..4a75e73f06bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5179,7 +5179,6 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
-	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
-- 
2.17.1

