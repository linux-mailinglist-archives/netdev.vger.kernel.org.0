Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC924B88C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgHTLXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbgHTLXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:23:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1492C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:23:16 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a5so1668295wrm.6
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U5n6SRT8Sjz1CPU13WE9d5LyTZiKHzyZjLgHZoxXOTE=;
        b=aqEEg19xOzHTc3ozUAXeqmBIsz/TxteAu/dHfpFyffdvzCI0suNWh4lVdHYbTteaQs
         OwOUuXvXjz7P5oYJiISCCLCsgVQFlym97GpZAeY9RzKEc20kmHFwcVWHGY86p2tu/3e4
         YURoEZWEfJlJorMoUduq5s3XoX4O5Fz2XxKfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U5n6SRT8Sjz1CPU13WE9d5LyTZiKHzyZjLgHZoxXOTE=;
        b=aj2XXBpHtldstgDT1zc3S+FEoz2t1szvA4POIo8jQPolDNVT1Hhre6jCaYqRfVIzio
         iNgE94UYgiksYjr8GI1yhHdU/9QKIQzSFvCOIijLxbKTHKdKz8YotajkDbfjcPFwL5Xj
         BSmDoOV7Ge21/zaDPxsoKnvMt6UMl+eAl/eUEETdYau471Q9PtHuINRSbU/DPIhIu6uf
         4Lb62M+Ry0vvVWsBaYk6SvLDCapTBmtmM+58LXzqISPiAoSQZYwRyGlMP9yX/HbhB1eY
         C84J6DGaRumY9hfo6I2P/nc2IGpasx9Ae9/WwSS3KIUrickH60ElRroirdbUlBohy7Bw
         aD/A==
X-Gm-Message-State: AOAM530g1y2Oa0hJlb9uLflu85R3fJCBxPgQ+ZAOYi20CZ3T5MRWMe/0
        JOe3lgVF5maKik5uXyAZ+F10TbAAPiJ+PA==
X-Google-Smtp-Source: ABdhPJwsPZzuqgFAlc6bqa3hO310FDoiF1csyrwZ7PXVpepe+lQQsB6yPf4bw0JUqp4EtOSSb0TOrQ==
X-Received: by 2002:a5d:6345:: with SMTP id b5mr3010882wrw.204.1597922595213;
        Thu, 20 Aug 2020 04:23:15 -0700 (PDT)
Received: from [192.168.0.101] ([79.134.172.106])
        by smtp.googlemail.com with ESMTPSA id t25sm3478958wmj.18.2020.08.20.04.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 04:23:14 -0700 (PDT)
Subject: Re: [RFC PATCH] net: bridge: Don't reset time stamps on SO_TXTIME
 enabled sockets
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200820105737.5089-1-kurt@linutronix.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5affe98d-bb16-0744-5266-db708fb9dc16@cumulusnetworks.com>
Date:   Thu, 20 Aug 2020 14:23:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820105737.5089-1-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 1:57 PM, Kurt Kanzenbach wrote:
> When using the ETF Qdisc in combination with a bridge and DSA, then all packets
> gets dropped due to invalid time stamps. The setup looks like this:
> 
> Transmit path:
> 
> Application -> bridge (br0) -> DSA slave ports (lan0, lan1) -> ETF Qdisc
>              -> ethernet (eth0)
> 
> The user space application uses SO_TXTIME to attach a sending time stamp for
> each packet using the corresponding interface. That time stamp is then attached
> to the skb in the kernel. The first network device involved in the chain is the
> bridge device. However, in br_forward_finish() the time stamp is reset to zero
> unconditionally. Meaning when the skb arrives at the ETF Qdisc, it's dropped as
> invalid because the time stamp is zero.
> 
> The reset of the time stamp in the bridge code is there for a good reason. See
> commit 41d1c8839e5f ("net: clear skb->tstamp in bridge forwarding path")
> Therefore, add a conditional for SO_TXTIME enabled sockets.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>   net/bridge/br_forward.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> RFC, because I don't know if that's the correct way to solve that issue.
> 


The new conditionals will be for all forwarded packets, not only the ones that are transmitted through
the bridge master device. If you'd like to do this please limit it to the bridge dev transmit.

Thanks,
  Nik
