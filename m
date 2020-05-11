Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F31CD732
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgEKLGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728638AbgEKLGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:06:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9F1C061A0C;
        Mon, 11 May 2020 04:06:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o10so7529137ejn.10;
        Mon, 11 May 2020 04:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ybDrynh43aGAdYaMM8qDIpCRRMRzFAjnTRZJLgw9IY=;
        b=TJW7vpazNVh5QwWeVsEe41nsOTWXavYTd4yBPZcjrxCazHfaHcKNLTWpRUI7BUCnlA
         7OkrJFB06o1OEkbbPiMdsO2aK0j6jbbwz2lsZYKeN+SSbhuMWErKqufUfck/9qmWmh+/
         qWA0QX5GX+V8CY6AXwqijN30tGG3Wi9veQSkweDn3tleaAV1YCplG6VtfNKxttXQvUzW
         3iiHhceWVjvgQSb0nx96QoBT/bIuoBDy8z6BaBycusTzuyU6Ud4VmEs3z2d9T8Jt1ZAm
         uTiFgjX5JB3Bf8pmPEeeOC6hlsToK/FWzKaBlwUd8nwVTl6sEF0QKB5FOoIXe8ZQSRSh
         i1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ybDrynh43aGAdYaMM8qDIpCRRMRzFAjnTRZJLgw9IY=;
        b=CqxYyIhxvnrZrJ/lKjN1CaKr3XCOb4Bbx4ps4aI4ribpA+nb5MogS795h+bfEhuJZo
         azrQ16o9FTsp1r/9kCrKeRUXhQGAwXpYdcLNwp+mGhCNYts1bl3gYAaPoYwIyeWUAgxL
         /iELJOtE7deVk0cV9fxNz0xLjybWhpoPPU6iHkNfv5DTqyJQaUVdxPP63K04PbNKtTV7
         SJ5JrqIlAxCfHPMOXVkNIDI5mhBucPkuFh/eBlv++tV1VjNCfYbhgD4zzEHNlkPJS2EB
         dHVmDr35Hhv2uREi3fl3aHBZvsLgGHE1sn89h4G2NPOUf6Stkelig+ohtUi++TnXSTXP
         m+1w==
X-Gm-Message-State: AGi0PubWmu/4HYc0YpTo4zke6rmD/V1mfY1VmK+3nixoK9dLy4woZKjE
        jYWSrfS8EZRYG0IvI5LuT5yLsqY/vEgmQP/PIdnUVQ==
X-Google-Smtp-Source: APiQypJxWhyHKDGTL92E/fjOEYy/Ja6gvJpBErwpcnHxTXlOfBtRbigEM+ciaG03gTeZWAsaW7qMbcbx8iGs/+nF89A=
X-Received: by 2002:a17:906:d8c1:: with SMTP id re1mr6314698ejb.184.1589195211787;
 Mon, 11 May 2020 04:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200510164255.19322-1-olteanv@gmail.com>
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 May 2020 14:06:41 +0300
Message-ID: <CA+h21hrK2_7F78momhR84tG4bqUFo2a1VVbpH=AxXGwejdgqPw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] Traffic support for dsa_8021q in
 vlan_filtering=1 mode
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 at 19:43, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This series is an attempt to support as much as possible in terms of
> traffic I/O from the network stack with the only dsa_8021q user thus
> far, sja1105.
>
> The hardware doesn't support pushing a second VLAN tag to packets that
> are already tagged, so our only option is to combine the dsa_8021q with
> the user tag into a single tag and decode that on the CPU.
>
> The assumption is that there is a type of use cases for which 7 VLANs
> per port are more than sufficient, and that there's another type of use
> cases where the full 4096 entries are barely enough. Those use cases are
> very different from one another, so I prefer trying to give both the
> best experience by creating this best_effort_vlan_filtering knob to
> select the mode in which they want to operate in.
>
> This series depends on "[v4,resend,net-next,0/4] Cross-chip bridging for
> disjoint DSA trees", submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200510163743.18032-1-olteanv@gmail.com/
>
> Russell King (1):
>   net: dsa: provide an option for drivers to always receive bridge VLANs
>
> Vladimir Oltean (14):
>   net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
>   net: dsa: sja1105: keep the VLAN awareness state in a driver variable
>   net: dsa: sja1105: deny alterations of dsa_8021q VLANs from the bridge
>   net: dsa: sja1105: save/restore VLANs using a delta commit method
>   net: dsa: sja1105: allow VLAN configuration from the bridge in all
>     states
>   net: dsa: sja1105: exit sja1105_vlan_filtering when called multiple
>     times
>   net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN
>     simultaneously
>   net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs
>   net: dsa: tag_sja1105: implement sub-VLAN decoding
>   net: dsa: sja1105: add a new best_effort_vlan_filtering devlink
>     parameter
>   net: dsa: sja1105: add packing ops for the Retagging Table
>   net: dsa: sja1105: implement a common frame memory partitioning
>     function
>   net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs
>   docs: net: dsa: sja1105: document the best_effort_vlan_filtering
>     option
>
>  .../networking/devlink-params-sja1105.txt     |   27 +
>  Documentation/networking/dsa/sja1105.rst      |  211 +++-
>  drivers/net/dsa/sja1105/sja1105.h             |   29 +
>  .../net/dsa/sja1105/sja1105_dynamic_config.c  |   33 +
>  drivers/net/dsa/sja1105/sja1105_main.c        | 1072 +++++++++++++++--
>  drivers/net/dsa/sja1105/sja1105_spi.c         |    6 +
>  .../net/dsa/sja1105/sja1105_static_config.c   |   62 +-
>  .../net/dsa/sja1105/sja1105_static_config.h   |   16 +
>  drivers/net/dsa/sja1105/sja1105_vl.c          |   20 +-
>  include/linux/dsa/8021q.h                     |   42 +-
>  include/linux/dsa/sja1105.h                   |    5 +
>  include/net/dsa.h                             |    1 +
>  net/dsa/slave.c                               |   12 +-
>  net/dsa/tag_8021q.c                           |  108 +-
>  net/dsa/tag_sja1105.c                         |   38 +-
>  15 files changed, 1443 insertions(+), 239 deletions(-)
>  create mode 100644 Documentation/networking/devlink-params-sja1105.txt
>
> --
> 2.17.1
>

Sorry to repost before receiving any feedback, but there are some
small fixups I need to make.

Thanks,
-Vladimir
