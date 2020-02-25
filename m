Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A14416BBFD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgBYIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:41:01 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52265 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBYIlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:41:00 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1j6Vlx-0003il-Al; Tue, 25 Feb 2020 09:40:57 +0100
Received: from [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad] (unknown [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EFFDE4C0314;
        Tue, 25 Feb 2020 08:40:55 +0000 (UTC)
Subject: Re: [PATCH v2] can: af_can: can_rcv() canfd_rcv(): Fix access of
 uninitialized memory or out of bounds
To:     "linux-can @ vger . kernel . org" <linux-can@vger.kernel.org>
Cc:     kernel@pengutronix.de, glider@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
References: <20200225083950.2542543-1-mkl@pengutronix.de>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXz
Message-ID: <bde858ee-f4d8-4f3c-8b50-95f1a917c869@pengutronix.de>
Date:   Tue, 25 Feb 2020 09:40:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200225083950.2542543-1-mkl@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 9:39 AM, Marc Kleine-Budde wrote:
> Syzbot found the use of uninitialzied memory when injecting non conformant
> CANFD frames via a tun device into the kernel:
> 
> | BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
> | CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
> | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> | Call Trace:
> |  __dump_stack lib/dump_stack.c:77 [inline]
> |  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
> |  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
> |  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
> |  number+0x9f8/0x2000 lib/vsprintf.c:459
> |  vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
> |  vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
> |  vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
> |  vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
> |  vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
> |  vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
> |  printk+0x18b/0x1d3 kernel/printk/printk.c:2062
> |  canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
> |  __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
> |  __netif_receive_skb net/core/dev.c:5312 [inline]
> |  netif_receive_skb_internal net/core/dev.c:5402 [inline]
> |  netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
> |  tun_rx_batched include/linux/skbuff.h:4321 [inline]
> |  tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
> |  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
> |  call_write_iter include/linux/fs.h:1901 [inline]
> |  new_sync_write fs/read_write.c:483 [inline]
> |  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
> |  vfs_write+0x44a/0x8f0 fs/read_write.c:558
> |  ksys_write+0x267/0x450 fs/read_write.c:611
> |  __do_sys_write fs/read_write.c:623 [inline]
> |  __se_sys_write+0x92/0xb0 fs/read_write.c:620
> |  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
> |  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
> |  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> In canfd_rcv() the non conformant CANFD frame (i.e. skb too short) is detected,
> but the pr_warn_once() accesses uninitialized memory or the skb->data out of
> bounds to print the warning message.
> 
> This problem exists in both can_rcv() and canfd_rcv(). This patch removes the
> access to the skb->data from the pr_warn_once() in both functions.
> 
> Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hello,
> 
> changes since RFC:
> - print cfd->len if backed by skb, -1 otherwise
>   (Requested by Oliver)

Doh! I have to adjust the patch description. Will do in next iteration.

Marc

-- 
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
