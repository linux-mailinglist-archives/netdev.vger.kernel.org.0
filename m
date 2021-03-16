Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7633E193
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhCPWlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhCPWld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 18:41:33 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5228AC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:41:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bm21so74810427ejb.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U0rdcmsxGp3lcXUmp5TVjHP9hTdCV0SHlFqeffuNi9w=;
        b=vJjfUbZnjwyESG0jwJpmiPJRFwsafTk2QrqHm0il4lmt8Fh4yN3qTgEfIe9tBIrAM7
         KsiiVKKvdprxhT0qn8w3HGJDCbY54244xNdnyRATmoi7Xn0R5kwYTSM8MxgqtCMnqQEK
         RzWsxwuwD8U+QgDoD4OB6mYDHz1mBJIm4iG74vjgDFoOXnmLsvX3qTTF/ocVMqGfOU4x
         sCba0oZD23AgaKOAiROAbvBS9d0JmTz3IWJZ6kF+x8uCGM8tOBB4TAcHZz/M9CSCStmC
         8cIyBUZvflGaB1fy+gIk8YRufln1PraCtDZM96FNErXwyMypmpFM/nytm4y95y4aQOvo
         y76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0rdcmsxGp3lcXUmp5TVjHP9hTdCV0SHlFqeffuNi9w=;
        b=FLC/Zio0c2oB9HcjlTecbYcwyg4e9JNAYtedF19U1vyCeJcP0sKf+E8ar4/7ItcbIv
         Z3s0DIJrp3zhV7v2E6ifkD6osSg0UnEZrDVNkM4ssEVTZnIF1O0Jwu1jHdCOiUQ1J+Zm
         oiU+DUH5GPhkjqd7OEIScVSp5bOiQpBD/TjBPstgmvXhH2796+DCp1UtGfB+r2SPcba7
         upVCPO/7JSbTRQJEvTEeNBzC7F2izvbmkVki5ktXpR3jdkz8QsxDT2FsaPew4Mb7qz06
         6FJgRWmapuHCYrDI9Ng75ON7UtelMmxK1UoHF9QjqkHroRNayMI5xddKuVnht4neSV4f
         t/rQ==
X-Gm-Message-State: AOAM530pN3rkRuB5rDeo1OK98kZPqLUvlhNVYXw56PGklG23c2UKZJX6
        5Y6q8m6goPIIlMjdOPFjIrw=
X-Google-Smtp-Source: ABdhPJzCGaw1MTWy5CH7PZEMQgbijXHsu+EmfZ4Oq3D7whOWs+3zVqKh/M4r92Cb3h+Bgp2weG1D3g==
X-Received: by 2002:a17:906:3ac3:: with SMTP id z3mr32768904ejd.106.1615934492106;
        Tue, 16 Mar 2021 15:41:32 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id cw14sm11539507edb.8.2021.03.16.15.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 15:41:31 -0700 (PDT)
Date:   Wed, 17 Mar 2021 00:41:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 net] net: dsa: Centralize validation of VLAN
 configuration
Message-ID: <20210316224130.ehqkcfktxwvj4j4s@skbuf>
References: <20210316214952.3444946-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316214952.3444946-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 10:49:52PM +0100, Tobias Waldekranz wrote:
> There are four kinds of events that have an impact on VLAN
> configuration of DSA ports:
> 
> - Adding VLAN uppers
>   (ip link add dev swp0.1 link swp0 type vlan id 1)
> 
> - Bridging VLAN uppers
>   (ip link set dev swp0.1 master br0)
> 
> - Adding bridge VLANs
>   (bridge vlan add dev swp0 vid 1)
> 
> - Changes to a bridge's VLAN filtering setting
>   (ip link set dev br0 type bridge vlan_filtering 1)

Expanding on my idea from v1, thinking out loud a bit:
https://patchwork.kernel.org/project/netdevbpf/patch/20210315195413.2679929-1-tobias@waldekranz.com/

All of these configurations could be supported by unoffloading
_something_.

> For all of these events, we want to ensure that some invariants are
> upheld for offloaded ports belonging to our tree:
> 
> - For hardware where VLAN filtering is a global setting, either all
>   bridges must use VLAN filtering, or no bridge can.

Ok, for this one I don't know what I would unoffload. The bridge with
the smallest throughput, I guess? Anyway, it would seem pretty arbitrary
for DSA to take this decision by itself.

> - For all filtering bridges, no VID may be configured on more than one
>   VLAN upper. An example of a violation of this would be:
> 
>   .100  br0  .100
>      \  / \  /
>      swp0 swp1
> 
>   $ ip link add dev br0 type bridge vlan_filtering 1
>   $ ip link add dev swp0.100 link swp0 type vlan id 100
>   $ ip link set dev swp0 master br0
>   $ ip link add dev swp1.100 link swp0 type vlan id 100
>   $ ip link set dev swp1 master br0

In this case, all bridge ports having 8021q coinciding uppers, except
one, should be unoffloaded.

> - For all filtering bridges, no upper VLAN may share a bridge with
>   another offloaded port. An example of a violation of this would be:
> 
>        br0
>       /  |
>      /   |
>   .100   |
>     |    |
>    swp0 swp1
> 
>   $ ip link add dev br0 type bridge vlan_filtering 1
>   $ ip link add dev swp0.100 link swp0 type vlan id 100
>   $ ip link set dev swp0.100 master br0
>   $ ip link set dev swp1 master br0

In this case it's pretty simple, we simply do not offload an 8021q upper
as a bridge port. With the patches that I hope to send tomorrow for
SWITCHDEV_BRPORT_OFFLOADED, this should be just as supported as an
unoffloaded LAG added to a bridge.

Actually for this one, I think there is the same limitation for both the
vlan_filtering=0 and vlan_filtering=1 cases. When vlan_filtering=0,
traffic coming from swp1 might be VLAN-tagged, and the expectation is
that the swp0.100 bridge port adds yet another VLAN tag on egress.

> - For all filtering bridges, no VID that exists in the bridge may be
>   used by a VLAN upper. An example of a violation of this would be:
> 
>       br0
>      (100)
>        |
>   .100 |
>      \ |
>      swp0
> 
>   $ ip link add dev br0 type bridge vlan_filtering 1
>   $ ip link add dev swp0.100 link swp0 type vlan id 100
>   $ ip link set dev swp0 master br0
>   $ bridge vlan add dev swp0 vid 100

With software interfaces, this configuration would mean that the VLAN
100 traffic is stolen from the bridge's data path by swp0.100, which
makes it pointless to let the bridge use that VLAN in the first place.

It is clear in this case too what port should be unoffloaded.

> Move the validation of these invariants to a central function, and use
> it from all sites where these events are handled. This way, we ensure
> that all invariants are always checked, avoiding certain configs being
> allowed or disallowed depending on the order in which commands are
> given.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

So without a clear use case for the corner cases above, I think I just
debunked by own idea about unoffloading bridge ports as being a useful
way to react.

I'll do some testing tomorrow, sorry for the rambling.

These are all really marginal conditions which nobody should be hitting
under normal usage, I'm starting to reconsider whether this is appropriate
as "net" material vs "net-next" (and the advantage of sending to "net-next"
would be that you could send the selftests too). I know that code in
general should only be as simple as necessary to be correct, but with
switchdev, even the bare minimum for correctness is a hell of a lot.
Vivien, Florian, Andrew, what do you think, net or net-next?
