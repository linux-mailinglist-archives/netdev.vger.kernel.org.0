Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A711933324F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCJA1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhCJA1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:27:35 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2E4C06174A;
        Tue,  9 Mar 2021 16:27:34 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d13so24371268edp.4;
        Tue, 09 Mar 2021 16:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZZTGlUumhoxDqrAcSWjyFG+FNXfbOX0ESKJ2jMxsb8c=;
        b=OWcsVydPYra+IWyyzx4umPbw5L1qc1JSRa067RviXdSpEdhvtpr3ORhRH1e36JdqoS
         l5r64fbyERnzpxMs4/TQmreW61v2atdBe6jBelrLC1J5K6b/a2EvtVo+pHeHFl/+JZAL
         XaEG2/mtp8D9DvEJwP9F1po6VtOVPPBPPTkcrn6KWGuQubk6i8M/zhem8JOPTzmWG5tj
         5R8T98WHb/jqyV+/DLjRxhijN5cvbhplr4KYocxKKpTPfD2hKkaCZIyXesniWwTiCsfR
         sMu6o4KocAV23W4abiymGXix5oECKCm8BxDFsyG38THFon11fjCfne1U6Z6XwgJKErlf
         yK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZZTGlUumhoxDqrAcSWjyFG+FNXfbOX0ESKJ2jMxsb8c=;
        b=bkM687DOynDMhAFB9yXrOifyap4g4jLZuLtJunU5/9DtPZdoXeuMs+dHdNZNeMs9j/
         pUUBZB4pL+3+tZl5VZpdybGgj8RQ9xBIZ7TdyxtR1qAFI64b2sW3bJDd7VFn4JAQWgUU
         j1ABCP+uDp+cvE1PDTA+ADwMTtOfjpv+SAXVKJKZngokfS+AS71o/+vZMwDchVGMUNWR
         sJJDjrOLUvsqf/AvboG0DU0vt6HKNP3cVg4OUeAFTwveb2cvZwQy5na/xSqiNaUKbuM8
         3fMWLFLP/BA5htpT9zJXUj4wGAIDSEd7AfGO6xyxG28/GayMp/8Ufg7e+Q1I5r+KmHPb
         9PKA==
X-Gm-Message-State: AOAM531haJG31rWPssCUEPjX3pt2+BJFnmHJkXeno+KF/0LXaqjFQVCl
        24YtDqSSVOSnH/DkiDycxNo=
X-Google-Smtp-Source: ABdhPJwII8G3ryqkrqwOHprbbJMJBD+YXZCJzUxnQHLRRLmfbrxrwsQl3JdDjZfVzG8/JJI0PdKTjw==
X-Received: by 2002:a50:cc4a:: with SMTP id n10mr261137edi.371.1615336053288;
        Tue, 09 Mar 2021 16:27:33 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id b12sm9728374eds.94.2021.03.09.16.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 16:27:32 -0800 (PST)
Date:   Wed, 10 Mar 2021 02:27:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, David.Laight@ACULAB.COM, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
Message-ID: <20210310002731.adinf2sgzeshkjqd@skbuf>
References: <20210309124848.238327-1-elder@linaro.org>
 <bb7608cc-4a83-0e1d-0124-656246ec4a1f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb7608cc-4a83-0e1d-0124-656246ec4a1f@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Tue, Mar 09, 2021 at 05:39:20PM -0600, Alex Elder wrote:
> On 3/9/21 6:48 AM, Alex Elder wrote:
> > Version 3 of this series uses BIT() rather than GENMASK() to define
> > single-bit masks.  It then uses a simple AND (&) operation rather
> > than (e.g.) u8_get_bits() to access such flags.  This was suggested
> > by David Laight and really prefer the result.  With Bjorn's
> > permission I have preserved his Reviewed-by tags on the first five
> > patches.
>
> Nice as all this looks, it doesn't *work*.  I did some very basic
> testing before sending out version 3, but not enough.  (More on
> the problem, below).
>
> 		--> I retract this series <--
>
> I will send out an update (version 4).  But I won't be doing it
> for a few more days.
>
> The problem is that the BIT() flags are defined in host byte
> order.  But the values they're compared against are not always
> (or perhaps, never) in host byte order.
>
> I regret the error, and will do a complete set of testing on
> version 4 before sending it out for review.

I think I understand some of your pain. I had a similar situation trying
to write a driver for hardware with very strange bitfield organization,
and my top priority was actually maintaining a set of bitfield definitions
that could be taken directly from the user manual of said piece of
hardware (and similar to you, I dislike C bitfields). What I came up
with was an entirely new API called packing() which is described here:
https://www.kernel.org/doc/html/latest/core-api/packing.html
It doesn't have any users except code added by me (some in Ethernet fast
paths), and it has some limitations (mainly that it only has support for
u64 CPU words), but on the other hand, it's easy to understand, easy to
use, supports any bit/byte layout under the sun, doesn't suffer from
unaligned memory access issues due to its byte-by-byte approach, and is
completely independent of host endianness.
That said, I'm not completely happy with it because it has slightly
higher overhead compared to typical bitfield accessors. I've been on the
fence about even deleting it, considering that it's been two years since
it's in mainline and it hasn't gained much of a traction. So I would
rather try to work my way around a different API in the sja1105 driver.

Have you noticed this API and decided to not use it for whatever reason?
Could you let me know what that was? Even better, in your quest to fix
the rmnet driver, have you seen any API that is capable of extracting a
bitfield that spans two 64-bit halves of an 128 bit word in a custom bit
layout?
