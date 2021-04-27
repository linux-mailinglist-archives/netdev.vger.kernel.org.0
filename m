Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA836CF44
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 01:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhD0XMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 19:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbhD0XMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 19:12:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED8C061574;
        Tue, 27 Apr 2021 16:11:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h10so71919359edt.13;
        Tue, 27 Apr 2021 16:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8MeAGMfgeHTcQrWCgz7DMd0TFO2Z0W2VrqifAfSumtY=;
        b=YElXGtLO0eaPVfSw7qtth17uaWiS3c0e27OcmZ/qifGI8BGUtgjFYV45BkoTXp6RPw
         Ykzi7Wb+LIJjXb4c08wB+4Q0yUKCWEOJ+THzFtDk4gCLNhAcNCgIEaAhC16E46BIzIST
         9ZyLe43IEyZw5Voy/TRAx7WPi3qxwwCeHZlcPfufanPsrS8dHB4U3OT00c3WERTT+LEb
         ZMmVhqE+tlOj+QCH0krNUq2y7AFQOfnzazCC6RqHWmJO6R4GZpOFS7JP60rFz4RgBBta
         LH9w4WTWc+8GuU0PzyMO1kipFfMZFRe8vvAVm4MN18ttIjtMNq3ol2aaEb7oAwpTLoGz
         W1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8MeAGMfgeHTcQrWCgz7DMd0TFO2Z0W2VrqifAfSumtY=;
        b=gMf6UNkLbE02/fY8WSSZm+EAQPbiuGIJ4BeM00eHKvTKDfiXzyIjUcpADSuhquyBPI
         ytUlTJp11XuavApvjanvSU62wWA/Zc4NkwofR9kNqcEdZWYLeQnwPGRlwMR9e4/t99RW
         8pr1C5MzGpUVtjKCmLaAQBk27fo1KHjFENwrgqH+yX6ukSMqs1n9yBIUXkiOQsjsMscH
         oz8r1+Ir7RN3CEB3vVmxcSMI0CM2xOBQsjJYtvYPbEA3vyz2rnfpqRqAHkmoNEuHnwWg
         GGfw82TEJwOtMoMdbwoiVBnhz+bAG3ozBiKnSp0a/3mCHoaV4wBF1IeNwS6fwzxmPMth
         5tpg==
X-Gm-Message-State: AOAM531o4KHZbNmhTgFyKiD53hee8dF+s4gPi7vXcnx3vd+I5UcSG1ib
        aLldv3SR/tsIsPwCt6uDxrrsGkO4lpc/L7xV9yQ=
X-Google-Smtp-Source: ABdhPJy1gAiGY7j2SqdaeZxWCcUiGKuryp/um0G4op6vO3r/nLkSv2PhTkJ16EnwwSEisg8Rc8OBTbLND1RBmGYd3J4=
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr7183878edw.89.1619565103532;
 Tue, 27 Apr 2021 16:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAMfj=-YEh1ZnLB8zye7i-5Y2S015n0qat+FQ6JW7bFKwBUHBPg@mail.gmail.com>
 <871rax9loz.fsf@kurt>
In-Reply-To: <871rax9loz.fsf@kurt>
From:   Tyler S <tylerjstachecki@gmail.com>
Date:   Tue, 27 Apr 2021 19:11:32 -0400
Message-ID: <CAMfj=-ZzOLog6NQvgpThSOy_5od_dY4KHd0uojxRxaWQA9kKJg@mail.gmail.com>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     alexander.duyck@gmail.com, anthony.l.nguyen@intel.com,
        ast@kernel.org, bigeasy@linutronix.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        ilias.apalodimas@linaro.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, sven.auhagen@voleatech.de,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:15 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> On Sun Apr 25 2021, Tyler S wrote:
> > Thanks for this work; I was having trouble using XDP on my I354 NIC until this.
> >
> > Hopefully I have not err'd backporting it to 5.10 -- but I'm seeing
> > jumbo frames dropped after applying this (though as previously
> > mentioned, non-skb/full driver XDP programs do now work).
> >
> > Looking at the code, I'm not sure why that is.
>
> I'm also not sure, yet.
>
> Can you try with version 3 of this patch [1] and see if there are still
> issues with jumbo frames? Can you also share the backported patch for
> v5.10?
>
> Thanks,
> Kurt
>
> [1] - https://lkml.kernel.org/netdev/20210422052617.17267-1-kurt@linutronix.de/

Sorry, I didn't see v3.  I can confirm that v3 fixes the issue I was
seeing with jumbo frames.

The only part of the patch that differs for 5.10 is the hunk I'll
include inline.  Thanks again for your work!

Cheers,
Tyler
@@ -8720,11 +8716,22 @@ static int igb_clean_rx_irq(struct
igb_q_vector *q_vector, const int budget)
                dma_rmb();

                rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
+               pktbuf = page_address(rx_buffer->page) + rx_buffer->page_offset;
+
+               /* pull rx packet timestamp if available and valid */
+               if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
+                       timestamp = igb_ptp_rx_pktstamp(rx_ring->q_vector,
+                                                       pktbuf);
+
+                       if (timestamp) {
+                               pkt_offset += IGB_TS_HDR_LEN;
+                               size -= IGB_TS_HDR_LEN;
+                       }
+               }

                /* retrieve a buffer from the ring */
                if (!skb) {
-                       xdp.data = page_address(rx_buffer->page) +
-                                  rx_buffer->page_offset;
+                       xdp.data = pktbuf + pkt_offset;
                        xdp.data_meta = xdp.data;
                        xdp.data_hard_start = xdp.data -
                                              igb_rx_offset(rx_ring);
