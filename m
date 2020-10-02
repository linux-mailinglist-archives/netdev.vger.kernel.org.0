Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D01280EFE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgJBIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBIc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 04:32:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E3C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 01:32:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k10so811423wru.6
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 01:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1vUk1lQx13qclx0e+MpuRQ5ij0W6oFTDg7Zo3xIHwY4=;
        b=tr28yD0lDd1TOaqvrMkSh20w3X6PFTQp+RRBDsMxx27B1J40/Wxl6zrfAKtygB5bq2
         a3jkb8+znH0xl2kwPf92h5SaOtKs5Fjx5UhLgwsj19kaieXxw5MRoKvnBfFRgHxjU9wL
         nPKBClFp1LnlC41ufg4hqUCNvSzGuwt7KLyx5Sei5xVKzmUZjr4+6647gZK6X0xLgIZy
         0Bea9aqevZOCXSWIbdAqjcdEurHza7T80QBlg0n5O7hNMmNjJbJ8PN2eO6SszGXXT3no
         X3Y6fg+2oQNp5rStLbkWmlPd182yynb56XXz+s4n1luvYBRXviZJZvh9HaQXwWdwj9IR
         Inow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1vUk1lQx13qclx0e+MpuRQ5ij0W6oFTDg7Zo3xIHwY4=;
        b=Aifg5ql5xW7m0Zon9bITmPkPMnFbV9YRlY8YnXrtXPF8DON0sIkl1HhcEg14xaDQSQ
         dgnzVYdv9o+vk4ipP0xrk4z3sMVHGeifLmLQwW2+yERdsxz6vbOzs+oThzvAX8bCILjk
         Owp10N4cpFSZqRMT5oqhRAH2DNC3zEv3+dRm04WevSSOdERt/ptpMwwM4ZNihJSskJHo
         X2BWCfHerU4K/qOgEU9hPPikeCc7Qf1DV12tqGiJtBVNusAMqY8TBlg8n0TD1UNVJtqZ
         CrzYpRJKyRxta+F6xTi+DLQVnO7ujyA9oG2keBdgLpMFZvp6jAv0bTWkB5H0nb+BB8yb
         xXYA==
X-Gm-Message-State: AOAM533MIRXUcKKPPNSv8lOQYxW3GixjZmNuQ3026kmd1q6U17XDOKVv
        Al9995jpMjgfPxrZRi+tdo3PqJsC5zs=
X-Google-Smtp-Source: ABdhPJxglz79gtcUC8rhrRbgeqvOlwJgVLe3Yuns3lBzkmqC20TKAIOgjPfKlmOn6780gDAseAjb+g==
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr1809052wrs.153.1601627544303;
        Fri, 02 Oct 2020 01:32:24 -0700 (PDT)
Received: from [192.168.8.147] ([37.166.162.133])
        by smtp.gmail.com with ESMTPSA id d19sm991070wmd.0.2020.10.02.01.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 01:32:23 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
Date:   Fri, 2 Oct 2020 10:32:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 10:26 AM, Eric Dumazet wrote:
> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> I have a problem with the following code in ndo_start_xmit() of
>> the r8169 driver. A user reported the WARN being triggered due
>> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
>> The driver is widely used, therefore I'd expect much more such
>> reports if it should be a common problem. Not sure what's special.
>> My primary question: Is it a valid use case that gso_size is
>> greater than 0, and no SKB_GSO_ flag is set?
>> Any hint would be appreciated.
>>
>>
> 
> Maybe this is not a TCP packet ? But in this case GSO should have taken place.
> 
> You might add a
> pr_err_once("gso_type=%x\n", shinfo->gso_type);
> 
>>
>> u32 mss = shinfo->gso_size;
>>
>>         if (mss) {
> 
> 
> 
>>                 if (shinfo->gso_type & SKB_GSO_TCPV4) {
>>                         opts[0] |= TD1_GTSENV4;
>>                 } else if (shinfo->gso_type & SKB_GSO_TCPV6) {
>>                         if (skb_cow_head(skb, 0))
>>                                 return false;
>>
>>                         tcp_v6_gso_csum_prep(skb);
>>                         opts[0] |= TD1_GTSENV6;
>>                 } else {
>>                         WARN_ON_ONCE(1);
>>                 }
>>
>>
>>
>>
>> -------- Forwarded Message --------
>> Subject: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
>> Date: Thu, 01 Oct 2020 19:19:24 +0000
>> From: bugzilla-daemon@bugzilla.kernel.org
>> To: hkallweit1@gmail.com
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=209423
>>
>> --- Comment #7 from Damian Wrobel (dwrobel@ertelnet.rybnik.pl) ---
>> Here it comes:
>>
>> [86678.377120] ------------[ cut here ]------------
>> [86678.377155] gso_size = 1448, gso_type = 0x00000000

Ah, sorry I see you already printed gso_type

Must then be a bug somewhere :/

