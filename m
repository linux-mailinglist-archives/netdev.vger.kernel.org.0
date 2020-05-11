Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602611CE8EE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEKXPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKXPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:15:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F5C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:15:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so19734645wmj.3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T91M3PRykAjSP3u+eHSwaXzrOv7nsw7kKXSUN8uAYgA=;
        b=DnJtRNY4s1OHUDQYWRkA2mxw0MBow7qThJFzsfeI68wDW7PJ2ERAk0fePlTG7CBEbs
         yVC6dQ0MwkYi+3K3wRNwQ7Dneqrpgw2KmIA9eA/STmL//Y8jZrQSY+nK7zjOh0oS65nq
         cSCv0hZ9Q2nsS+H80FpEFgFQBk8YGxOppD9hX/RwP0edJfg47lYq4/Bxuspjur/O/Zu9
         I0XAmTD/zQeqyl/stTpdoQ1Mc5DXZJP9eFDxOQUEWx9X/JqkzaLsqBlncv5hXr/z5T37
         rM6SH0jo6jAumRnM1zYtLVxSKkQH8+7pod+IyHpj8WP90c6WEIROZUGxyiyMK9ESZC0k
         TUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T91M3PRykAjSP3u+eHSwaXzrOv7nsw7kKXSUN8uAYgA=;
        b=HStVYGWZ2AvxrSUWLQAtLW1yDQ9BaOI4A5/0+ziPmVTJ8FxvpsxqqWWp+SHVry3um7
         JKsgcl5gC6Uzp4Z/vl069fm89zhtzySYj6VRaKRYrE2pktos+u38fcj6bynUqVFlpsX7
         1limibbCi3RmSbWSsofVB6AUpvV8Ucl3idPuSANknKEbhgTnU/sxX862xWcWt+2SrFJb
         hRRU9TOzuR8aAP89p9cs/7CrjmMSirA426i2FY2upaTu+BiY23uXFZ49tpRnJqkTkRrG
         fr5T8LopZUNRyw1yygl8RVX/+X2/8RH5BrAt6kCQ1XTkJXGlOpPXA45jSvLSDDlYoPBK
         xRiQ==
X-Gm-Message-State: AGi0PuZkwEougDQVZ6ubfqrvYenFemYZCP36kRhPFomriL2QKltNqun4
        NyQJoltbJIdoQ+buevoMWSPVYC0R
X-Google-Smtp-Source: APiQypJJVfkZTOS1UNkUAr8tPdTKNqryyG1bpbHxVor45KRg3vMreKGlIU0Z4Og/FxpLTVB9GVqb5g==
X-Received: by 2002:a1c:4409:: with SMTP id r9mr35544038wma.165.1589238937441;
        Mon, 11 May 2020 16:15:37 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z22sm27773992wma.20.2020.05.11.16.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 16:15:36 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: dsa: implement and use a generic
 procedure for the flow dissector
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20200511202046.20515-1-olteanv@gmail.com>
 <20200511202046.20515-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <16b11435-e9f4-f869-bbcd-fea3cb069f71@gmail.com>
Date:   Mon, 11 May 2020 16:15:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511202046.20515-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> For all DSA formats that don't use tail tags, it looks like behind the
> obscure number crunching they're all doing the same thing: locating the
> real EtherType behind the DSA tag. Nonetheless, this is not immediately
> obvious, so create a generic helper for those DSA taggers that put the
> header before the EtherType.
> 
> Another assumption for the generic function is that the DSA tags are of
> equal length on RX and on TX. Prior to the previous patch, this was not
> true for ocelot and for gswip. The problem was resolved for ocelot, but
> for gswip it still remains, so that hasn't been converted.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Given that __skb_flow_dissect() already de-references dsa_device_ops
from skb->dev->dsa_ptr, maybe we can go one step further and just have
dsa_tag_generic_flow_dissect obtain the overhead from the SKB directly
since this will already have touched the cache lines involved. This then
makes it unnecessary for the various taggers to specify a custom
function and instead, dsa_tag_generic_flow_dissect() can be assigned
where the dsa_device_ops are declared for the various tags. Did I miss
something?

It also looks like tag_ocelot.c and tag_sja1105.c should have their
dsa_device_ops structures const, as a separate patch certainly.
-- 
Florian
