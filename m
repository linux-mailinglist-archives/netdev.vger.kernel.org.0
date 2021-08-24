Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05F3F5FD5
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbhHXOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhHXOG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:06:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B433CC061757;
        Tue, 24 Aug 2021 07:05:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so1896206pjb.0;
        Tue, 24 Aug 2021 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BdtL4BgokjgujApJ06tQSXQaIiFk2bqrpHTm5UuiXVg=;
        b=DnSSy2sCW4l8HMb5J0ljKo0yiqzEUo/COydY729551qsxQcw1C7UqW4AGxI19Inxpp
         hxp+ZzvTwXWAz/4LZrrMo08CJIhpQi4eMYaPh51mTwOy1guaKQLZzNO5uPCi3vSqKA6B
         7IN9+sN84HZgSZOChdqxtkw39Cb3zZDiI2/Kq5J8I4pi4fyN7h2ic9eHPRBhgbQfEEYv
         3mfWiK8FxUhHIg0i2dBCyk3Ihg4Ac+hUuTjdl3pnbXkNBjDX6S/niPHC3MFC9ReHN5E0
         0hQWD8RBCWbgSgqwE1laG4BpgWuAqU5Qk5wTF1LFMfWFWmmodebzwS8RHlg5QC24DBVg
         dEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BdtL4BgokjgujApJ06tQSXQaIiFk2bqrpHTm5UuiXVg=;
        b=VgALX1hhzEvhcGNwNlJy+aWUDyLSqzw1hEKuTR4MSZ17sTZ+kf/9kkTQFatW7ubAKd
         FGIOFlW9Cd9YQ7v4tRGOGYoaI928UQWsikBsTLZLAAgNKBbuVH3U1BueHBr5e61/ZC5z
         Ez2CqEvtJUfVBZI8Hx4MGuc1nGd4FVbJgP3dVFyUi0djb04WtnxAEwPssbdD73RFH+X+
         T538V0jq28o+sb/CAAnWPGcLrXE4hYqhjhd2MTwzFDdnZX/tZips1xyJIu1EeSIKPXHw
         XAwNJ8ILLLch8eHkpdosceKeDQJjHbrJ4a12K99EtlyVxBEr3NGBbpwvdoAigD1Wsbrd
         KqxQ==
X-Gm-Message-State: AOAM530qpyzQxeJRA+pMYzZx/AT8WT/A+7GSLjRitZxjeAGsaMLc9Lf/
        jglkk9l1lzpdV1HBtFWv9hQ=
X-Google-Smtp-Source: ABdhPJzCA4TGdP0RxqYe87RtOsdJBuEI/1t/V2fnwfkQL88ttw1AkX+kEDsHve9owb5Zlw8/2bvNaA==
X-Received: by 2002:a17:902:6b49:b0:136:3f21:7a9 with SMTP id g9-20020a1709026b4900b001363f2107a9mr3173720plt.81.1629813945290;
        Tue, 24 Aug 2021 07:05:45 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ml5sm2710652pjb.4.2021.08.24.07.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 07:05:44 -0700 (PDT)
Date:   Tue, 24 Aug 2021 07:05:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, andrei.pistirica@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [RFC PATCH] net: macb: Process tx timestamp only on ptp packets
Message-ID: <20210824140542.GA17195@hoboy.vegasvil.org>
References: <20210824101238.21105-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824101238.21105-1-harini.katakam@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 03:42:38PM +0530, Harini Katakam wrote:
> The current implementation timestamps all packets and also processes
> the BD timestamp for the same. While it is true that HWTSTAMP_TX_ON
> enables timestamps for outgoing packets, the sender of the packet
> i.e. linuxptp enables timestamp for PTP or PTP event packets. Cadence
> GEM IP has a provision to enable this in HW only for PTP packets.
> Enable this option in DMA BD settings register to decrease overhead.

NAK, because the HWTSTAMP_TX_ON means to time stamp any frame marked
by user space, not just PTP frames.

This patch does not "decrease overhead" because the code tests whether
time stamping was request per packet:

drivers/net/ethernet/cadence/macb_main.c line 1202

	if (unlikely(skb_shinfo(skb)->tx_flags &
		     SKBTX_HW_TSTAMP) &&
	    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
		...
	}

Thanks,
Richard
