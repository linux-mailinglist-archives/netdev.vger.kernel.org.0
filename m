Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EC443FD85
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhJ2Nsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhJ2Nsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:48:39 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125BC061570;
        Fri, 29 Oct 2021 06:46:11 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id g25so5330320qvf.13;
        Fri, 29 Oct 2021 06:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RbpeTIeeRwWf8vsmX2ayyHoFt9G9jI8h/GOkLH1xyTg=;
        b=Muw5a2y8SyYW5ErwxNs2JTIYLadNF+gdaGlFvsSFkibZUiqCwO8pz9eHvDEtu2Cz1K
         YYZCuGGL1L++MqTeHcoblqwoqAfg83UmFITtMql4tOlnqxTXy7GaymYdxVcgvXDDZdVc
         fL/ncLku7CYU4DW+gGOx3sgUhrHWEtmrL0FL0hFfkg78R6fM4uAbAQ69a3iC6bhyVo6F
         Dr0O7ZnXpPQTakZkrkW/cW7Bpta9OOvTslyIZfFBrBpUDMOkFZHeWTkjOMqZ50ObEoUn
         DpgaEkWFKgMljRi1/utcNlnqLTyEKnLoi/EL9nQGNHnJ0CqFfyiDNEVzGnA4YqP9J4vf
         49gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RbpeTIeeRwWf8vsmX2ayyHoFt9G9jI8h/GOkLH1xyTg=;
        b=N+lBvPgnosEnC3F6T5uhPyYnRX/AGyoWCw6wCsf6UcWUBWHSjV2Cup23jfWFHofvcF
         YLiA2CYjssKEp+EWtb53eytrlaLVAMmFOkMf1X+r/F1MlIb/Dn8PhJORDToeZ15WdEbA
         lHFl15Pv//+txrzU2isywq9ZYK34cUBYpaCGf2wqMaxOt7pGbR3BDOV9RlDWvTIu/AE8
         OWsHGvhK5TeyuVWlP3fNDeeTG8APUo7BowbZExHwKf+M0svTqHiYlhmn8reSOD6TbzPt
         lbxBJAGi3R51QBXttBkGuMau2BeswX2I2LLJXQh12piVBhFKvqw/0FspS6x1A1wLAsHD
         FhGA==
X-Gm-Message-State: AOAM531oPvBWLZKcsMI8vYZcWpj+RZ65c9ohUiycyTZjCQU3yql8HV0g
        Knclp0grKTXBun4n80qFXN16H2xWUVo=
X-Google-Smtp-Source: ABdhPJxY02PQEAvvV2gt4cqGYJgcsjbpNbrae7qBx32RSdFMPqkLpLxlnJxFdi86oFnIJ5er8rhjhg==
X-Received: by 2002:ad4:4246:: with SMTP id l6mr3678626qvq.65.1635515170168;
        Fri, 29 Oct 2021 06:46:10 -0700 (PDT)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id c13sm4322246qtc.42.2021.10.29.06.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 06:46:09 -0700 (PDT)
Date:   Fri, 29 Oct 2021 09:46:06 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream
Message-ID: <YXv7HpMlTMOIhiy4@Zekuns-MBP-16.fios-router.home>
References: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
 <87y26cxzb4.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y26cxzb4.fsf@tynnyri.adurom.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 06:52:31AM +0300, Kalle Valo wrote:
> Zekun Shen <bruceshenzk@gmail.com> writes:
> 
> > Large pkt_len can lead to out-out-bound memcpy. Current
> > ath9k_hif_usb_rx_stream allows combining the content of two urb
> > inputs to one pkt. The first input can indicate the size of the
> > pkt. Any remaining size is saved in hif_dev->rx_remain_len.
> > While processing the next input, memcpy is used with rx_remain_len.
> >
> > 4-byte pkt_len can go up to 0xffff, while a single input is 0x4000
> > maximum in size (MAX_RX_BUF_SIZE). Thus, the patch adds a check for
> > pkt_len which must not exceed 2 * MAX_RX_BUG_SIZE.
> >
> > BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> > Read of size 46393 at addr ffff888018798000 by task kworker/0:1/23
> >
> > CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 5.6.0 #63
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> > Workqueue: events request_firmware_work_func
> > Call Trace:
> >  <IRQ>
> >  dump_stack+0x76/0xa0
> >  print_address_description.constprop.0+0x16/0x200
> >  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> >  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> >  __kasan_report.cold+0x37/0x7c
> >  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> >  kasan_report+0xe/0x20
> >  check_memory_region+0x15a/0x1d0
> >  memcpy+0x20/0x50
> >  ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> >  ? hif_usb_mgmt_cb+0x2d9/0x2d9 [ath9k_htc]
> >  ? _raw_spin_lock_irqsave+0x7b/0xd0
> >  ? _raw_spin_trylock_bh+0x120/0x120
> >  ? __usb_unanchor_urb+0x12f/0x210
> >  __usb_hcd_giveback_urb+0x1e4/0x380
> >  usb_giveback_urb_bh+0x241/0x4f0
> >  ? __hrtimer_run_queues+0x316/0x740
> >  ? __usb_hcd_giveback_urb+0x380/0x380
> >  tasklet_action_common.isra.0+0x135/0x330
> >  __do_softirq+0x18c/0x634
> >  irq_exit+0x114/0x140
> >  smp_apic_timer_interrupt+0xde/0x380
> >  apic_timer_interrupt+0xf/0x20
> >
> > Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> 
> How did you test this?
I found the bug using a custome USBFuzz port. It's a research work
to fuzz USB stack/drivers. I modified it to fuzz ath9k driver only,
providing hand-crafted usb descriptors to QEMU.

After fixing the value of pkt_tag to ATH_USB_RX_STREAM_MODE_TAG in QEMU
emulation, I found the KASAN report. The bug is triggerable whenever
pkt_len is above two MAX_RX_BUG_SIZE. I used the same input that crashes
to test the driver works when applying the patch.
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
