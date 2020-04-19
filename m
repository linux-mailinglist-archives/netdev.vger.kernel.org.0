Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676811AFE71
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgDSViV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSViV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:38:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C7AC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:38:20 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so9136295wmh.3
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=8vEWK/7rygIKg+4NCoTnaR+BiRH4Y2zmHDic+EhcStk=;
        b=LFatzp4ppj+Og7OpvQ6tloJjLMNKowKC9QKB0/ZuJavK2RYlX/V7m0ZmgTVJm38A61
         8gfszwCRu02eYFC4Nege1o2igInYZj7U/81YaGfaFnhtsJ1PHq+szBXcZRlYkXccjNld
         Qm8MWarhnR0g5Ki+gLEAHldI4OrXDcANMCRyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8vEWK/7rygIKg+4NCoTnaR+BiRH4Y2zmHDic+EhcStk=;
        b=c53xPWCpYDKOAZHMb50J7hHkjL3PpPL5a8HRK7n57ribWj4foAlp0VVnhDv+M3pUv4
         kUbdlOgXr+NXwfKTImQNI4m0Ln8X690TyJuv0C4a/yhTrQPs2tm/5hOwWRUctQfpzFU+
         /ACWEIzS0zFd5zJiyIW5BSSUyAucsekTEOPuxXYuWheRiXtpR+vHfwmb8bUKPXdAzs9z
         mYu19pYmfKI/0IE3wp8TW6FET/G5bSL4/5P8GshXlzWWmFyATWx8S1QFn0pklKC2vdeu
         lcqYCH0kkFOaaaqUazfF7X+OXXoqSPFdpho89V9vTxcZ5zVZsU8W7wyEtgJFwg7B/pCR
         Q3SQ==
X-Gm-Message-State: AGi0PuYSBM/OKm5Tq0Xr8GIg/NQD0lTOFHoMkzDqnOz0DMph+Cr/tbEQ
        Y7T4a0c8SLVnzlrQdY8djQEyXx96Dnc=
X-Google-Smtp-Source: APiQypICgWnL0+dvE7ffQB62Lv8RXFalTIFurR1vBY4EGC0kcjPaFMlzhZEcCN4hvk/6lQ/rZ/qAdQ==
X-Received: by 2002:a1c:7d04:: with SMTP id y4mr14177056wmc.10.1587332299613;
        Sun, 19 Apr 2020 14:38:19 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id k9sm43487362wrd.17.2020.04.19.14.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 14:38:19 -0700 (PDT)
Date:   Mon, 20 Apr 2020 00:38:17 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb
 in rtl8169_mark_to_asic
Message-ID: <20200419213817.GA39723@carbon>
Mail-Followup-To: Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
 <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
 <20200419190029.GA37084@carbon>
 <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-04-19 23:03:57, Heiner Kallweit wrote:
> On 19.04.2020 21:00, Petko Manolov wrote:
> > On 20-04-19 20:16:21, Heiner Kallweit wrote:
> >> We want to ensure that desc->opts1 is written as last descriptor field.
> >> This doesn't require a full compiler barrier, WRITE_ONCE provides the
> >> ordering guarantee we need.
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
> >>  1 file changed, 4 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >> index 2fc65aca3..3e4ed2528 100644
> >> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >> @@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
> >>  {
> >>  	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
> >>  
> >> -	desc->opts2 = 0;
> >> -	/* Force memory writes to complete before releasing descriptor */
> >> -	dma_wmb();
> > 
> > If dma_wmb() was really ever needed here you should leave it even after you 
> > order these writes with WRITE_ONCE().  If not, then good riddance.
> > 
> My understanding is that we have to avoid transferring ownership of
> descriptor to device (by setting DescOwn bit) before opts2 field
> has been written. Using WRITE_ONCE() should be sufficient to prevent
> the compiler from merging or reordering the writes.
> At least that's how I read the process_level() example in
> https://www.kernel.org/doc/Documentation/memory-barriers.txt

WRITE_ONCE() will prevent the compiler from reordering, but not the CPU.  On x86 
this code will run just fine, but not on ARM or PPC.  Based on your description 
above i think dma_wmb() is still needed.


		Petko


> > Just saying, i am not familiar with the hardware nor with the driver. :)
> > 
> > 
> > 		Petko
> > 
> > 
> >> -
> >> -	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
> >> +	/* Ensure ordering of writes */
> >> +	WRITE_ONCE(desc->opts2, 0);
> >> +	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
> >>  }
> >>  
> >>  static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
> >> @@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
> >>  		return NULL;
> >>  	}
> >>  
> >> -	desc->addr = cpu_to_le64(mapping);
> >> +	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
> >>  	rtl8169_mark_to_asic(desc);
> >>  
> >>  	return data;
> >> -- 
> >> 2.26.1
> >>
> >>
> 
