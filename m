Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5342452A2
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgHOVxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgHOVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:52:38 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D41C0A5534
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 09:57:34 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 74so6028392pfx.13
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 09:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=li9vWz+/XVimR2XJeecfcXwEA4QfWOmK4lpfErK/5xc=;
        b=mxDNTvEkrW/nrS+Ptr+zSoRZTw9Oap6h4q5lWfg06TmylP7lQ/iG1QkeKPG0IA09yR
         TkWJNcpgywpSC+B7lPiX4gf4a4bYRhIRak22s7PSb22AUGvE556KNng/rqyf9Uw/hRrg
         Cu3lPSAcYcIvwaN7KJbaHCnk71YFhe2XeTqI0dIJxaZUgkeTZy+qH8pbRblWlFzBNPWz
         dDgP6hGjpKVkjn5Cb601/5RhaZQhcXdQ7A0oaiX4ZQ/TOGjLjqNWDdoWwDTVX7GixT7M
         zEFwxw7Qp/Xq/bkk65zuvPw6QM42J4u4Z8dZI4YJ+YZg4SKMYGsl5JxBIfBJHBhb9HyA
         CQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=li9vWz+/XVimR2XJeecfcXwEA4QfWOmK4lpfErK/5xc=;
        b=hQ/y+Zsyt8spNtUQAwIQcmZkG3JM4W4vwjuqtfX7uJxnWW90gWmuYy+TZoCFT7Geic
         DsaG5z/HS+LQbayvXxfq1yYwW48yagKnAj8hbBNZcnRdv6QjPC9SakPb5IJrEa+UlllV
         iZJjzFgaYqNYNWzz/Pj8A/QFjd1drTIvZiAXOM++diXfmpBjCCMGwEYyCFfizpsxpvO9
         91MP1pt5nhZf2VdgRrQqbYNctY1eVE9hnW11AxYACinNLHqTUMYBEO3pnvx57Okv6IqX
         mWtO55l0L4WKJFsP0IGDTQfr25mgR2lJrh3iVoQlMA1T3kAkrtkoUpXbzLTW+juUgGMu
         sLmw==
X-Gm-Message-State: AOAM530nMK4XmKLQEBp6N2Q/qZwQBVcTkLm7ADf2xl5S0WEU49NrnjnN
        Gj4o4raxc3bt+2+ZyaYeFY4=
X-Google-Smtp-Source: ABdhPJz8Lk99J7nkUATb8dnZUD/7cugpODbuUHLpfxuPoS8R7+ykNlQEkF4pLVyKLD6SipAhHx6RRQ==
X-Received: by 2002:aa7:8e9e:: with SMTP id a30mr2838802pfr.319.1597510653182;
        Sat, 15 Aug 2020 09:57:33 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t63sm11027346pgt.50.2020.08.15.09.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 09:57:32 -0700 (PDT)
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, edumazet@google.com
Cc:     Doug Berger <opendmb@gmail.com>,
        Justin Chen <justin.chen@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Alternate location for skb_shared_info other than the tail?
Message-ID: <e6f779c3-9af0-5200-013b-f4da94c2ae38@gmail.com>
Date:   Sat, 15 Aug 2020 09:57:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

We have an Ethernet controller that is capable of putting several 
Ethernet frames within a single 4KB buffer provided by Linux. The 
rationale for this design is to maximize the DRAM efficiency, especially 
for LPDDR4/5 architectures where the cost to keep a page open is higher 
than say DDR3/4.

We have a programmable alignment which allows us to make sure that we 
can align the start of the Ethernet frames on a cache line boundary (and 
also add the 2 byte stuffing to further align the IP header). What we do 
not have however is a programmable tail room to space out the Ethernet 
frames between one another. Worst case, if the end aligns on a 64b 
boundary, the next frame would start on the adjacent byte, leaving no 
space in between.

We were initially thinking about using build_skb() (and variants) and 
point the data argument to the location within that 4KB buffer, however 
this causes a problem that we have the skb_shared_info structure at the 
end of the Ethernet frame, and that area can be overwritten by the 
hardware. Right now we allocate a new sk_buff and copy from the offset 
within the 4KB buffer. The CPU is fast enough and this warms up the data 
cache that this is not a performance problem, but we would prefer to do 
without the copy to limit the amount of allocations in NAPI context.

What is further complicating is that by the time we process one Ethernet 
frame within the 4KB data buffer, we do not necessarily know whether 
another one will come, and what space we would have between the two. If 
we do know, though, we could see if we have enough room for the 
skb_shared_info and at least avoid copying that sk_buff, but this would 
not be such a big win.

We are unfortunately a bit late to fix that hardware design limitation, 
and we did not catch the requirement for putting skb_shared_info at the 
end until too late :/

In premise skb_shared_info could reside somewhere other than at the 
tail, and the entire network stack uses the skb_shinfo() to access the 
area (there are no concerns about "wild" accesses to skb_shared_info), 
so if we could find a way to encode within the sk_buff that an alternate 
location is to be used, we could get our cookie. There are some parts of 
the stack that do however assume that we need to allocate the header 
part plus the sbk_shared_info structure, those assumptions may be harder 
to break.

Do you have any suggestions on how we could specify an alternate 
location for skb_shared_info or any other suggestions on how to avoid 
copies?

Thanks!
-- 
Florian
