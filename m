Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D531AEC8
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 04:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBNDCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 22:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBNDCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 22:02:36 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529DFC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 19:01:50 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id v193so4216274oie.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 19:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w6XknGpNNtBelm0Clwz6M1WNlLhaJQGF3+9lbK+JHC0=;
        b=h3gH5r84mjdZjx14z5EyUHa9j8C3nhybSsIl3mf1OruSkynRDP2wr+ODGNeDnA+3iB
         FEgingsj9GLlKWckjLha4znaiV7JB4eBdtgt0D88d/BjEwgErMumktj7wtrhl+aSjunS
         ac9kDMsA3v05rPxPrU8kwdjRuMSkwdK1CvTSaB6yBmUfXjmlSbO/7yW6kRLQjOjNC1c1
         kYbmq2PGvnliN8HRuThZx8q0CI2Wy8AaRrWXK08ijOmmBHXKhKF47bqY63Zm0wM/elrN
         pd/bOKdsbpq1CK77cZWKdabLHvNaLIQyH4vNfiYXqh8JgVv7xWDvikqYrZo7lxvDYXhv
         AuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w6XknGpNNtBelm0Clwz6M1WNlLhaJQGF3+9lbK+JHC0=;
        b=YHemamUdiOoGLfFyl9B6iuqZ5I2q3G5QM/ZSSeqCA6dwm3r9Qogmwr7OnuAlsuveW5
         42GieSuc1RRbPjDdAR8EwALnraa9j34RC0Gw8TD4CTkDRcmAupGTatBlJOd27V+Hd4R2
         ZVM0r2TeYdj03o3azqpWKYENp0lS+T3bBQZyjxpYReH8Pm4iRPJHTsHloMGcsan62g6/
         O1uIz5+2zdjusWqVQ5sgXBo8n3i/M0YMTzMDa7tNhACGlbXxIPGh00EeFqBFMdwIX7nT
         vPjDj44kRDmZMEcDbX+JRYpU4rDa2QNXUyKaUKX//huXxYO8ZwON9kVKaOUaU9KK7hxb
         OLjw==
X-Gm-Message-State: AOAM530qx76qWgWxAbU4F3xYly+jOfkk84l6ifVuqo3RoYstIDy00r5a
        2k+A36uWNobPcEkXo68OdHc=
X-Google-Smtp-Source: ABdhPJyOifL+29jNIeOQcWC0NeNXZyLuvMlgKHuvvf60iSeYreKiqNL0BdQudtaHhE7dW+nUXb2tig==
X-Received: by 2002:a05:6808:bc3:: with SMTP id o3mr4428397oik.134.1613271709622;
        Sat, 13 Feb 2021 19:01:49 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id v16sm2872458oia.26.2021.02.13.19.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 19:01:49 -0800 (PST)
Subject: Re: [PATCH v2 net-next 11/12] net: dsa: felix: setup MMIO filtering
 rules for PTP when using tag_8021q
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-12-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0569a4d6-155d-592b-deee-17b6113ee90e@gmail.com>
Date:   Sat, 13 Feb 2021 19:01:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-12-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:38, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the tag_8021q tagger is software-defined, it has no means by
> itself for retrieving hardware timestamps of PTP event messages.
> 
> Because we do want to support PTP on ocelot even with tag_8021q, we need
> to use the CPU port module for that. The RX timestamp is present in the
> Extraction Frame Header. And because we can't use NPI mode which redirects
> the CPU queues to an "external CPU" (meaning the ARM CPU running Linux),
> then we need to poll the CPU port module through the MMIO registers to
> retrieve TX and RX timestamps.
> 
> Sadly, on NXP LS1028A, the Felix switch was integrated into the SoC
> without wiring the extraction IRQ line to the ARM GIC. So, if we want to
> be notified of any PTP packets received on the CPU port module, we have
> a problem.
> 
> There is a possible workaround, which is to use the Ethernet CPU port as
> a notification channel that packets are available on the CPU port module
> as well. When a PTP packet is received by the DSA tagger (without timestamp,
> of course), we go to the CPU extraction queues, poll for it there, then
> we drop the original Ethernet packet and masquerade the packet retrieved
> over MMIO (plus the timestamp) as the original when we inject it up the
> stack.
> 
> Create a quirk in struct felix is selected by the Felix driver (but not
> by Seville, since that doesn't support PTP at all). We want to do this
> such that the workaround is minimally invasive for future switches that
> don't require this workaround.
> 
> The only traffic for which we need timestamps is PTP traffic, so add a
> redirection rule to the CPU port module for this. Currently we only have
> the need for PTP over L2, so redirection rules for UDP ports 319 and 320
> are TBD for now.
> 
> Note that for the workaround of matching of PTP-over-Ethernet-port with
> PTP-over-MMIO queues to work properly, both channels need to be
> absolutely lossless. There are two parts to achieving that:
> - We keep flow control enabled on the tag_8021q CPU port
> - We put the DSA master interface in promiscuous mode, so it will never
>    drop a PTP frame (for the profiles we are interested in, these are
>    sent to the multicast MAC addresses of 01-80-c2-00-00-0e and
>    01-1b-19-00-00-00).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
