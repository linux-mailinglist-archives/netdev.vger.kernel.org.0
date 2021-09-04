Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C854009E8
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 07:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhIDFzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 01:55:11 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:32916 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231299AbhIDFzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 01:55:08 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1845nB04013378;
        Sat, 4 Sep 2021 05:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=mHen41UErFXR9v5YvatPOEQ8bs75/lZuwhA6u13dtZQ=;
 b=FyDs8wVDYoj86tst9dnzM8R4vi8kUcEeLllvTkjcKoy4dFiFSLHdq6n/gCo2Q1NcHxkS
 ukXtkl38W+WfS0S4ov1GtIm8czeojCPz8mLZmz4lsKWxgUBT6GNM7RDu74P3Dzzg7SxO
 ylQUuITSjABOwZ3wjyggbA4Ebiy4qw0u9rWiEL63uDRwCBWovjIUQeWpYQjn8DPomiTS
 Vty9AnjZOX9/mfsyiu6XCgV9qu+qrk+PbK1or3G0QZgdmw1romBXQIW2+pyQDoKIcJti
 Z/iS3V1qz8iqz5oAx90kp5KTuk7ESAwc/nY4WtXJKPidQDFBMqB2hvBwzxabYk9rsArm fQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 3aux11r4f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Sep 2021 05:53:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCyWwdFL+De8hydXj7FsWUQVs6TbAt/3AnvTjG6SLrKyvDhUV0Uklfat7lky+ERS6GaQrTw+LgmwDTiJ9nB1IaGAzbktD0mTzInWHxCD4YtNFlA+SnsIdgOcHkCTIb9p+b9QHNyA3/wmbTVemZ/Ima8j7Dzp25JgByi4GD++p23nwQIRwcqGxIBGnKubYhlwie+6AtwSH5i6D7uRv1aI/PECoZ/KUJKyzABV06eIme4era6KawIitiUBAVB9a1IIXMVwn1cxU1ihCodCKNlD5fVP5p5aKj7BzsbbN6tgfZTbZ960esY5gOmsg+n1nxkgAgoVC368fO06VYRwTj+ZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHen41UErFXR9v5YvatPOEQ8bs75/lZuwhA6u13dtZQ=;
 b=jgmRcxjOjTbi7fgwIVZdjMwaFNkcrnuTceiX4vtTDxc7dRyEsWcWAcOcstIDLrF2NpUzsPQW/8RBaWcUcmzN9wTzSEOlsJw2gIjbEVFJW+VU5KoGEurEkyS6t/a2R2IyjjVO12RFpWSDH879CNyQ9YtfbrNK4dQDn6SYmH7ZwwPmSRMX9crKYEzaej8TqBjmPqdN+iRZB+tX03J4P/INiITrC/zszy/z4ycI32o99VeKZlfzQktW7UKUmQZdBeooB2pU7b7R3cHeKV4Tn5G9Gi2qLtLrQ8Kwatd4MRAnLhafbEc1KV5eCLQgiFQZFWZKWA+1xvNI5B6B5fKIAmIOwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM6PR11MB2793.namprd11.prod.outlook.com (2603:10b6:5:c0::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Sat, 4 Sep 2021 05:53:52 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::b866:141c:8869:a813]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::b866:141c:8869:a813%6]) with mapi id 15.20.4457.017; Sat, 4 Sep 2021
 05:53:52 +0000
