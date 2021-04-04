Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3DB353636
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 04:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhDDCdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 22:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhDDCdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 22:33:13 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89D5C061756;
        Sat,  3 Apr 2021 19:33:09 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id i81so8609042oif.6;
        Sat, 03 Apr 2021 19:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9kK4JLftKzlx8Dd9WsCAD10DkpUFDpGIS6PjT+XywEg=;
        b=B6gGGFGhaC1KefgVKVBye+qwFkxvOzewH3KW6fIbSLw2tLYGss+OPaUlkLzTuWpoOb
         Jbm3dHMKyeJnIOlzZiD9OFEYswE5tPps4NJsQMoRDpElr+mfAxGp2UjMb9Lr+IUWQVIg
         p7v6xjerEfqhnr/pcy6Zh7Cdnx7bIrQIeVTnoq/J+Dg6No3iDHnmxTmDeZY68WcQmCt9
         Udr9R8EOTLoE2Q+e3D84imq+Z8y2vXsziBiOiKJZod1I4u3FtU6MSJ9nJ11NCLAt5Lbl
         FJ/MrX2E6Q2v4KdAJnnZ9Nr4Z3rDY79rYk371iZJoVfJuhWeQJCOELeO/kDYQpO3F16v
         1+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9kK4JLftKzlx8Dd9WsCAD10DkpUFDpGIS6PjT+XywEg=;
        b=eCUFEpNuZqkIIe+R720kXC2+EZaLTYNDBtFtNwxu5YKvcc+Efwx9Dys7/IUUG3Wnjy
         ag2br44LqInScWnlFnr48q9sKKQONARRwQ+01I/E3BCxbZPPSboF4SFgm9K+dkhE8OJ7
         mP3jQcvrJGKItc+jvXX3rKCerNk4s55QNwN3pbLQodHc5Z7OaqZdVWUK6iV88qZtBOjm
         aLItdqF9iEVqJPyKTk9LuyD8oJ3qPD2hZ4uMG3Yq11Gc9LMNKiqA44PkEMKo+NelaIrA
         2c4gCqvOyBeO22DjYW8SDxoF1p03U/g2lfNReUdQV40Y/8viepX86OjtRA+xjXEdETNA
         CyRw==
X-Gm-Message-State: AOAM533xIbOurgdVe2giEToErsFIeQNLHV68n/Pxnsjj3mkNz42otvdH
        bzqkneSB9+65n1P6BSPzDLMTbRdc3fE=
X-Google-Smtp-Source: ABdhPJzC3HWE2ylpgtXM5qJiE/qVb1ttVbl9OIJRl6FWVl814rQ0ZMfEcz+952a3lS4sYl5pV2HHHw==
X-Received: by 2002:aca:4e83:: with SMTP id c125mr13911341oib.38.1617503588787;
        Sat, 03 Apr 2021 19:33:08 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:d9ea:8934:6811:fd93? ([2600:1700:dfe0:49f0:d9ea:8934:6811:fd93])
        by smtp.gmail.com with ESMTPSA id n10sm2940225otj.36.2021.04.03.19.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 19:33:08 -0700 (PDT)
Subject: Re: [PATCH net-next v1 1/9] net: dsa: add rcv_post call back
To:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-2-o.rempel@pengutronix.de>
 <20210403140534.c4ydlgu5hqh7bmcq@skbuf>
 <20210403232116.knf6d7gdrvamk2lj@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <53d84140-c072-f4ab-2f5c-af5c62abce2d@gmail.com>
Date:   Sat, 3 Apr 2021 19:32:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210403232116.knf6d7gdrvamk2lj@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/3/2021 16:21, Vladimir Oltean wrote:
> On Sat, Apr 03, 2021 at 05:05:34PM +0300, Vladimir Oltean wrote:
>> On Sat, Apr 03, 2021 at 01:48:40PM +0200, Oleksij Rempel wrote:
>>> Some switches (for example ar9331) do not provide enough information
>>> about forwarded packets. If the switch decision was made based on IPv4
>>> or IPv6 header, we need to analyze it and set proper flag.
>>>
>>> Potentially we can do it in existing rcv path, on other hand we can
>>> avoid part of duplicated work and let the dsa framework set skb header
>>> pointers and then use preprocessed skb one step later withing the rcv_post
>>> call back.
>>>
>>> This patch is needed for ar9331 switch.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>
>> I don't necessarily disagree with this, perhaps we can even move
>> Florian's dsa_untag_bridge_pvid() call inside a rcv_post() method
>> implemented by the DSA_TAG_PROTO_BRCM_LEGACY, DSA_TAG_PROTO_BRCM_PREPEND
>> and DSA_TAG_PROTO_BRCM taggers. Or even better, because Oleksij's
>> rcv_post is already prototype-compatible with dsa_untag_bridge_pvid, we
>> can already do:
>>
>> 	.rcv_post = dsa_untag_bridge_pvid,
>>
>> This should be generally useful for stuff that DSA taggers need to do
>> which is easiest done after eth_type_trans() was called.
> 
> I had some fun with an alternative method of parsing the frame for IGMP
> so that you can clear skb->offload_fwd_mark, which doesn't rely on the
> introduction of a new method in DSA. It should also have several other
> advantages compared to your solution such as the fact that it should
> work with VLAN-tagged packets.
> 
> Background: we made Receive Packet Steering work on DSA master interfaces
> (echo 3 > /sys/class/net/eth0/queues/rx-1/rps_cpus) even when the DSA
> tag shifts to the right the IP headers and everything that comes
> afterwards. The flow dissector had to be patched for that, just grep for
> DSA in net/core/flow_dissector.c.
> 
> The problem you're facing is that you can't parse the IP and IGMP
> headers in the tagger's rcv() method, since the network header,
> transport header offsets and skb->protocol are all messed up, since
> eth_type_trans hasn't been called yet.
> 
> And that's the trick right there, you're between a rock and a hard
> place: too early because eth_type_trans wasn't called yet, and too late
> because skb->dev was changed and no longer points to the DSA master, so
> the flow dissector adjustment we made doesn't apply.
> 
> But if you call the flow dissector _before_ you call "skb->dev =
> dsa_master_find_slave" (and yes, while the DSA tag is still there), then
> it's virtually as if you had called that while the skb belonged to the
> DSA master, so it should work with __skb_flow_dissect.
> 
> In fact I prototyped this idea below. I wanted to check whether I can
> match something as fine-grained as an IGMPv2 Membership Report message,
> and I could.
> 
> I prototyped it inside the ocelot tagging protocol driver because that's
> what I had handy. I used __skb_flow_dissect with my own flow dissector
> which had to be initialized at the tagger module_init time, even though
> I think I could have probably just called skb_flow_dissect_flow_keys
> with a standard dissector, and that would have removed the need for the
> custom module_init in tag_ocelot.c. One thing that is interesting is
> that I had to add the bits for IGMP parsing to the flow dissector
> myself (based on the existing ICMP code). I was too lazy to do that for
> MLD as well, but it is really not hard. Or even better, if you don't
> need to look at all inside the IGMP/MLD header, I think you can even
> omit adding this parsing code to the flow dissector and just look at
> basic.n_proto and basic.ip_proto.
> 
> See the snippet below. Hope it helps.

This looks a lot better than introducing hooks at various points in 
dsa_switch_rcv().
-- 
Florian
