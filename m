Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722D2440C8C
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 03:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhJaCp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 22:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaCp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 22:45:26 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0706DC061570;
        Sat, 30 Oct 2021 19:42:55 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id t40so12916202qtc.6;
        Sat, 30 Oct 2021 19:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4pTpNp+ctrU1VcOo9RHb5FHn9UkMoYaGEFwbc7czNlw=;
        b=HI2oJgy7m5eV+XVozD3/C005/TKCpmoqYD90457YhJWPYqG4yxZOjMOHFjoeKPFmqC
         XAlf1bQtsxs9YakyjiarZSgI/gJpbY9A95wjfpVZP60vR2z9EHB3C/7dU5uD1YeIJ7ax
         WnU/EmOUPGg6EF5+c1SW3/q+NEIleSppP9tnUlqir6x3ljUnRz670+1ieKI3jv2pQKOv
         jF2wfY++7sNeVcOVo+28L0FNlQ/AVzPpzfHmrJXYIlK16KEuvRJU8MTWRf09muFurjyg
         813NbrzbI/SoNJLjkg9BVihrQTzvDT20id+OdmqD6K0vu/QDdQN6lSQpFguBavfPREgN
         zABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4pTpNp+ctrU1VcOo9RHb5FHn9UkMoYaGEFwbc7czNlw=;
        b=3cu4PbUWmZha1Rf2+Fs1adszd2VwWH7QulnHDH+GDs72iXFRvuef4mGvStILlkMn73
         pVPeWra9NbxkFU8LBHA85zXp9yVuGqc2h9tdaphRjd//eyUkcrNIE1pKmFAkWkA0ak1X
         oaC9SmWRgCXr+NXJDwVdpZWPLruBD7L3oYbxsj5sj5e+QZJCoblhRTrie1uXnzsPjRJU
         4lbBTt25VMdCFiw6xkUbQ1DQ8ZqzT5HC6V1Wd5Hjugu5J/DU0+wdnb8YbiImas4fF0OI
         jcN+I1W+bNNKUeCO1q7aHgfTlr+XcdnmZ+VQQDB7xs8u6ZTdpeB/sEw9ja7u6ihqgPdX
         NoLQ==
X-Gm-Message-State: AOAM532+pq5ySIUIS9wKNe2cjxrjpZYXMJ+ADeS3xNDVFzfmwtcPKNPC
        45/Iu0fHnz+YJ63C18UXnVk=
X-Google-Smtp-Source: ABdhPJxetHAF/mKwh0e6XS/DQKI2r+ozbBPRlT3Sd2LEbpSrdmeBVMlbAgPHhvmsXm39F3v0zN2Bcw==
X-Received: by 2002:ac8:5990:: with SMTP id e16mr21171559qte.38.1635648173944;
        Sat, 30 Oct 2021 19:42:53 -0700 (PDT)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id i12sm4116907qtx.1.2021.10.30.19.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 19:42:53 -0700 (PDT)
Date:   Sat, 30 Oct 2021 22:42:50 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] mwifiex_usb: Fix skb_over_panic in mwifiex_usb_recv
Message-ID: <YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, with an unknown recv_type, mwifiex_usb_recv
just return -1 without restoring the skb. Next time
mwifiex_usb_rx_complete is invoked with the same skb,
calling skb_put causes skb_over_panic.

The bug is triggerable with a compromised/malfunctioning
usb device. After applying the patch, skb_over_panic
no longer shows up with the same input.

Attached is the panic report from fuzzing.
skbuff: skb_over_panic: text:000000003bf1b5fa
 len:2048 put:4 head:00000000dd6a115b data:000000000a9445d8
 tail:0x844 end:0x840 dev:<NULL>
kernel BUG at net/core/skbuff.c:109!
invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 PID: 198 Comm: in:imklog Not tainted 5.6.0 #60
RIP: 0010:skb_panic+0x15f/0x161
Call Trace:
 <IRQ>
 ? mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
 skb_put.cold+0x24/0x24
 mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __hrtimer_run_queues+0x316/0x740
 ? __usb_hcd_giveback_urb+0x380/0x380
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 irq_exit+0x114/0x140
 smp_apic_timer_interrupt+0xde/0x380
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Reported-by: Zekun Shen <bruceshenzk@gmail.com>
Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 426e39d4c..6d81e8786 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -130,7 +130,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		default:
 			mwifiex_dbg(adapter, ERROR,
 				    "unknown recv_type %#x\n", recv_type);
-			return -1;
+			ret = -1;
+			goto exit_restore_skb;
 		}
 		break;
 	case MWIFIEX_USB_EP_DATA:
-- 
2.25.1

