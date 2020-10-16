Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481E12908FD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410466AbgJPP4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408157AbgJPP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 11:56:48 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE29C061755;
        Fri, 16 Oct 2020 08:56:48 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t21so2969111eds.6;
        Fri, 16 Oct 2020 08:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/6eJb3d/LH1w9U+JGdalk+l2zLyd0Hh/mR0rroG5prU=;
        b=Oe1GsO4qAOTblXYzhEN+nYK7SJWlNrdKpAaOFmZ3+qHZPSlYVUxy2ohAk6kMhnal51
         fdkzbCzM7AfnyPgnB0eV6Y7F93lLph/CCOxBKu9768v4Q6OE1l10LIyxwY0G5kSVbSPY
         7mVqrodaImSyxdDyRUwpsQAq6iZgJ7GNg03duhV0VgZBgk6XQqc3S6zmkQprThgkdEco
         R2ap+22LzK0SkgqxC1WSRcB2eYeUjk3fXyJwAxlfR8GSo7qIkwhXmdu3xlQuBiWlwfDG
         xe0GUmojrzuTW6/UGAAEB4Dx7C8/vfcQTv7X2znGNTqB6a6TKs4PJl6gz7RQjFD2dQDV
         Re9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/6eJb3d/LH1w9U+JGdalk+l2zLyd0Hh/mR0rroG5prU=;
        b=qqwbiu385u8+FfWdRBNXcIfTXJvqtIbt7NjCm2BGaRV2c5ainlGUKm48HdAAAKTx0e
         hJkwdMydd/BsQrimF01ypSsOAXE8nGQ+8bxoTKngFZRv9I1bhqGsXwFF3WU609D7lGhc
         eY7DWaQn6+zkKcXj3cmZzyPrGIfp+4V5HzSTSIplAXMCBkNTOKEhyH0MHYzscy0gR7M/
         fVVhMNR+6d7ZLLMXOUdsWqew7nI8GMelO9yASdXWy69L4UkMUYc2OfDS7TDglpAMAg59
         4G7pDzTBi602mo79PSbqo79eweZWk6QAqyXLlfo+SY0TjWACDF/EptxQSzNStbYfpAau
         E4nA==
X-Gm-Message-State: AOAM530BFmY6e88mQ2u6oa5D7SkFfhwvPea4fU6lUmvw4TNZiF67vbM6
        1R3QC5f3w7QT2ueABdLnuSc=
X-Google-Smtp-Source: ABdhPJwQRMmXfizi2zx4WaAk+ytCAGe2YF6JcYioAUlXSjuUK6Z4gWryF0tQ5WvrgWeqr/7O7umS3A==
X-Received: by 2002:a50:fa42:: with SMTP id c2mr4956878edq.282.1602863807002;
        Fri, 16 Oct 2020 08:56:47 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id rs18sm1958606ejb.69.2020.10.16.08.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:56:46 -0700 (PDT)
Date:   Fri, 16 Oct 2020 18:56:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201016155645.kmlehweenqdue6q2@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
 <4467366.g9nP7YU7d8@n95hx1g2>
 <20201016090527.tbzmjkraok5k7pwb@skbuf>
 <1655621.YBUmbkoM4d@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655621.YBUmbkoM4d@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 02:44:46PM +0200, Christian Eggers wrote:
> Machine:
> - ARMv7 (i.MX6ULL), SMP_CACHE_BYTES is 64
> - DSA device: Microchip KSZ9563 (I am currently working on time stamping support)

I have a board very similar to this on which I am going to test.

> Last, CONFIG_SLOB must be selected.

Interesting, do you know why?

> 3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
> for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
> ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?

I was thinking about something like that, indeed. DSA knows everything
about the tagger: its overhead, whether it's a tail tag or not. The xmit
callback of the tagger should only be there to populate the tag where it
needs to be. But reallocation, padding, etc etc, should all be dealt
with by the common DSA xmit procedure. We want the taggers to be simple
and reuse as much logic as possible, not to be bloated.
