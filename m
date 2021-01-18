Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACDC2FAA2C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393991AbhART25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393919AbhART2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:28:41 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6761EC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:28:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id r12so13881379ejb.9
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A67zwm66VO39Pc8GKi5HBAhdDGv5+urr58JWHCjCMxo=;
        b=n48jHYV+54ZNvhy5//koB8eQEgppEzz03Vt0VM63bZSdM/aNV2LNY8SXklUuNprX+i
         a4Elv03OqSh4dDkNOLeRBeLx+cSYrPwLEQnr92j+lEn6Drgi6eE91A5DdJymj5WLD+6I
         nUcMge9EPcuMO08PzRD2CiqY5aetHHnmIh7EYcrXsY3G4E4iveMY5UZ2ubme9vbmNR4A
         4sm+sNM1cyldMB6kEhfk8ave5nTB60Gs3+q5B7cAbP9/kzf/683Tyry6oamJREgdAXSk
         1zUXzOIy7Nl3h04rmIilImxN97nCJSWQvW1BEXhOo2cnuADqHFwG/wtXxZI40vVgKV/6
         jgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A67zwm66VO39Pc8GKi5HBAhdDGv5+urr58JWHCjCMxo=;
        b=ot2a70vwS2NJK067HiSot0eDMvVtp+dJZeC4N/2MRuR7NNKVReUBU6MygEo83DY4xR
         /3GyQJHk6dBL9+Jpt/86kdHknwEtPXkEs7pPLCxW9cEkH9ycSW8SeMOisYWsVrSrYqra
         +Syv5UV1emU2DODpGm5vhAy5Epx/nJxA+E2QG19RRRync8vWtqvEI9VqsEL/k+LMuCwD
         6s+/YpnRXICrBVcwgUSWoYeu1H2GJxIM++01MFynu9Uw6TrnRvVFfdhfbYXR3p8BVjp0
         ztR3/UnwpMZmh3tbvsfvwHN/lVfos0lWSr7anAxTyVcYS4O9sWwOI1417py0dEut7X7U
         AIyg==
X-Gm-Message-State: AOAM530bA9JIiYUeKNgHvMuJm2tL4ybu1IkitgF57sTZSBToHaocj4bK
        CHle1fa3eK8Ixfgfl1kNrKI=
X-Google-Smtp-Source: ABdhPJxujV+3oZ1jZoXr7Zjnj31eipl+Nh4aR7DP6sbHgtkhDkMbQ0IGg+dGXoo11Sc2Yz1UxsKRMw==
X-Received: by 2002:a17:906:68d1:: with SMTP id y17mr737633ejr.293.1610998079122;
        Mon, 18 Jan 2021 11:27:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bl13sm1688007ejb.64.2021.01.18.11.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 11:27:58 -0800 (PST)
Date:   Mon, 18 Jan 2021 21:27:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118192757.xpb4ad2af2xpetx3@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf>
 <87turejclo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87turejclo.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 07:58:59PM +0100, Tobias Waldekranz wrote:
> Ah I see, no I was not aware of that. I just saw that the entry towards
> the CPU was added to the ATU, which it would in both cases. I.e. from
> the switch's POV, in this setup:
> 
>    br0
>    / \ (A)
> swp0 dummy0
>        (B)
> 
> A "local" entry like (A), or a "static" entry like (B) means the same
> thing to the switch: "it is somewhere behind my CPU-port".

Yes, except that if dummy0 was a real and non-switchdev interface, then
the "local" entry would probably break your traffic if what you meant
was "static".

> > So I think there is a very real issue in that the FDB entries with the
> > is_local bit was never specified to switchdev thus far, and now suddenly
> > is. I'm sorry, but what you're saying in the commit message, that
> > "!added_by_user has so far been indistinguishable from is_local" is
> > simply false.
> 
> Alright, so how do you do it? Here is the struct:
> 
>     struct switchdev_notifier_fdb_info {
> 	struct switchdev_notifier_info info; /* must be first */
> 	const unsigned char *addr;
> 	u16 vid;
> 	u8 added_by_user:1,
> 	   offloaded:1;
>     };
> 
> Which field separates a local address on swp0 from a dynamically learned
> address on swp0?

None, that's the problem. Local addresses are already presented to
switchdev without saying that they're local. Which is the entire reason
that users are misled into thinking that the addresses are not local.

I may have misread what you said, but to me, "!added_by_user has so far
been indistinguishable from is_local" means that:
- every struct switchdev_notifier_fdb_info with added_by_user == true
  also had an implicit is_local == false
- every struct switchdev_notifier_fdb_info with added_by_user == false
  also had an implicit is_local == true
It is _this_ that I deemed as clearly untrue.

The is_local flag is not indistinguishable from !added_by_user, it is
indistinguishable full stop. Which makes it hard to work with in a
backwards-compatible way.

> Ok, so just to see if I understand this correctly:
> 
> The situation today it that `bridge fdb add ADDR dev DEV master` results
> in flows towards ADDR being sent to:
> 
> 1. DEV if DEV belongs to a DSA switch.
> 2. To the host if DEV was a non-offloaded interface.

Not quite. In the bridge software FDB, the entry is marked as is_local
in both cases, doesn't matter if the interface is offloaded or not.
Just that switchdev does not propagate the is_local flag, which makes
the switchdev listeners think it is not local. The interpretation of
that will probably vary among switchdev drivers.

The subtlety is that for a non-offloading interface, the
misconfiguration (when you mean static but use local) is easy to catch.
Since only the entry from the software FDB will be hit, this means that
the frame will never be forwarded, so traffic will break.
But in the case of a switchdev offloading interface, the frames will hit
the hardware FDB entry more often than the software FDB entry. So
everything will work just fine and dandy even though it shouldn't.

> With this series applied both would result in (2) which, while
> idiosyncratic, is as intended. But this of course runs the risk of
> breaking existing scripts which rely on the current behavior.

Yes.

My only hope is that we could just offload the entries pointing towards
br0, and ignore the local ones. But for that I would need the bridge
maintainers to clarify what is the difference between then, as I asked
in your other patch.
