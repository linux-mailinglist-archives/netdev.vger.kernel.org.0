Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D102F13BA5
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfEDSjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:39:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37365 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfEDSjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:39:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id z8so4305581pln.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 11:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cEvabnhyF9VKrhnSa2gn+sp0514QPRTSMHW6GgUAcW4=;
        b=cfxEWiEwz6nUiycUGuKst1/DH7R8TmY+SGzzJLDk5+EhhnJvh5A8Arkrn62LNS6Qoa
         7Jl8aRObkcT9t4+7abTCHvj8bbbLib/PKgF3kHoaBVBA5EnFciWasSSypQFqwXTeIhmr
         WiUHsXhMl42sX2xEGhUv5eKkXtRW0lIV7gWDNLNGUkH3qqtmdc8v3KWYdrQQJf8F7JdN
         E4u9P6AsyY/NJw8iwSuK2evPc3066URLc0YcFK7XgoXFC87WaSr7wTuinLwKjkFa96X8
         /qCN3WOvTlCyZCEP14JGEex6A3g3cYxgJkc1vlq8iQnuI8sbisGqi5EBv2YNsvuZxCBg
         HizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cEvabnhyF9VKrhnSa2gn+sp0514QPRTSMHW6GgUAcW4=;
        b=H8YKAGUmyP5TuWI9/fojezhsdGtd9WqrdhOuLKfndwshDz944pbW/gV7kG8pQd22SF
         ezWb3tjvC1+reRJb99f0UC9rNHD9VJdu2w9MqWsHOAP3XUSBaX2cDwELR4PffFixDdo8
         amJGLr+jcpoTT/4XAW8k762Wpe9/d4ApeIfa+NqLi5/XEqBp3ZzroD4A0JXI72adgLpz
         W3gp4bCyCEUtXEj3obSxGkkgMYxXLHq87Oj1tI9PiPQt8jUUYquCWONTycSNVcO6Cv79
         A3ekDqdsEDQF/sHFNmVE+TUTwQwAyOdf7jsK8EPUbETt734kJs8OxzwyxKjITxdXjiEH
         GLMA==
X-Gm-Message-State: APjAAAUMHyq+MGUeQNMZOUvZsxNWLZFhyCyhpTqRrJcnDADAjyPNZIy8
        8t+SojwI+4Kj01SVGbKwMvaOC3zs
X-Google-Smtp-Source: APXvYqx0UjJGgTlCtHIMid7S41QLbaH6wTenxrLXZ2g2RxVAO7h6W/zF9VGNW9RgCwgwPFTk92AUQA==
X-Received: by 2002:a17:902:6842:: with SMTP id f2mr20726885pln.189.1556995162294;
        Sat, 04 May 2019 11:39:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id q87sm8436206pfa.133.2019.05.04.11.39.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:39:21 -0700 (PDT)
Subject: Re: [Patch net-next] sch_htb: redefine htb qdisc overlimits
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
 <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com>
 <CAM_iQpV4CJVXP0STJs-MWREkU1uxg5HsvMpTkiRfpK7Smz-J9g@mail.gmail.com>
 <CANn89iKhyVk8AfAdKJUPho7bKiZ9Aqa3aovrgTbUBft+8gDeig@mail.gmail.com>
 <CAM_iQpX6LZ1OFXapOJpdteSSM+fOHnC0QpnJRkexq3dVZzp_bw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3f792067-09a7-a645-90be-ffe308c7baf3@gmail.com>
Date:   Sat, 4 May 2019 11:39:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX6LZ1OFXapOJpdteSSM+fOHnC0QpnJRkexq3dVZzp_bw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 2:27 PM, Cong Wang wrote:
> On Sat, May 4, 2019 at 11:10 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Sat, May 4, 2019 at 1:49 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>>> Sure, v2 is coming. :)
>>
>> Another possibility would to reuse existing sch->qstats.overlimits ?
> 
> I don't find any way to retrieve qdisc pointer from struct htb_sched,
> unless we add a pointer there, which will end up bigger.
> 
> Or refactor the functions on the call path of htb_change_class_mode()
> to use struct Qdisc*, which will end up a bigger patch.
> 
> Therefore, I think your suggestion of folding it into 'direct_pkts' is better.
> 
> Thanks.
> 

I see, SGTM then.
