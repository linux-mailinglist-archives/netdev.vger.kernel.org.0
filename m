Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4951910A771
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 01:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK0AXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 19:23:22 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35620 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfK0AXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 19:23:22 -0500
Received: by mail-pf1-f193.google.com with SMTP id q13so10046442pff.2
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 16:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zne1RIuQpmE5ZwdAMU8zHqZSNC7RjvGkRbj4lF6lP1M=;
        b=WGUiHXAvgyvdONJNTW37DWhiKvjklo/8MX8T3XulSp0vUIzU4IlLCkFpcVAXxwiirW
         mmT32jTqw1+XzN5CcImYQZF4s1rO+0DvGotQCPNzh1MVifMop4wEne5cIOcv/2G4uVl1
         4lMVPO30b9ed1fvI48EiAFOPyXJ92yBa7dOYfMwagPWqyun+zrVfy1NPlbMlPxsOecBc
         Dec3uheVdv3/pXTNtwqUPT46D/iLue9V44xchUtl3aM+gyRgbYHPlgvqW5sOzaTbieqg
         5gToF0ta8jUeGvY53Pgy61OUyGJkMg2T7AIA2WNBZq+wWr1epG6IkKsCnltU1sTqI2At
         Y1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zne1RIuQpmE5ZwdAMU8zHqZSNC7RjvGkRbj4lF6lP1M=;
        b=DM4/fIvt5/XOxaCbOglvmKdTyimDaLB5YxMAGxmrb/iyFGxGlqFgDPYYmQ20AHdAjW
         4BcdDWRtu/Byqp0s5W/HjAm0x+ra6f5WSYHUD1uDrIu8YHDo/ID6XmEsZ4KCjC8Az0tP
         aEH9Y1BqsSHQuT82P8razgeEK8rv7XJ07JDv3yzRPVEgo4slRWWyzmG0EKOlbST6r7WO
         FTXkqovX8wpbCsyNa79rNb6+VVUIHpujD2vDi+npMhkYN8ffqA17nkQ1IOasR4C3sqzG
         6IW2zVZ62l27DRwjKZFv1XuVM97Wo1zPeJQdoj8qV4iVQsDQPXtyHb/u+M7EK9ra9r7Y
         tYPg==
X-Gm-Message-State: APjAAAV483U7rEw2M7VEokoHlLu6FDObwwXvdVp4hXYMDImAsoQqIRJ7
        GfEq0sZQ0+oXVa39rt+OeifyChbg
X-Google-Smtp-Source: APXvYqzk0Lvuk0CMrSeA4+x/PlTg/e1P/lwiYYURhNz72nQM/sAjwWlMQ6DNSITvVe3xTsjLe2PRow==
X-Received: by 2002:a65:46c6:: with SMTP id n6mr1512758pgr.15.1574814200081;
        Tue, 26 Nov 2019 16:23:20 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r33sm4358655pjb.5.2019.11.26.16.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 16:23:19 -0800 (PST)
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
 <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
 <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
 <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b7b60950-532a-0d0d-d6b7-85ebd6a47e33@gmail.com>
Date:   Tue, 26 Nov 2019 16:23:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/19 3:32 PM, Oliver Herms wrote:
> Hi everyone,
> 
> On 26.11.19 23:45, Eric Dumazet wrote:
>>
>>
>> On 11/26/19 11:10 AM, Oliver Herms wrote:
>>>
>>> What do you think about making this configurable via sysctl and make the current
>>> behavior the default? I would also like to make this configurable for other 
>>> payload types like TCP and UDP. IMHO there the ID is unnecessary, too, when DF is set.
>>>
>>
>> Certainly not.
>>
>> I advise you to look at GRO layer (at various stages, depending on linux version)
>>
>> You can not 'optimize [1]' the sender and break receivers ( including old ones )
>>
>> [1] Look at ip_select_ident_segs() : the per-socket id generator makes
>> ID generation quite low cost, there is no real issue here.
>>
> 
> ip_select_ident_segs() is not the issue. The issue is with __ip_select_ident
> that calls ip_idents_reserve. That consumes significant amount of CPU time here
> while not adding any value (for my use case of company internal IPIP tunneling 
> in a well defined environment to be fair).
> 
> Here is a flame graph: https://tinyurl.com/s9qv9fx
> I'm curious for ideas on how to make this more efficient.
> Using a simple incrementation here, as with sockets, would solve my problem well enough.
> 
> Thoughts?
> 

Oliver, TCP flows do not call  __ip_select_ident()

Pleas do not touch TCP payload.

Thank you.
