Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C442E246849
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgHQOWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgHQOW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 10:22:28 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99F8C061389;
        Mon, 17 Aug 2020 07:22:27 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s23so12463476qtq.12;
        Mon, 17 Aug 2020 07:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xq6UJuf5AUIsCrnDr2pNUpuRPwGDZHFPckC6KbsKne8=;
        b=rut2/04MKXnpJsaH2P1q8fZ8/7h0+MUlFVjQ5XH+zUjGwDW9gInJAnxQu34xpnbcmh
         NJXm5tHxDanATsM5lp6jOmTLvpCcKKu+YTpoCHQpCQXGE5cco4IzE+51ztd1hmIbPHkd
         nMm/+14MJSQvxtF1PjOWXjT4tqFU3URHF/Brx9wXlfDWhLtrmdg5FTnnve2ZO/id/cBB
         Xzhl2gE6UNlnxei9M8G9Gc24eIPttyqFWde65w5Sr22DkBHtWuWDLZGy4vN4gyI5FNnT
         hiMdWMzWtD4LwQSMgGIWKIWOL/98zGsaa+DJDK4SPKUsgNSfiiG6eau8zIKbiy70Dsk9
         TrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xq6UJuf5AUIsCrnDr2pNUpuRPwGDZHFPckC6KbsKne8=;
        b=CO8DlOiPTqqlPxJAGtD7M11G3wlngCPkxsSGXRBGhIBmx1WP39FZ60mrQTB60XV4cr
         DUQ6ZKpfOT2AGijcMXT6wn2yoQ5s+kntdWF8oHwEMULqTSDSgB3t1xbwqktZ25LV+CjQ
         dM+rKKP3X8zsucoK9K6s6jWH+e7F1WXt3sM26quRR0jtLg94KN/ofuwcZlTC38WMPuBL
         gQH7oQqevV7ZQSnzImuB2BomFiEHgMF4ymyJiVZnsgkaGcVHFrbB5HHAkD5euE8jmx8b
         lf5/FUVIbVsDjEvnfFAn7Su6vI7vk2tyU8zEDs/OfZrbW4zOe2ftSPaBAGphwGRTGznS
         puWA==
X-Gm-Message-State: AOAM533l4n7j67UOvKQI2D+S9Dwjtg+BX2PgEVcvC11p2opj741D2JJM
        qVn7HRk/f0frt/Cvh5BpMkrOr6igMDzV/g==
X-Google-Smtp-Source: ABdhPJwliazj5q10dSLSJV0Dl/ELLVnb322v2BArNI0YCxOKVzoyVzcUHEgPKX2z526KcoqljMv0yg==
X-Received: by 2002:aed:3102:: with SMTP id 2mr12609589qtg.212.1597674146845;
        Mon, 17 Aug 2020 07:22:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:8002:1323:e13e:9d76:7bc8])
        by smtp.gmail.com with ESMTPSA id o2sm17336842qkh.102.2020.08.17.07.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 07:22:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C1A6CC0BEB; Mon, 17 Aug 2020 11:22:23 -0300 (-03)
Date:   Mon, 17 Aug 2020 11:22:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: sctp: num_ostreams and max_instreams negotiation
Message-ID: <20200817142223.GH3399@localhost.localdomain>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
 <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 02:49:31PM +0000, David Laight wrote:
> From: David Laight
> > Sent: 14 August 2020 17:18
> > 
> > > > > At some point the negotiation of the number of SCTP streams
> > > > > seems to have got broken.
> > > > > I've definitely tested it in the past (probably 10 years ago!)
> > > > > but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
> > > > > returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
> > > > > rather than the smaller of that value and that configured
> > > > > at the other end of the connection.
> > > > >
> > > > > I'll do a bit of digging.
> > > >
> > > > I can't find the code that processes the init_ack.
> > > > But when sctp_procss_int() saves the smaller value
> > > > in asoc->c.sinint_max_ostreams.
> > > >
> > > > But afe899962ee079 (if I've typed it right) changed
> > > > the values SCTP_INFO reported.
> > > > Apparantly adding 'sctp reconfig' had changed things.
> > > >
> > > > So I suspect this has all been broken for over 3 years.
> > >
> > > It looks like the changes that broke it went into 4.11.
> > > I've just checked a 3.8 kernel and that negotiates the
> > > values down in both directions.
> > >
> > > I don't have any kernels lurking between 3.8 and 4.15.
> > > (Yes, I could build one, but it doesn't really help.)
> > 
> > Ok, bug located - pretty obvious really.
> > net/sctp/stream. has the following code:
> > 
> > static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> > 				 gfp_t gfp)
> > {
> > 	int ret;
> > 
> > 	if (outcnt <= stream->outcnt)
> > 		return 0;
> 
> Deleting this check is sufficient to fix the code.
> Along with the equivalent check in sctp_stream-alloc_in().

2075e50caf5e has:

-       if (outcnt > stream->outcnt)
-               fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
+       if (outcnt <= stream->outcnt)
+               return 0;

-       stream->out = out;
+       ret = genradix_prealloc(&stream->out, outcnt, gfp);
+       if (ret)
+               return ret;

+       stream->outcnt = outcnt;
        return 0;

The flip on the if() return missed that stream->outcnt needs to be
updated later on even if it is reducing the size.

The proper fix here is to move back to the original if() condition,
and put genradix_prealloc() inside it again, as was fa_zero() before.
The if() is not strictly needed, because genradix_prealloc() will
handle it nicely, but it's a nice-to-have optimization anyway.

Do you want to send a patch?

> 
> 
> > This does mean that it has only been broken since the 5.1
> > merge window.
> 
> And is a good candidate for the back-ports.

Yep.

> 
> > 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> > 	if (ret)
> > 		return ret;
> > 
> > 	stream->outcnt = outcnt;
> > 	return 0;
> > }
> > 
> > sctp_stream_alloc_in() is the same.
> > 
> > This is called to reduce the number of streams.
> > But in that case it does nothing at all.
> > 
> > Which means that the 'convert to genradix' change broke it.
> > Tag 2075e50caf5ea.
> > 
> > I don't know what 'genradix' arrays or the earlier 'flex_array'
> > actually look like.
> > But if 'genradix' is some kind of radix-tree it is probably the
> > wrong beast for SCTP streams.
> > Lots of code loops through all of them.
> 
> Yep, I'm pretty sure a kvmalloc() would be best.

kvmalloc() doesn't help here because these functions can be called
form bh. Note how sctp_process_strreset_addstrm_in(), for example,
needs to use GFP_ATOMIC in there, in which kvmalloc() can't fallback
to vmalloc.

> 
> > While just assigning to stream->outcnt when the value
> > is reduced will fix the negotiation, I've no idea
> > what side-effects that has.
> 
> I've done some checks.
> The arrays are allocated when an INIT is sent and also before
> a received INIT is processed.
> So if one side (eg the responder) allocates a very big value
> then the associated memory is never freed when the value
> is negotiated down.
> There is a comment to the effect that this is desirable.
> 
> If my quick calculations are correct then each 'in' is 20 bytes
> and each 'out' 24 (with a lot of pad bytes).
> So the max sizes are 322 and 386 4k pages.
> 
> I haven't looked at how many of the 'out' streams gets the
> extra, separately allocated, structure.
> I suspect the memory footprint for a single SCTP connection
> is potentially huge.

This shouldn't be an issue. The default amount of out streams is low
(10, SCTP_DEFAULT_OUTSTREAMS) and the 'in' ones are only allocated
when we have such info already. That's why sctp_connect_new_asoc() and
sctp_association_init() will pass incnt=0 for sctp_stream_init().

  Marcelo
