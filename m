Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B0290F58
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411792AbgJQFfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411748AbgJQFen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:34:43 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBDDC0613A7;
        Fri, 16 Oct 2020 17:48:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x7so5847846eje.8;
        Fri, 16 Oct 2020 17:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ua2AZ2Oeg9ewqA0Si3AkIz4WRNl/Q2mfMB0KJrjvhWY=;
        b=uUqHvywJ4GS5x9oDzvgNuIg90FGhdNqaQgCMHgxjpw45tpi34MNDwt4s22Pxeay58Y
         ujr4iqHG6RbIXO+2EZqSWTzH3aEpz0Mgj4cnakrg0lFeDXs+Xu5Zt05zoJdANtopnbxF
         tCBBVD3+0CLMQMTsYUMegL844PryMkQ1229MKI+1MMq4vg39zbGA1Nv9jkr2l74gfWMz
         VMLpnROG2RhB4Ql8m/yZ9BW+I8oDO5v7leu7r5x/1y0Iq53NEyHwgaEhK/5IyZB6Ch8b
         GhiQ33U3GMiqBMdiQCnen1aPahXyFCv6zyJoc7OjbcsXlQcPiE0q3Jy0vgQj7I34eYFs
         5bSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ua2AZ2Oeg9ewqA0Si3AkIz4WRNl/Q2mfMB0KJrjvhWY=;
        b=uAlV+uik/qawGdNa/4aQn+Gx4Io9fdtlXUZcUKB6TAh3mFjKHhiSNZfcbBU1HZPNfy
         +MRSNmJaSpqPF8X9Lgyx+2UzESY0atNvuEf+UdiVz0UdpFEf544g2FrqYT3itOEhFPcQ
         H0VYRgmhMQt7tnHXTHCijJA6e95tYfkkY7aNVqlkYpI7lEp+86sRLU+rg8l5E7VU5Opb
         blTfNc1jkXutFTft8z+XvSkMqetSje4lcSiqrzwmVBDgfotnZgUGU6N0IonVtEGvRkrz
         Ajv+flI04b9426ztcVsl/Ntt8XoeSf2a3Y6ngDh1cx5bKNXysWNukSTYeH/v088gadLp
         VgnA==
X-Gm-Message-State: AOAM530jJN+H1FzUzpNtTrJS+aEFkLNE1LN4UnP98BJv9rA8xbwEdKiv
        EOThw3XChWgFlvkAiLOlH3I=
X-Google-Smtp-Source: ABdhPJzn4nNS0j7LhCADf/vRymr8pWItLqMkNIvB2wdUC712nx3iIG29qbmvY0bg9osr7Jp5j/DpQg==
X-Received: by 2002:a17:906:1a11:: with SMTP id i17mr6338496ejf.381.1602895698730;
        Fri, 16 Oct 2020 17:48:18 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id si13sm3326957ejb.49.2020.10.16.17.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 17:48:18 -0700 (PDT)
Date:   Sat, 17 Oct 2020 03:48:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to
 drivers xmit function
Message-ID: <20201017004816.q4l6cypw4fd4vu5f@skbuf>
References: <20201016200226.23994-1-ceggers@arri.de>
 <20201016200226.23994-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016200226.23994-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 10:02:24PM +0200, Christian Eggers wrote:
> Ensure that the skb is not cloned and has enough tail room for the tail
> tag. This code will be removed from the drivers in the next commits.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Does 1588 work for you using this change, or you haven't finished
implementing it yet? If you haven't, I would suggest finishing that
part first.

The post-reallocation skb looks nothing like the one before.

Before:
skb len=68 headroom=2 headlen=68 tailroom=186
mac=(2,14) net=(16,-1) trans=-1
shinfo(txflags=1 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x9d6927ec sw=1 l4=0) proto=0x88f7 pkttype=0 iif=0
dev name=swp2 feat=0x0x0002000000005020
sk family=17 type=3 proto=0

After:
skb len=68 headroom=2 headlen=68 tailroom=186
mac=(2,16) net=(18,-17) trans=1
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0

Notice how you've changed shinfo(txflags), among other things.

Which proves that you can't just copy&paste whatever you found in
tag_trailer.c.

I am not yet sure whether there is any helper that can be used instead
of this crazy open-coding. Right now, not having tested anything yet, my
candidates of choice would be pskb_expand_head or __pskb_pull_tail. You
should probably also try to cater here for the potential reallocation
done in the skb_cow_head() of non-tail taggers. Which would lean the
balance towards pskb_expand_head(), I believe.

Also, if the result is going to be longer than ~20 lines of code, I
strongly suggest moving the reallocation to a separate function so you
don't clutter dsa_slave_xmit.

Also, please don't redeclare struct sk_buff *nskb, you don't need to.
