Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569214F8DF5
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiDHFl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 01:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiDHFlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 01:41:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E592C194FE1
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 22:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649396360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IZ7lgdZeZiKpKmhex2GbjuSTe4esituqY0pCR5Ga/NE=;
        b=WFu6gZD0vAFQd+YcmXqFd75pDc4wt+gFtjQOFtO042uWb+P7djJEwel0DSzAkPDHj/HdUm
        beezrd1Jbzq0aWiD35Qa/Ut0ybf4SRzmWkFM2SLn1tK0rziQ6Ss311lZUi6t6NzJnxRCvE
        Zufg4TmGaMgtHnDFDNVqC/LblfbitAg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-xclhPP9vNFaPpnKYCmd2VQ-1; Fri, 08 Apr 2022 01:39:19 -0400
X-MC-Unique: xclhPP9vNFaPpnKYCmd2VQ-1
Received: by mail-qv1-f70.google.com with SMTP id kk17-20020a056214509100b00443cc96b7d5so8543412qvb.16
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 22:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IZ7lgdZeZiKpKmhex2GbjuSTe4esituqY0pCR5Ga/NE=;
        b=AeXGejEdc3e6YWJ+AYk/kXWASVuydbcWDcvvR2KI+yBF3pJAdbJxC20T+luznOip4p
         g7sTB6pfILrLl/5YuTh98yAOYEZAiccG3oTk9MM1yhNI2gLc9dMBeOgAsSFavmVujMW7
         jN5poaK/CFJIu9IdS0RDR2gln8HInZvvReZHkf0eCs9TkNznxXDmJdf6MxTSs1yhJPTw
         csWEA3k1p50S+glPs7WQpcLyGHH24sJSzwYjiJxIFJDtqRs03/bLyTPsCuVSTNjqZ/tb
         rbl3ZzAEGkAw2AVNqqz/G9cGFIoaV/QxogkABtmOt7kmVdiuIdjrRhs+D1tGnzdc/aPc
         PXdg==
X-Gm-Message-State: AOAM5323ybSrVrPAr++ZW3nr7iqbkd7VKpm8lxKAOez6coNFHIzu0tUV
        0PMB3ByBXdcz6KjT4+dt+AsvsIvSBra6XPLk2jbeUEjdnHew1vitzbuNb10BkPnFoX8sv5BjIJ6
        Q95j28IdT4xyRAG7c
X-Received: by 2002:a05:620a:4008:b0:680:9de9:6ecd with SMTP id h8-20020a05620a400800b006809de96ecdmr11906798qko.385.1649396358710;
        Thu, 07 Apr 2022 22:39:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxX1+ghE3EFczgvRq33KUGWGagkx7jyuaqyP77YQfrDLD3SM8i96LFs8tt/6N7bpKy5KsTmdg==
X-Received: by 2002:a05:620a:4008:b0:680:9de9:6ecd with SMTP id h8-20020a05620a400800b006809de96ecdmr11906785qko.385.1649396358418;
        Thu, 07 Apr 2022 22:39:18 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::15])
        by smtp.gmail.com with ESMTPSA id u187-20020a3792c4000000b0067e679cfe5asm13356838qkd.59.2022.04.07.22.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 22:39:17 -0700 (PDT)
Date:   Thu, 7 Apr 2022 22:39:14 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Artem Savkov <asavkov@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] timer: add a function to adjust timeouts to be
 upper bound
Message-ID: <20220408053914.csbplfylubrlkads@treble>
References: <20220407075242.118253-2-asavkov@redhat.com>
 <87zgkwjtq2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zgkwjtq2.ffs@tglx>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 02:37:25AM +0200, Thomas Gleixner wrote:
>  "Make sure TCP keepalive timer does not expire late. Switching to upper
>   bound timers means it can fire off early but in case of keepalive
>   tcp_keepalive_timer() handler checks elapsed time and resets the timer
>   if it was triggered early. This results in timer "cascading" to a
>   higher precision and being just a couple of milliseconds off it's
>   original mark."
> 
> Which reinvents the cascading effect of the original timer wheel just
> with more overhead. Where is the justification for this?
> 
> Is this really true for all the reasons where the keep alive timers are
> armed? I seriously doubt that. Why?
> 
> On the end which waits for the keep alive packet to arrive in time it
> does not matter at all, whether the cutoff is a bit later than defined.
> 
>      So why do you want to let the timer fire early just to rearm it? 
> 
> But it matters a lot on the sender side. If that is late and the other
> end is strict about the timeout then you lost. But does it matter
> whether you send the packet too early? No, it does not matter at all
> because the important point is that you send it _before_ the other side
> decides to give up.
> 
>      So why do you want to let the timer fire precise?
> 
> You are solving the sender side problem by introducing a receiver side
> problem and both suffer from the overhead for no reason.

Here are my thoughts.  Maybe some networking folks can chime in to
keep us honest.

I get most of what you're saying, though my understanding is that
keepalive is only involved in sending packets, not receiving them.  I do
think there would be two opposing use cases:

  1) Client sending packets to prevent server disconnects

  2) Server sending packets to detect client disconnects

For #1, it's ok for the timer to pop early.  For #2, it's ok for it to
pop late.  So my conclusion is about the same as your sender/receiver
scenario: there are two sides to the same coin.

If we assume both use cases are valid (which I'm not entirely convinced
of), doesn't that mean that the keepalive timer needs to be precise?

Otherwise we're going to have broken expectations in one direction or
the other, depending on the use case.

> Aside of the theoerical issue why this matters at all I have yet ot see
> a reasonable argument what the practical problen is. If this would be a
> real problem in the wild then why haven't we ssen a reassonable bug
> report within 6 years?

Good question.  At least part of the answer *might* be that enterprise
kernels tend to be adopted very slowly.  This issue was reported on RHEL
8.3 which is a 4.18 based kernel:

  The time that the 1st TCP keepalive probe is sent can be configured by
  the "net.ipv4.tcp_keepalive_time" sysctl or by setsockopt(). 

  We observe that if that value is set to 300 seconds, the timer
  actually fires around 15-20 seconds later. So ~317 seconds. The larger
  the expiration time the greater the delay. So for the default of 2
  hours it can be delayed by minutes. This is causing problems for some
  customers that rely on the TCP keepalive timer to keep entries active
  in firewalls and expect it to be accurate as TCP keepalive values have
  to correspond to the firewall settings. 

-- 
Josh

