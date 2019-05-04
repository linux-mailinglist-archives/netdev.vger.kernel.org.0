Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54B136F6
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfEDCA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:00:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34935 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:00:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id t87so3209292pfa.2;
        Fri, 03 May 2019 19:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sW39XxwT6QxdvhUrZmgvyJobiq2om+iJ0XiMpRypi+g=;
        b=rLp3wy5KDzDEvPVw74Y+MqMi9ViwScosjL3tXLCkJu1N2ysh07L4YXyvysO+5tebTy
         zA7nrLg16SC7p8WcX6po5VTR4cOaioXJPCeVtiWT3y1mZLkR7lVlS+nZGkvVnD9zhJcv
         qvK8iDtaoKb7vNCxbcAmpj/jSZklnm5cay1TLliQBSCs81dbanlAhF2rTSjrHM6j5Zr5
         uFGkREMQdxtUYdCwsTQhCI/yfPx9hLeq5HsRv3j5Ue2Ey1cN+uSp02+94lZXai6/4eOH
         pqIU1ZzNaMcqYo3r+7293R1PhYdSN/j7Fi6KY92s1O63buAXSkyNQK5GgPODroEgMv2G
         Kd4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sW39XxwT6QxdvhUrZmgvyJobiq2om+iJ0XiMpRypi+g=;
        b=NHeXkMep6PVzPVGEIb0M+aRuNt+eZoCzY4O+3UgaqCRZmFwt2DCJBwCdjYuEK+ebLa
         TS8sGKiNGLzfsbSocU8Au2LMnz+qZtMn6/c64IlKzx5JLcBNqXuWK8LzJ4pb00chWk0l
         6R6ySSIt0Wjn3k9dEF7EfBocCmy6KkpOUrwXZJH0d8CgwI9g6q5Q3X/4YOU/YriRrQ2z
         pKro5qqVxjb6b60ZwG8tnxMrx8RVV+bkND6trORJcWNt/zq6KLZc5QgPgBuMkMir+A8C
         35tTIYrerMLHu8MU/01eLoYv+9KmEYoRqrqShKRkxGLgt4n0OV1xSn8UAqF9PvFUvyD+
         gl+w==
X-Gm-Message-State: APjAAAUCDk806EirkCVWiCpM7eiHLdDZLmIFXypSPFFWDcHF88Bj/125
        KJvLHJGnVkIcSoA95ZC5T2NQhdum
X-Google-Smtp-Source: APXvYqybv9eWUjV7PPH4WD029y5MbVvqkeaCkgFrqj8jVjI3TI5K6ELDl5flVVaTjzR+Y56s1Eh89g==
X-Received: by 2002:a62:b411:: with SMTP id h17mr15529149pfn.61.1556935257555;
        Fri, 03 May 2019 19:00:57 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id n11sm3711061pgq.8.2019.05.03.19.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:00:56 -0700 (PDT)
Subject: Re: [PATCH net-next 3/9] net: dsa: Allow drivers to filter packets
 they can decode source port from
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <dcf251bc-ace1-4a3e-d500-54c916fcfdbb@gmail.com>
Date:   Fri, 3 May 2019 19:00:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> Frames get processed by DSA and redirected to switch port net devices
> based on the ETH_P_XDSA multiplexed packet_type handler found by the
> network stack when calling eth_type_trans().
> 
> The running assumption is that once the DSA .rcv function is called, DSA
> is always able to decode the switch tag in order to change the skb->dev
> from its master.
> 
> However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
> user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
> true, since switch tagging piggybacks on the absence of a vlan_filtering
> bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
> rely on switch tagging, but on a different mechanism. So it would make
> sense to at least be able to terminate that.
> 
> Having DSA receive traffic it can't decode would put it in an impossible
> situation: the eth_type_trans() function would invoke the DSA .rcv(),
> which could not change skb->dev, then eth_type_trans() would be invoked
> again, which again would call the DSA .rcv, and the packet would never
> be able to exit the DSA filter and would spiral in a loop until the
> whole system dies.
> 
> This happens because eth_type_trans() doesn't actually look at the skb
> (so as to identify a potential tag) when it deems it as being
> ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
> installed (therefore it's a DSA master) and that there exists a .rcv
> callback (everybody except DSA_TAG_PROTO_NONE has that). This is
> understandable as there are many switch tags out there, and exhaustively
> checking for all of them is far from ideal.
> 
> The solution lies in introducing a filtering function for each tagging
> protocol. In the absence of a filtering function, all traffic is passed
> to the .rcv DSA callback. The tagging protocol should see the filtering
> function as a pre-validation that it can decode the incoming skb. The
> traffic that doesn't match the filter will bypass the DSA .rcv callback
> and be left on the master netdevice, which wasn't previously possible.

I can't come up with a different solution either:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Maybe one day we will have in-kernel BPF filter for parsing DSA tags
(similar to PTP) and then we can preserve the layering while leveraging
the power of BPF!
-- 
Florian
