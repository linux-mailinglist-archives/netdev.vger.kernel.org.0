Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8D380BBA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhENO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:26:17 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:59264
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230074AbhENO0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:26:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEzxxXKKrZo/gxs5LOgkcQemqVw6SJqJmiMOyinyuuQyGNSzfjVY2teVGnQ2/MadJytcSANd3tiTvJjjrk1uo0LGpCrx20CgOcNceq6KEH17SBs24BQ7CdjzcpHAUHEW0Iq7f3a3W490B/Qq2k5Tfl+5RmEMNWeEwsWcA1N9nFc9/CnXte4MWDqVUpLtiX2OtmZ1Wx/u481G4LOwxFTPA0K+AJVtk+/giGVUwx3rq7Tpc8vQKturxJ+tMhZ2FettZ4a/GT7Pw98Bx2ssnaGMtT7BYADVQZdTA3Bh0zzcX9nREGV6LDgJvMsO9sjhq9NZOJpES9r50DuMDB/RO8KMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCg9trwOTNJ9DCXTOfZEhUgtpft8FCu+uI1YV+zUfrc=;
 b=HUWL/t8Axq1r2avptLb01TrDPUS25goOK9oumQdNEJtHmiIyo4nyRvByLy0sUG/YT6eTNFkJscqy77Pdn9L0vdYKkIgvCJtcFopVkHIxO7OwBO4PyEuGR6IWFfMBsQiRG6ExO5VVUzUAi4gpUsZYGaXT+PyEi3aGP23KFnWcpspMzGcPjHQr/utnd3BnKsyQ1I2KjSmPyNRzHCYVQOkOZeerI09zUE3s3LbiBSxmssUI6xLZXdtaDGuConLsNoHq5wQ7vRcxX6AKBOXsCTRPfLVCC0Z8N2hbR9vZglCGWqiABMp1cYPXfz0G820ZaDzf2qbJhkhsbZSvfuzbkH9JHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCg9trwOTNJ9DCXTOfZEhUgtpft8FCu+uI1YV+zUfrc=;
 b=RlpY8qbahyTbeFzlRn3/Djskn8et2N3UElvbqpnx3YouLU9wnGw60K8UyEI1mKyuJair3oyzr/dfhnLz2z1WRkhlbmfLJHSdONB1ximeuYmgmezg9Xjmd7pkQ+/2ifLfNV7rGLvBNznPEfzB3uql4nqrwL7UwNl8an/c/NCYNHfWal91HSMYe7gn7ECky+lpSpg5eunSL+lcDsJOKp4juRzJeS1vO8wqTHyenhkMBvYTkkP1YSVHf7cPJeysXbIosLlSN54QzO9g5515a9Tzrx7ujOG2V8oJ+8/4/fid/ESywbrM5Y1CTgVIT5614v55Er3RklRMh6PbFtWmWmnSIw==
