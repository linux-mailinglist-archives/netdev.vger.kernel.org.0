Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F0631AECB
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 04:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhBNDHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 22:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBNDHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 22:07:04 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83621C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 19:06:24 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id k10so3088780otl.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 19:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ysxmG6dJEtG/0v3okHLF1VUxolnbF9xg/wYdChM3OUo=;
        b=vO1sW3bC+G+YuqBWMUMLKQtGO9TWCHfLUJgpLCMMM5pMJpqGYXT2wg5oOD04Wqc545
         IBO14KK415c4t4/RB4VAM4W3j9OyjLspL/gm5BsjBtv+K8zmdCHftN64vVmb7mD/yzrc
         gsYyfsATeeSosDd0Pt9JQ7jzPZkFHg5AcdXxfVCn2LILax6RB0y0TImtyu7HyDAZ04Es
         YvMavCNIAIMW5EDRZTxglPc77ZxM9bCfEClilvZ2or7nbyCm/shQjnIqfjk9CUTwmiVc
         jKPhWLIlqKnmYU82PzARcO8GjQsuHfzxHCo5bWS1uKl0lJVObgEYYoFpc1+JV2HNIQvs
         2TCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ysxmG6dJEtG/0v3okHLF1VUxolnbF9xg/wYdChM3OUo=;
        b=CED8eGDE7bFGMY3W15/QlY1t6dZFnR1CT3Ba0YRQpIGGO/JkCOCjQ+NtjbQP8w81fT
         PO73wORuCFcZ3xN9E0tnKTz9S7iolARHqi/XtGVKX2WXWfmZYEJHVb/E8NR70HnG/kXO
         eKndt8H8Jykvp2GFKsXcTSwRcedoS9YjsNJ88i9jWMoE99CP4GSrtdWl9wxqLVGiYzAh
         NpVDFnIIMBIEW6omYaJv+FaCdSFhys6nKVLaRDyxBxgMNj6j8zegrfrgYlpDUfvMZCA4
         XozDBqdgaX4j4ZRbk1dWE4iqnYdvFU2SF8pKSr8SmKAfQ+hhjy9CzQfcgULEhUCbNvJA
         peYw==
X-Gm-Message-State: AOAM531w74NYFG6GEfkXZ7shnrMZuM48z4oeCOvDziQnVEx7KVr+RWPj
        5zfqDnehg64YlVVLlaQm4AA=
X-Google-Smtp-Source: ABdhPJwOG6TkAGU8naZp8E/WLypoakxcIaQkljPUgjtgB4tzvD10IuyQDjR1549sYDqjOvaHJVVy5Q==
X-Received: by 2002:a9d:3284:: with SMTP id u4mr7008675otb.187.1613271983848;
        Sat, 13 Feb 2021 19:06:23 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id 97sm2193181oty.48.2021.02.13.19.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 19:06:22 -0800 (PST)
Subject: Re: [PATCH v2 net-next 12/12] net: dsa: tag_ocelot_8021q: add support
 for PTP timestamping
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
 <20210213223801.1334216-13-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <be06f9be-7f45-02b0-f324-38337b137081@gmail.com>
Date:   Sat, 13 Feb 2021 19:06:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-13-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:38, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> For TX timestamping, we use the felix_txtstamp method which is common
> with the regular (non-8021q) ocelot tagger. This method says that skb
> deferral is needed, prepares a timestamp request ID, and puts a clone of
> the skb in a queue waiting for the timestamp IRQ.
> 
> felix_txtstamp is called by dsa_skb_tx_timestamp() just before the
> tagger's xmit method. In the tagger xmit, we divert the packets
> classified by dsa_skb_tx_timestamp() as PTP towards the MMIO-based
> injection registers, and we declare them as dead towards dsa_slave_xmit.
> If not PTP, we proceed with normal tag_8021q stuff.
> 
> Then the timestamp IRQ fires, the clone queued up from felix_txtstamp is
> matched to the TX timestamp retrieved from the switch's FIFO based on
> the timestamp request ID, and the clone is delivered to the stack.
> 
> On RX, thanks to the VCAP IS2 rule that redirects the frames with an
> EtherType for 1588 towards two destinations:
> - the CPU port module (for MMIO based extraction) and
> - if the "no XTR IRQ" workaround is in place, the dsa_8021q CPU port
> the relevant data path processing starts in the ptp_classify_raw BPF
> classifier installed by DSA in the RX data path (post tagger, which is
> completely unaware that it saw a PTP packet).
> 
> This time we can't reuse the same implementation of .port_rxtstamp that
> also works with the default ocelot tagger. That is because felix_rxtstamp
> is given an skb with a freshly stripped DSA header, and it says "I don't
> need deferral for its RX timestamp, it's right in it, let me show you";
> and it just points to the header right behind skb->data, from where it
> unpacks the timestamp and annotates the skb with it.
> 
> The same thing cannot happen with tag_ocelot_8021q, because for one
> thing, the skb did not have an extraction frame header in the first
> place, but a VLAN tag with no timestamp information. So the code paths
> in felix_rxtstamp for the regular and 8021q tagger are completely
> independent. With tag_8021q, the timestamp must come from the packet's
> duplicate delivered to the CPU port module, but there is potentially
> complex logic to be handled [ and prone to reordering ] if we were to
> just start reading packets from the CPU port module, and try to match
> them to the one we received over Ethernet and which needs an RX
> timestamp. So we do something simple: we tell DSA "give me some time to
> think" (we request skb deferral by returning false from .port_rxtstamp)
> and we just drop the frame we got over Ethernet with no attempt to match
> it to anything - we just treat it as a notification that there's data to
> be processed from the CPU port module's queues. Then we proceed to read
> the packets from those, one by one, which we deliver up the stack,
> timestamped, using netif_rx - the same function that any driver would
> use anyway if it needed RX timestamp deferral. So the assumption is that
> we'll come across the PTP packet that triggered the CPU extraction
> notification eventually, but we don't know when exactly. Thanks to the
> VCAP IS2 trap/redirect rule and the exclusion of the CPU port module
> from the flooding replicators, only PTP frames should be present in the
> CPU port module's RX queues anyway.
> 
> There is just one conflict between the VCAP IS2 trapping rule and the
> semantics of the BPF classifier. Namely, ptp_classify_raw() deems
> general messages as non-timestampable, but still, those are trapped to
> the CPU port module since they have an EtherType of ETH_P_1588. So, if
> the "no XTR IRQ" workaround is in place, we need to run another BPF
> classifier on the frames extracted over MMIO, to avoid duplicates being
> sent to the stack (once over Ethernet, once over MMIO). It doesn't look
> like it's possible to install VCAP IS2 rules based on keys extracted
> from the 1588 frame headers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
