Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC73467642
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380430AbhLCL2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380420AbhLCL2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:28:46 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A04CC061757
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 03:25:22 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 133so2119965wme.0
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 03:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3RjuwLlrhM4RaugB5EqP8K7MgHWl2y/JDvpsw8Kh3Kw=;
        b=u9sKOqg0RFOM8iEFk5rD0bJttsvjSiLECk8MJ6OqCT+4RDfTQ8BEXuGmr6T6DIv9rG
         EPOIdbNCga0jxADLP2Kmjok3kywdVdeEIxa7ixv/fhnf+ZYVWBGtFSxGlImyRyVZMpps
         22wFeafTo7+Lm6cQVWCgAFg3zy2+dU+BQu+WK9N219MT0u1R6fzhV2QUXNv3bwDXkoDl
         eJbS+OcnTXNQh/N4qCpOZsOy0bk3bFiFQdxjyb7Tufy0EaiSPZcDL482wNAmNMYClb09
         EQiNFmsFxZ0YKegbeMu8XRouHWvAeqJ8iL6sti0e2VhBrSY0mJhE7edTi5xjnmiO5h93
         r9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3RjuwLlrhM4RaugB5EqP8K7MgHWl2y/JDvpsw8Kh3Kw=;
        b=3qeO1dqLVOCwKIbYqLCfg9v+jTtbFtQ/yE/bWqklksF492H2Mzrk/SxygfSx8/uAkT
         ZYjP1ORpWaSSYWKL+zamdraF7hjBcQ7lT4E+tnXcCajchdDBqsf93AHY+g7PoKP9w7tE
         DL+/VNEXXoucwHYpcWGbo+DTLyw+92r0VDLzG1PUVbsvNixVQJP2iuAUvXPp0vebDBwN
         8vYSnDHCLK8vSKEgFgVaiTyR6tvFnq8YfU5kM2dj9ebUS44AR+wUipNf8cnjDHr7+Vou
         Tw5thiuJGtf7SzsT3+fdfjDZWycuN8u8pVGt/yd3/EIM2sWr6XZ7e38P8TATPXJ8PkkI
         jTEA==
X-Gm-Message-State: AOAM532L2xuP0c+vI191Y9S0KcUJp6coheIrG1BmxMqbnkvoJtBkmIpj
        sPbauXA5Kdo6H6EZbrT2PwtlEQ==
X-Google-Smtp-Source: ABdhPJz+cGHOxy5Mt0/jQV/UOWaSpy9XrPsrHUAMDW7DVVzwmjio8rNtLAaEoel4rwUawHO2LQoEwQ==
X-Received: by 2002:a05:600c:4308:: with SMTP id p8mr13873064wme.132.1638530720576;
        Fri, 03 Dec 2021 03:25:20 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id c10sm2525955wrb.81.2021.12.03.03.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 03:25:20 -0800 (PST)
Date:   Fri, 3 Dec 2021 11:25:18 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Message-ID: <Yan+nvfyS21z7ZUw@google.com>
References: <20211202143437.1411410-1-lee.jones@linaro.org>
 <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87o85yj81l.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o85yj81l.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021, Bjørn Mork wrote:

> Hello Lee!
> 
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Thu,  2 Dec 2021 14:34:37 +0000 Lee Jones wrote:
> >> Currently, due to the sequential use of min_t() and clamp_t() macros,
> >> in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is not set, the logic
> >> sets tx_max to 0.  This is then used to allocate the data area of the
> >> SKB requested later in cdc_ncm_fill_tx_frame().
> >> 
> >> This does not cause an issue presently because when memory is
> >> allocated during initialisation phase of SKB creation, more memory
> >> (512b) is allocated than is required for the SKB headers alone (320b),
> >> leaving some space (512b - 320b = 192b) for CDC data (172b).
> >> 
> >> However, if more elements (for example 3 x u64 = [24b]) were added to
> >> one of the SKB header structs, say 'struct skb_shared_info',
> >> increasing its original size (320b [320b aligned]) to something larger
> >> (344b [384b aligned]), then suddenly the CDC data (172b) no longer
> >> fits in the spare SKB data area (512b - 384b = 128b).
> >> 
> >> Consequently the SKB bounds checking semantics fails and panics:
> >> 
> >>   skbuff: skb_over_panic: text:ffffffff830a5b5f len:184 put:172   \
> >>      head:ffff888119227c00 data:ffff888119227c00 tail:0xb8 end:0x80 dev:<NULL>
> >> 
> >>   ------------[ cut here ]------------
> >>   kernel BUG at net/core/skbuff.c:110!
> >>   RIP: 0010:skb_panic+0x14f/0x160 net/core/skbuff.c:106
> >>   <snip>
> >>   Call Trace:
> >>    <IRQ>
> >>    skb_over_panic+0x2c/0x30 net/core/skbuff.c:115
> >>    skb_put+0x205/0x210 net/core/skbuff.c:1877
> >>    skb_put_zero include/linux/skbuff.h:2270 [inline]
> >>    cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1116 [inline]
> >>    cdc_ncm_fill_tx_frame+0x127f/0x3d50 drivers/net/usb/cdc_ncm.c:1293
> >>    cdc_ncm_tx_fixup+0x98/0xf0 drivers/net/usb/cdc_ncm.c:1514
> >> 
> >> By overriding the max value with the default CDC_NCM_NTB_MAX_SIZE_TX
> >> when not offered through the system provided params, we ensure enough
> >> data space is allocated to handle the CDC data, meaning no crash will
> >> occur.
> 
> Just out of curiouslity: Is this a real device, or was this the result
> of fuzzing around?

