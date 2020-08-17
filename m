Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4CE24687D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgHQOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgHQOf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 10:35:59 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ACCC061389;
        Mon, 17 Aug 2020 07:35:59 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t6so7884569qvw.1;
        Mon, 17 Aug 2020 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Awq8Z6iR2eZTopjDGiDMsFnrbo3ecIwvq5riYa5nn98=;
        b=Kacuz5NB4ZHv0x0SvcGFSNYJZBRkOf/tz1VJRhEVQSKIk+MSs05QZE+4cgpQt/+Ywv
         ceiDvsFGbbkgFhT2e5UuOz0NZcFrSLwKTljM6PLarQEOtMyrN16c4p1If5ZCwGnHa3Cj
         /WOVx0ou1GKA6c6QMksXS0tx/dOuQgAL/dwGzw2Iz8JkslEJlRC96pNrICg9RGCTJLfh
         yHMHHeOhGUkU6/knhzRgvsjhZMnhqtK6JUcWVrcd4qvY7Z4tgNODZShHnd902XYs2ZNU
         MpeUBtcIH0b5mi3kPMDriwmlJ/8IYrhFTQ/fUhcHEF1sKLz6d+b/TR0BM3ysL2HymXhm
         UVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Awq8Z6iR2eZTopjDGiDMsFnrbo3ecIwvq5riYa5nn98=;
        b=aE9EctByqswIhswqBTPL3xAaq/woNSgCam8o+5gYKhlma/kQYJ3vae6BlHKz+DTfGn
         k9LSLdS6niRZKe9GBQJcPxpgQs9vTmIbkJ5TKuRNZeCgmOMSieq9n3NSylQQqfdjHv/9
         sMvxPN+fWCDEhx6jza5CIQbcbi1AJe8WJBaU4y2hx/a8aOfVSnI6l5qv2vuaHNM5VyIP
         92wmSYVYf9S1e7KYCyj2JsA4i0RCxxhVZYMCvbYTTWFeSnUzuB+R8ButVJNRgQfa4KBs
         HmaZoIiu1bqfBcrPPB3useKPcfkcmezgmUb+ydJmn0FMTmBCax2qoXy22f8z3zEY8TDz
         4PfA==
X-Gm-Message-State: AOAM532K4vyXBWxqlieUaSG7En2Q/SwVmU/tw6duxPv7fjnE1ShSwpb1
        OxQT+I/ck+N2zf4a79xjqIs=
X-Google-Smtp-Source: ABdhPJwq2e2Y19lzO5cQJHDiD0cKY1Mt/bf2o2I/dmY9f3fNigrUgxFsDraAmWvywiVHrubcOitzPw==
X-Received: by 2002:ad4:442d:: with SMTP id e13mr14751791qvt.81.1597674957555;
        Mon, 17 Aug 2020 07:35:57 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.86])
        by smtp.gmail.com with ESMTPSA id c70sm17616071qke.109.2020.08.17.07.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 07:35:56 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 95075C0BEB; Mon, 17 Aug 2020 11:35:54 -0300 (-03)
Date:   Mon, 17 Aug 2020 11:35:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: sctp: num_ostreams and max_instreams negotiation
Message-ID: <20200817143554.GI3399@localhost.localdomain>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
 <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
 <20200817142223.GH3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817142223.GH3399@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 11:22:23AM -0300, Marcelo Ricardo Leitner wrote:
> On Sat, Aug 15, 2020 at 02:49:31PM +0000, David Laight wrote:
> > From: David Laight
> > > Sent: 14 August 2020 17:18
> > > 
> > > > > > At some point the negotiation of the number of SCTP streams
> > > > > > seems to have got broken.
> > > > > > I've definitely tested it in the past (probably 10 years ago!)
> > > > > > but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
> > > > > > returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
> > > > > > rather than the smaller of that value and that configured
> > > > > > at the other end of the connection.
> > > > > >
> > > > > > I'll do a bit of digging.
> > > > >
> > > > > I can't find the code that processes the init_ack.
> > > > > But when sctp_procss_int() saves the smaller value
> > > > > in asoc->c.sinint_max_ostreams.
> > > > >
> > > > > But afe899962ee079 (if I've typed it right) changed
> > > > > the values SCTP_INFO reported.
> > > > > Apparantly adding 'sctp reconfig' had changed things.
> > > > >
> > > > > So I suspect this has all been broken for over 3 years.
> > > >
> > > > It looks like the changes that broke it went into 4.11.
> > > > I've just checked a 3.8 kernel and that negotiates the
> > > > values down in both directions.
> > > >
> > > > I don't have any kernels lurking between 3.8 and 4.15.
> > > > (Yes, I could build one, but it doesn't really help.)
> > > 
> > > Ok, bug located - pretty obvious really.
> > > net/sctp/stream. has the following code:
> > > 
> > > static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> > > 				 gfp_t gfp)
> > > {
> > > 	int ret;
> > > 
> > > 	if (outcnt <= stream->outcnt)
> > > 		return 0;
> > 
> > Deleting this check is sufficient to fix the code.
> > Along with the equivalent check in sctp_stream-alloc_in().
> 
> 2075e50caf5e has:
> 
> -       if (outcnt > stream->outcnt)
> -               fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
> +       if (outcnt <= stream->outcnt)
> +               return 0;
> 
> -       stream->out = out;
> +       ret = genradix_prealloc(&stream->out, outcnt, gfp);
> +       if (ret)
> +               return ret;
> 
> +       stream->outcnt = outcnt;
>         return 0;
> 
> The flip on the if() return missed that stream->outcnt needs to be
> updated later on even if it is reducing the size.
> 
> The proper fix here is to move back to the original if() condition,
> and put genradix_prealloc() inside it again, as was fa_zero() before.
> The if() is not strictly needed, because genradix_prealloc() will
> handle it nicely, but it's a nice-to-have optimization anyway.
> 
> Do you want to send a patch?

Note the thread 'Subject: RE: v5.3.12 SCTP Stream Negotiation Problem'
though.

  Marcelo
