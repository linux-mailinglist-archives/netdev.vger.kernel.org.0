Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4754018DE
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbhIFJcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:32:20 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:32968 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241279AbhIFJcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:32:19 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1868a0m7000628;
        Mon, 6 Sep 2021 02:31:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=mHen41UErFXR9v5YvatPOEQ8bs75/lZuwhA6u13dtZQ=;
 b=sKL0UMjPQlT+Tvi/8bvxmyt4pzKT2tS9ubTg/j6PCFWbkX52Ibp4LorWyaqNscHHxL8p
 DTBExbOMdbuOdULer/MeYANOfPw48IsMRMRjxRTH1vTyX7QLbg1DNoSAjowUY8EqW+iK
 4q/pS5FsgCKMfRHO1bJGfrwUsEPXhaVjdSUvPiIdtuD7BFusbpdIBY+Tn2kWrP/JOatg
 wuWxG2UbcF2M55AIfWHx6QszKQYdgw/4YA6wvE+R1mRpCdezhI5xsDgyXWM22G+uMQTM
 JDw7kVwoDcKbrYAxpOEn8/z9+1SA1yOuOUN/BYJ+IUdObtNbzVArFWApsWCBSR/v6mCI UA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com with ESMTP id 3aw6bj890k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 02:31:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krgM7OZ9sT2RBkkQD2AbPa6hKamSw4ACJKaIN001XpDbmMYxvft5jT4PxaDk28pJUvjTCl2DuZjE1vw9hjMf3edIRpV4Fkv3jsqCHsjTOxPwry8VYnh/4ZBrnqFUHoVYKUVJU1CqaIkNmazCzhzUrFNCj/XzOZLrYdFJc4HpvMzf7PTcRAVB9Aq7vIw6xwbEQL0cF7r/aH8ZIbN3IwyY0S4BWqmfFegMIhH+rG2CvL6la03VgaT0gZCsQ3AspYCF5PINBXEqhwqqkKmc9DPoqfW4Ib0wLzeCZ3CUhg0mLbQzYnVDPWql28I2+VScaURvchIg41tqrGBH1nsAFMDw1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mHen41UErFXR9v5YvatPOEQ8bs75/lZuwhA6u13dtZQ=;
 b=Zvc+xqOhNyHsMrM9zaxMwAdlldjNSPfSWm0Xt99cabTm00Emyb8sGvejAd/evlu545yM65WVxMI4/fW9L3Zacz0mBuG7kNikR0mGNHZ2YPj+rs/KjRtPLA+tQEAi7dzY8RTDtgNIV+BrjZWA4YvdA7Me+/QooWp6zK0nRlbag0GjheWlL6+720q1D+ZAAu5aVAYRcT5NyYSciDgSZC+1xNCKlcKj97e68rjS+s6dPMv1F+lA/0VRDNFQ18ejKY6BB2DVvuXEt40GeYp/7U89p086CzdFS73/7fzf4HlqeoCupXiZeQ+V22CmSU+J10uYEwZBx1NoBsixtQFKQS42ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM6PR11MB3644.namprd11.prod.outlook.com (2603:10b6:5:139::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.17; Mon, 6 Sep 2021 09:31:07 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::b866:141c:8869:a813]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::b866:141c:8869:a813%6]) with mapi id 15.20.4457.017; Mon, 6 Sep 2021
 09:31:07 +0000
