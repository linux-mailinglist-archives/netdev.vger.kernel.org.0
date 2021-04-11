Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D435B6BB
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhDKTXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 15:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDKTXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 15:23:22 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523D8C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 12:23:05 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id u3so5266178qvj.8
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 12:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=avXKiq6W+cYGDZMRMyBt4n7I4IadwdOEJ3VppA72up8=;
        b=lEu20EK+X+1WiwYPTWb8cP1F1Qq7LW5NURwjmGPt968kvqeyKoujeqFFMXbTd/M9Wu
         ppHVpNr2DHA0WINHls+tiDm06zgy4BOXXKojmIUPXXxefy9hS0/saZOMcEOfwO1bvhTC
         X5dbf70xuqvFw/ThI40zb/8C87o2cG1Vip17U5d73RnRQQLkMHkneZHP7HFTT+9ISTC7
         9r5GjJoP4VLhSP/wH9OlPMEObRGSYNW3gjyh8tIgC9im+2kIyWW39aC02tNzT9UujHd6
         /OHoqYnhjkeRrmCY3Ax8RCkpONhNHLiAGwUPX0RmLQq+kdLMjevBLi+lKD8qd4bD0zyk
         rWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=avXKiq6W+cYGDZMRMyBt4n7I4IadwdOEJ3VppA72up8=;
        b=AeTM0YlA/bVx/KE2N5n3OAMinMZn0tRDaJ1/LmtRZC53vRDvJc205AmXLYya03s+8w
         U7X1XU5Y/IUB0jbB4TWLiM2RQzSBHf7mhQJLwgOuIquDOiJEPsvZv6SYk/XjzwsjvW/R
         6fFLShYtknVNBmAIwzarCU5x+PPXb7j2th0F4BI7he6rs3c80DqQ8/+cXmGRvzc6eHTI
         w9R0EZLF5qxSXDFZcc5WnUT2L0S3f9Xtp0sQym69ZWOxjLMwcwtbAD08CoZ0ukPKFhER
         5n0Sw0MYJmKd1oir0Rgg6Uh4kawZA/xfhI+aDMrRK1yvD73/0YFhrmpjqyxQp5OQHgbw
         zqfA==
X-Gm-Message-State: AOAM531cilmaif/vL8r/YBkgU3rPoxZ+K64Y2gzOfBq3AJoHOGu23UzJ
        z5U3L9JhFrxlXUjmgu8d+uSC/L2hn7bbCA==
X-Google-Smtp-Source: ABdhPJzIqAon0BzR8LpoF0DHxUjqClo4RyFAmuYjszffIGg/rVKHhvbv1pCrCILwnw9+vkufAehP0Q==
X-Received: by 2002:a0c:e950:: with SMTP id n16mr2789573qvo.43.1618168984338;
        Sun, 11 Apr 2021 12:23:04 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id x22sm4759524qki.21.2021.04.11.12.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 12:23:03 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
 <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
 <877dlb67pk.fsf@nvidia.com>
 <6424d667-86a9-8fd1-537e-331cf4e5970c@mojatatu.com>
 <8735vz609x.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <137b2a5b-8a05-e699-1ac9-3dc072ea16a7@mojatatu.com>
Date:   Sun, 11 Apr 2021 15:23:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <8735vz609x.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-09 9:43 a.m., Petr Machata wrote:
> 
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> 

>>>> Does the spectrum not support multiple actions?
>>>> e.g with a policy like:
>>>>    match blah action trap action drop skip_sw
>>> Trap drops implicitly. We need a "trap, but don't drop". Expressed in
>>> terms of existing actions it would be "mirred egress redirect dev
>>> $cpu_port". But how to express $cpu_port except again by a HW-specific
>>> magic token I don't know.
> 
> (I meant mirred egress mirror, not redirect.)
>

Ok.

>> Note: mirred was originally intended to send redirect/mirror
>> packets to user space (the comment is still there in the code).
>> Infact there is a patch lying around somewhere that does that with
>> packet sockets (the author hasnt been serious about pushing it
>> upstream). In that case the semantics are redirecting to a file
>> descriptor. Could we have something like that here which points
>> to whatever representation $cpu_port has? Sounds like semantics
>> for "trap and forward" are just "mirror and forward".
> 
> Hmm, we have devlink ports, the CPU port is exposed there. But that's
> the only thing that comes to mind. Those are specific for the given
> device though, it doesn't look suitable...
> 

If it has an ifindex should be good enough for abstraction
purposes.

>> I think there is value in having something like trap action
>> which generalizes the combinations only to the fact that
>> it will make it easier to relay the info to the offload without
>> much transformation.
>> If i was to do it i would write one action configured by user space:
>> - to return DROP if you want action trap-and-drop semantics.
>> - to return STOLEN if you want trap
>> - to return PIPE if you want trap and forward. You will need a second
>> action composed to forward.
> 
> I think your STOLEN and PIPE are the same behavior. Both are "transfer
> the packet to the SW datapath, but keep it in the HW datapath".
> 
> In general I have no issue expressing this stuff as a new action,
> instead of an opcode. I'll take a look at this.
> 

Ok, thanks.

cheers,
jamal
