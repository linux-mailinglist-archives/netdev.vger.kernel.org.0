Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75F1B7778
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgDXNtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgDXNtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 09:49:16 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABFDC09B046
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:49:16 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id l11so7736725lfc.5
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sDwVLjRBMPWU6wEqJr0n/7TaaBKOSB8AM8QuUjXpRFg=;
        b=PFmeDn82LqDvfQ32uAq3qNbtzdFMdsCBiPHffUqPmJU35TDpn6p3vUhwu4z9ydA+1w
         bOCnHg07doepYRJy1qQfHA8PfJfz32xzpmPG8epQ8gKLESNSrZIpLVh1OGxeZrRzmyUs
         Akipi/z1KazdqSXjtV6JSC9rJJfEXqhyGF7Tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sDwVLjRBMPWU6wEqJr0n/7TaaBKOSB8AM8QuUjXpRFg=;
        b=jX67yK8kDBVo7caL6hxILN/EsTx5ac82mxQ00ygIGCih7Tg3bhgB/NnmGo+1NJWe73
         WQCF6DFZsfLcBwATRGmu5jkQBZtWr9wPuhtndsc9PNg7We/mNObraxc857iDQlxhyjLi
         r+Izq70Nqet7IV0TcHYsVTCRGwD8Ehu5/yOyGx0yqUDRW0U6p+W4hPA95CZE6I+n/IIh
         9wsaHh3OTNhljPOtnimDjZ1a3t83sEzIVBplfHsbzqjYK9qTCirjMCwKfY9iyevK5OY9
         gB4VFKNtT0Cjt1Yzf4dmEOk1Kbh2UpXbblrp/LxXS5Hbf8wsRzswNcXYHvRm5GibyEUu
         Lx6Q==
X-Gm-Message-State: AGi0PuYSkAWEm06SS4uakt4D5YEF5xT1iWAwNswYQWeu0HfHSHzcw89n
        E0A2+ohms4iwsg3sQijMIQ5OwQ==
X-Google-Smtp-Source: APiQypK0WfE0K8h4OMIWzRhDwx1eUUgoHfJYt5KeqpvgHE+uplakMIQw54Kb+bQu6g5+TtSK95qO8w==
X-Received: by 2002:ac2:5dcf:: with SMTP id x15mr6231405lfq.3.1587736154353;
        Fri, 24 Apr 2020 06:49:14 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b2sm4504085lfi.14.2020.04.24.06.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 06:49:13 -0700 (PDT)
Subject: Re: [PATCH net-next v3 10/11] bridge: mrp: Integrate MRP into the
 bridge
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
 <20200422161833.1123-11-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <4c2200b5-5173-eac3-1cf5-14538a0b5d71@cumulusnetworks.com>
Date:   Fri, 24 Apr 2020 16:49:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422161833.1123-11-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2020 19:18, Horatiu Vultur wrote:
> To integrate MRP into the bridge, the bridge needs to do the following:
> - detect if the MRP frame was received on MRP ring port in that case it would be
>   processed otherwise just forward it as usual.
> - enable parsing of MRP
> - before whenever the bridge was set up, it would set all the ports in
>   forwarding state. Add an extra check to not set ports in forwarding state if
>   the port is an MRP ring port. The reason of this change is that if the MRP
>   instance initially sets the port in blocked state by setting the bridge up it
>   would overwrite this setting.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_device.c  |  3 +++
>  net/bridge/br_if.c      |  2 ++
>  net/bridge/br_input.c   |  3 +++
>  net/bridge/br_netlink.c |  5 +++++
>  net/bridge/br_private.h | 31 +++++++++++++++++++++++++++++++
>  5 files changed, 44 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


