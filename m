Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20D1CD149
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgEKFeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgEKFeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 01:34:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E28C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 22:34:01 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so2730094wmd.0
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 22:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXW3upB1ZZMV2jZFkfjSF6rS0fu0dx5/uaDft0i8oJA=;
        b=vVRz0IsSwuCc+qTKLWJXsL0RpUAUtQeeMmHfTs+7DotrrmQQ9s1rIemqceWcjrVDaJ
         Qo7NWKb+gHlv8v94mP3+AzCpbF1xRku8iHfciM9uUXYweeGoclqM7vEcefX6Uz6V5e/D
         S0XXm2vYSer5t0yrL8qbloQUpyAW6dQYl/c61vuwlcB+E/WXxo2yR0CGKHRI8WZstlGC
         8C04ghmWR2cVw5Wfl4i7P9YaHU5/QcbKR2CikpnsNmXyUHiRKQLhkfojxkV/olqBnEfv
         v8kEZoIjZe7KeXfj6fqWo1KyacDt6GY9HCty7lkksh4OSRRYhzRzv1pCY79fE/d1Hgrt
         llcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXW3upB1ZZMV2jZFkfjSF6rS0fu0dx5/uaDft0i8oJA=;
        b=KqkWGebAogb7sa1nAay3Xm14N6CdXQm5dKQRfTag0gFPJQk/B9oamPmmi3C2GfcLBa
         dVXFvqh1I+/YoAFXE7Rwz5uWLODbjTri0+bMIXsmwQV7bzDoCv9TwMk/oAeq0OzmRiOI
         xe5YC3YeUSnAkzDJStnbpYTzrVcWRxm4X7mWKXJPG4vRQA9ORhmH2agzUlnU8r9wmYsc
         8Ga4ASE1vWqJAElvevtnCll+ywasoZtzAlVi1wnNl+ZFKcfsqsT6J40IULKEZ00BeLfO
         f/DJKFeelWrwbG3GEphld+Jl5D2bliaX//l90Ko83OaLj+qZR0DPi8Xef8iFX5uFMa8S
         +D1A==
X-Gm-Message-State: AGi0PuakTLkwc4Hl4vRhPJZtxnlKQ5Z0+US0JIAu/UP+2x7u9t2gkn1P
        mGWA/T51jkwU9Gpq6gabBwZr29I9A9M=
X-Google-Smtp-Source: APiQypKkIn9NRpi/Ul5rkldsAt/3GFey21aTDyeDscPlxFo+Hfb25LJ/ECiHh6fOzlpqoFvhHzrzww==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr31342772wmb.56.1589175240437;
        Sun, 10 May 2020 22:34:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y70sm26391759wmc.36.2020.05.10.22.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 22:33:59 -0700 (PDT)
Date:   Mon, 11 May 2020 07:33:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200511053359.GC2245@nanopsycho>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
 <20200507153231.GA10250@salvia>
 <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
 <20200507164643.GA10994@salvia>
 <20200507164820.0f48c36b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507164820.0f48c36b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 08, 2020 at 01:48:20AM CEST, kuba@kernel.org wrote:
>On Thu, 7 May 2020 18:46:43 +0200 Pablo Neira Ayuso wrote:
>> On Thu, May 07, 2020 at 04:49:15PM +0100, Edward Cree wrote:
>> > On 07/05/2020 16:32, Pablo Neira Ayuso wrote:  
>> > > On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:  
>> > >> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
>> > >>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.  
>> > > 
>> > > You have have to explain why this makes sense in terms of semantics.
>> > > 
>> > > _DISABLED and _ANY are contradicting each other.  
>> > No, they aren't.  The DISABLED bit means "I will accept disabled", it doesn't
>> >  mean "I insist on disabled".  What _does_ mean "I insist on disabled" is if
>> >  the DISABLED bit is set and no other bits are.
>> > So DISABLED | ANY means "I accept disabled; I also accept immediate or
>> >  delayed".  A.k.a. "I don't care, do what you like".  
>> 
>> Jiri said Disabled means: bail out if you cannot disable it.
>
>That's in TC uAPI Jiri chose... doesn't mean we have to do the same
>internally.

Yeah, but if TC user says "disabled", please don't assign counter or
fail.


>
>> If the driver cannot disable, then it will have to check if the
>> frontend is asking for Disabled (hence, report error to the frontend)
>> or if it is actually asking for Don't care.
>> 
>> What you propose is a context-based interpretation of the bits. So
>> semantics depend on how you accumulate/combine bits.
>> 
>> I really think bits semantics should be interpreted on the bit alone
>> itself.
>
>These 3 paragraphs sound to me like you were arguing for Ed's approach..
>
>> There is one exception though, that is _ANY case, where you let the
>> driver pick between delayed or immediate. But if the driver does not
>> support for counters, it bails out in any case, so the outcome in both
>> request is basically the same.
>> 
>> You are asking for different outcome depending on how bits are
>> combined, which can be done, but it sounds innecessarily complicated
>> to me.
>
>No, quite the opposite, the code as committed to net has magic values
>which drivers have to check.
>
>The counter-proposal is that each bit represents a configuration, and
>if more than one bit is set the driver gets to choose which it prefers. 
>What could be simpler?
>
>netfilter just has to explicitly set the field to DONT_CARE rather than 
>depending on 0 form zalloc() coinciding with the correct value.
