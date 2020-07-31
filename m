Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B210234A3A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbgGaR1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729944AbgGaR1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:27:06 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D48C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:27:06 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l23so29531068qkk.0
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dMAP5qZPgNkGYL/Es8e27wkRPcvMrbRpgL3nt2uv/U8=;
        b=DQpUmHoSUZ9Cd93537ypZkM+1dvS3gvkMWCoz3Qx13NPmBpmH4L+gKmanA4eodPVK+
         J04ciTphvC/32YS6/AsssAWJdCiJyeCIKz5NoES6FsgkNTeTMfBHwpqq/Y0st/RDULz1
         s90EGRs+oMbXy9wM0GoUZ2naiDEY9gSop5clWt0kv0vvi10hVW8C4NrFvOqm1/nyfGwr
         VqSlZFKNcLXmFmS3OPykN7Q7FfMF/aurchj96d1DyX+1/jlWq3xFkaX+jAweuOZ3N1oM
         Ffdz2TlQJTZ6E/1rQ7Nne2iW8IWlgbGeezgGumjp1cbCy0+8cSqHHZTwHyvW2HGy+2Gh
         Cg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dMAP5qZPgNkGYL/Es8e27wkRPcvMrbRpgL3nt2uv/U8=;
        b=Z+xWxoPfG/7hCaeRlTZ6puVERF7SP/WIze9N8Rtz0MQ8eG3EZlDF8OtGOtVguUuEQa
         PWxnknI6LJ/zLQPa8lA/+0NrN019FrbATAyLySU1cjKbhwh2Jj648YjbiQyAbE044nQE
         SEeBXJZ6F/ckqTveyhvl02H2Pns85Zsl/uXIt8Ti8da0vNFDOVHBNVeLo4DbmeEL+78y
         m3GhKeKH0bQKsrtRQx5786CPorOhK1wK98Jif+s870HoNyZkzQ4v16V4p8p0ovNJsOQ1
         dfYrv8I3eXsFmuhHzIb1oPRnKp6xW/Itz1aX8XL2whgsN7NjQvijbeFEt09wIVGaO6iH
         KSYg==
X-Gm-Message-State: AOAM533+TW4nnia8FsxBPzaP3WR6IZ41VVecyi0vnwmflBXSGAH4j2Og
        6I9VYinO4YsX2inIegGT/DX+36B5
X-Google-Smtp-Source: ABdhPJyrJF8gZ+2Ot8N+3QMSrr1x/JQDSN2YszfLrZbeCASgiu2Qgge4RLDx9HCfx3o3FrCKIodRNg==
X-Received: by 2002:a37:9b95:: with SMTP id d143mr4875785qke.272.1596216425945;
        Fri, 31 Jul 2020 10:27:05 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c147:b41e:be5e:8b7a? ([2601:284:8202:10b0:c147:b41e:be5e:8b7a])
        by smtp.googlemail.com with ESMTPSA id 94sm9869305qtc.88.2020.07.31.10.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:27:05 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: clear bridge's private skb space on xmit
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        davem@davemloft.net
References: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <07823615-29a8-9553-d56b-1beef55a07bc@gmail.com>
Date:   Fri, 31 Jul 2020 11:27:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 10:26 AM, Nikolay Aleksandrov wrote:
> We need to clear all of the bridge private skb variables as they can be
> stale due to the packet being recirculated through the stack and then
> transmitted through the bridge device. Similar memset is already done on
> bridge's input. We've seen cases where proxyarp_replied was 1 on routed
> multicast packets transmitted through the bridge to ports with neigh
> suppress which were getting dropped. Same thing can in theory happen with
> the port isolation bit as well.
> 
> Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/bridge/br_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 8c7b78f8bc23..9a2fb4aa1a10 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -36,6 +36,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	const unsigned char *dest;
>  	u16 vid = 0;
>  
> +	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
> +
>  	rcu_read_lock();
>  	nf_ops = rcu_dereference(nf_br_ops);
>  	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
> 

What's the performance hit of doing this on every packet?

Can you just set a flag that tells the code to reset on recirculation?
Seems like br_input_skb_cb has space for that.