From:   Jun Miao <jun.miao@windriver.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@windriver.com
Subject: [v2][PATCH] ice: Fix NULL pointer dereference of pf->aux_idx
Date:   Mon,  6 Sep 2021 17:30:54 +0800
Message-Id: <20210906093054.2904558-1-jun.miao@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0054.apcprd04.prod.outlook.com
 (2603:1096:202:14::22) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp7.wrs.com (60.247.85.82) by HK2PR04CA0054.apcprd04.prod.outlook.com (2603:1096:202:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Mon, 6 Sep 2021 09:31:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b48d1699-1f04-4fd2-8d38-08d971190e15
X-MS-TrafficTypeDiagnostic: DM6PR11MB3644:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB364464BDA0F4ABEFF4436B498ED29@DM6PR11MB3644.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Daj8GYwE1DuaBDHooCT8HZFqcksy2TxAEnFlShAIFmmJzsYX/FOJbp2W+WpYt1ks+/jri/TVAzhqYCum43cOll0H1CXaS8KR9qQroaLI3spDULXQkVppe93sUKoPnoXns8D1qObJsvEnVtDTeGvX1VJbXu7aW9Yfh0Jsf9gMudx/AqIkTYVkWMUyANYVgl5fDmh7Gx/bmUFl+dEsBGnG6ZPwuck2XBtq6GyLmqYrOI9mPW9DzoWGp4Lp4yDXh0jrm8ioNCNkZFzdEIcFI2d6EFl3h4zax5JkFYLrASIGXWQ7Ps9+wIwuGVcs81Se7XeXqkGhkITDIGjV+L/W8oeW9TO7p0wYJujz1SzBF0xaVzJcb8EvXRSU0G2wNCsy+y3h7PEnXv8ETPW6w2rFVIpYSoHzdFfBkr12JJw8J5aeJcL0i4yK9d0LgC4+/TDJWDEnsWiCOEK06wez3Zc58Ni9zS3vkJTFjOfKYibpkgtIjlZoAUeiYJzfGcne70fjp3BiK+szgzmXwkrETsKaffip5xsv+aJ1DJ6sTXIImkTV+UE5C4FCujkFa50pk/vZjXe55ALXnDyUPjWk/cXxXLpIIL9IbtwsHcdTTb2hcxuEWj3YkVhZdOEoo0/imeeZofVvZegQzomaF13NZigqnSb+r/0wsfwF+Uikg3KobBOBKRHl1fZ979u3qZkYRNOdf60zFu2EfznWzQmS2M7Ld2mn4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(44832011)(6512007)(6486002)(45080400002)(5660300002)(8676002)(316002)(508600001)(107886003)(2616005)(38100700002)(38350700002)(36756003)(4326008)(86362001)(956004)(6506007)(2906002)(1076003)(66556008)(66946007)(66476007)(52116002)(186003)(26005)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g430sDot25q3/Ukih4yFo63IIlLvAVQDPp5VIhAJwHDuLKQCIN02eDIX3NZY?=
 =?us-ascii?Q?B2CwlC7W3VqA2a9MNZAy2HUfSQ0T7TdQa0JJ4ZKvSdB9ZYbdI/kjn/4B66G3?=
 =?us-ascii?Q?L4jzm2xOuDEMKEq0iu2RzUYyA1LKuGXCZFxFTfieuS6shdTfePxueOpb8wOD?=
 =?us-ascii?Q?EwKucYDgAvN+i7szNtByi6Pj0mlVUFBC5p+WBUvKDkIVLiGEk4vZPhVgdVKh?=
 =?us-ascii?Q?p783Xokaw1/h0u/nRMz+HtQW/UCjpjGr7PLMZ3DOkw9ErbvsERp2VrnRmSur?=
 =?us-ascii?Q?E08IZ1Ot+Mo4K9u7SJNCdn+0XO4IwHrCl26Svu8i7iiVSkS3EvWAQQLW2ZxJ?=
 =?us-ascii?Q?OcI/B5EpM6t+eIb4FI9A2JES9lMP/RJlev4R/iKbkmxU2meJsT2VvsllkBCQ?=
 =?us-ascii?Q?Azyy3mrdwjNm0FgbXqYOYAAJGaHW3p/h9JZVIrK2AtqqhMqqPEt2uOhBmZnY?=
 =?us-ascii?Q?KXoKiog9Apibmq4IFfmRLN7Dqw2JqYJXZ78YZ9NFBQDO6asT4e6Rj81Q7LqO?=
 =?us-ascii?Q?OHufg3d6j7w43NAGz0LwETRNUu4Qu0YHKr9zjoTqqSqncM6EYN7IQxKImTKr?=
 =?us-ascii?Q?cjU5IDpI1qfJOTRiwsblyKxe/hk7E7vkpB31eaw7EL9PN/XlfFhc5aqQHSP1?=
 =?us-ascii?Q?MoTP7V8RzHq8csztfG8V06fgXhzYFW4VKU74ZBDOSB2wP54zjO11iP2XptJE?=
 =?us-ascii?Q?6OzT7lqRHN4piyT6qtNU8O2Q6czodx7c9/1GGYoDvO4REX4At3AjGcfl4uY2?=
 =?us-ascii?Q?QBg6u6OWYJ5qe2EJadv5PZvW6rAaFkGI0JgmdlclWf/r/4lgcr8FpxkUS7yJ?=
 =?us-ascii?Q?ywLV1nWiCxZF5LwKSUwkZzpZJGxZt7wHG/LJkKqHNK/dMLp5nNoifWOkSbIv?=
 =?us-ascii?Q?uEAm7aK/+XKZGlrkCjmd7nB3tAnvQkuLytNrUwpaJsUnevHfWe9beOFiRGSJ?=
 =?us-ascii?Q?IBmYcfeH5u0kHObTS0vLWULrfpsfqy9LeL3hLKPrrr2vUelp/pWQaPyO4MEM?=
 =?us-ascii?Q?6xOJi7p4dj+LtKKeq83ortdQ1kqYmjHPGbVUNNy4fZD8lRG7CyOgUhNtkqo6?=
 =?us-ascii?Q?jvwHBaagrT7lGah9p+vhepTJC+qWCv45hUc7CF/tSSWVcbR28cdl25tF064q?=
 =?us-ascii?Q?V1jR/Ad++DgUvS8KU5+qsVpa3Xg64kFvt5Yeau1frIFA7e/ftkmegrGYN9EJ?=
 =?us-ascii?Q?S3j40hdOdtRPvhs2RaQxK2t+rP7pmV4CiK7KBqfUEUXBl13CNW4pVY80s4eL?=
 =?us-ascii?Q?TEec0URJq40FMIEhkyrPiiqtNP74ryYhRLQutvtXhjwkyzcT8/7Su5D88YlA?=
 =?us-ascii?Q?Q4wGhv7iNgdUYdh6Z1yDZo8I?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48d1699-1f04-4fd2-8d38-08d971190e15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 09:31:07.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2+EGQ5i/OiPvKp2fS4ojC1i+W+mwZh1KubIrCTxl2yK2uHPBV3uUHMg4iKwqr3ee3D0vmhdcfiV4XLINLYNjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
X-Proofpoint-GUID: 52rVTx0OaGaxS66zFQPBhPLme02BW1IW
X-Proofpoint-ORIG-GUID: 52rVTx0OaGaxS66zFQPBhPLme02BW1IW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-06_05,2021-09-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109060060
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

