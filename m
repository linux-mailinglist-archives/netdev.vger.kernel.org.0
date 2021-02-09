Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240773159C4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhBIWz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbhBIWcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:32:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EACC0698C1;
        Tue,  9 Feb 2021 13:29:31 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z9so2442340pjl.5;
        Tue, 09 Feb 2021 13:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vFu+OipBrwtEdIo/aozLlKqEGgMlKw0YEDC3frRkzXg=;
        b=QQjJX0ebki87Ij2npL/1hztxP0SlB1hFS2lx86A5ddBWb7dy5CFwnMK4/Gb4226EIh
         3plOOlZETAlifZAk7yaFMarQDc+8XCwP4JaHqLnsNOOydjU7VLyKCfbIIkfpEKKnJQzC
         SxfSI4yxgIzQt9BI5ICWE+LnMM+CvoE94nv4eJMYTNU99DK8CQZUGRUFKoB9cajUP8AG
         jy+sp8sRvpyXSQCPzydklhSflwqFXQFf3Iig/u2cqQhl31nUWjJTGxSEUH+65s8YzL0o
         MYWe86Rh7OB0i3x/kB3TLKhYpjc0HMwBHzaFB5BAGO+QP+qvad8xRsCIzINft7hduZDT
         YiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vFu+OipBrwtEdIo/aozLlKqEGgMlKw0YEDC3frRkzXg=;
        b=HJIsr8bbSU2MZIoMH9LcT5mX7RE6CisTG4vpSg8h3c9F6zag9yApEqJUlxDa7k3xOh
         87lhyJdB3v+oFkNJItEbvoBbz0Ry+W5w/iYFP7ys6AazBNTGyPXfmjvOrcDqfbsIhsNX
         N5qCGVRwJ3+0mzvgmO5r1rOI4FeOuRRbWg/SCYFUJD+e/iK0aMoeVSh+Z97uSe2Jp8B3
         T9O9QfXYgjzqRUBK5uRNuKVUCXXkqBwx56pz5k0agYUlXX9gZGjkxkIpN00Ge/836uGL
         8cHVPQSXEk1xoS6S0YbW643Js2CwVKgL5W0GJfpdiXPXtPo3SDpgdupgcY68bo1KwEga
         ovpA==
X-Gm-Message-State: AOAM532C3teNO00BYPxKOZyCX0VhJYHL5epSde/L20N7HpgRqs9bDD1B
        tv8/JvOOr3QR3wie/fsPeXZ7ArT9pF4=
X-Google-Smtp-Source: ABdhPJxmXjN5Umg8s/WQTtR/cfUP5tk/mH7Ayxd2RJiqGkYFvvdDDJD3InqKka61E/JPqBcRQPgoZg==
X-Received: by 2002:a17:902:6b45:b029:e0:7a3:a8c with SMTP id g5-20020a1709026b45b02900e007a30a8cmr23455554plt.1.1612906170985;
        Tue, 09 Feb 2021 13:29:30 -0800 (PST)
Received: from [10.67.49.228] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j3sm335pjs.50.2021.02.09.13.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 13:29:30 -0800 (PST)
Subject: Re: [PATCH v2 net-next 07/11] net: dsa: kill .port_egress_floods
 overengineering
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-8-olteanv@gmail.com>
 <20210209203724.t3gvjdzhxbkt3qu2@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <7f907d89-542f-2652-7cf6-ea196f754eac@gmail.com>
Date:   Tue, 9 Feb 2021 13:29:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209203724.t3gvjdzhxbkt3qu2@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 12:37 PM, Vladimir Oltean wrote:
> On Tue, Feb 09, 2021 at 05:19:32PM +0200, Vladimir Oltean wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> The bridge offloads the port flags through a single bit mask using
>> switchdev, which among others, contains learning and flooding settings.
>>
>> The commit 57652796aa97 ("net: dsa: add support for bridge flags")
>> missed one crucial aspect of the SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS API
>> when designing the API one level lower, towards the drivers.
>> This is that the bitmask of passed brport flags never has more than one
>> bit set at a time. On the other hand, the prototype passed to the driver
>> is .port_egress_floods(int port, bool unicast, bool multicast), which
>> configures two flags at a time.
>>
>> DSA currently checks if .port_egress_floods is implemented, and if it
>> is, reports both BR_FLOOD and BR_MCAST_FLOOD as supported. So the driver
>> has no choice if it wants to inform the bridge that, for example, it
>> can't configure unicast flooding independently of multicast flooding -
>> the DSA mid layer is standing in the way. Or the other way around: a new
>> driver wants to start configuring BR_BCAST_FLOOD separately, but what do
>> we do with the rest, which only support unicast and multicast flooding?
>> Do we report broadcast flooding configuration as supported for those
>> too, and silently do nothing?
>>
>> Secondly, currently DSA deems the driver too dumb to deserve knowing that
>> a SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute was offloaded, because it
>> just calls .port_egress_floods for the CPU port. When we'll add support
>> for the plain SWITCHDEV_ATTR_ID_PORT_MROUTER, that will become a real
>> problem because the flood settings will need to be held statefully in
>> the DSA middle layer, otherwise changing the mrouter port attribute will
>> impact the flooding attribute. And that's _assuming_ that the underlying
>> hardware doesn't have anything else to do when a multicast router
>> attaches to a port than flood unknown traffic to it. If it does, there
>> will need to be a dedicated .port_set_mrouter anyway.
>>
>> Lastly, we have DSA drivers that have a backlink into a pure switchdev
>> driver (felix -> ocelot). It seems reasonable that the other switchdev
>> drivers should not have to suffer from the oddities of DSA overengineering,
>> so keeping DSA a pass-through layer makes more sense there.
>>
>> To simplify the brport flags situation we just delete .port_egress_floods
>> and we introduce a simple .port_bridge_flags which is passed to the
>> driver. Also, the logic from dsa_port_mrouter is removed and a
>> .port_set_mrouter is created.
>>
>> Functionally speaking, we simply move the calls to .port_egress_floods
>> one step lower, in the two drivers that implement it: mv88e6xxx and b53,
>> so things should work just as before.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
> 
> Florian, Andrew, what are your opinions on this patch? I guess what I
> dislike the most about .port_egress_floods is that it combines the
> unicast and multicast settings in the same callback, for no good
> apparent reason. So that, at the very least, needs to change.
> What do you prefer between having:
> 	.port_set_unicast_floods
> 	.port_set_multicast_floods
> 	.port_set_broadcast_floods
> 	.port_set_learning
> and a single:
> 	.port_bridge_flags

Tough one, from a driver writer perspective the fewer callbacks to wire
up the better, but from a framework perspective it is certainly easier
to audit drivers if there is a callback for a narrow and specific use
case. My vote goes for the single callback, that would lead to an easier
patch set to review IMHO.
-- 
Florian
