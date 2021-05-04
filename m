Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1FB372465
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 04:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhEDCQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 22:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhEDCQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 22:16:24 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65277C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 19:15:30 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u16so7355842oiu.7
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 19:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lfbgDuxKTwgH6ohD48mm150RxYqlMXrihVa/Lv86vb4=;
        b=CUZMnLCw1L6m0suU9DV5ujQmSPUc8xFb3m+Xfj/b/R2wJErP+S/gznepnlec+w1YOS
         FyC3GA8+UA7UK4GjYVpjRGcocIJMI5i64WtluyLdinTAuaQg0uXCXPMJkddA42LUs2GZ
         B/hBbFOBbOfqp9M868m11GRnL9LiHNdSlmqIhqwcqO0eZ2xjXcRTTr/tx3WrqU/zto37
         0i+kcOAoauv72f/Y8+fowa0ve7n1hHBICVsOmF93fg9T560hj+FShuWAbTLnIV5Ts1hJ
         k+nCS3c9hejlAo9aMsS0IZ1peDJcbGRmH2JRZLwf+aXmAaZ/sYMCQ66J3P/b3tMK/0Kd
         G7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfbgDuxKTwgH6ohD48mm150RxYqlMXrihVa/Lv86vb4=;
        b=pWZUPNHtgoClahrK/ISgKZpOpPqS/uL5X6OLEggjL1siRmdE6bzkBE2kYJZfus8B48
         aG0GQhNrJiJsBe+eOV5wGEJSzsQ9cWHuKoZmcpk2Bz0Eo7qEzL+P8nxvKOIbOZfSCOEk
         AqBm0HJIg7or/+itjeHNbmfA8xeKGe5Jo9MASNPjWzkK26Eu8fd4mv2/+NsRQbEsFijN
         +9DYX5pNcz0Zm7cQCHlloTGMhQbXBKC2jKvJMfwZqH5a2dk18XsNJ/q6XSDo1k/WsZeS
         SGldZI+7s2kiZKsgL+teYLgzXKBqOEoEZ9NmQUFIQHysiQEMSKaBfmaXESDJCTUOxtGs
         +puA==
X-Gm-Message-State: AOAM531QQ5txryTGEUgvTNsp914BdMdr/uSQGl36NIb5wJcLSzLVTxcg
        gPvZp3VscmpbhQwkqSPS9D6qildUqPWHaA==
X-Google-Smtp-Source: ABdhPJyot+mfEMsewQP8umXzihYlkseVXUta6MGeFugLloN7U2iq7l8+1C6hGzXeIMi9Il9uWkG6DQ==
X-Received: by 2002:a05:6808:1392:: with SMTP id c18mr1223635oiw.176.1620094529724;
        Mon, 03 May 2021 19:15:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id a21sm366145oop.20.2021.05.03.19.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:15:29 -0700 (PDT)
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when printing
 stats
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210501031059.529906-1-kuba@kernel.org>
 <20210503075739.46654252@hermes.local>
 <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <be91d0cd-6233-3c8d-e310-a1b7fc842b48@gmail.com>
 <20210503122242.6ae77bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3737927a-7352-5a07-e19a-6b09470734a5@gmail.com>
Date:   Mon, 3 May 2021 20:15:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503122242.6ae77bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/3/21 1:22 PM, Jakub Kicinski wrote:
> On Mon, 3 May 2021 11:16:41 -0600 David Ahern wrote:
>> On 5/3/21 10:00 AM, Jakub Kicinski wrote:
>>> On Mon, 3 May 2021 07:57:39 -0700 Stephen Hemminger wrote:  
>>>> Maybe good time to refactor the code to make it table driven rather
>>>> than individual statistic items.  
>>>
>>> 🤔 should be doable.
>>>
>>> Can I do it on top or before making the change to the columns?
>>>   
>>
>> I think it can be a follow on change. This one is clearly an improvement
>> for large numbers.
> 
> Fun little discrepancy b/w JSON and plain on what's printed with -s 
> vs -s -s: JSON output prints rx_over_errors where plain would print
> rx_missed_errors. I will change plain to follow JSON, since presumably
> we should worry more about breaking machine-readable format.
> 

you mean from this commit?

commit b8663da04939dd5de223ca0de23e466ce0a372f7
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Wed Sep 16 12:42:49 2020 -0700

    ip: promote missed packets to the -s row
