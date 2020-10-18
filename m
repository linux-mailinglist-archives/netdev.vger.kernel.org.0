Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FF32917D1
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgJRONi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 10:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgJRONi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 10:13:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAC2C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 07:13:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x7so10235295eje.8
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 07:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jgNXt7/bSD04096oK/hpMiX5eLH0klgCEI1ucnUAme0=;
        b=Sg1GPq+5KfzzemBxrqEPDImqdeJHHL+q+Tx7k5ZWGeHS5MynOE2fhGMzPseJQu9LdL
         uCAd1Q2cVDo/c6llMsSN0LhZCYqoCoN+0Zp/LPuR08ugV8LdN5GzdpvzaJ8Ue+I+kFBY
         kGnPW3H+WwZ6zRcRdBtnlVdHy5Nm9H8nYSS55wufWQgVlaTxxpSwgsSawbLay1m2dcb/
         zOxcHzpnHUVYYOkkJ9Dilr5rcuHDA1a/7TXoEKuETS6gSAMKzTyKiSpMVCGC+eEa/OQw
         52lfVTBSVpi5wCNZcfLlCc0rwylPvkmfQy+93AYszTekQxIdq7VZ9dc/QTcT2PTOzacX
         s5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jgNXt7/bSD04096oK/hpMiX5eLH0klgCEI1ucnUAme0=;
        b=Rhg3B7rDHymaAu6ao7w9F74cdDmqgllKVjIfQ9JmNpqZXHAMAY5uO0ePapBlUPLdEe
         n2RHm3UDk8dcA5adBHRzrA3dtYIkomokG1ROWAxiyQvG5P5EsKpz6nT8AQjaxZ5KsJrE
         yg6AdgCRw6Po1yR41STadoQ7ReIEx5D0dRfjJcVXn+Q79yFPQBNL7L5Mqe2CNTJvuhAl
         W7bsT3XU5APLs/z2gEERwemilPi0BvEpfTavNW9CfqlOta4tX9jTDrorlhFq8czmHtC3
         gRbwAVDSm+qJzceU//Flv1NpZZGN9dLXn7assfBvId9ZHT45K+Bf16rXDl/Rrnb7+xP+
         LAvA==
X-Gm-Message-State: AOAM533AgHo8GToiKi+DRIgnjkt9I6e3wF/Grsc0oyzU5mdxkHl/kxlA
        6iick/BwXrKcgQuVlhuUKCU=
X-Google-Smtp-Source: ABdhPJxeCAZvQc491czsTROSexJSnyngZzLBaTdjX1yEfK+6bYxYbO/Nq2hUG1naJHnDBvdbg5BrHw==
X-Received: by 2002:a17:906:38c9:: with SMTP id r9mr13672569ejd.9.1603030415062;
        Sun, 18 Oct 2020 07:13:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id m6sm8005341ejl.94.2020.10.18.07.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 07:13:34 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
Date:   Sun, 18 Oct 2020 16:13:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018134843.emustnvgyby32cm4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2020 15:48, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 03:09:32PM +0200, Heiner Kallweit wrote:
>> On 18.10.2020 14:16, Vladimir Oltean wrote:
>>> On Sun, Oct 18, 2020 at 02:02:46PM +0200, Heiner Kallweit wrote:
>>>> Wouldn't a simple unsigned long (like in struct net_device_stats) be
>>>> sufficient here? This would make handling the counter much simpler.
>>>> And as far as I understand we talk about a packet counter that is
>>>> touched in certain scenarios only.
>>>
>>> I don't understand, in what sense 'sufficient'? This counter is exported
>>> to ethtool which works with u64 values, how would an unsigned long,
>>> which is u32 on 32-bit systems, help?
>>>
>> Sufficient for me means that it's unlikely that a 32 bit counter will
>> overflow. Many drivers use the 32 bit counters (on a 32bit system) in
>> net_device_stats for infrequent events like rx/tx errors, and 64bit
>> counters only for things like rx/tx bytes, which are more likely to
>> overflow.
> 
> 2^32 = 4,294,967,296 = 4 billion packets
> Considering that every packet that needs TX timestamping must be
> reallocated, protocols such as IEEE 802.1AS will trigger 5 reallocs per
> second. So time synchronization alone (background traffic, by all
> accounts) will make this counter overflow in 27 years.
> Every packet flooded or multicast by the bridge will also trigger
> reallocs. In this case it is not difficult to imagine that overflows
> might occur sooner.
> 
> Even if the above wasn't true. What becomes easier when I make the
> counter an unsigned long? I need to make arch-dependent casts between an
> unsigned long an an u64 when I expose the counter to ethtool, and there
> it ends up being u64 too, doesn't it?
> 

Access to unsigned long should be atomic, so you could avoid the
following and access the counter directly (like other drivers do it
with the net_device_stats members). On a side note, because I'm also
just dealing with it: this_cpu_ptr() is safe only if preemption is
disabled. Is this the case here? Else there's get_cpu_ptr/put_cpu_ptr.
Also, if irq's aren't disabled there might be a need to use
u64_stats_update_begin_irqsave() et al. See:
2695578b896a ("net: usbnet: fix potential deadlock on 32bit hosts")
But I don't know dsa good enough to say whether this is applicable
here.

+	e = this_cpu_ptr(p->extra_stats);
+	u64_stats_update_begin(&e->syncp);
+	e->tx_reallocs++;
+	u64_stats_update_end(&e->syncp);

+		e = per_cpu_ptr(p->extra_stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&e->syncp);
+			tx_reallocs	= e->tx_reallocs;
+		} while (u64_stats_fetch_retry_irq(&e->syncp, start));