This is the result of "fuzzing around" on qemu. :)

https://syzkaller.appspot.com/bug?extid=2c9b6751e87ab8706cb3

> Not that it matters - it's obviously a bug to fix in any case.  Good catch!
> 
> (We probably have many more of the same, assuming the device presents
> semi-sane values in the NCM parameter struct)
> 
> >> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> >> index 24753a4da7e60..e303b522efb50 100644
> >> --- a/drivers/net/usb/cdc_ncm.c
> >> +++ b/drivers/net/usb/cdc_ncm.c
> >> @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
> >>  		min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth32);
> >>  
> >>  	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
> >> +	if (max == 0)
> >> +		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
> >>  
> >>  	/* some devices set dwNtbOutMaxSize too low for the above default */
> >>  	min = min(min, max);
> 
> It's been a while since I looked at this, so excuse me if I read it
> wrongly.  But I think we need to catch more illegal/impossible values
> than just zero here?  Any buffer size which cannot hold a single
> datagram is pointless.
> 
> Trying to figure out what I possible meant to do with that
> 
>  	min = min(min, max);
> 
> I don't think it makes any sense?  Does it?  The "min" value we've
> carefully calculated allow one max sized datagram and headers. I don't
> think we should ever continue with a smaller buffer than that

I was more confused with the comment you added to that code:

   /* some devices set dwNtbOutMaxSize too low for the above default */
   min = min(min, max);

... which looks as though it should solve the issue of an inadequate
dwNtbOutMaxSize, but it almost does the opposite.  I initially
changed this segment to use the max() macro instead, but the
subsequent clamp_t() macro simply chooses 'max' (0) value over the now
sane 'min' one.

Which is why I chose 
> Or are there cases where this is valid?

I'm not an expert on the SKB code, but in my simple view of the world,
if you wish to use a buffer for any amount of data, you should
allocate space for it.

> So that really should haven been catching this bug with a
> 
>   max = max(min, max)

I tried this.  It didn't work either.

See the subsequent clamp_t() call a few lines down.

> or maybe more readable
> 
>   if (max < min)
>      max = min
> 
> What do you think?

So the data that is added to the SKB is ctx->max_ndp_size, which is
allocated in cdc_ncm_init().  The code that does it looks like:

   if (ctx->is_ndp16)                                                                                         
        ctx->max_ndp_size = sizeof(struct usb_cdc_ncm_ndp16) +
	                    (ctx->tx_max_datagrams + 1) *
			    sizeof(struct usb_cdc_ncm_dpe16);                                                                                               
    else                                                                                                       
        ctx->max_ndp_size = sizeof(struct usb_cdc_ncm_ndp32) +
	                    (ctx->tx_max_datagrams + 1) *
			    sizeof(struct usb_cdc_ncm_dpe32);  

So this should be the size of the allocation too, right?

Why would the platform ever need to over-ride this?  The platform
can't make the data area smaller since there won't be enough room.  It
could perhaps make it bigger, but the min_t() and clamp_t() macros
will end up choosing the above allocation anyway.

This leaves me feeling a little perplexed.

If there isn't a good reason for over-riding then I could simplify
cdc_ncm_check_tx_max() greatly.

What do *you* think? :)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
