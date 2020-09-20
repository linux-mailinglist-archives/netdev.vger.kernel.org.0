Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5FD2711CD
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgITCox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:44:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB210C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:44:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so6111118pfi.4
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TGqEjMtr00ekOPlqSVGiuX6Dxsp0NvTuUX3MESVAdjQ=;
        b=FmxRZWx+Uu9PUhXNniGO08DJ+hHVxUTMGKT+Si8tK/FAahmv0lxGwu9QuRxks/y0WY
         xpjzGvuM205L88jLHzG9a2TE/b5hV++67LWNRnoyN9SzDrauNGFzUn/s6Ibugrz0Nelr
         iPZCv5z8NRZKcHmeXTzqdBV5C3p0fvROwEsYjGgjNM+RGMxjaC+I29W3rhrGzVdH1Yg6
         2rgCMIu80ArgOUkewzz/n/1u5M4j0LjNnrilMWjOLFdp6RDcjpsNLxgM8ApoZkfnMfoS
         BdYxihG+smouFC1oulxsoOWtZEG2raN5EoOB87Jz70RGiHNEy+Q3Eu17/5npuCuz/GFQ
         MxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TGqEjMtr00ekOPlqSVGiuX6Dxsp0NvTuUX3MESVAdjQ=;
        b=h+QtC/CX3TCaWhDBtxPYVkUQIG6ApvQYHddUp5NL3BQ4Ykvv8KUNjJ7mHmIkGuYDRe
         kulyCAPT6rFhqLgLtFdVVNUAxsb7jOgzd5/7sQPjfF5XzrdvEC5PXkTQ6gdGmJP20zRY
         mf/5/+AaM7lbkGL6UVnjFvJOhCRlVVTojjIGbpg9lXuNmWbcLp02p6YAGGTfk017X405
         CDV2QpmKSIKErmxNz3rP5zQCez2XvUnn5MgYYy6jhmLMOSZyP3p3u3NOHeGZVGEgCGWg
         nrSLCF/5PbDt2yty+E1OAmC/BMqrdIZ6jLLiYsa58SyNVYJbdZ0+Mm6L2mQHZCPStBSX
         lO+Q==
X-Gm-Message-State: AOAM5329c/POsTK+tigfvQWFe8zTTwf+/Rw3fw+DNdQHGPaDrVEhcrrP
        ui3R97PQBBX96CpePessZRY=
X-Google-Smtp-Source: ABdhPJz9edaN2G785kz1y3rE4+bEBHMkPhYOJ75P7mwiH4i05nYVz7nCX5s2k+RWwJBfqbeGuBmksg==
X-Received: by 2002:a62:503:0:b029:13e:d13d:a0f9 with SMTP id 3-20020a6205030000b029013ed13da0f9mr38105338pff.21.1600569892327;
        Sat, 19 Sep 2020 19:44:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y202sm8114847pfc.179.2020.09.19.19.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:44:51 -0700 (PDT)
Subject: Re: [RFC PATCH 0/9] DSA with VLAN filtering and offloading masters
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ac8c025-a66a-1591-a80b-afef95d9a79b@gmail.com>
Date:   Sat, 19 Sep 2020 19:44:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> This series attempts to make DSA VLANs work in the presence of a master
> interface that is:
> - filtering, so it drops VLANs that aren't explicitly added to its
>    filter list
> - offloading, so the old assumptions in the tagging code about there
>    being a VLAN tag in the skb are not necessarily true anymore.
> 
> For more context:
> https://lore.kernel.org/netdev/20200910150738.mwhh2i6j2qgacqev@skbuf/
> 
> This probably marks the beginning of a series of patches in which DSA
> starts paying much more attention to its upper interfaces, not only for
> VLAN purposes but also for address filtering and for management of the
> CPU flooding domain. There was a comment from Florian on whether we
> could factor some of the mlxsw logic into some common functionality, but
> it doesn't look so. This seems bound to be open-coded, but frankly there
> isn't a lot to it.

This looks really good to me, thanks!

> 
> Vladimir Oltean (9):
>    net: dsa: deny enslaving 802.1Q upper to VLAN-aware bridge from
>      PRECHANGEUPPER
>    net: dsa: rename dsa_slave_upper_vlan_check to something more
>      suggestive
>    net: dsa: convert check for 802.1Q upper when bridged into
>      PRECHANGEUPPER
>    net: dsa: convert denying bridge VLAN with existing 8021q upper to
>      PRECHANGEUPPER
>    net: dsa: refuse configuration in prepare phase of
>      dsa_port_vlan_filtering()
>    net: dsa: allow 8021q uppers while the bridge has vlan_filtering=0
>    net: dsa: install VLANs into the master's RX filter too
>    net: dsa: tag_8021q: add VLANs to the master interface too
>    net: dsa: tag_sja1105: add compatibility with hwaccel VLAN tags
> 
>   drivers/net/dsa/sja1105/sja1105_main.c |   7 +-
>   include/linux/dsa/8021q.h              |   2 +
>   net/dsa/port.c                         |  58 +++++++--
>   net/dsa/slave.c                        | 156 ++++++++++++++++++-------
>   net/dsa/switch.c                       |  41 -------
>   net/dsa/tag_8021q.c                    |  20 +++-
>   net/dsa/tag_sja1105.c                  |  21 +++-
>   7 files changed, 206 insertions(+), 99 deletions(-)
> 

-- 
Florian
