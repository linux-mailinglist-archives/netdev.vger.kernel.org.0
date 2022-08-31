Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB015A8990
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiHaXnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHaXne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:43:34 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8970CEA14D
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:43:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s11so20357025edd.13
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=f3iGaD9eS+AAXvqS3QIgN+k9G/5dYY8PLniAJGAinP4=;
        b=DCmwNRPsVubwpQsB5SGFkr1Ewxob9VuTGMg1m9Z+Zt2gqLFEImAnxnLtSy7/gtgUG0
         tcvGzhYjuX9XFTztL+k3+PW+OtjlDPofKvPWdnI+dwK6xR8ehQOSVNEWnNagdGvoWwxd
         eCtihGA6vs6hCiGGK19Xtuc75gJs7HAkUOGcISG6XOJ5knJb/4TI4Pxb1MJk6IKeA8et
         70Gr5e4kGh2imUhw5HwuYoMwsNIhO1GuFm29s7vOEEJJV51X2YPBt4N2IWl+HWQeN9qv
         sbOD9/xv8Tt4EF7tcReTMKupogM0IH/+hp/uxfu1e6Cd3aK4cl6siXoVuZjg1KNb+MRT
         2iAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=f3iGaD9eS+AAXvqS3QIgN+k9G/5dYY8PLniAJGAinP4=;
        b=DNbUcS5OPLI2XdFMtzbWyB2qE7MKD9rHT2rgLNcDi3xEJ4ncWYqHi9QaYwgvZQfsmt
         t8IFrs9a88CHJLLu+94+bsyVL9yR8UkLPHIWbjUWtfdMJuTEZRaeqwIRzLmOP0GjZrDx
         lBcczgYQ29wWv+3+JvMlxkeDj419UcqB3WwOFxN6ZSfch3kDkKEGvF18mHA77nxFwj3d
         o2zTQ6NCEXytltMYI4oXna/9QLR3gPJXN8eQ/v1yePbDolJKWGlqK/d5hfb9WuyDrx16
         uxWW6ElwDqOxDSgXn3RZasvud/MrXjnTQZpsSfpPHCUKaRmGdvJ5hL87/GN6KnclN237
         vOFg==
X-Gm-Message-State: ACgBeo3PpK2iKtL5AXN4Gzg2frFu72VpAoExIoQNSIchmIxiXVauzypd
        jpXsne5WiPuQ16pVuWvv25w=
X-Google-Smtp-Source: AA6agR4147WvZ+0G0d9o+Ve84ZJ6beDgNzstYb45kAPYotaXysuAREhdBiPALtEZQcLyQJAdlwzY6A==
X-Received: by 2002:a05:6402:292c:b0:448:353d:1c2b with SMTP id ee44-20020a056402292c00b00448353d1c2bmr17511001edb.232.1661989411936;
        Wed, 31 Aug 2022 16:43:31 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090618a200b0073d71b7527asm7570050ejf.151.2022.08.31.16.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 16:43:31 -0700 (PDT)
Date:   Thu, 1 Sep 2022 02:43:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Message-ID: <20220831234329.w7wnxy4u3e5i6ydl@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf>
 <87v8q8jjgh.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8q8jjgh.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 09:34:22PM +0200, Kurt Kanzenbach wrote:
> I've plugged my hellcreek test device into a Cisco switch and saw these
> messages flying by. It said it failed to get source port 0 at a constant
> rate. Turns out the Cisco switch does RSTP by default. Every STP frame
> received has source port 0 which doesn't make any sense. The switch adds
> a tail tag to every frame towards the CPU. All STP frames have their
> tail tag not really at the end of the frame. It's off by exactly four
> bytes. So, maybe it's the FCS.

Hmm, I'm not sure I'm awake enough to be looking at this. So AFAIU, some
DWMAC versions can be configured to strip the padding and FCS from
"Length" frames (EtherType <= 0x600) via the ACS bit in the MAC
configuration register, and some others can also be configured to strip
the FCS from "Type" frames (EtherType > 0x800) via the CST bit of the
same register. Ok, I'll go with that, although I'm confused as to why
some DWMACs would have ACS but not CST available.

The stmmac driver does not support NETIF_F_RXFCS, so it wants frames
passed up the stack to never have the FCS. That is good. Except that the
frames passed via the RX buffer descriptors may sometimes have RX FCS,
and sometimes may not.

This means that the driver needs to make a determination of whether the
hardware has already stripped the FCS or not, before attempting to strip
the FCS by itself.

So we may have:

(a) FCS stripped by HW, left alone by SW => frame looks ok
(b) FCS stripped by HW and also by SW => frame is truncated by 4 bytes
(c) FCS left alone by HW, left alone by SW => frame has 4 bytes too many (the FCS)
(d) FCS left alone by HW, stripped by SW => frame looks ok

It seems from what you're saying that you're under circumstance (c).

