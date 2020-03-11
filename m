Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB41820EE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgCKSgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:36:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34548 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbgCKSgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:36:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so1667983pgn.1
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f7voLh5ttjyOhk2gO8KOlP7FYPY++rd+JbthuIf6yzk=;
        b=FcK4kr9XiIU7u5SruJvKsbMRG2VdPCkk+DI8+VTNfbAIuFivCNTw90nUWTucF7/Wvl
         FZsPokLjJeeJ0jXoomO1DzVC8FbyLhsFLcTF/Ru3vmCjALD4FNg9ExaszlSmGwcO560I
         LVpJk3+7ia154CLwhzeCs1YHiTMAvR9MDk4+AeV3NuRDAHDYZjbc2Y3VmKmkRoXw7e4f
         RZhQzEYUMWeLB71ilXLp+NNXzCj4JBj0nXRQ/572NmFRq79ZrqmYwFz+HCW+yh3NfebL
         82tFxj2h08ZPbl+g7oYRay1DnlfCyoFK8Pb6NImeq2e8HMi+79Dxdz1pu0q1lzQF6VvJ
         oXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f7voLh5ttjyOhk2gO8KOlP7FYPY++rd+JbthuIf6yzk=;
        b=YacRD7JCPRqHvjaT5leNdvCaAkXwlU5cnDMxS8IQPM4qjEDWvpLhujxi4s6MywFwit
         P7W/NClz/y4hbNPoyq45iPEI0xaVgwNjX6WiI37F1dkSc5HMiQwqiyDZBLFGPt7Xeq5C
         koqaxpco2lc3abZQXL8Df0iimA5YcWxV1S+1kut0XPTWgtzHF+jTROqDD1HXwfXy5hon
         1DQh+sdp2gRRbzQYBmX5wDHGqDgZdD8MTrkfDB74FzqnThG9vyACLKjrnjWNlD/35VP8
         XatbDoLcMhWa97gV/PaGgCPrxAFqtHJUsyIhK5iNyZXOjJzTl81NVc/dtRBrHM6evS9c
         +xrA==
X-Gm-Message-State: ANhLgQ2jpZx+T09jxOcAcPWh4wXvWOwQAnxIuaytQpkSzB/looAZAzuh
        aH6y5beF7qAMjXWFGTghCDI=
X-Google-Smtp-Source: ADFU+vuoWMqzaFOBu40/tSRede6KdqcrjYyLo/4D4zmZR9HFL7WyziMy8SOT/g38dt2I4EOz4VhOfQ==
X-Received: by 2002:aa7:8d03:: with SMTP id j3mr3725436pfe.237.1583951794036;
        Wed, 11 Mar 2020 11:36:34 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r22sm6159627pjo.3.2020.03.11.11.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 11:36:33 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN
 tail-dropping mode
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Roman Mashak <mrv@mojatatu.com>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, mlxsw@mellanox.com
References: <20200311173356.38181-1-petrm@mellanox.com>
 <20200311173356.38181-4-petrm@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com>
Date:   Wed, 11 Mar 2020 11:36:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311173356.38181-4-petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/20 10:33 AM, Petr Machata wrote:
> When the RED Qdisc is currently configured to enable ECN, the RED algorithm
> is used to decide whether a certain SKB should be marked. If that SKB is
> not ECN-capable, it is early-dropped.
> 
> It is also possible to keep all traffic in the queue, and just mark the
> ECN-capable subset of it, as appropriate under the RED algorithm. Some
> switches support this mode, and some installations make use of it.
> 
> To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
> configured with this flag, non-ECT traffic is enqueued (and tail-dropped
> when the queue size is exhausted) instead of being early-dropped.
> 

I find the naming of the feature very confusing.

When enabling this new feature, we no longer drop packets
that could not be CE marked.

Tail drop is already in the packet scheduler, you want to disable it.


How this feature has been named elsewhere ???
(you mentioned in your cover letter : 
"Some switches support this mode, and some installations make use of it.")

