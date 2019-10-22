Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B12DFBAD
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfJVCfh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Oct 2019 22:35:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:54583 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfJVCfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 22:35:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 19:35:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="227536442"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga002.fm.intel.com with ESMTP; 21 Oct 2019 19:35:35 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 21 Oct 2019 19:35:34 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX116.amr.corp.intel.com ([169.254.7.79]) with mapi id 14.03.0439.000;
 Mon, 21 Oct 2019 19:35:34 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ethernet/intel:  release the local packet buffer
Thread-Topic: [PATCH] ethernet/intel:  release the local packet buffer
Thread-Index: AQHVbbQoopumek9cY0G4nbDkuqi67admH4Jg
Date:   Tue, 22 Oct 2019 02:35:33 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971541EE@ORSMSX103.amr.corp.intel.com>
References: <20190918000013.32083-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190918000013.32083-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTM4YzlmZmUtNThjMi00ZWRiLWE1MDctOTI1ZWRhYmQ4Mzc2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWDQ1cE1KVzVLRjl6VDVFZ1VLQ3pweGJ2SEZKK2dhRE9JZ0xxVWZtbCtCSm1FS3VGbHpwQkFubE85ZU5hSVp6UiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Navid Emamdoost
> Sent: Tuesday, September 17, 2019 5:00 PM
> Cc: emamd001@umn.edu; smccaman@umn.edu; kjlu@umn.edu; Navid
> Emamdoost <navid.emamdoost@gmail.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; David S. Miller <davem@davemloft.net>;
> intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] ethernet/intel: release the local packet bufferq
> 
> In e100_loopback_test the buffer allocated for the local packet needs to
> be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/intel/e100.c | 1 +
>  1 file changed, 1 insertion(+)

Sorry for the delay getting to this, took me a bit to get the hardware together.

NAK, this patch introduces a trace to my test machines when I run the ethtool diagnostic on an e100 port, the system will sometimes survive a bit after the trace, however if I try to run traffic across the interface after the trace the system panics and locks up with a kernel not syncing message.  I do not have a capture of the lock up panic (I can probably get one via serial port or netconsole if really necessary.)  The trace before the lock up panic is as follows:
---------------------------------------------------------------------------
[  102.460446] BUG: Bad page state in process ethtool  pfn:78db8
[  102.460474] page:ffffd5bf41e36e00 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
[  102.460505] flags: 0xfffffc0000000()
[  102.460523] raw: 000fffffc0000000 dead000000000100 dead000000000122 0000000000000000
[  102.460553] raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
[  102.460582] page dumped because: nonzero _refcount
[  102.460602] Modules linked in: snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_intel_nhlt snd_hda_codec
 snd_hwdep snd_hda_core snd_seq snd_seq_device snd_pcm mei_wdt snd_timer iTCO_wdt mei_me snd iTCO_vendor_support gpio_ic
h mei coretemp lpc_ich pcspkr sg soundcore i2c_i801 joydev acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_t
ables xfs libcrc32c sd_mod sr_mod cdrom i915 video i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_
fops e1000e ata_generic firewire_ohci pata_marvell ata_piix drm pata_acpi serio_raw e100 firewire_core libata ptp pps_co
re mii crc_itu_t
[  102.460800] CPU: 3 PID: 1541 Comm: ethtool Not tainted 5.4.0-rc1_next-queue_dev-queue_regress-00576-g16390e0 #3
[  102.460836] Hardware name:  /DQ35JO, BIOS JOQ3510J.86A.0954.2008.0922.2331 09/22/2008
[  102.460865] Call Trace:
[  102.460883]  dump_stack+0x5a/0x73
[  102.460900]  bad_page+0xf5/0x10f
[  102.460916]  get_page_from_freelist+0x103e/0x1290
[  102.460936]  ? __switch_to_asm+0x40/0x70
[  102.460955]  ? __build_skb+0x20/0x190
[  102.460972]  __alloc_pages_nodemask+0x17d/0x320
[  102.460991]  page_frag_alloc+0x87/0x130
[  102.461008]  __netdev_alloc_skb+0x10b/0x130
[  102.461029]  e100_rx_alloc_skb+0x20/0x180 [e100]
[  102.461050]  e100_rx_alloc_list+0x98/0x160 [e100]
[  102.461070]  e100_up+0x11/0x120 [e100]
[  102.461088]  e100_diag_test+0x14e/0x157 [e100]
[  102.461107]  ? _cond_resched+0x15/0x30
[  102.461125]  ? dev_ethtool+0x1133/0x2c30
[  102.461143]  dev_ethtool+0x1159/0x2c30
[  102.461161]  ? inet_ioctl+0x1a0/0x1d0
[  102.461178]  ? netdev_run_todo+0x5d/0x2d0
[  102.461196]  dev_ioctl+0xb3/0x4e0
[  102.461212]  sock_do_ioctl+0xa0/0x140
[  102.461228]  ? do_anonymous_page+0x361/0x670
[  102.461247]  sock_ioctl+0x26e/0x380
[  102.461264]  do_vfs_ioctl+0xa9/0x630
[  102.461281]  ? handle_mm_fault+0xe2/0x1f0
[  102.462101]  ? __do_page_fault+0x247/0x490
[  102.462911]  ksys_ioctl+0x60/0x90
[  102.463715]  __x64_sys_ioctl+0x16/0x20
[  102.464519]  do_syscall_64+0x5b/0x1b0
[  102.465321]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  102.466134] RIP: 0033:0x7f03e53f32f7
[  102.466948] Code: 44 00 00 48 8b 05 79 1b 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 1b 2d 00 f7 d8 64 89 01 48
[  102.468728] RSP: 002b:00007ffffc72ebf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  102.469657] RAX: ffffffffffffffda RBX: 00007ffffc72ec50 RCX: 00007f03e53f32f7
[  102.470595] RDX: 00007ffffc72ec60 RSI: 0000000000008946 RDI: 0000000000000003
[  102.471532] RBP: 0000000000000001 R08: 0000000000000002 R09: 0000000000000038
[  102.472453] R10: 00007ffffc72e7c0 R11: 0000000000000246 R12: 0000000000000038
[  102.473359] R13: 0000000001428010 R14: 00000000014280d0 R15: 00007ffffc72edc8
[  102.474260] Disabling lock debugging due to kernel taint
[  104.924447] e100 0000:06:00.0 eth0: NIC Link is Up 100 Mbps Full Duplex
---------------------------------------------------------------------------


