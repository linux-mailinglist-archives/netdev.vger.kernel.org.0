Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8630C1CE907
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEKXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:19:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B91C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:46 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so8486016pjt.4
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0p0J9qdW+YU8vmVVINMwEP0IePe2AQnAZTxXIAP8gbQ=;
        b=LQXjaEktCBYlP5UUsesV6FJ0fGUuHTI+d4jpK04FcvB3K0QBe0tfZb4MfnDuLURCr8
         Pe2sz5Dhyg/FygzVRHzJRE9DoToLSsGXtyS35j8LwugzLpEuDlkA9qOsgfC6K2Vi7Gul
         WDA7PKfWOYGkEKroKCbBfO96NtdKfEUaIkwNA2y7jJImr0hPiV76eUDdiZ96AgCdFFgc
         hQcqrZH7yla9Ni2i5m2ut3Q+J25nAJgc07SqjKP4f165/P/KzGBk8zTLVMl5I9yq3Dj9
         FbUQT+HqA122aCzfeA6uZzmWtiqFOu+n6OAgRSa4PyuvNHBalEz2cpFWGTq4njKJDj4m
         +iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0p0J9qdW+YU8vmVVINMwEP0IePe2AQnAZTxXIAP8gbQ=;
        b=IfdriyJ51rwKf2sDJTy3zj48SVrpSewsgUIisENUK+K87jheRvxvVevE2S0owWUQEG
         90eT7BJEMZpfqKhxjQmJlc5VmNq7nkFtSNuCiFbIdt59PNO7DI/I3R70Hmyjse6zLLZQ
         6RBAhf5Did7vAB/sPL82/PmVHCU+Jp2OnPrn6H42oXHrefiu1CxMSOnry60nuJLGHbtA
         baD4mV6LXkV90+pxilvmE08eX/2j7eL3AVlehWWKE9kfpeSRq9EWoZ+CEhO5mqGeStQB
         rQHcHaYmNfYZvPy+Ty+c1N/QDXyPb6mC3OV37/lIVtTzptsnjcl5bbyuc7di0K1A1Ico
         QAoQ==
X-Gm-Message-State: AGi0PuZ+pztyn43bRGrEoAx50L5VkHG2941ls9JjWKCuYww+M41OLJOJ
        lEFGlIm3cXrIM7xULOpSH3iNi4yC
X-Google-Smtp-Source: APiQypLoVzu7jTuFhuuziJMevKc1xO8KXfirdLOu/oFYJO5b+kbc4Xb5m7VZeYBHkvxLT5y4MpeBDA==
X-Received: by 2002:a17:902:7c03:: with SMTP id x3mr17780506pll.254.1589239185557;
        Mon, 11 May 2020 16:19:45 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id kr1sm7723856pjb.26.2020.05.11.16.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 16:19:44 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: sja1105: request promiscuous mode
 for master
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20200511202046.20515-1-olteanv@gmail.com>
 <20200511202046.20515-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0965a8ff-d338-3121-712d-eb1adcac3d1c@gmail.com>
Date:   Mon, 11 May 2020 16:19:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511202046.20515-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently PTP is broken when ports are in standalone mode (the tagger
> keeps printing this message):
> 
> sja1105 spi0.1: Expected meta frame, is  180c200000e in the DSA master multicast filter?
> 
> Sure, one might say "simply add 01-80-c2-00-00-0e to the master's RX
> filter" but things become more complicated because:
> 
> - Actually all frames in the 01-80-c2-xx-xx-xx and 01-1b-19-xx-xx-xx
>   range are trapped to the CPU automatically
> - The switch mangles bytes 3 and 4 of the MAC address via the incl_srcpt
>   ("include source port [in the DMAC]") option, so an address installed
>   to the RX filter would, at the end of the day, not correspond to the
>   final address seen by the DSA master.
> 
> Assume RX filters on DSA masters are typically too small to include all
> necessary addresses for PTP to work properly on sja1105, and just
> request promiscuous mode unconditionally.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
