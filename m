Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C6E270AC3
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 06:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISEw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 00:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISEw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 00:52:58 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86639C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 21:52:58 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n61so7366985ota.10
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 21:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+W6EmXEG1Z3vdrJsWNkeRsta/0t+g+iy9JwrWmtuLdU=;
        b=FDKAfOhVR26Rpdh1dVGIi6z7PrGA/EQ2FbdQ0AuBFOpJWXjWnHOCJVqvGPMcTtAamz
         MdAIk9HdRogKVC86T4cb8VTe5PIvyalgP35bmxobV7ik+pE4ljq39vI1xNh0DPLL5Otx
         LXqBR3XO59oX4Jpq0hMGwR2wWztHvD4yWS9vGJ1yej50AGjxrgWG/sHfReF1bfwpE8pA
         VyoehTmZD2RMtKfWfd5nttfdGO4B6826HT9h7v2STb82FERwWEuXVZeYMxhjB2jOmouV
         Itgf/GTdsl2StXbWQKU4gTQHXU4COQZ3906HqsZVNyaJTbGQJnh7aFJbIiq1Ym4UeobM
         hlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+W6EmXEG1Z3vdrJsWNkeRsta/0t+g+iy9JwrWmtuLdU=;
        b=IydA7TUnrUhAhBynB92inEWGx48oLK2ONuD1b0ozphok8c6+EVFRMQ1D28wGLBSPNl
         tBmE9fekSMyZqMi5YUCC6yETlRKHWEa2PwFKd7tmaqAkjCHqfBU+I+4mb9vN+3Lo1Mcu
         UyI7lG7D/+iclqeaqTKUWMVdjl7uZ1BfOFQIQ4tFiBo4xVeqo9UDSY++C7Kc3baudHCa
         dkFfAvx8+sanO/SU0ZNWGsxlMoJD7MBz0S4se0NUHEPz9vBmORM6UiecOUaxMmXdSsmw
         fS3M3ufxn2W4Whi/8xgDKbbkAhWLx6A/z6ZxBbGACz4b96FzIE/4uvxjTmvedu2P6IDP
         qOFg==
X-Gm-Message-State: AOAM533nSGlgzN9dJLQe/yUeH1l5L2tNX7oCBFBuScP9cvy7pOr8WhUh
        ROOlj2FhAucZ7RNr30ic/5HJogRAuQQuUg==
X-Google-Smtp-Source: ABdhPJzrHgqRvFxsDVi7wf9WmAy9APYk+H0Iahzsr5Z5cumGXKWyHeaVpt6jqF627QN66MwZ+Y8ZIw==
X-Received: by 2002:a9d:73d4:: with SMTP id m20mr23710288otk.227.1600491177695;
        Fri, 18 Sep 2020 21:52:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:fc15:41f5:881c:229a])
        by smtp.googlemail.com with ESMTPSA id v7sm4615611oie.9.2020.09.18.21.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 21:52:56 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
References: <20200916194249.505389-1-kuba@kernel.org>
 <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
 <20200918084826.14d2cea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f936dedf-ee3a-976c-c535-55a2b075b37b@gmail.com>
Date:   Fri, 18 Sep 2020 22:52:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918084826.14d2cea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 9:48 AM, Jakub Kicinski wrote:
> On Fri, 18 Sep 2020 09:44:35 -0600 David Ahern wrote:
>> On 9/16/20 1:42 PM, Jakub Kicinski wrote:
>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>>>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>>>     RX: bytes  packets  errors  dropped overrun mcast
>>>     6.04T      4.67G    0       0       0       67.7M
>>>     RX errors: length   crc     frame   fifo    missed
>>>                0        0       0       0       7
>>>     TX: bytes  packets  errors  dropped carrier collsns
>>>     3.13T      2.76G    0       0       0       0
>>>     TX errors: aborted  fifo   window heartbeat transns
>>>                0        0       0       0       6
>>>
>>> After:
>>>
>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>>>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>>>     RX: bytes  packets  errors  dropped missed  mcast
>>>     6.04T      4.67G    0       0       7       67.7M
>>>     RX errors: length   crc     frame   fifo    overrun
>>>                0        0       0       0       0
>>>     TX: bytes  packets  errors  dropped carrier collsns
>>>     3.13T      2.76G    0       0       0       0
>>>     TX errors: aborted  fifo   window heartbeat transns
>>>                0        0       0       0       6  
>>
>> changes to ip output are usually not allowed.
> 
> Does that mean "no" or "you need to be more convincing"? :)
> 
> JSON output is not changed. I don't think we care about screen
> scrapers. If we cared about people how interpret values based 
> on their position in the output we would break that with every
> release, no?
> 

In this case you are not adding or inserting a new column, you are
changing the meaning of an existing column.

It's an 'error' stat so probably not as sensitive. I do not have a
strong religion on it since it seems to be making the error stat more up
to date.


