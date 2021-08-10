Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE10D3E5722
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbhHJJhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhHJJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:37:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EAAC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:37:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so4422600pjb.2
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Yr15xQvfPLBcizpYjWCLJ6EZ81n3gfhy5YO2ARrcAM=;
        b=fQevwuQRRKpb8Tj+B339RveKG4yf93jjcGw/baNTvnPDdvw+PfgUlSIib/8M4c/tlB
         qNT9RnKi67EiY88UAQl87D6uEPGAv9R9aL0xxm2S9ohOIE7Ta1gEJuOONglRydLIYPE1
         gE/LkVaJ5KqlKFvmucJSLzi2SlJRRKG+kYOe0hVobfULo0mOvS7ylviCyaiy6dTiDRPt
         hS0KKzmzAlw7+kIxhYJMfHho6iny+007sVYuGWfinyZC1Zf4K9xGlMC2R7T+NHJeHil5
         672O4nzmrfMmzRvMdJniTjJbTKK/hyisJsWmqRhZ9Hf6qDFrOeMr4BWk48iw+7vg1F1X
         YQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Yr15xQvfPLBcizpYjWCLJ6EZ81n3gfhy5YO2ARrcAM=;
        b=m7wzgPxN70kivqtnizwdbiPAZO7n7eY3ltAXvUw48p/bpBi/fxQHrxNjvGlUcLrh8V
         06/Djrn+8pWP/vhKT3KkoyT5NgSQpKoSa896HriWMpewRlR6ovX+tGq6kIqVlHmRMxOG
         fCDRMUV//mBwQJFoa2iSUenzDdXDsyH++jwLmK+nxpvfQFwoztEDKF66o2J2hiI2aoJM
         +TA6MJUQPJpHLs/mfBvymdsCwlA1ltASNE0jw7hddCZs+vlYsvSjjLuo7PTxS5lbFe/i
         FzoONCRuNgnPoTRE042BpkxAzvDE/G3J3lt9ek/bgGF5VccUSGB49u8E4A+Ul65YIvsZ
         Rywg==
X-Gm-Message-State: AOAM530DgLfRHMeebnleetsFiYUM0rB7ETbrLDO9miQ4eX8Rr+Ma4gPk
        i2CROc1YQq6WIpNPvRM3eT0=
X-Google-Smtp-Source: ABdhPJzIsNB1TmeTtt2ixisFb6DOib379NfBgaVJVfPwikjWT1RCUp83f7lEOkAlN1B6V9O7V3zj6w==
X-Received: by 2002:a63:c14a:: with SMTP id p10mr168379pgi.311.1628588232226;
        Tue, 10 Aug 2021 02:37:12 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id r10sm22568343pff.7.2021.08.10.02.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:37:11 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a
 loop" antipattern from the core
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <30cef704-7703-7e91-6f00-7a92f678a916@gmail.com>
Date:   Tue, 10 Aug 2021 02:37:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809190320.1058373-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 12:03 PM, Vladimir Oltean wrote:
> Ever since Vivien's conversion of the ds->ports array into a dst->ports
> list, and the introduction of dsa_to_port, iterations through the ports
> of a switch became quadratic whenever dsa_to_port was needed.
> 
> dsa_to_port can either be called directly, or indirectly through the
> dsa_is_{user,cpu,dsa,unused}_port helpers.
> 
> Introduce a basic switch port iterator macro, dsa_switch_for_each_port,
> that works with the iterator variable being a struct dsa_port *dp
> directly, and not an int i. It is an expensive variable to go from i to
> dp, but cheap to go from dp to i.
> 
> This macro iterates through the entire ds->dst->ports list and filters
> by the ports belonging just to the switch provided as argument.
> 
> While at it, provide some more flavors of that macro which filter for
> specific types of ports: at the moment just user ports and CPU ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