From:   Jun Miao <jun.miao@windriver.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@windriver.com
Subject: [PATCH] ice: Fix a kernel NULL pointer dereference when PCI hotplug
Date:   Sat,  4 Sep 2021 13:53:38 +0800
Message-Id: <20210904055338.2994430-1-jun.miao@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0017.apcprd03.prod.outlook.com
 (2603:1096:202::27) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp7.wrs.com (60.247.85.82) by HK2PR0302CA0017.apcprd03.prod.outlook.com (2603:1096:202::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Sat, 4 Sep 2021 05:53:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aed4e1ee-da2f-4810-0cc9-08d96f685f9e
X-MS-TrafficTypeDiagnostic: DM6PR11MB2793:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB2793C795177BC42AC1C0A1098ED09@DM6PR11MB2793.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTzarpRaZGq+liW1nx2s1Oa3G2ziEDIB1hV/QsDbFfmy2u8g5zRQzMkhLT6vHFk/mmWJOT/zDyW6clPFN9jZFsAQI8FS8dhpBkPfvvgE2iwIjGXiB6cxo2ZvytHC0hbDgKUk0zL9u9PcChR9FObfWMAwRP+m3MrKAXdNfjms04WGey0HddyxkRaLWxwYroy9hqDytCSwds+wttx6D7beLkvDCWyOk3TlPnJa1I21lxdxrrPlxgD+0TR0vnaKUGOcny060lbuZkZUrLbK0Q1y5CEmBaOVjkhZSwlibVfyGhI+oD28erCmLzw9nVgb6NZH1Ux4vdTGCyVE/dszucib9S8ugdy9umy+S+l4FHOwjWJNrrE1fByd4tqKhXcyLKkr/pOTFQkl7Q6eP5wSabX70FUhkdK3PyH9vmo4DeCmgsQIiuLFcKlX77JlSaEC3TXYSXL9BxuMKyl3512ib7FeUJuQAGAtSl75Zgq0hwEX88LSZ4GC773LiqXbrrw4T6hocKw1xzrYyvZkOZeeZmIpiN8DnvuE5iyyFqgJj/A98EIvCg9r6FsqAxgiRfTu9AYAzf+TZ1ryra6npoPMDLKO1aVLdbVL4HGes+M/q4DFjyICLxtBJ7DG/bOUGZJ6QbAjALhUWPVUlqOsiYC2orK4JeVuWYmYVlRRygQC2M3Lxu5iKH6TSJZDyaZuGCuCPDFvL+RD+UtitG1g1lmY2RtLxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(136003)(366004)(376002)(6512007)(6506007)(86362001)(5660300002)(66476007)(6486002)(6666004)(1076003)(8676002)(66556008)(316002)(107886003)(36756003)(2616005)(66946007)(2906002)(478600001)(4326008)(52116002)(38350700002)(45080400002)(44832011)(26005)(186003)(956004)(38100700002)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0U8TDTR5kHjCpz81dUvayZNon7FFnckpVSdFAg9QMOApZ7szeM3w9NILa8Hk?=
 =?us-ascii?Q?CwvwsoepAJiOyDviCAnooHpkHpEn7TiVhWpboo59b3IZIKXvXt2AoErgatWX?=
 =?us-ascii?Q?9GerpS9F10WwnVlLIj8+YiJOmL/LQcwfHOPJZjxeIDK9nBTUJ7qWOF4BI0gw?=
 =?us-ascii?Q?DYbb4fjiQepUHstRnOySgEt835xYf8ojcW6PyNnzwMbvyn+GLaiBILr05xkx?=
 =?us-ascii?Q?arMFjSne+iHti4M3cko0/XzP8+ZCmcq/kmrA+Fd9XEnVkga9Z99uC1Zij6jJ?=
 =?us-ascii?Q?MLRfRnFeZ/smRp2+MrtiiG9WwMbY7fYmkmX6okXgtd17Till+QdrYx9b+6ss?=
 =?us-ascii?Q?3q8QjkDCjhLX9evLpPesBk9svItzxoS3j4Z7x0+637I8De3og7pNF7Q14Eec?=
 =?us-ascii?Q?jTjoVM2cawI6JXzjzMmZKz3ZKNLkDu7UKgEnsa76mvWQ0qq/jYLbbR8dwcoU?=
 =?us-ascii?Q?LSaiOUWYwXz+weuzsAGDCYkImW5Mioi9nj7rwdMHyn74r3t+iQaoXqn7tkiR?=
 =?us-ascii?Q?9o7s60zwChUBqlQ15ZIxZCOdlBHhwanNIiu5AZ0/06hck7dX80rMMAz0vjbg?=
 =?us-ascii?Q?abnlNFO9tsSQ+sCpFQE6gpqM7XSitWcDxmOZp3evUGKFGcr2tQWdqHvas4c4?=
 =?us-ascii?Q?kRAxPRzii8nJh70cHgVkJ16PR1IqKRUBAcez3OSYl5l1X/VJMrqKcTAjPYLM?=
 =?us-ascii?Q?wsTmdyz3vmIPwcYNNFuG24vrsq/NwHqO8xo/1ppfcAsdBWx/Y6Czy3avJkCU?=
 =?us-ascii?Q?MStxz2HTr3LrdHJtnQ1A6zkr9nUUUdsqx5KKNPEHPVB7oJKLBw7t1PDDSXJ4?=
 =?us-ascii?Q?86sWYxa1zDaX5W/KDJJjAUZ874d+8EWFS2tzFC9uBFhBXcG1mqEQHL9dkUAM?=
 =?us-ascii?Q?Uc9GwzJI5MtTMh3+qZBnmrwvJheTW90WX7gKBJyaXG6rXqxztqJ6GDbTznTj?=
 =?us-ascii?Q?6xnDQVBm117BiLzxAfFO6zeT+w4ZGof2J8n2lQyDCWm5C7iObA0/orh3akgP?=
 =?us-ascii?Q?N8yfsbgrwTdR3pCu3yX5GG8hUJkvMYpUstypi+6zaYl3ov7KRqlob21uHXx/?=
 =?us-ascii?Q?xBDxYKzbH//iv6AKapXrUC4INch4AdMMdt3LMp0dIitZefbkm+4SBY1zgkdQ?=
 =?us-ascii?Q?XaI825QPO7gyyzv93cBAmrwevKCsNVFMyTvgqUi/NI1zooe9G3BbNRBbE8VN?=
 =?us-ascii?Q?jPgfSogPU7+yTu5s9b1fpIddGDLREi6jPE+UEo4bhyAub8DSkD2g3UIzccYY?=
 =?us-ascii?Q?roi8B3ay40BIH0Q3+r02hQpCOCIpIMD3MeLIpwAhaay/LqytIHJy6oHdcaIP?=
 =?us-ascii?Q?vlZKpImMAlPrVG1d6/IKFri4?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed4e1ee-da2f-4810-0cc9-08d96f685f9e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2021 05:53:52.3279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4J6wqCy7dG4jvqAr4D1aEdW9u7Rm8ZktZ6mu1WRAIX3/2ucUnTpJDni6/42/juKITnio64BokmVs3X5QoSTUbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2793
X-Proofpoint-ORIG-GUID: kn4FbOMdmWHKLgM7d_BFbGvVDxikFH0z
X-Proofpoint-GUID: kn4FbOMdmWHKLgM7d_BFbGvVDxikFH0z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-04_01,2021-09-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109040039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RDMA is not supported on some devices such as E822-C.
When triger PCI hotplug, there will be a kernel NULL pointer Call Trace.

Since of removing the E822-C ice driver, ice_remove() will callback ida_free().
But there isn`t be alloced "pf->aux_idx", when the RDMA is unsupported. So we
should check whether support RDMA firstly, before free the "pf->aux_idx".

Feature description and call trace Log:

There are E822-C on the board:
ec:00.0 Ethernet controller: Intel Corporation Ethernet Connection E822-C for QSFP (rev 20)
ec:00.1 Ethernet controller: Intel Corporation Ethernet Connection E822-C for QSFP (rev 20)
ec:00.2 Ethernet controller: Intel Corporation Ethernet Connection E822-C for QSFP (rev 20)
ec:00.3 Ethernet controller: Intel Corporation Ethernet Connection E822-C for QSFP (rev 20)
ec:00.4 Ethernet controller: Intel Corporation Ethernet Connection E822-C for SFP (rev 20)

root@intel-x86-64:~#echo 1 > /sys/bus/pci/devices/0000:ec:00.3/remove
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 17 PID: 791 Comm: sh Not tainted 5.14.0-next-20210903 #1
Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE, BIOS
JBVLCRB2.86B.0014.P67.2103111848 03/11/2021
RIP: 0010:ida_free+0x7f/0x150
Code: 00 00 48 c7 45 d0 00 00 00 00 0f 88 d8 00 00 00 89 f3 e8 44 38 84 00 48 8d
7d a8 49 89 c6 e8 38 ee 00 00 a8 01 49 89 c5 75 47 <4c> 0f a3 20 0f 92 c0 84 c0
75 79 48 8b 7d a8 4c 89 f6 e8 6a 38 84
RSP: 0018:ffffb114c18dbc38 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb114c18dbc38
RBP: ffffb114c18dbc90 R08: 0000000000000000 R09: ffffb114c18dbc28
R10: 0000000000000000 R11: ffffffff89e59e58 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000246 R15: ffffa0e5e10f4900
FS:  00007fc4d4021740(0000) GS:ffffa0f500040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010a70a000 CR4: 0000000000350ee0
Call Trace:
 ice_remove+0xc4/0x210 [ice]
 pci_device_remove+0x3b/0xc0
 device_release_driver_internal+0xfe/0x1d0
 device_release_driver+0x12/0x20
 pci_stop_bus_device+0x61/0x90
 pci_stop_and_remove_bus_device_locked+0x1a/0x30
 remove_store+0x7c/0x90
 dev_attr_store+0x14/0x30
 sysfs_kf_write+0x39/0x50
 kernfs_fop_write_iter+0x123/0x1b0
 new_sync_write+0x10e/0x1b0
 vfs_write+0x131/0x2a0
 ksys_write+0x5e/0xe0
 __x64_sys_write+0x1a/0x20
 do_syscall_64+0x3f/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc4d411faa7
Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b
04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3
48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007fff097188b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fc4d411faa7
RDX: 0000000000000002 RSI: 0000555bc86bf640 RDI: 0000000000000001
RBP: 0000555bc86bf640 R08: 0000000000000000 R09: 00007fc4d41cf4e0
R10: 00007fc4d41cf3e0 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fc4d42155a0 R14: 0000000000000002 R15: 00007fc4d42157a0
Modules linked in: intel_rapl_msr intel_rapl_common ice i10nm_edac
x86_pkg_temp_thermal intel_powerclamp matroxfb_base iTCO_wdt coretemp
intel_pmc_bxt matroxfb_g450 crct10dif_pclmul iTCO_vendor_support matroxfb_accel
intel_spi_pci crct10dif_common watchdog intel_spi matroxfb_DAC1064 intel_th_gth
aesni_intel spi_nor g450_pll crypto_simd input_leds matroxfb_misc cryptd
intel_th_pci led_class i2c_i801 intel_th i2c_smbus i2c_ismt wmi acpi_cpufreq
sch_fq_codel openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 fuse configfs
CR2: 0000000000000000
---[ end trace b7d0a971ebc5759b ]---
SmmCorePerformanceLib: No enough space to save boot records
RIP: 0010:ida_free+0x7f/0x150
Code: 00 00 48 c7 45 d0 00 00 00 00 0f 88 d8 00 00 00 89 f3 e8 44 38 84 00 48 8d
7d a8 49 89 c6 e8 38 ee 00 00 a8 01 49 89 c5 75 47 <4c> 0f a3 20 0f 92 c0 84 c0
75 79 48 8b 7d a8 4c 89 f6 e8 6a 38 84
RSP: 0018:ffffb114c18dbc38 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb114c18dbc38
RBP: ffffb114c18dbc90 R08: 0000000000000000 R09: ffffb114c18dbc28
R10: 0000000000000000 R11: ffffffff89e59e58 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000246 R15: ffffa0e5e10f4900
FS:  00007fc4d4021740(0000) GS:ffffa0f500040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010a70a000 CR4: 0000000000350ee0
note: sh[791] exited with preempt_count 1
Killed

Fixes: d25a0fc41c1f ("ice: Initialize RDMA support")
Signed-off-by: Jun Miao <jun.miao@windriver.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0d6c143f6653..947a47d10855 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4615,7 +4615,10 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_aq_cancel_waiting_tasks(pf);
 	ice_unplug_aux_dev(pf);
-	ida_free(&ice_aux_ida, pf->aux_idx);
+
+	if (ice_is_aux_ena(pf))
+		ida_free(&ice_aux_ida, pf->aux_idx);
+
 	set_bit(ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
-- 
2.32.0

