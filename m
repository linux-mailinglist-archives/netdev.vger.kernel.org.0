Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78CE2F8B4E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbhAPEmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbhAPEmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:42:12 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4967FC061757;
        Fri, 15 Jan 2021 20:41:32 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id d189so11841062oig.11;
        Fri, 15 Jan 2021 20:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OOtJkxn6jSLOB+e6L+ZSIwut8jpGnnKI/nsHAVbM2uI=;
        b=J8j2uQGI5vZoLIt0q4STAhg4kLLkG1Apt9vtWWi+rtkCHI3J9FCsv5eMqAQjU9jVki
         xfkUTvZLzbg44OK96/8e41pEd0UOk16qlnymUc6ZYoTJL4A4/982J+hBlFkMNKmV7c5K
         /Aq8xpjp/i25Pj90yhiPvgDzpvseL7P7nLLCNIoZ800zEso1U4lUD79GrMfFOjbSX3o1
         Cag+iL9K5h+zor+M8xpqgSaP8CF83dQe/duS4X4LL6H+2EioObmkanIbVdPLr1Covghw
         NpmADwf67Jtihow21/AiKZor0dIuzY4BOceQM5MQf/Drlco7Ls75FlAvDHkHiHHzYuDp
         Ze9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OOtJkxn6jSLOB+e6L+ZSIwut8jpGnnKI/nsHAVbM2uI=;
        b=YzURgO32Jyg97CxkB8PDIvgv+2IAId1axWUraloXZFdcyfmFRXewjOaG5hklrd5hGo
         nf5e4GrC0RuTCxdJVxlzjKoYdsqUR1hObk49NGsXhXgXqDd4KaRcu+g0VmRYTsVRqz7O
         zMYLjJl+wpU9pe0gPvYWRPTPI3Jnb2Vx0t1YLAGr9hHsoV2Onoouy38ucGonBL1ebcUl
         Lnx+12H0hjBvXFpaqTgDI/NmmB7C4ql8pkDAdAJlhz3S4PrptbW9/pOjfjrxArfxxSAb
         K6X+Cu/JxOPr6gbX67eOIVZ5HzK2dQis0wQ9wL/j47gSF1tMJ68rdMJqRRdX8l4cwi7J
         0ynA==
X-Gm-Message-State: AOAM531SymOZnesnbeG20gx2FljVZOcHwI1PqHdyklDtDAtwzzgC5jJz
        QRr1QqeBiENrVauoLqe3GU4=
X-Google-Smtp-Source: ABdhPJyrpjfh8Zg2ajZ0wCrfw3KOHQC0cjp72X8cQ8lFxpgv8STYnmmdiHjEOZVAZYtZLBwkKa+hYQ==
X-Received: by 2002:aca:c3c3:: with SMTP id t186mr7890985oif.53.1610772091734;
        Fri, 15 Jan 2021 20:41:31 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.215])
        by smtp.googlemail.com with ESMTPSA id y12sm2382709oti.0.2021.01.15.20.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:41:31 -0800 (PST)
Subject: Re: [PATCH net 0/2] ipv6: fixes for the multicast routes
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Graf <tgraf@suug.ch>, David Ahern <dsahern@gmail.com>
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
 <20210115145028.3cb6997f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFnufp2DLgmO_paMoTGPUAGHbp9=hVgWR5UxmYbQQE=n642Ejw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <989d8413-469d-9d80-1a80-15868af24de6@gmail.com>
Date:   Fri, 15 Jan 2021 21:41:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAFnufp2DLgmO_paMoTGPUAGHbp9=hVgWR5UxmYbQQE=n642Ejw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 4:12 PM, Matteo Croce wrote:
> On Fri, Jan 15, 2021 at 11:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Fri, 15 Jan 2021 19:42:07 +0100 Matteo Croce wrote:
>>> From: Matteo Croce <mcroce@microsoft.com>
>>>
>>> Fix two wrong flags in the IPv6 multicast routes created
>>> by the autoconf code.
>>
>> Any chance for Fixes tags here?
> 
> Right.
> For 1/2 I don't know exactly, that code was touched last time in
> 86872cb57925 ("[IPv6] route: FIB6 configuration using struct
> fib6_config"), but it was only refactored. Before 86872cb57925, it was
> pushed in the git import commit by Linus: 1da177e4c3f4
> ("Linux-2.6.12-rc2").
> BTW, according the history repo, it entered the tree in the 2.4.0
> import, so I'd say it's here since the beginning.
> 
> While for 2/2 I'd say:
> 
> Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
> 

As I recall (memory jogging from commit description) my patch only moved
the setting from ip6_route_info_create default to here.

The change is correct, just thinking it goes back beyond 4.16. If
someone has a system running a 4.14 or earlier kernel it should be easy
to know if this was the default prior.
