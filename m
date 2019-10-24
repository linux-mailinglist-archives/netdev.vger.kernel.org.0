Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11263E3C56
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437359AbfJXTs7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 15:48:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:59469 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437273AbfJXTs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:48:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 12:48:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="399879464"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 24 Oct 2019 12:48:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/sched/sch_generic.c:448
In-Reply-To: <20191024032105.xmewznsphltnrido@linux-p48b>
References: <20191024032105.xmewznsphltnrido@linux-p48b>
Date:   Thu, 24 Oct 2019 12:50:11 -0700
Message-ID: <87mudpylcc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Davidlohr Bueso <dave@stgolabs.net> writes:

> Hi,
>
> I'm hitting the following in linux-next, and as far back as v5.2, ring any bells?
>
> [  478.588144] NETDEV WATCHDOG: eth0 (igb): transmit queue 0 timed out
> [  478.601994] WARNING: CPU: 10 PID: 74 at net/sched/sch_generic.c:448 dev_watchdog+0x253/0x260
> [  478.620613] Modules linked in: ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) bpfilter(E) scsi_transport_iscsi(E) af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) ext4(E) intel_rapl_msr(E) intel_rapl_common(E) crc16(E) mbcache(E) jbd2(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crc32_pclmul(E) iTCO_wdt(E) ghash_clmulni_intel(E) iTCO_vendor_support(E) aesni_intel(E) crypto_simd(E) cryptd(E) glue_helper(E) ipmi_si(E) igb(E) ioatdma(E) pcspkr(E) ipmi_devintf(E) mei_me(E) lpc_ich(E) mfd_core(E) ipmi_msghandler(E) joydev(E) i2c_i801(E) mei(E) dca(E) button(E) btrfs(E) libcrc32c(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) sd_mod(E) mgag200(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) i2c_algo_bit(E) isci(E) ehci_pci(E) drm_vram_helper(E) ahci(E) ehci_hcd(E) libsas(E) crc32c_intel(E) ttm(E) libahci(E) scsi_transport_sas(E) drm(E) usbcore(E)
> [  478.620658]  libata(E) wmi(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
> [  478.837008] CPU: 10 PID: 74 Comm: ksoftirqd/10 Kdump: loaded Tainted: G            E     5.4.0-rc4-2-default+ #2
> [  478.859457] Hardware name: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP04.112220131546 11/22/2013
> [  478.882867] RIP: 0010:dev_watchdog+0x253/0x260

Not ringing any bells, but if this timeout is happening, you should also
be seeing some igb "TX Hang" warnings. Usually this warning happens when
some packet is stuck (for whatever reason) in the transmission queue.

Can you share more details about what you are running? specially the
kind of configuration (if any) you are doing to the controller.


Cheers,
--
Vinicius
