Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7486E1A0DF6
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgDGMug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 08:50:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgDGMuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 08:50:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037CljX7161583;
        Tue, 7 Apr 2020 12:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j94009vUf8XWUVxRYBfWvQUQRG2QBoE5hbWKzFiNLSY=;
 b=ccw1bzA3lx6xoZ6UKJ2BmDk4muoBO/dT7MQwSfmokPgW3hOWSgNKUh/Hds1cab2DWKN1
 Psv2y0fikCDnO+adX9lMFt65sZ407W3koTUbFNqsd+HtqdWGaWR/fSn4JU8cCQ+VLIvN
 HWmi/Ew66uOSoBNT/IzsI0Gwl94JmI5Wao9Pi2ZEZYSrfKtzclCW5PhjVLRYwTiYYnXe
 XfZT3dYMNfGBvCMVjBCgcImaXosbD6RPyiDUlYKBE51kXDJE+a4YhrN8n3lKRRbfe5Ym
 0o4cEU0pek97svlTM32GkiXZKIBID3KbMlProgkF+ki0SihrMJ75xKQCmay80+IXLOVZ aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 306j6mcp08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 12:50:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037ClHHN111184;
        Tue, 7 Apr 2020 12:50:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3073qfwdes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 12:50:20 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037CoJ8K018338;
        Tue, 7 Apr 2020 12:50:19 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 05:50:18 -0700
Date:   Tue, 7 Apr 2020 15:50:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 5/5] ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb
Message-ID: <20200407125010.GJ2001@kadam>
References: <20200404041838.10426-1-hqjagain@gmail.com>
 <20200404041838.10426-6-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404041838.10426-6-hqjagain@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 04, 2020 at 12:18:38PM +0800, Qiujun Huang wrote:
> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
> usb_ifnum_to_if(urb->dev, 0)
> But it isn't always true.
> 
> The case reported by syzbot:
> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
> usb 2-1: new high-speed USB device number 2 using dummy_hcd
> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
> usb 2-1: config 1 has no interface number 0
> usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
> 1.08
> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> general protection fault, probably for non-canonical address
> 0xdffffc0000000015: 0000 [#1] SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
> 
> Call Trace
> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
> expire_timers kernel/time/timer.c:1449 [inline]
> __run_timers kernel/time/timer.c:1773 [inline]
> __run_timers kernel/time/timer.c:1740 [inline]
> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
> __do_softirq+0x21e/0x950 kernel/softirq.c:292
> invoke_softirq kernel/softirq.c:373 [inline]
> irq_exit+0x178/0x1a0 kernel/softirq.c:413
> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> 
> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 48 ++++++++++++++++++------
>  drivers/net/wireless/ath/ath9k/hif_usb.h |  5 +++
>  2 files changed, 42 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 6049d3766c64..4ed21dad6a8e 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -643,9 +643,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>  
>  static void ath9k_hif_usb_rx_cb(struct urb *urb)
>  {
> -	struct sk_buff *skb = (struct sk_buff *) urb->context;
> -	struct hif_device_usb *hif_dev =
> -		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
> +	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
> +	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
> +	struct sk_buff *skb = rx_buf->skb;
>  	int ret;
>  
>  	if (!skb)

This "if (!skb)" error path returns directly and leaks "rx_buf".
Of course, it's an impossible condition.  We should just delete the
check.

> @@ -685,14 +685,15 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
>  	return;
>  free:
>  	kfree_skb(skb);
> +	kfree(rx_buf);
>  }
>  
>  static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  {
> -	struct sk_buff *skb = (struct sk_buff *) urb->context;
> +	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
> +	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
> +	struct sk_buff *skb = rx_buf->skb;
>  	struct sk_buff *nskb;
> -	struct hif_device_usb *hif_dev =
> -		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
>  	int ret;
>  
>  	if (!skb)

Same.

> @@ -750,6 +751,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  	return;
>  free:
>  	kfree_skb(skb);
> +	kfree(rx_buf);
>  	urb->context = NULL;
>  }
>  

regards,
dan carpenter
