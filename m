Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74532871C3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgJHJop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:44:44 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2BC061755;
        Thu,  8 Oct 2020 02:44:44 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g4so5192321edk.0;
        Thu, 08 Oct 2020 02:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fK7DrchbZqdfBsz7y7likbfCz9mOIC+hUmwv4mdi41I=;
        b=VtfYuM7C35JVasrzkGJzP87ITCw5uEORLEzJDW7x+JivMNz7muJdVVM4ctIREjXzoQ
         9FRH/oWZvfG6qROEz7vjPYtCwwXdSX8lkoxg/Bz/oKlGtGQxWvM46bcU0+qXGdMQp2+n
         5U6yz6vae+OC+qNbrkB/jUdCTnPeKnQM6HWOqaYXeKMXLeATUXo6F8tZWuyckdZcba7r
         JrFW7hlb6Emgdd3F2l73FO3IiPYgo/diQY+avgHD9Rz8xNy5ZfT/Tzl1akPwiy0YQNRX
         17QWIFdtHh7fhAmuvliQdeRg+2GuSTsoD/RpsSefKpLi+LIOc6bJobe92hNJuomh9pn9
         C/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fK7DrchbZqdfBsz7y7likbfCz9mOIC+hUmwv4mdi41I=;
        b=RyUxcSD73/EsXyBkIdtdu0FdkJ/IVRhgydBSyNHImUs4ZVYnfe5vZQkCdvYMRfGDr+
         zIad4fuDEfjO1uOnUHvgmTyFK98fpOcFzBpQ8iJOjp2o7vewKRXwuNGFpAR+LK10x1Ay
         JwQR9GimcDV61ezo5374AAfHBPW83ZLGgDjpMHupIp1WicVIPoBtO6Vbr/RHqG9ENCs1
         qivc9KbJc35HrQkG/jGqTZRwhm6BomIWV3pBs54VYc5jnfq00Y38lo0M3mI6ODTFSV08
         1HQqKANjZNwEAccB0OJBKMUP9DiRrYtI+BoQZgJ7UMczXvZW2K5jxrMM1vn2arPC+NFm
         wQxw==
X-Gm-Message-State: AOAM532TEhOr27x9VkuoiNem7qw23WIU9ZOvL2yBSubjw92GGKG1Kbzp
        zdfz3l3sBFTV4J8tE1YPPXk=
X-Google-Smtp-Source: ABdhPJxXbEx+g9sV5+NKVNFiaHg4G7F2F8qMDXQe772KKfOI7pVX+F31T3eHInm9sRL1xLbB6V+GZA==
X-Received: by 2002:a05:6402:384:: with SMTP id o4mr8062191edv.387.1602150282845;
        Thu, 08 Oct 2020 02:44:42 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id pj5sm3701206ejb.118.2020.10.08.02.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 02:44:42 -0700 (PDT)
Date:   Thu, 8 Oct 2020 12:44:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201008094440.oede2fucgpgcfx6a@skbuf>
References: <20201004143000.blb3uxq3kwr6zp3z@skbuf>
 <87imbn98dd.fsf@kurt>
 <20201006072847.pjygwwtgq72ghsiq@skbuf>
 <87tuv77a83.fsf@kurt>
 <20201006133222.74w3r2jwwhq5uop5@skbuf>
 <87r1qb790w.fsf@kurt>
 <20201006140102.6q7ep2w62jnilb22@skbuf>
 <87lfgiqpze.fsf@kurt>
 <20201007105458.gdbrwyzfjfaygjke@skbuf>
 <87362pjev0.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87362pjev0.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 10:34:11AM +0200, Kurt Kanzenbach wrote:
> On Wed Oct 07 2020, Vladimir Oltean wrote:
> > On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach wrote:
> >> For instance the hellcreek switch has actually three ptp hardware
> >> clocks and the time stamping can be configured to use either one of
> >> them.
> >
> > The sja1105 also has a corrected and an uncorrected PTP clock that can
> > take timestamps. Initially I had thought I'd be going to spend some time
> > figuring out multi-PHC support, but now I don't see any practical reason
> > to use the uncorrected PHC for anything.
> 
> Just out of curiosity: How do you implement 802.1AS then? My
> understanding is that the free-running clock has to be used for the

Has to be? I couldn't find that wording in IEEE 802.1AS-2011.

> calculation of the peer delays and such meaning there should be a way to
> get access to both PHCs or having some form of cross timestamping
> available.
> 
> The hellcreek switch can take cross snapshots of all three ptp clocks in
> hardware for that purpose.

Well, at the end of the day, all the other TSN offloads (tc-taprio,
tc-gate) will still have to use the synchronized PTP clock, so what
we're doing is we're simply letting that clock be synchronized by ptp4l.

> >> > So when you'll poll for TX timestamps, you'll receive a TX
> >> > timestamp from the PHY and another one from the switch, and those will
> >> > be in a race with one another, so you won't know which one is which.
> >> 
> >> OK. So what happens if the driver will accept to disable hardware
> >> timestamping? Is there anything else that needs to be implemented? Are
> >> there (good) examples?
> >
> > It needs to not call skb_complete_tx_timestamp() and friends.
> >
> > For PHY timestamping, it also needs to invoke the correct methods for RX
> > and for TX, where the PHY timestamping hooks will get called. I don't
> > think that DSA is compatible yet with PHY timestamping, but it is
> > probably a trivial modification.
> 
> Hmm? If DSA doesn't support PHY timestamping how are other DSA drivers
> dealing with it then? I'm getting really confused.

They aren't dealing with it, of course.

> Furthermore, there is no hellcreek hardware available with timestamping
> capable PHYs. How am I supposed to even test this?
> 
> For now, until there is hardware available, PHY timestamping is not
> supported with the hellcreek switch.

I was just pointing out that this is something you'll certainly have to
change if somebody will want PHY timestamping.

Even without hardware, you _could_ probably test that DSA is doing the
right thing by simply adding the PTP timestamping ops to a PHY driver
that you own, and inject dummy timestamps. The expectation becomes that
user space gets those dummy timestamps, and not the ones emitted by your
switch.
