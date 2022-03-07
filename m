Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A414D0168
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243264AbiCGOfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243259AbiCGOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:35:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31817D01F
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 06:34:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so7517371pjb.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 06:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ssk11GQ5fz5EUo/3PztWcue0Na9oI56qydLjndfE+CY=;
        b=hPYAr6P6Jei89ZK1rXIlqdL0GedWAyoYsxGHFhUGSxSTqicWtYSeUUOrIKDx/y7RxA
         VCDyOhlwLACW/ffQVsUlOsY5GrBENolGeO63jyrA+qmUdQ5WaWCHxyDXi4XDCFdexH7Y
         C5M6ORCZZCS2ve4WVLJrRi4/IcWTqdSGM7rLxtgEqgF5YZdBa1FkUQS7Fc7ujfB6lmo9
         DdrP04K7CyMIKhTbX+SyJul7TtKgxVOGWcR5Ek9fDa4Eodj4sihV7ikDXqkDetnquxB1
         5Ly+YafZkKRTp8jynmTt3B61qWEMY34gaLVbnOn+V/nI1aVKxiAauaHMHv5mutqSdut4
         0rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ssk11GQ5fz5EUo/3PztWcue0Na9oI56qydLjndfE+CY=;
        b=jEHqePIzH0HrlfNm/kJYh90vf1gxw57rqscy0yEinSjVWX4smDZjyeXOdnUjVhsFEv
         nBq1pInj7ZYcaDzz9TbSQ2yatGXfFf8W6bT3PPSs9K98g/TRo9U0jIsbiv2k1DP4HMro
         l/7PYAXFYCg1KBdSaKUnl9ooCG5duK86AnAYz7WD7gLxZDSHk13qMUyc+OK+MGGBmkgm
         C80W9t4jAkXK5O1TIWWrFCKDIfd3Rne4KmLZXL3p2axMQH/CsuCRx8/uPjKuIz49Vtyp
         dpszb49/r4hiSG8EkIqSvW+NCd/cDzgUlEhzTJYpm3eanuomJ1OmVg4VZwxP2zHixLcg
         HQ0g==
X-Gm-Message-State: AOAM530wyA4bvSGTa+JZ7tm6UXfjWAXeIQJe0klgq2vY+TGegQYOv3Oi
        5s662gymAcHXMoBvIuaS5v0=
X-Google-Smtp-Source: ABdhPJwoAa2qNgvYovQUIVbOGzL9WNywkK+cBiONEiJ4P7NPDTauPqYr19K8rLCIWyqkaW3IByRAdA==
X-Received: by 2002:a17:90b:4a8f:b0:1bf:e03:dc15 with SMTP id lp15-20020a17090b4a8f00b001bf0e03dc15mr13436954pjb.65.1646663683445;
        Mon, 07 Mar 2022 06:34:43 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nu4-20020a17090b1b0400b001bf497a9324sm6231114pjb.31.2022.03.07.06.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:34:42 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:34:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220307143440.GC29247@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306215032.GA10311@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 01:50:32PM -0800, Richard Cochran wrote:
> On Sun, Mar 06, 2022 at 07:38:55PM +0100, Gerhard Engleder wrote:
> > How can I cover my use case with the existing API? I had no idea so far.
> 
> Okay, so 2 PHCs doesn't help, but still all you need is:
> 
> 1. a different method to convert time stamps to vclock time base
> 
> 2. a different method for vclocks' gettime
> 
> So let me suggest a much smaller change to the phc/vclock api... stay tuned

For #1:

On the receive path, the stack calls ptp_convert_timestamp() if the
socket has the SOF_TIMESTAMPING_RAW_HARDWARE option.  In that method,
you need only get the raw cycle count if supported by the pclock.

So instead of:

	vclock = info_to_vclock(ptp->info);

	ns = ktime_to_ns(hwtstamps->hwtstamp);

	spin_lock_irqsave(&vclock->lock, flags);
	ns = timecounter_cyc2time(&vclock->tc, ns);
	spin_unlock_irqrestore(&vclock->lock, flags);

something like this:

	vclock = info_to_vclock(ptp->info);

	cycles = pclock->ktime_to_cycles(hwtstamps->hwtstamp);

	spin_lock_irqsave(&vclock->lock, flags);
	ns = timecounter_cyc2time(&vclock->tc, cycles);
	spin_unlock_irqrestore(&vclock->lock, flags);

This new class method, ktime_to_cycles, can simply do ktime_to_ns() by
default for all of the existing drivers, but your special driver can
look up the hwtstamp in a cache of {hwtstamp, cycles} pairs.

(No need to bloat skbuff by another eight bytes!)

For #2:

Similarly, add a new class method, say, pclock.get_cycles that does

	if (ptp->info->gettimex64)
		ptp->info->gettimex64(ptp->info, &ts, NULL);
	else
		ptp->info->gettime64(ptp->info, &ts);

by default, but in your driver will read the special counter.

Thanks,
Richard
