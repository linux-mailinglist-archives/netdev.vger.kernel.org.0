Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5154162BC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbhIWQIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242448AbhIWQIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:08:10 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40497C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:06:39 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id a13so6632330qtw.10
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S037++Fg3/u2sSJM6o8yWeOZfwgBir+bmyu6tYQlVm4=;
        b=yuLeLeEKgtHGy/AlVVlFpjvpCx8MgikO0bZFcPmuNcUBe1LnIRbyAsWDDBTuoQw+XA
         +YgfQ5gWMSb/3uLV9RCDd0yqkBGWWPwL7STrqp5fmAl1nVPQPI6RsPH88I3Q6zXddH+n
         PcTLm59234CJngvnIU2r2KzyS0na/kisYG5yjV1CZslb9M0eUZOuqW+kgU3Te/us+f6m
         853iI6l0pg9EqcI2CDczUL80xHrZIXtu4QsvOiIrbCnRKv6DGUv2XaXc3v4FKqn+Flu0
         oyBeWyqrTV6FUb4/Iy2lvCeNfa3etIpxHk0BUebgnxbDJ9LYKgx4aNiFMsZzKXqzv13v
         E+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S037++Fg3/u2sSJM6o8yWeOZfwgBir+bmyu6tYQlVm4=;
        b=VqFWZkc3OqyChSVlepnarSYUpHDNVMgs6SUEkEzs0CKMMt+M9qK8GAHmlGKgXnayPM
         3Od/Nwmvmdwbg5V+AA1jh8nkMc3GHhDlBs7rgRpjjE7863jEYIdU6g7QJfdSXdtbfx7Y
         D1Lcyr23wSpU0m+Non5zUXs5cajKJrqGEE3aEt0E18GL3SwdzLNc/l1J3WlpIFa+AQgK
         TswmW5tZ39QkvwAdDaBSLdX6WrKjl2w7LhfK++Us4+3eokupStmCtKPXcfFOugXHScd9
         gY+/5Bg+7Dk0/wGYsz3Q9cP6zxCO7Q/YxAXs+4H7LFPKren6Xf8de636auMgBLpghxYJ
         5CUg==
X-Gm-Message-State: AOAM531sF/m9fjVYv8D8WlAuD8Ife98HWoNjRgh5xv5OOFLgwdxVzy39
        R0GJ2bbnKIQIVqJQYe9IwcMtYQ==
X-Google-Smtp-Source: ABdhPJzXxLH30Pay40JM4NAvtwjZSMbhSgpSqdS1SoLaTEcgjWqGSkAICwqjmWFnOTn9PnYoFoJjKQ==
X-Received: by 2002:ac8:149:: with SMTP id f9mr5391718qtg.208.1632413198360;
        Thu, 23 Sep 2021 09:06:38 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id c25sm3038942qtm.78.2021.09.23.09.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:06:37 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: sched: also drop dst for the packets toward
 ingress in act_mirred
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
References: <cover.1632133123.git.lucien.xin@gmail.com>
 <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com>
 <CADvbK_c_C+z6aaz0a+NFPRRZLhR-hMvFMXvaNyXpd84qzPFKUg@mail.gmail.com>
 <CAM_iQpU+CMLbDGyTQvo3=MwfbPghnb5C0tPLFmrhe_kaYzP6UA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <40b4a814-2687-b299-4253-ac506710e133@mojatatu.com>
Date:   Thu, 23 Sep 2021 12:06:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU+CMLbDGyTQvo3=MwfbPghnb5C0tPLFmrhe_kaYzP6UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC Shmulik.
Unfortunately we dont have good test cases in tdc to test different
scenarios of this setup (packets being redirected in both directions
once or several times).

cheers,
jamal

On 2021-09-21 11:52 p.m., Cong Wang wrote:
> On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Tue, Sep 21, 2021 at 2:34 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>
>>> On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
>>>>
>>>> Without dropping dst, the packets sent from local mirred/redirected
>>>> to ingress will may still use the old dst. ip_rcv() will drop it as
>>>> the old dst is for output and its .input is dst_discard.
>>>>
>>>> This patch is to fix by also dropping dst for those packets that are
>>>> mirred or redirected to ingress in act_mirred.
>>>
>>> Similar question: what about redirecting from ingress to egress?
>> We can do it IF there's any user case needing it.
>> But for now, The problem I've met occurred in ip_rcv() for the user case.
> 
> I think input route is different from output route, so essentially we need
> a reset when changing the direction, but I don't see any bugs so far,
> except this one.
> 
> Thanks.
> 

