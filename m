Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5930B701
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 06:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhBBFZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 00:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBBFZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 00:25:33 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7B5C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 21:24:53 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m22so26153243lfg.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 21:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4IE20MJnl8eHsd4GaQUa85dUNOruSYWVFEX90IoX2I=;
        b=w06eCpr5wtFrtMcHBvMb91J/tq8T7BxmPGzAOToWyQhZd14DAnyXal6Mdail3HPzIO
         fxFVCYhYAB6899Bb5o7L0dX1wSCrjGqP9jPHfCs48VxSBkm+KfLLOayVPUsDFq4CaMQ/
         q5AIjpmVRwke66otu+1KRoxeQgQf4s1ptihy77QWTYGujKL+MWNEee4xJPYS0sb241BN
         Mn8mX7cKvmGU0ykEkgG41vV11inm8EBcnYxwYIX3pTTAl856dm8pps1ikZjueZneKeSy
         QOUV08ZfGaozFn4w0ZXEj1cHDGOMZAvw4EPcSxgHCme3HiyymxEd+9kQ6K1aCX8ffcnE
         v0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4IE20MJnl8eHsd4GaQUa85dUNOruSYWVFEX90IoX2I=;
        b=nF+7CS4twg09vRre83uGgM8MV6nwH4DWvf9Bu0n3cVzJWANSi76oA1qp1oaJZCncN/
         Zmn1wMllPi3Ej6ulFbhIF5IucNtqWf0r1th/jrWs+jeT4ZSS5zGZAUTpflrx2d97OfOA
         7l97COrFKappWKtAaupW+esf2zdyZ9LB4dguzIEEzxpLHtCO5qiejjMhwJwJNzopsitE
         Fee1DmtuzupyxuR5q4W+sNNiY2l3OaRgtNWkl+DUxkjldcdpzCtnEa2A0yhOtxWHJLMy
         dLsBPl4XInHamhDfMuIIDegZVLqa8nXRMKOCmtIxipIiprdPtWs0JmT8Ny1ZVH0n1W60
         HFhw==
X-Gm-Message-State: AOAM530NQf7rZQH8qmEZg0NxcE1nTfGEyyLsqe4KzXjVQc4Wvzk4ZFcJ
        bLptrMKiIIHESLqCE6AL4YspJQ==
X-Google-Smtp-Source: ABdhPJyl0vts+5/Uhb/qaf+yxm3P6Ji+42b2yBLYtj2nfuodcYjjKjPlEu6Y/nmtIrWWjRB+spSSmg==
X-Received: by 2002:a19:7019:: with SMTP id h25mr10546140lfc.627.1612243490484;
        Mon, 01 Feb 2021 21:24:50 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d9sm3167550lfm.293.2021.02.01.21.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 21:24:49 -0800 (PST)
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Jakub Kicinski <kuba@kernel.org>,
        Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
 <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
 <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
 <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
 <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <03621476-ed9b-a186-3b9a-774c703c207a@norrbonn.se>
Date:   Tue, 2 Feb 2021 06:24:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 01/02/2021 21:44, Jakub Kicinski wrote:
> On Sat, 30 Jan 2021 12:05:40 -0800 Pravin Shelar wrote:
>> On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
>>>> On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>>> Following are the reasons for extracting the header and populating metadata.
>>>> 1. That is the design used by other tunneling protocols
>>>> implementations for handling optional headers. We need to have a
>>>> consistent model across all tunnel devices for upper layers.
>>>
>>> Could you clarify with some examples? This does not match intuition,
>>> I must be missing something.
>>
>> You can look at geneve_rx() or vxlan_rcv() that extracts optional
>> headers in ip_tunnel_info opts.
> 
> Okay, I got confused what Jonas was inquiring about. I thought that the
> extension headers were not pulled, rather than not parsed. Copying them
> as-is to info->opts is right, thanks!
> 

No, you're not confused.  The extension headers are not being pulled in 
the current patchset.

Incoming packet:

---------------------------------------------------------------------
| flags | type | len | TEID | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
---------------------------------------------------------------------
<--------- GTP header ------<<Optional GTP elements>>-----><- Pkt --->

The "collect metadata" path of the patchset copies 'flags' and 'type' to 
info->opts, but leaves the following:

-----------------------------------------
| N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
-----------------------------------------
<--------- GTP header -------><- Pkt --->

So it's leaving _half_ the header and making it a requirement that there 
be further intelligence down the line that can handle this.  This is far 
from intuitive.

/Jonas