Received: from DS7PR03CA0287.namprd03.prod.outlook.com (2603:10b6:5:3ad::22)
 by BYAPR12MB3399.namprd12.prod.outlook.com (2603:10b6:a03:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 14 May
 2021 14:25:03 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::e8) by DS7PR03CA0287.outlook.office365.com
 (2603:10b6:5:3ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Fri, 14 May 2021 14:25:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 14 May 2021 14:25:02 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 May
 2021 14:25:00 +0000
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: [BUG] net: stmmac: Panic observed in stmmac_napi_poll_rx()
Message-ID: <b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com>
Date:   Fri, 14 May 2021 15:24:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afa20399-4416-4f36-7836-08d916e41005
X-MS-TrafficTypeDiagnostic: BYAPR12MB3399:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3399822C1C180EB1A3D0E6F5D9509@BYAPR12MB3399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSBes4Ryr9ccdgSsNwtpW86eWFLxkIhy1ckAb1jhykqb+jpthgRk0Ny1h1CK8e4UpAFEmbyl9/XvMopVrVx6sZ0zvPspYvjX4Bpalhkey22Eo+R9ylBqT+ynVM6PTMR737afQdZ/LmOio1Kag+YJJdMMnNYIJxTo7pArp0fh41HGdsN12hMSovwlibg8rFtKYkc7n7YL1JQ4xY0GwQBoWc0kYk5KEVxt+4OMf6TDqChasqxTHmBDd1xMnGQdNVdhHyyuaE9Gy992vv1Sgmzm/N0pYsIXM+TuSQuMfJBRVTcH23ZBUYvXpau+MAw2Wcu/x08Ye10nfAO8i8GpuFoJiZ7rF/bCWEmO6lFIS4FD/DlETWrx7KKYQVnWRAEg8moZBIlP8rBYKWGEIM0nJ2tpzrAsQ15nsvuTlX1VRX1CqSd+3FDKQpJdGv3NSfXT/p2h5JxzZWH7f5bEmX9nMLR2LWVNYmz9431cv2xjP+Y7DsdbMUYel3fw2lmNgjbHreT4kqgzoIO53DPgOQOmkEpjzksok6v9w0Gd4ARsx1ArN5ta6fUa8k/ZWDQVbMLYcdPAWuPBzWv3xz3Dft3WMalGKVV2RQVGAqUEl8FA+yHR6aB70YJEV3F0KoEMnW8kvDXI1g8x8k9RmBArs906FNZ+1GYJmRixbk+6iXt7Q0DUv7fkyeiGbPsdBtaq4Jyd3mCm5QHvhKvISqzVkYjjS/bh/A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(46966006)(36840700001)(316002)(36906005)(83380400001)(110136005)(54906003)(31696002)(16576012)(107886003)(8676002)(36756003)(82740400003)(7636003)(31686004)(82310400003)(5660300002)(478600001)(426003)(47076005)(336012)(8936002)(2906002)(2616005)(45080400002)(186003)(16526019)(26005)(36860700001)(86362001)(70586007)(70206006)(4326008)(356005)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 14:25:02.5255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afa20399-4416-4f36-7836-08d916e41005
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

I have been looking into some random crashes that appear to stem from
the stmmac_napi_poll_rx() function. There are two different panics I
have observed which are ...

[   19.591967] ------------[ cut here ]------------
[   19.596701] kernel BUG at /home/jonathanh/kernel/include/linux/skbuff.h:2297!
[   19.606273] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   19.611847] Modules linked in:
[   19.615146] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.10.0 #1
[   19.621357] Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
[   19.628010] pstate: 00c00009 (nzcv daif +PAN +UAO -TCO BTYPE=--)
[   19.634134] pc : eth_type_trans+0xf8/0x1a0
[   19.638326] lr : stmmac_napi_poll_rx+0x340/0xbd0
[   19.643123] sp : ffff800011f63ba0
[   19.646544] x29: ffff800011f63ba0 x28: 00000000000005ea 
[   19.651995] x27: ffff0003d4fe48c0 x26: 00000000000000d3 
[   19.657532] x25: ffff0003d4fe48c0 x24: 0000000000000000 
[   19.662961] x23: ffff0000828d1a40 x22: ffff000083497f00 
[   19.668503] x21: ffff000084b4d6c0 x20: ffff800011b79000 
[   19.673934] x19: 0000000000000000 x18: 0000000000000000 
[   19.679472] x17: 0000000000000000 x16: ffff00008095e291 
[   19.684953] x15: 0000000000000001 x14: 4f77dff9f5ddb24a 
[   19.690425] x13: 3ecd4adcbed3184e x12: bca593c98536d7f5 
[   19.695860] x11: 62327b117d535683 x10: 69f6607bf62388d6 
[   19.701297] x9 : a65753eedd84defc x8 : ffff000084b4dcd0 
[   19.706836] x7 : ffff000084b4dcc0 x6 : 0000000000000000 
[   19.712271] x5 : 0000000000001000 x4 : 0000008000000000 
[   19.717810] x3 : 00000000ffffffea x2 : 00000000000005dc 
[   19.723241] x1 : ffff0003d4fe4000 x0 : ffff000083497f00 
[   19.728777] Call trace:
[   19.731322]  eth_type_trans+0xf8/0x1a0
[   19.735163]  stmmac_napi_poll_rx+0x340/0xbd0
[   19.739540]  net_rx_action+0x220/0x368
[   19.743387]  __do_softirq+0x10c/0x264
[   19.747145]  run_ksoftirqd+0x44/0x58
[   19.750840]  smpboot_thread_fn+0x1d0/0x298
[   19.755025]  kthread+0x120/0x150
[   19.758484]  ret_from_fork+0x10/0x1c
[   19.762235] Code: 52800063 33000862 39020002 17ffffe0 (d4210000) 
[   19.768472] ---[ end trace 8e68a50b77108dd8 ]---
[   19.773159] Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt
[   19.780636] SMP: stopping secondary CPUs
[   19.785053] Kernel Offset: disabled
[   19.788691] CPU features: 0x0240002,2300aa30
[   19.793044] Memory Limit: none
[   19.796183] ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt ]---

