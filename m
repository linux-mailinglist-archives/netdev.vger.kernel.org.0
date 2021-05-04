Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7E83731E3
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 23:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhEDVZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 17:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhEDVZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 17:25:52 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F8C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 14:24:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 12so15344732lfq.13
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 14:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=uliylMPA3scQqPaauQbVrIOixvG300bg8trmMivqpf0=;
        b=KFS/nGi1eolFwtYT6NELDRAushYNsu4vIKv4FZrf5JKt3IoYJpFAKmQ5N2iEM8luNG
         ceizYfDegDgvfioz0FPWRlwC+BT5vAMxYunFnXn2LhPKuPlM1tYcMOeR0dZjdQe8Z15u
         gy7rBvCZNqyYja5VimuxEyBvGWat3pHV3Jf1IRCYOmiAE9bRmKijSHtakap5UPWv2vau
         38Wy4IkGaSyt1i4MVG4A0ZWLai8LpQAujiWkwux58NTsnUu8hy3zNs0DetSbMUXm1sLR
         LTVd6+KiS3JofDeIFk1c+wTrLdb8XNBPo0W5ZwqHnmXSXmrD5LU91i23TYmoWNw1HulN
         lp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uliylMPA3scQqPaauQbVrIOixvG300bg8trmMivqpf0=;
        b=c4jhsJNkE1QQHDjG/Cxml0HebJUqGxJ37zwhxGp87iB9SwQ/vOx84iV46Wae48bv9C
         pf0n3cwy1oij6szW/wuw06NqODRo/4hes0sY5gNs4+GqQnNB05+Rnwrz+WlCwPoXgePv
         xMaw0vwqqcDG90CchHJo5sE1uB0zc4vzlEB9Wu6T3oEgN4ylmh1FJj+RHvY0BDIecky4
         V1gLQAmcgSNz4yOz0wMCOEO9PVlRWWhdhf9RD1RoK+RyVXOuR0/yOvQ8cWGLH+xnS4m0
         BsLRGRMdFxxcmalevgUeL/ObiD23I27JIhKEm13uEZAOOXtLNomrIiU5Cfw2ylnGuAGM
         6sXg==
X-Gm-Message-State: AOAM532GZBBubD8o9aUgmRJQgSq31OUsqeoO60MRro4ZPG5ySUMedcCp
        bIrszmHK1i1rrZ/MAgphGL7Z7A==
X-Google-Smtp-Source: ABdhPJwOz299VrftPbCO7qLkDc3Ng/aTngBk9v/lnjlgXm+ouCEQ5CFF+JF2+FXdX1vkFuu+ce2pMw==
X-Received: by 2002:a05:6512:693:: with SMTP id t19mr6651918lfe.91.1620163494568;
        Tue, 04 May 2021 14:24:54 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id i7sm361703lfv.126.2021.05.04.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 14:24:53 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
In-Reply-To: <YJGvkJBKPj2WloXf@lunn.ch>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-7-tobias@waldekranz.com> <20210427101747.n3y6w6o7thl5cz3r@skbuf> <878s4uo8xc.fsf@waldekranz.com> <20210504152106.oppawchuruapg4sb@skbuf> <874kfintzh.fsf@waldekranz.com> <YJGvkJBKPj2WloXf@lunn.ch>
Date:   Tue, 04 May 2021 23:24:52 +0200
Message-ID: <871ramnqe3.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 22:33, Andrew Lunn <andrew@lunn.ch> wrote:
>> There is really no need to recompute the static parts of the tags on
>> each skb. It would mean moving some knowledge of the tagging format to
>> the driver. But that boundary is pretty artificial for
>> mv88e6xxx. tag_dsa has no use outside of mv88e6xxx, and mv88e6xxx does
>> not work with any other tagger. I suppose you could even move the whole
>> tagger to drivers/net/dsa/mv88e6xxx/?
>> 
>> What do you think?
>> 
>> Andrew?
>
> We have resisted this before.
>
> What information do you actually need to share between the tagger and
> the driver?

So far:

- Trunk/LAG ID to netdev mappings (this is stored on the dst now, but I
  think I have seen the light and agree with Vladimir that it really has
  no business there).

- DSA dev/port to bridge netdev mappings for the forwarding offloading
  in this RFC (or preferably the actual tag templates to use on egress
  since that would probably give you better performance)

In the future:

- Completions for in-flight remote management operations.

- FlowID to TC rule mappings (from the "Switch Egress header" when we
  enable that)

- In-band signaling between firmware running on the IMP and the driver
  for things like MRP and CFM offloading.

> Both tag_lan9303.c and tag_ocelot_8021q.c do reference
> their switch driver data structures, so some sharing is allowed. But
> please try to keep the surface areas down.

If you have a surface area keep it small, yes, agreed. I guess my
question is more why we should have any surface area at all? What do we
gain by the tagger/driver separation in the case of mv88e6xxx?

>        Andrew
