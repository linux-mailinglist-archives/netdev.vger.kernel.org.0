Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9421C635
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGKUiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgGKUit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:38:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87177C08C5DD;
        Sat, 11 Jul 2020 13:38:49 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x9so3680114plr.2;
        Sat, 11 Jul 2020 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s18ZnoqY14oQyb9zsNB7IKskd4ciL3caDyG6Woi/AEM=;
        b=vJ5Xx45aOYtTCOtQgboD0wLF0wV9VohKeH2qAMq4yEjkW02oxAWFOPgFYZQmJTNqeb
         Gdt5Usk0Ww0H7RhAydlb9TqQ05BDZ6fk4PLCJUSxgdM8ZrdtaHGo+OJeupVhBBLPHD+R
         jiPz08e1/i50s9oi/4hBd6sXJafTcdEUgrqdy9IaD1RQ83GapK1LqgW0OxCeItkGfugb
         c0py6C2BIyo/iNAEwO8TRhqqL2Gj/0vjSlx/ZSXARA4Ot8AtpKkjrodivMlROyLWfHUk
         Q9uZYT68DNkPv2RCqnlj13Fh5Kv9VgVL3Pj4QUKk0f28mmPYBdt6Q7qm4R7Hl/x6RCaf
         8x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s18ZnoqY14oQyb9zsNB7IKskd4ciL3caDyG6Woi/AEM=;
        b=cN+yv4k04aoLVlAuJ/QZyo25KNCqLFPu6calaBhC/PgPJXWUTytrQcH5MmaYKpaCSY
         lSWmFLbNWpz1+0153luzyQRIFuxhJvGwf+h6vozrEcngGrntChrtw5Toa0ACeg4/lgN5
         AQsNvM8EgnS1bIuLpcK1YkKnlpRL7evrqaSzT3UaG+8Aqq5nA3m7AHLfttKxljQumFnh
         lcG0x0Z+kq5XYbUvkH0yzu4q9D015N8OOg1xQmYvYvpIEMMrI+kATykp4sRVSlsm+q5Q
         SOCw4ArLoCA0B/3oR7yd7i7yodOq+43k2JDC0LL9FF66/Y3/Az+Xs/ooVooVUciabD25
         XsLg==
X-Gm-Message-State: AOAM530h8msf2NVAXoZMDrrSrMe1qMtfB8pVtU37TL9DFrnRmanAQe/F
        9AKbfdVpd1uMEokYmnU9z+8=
X-Google-Smtp-Source: ABdhPJwWfWJAxremhzhnn13oaBl/bg81BqdpITPFKNL6p1V8x/ck3m+nmRaM+Z1pyyLjP5gSMNYdEQ==
X-Received: by 2002:a17:902:6194:: with SMTP id u20mr66275217plj.333.1594499929025;
        Sat, 11 Jul 2020 13:38:49 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id d25sm8869503pgn.2.2020.07.11.13.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 13:38:48 -0700 (PDT)
Subject: Re: [PATCH v1 3/8] net: dsa: hellcreek: Add PTP clock support
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-4-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <01981d4a-6e28-2789-6d15-5d825e7ce09b@gmail.com>
Date:   Sat, 11 Jul 2020 13:38:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710113611.3398-4-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> 
> The switch has internal PTP hardware clocks. Add support for it. There are three
> clocks:
> 
>  * Synchronized
>  * Syntonized
>  * Free running
> 
> Currently the synchronized clock is exported to user space which is a good
> default for the beginning. The free running clock might be exported later
> e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The switch
> also supports cross time stamping for that purpose.
> 
> The implementation adds support setting/getting the time as well as offset and
> frequency adjustments. However, the clock only holds a partial timeofday
> timestamp. This is why we track the seconds completely in software (see overflow
> work and last_ts).
> 
> Furthermore, add the PTP multicast addresses into the FDB to forward that
> packages only to the CPU port where they are processed by a PTP program.
> 
> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Are not you missing an depends on PTP_1588_CLOCK somewhere?

> ---

[snip]

>  
> +static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
> +{
> +	static struct hellcreek_fdb_entry ptp = {
> +		/* MAC: 01-1B-19-00-00-00 */
> +		.mac	      = { 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 },
> +		.portmask     = 0x03,	/* Management ports */

Should not this depend on the actual number of ports enabled by the user
and so it would be more logical to program those entries (or update
them) at port_enable() time?
-- 
Florian
