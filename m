Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8682C6182
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgK0JTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgK0JTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:19:17 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AC1C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 01:19:17 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id r18so5190745ljc.2
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 01:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=D8kpBdNOuri075Gpxasz1H3+KCpnUoRlaHCSVys4/nA=;
        b=mtmJ9nniBYKkXEWP+xslP+q8gpef/qOeAIbGTysENxkiNBPCkhwzUA4e7ouov0+6e6
         yNPnvoWMofP6WGYpCDv31irP7sAI/uc1HkG8/GYju24bi2pURVu4myD7jztsXW+h6sUb
         j9124R6QNqKA23e/pXp0ZqBx7IuVbBour1fp0yvDl56PNZ1It3afd7A6kqrn/uY3SFqK
         OFl+gsHvQR+Ker1W1WOAsXLyHaNOsjXcNCz5fV9Cav930cKee9wJ49V2E42IeC+WvQ6f
         2NRRTncvqQfCtdNmfC0usPjGCEmYW000f4sdWAwfFpt1oRWioUdiVMZuQFr8yqE9C2ms
         WdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=D8kpBdNOuri075Gpxasz1H3+KCpnUoRlaHCSVys4/nA=;
        b=ZMUjrCn1998ro0dYa+8OKFh2EqA1xuWjwWQnbKRPFv2PIT/6T0owsAQinhE97/EMoD
         //2TpQQj/XlZ1kZudOXmh73x1lcDT968n0VKetchtAGjBACpo9BQn7/Kg3WCVv5OWtPH
         17PSfJCOvC8PMG8VpohHNqU9Xd/ejPo5xWgZ9rsV3R9usgjxY1ka4QpCTf730a1Gp+vW
         0LcU4q+ijg3MTgc37AoDwDaYixnWIcg+pupQwzikUnFuE9nlFE31XGhxJXbHXP1YpvER
         w3iIhcNCfZEJjR5yQOSnqRH6eQkQ+k00m50M5jLbc0mPtHu7wEG6d188wwZYeiWWCEvk
         Bj6A==
X-Gm-Message-State: AOAM5330traI7wz02E8oAf18xXeBToYi9TKB6QIq+nwrG5stHPIeTUsa
        Iv/jtJFQmBOufu6uEJ7zMn39xouNm51gFW5m
X-Google-Smtp-Source: ABdhPJywXrz0/4XQFVpL3NSOSe3CEd+o2ue78StTcG1NUM6kpZzvpLrvUjpW2Wah8YmUdw74UklqMg==
X-Received: by 2002:a2e:6e06:: with SMTP id j6mr3012306ljc.282.1606468755603;
        Fri, 27 Nov 2020 01:19:15 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d7sm620131lfn.34.2020.11.27.01.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:19:15 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201126225753.GP2075216@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com> <20201119144508.29468-3-tobias@waldekranz.com> <20201120003009.GW1804098@lunn.ch> <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com> <20201120133050.GF1804098@lunn.ch> <87v9dr925a.fsf@waldekranz.com> <20201126225753.GP2075216@lunn.ch>
Date:   Fri, 27 Nov 2020 10:19:14 +0100
Message-ID: <87r1of88dp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 23:57, Andrew Lunn <andrew@lunn.ch> wrote:
>> If you go with the static array, you theoretically can not get the
>> equivalent of an ENOMEM. Practically though you have to iterate through
>> the array and look for a free entry, but you still have to put a return
>> statement at the bottom of that function, right? Or panic I suppose. My
>> guess is you end up with:
>> 
>>     struct dsa_lag *dsa_lag_get(dst)
>>     {
>>         for (lag in dst->lag_array) {
>>             if (lag->dev == NULL)
>>                 return lag;
>>         }
>> 
>>         return NULL;
>>     }
>
> I would put a WARN() in here, and return the NULL pointer. That will
> then likely opps soon afterwards and kill of the user space tool
> configuring the LAG, maybe leaving rtnl locked, and so all network
> configuration dies. But that is all fine, since you cannot have more

This is a digression, but I really do not get this shift from using
BUG()s to WARN()s in the kernel when you detect a violated invariant. It
smells of "On Error Resume Next" to me.

> LAGs than ports. This can never happen. If it does happen, something
> is badly wrong and we want to know about it. And so a very obvious
> explosion is good.

Indeed. That is why I think it should be BUG(). Leaving the system to
limp along can easily go undetected.

>> So now we have just traded dealing with an ENOMEM for a NULL pointer;
>> pretty much the same thing.
>
> ENOMEM you have to handle correctly, unwind everything and leaving the
> stack in the same state as before. Being out of memory is not a reason

We have to handle EWHATEVER correctly, no? I do not get what is so
special about ENOMEM. If we hit some other error after the allocation we
have to remember to free the memory of course, but that is just normal
cleanup. Is this what you mean by "unwind everything"? In that case we
need to also "free" the element we allocated from the array. Again, it
is fundamentally the same problem.

How would a call to kmalloc have any impact on the stack? (Barring
exotic bugs in the allocator that would allow the heap to intrude on
stack memory) Or am I misunderstanding what you mean by "the stack"?

> to explode. Have you tested this? It is the sort of thing which does
> not happen very often, so i expect is broken.

I have not run my system under memory pressure or done any error
injection testing. Is that customary to do whenever using kmalloc?  If
it would make a difference I could look into setting that up.

I have certainly tried my best to audit all the possible error paths to
make sure that no memory is ever leaked, and I feel confident in that
analysis.
