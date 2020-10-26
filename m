Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC12985A1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 03:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421520AbgJZCsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:48:41 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:35028 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389207AbgJZCsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 22:48:41 -0400
Received: by mail-il1-f194.google.com with SMTP id k6so1632476ilq.2
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 19:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GDzoHOBhZhnW2ZwbmTdxGKhzQJGv+YZ+mxduscm9D4s=;
        b=s5deCSJeJ4SFNOBlpI40X6m1awjhO3HRSfR0g+Voq6a3bddkSa2AumDxPSuqJqPsnb
         BcpdG9atQ4WAOHGA6GLEAVuV1zP7GOZqK5CEge6s1rmV9YeXEty9ALdbXWf43okhRgOw
         ExOPw5Zb/cmXOTsX6O7Qmpm4+3snHtEgG3drFxmw5IwJC18b+Y6y6qylgUnnmAd97mC3
         WBrJm2DDe/6FIs5LTQBON2VVc+/NCmfLCR5ExmSbDQwN6x6t9mNELs6Mo5TDOzYS6OwE
         X7Pg59zl0RC4DmXnJeDlCKPwSSrBi3BNmb9M3FRkWwTAl9gkHoy17XeyzKBSFat3u4YS
         kOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GDzoHOBhZhnW2ZwbmTdxGKhzQJGv+YZ+mxduscm9D4s=;
        b=eZa7lH5actPvbYBH53PYUOvqj0t3js2nZPDCS7jMn5Yxi19REq4CGs3YYdVqUS+h9z
         KP0sebeus+32wbn/QLyFrI8axdUfZE8AAft9H0XGo83deW6CW4XriM6YMTgORvvGLAyU
         ZDuim5XPRy/fgrV+atFRFUMp/4hxDN4lr1fHf+u4AwP0jtnKzaTasZK1uTIO0VxGOPRb
         wDZdUw6Ktq0YpkJq9O2vWFkJ4DI1viMz/axtTdBq1basNp7dfPiPItyX9shFh2I77M/6
         2MNwY184JwvT5RSkRwBDfZfsyM9ax6eZGoMfmJ/3Vn4T6B6c9JmlYcAS8IPWA06aPLAT
         CXNA==
X-Gm-Message-State: AOAM532dl6FYL+i2tqGbLxWlDvxrBc3oneJScxgOrfGyNbJFpKuSRweM
        6eRRg/9yVtDkB2VMpy9cSz8=
X-Google-Smtp-Source: ABdhPJzlRKkQetFW0XvgEPwvA6W4ZiYvkAd1t4IGlYDZj7gy8ruuC9cneftjylslBg99fet8TrDUkw==
X-Received: by 2002:a05:6e02:112:: with SMTP id t18mr9176495ilm.299.1603680519939;
        Sun, 25 Oct 2020 19:48:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:146b:8ced:1b28:de0])
        by smtp.googlemail.com with ESMTPSA id q23sm4735666iob.19.2020.10.25.19.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 19:48:39 -0700 (PDT)
Subject: Re: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
To:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>
References: <cover.1603469145.git.gnault@redhat.com>
 <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
 <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201023184816.GB21673@pc-2.home>
 <20201025144309.1c91b166@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <310b13d1-4685-cd76-be5f-e9450fb6a95e@gmail.com>
Date:   Sun, 25 Oct 2020 20:48:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201025144309.1c91b166@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/20 3:43 PM, Jakub Kicinski wrote:
> On Fri, 23 Oct 2020 20:48:16 +0200 Guillaume Nault wrote:
>> On Fri, Oct 23, 2020 at 11:23:04AM -0700, Jakub Kicinski wrote:
>>> On Fri, 23 Oct 2020 18:19:43 +0200 Guillaume Nault wrote:  
>>>> Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
>>>> mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
>>>> need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.  
>>>
>>> Does it generate an error or a warning? I don't know much about soft
>>> dependencies, but I'd think it's optional.  
>>
>> Yes, it's optional from a softdep point of view. My point was that
>> having a softdep isn't a complete solution, as a bad .config can still
>> result in inability to properly transmit GSO packets.
> 
> IMO the combination of select and softdep feels pretty strange.
> 
> It's either a softdep and therefore optional, or we really don't 
> want to be missing it in a correctly functioning system, and the
> dependency should be made stronger.
> 

That's why I liked the softdep solution - if the module is there, load it.
