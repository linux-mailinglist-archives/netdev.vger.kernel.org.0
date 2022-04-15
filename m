Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABA8502D85
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbiDOQMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiDOQMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:12:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD0C54BC0;
        Fri, 15 Apr 2022 09:09:49 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bh17so16071817ejb.8;
        Fri, 15 Apr 2022 09:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6JlZxxiGZmb0vqOcZsu5IsnR52qMrk0jyITxfKKhTco=;
        b=ZC9/kPycUbLVZRiAXRkwqNrNDGebavEbbYo5zoquTTe8CUdFIuOuh7OpF0fyzjvyOv
         IhaYsgXw09+YNa/uIJEindg/poz+JCpYHr05EqBb3dgH/+0nUyErqm/WDknhPQvW75cO
         07g7R+Luz06xCjJlXDK9+gw77E04PzYBy01Om8qBxuFo7hzuI1XtuP5Icjkv8MXU/J98
         bQBc47KRo+sm4EctOyweVjxV/MOcQ0NqoClrITE0Mf7rcCMsddtKBWXsatWSlsk8btjW
         wXDonlCwRAVjC/5lGeG7OGHiyLp+//79gdxbgezb9f2FpRDykUXzlKX4WD0OIEfwmeby
         4h+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6JlZxxiGZmb0vqOcZsu5IsnR52qMrk0jyITxfKKhTco=;
        b=PIb5ycJC/We3rrjqXCOxunPx2uohqCjGLg+DtoPz1ColzutBAgvBJgb0uK30xXIzin
         rC/HzXprEH5MDgxLO0CkYFZnXalTNa232+tA50oDalaWLnZoUlH3e4SAIc/heY1qOOWA
         vL9ElYFkLw0HrGuUimCSyXkLhkZnn3ia7Kz7NsC+4y6fEILa1aLPad2fXFnUoAYCUsKs
         ok0/r0awJ5YkaugRiu61p38qPjk2PtGA0x0KtO98OKv7nslpyh2zhJjG96/S5yaBHopM
         VCL+ti9SUIHM0wieeauxBtk0EF66kQyNfCFasZ+UUhgwd5HtBRw2CSOsgUI8c8bcrmvJ
         SSUg==
X-Gm-Message-State: AOAM531fwJvL5EeUzkCyKZo3tpDUqu83Pbj/sdE9v47vCXWpdPSdLAfw
        tQ9F9Rm1F9+BxFQFdAz4l5w=
X-Google-Smtp-Source: ABdhPJwMtLoWL3yAxfLe9BEEngeq0PxdbYXpFZIgqysx3T6d8CKldRdbn9SfEIwN6GiN102YjKLX0g==
X-Received: by 2002:a17:907:d90:b0:6eb:557e:91e6 with SMTP id go16-20020a1709070d9000b006eb557e91e6mr6658502ejc.376.1650038987627;
        Fri, 15 Apr 2022 09:09:47 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm1851869ejb.143.2022.04.15.09.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:09:46 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:09:40 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Message-ID: <20220415160940.GA47428@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-2-parri.andrea@gmail.com>
 <PH0PR21MB3025FA1943D74A31E47B7F8FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415064133.GA2961@anparri>
 <PH0PR21MB3025F31739A0480F66639ACAD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB3025F31739A0480F66639ACAD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 02:27:37PM +0000, Michael Kelley (LINUX) wrote:
> From: Andrea Parri <parri.andrea@gmail.com> Sent: Thursday, April 14, 2022 11:42 PM
> > 
> > On Fri, Apr 15, 2022 at 03:33:23AM +0000, Michael Kelley (LINUX) wrote:
> > > From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, April 13,
> > 2022 1:48 PM
> > > >
> > > > The function returns NULL if the ring buffer has no enough space
> > > > available for a packet descriptor.  The ring buffer's write_index
> > >
> > > The first sentence wording is a bit scrambled.  I think you mean the
> > > ring buffer doesn't contain enough readable bytes to constitute a
> > > packet descriptor.
> > 
> > Indeed, replaced with your working.
> > 
> > 
> > > > is in memory which is shared with the Hyper-V host, its value is
> > > > thus subject to being changed at any time.
> > >
> > > This second sentence is true, but I'm not making the connection
> > > with the code change below.   Evidently, there is some previous
> > > check made to ensure that enough bytes are available to be
> > > received when hvs_stream_dequeue() is called, so we assumed that
> > > NULL could never be returned?  I looked but didn't find such a check,
> > > so maybe I didn't look carefully enough.  But now we are assuming
> > > that Hyper-V might have invalidated that previous check by
> > > subsequently changing the write_index in a bogus way?  So now, NULL
> > > could be returned when previously we assumed it couldn't.
> > 
> > I think you're looking for hvs_stream_has_data().  (Previous checks
> > apart, hvs_stream_dequeue() will "dereference" the pointer so...)
> 
> Agreed.  I didn't say this explicitly, but I was wondering about the risk
> in the current code (without these hardening patches) of getting a
> NULL pointer from hv_pkt_iter_first_raw(), and then dereferencing it.

Got it.  Updated the changelog to:

  "The ring buffer's write_index is in memory which is shared with the
   Hyper-V host, an erroneous or malicious host could thus change its
   value and overturn the result of hvs_stream_has_data()."

Hopefully this can clarify the issue (without introducing other typos).

Thanks,
  Andrea
