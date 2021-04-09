Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7335A592
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhDISPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbhDISPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:15:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5EBC061761;
        Fri,  9 Apr 2021 11:15:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso3607220pjh.2;
        Fri, 09 Apr 2021 11:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DYxEv2edvVGxPPjEUP725MmjjlKkdNTOJ7fvlokNStM=;
        b=tmXHHxq7vMShPokEpmEl304lYv7J3PZaz4WfLlAYfLlONRQhSgpPdqh2PvzCribrFU
         PRn/u4qZi60lwhudS4+18MdP/rbDs+/pPY1wVrkywEC/GuRUBuDahz4MVqG658r5aEDX
         XwdI8v6N3PNPTX2YSiGvibIJehIxGFR2McWnNdHee6BjtNYb1HY5zok7Qog7bNLUO35f
         E22pLWlszkWWZlo4W7s6ukHJy1HAIgn9+C/H2Xvpd7od8MMPWf5Og19VOlH9kv4chZLj
         D7j3jONS7/Z8vUbUb4KqQ9wG1wq08vX6uTlMKqGdJaPC9EjDa3s3jAB+LkraqQll5fCf
         OiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYxEv2edvVGxPPjEUP725MmjjlKkdNTOJ7fvlokNStM=;
        b=bMVxl6Oczu64LcEvkr/oscbSmScAj3qle6BYxtBFOUo87LK88v70i5/1EFz4KqfmWE
         X6KrhSm7A4Za+lh2e5RKsPK5Qae9nWFIa75f8Ql41HrWGITpocY1PFSVQOJeW7/xR06g
         JpzE2QQvdVI7PTi+48S5YeWtNWrDgb33BzoIVZJ3c0n0SvJ463DqRSWLw1LeRiPHEdVf
         XvS8yoGws9ktDqaBUyg2ZL+Pxw4zRnnv835USWt6NdLLj++vIzXFJgJDzbOzYyDw+5R8
         4j75daak3cOiEDhdZUm/ueOrf0qwtVn8zMmmGPkPBqeewTsEDxeCawpfSYKtEJzAUzD7
         KDyA==
X-Gm-Message-State: AOAM530l+DSr1b696XjgOcNJzaDsHsjd0M9EeYQX7rG4t2IBvFFLI5M8
        VNz4D54zMEY9x0sMNhx7AjpKWVFqQ+0=
X-Google-Smtp-Source: ABdhPJx2czWkNSKPRVNvEyTDZcRg2m4YyTrBVmC2IHGHtMMQWur+dgMVt72IUbECDllx73FDBDyg/Q==
X-Received: by 2002:a17:90a:7c4b:: with SMTP id e11mr14768195pjl.151.1617992139825;
        Fri, 09 Apr 2021 11:15:39 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id s9sm2717856pfc.192.2021.04.09.11.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 11:15:39 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] drivers: net: dsa: qca8k: add support for multiple
 cpu port
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210406045041.16283-1-ansuelsmth@gmail.com>
 <20210406045041.16283-2-ansuelsmth@gmail.com> <YGz/nu117LDEhsou@lunn.ch>
 <YGvumGtEJYYvTlc9@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b8182434-b7b0-ef59-ef15-f84687df94df@gmail.com>
Date:   Fri, 9 Apr 2021 11:15:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGvumGtEJYYvTlc9@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/5/2021 10:16 PM, Ansuel Smith wrote:
> On Wed, Apr 07, 2021 at 02:41:02AM +0200, Andrew Lunn wrote:
>> On Tue, Apr 06, 2021 at 06:50:40AM +0200, Ansuel Smith wrote:
>>> qca8k 83xx switch have 2 cpu ports. Rework the driver to support
>>> multiple cpu port. All ports can access both cpu ports by default as
>>> they support the same features.
>>
>> Do you have more information about how this actually works. How does
>> the switch decide which port to use when sending a frame towards the
>> CPU? Is there some sort of load balancing?
>>
>> How does Linux decide which CPU port to use towards the switch?
>>
>>     Andrew
> 
> I could be very wrong, but in the current dsa code, only the very first
> cpu port is used and linux use only that to send data.

That is correct, the first CPU port that is detected by the parsing
logic gets used.

> In theory the switch send the frame to both CPU, I'm currently testing a
> multi-cpu patch for dsa and I can confirm that with the proposed code
> the packets are transmitted correctly and the 2 cpu ports are used.
> (The original code has one cpu dedicated to LAN ports and one cpu
> dedicated to the unique WAN port.) Anyway in the current implementation
> nothing will change. DSA code still supports one cpu and this change
> would only allow packet to be received and trasmitted from the second
> cpu.

That use case seems to be the most common which makes sense since it
allows for true Gigabit routing between WAN and LAN by utilizing both
CPUs's Ethernet controllers.

How do you currently assign a port of a switch with a particular CPU
port this is presumably done through a separate patch that you have not
submitted?
-- 
Florian
