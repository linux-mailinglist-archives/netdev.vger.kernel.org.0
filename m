Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1CAFC8BC
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNOUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:20:31 -0500
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:42145 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfKNOUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:20:31 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2019 09:20:28 EST
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTP id 47DNhb1fwQz11XY
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 14:11:59 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2dn3.dwd.de ([127.0.0.1])
        by localhost (ofcsg2dn3.dwd.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id gwgmMzMlALxa for <netdev@vger.kernel.org>;
        Thu, 14 Nov 2019 14:11:59 +0000 (UTC)
Received: from ofmailhub.dwd.de (oflxs446.dwd.de [141.38.40.78])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTP id 47DNhb0Jdtz11XS;
        Thu, 14 Nov 2019 14:11:59 +0000 (UTC)
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.42.142])
        by ofmailhub.dwd.de (Postfix) with ESMTP id DED17195F9;
        Thu, 14 Nov 2019 14:11:58 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:11:58 +0000 (UTC)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@praktifix.dwd.de
To:     tariqt@mellanox.com, netdev@vger.kernel.org
Subject: mlx4 kernel oops when rebooting system
Message-ID: <alpine.LRH.2.21.1911141316340.16328@praktifix.dwd.de>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have two systems each having two Mellanox ConnectX-3 Pro cards and
every time the system is rebooted it gets a kernel oops. If I remember
it correctly, this started when I upgraded to kernel 4.19.x. Before with
4.14.x I did not get this. I tried with newer kernels, but that did
not help. Here an oops with kernel 5.1.21:

 {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
 {1}[Hardware Error]: event severity: fatal
 {1}[Hardware Error]:  Error 0, type: fatal
 {1}[Hardware Error]:   section_type: PCIe error
 {1}[Hardware Error]:   port_type: 4, root port
 {1}[Hardware Error]:   version: 1.16
 {1}[Hardware Error]:   command: 0x6010, status: 0x0143
 {1}[Hardware Error]:   device_id: 0000:80:03.0
 {1}[Hardware Error]:   slot: 0
 {1}[Hardware Error]:   secondary_bus: 0x88
 {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x2f08
 {1}[Hardware Error]:   class_code: 040600
 {1}[Hardware Error]:   bridge: secondary_status: 0x2000, control: 0x0003
 {1}[Hardware Error]:  Error 1, type: fatal
 {1}[Hardware Error]:   section_type: PCIe error
 {1}[Hardware Error]:   port_type: 4, root port
 {1}[Hardware Error]:   version: 1.16
 {1}[Hardware Error]:   command: 0x6010, status: 0x0143
 {1}[Hardware Error]:   device_id: 0000:80:03.0
 {1}[Hardware Error]:   slot: 0
 {1}[Hardware Error]:   secondary_bus: 0x88
 {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x2f08
 {1}[Hardware Error]:   class_code: 040600
 {1}[Hardware Error]:   bridge: secondary_status: 0x2000, control: 0x0003
 Kernel panic - not syncing: Fatal hardware error!
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.1.21 #1
 Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 03/25/2019
 Call Trace:
  <NMI>
  dump_stack+0x46/0x5b
  panic+0xf7/0x291
  __ghes_panic+0x63/0x6f
  ghes_notify_nmi+0x1fd/0x290
  nmi_handle+0x69/0x110
  do_nmi+0x117/0x3a0
  end_repeat_nmi+0x16/0x50
 RIP: 0010:intel_idle+0x7d/0x120
 Code: 04 25 00 4d 01 00 48 89 d1 0f 01 c8 48 8b 00 a8 08 75 17 e9 07 00 00 00 0f 00 2d 9e 6b 48 00 b9 01 00 00 00 48 89 e8 0f 01 c9 <65> 48 8b 04 25 00 4d 01 00 f0 80 60 02 df f0 83 44 24 fc 00 48 8b
 RSP: 0018:ffffffff88003e40 EFLAGS: 00000046
 RAX: 0000000000000020 RBX: 0000000000000004 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: ffffffff88097780 RDI: 0000000000000000
 RBP: 0000000000000020 R08: 0000000000000002 R09: ffe813d0035074b0
 R10: 0000000000000018 R11: 071c71c71c71c71c R12: 0000000000000004
 R13: ffffffff88097918 R14: ffffffff88015780 R15: 0000000000000000
  ? intel_idle+0x7d/0x120
  ? intel_idle+0x7d/0x120
  </NMI>
  cpuidle_enter_state+0x7c/0x3a0
  do_idle+0x1ad/0x230
  cpu_startup_entry+0x14/0x20
  start_kernel+0x502/0x522
  ? set_init_arg+0x50/0x50
  secondary_startup_64+0xa4/0xb0
 Kernel Offset: 0x6000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Not sure if it is related but on

    https://docs.mellanox.com/display/MLNXOFEDv471001/Bug+Fixes

I read under 1843020 "Server reboot may result in a system crash.".
So could it be that Mellanox already fixed the problem but this did
not get back ported to the kernel.org driver?

Problem with this panic is that one can no longer poweroff the system
safely because it then reboots.

Please advice what I can do or provide other information to help fix
the problem.

Regards,
Holger


PS: Please CC me since I am not on netdev@vger.kernel.org
