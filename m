Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69402876C2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgJHPJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbgJHPJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:09:56 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5D2C061755;
        Thu,  8 Oct 2020 08:09:55 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e22so8639094ejr.4;
        Thu, 08 Oct 2020 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mz7ujxNpgZNPhKSQpiot5811hgY+Em16b9dwOzq10cs=;
        b=SRxtaS0AtGer+J0vhK+LYmmxlivIl0mUUyfkAvhkgWCecI79C2tapJn2EL0ukjyUIT
         sBJEvcboBUg3uiMvdjp67nPKZIUp0OInqnAkzY1FaxMj1hb5rqGWyMKZrhjZuDE3n/xa
         VZf+Wn4KQVcX7aFSdDZKX/WNN7SMVmGsHQLKFwXhfE3x5U/R4tBMwtbavCoaQEtMpF7W
         1j0n7nJjqMlJaPCiGfe6gVmj2k6Mrsf63STQYEQrnMXeeREuiF8EFAgbFW3cWJvHMlpj
         TuyM78VQwXcqO7khSTPwSJZmW6N9KEU8xMI5+rjTEsfxjXS40o7vtHTkoEMCeyFS/4H2
         6ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mz7ujxNpgZNPhKSQpiot5811hgY+Em16b9dwOzq10cs=;
        b=pQlYkPNGxatYlqIBtIChdyFfRbjkzvR8VS9OGqOrFLXD0oJGB5CDpQlyxEsfi2PZ7g
         I4jywRFtr+H0th/xtts8jZKFHk2Cm3TyLBaTqIQc4AiTEq4fErkLwwZBNZvVTnoxMkpj
         fDOzcRpIvggzDGyjRfTGfe4M8zBCVtytcO1hibOracle7gEt99SSMbTfvlkOjuU5pEG0
         ktVqdjCW418QrCZddKgfQB4AnTpnMYpag6Od1PIRT8UuJ7zsI/D3of42boG/ryuP0CQB
         GslzaOO1IfShFgD8dQYcjiWTfHmSKxIo2FshVyqzA9fYu0oFDUBYLthszOdekKC6blS2
         PH+Q==
X-Gm-Message-State: AOAM531n5ppmcOSVAfLJPdRgObd8W2mqEN8CU+pDNj7yLe6bzkfKu5aY
        oj2B8x15PM8YHQMu+bJCvTk=
X-Google-Smtp-Source: ABdhPJxiy8myepYvwEmljQhBGRrkN1b7gi1vk6j8Oly9ej4MQyqd5eREHSult1j+7Eg5DgRKx8N2kw==
X-Received: by 2002:a17:906:f0d8:: with SMTP id dk24mr9101321ejb.492.1602169794085;
        Thu, 08 Oct 2020 08:09:54 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id z20sm4110861edq.90.2020.10.08.08.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:09:52 -0700 (PDT)
Date:   Thu, 8 Oct 2020 18:09:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201008150951.elxob2yaw2tirkig@skbuf>
References: <87tuv77a83.fsf@kurt>
 <20201006133222.74w3r2jwwhq5uop5@skbuf>
 <87r1qb790w.fsf@kurt>
 <20201006140102.6q7ep2w62jnilb22@skbuf>
 <87lfgiqpze.fsf@kurt>
 <20201007105458.gdbrwyzfjfaygjke@skbuf>
 <87362pjev0.fsf@kurt>
 <20201008094440.oede2fucgpgcfx6a@skbuf>
 <87lfghhw9u.fsf@kurt>
 <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kamil,

On Thu, Oct 08, 2020 at 02:55:57PM +0200, Kamil Alkhouri wrote:
> Hello dears,
> 
> On Thu, 2020-10-08 at 12:01 +0200, Kurt Kanzenbach wrote:
> > On Thu Oct 08 2020, Vladimir Oltean wrote:
> > > On Thu, Oct 08, 2020 at 10:34:11AM +0200, Kurt Kanzenbach wrote:
> > > > On Wed Oct 07 2020, Vladimir Oltean wrote:
> > > > > On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach
> > > > > wrote:
> > > > > > For instance the hellcreek switch has actually three ptp
> > > > > > hardware
> > > > > > clocks and the time stamping can be configured to use either
> > > > > > one of
> > > > > > them.
> > > > > 
> > > > > The sja1105 also has a corrected and an uncorrected PTP clock
> > > > > that can
> > > > > take timestamps. Initially I had thought I'd be going to spend
> > > > > some time
> > > > > figuring out multi-PHC support, but now I don't see any
> > > > > practical reason
> > > > > to use the uncorrected PHC for anything.
> > > > 
> > > > Just out of curiosity: How do you implement 802.1AS then? My
> > > > understanding is that the free-running clock has to be used for
> > > > the
> > > 
> > > Has to be? I couldn't find that wording in IEEE 802.1AS-2011.
> > 
> > It doesn't has to be, it *should* be. That's at least the outcome we
> > had
> > after lots of discussions. Actually Kamil (on Cc) is the expert on
> > this
> > topic.
> 
> According to 802.1AS-2011 (10.1.1): "The LocalClock entity is a free-
> running clock (see 3.3) that provides a common time to the time-aware
> system, relative to an arbitrary epoch.", "... All timestamps are taken
> relative to the LocalClock entity". The same statement holds true for
> 802.1AS-2020 (10.1.2.1).

Nice having you part of the discussion.

IEEE 802.1AS-rev draft 8.0, clause F.3 PTP options:

	The physical adjustment of the frequency of the LocalClock
	entity (i.e., physical syntonization) is allowed but not
	required.

In fact, even if that wasn't explicitly written, I am having a hard time
understanding how the "B.1.1 Frequency accuracy" requirement for the
LocalClock could be satisfied as long as it is kept free-running.
Otherwise said, what should I do as a system designer if the
LocalClock's frequency is not within +/- 100 ppm offset to the TAI
frequency, and I'm not allowed to correct it.

By the way, how would you see the split between an unsynchronized and a
synchronized PHC be implemented in the Linux kernel?

Thanks,
-Vladimir
