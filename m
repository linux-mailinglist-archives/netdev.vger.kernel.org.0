Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B483A4D05C0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbiCGRz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244269AbiCGRzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:55:25 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FFE6E8C5
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:54:30 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id r2so806330iod.9
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 09:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDf6OjoGPyJFhKapx4AyJRciN9H+36Y+6ggWjNUCgGw=;
        b=g5jEDTH2Zh18u2j4X+lLYWA+YuQJpE+IJ4979dqdtHTSLL/btX97xt6ROOfdORrWuu
         CjOIxhvZuctZbKY05G5P/mfjIAuCvP+T/Vty0DcYkFDiNBUZElk84vP3z38P1+C2dqkM
         soYX5d3VOGJoyhDqKD8DUXsTzL0Wa9BwjLKm4SGO3DIOZJAyGGQbUSSQ2rFTlM5e0bjR
         F1ZJfVyDYwFmZTOHGp/nIsRSZcup86yf/6yLQzyKHhbxRTc2a165J6jnGZ9WCR6GAmhI
         UjEZlFP46A12rojsHUDpLiCfbQsyqyLFqmABHSLGpGxFrRVoh2eWma1F0zE0Z/vrlyDX
         0qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDf6OjoGPyJFhKapx4AyJRciN9H+36Y+6ggWjNUCgGw=;
        b=0YrxXTr/xwDTlaM13Gyyva6VILp4dWO5wjHsDW0bhWuX1JJIWyvGShmQlYo4fIiq6x
         Yn1f4fkrQZJ9X4fVpcZXaaZIsPLYvjtDhL2/RqZOBz4H17vhi405vTX1sa2jfpUO39jj
         3ylWBl0bn7HkRWR4FM0Y8ChWpKcvijGzfobXdfMfQzYMxvTQuIoxHO81Pxe4Y9Elt/2l
         T8c738dH7Tm6gkmfQ3HoF/9Q5rP4S2E89WAgFD9ug0uU8HfyYgnei7ZDGgvz1LqvZ/Qh
         edki1Pi58O4/HWH/iR5Sj4OR98j+OWRRGy6FDbpJ+KX/PuDmxeU+CrohSCy+TVFfJpHa
         qAiQ==
X-Gm-Message-State: AOAM531hSzBQCh0NiMpi5kxhcT0PKdLyjmrVXzDPnYFH+jgxya/6kA3u
        n3MBXP37T5qW6RbTrMXpWo3NNbtIeV58lSnXcup1Ew==
X-Google-Smtp-Source: ABdhPJwWcq/DGO0V+gbpxEQ7JyV6d6TvrmREbZzE8zvJ5h3Jnn+ry33BRxn5nDmpxOYUnXyx7iNzaGfKdh6ZGc17UWk=
X-Received: by 2002:a02:95cc:0:b0:315:d2b:4412 with SMTP id
 b70-20020a0295cc000000b003150d2b4412mr11104222jai.259.1646675669518; Mon, 07
 Mar 2022 09:54:29 -0800 (PST)
MIME-Version: 1.0
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org> <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org> <20220307143440.GC29247@hoboy.vegasvil.org>
In-Reply-To: <20220307143440.GC29247@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Mon, 7 Mar 2022 18:54:19 +0100
Message-ID: <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > How can I cover my use case with the existing API? I had no idea so far.
> >
> > Okay, so 2 PHCs doesn't help, but still all you need is:
> >
> > 1. a different method to convert time stamps to vclock time base
> >
> > 2. a different method for vclocks' gettime
> >
> > So let me suggest a much smaller change to the phc/vclock api... stay tuned
>
> For #1:
>
> On the receive path, the stack calls ptp_convert_timestamp() if the
> socket has the SOF_TIMESTAMPING_RAW_HARDWARE option.  In that method,
> you need only get the raw cycle count if supported by the pclock.
>
> So instead of:
>
>         vclock = info_to_vclock(ptp->info);
>
>         ns = ktime_to_ns(hwtstamps->hwtstamp);
>
>         spin_lock_irqsave(&vclock->lock, flags);
>         ns = timecounter_cyc2time(&vclock->tc, ns);
>         spin_unlock_irqrestore(&vclock->lock, flags);
>
> something like this:
>
>         vclock = info_to_vclock(ptp->info);
>
>         cycles = pclock->ktime_to_cycles(hwtstamps->hwtstamp);
>
>         spin_lock_irqsave(&vclock->lock, flags);
>         ns = timecounter_cyc2time(&vclock->tc, cycles);
>         spin_unlock_irqrestore(&vclock->lock, flags);
>
> This new class method, ktime_to_cycles, can simply do ktime_to_ns() by
> default for all of the existing drivers, but your special driver can
> look up the hwtstamp in a cache of {hwtstamp, cycles} pairs.

ktime_to_cycles uses hwtstamp as key for the cache lookup. As long as
the PHC is monotonic, the key is unique. If the time of the PHC is set, then
the cache would be invalidated. I'm afraid that setting the PHC could lead to
wrong or missing timestamps. Setting the PHC in hardware, timestamp
generation in hardware, and cache invalidation in software would need to
be synchronized somehow.

Practically the PHC should be set only once. It would be also ok to use
vclocks for PTP after PHC has been set. So it should work. But it would
not be the generic PHC/vclock user space interface anymore.

> (No need to bloat skbuff by another eight bytes!)

I understand that bloating skbuff shall be prevented. Actually I need
to find a way
to generate the correct timestamp within ptp_convert_timestamp and without
bloating skbuff. The cache is one possibility. What do you think about the
following idea?

For TX it is known which timestamp is required. So I would have to find a way
to detect which timestamp shall be filled into hwtstamp.

For RX both timestamps are already available within skbuff, because they are
stored in front of the Ethernet header by the hardware. So I have to find a way
to detect the RX case and copy the right timestamp to hwtstamp.

This would prevent the cache and does not bloat skbuff.

> For #2:
>
> Similarly, add a new class method, say, pclock.get_cycles that does
>
>         if (ptp->info->gettimex64)
>                 ptp->info->gettimex64(ptp->info, &ts, NULL);
>         else
>                 ptp->info->gettime64(ptp->info, &ts);
>
> by default, but in your driver will read the special counter.

Looks better than my getfreeruntimex64.

Thanks for your suggestion!

Gerhard
