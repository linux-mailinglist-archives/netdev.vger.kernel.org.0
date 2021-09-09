Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1264E40428C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 03:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348460AbhIIBKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 21:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbhIIBJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 21:09:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77F8C061575;
        Wed,  8 Sep 2021 18:08:50 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j13so226397edv.13;
        Wed, 08 Sep 2021 18:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bjCj1xxnk8ibB2wj+n4wwtf9Ek6cDzSe9Y9AVaJRCoU=;
        b=jcJ63ESi+8E+4uQ8JciippXskAmL9aDzz+pxOL3zNJHiLT0qn4TmHxHyO+Ut364iq9
         uY3m+6/ZAydMfs324MyjsRvQ0ol3+QFfhciMo29L0Jb4dAOGORncL1TyCC1GwidLSt36
         MR/4HOqDAlUtiJossUu5NxJiSnp7VYVqjwdcNpY833OoWGRSYK5iKPe+bzJQ4vz+dX37
         7rLH6q/9Usvje1Ezrzsd3eoxfdgX4dqs9JUddZw0O9wPt1dVrGxvBQ2BBK17jAmeO39x
         KVgLKvAR4yQvc27ajVe865YzCuf96JMlk1ccrxKYIWVC7ZRtyTBdU5uAykPZCNDTsYlK
         SgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bjCj1xxnk8ibB2wj+n4wwtf9Ek6cDzSe9Y9AVaJRCoU=;
        b=RqA5NDjzn3SRFheFP4zyhSAGh+dwv6nbTUtytKPpYwG8pYUCP05arwwrwG9OR+/e3Y
         QlyWMr2OkYVProix1n8E4Rz4C/i9bCvyaOYe3GToZ7EI/+MC/57vi3DJ1lolVOPE3awD
         IrS3YOM18gjpAekK/Iv02ax1Hd498cNmC2BPwQxKxmunNxVweERnbiox+eQLZmpROviE
         JIAAD+h4h7ZGDnyNZUZvFIEnUJEb0WqreaOxAt2d0hCUCpro4cICRIdTEtNgvlwGhf1x
         8xutEhZLBWLoVtLhNb7l43kL4rrNz0+k4rUWUMlCmtQKUh76wpZm99MCu0TsJ63KpAEr
         v8Xw==
X-Gm-Message-State: AOAM533WDN7mgl8WUDh1QiVry5vmQB5iN/rIz9PLCwGNL6set9idIzHY
        9jk9SdtaVKQGSFS6dEk8HJs=
X-Google-Smtp-Source: ABdhPJzUBIKUSm8tJ9FF1Xr298ulw7Nr/JBJ1I+LIXgWD8+GU646MturKio3VuQKWSQPCKjThZSkIA==
X-Received: by 2002:aa7:c9cd:: with SMTP id i13mr437648edt.178.1631149729073;
        Wed, 08 Sep 2021 18:08:49 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bs13sm63182ejb.98.2021.09.08.18.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 18:08:48 -0700 (PDT)
Date:   Thu, 9 Sep 2021 04:08:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Message-ID: <20210909010847.s2cpwkkrxy6otimb@skbuf>
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
 <20210909002601.mtesy27atk7cuyeo@skbuf>
 <7e59ae19-ffba-9515-c6a9-c413bb89d240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e59ae19-ffba-9515-c6a9-c413bb89d240@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 05:49:17PM -0700, Florian Fainelli wrote:
> On 9/8/2021 5:26 PM, Vladimir Oltean wrote:
> > On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
> > > > Where is the problem?
> > >
> > > I'd say with 994d2cbb08ca, since the tagger now requires visibility into
> > > sja1105_switch_ops which is not great, to say the least. You could solve
> > > this by:
> > >
> > > - splitting up the sja1150 between a library that contains
> > > sja1105_switch_ops and does not contain the driver registration code
> >
> > I've posted patches which more or less cheat the dependency by creating
> > a third module, as you suggest. The tagging protocol still depends on
> > the main module, now sans the call to dsa_register_switch, that is
> > provided by the third driver, sja1105_probe.ko, which as the name
> > suggests probes the hardware. The sja1105_probe.ko also depends on
> > sja1105.ko, so the insmod order needs to be:
> >
> > insmod sja1105.ko
> > insmod tag_sja1105.ko
> > insmod sja1105_probe.ko
> >
> > I am not really convinced that this change contributes to the overall
> > code organization and structure.
>
> Yes, I don't really like it either, maybe we do need to resolve the other
> dependency created with 566b18c8b752 with a function pointer/indirect call
> that gets resolved at run-time, assuming the overhead is acceptable.

The overhead is acceptable, but maybe I'm not very clear where to put
the function pointer? In struct sja1105_tagger_data I assume?
Also, a function pointer with a single implementation and no intention
of adding a second one is a pretty strange construct, too.

> > > - finding a different way to do a dsa_switch_ops pointer comparison, by
> > > e.g.: maintaining a boolean in dsa_port that tracks whether a particular
> > > driver is backing that port
> >
> > Maybe I just don't see how this would scale. So to clarify, are you
> > suggesting to add a struct dsa_port :: bool is_sja1105, which the
> > sja1105 driver would set to true in sja1105_setup?
>
> Not necessarily something that is sja1105 specific, but something that
> indicates whether the tagger is operating with its intended switch driver,
> or with a "foreign" switch driver (say: dsa_loop for instance).

So that's the other thing. How would we set this "dp->tagger_running_on_foreign_switch_driver" bit?
Which switch/tagging driver pair that gets to run using the mainline code today
will ever cause this to be set?
The patch to make tag_sja1105 safe with dsa_loop was effectively solving
a non-problem from this perspective, since you'd have to modify
dsa_loop_get_protocol to report DSA_TAG_PROTO_SJA1105.
Instead of over-engineering things, how about making dsa_port_is_sja1105
return true? We could set that 'foreign switch driver' bit from the
dsa_loop module itself, when the time comes to make it officially
support multiple tagging protocols and changing between them.