> The DSA master is a older stmmac. It has this code here:
> 
> |drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> |	/* Clear ACS bit because Ethernet switch tagging formats such as
> |	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
> |	 * hardware to truncate packets on reception.
> |	 */
> |	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
> |		value &= ~GMAC_CONTROL_ACS;
> |
> 
> Actually, this has to be done. Without disabling the ACS bit the STP
> frames are truncated and the trailer tag is gone.

So from Florian's comment above, he was under case (b), different than yours.
I don't understand why you say that when ACS is set, "the STP frames are
truncated and the trailer tag is gone". Simply altering the ACS bit
isn't going to change the determination made by stmmac_rx(). My guess
based on the current input I have is that it would work fine for you
(but possibly not for Florian).

> Then, there is
> 
> |drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> |		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
> |		 * Type frames (LLC/LLC-SNAP)
> |		 *
> |		 * llc_snap is never checked in GMAC >= 4, so this ACS
> |		 * feature is always disabled and packets need to be
> |		 * stripped manually.
> |		 */
> |		if (likely(!(status & rx_not_ls)) &&
> |		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
> |		     unlikely(status != llc_snap))) {
> |			if (buf2_len)
> |				buf2_len -= ETH_FCS_LEN;
> |			else
> |				buf1_len -= ETH_FCS_LEN;
> |
> |			len -= ETH_FCS_LEN;
> |		}
> 
> Great. Unfortunately the stmmac used here is a dwmac-3.70. So, the FCS
> doesn't seem to be stripped for the STP frames.

Yes, neither by hardware nor by software.

It isn't stripped by hardware due to the ACS setting. And it isn't
stripped by software because, although the synopsys_id is smaller than 4.00,
there's only a single stmmac_desc_ops :: rx_status implementation which
will ever return "llc_snap" as parse result for a frame, and that isn't
yours.

> Now, I'm currently testing the patch below and it seems to work:
> 
> |root@tsn:~# dmesg | grep -i 'Failed to get source port'
> |root@tsn:~# tcpdump -i lan0 stp
> |tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> |listening on lan0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
> |19:25:17.031699 STP 802.1w, Rapid STP, Flags [Learn, Forward, Agreement], bridge-id 8000.2c:1a:05:28:06:c1.8006, length 36
> 
> Thanks,
> Kurt
> 
> Patch:
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 9c1e19ea6fcd..74f348e27005 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -41,6 +41,7 @@
>  #include <linux/bpf_trace.h>
>  #include <net/pkt_cls.h>
>  #include <net/xdp_sock_drv.h>
> +#include <net/dsa.h>
>  #include "stmmac_ptp.h"
>  #include "stmmac.h"
>  #include "stmmac_xdp.h"
> @@ -5209,6 +5210,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>                  */
>                 if (likely(!(status & rx_not_ls)) &&
>                     (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
> +                    unlikely(netdev_uses_dsa(priv->dev)) ||

This change forces FCS stripping in software for all DWMACs used as DSA
masters.

Florian solved his problem by moving from case (b) to (d), so the change
should continue to work for him as well.

>                      unlikely(status != llc_snap))) {
>                         if (buf2_len)
>                                 buf2_len -= ETH_FCS_LEN;

My 2 cents on this topic are:

1. The software determination is way too complicated and hard to reason
   about, there are too many tests in the fast path, and you are adding
   one more (actually two, if you look at the implementation of netdev_uses_dsa).
   Additionally, someone will probably need to modify the zerocopy rx
   procedure as well, in a not so distant future. It must be taken into
   consideration how much worse would the performance be if the driver
   would just configure the hardware to never selectively strip the FCS
   (i.e. for some packets but not all; in practice this means never
   strip the FCS. Ideally it would *always* strip the FCS, but I'm not
   sure whether this is possible with other hardware pre-4.0).
   Considering that for the common case of IP traffic the FCS is already
   stripped in software, I think there will be a net gain by simplifying
   stmmac_rx() and leaving just the "BD really is last" check.

2. The FCS stripping logic actually looks wrong to me.

			if (buf2_len) {
				buf2_len -= ETH_FCS_LEN;
				len -= ETH_FCS_LEN;
			} else if (buf1_len) {
				buf1_len -= ETH_FCS_LEN;
				len -= ETH_FCS_LEN;
			}

   The "if (x != 0) x -= 4" idiom seems classically wrong, in that x may
   still be < 4, and this will result in a negative buf2_len, or buf1_len.

   Applied to reality, this would mean a scatter/gather frame where the FCS
   is split between 2 buffers. I don't think the driver handles this case
   well at all.

How large can you configure the hellcreek switch to send packets towards
the DSA master? Could you force a packet size (including hellcreek tail tag)
comparable to dma_conf->dma_buf_sz? Or if not, perhaps you could hack
the way in which stmmac_set_bfsize() works, or one of the constants?