... or ...

[   14.914607] Unable to handle kernel write to read-only memory at virtual address ffff000087ab3000
[   14.924064] Mem abort info:
[   14.927201]   ESR = 0x9600014f
[   14.930578]   EC = 0x25: DABT (current EL), IL = 32 bits
[   14.936484]   SET = 0, FnV = 0
[   14.939890]   EA = 0, S1PTW = 0
[   14.943603] Data abort info:
[   14.946781]   ISV = 0, ISS = 0x0000014f
[   14.950995]   CM = 1, WnR = 1
[   14.954334] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000004505ae000
[   14.961377] [ffff000087ab3000] pgd=000000047fff8003, p4d=000000047fff8003, pud=000000047fc6b003, pmd=000000047fc2d003, pte=0060000107ab3787
[   14.974932] Internal error: Oops: 9600014f [#1] PREEMPT SMP
[   14.980660] Modules linked in: tegra210_adma snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec host1x snd_hda_core crct10dif_ce tegra_aconnect pwm_fan lm90 pwm_tegra tegra_bpmp_thermal phy_tegra194_p2u pcie_tegra194 at24 ip_tables x_tables ipv6
[   15.003003] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.10.0 #1
[   15.009381] Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
[   15.016058] pstate: 80c00009 (Nzcv daif +PAN +UAO -TCO BTYPE=--)
[   15.022364] pc : __dma_inv_area+0x40/0x58
[   15.026660] lr : arch_sync_dma_for_cpu+0x1c/0x28
[   15.031368] sp : ffff800011f63ba0
[   15.035035] x29: ffff800011f63ba0 x28: 0000000000000000 
[   15.040658] x27: ffff0003d4fb88c0 x26: 00000000000000be 
[   15.046253] x25: ffff0003d4fb88c0 x24: 00000000000005ea 
[   15.051960] x23: ffff0000828bd7a0 x22: 00000000ffffffa8 
[   15.057544] x21: 0000000000000002 x20: ffff000080929010 
[   15.063251] x19: 0000000107a3d000 x18: 0000000000000001 
[   15.068957] x17: 0000000000000000 x16: 0000000000000000 
[   15.074517] x15: 0000000000000068 x14: b17d6301a8460a08 
[   15.080185] x13: 010100003bd8701b x12: 1080e9f16ff0a040 
[   15.086033] x11: 3bb9990301080263 x10: a8c00163a8c0ccd5 
[   15.091856] x9 : 06400040fb17dc05 x8 : ffff000083e108c0 
[   15.097401] x7 : ffff000083e108c0 x6 : 00000000ffffffa8 
[   15.102924] x5 : ffff8000109ca6e0 x4 : 0000000000000000 
[   15.108612] x3 : 000000000000003f x2 : 0000000000000040 
[   15.114302] x1 : ffff000187a3cf80 x0 : ffff000087ab3000 
[   15.119952] Call trace:
[   15.122543]  __dma_inv_area+0x40/0x58
[   15.126521]  dma_sync_single_for_cpu+0xac/0x100
[   15.131195]  stmmac_napi_poll_rx+0x490/0xbd0
[   15.135786]  net_rx_action+0x220/0x368
[   15.139663]  __do_softirq+0x10c/0x264
[   15.143609]  run_ksoftirqd+0x44/0x58
[   15.147452]  smpboot_thread_fn+0x1d0/0x298
[   15.151678]  kthread+0x120/0x150
[   15.155042]  ret_from_fork+0x10/0x1c
[   15.158772] Code: 8a230000 54000060 d50b7e20 14000002 (d5087620) 
[   15.165228] ---[ end trace 23cff873d17a8509 ]---


This is seen on our Tegra194 Jetson AGX Xavier and it seems that it
is more likely to occur when the CPU is operating at slower
frequencies. For instance if I set the CPU speed to the min of
115.2MHz it occurs more often but not 100%.

Please note that although the above panics logs are from 5.10, it
is also seen with the current mainline.

The bug being triggered in skbuff.h is the following ...

 void *skb_pull(struct sk_buff *skb, unsigned int len);
 static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
 {
         skb->len -= len;
         BUG_ON(skb->len < skb->data_len);
         return skb->data += len;
 }

Looking into the above panic triggered in skbuff.h, when this occurs
I have noticed that the value of skb->data_len is unusually large ...

 __skb_pull: len 1500 (14), data_len 4294967274

I then added some traces to stmmac_napi_poll_rx() and
stmmac_rx_buf2_len() to trace the values of various various variables
and when the problem occurs I see ...

 stmmac_napi_poll_rx: stmmac_rx: count 0, len 1518, buf1 66, buf2 1452
 stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1518
 stmmac_napi_poll_rx: stmmac_rx: count 1, len 1518, buf1 66, buf2 1452
 stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1536
 stmmac_napi_poll_rx: stmmac_rx: count 2, len 1602, buf1 66, buf2 1536
 stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 1602, plen 1518
 stmmac_napi_poll_rx: stmmac_rx: count 2, len 1518, buf1 0, buf2 4294967212
 stmmac_napi_poll_rx: stmmac_rx: dma_buf_sz 1536, buf1 0, buf2 4294967212

The above shows that occasionally the value of 'len' passed to
stmmac_rx_buf2_len() is greater than the value returned by
stmmac_get_rx_frame_len() and stored in 'plen', which then causes
stmmac_rx_buf2_len() to return a negative value but is then treated
as an unsigned value. So it is clear to me that there is overflow 
happening occasionally, but I am not sure how to fix it. I tried the
following but this appears to be causing other issues ...

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160..26336de80fe8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3728,7 +3728,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 
        /* Not last descriptor */
        if (status & rx_not_ls)
-               return priv->dma_buf_sz;
+               return priv->dma_buf_sz - len;
 
        plen = stmmac_get_rx_frame_len(priv, p, coe);
 
@@ -3848,7 +3848,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
                buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
                len += buf1_len;
-               buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
+               buf2_len = stmmac_rx_buf2_len(priv, p, status, buf1_len);
                len += buf2_len;


The patch I added to trace the various variable is as follows ...

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160..975059bb3165 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3723,15 +3723,20 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
        unsigned int plen = 0;
 
        /* Not split header, buffer is not available */
-       if (!priv->sph)
+       if (!priv->sph) {
+               trace_printk("%s: len %u, plen %u\n", __func__, len, priv->dma_buf_sz);
                return 0;
+       }
 
        /* Not last descriptor */
-       if (status & rx_not_ls)
+       if (status & rx_not_ls) {
+               trace_printk("%s: len %u, plen %u\n", __func__, len, priv->dma_buf_sz);
                return priv->dma_buf_sz;
+       }
 
        plen = stmmac_get_rx_frame_len(priv, p, coe);
 
+       trace_printk("%s: len %u, plen %u\n", __func__, len, plen);
        /* Last descriptor */
        return plen - len;
 }
@@ -3850,7 +3855,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
                len += buf1_len;
                buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
                len += buf2_len;
-
+               trace_printk("%s: count %u, len %u, buf1 %u, buf2 %u\n", __func__,
+                            count, len, buf1_len, buf2_len);
+               if (buf1_len > priv->dma_buf_sz || buf2_len > priv->dma_buf_sz) {
+                       trace_printk("%s: dma_buf_sz %u, buf1 %u, buf2 %u\n",
+                               __func__, priv->dma_buf_sz, buf1_len, buf2_len);
+                       BUG_ON(1);
+               }
                /* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
                 * Type frames (LLC/LLC-SNAP)
                 *

Note I added the above BUG_ON to trap unusually large buffers. Let
me know if you have any thoughts.

Thanks!
Jon

-- 
nvpublic
