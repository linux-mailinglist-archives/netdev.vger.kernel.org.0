Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80A43585B8
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 16:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhDHOFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 10:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhDHOFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 10:05:20 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5221CC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 07:05:09 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c4so2268779qkg.3
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 07:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=woJLdS6GK6qIk/ZIm7OZAEOk51nU/KDETFUiUwEKBqw=;
        b=BQsqNV8lZYNO7qhqQYCb6lzXJXzOopEwFOvPASx9orE8plzwtgaZyhkanITa/aBaLm
         me0OrfB1m4ClBbikvunR9ba+OqzeF1+iW1t33EDHwoTKzLijaAvw7gS6ghvMiHKlSZSM
         oHD4lQJFHrHLkNxWxhf1b6rKi21sSLwItud08VZ1JOMYru6LoxLVJDVWouiJIZZKqkh3
         C3pm+tS1JV7QuMJdJS8BIa868Gv4sjuydYsk2kYPAiFF14ozFrnNEYkumh89ydbZE4Bm
         w1ivdFBwYZ4ZJybQfM9Pn3S0tTgPNx/RPW9secnYjoK4D1N+KxYp0/vXU6EzBHhaBxo0
         IGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=woJLdS6GK6qIk/ZIm7OZAEOk51nU/KDETFUiUwEKBqw=;
        b=ZehAfufN4oUlycVDVh9C4lcDdmsHnnhmX90VonS5CB3BB8qHWwbh9t4NtSxYSMXq1d
         6JodzHuzONfjGRtTKM9V5ZXWI6ENNordSCqJZwDnO8wqVWuu+U/C1lE0H6S5cyrvkhFL
         F6jT14i2mgfOQwjbmirsxSEAXFaYo4MCUzZe+AC4H9hZH/ry+W8PiIh3rtih80y3adiF
         H4A/3TD8kPTlaO3R9hPHQUp9+a8N59TiVz5p6AcHTmBYH0t9x57fS48PpahYTXm4AO3g
         SEC6IfxR8P77T674MOwq4BbAiORbxHQLO2PtKgIwkZDnpG29WSzW+o1DZmsSwdsCEOsp
         hn7w==
X-Gm-Message-State: AOAM532iBuAiu0ydnoORO/RcIRmN07dEL3Vihbe0Ke2VEhB9piHTPr23
        chTVRoVmPsp53CyhtiNuzIUGtsXSZwziQw==
X-Google-Smtp-Source: ABdhPJykbhhgJvZAyRGF69FbL7svvoCnAhwQyGBIgrEVLuYyMG6lyUHGNX2awTnHLx3DPYwCLyK8ew==
X-Received: by 2002:a05:620a:22f5:: with SMTP id p21mr8508140qki.225.1617890708600;
        Thu, 08 Apr 2021 07:05:08 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id e14sm18047715qte.78.2021.04.08.07.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 07:05:08 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
Date:   Thu, 8 Apr 2021 10:05:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408133829.2135103-2-petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On 2021-04-08 9:38 a.m., Petr Machata wrote:
> The TC action "trap" is used to instruct the HW datapath to drop the
> matched packet and transfer it for processing in the SW pipeline. If
> instead it is desirable to forward the packet and transferring a _copy_ to
> the SW pipeline, there is no practical way to achieve that.
> 
> To that end add a new generic action, trap_fwd. In the software pipeline,
> it is equivalent to an OK. When offloading, it should forward the packet to
> the host, but unlike trap it should not drop the packet.
> 

I am concerned about adding new opcodes which only make sense if you
offload (or make sense only if you are running in s/w).

Those opcodes are intended to be generic abstractions so the dispatcher
can decide what to do next. Adding things that are specific only
to scenarios of hardware offload removes that opaqueness.
I must have missed the discussion on ACT_TRAP because it is the
same issue there i.e shouldnt be an opcode. For details see:
https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf

IMO:
It seems to me there are two actions here encapsulated in one.
The first is to "trap" and the second is to "drop".
This is no different semantically than say "mirror and drop"
offload being enunciated by "skip_sw".

Does the spectrum not support multiple actions?
e.g with a policy like:
  match blah action trap action drop skip_sw

cheers,
jamal
