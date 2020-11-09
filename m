Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C5D2AB865
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgKIMiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIMiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:38:17 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BCAC0613CF;
        Mon,  9 Nov 2020 04:38:16 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id o20so8569657eds.3;
        Mon, 09 Nov 2020 04:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LG+mhNfwR75ysCcJy9bcqltJjwVCXWRs/YVx7ayTGvQ=;
        b=R8oa8IDCJJ3zLcWHWpi0vGT+wAuXAK+wBtt+t/mDjRRFlp2DhuuXxGet46gIqV/5+L
         n4beh4lv1R1/IGtWi8gmiTExqXK37BZBxiqlIiM85wrkTcwHRqgAsO538e8oJtLeO5C7
         kd0lbwbO5Fz99chBo4K+egFLPeTx03DZNo9AAjW9LnFagAQTkVjW8tyojMmMyBYiFYfH
         hdnDk48kbpBw7MXyHdbOJolKQKQBz7GOesUhANjJehhec+rqrPD5RoVeR8c6MMOQm7gT
         GcCDNlxf3khqoOEfzE4XV1x44XceoU7scz6ytTzIX74dY9uxyBI8psSvsICCu7ImwAHG
         9qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LG+mhNfwR75ysCcJy9bcqltJjwVCXWRs/YVx7ayTGvQ=;
        b=mP1O4B1l/VtnD63UxlUNu3kFt8H+OhxmLn8qjp8xZ146qATH7KPOFN+fmc1IIN7VHB
         UPJbMVDe7gwW8LTecLogyS/j/4JhbRMuiTEBAEgQwl0WiIU6OLK7oYG68Ag/4u5C+Hv5
         OAfTABgIiqlpuws3Tx44zMMROL5YzeRUQY8rpA34JG3dzK2K2f+5eF3DtrETN+ju7ay+
         0FPkvHnjSVxaJ6C+bB+3McFSkEI61onn++NCv4rKg3zBzr4GgNxq+sFEtSyMQ0gFuJvx
         GGR/jrkup1ZRDkt7XCagg7V3AztX+YduhLVgI9HpT/acWAD5lwGMDUx/Z1BmsnWpJBiX
         KEUw==
X-Gm-Message-State: AOAM533CM7GPotI9T1N9LdAxrVot/3imzkAnsnAAtdrWm/lhF3P0mDh3
        vzc3iLqY9k6l+1Tn+uSelT4=
X-Google-Smtp-Source: ABdhPJzOLgHdE6uRPQxt9Dped4eDMxKXKDgqZx12eZEB71cDAkPymkBfPkNKVKpN4SyHvvLbOH9Brw==
X-Received: by 2002:a50:ee97:: with SMTP id f23mr15527151edr.333.1604925494720;
        Mon, 09 Nov 2020 04:38:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id a1sm8898495edk.52.2020.11.09.04.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 04:38:14 -0800 (PST)
Date:   Mon, 9 Nov 2020 14:38:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201109123813.kjzvel7pszhcmcgw@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <20201108235939.GC1417181@lunn.ch>
 <20201109003028.melbgstk4pilxksl@skbuf>
 <87y2jbt0hq.fsf@waldekranz.com>
 <20201109100300.dgwce4nvddhgvzti@skbuf>
 <87tutyu6xc.fsf@waldekranz.com>
 <20201109123111.ine2q244o5zyprvn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109123111.ine2q244o5zyprvn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 02:31:11PM +0200, Vladimir Oltean wrote:
> I need to sit on this for a while. How many DSA drivers do we have that
> don't do SA learning in hardware for CPU-injected packets? ocelot/felix
> and mv88e6xxx? Who else? Because if there aren't that many (or any at
> all except for these two), then I could try to spend some time and see
> how Felix behaves when I send FORWARD frames to it. Then we could go on
> full blast with the other alternative, to force-enable address learning
> from the CPU port, and declare this one as too complicated and not worth
> the effort.

In fact I'm not sure that I should be expecting an answer to this
question. We can evaluate the other alternative in parallel. Would you
be so kind to send some sort of RFC for your TX-side offload_fwd_mark so
that I could test with the hardware I have, and get a better understanding
of the limitations there?
