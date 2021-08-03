Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F773DE473
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhHCCea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhHCCe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 22:34:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE35C06175F;
        Mon,  2 Aug 2021 19:34:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c16so21910222plh.7;
        Mon, 02 Aug 2021 19:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=577pONOMaphoN9DWDAUHRKXcFNjCArt420a6BE3/S9g=;
        b=Dj1LJIIy/W1SeWqguB/enjBKhg4REfLBEVNhaT/94/vR8LqX8wZCJXn4hsN1wGwPAP
         Ch4pEyCH5mZA+ZX/Un/1ShJJAOiRSsHs/JD+tNFDaTdxDiEm4hQCmbSGNIyg65hJUmTi
         sPc12QG5OqRc5W5xew5s8QoJnJ/SYhx7EuiRsk6CTvCmPbAAsQFU1JO2dV/h99Oi9fST
         ypyorUJEJRb+dO9v0psxoKATwdfz8FuThE7sI5DWm9ILTBRt6hT3K2//cskqBcs4wzmv
         5TVa6JBM6/UCaWYTqwqoKwnf6VN6DBwyRlcntROcOIG6moNaSZC6c6c7wbFiwsXL6GNU
         9mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=577pONOMaphoN9DWDAUHRKXcFNjCArt420a6BE3/S9g=;
        b=dp7slcNIxguONbAfQaOQUz0pRH4Lw7TLDaElw4xvoIgV/37S62BaMvDsNJgUdc+Yyb
         GTDYl9cokYTCAv+uqFKqIjoxIjXiIqF/9KWFnnRlM/WpxiFhudMBoaeInROOVI7Jhtp0
         Zi4BTD9uXhoSx7mB6bwnAZUH+aSovBmuQRXx0/rgUTy62sdzZeDidIQ94mgcOCjkqSIs
         8NJXe9KuDJNM4JD9IOuEGJ17ro1EaW5x317sRwo0P2O9v1u+dG13CJenwgJ27LnMF+8V
         xB21YYjQ21DVOFU6DMbY4cyTwx1g6UY6SeICTifOCbcOj4dTKW0N8z7fdubXM4Yzc9sh
         8y7w==
X-Gm-Message-State: AOAM5339Nlkclw/cXxqKiQIBN+5xij7XijPxUxZIRsXgeO3WhGGSd+CK
        AN4OJq621lqkKpucbrkiwj8=
X-Google-Smtp-Source: ABdhPJyOAoubN777cbZj+Wuxd/g5bT16u43jW4knHV6SynNRtSnkCk7RlIoBZ0Y2TYqkdLJT7tXBaQ==
X-Received: by 2002:a17:903:22c6:b029:12c:8da8:fd49 with SMTP id y6-20020a17090322c6b029012c8da8fd49mr16127303plg.79.1627958057418;
        Mon, 02 Aug 2021 19:34:17 -0700 (PDT)
Received: from [10.58.0.94] ([45.135.186.121])
        by smtp.gmail.com with ESMTPSA id h21sm3104574pfq.130.2021.08.02.19.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 19:34:16 -0700 (PDT)
Subject: Re: [BUG] mwifiex: possible null-pointer dereference in
 mwifiex_dnld_cmd_to_fw()
To:     Brian Norris <briannorris@chromium.org>
Cc:     amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        baijiaju1990@gmail.com
References: <968036b8-df27-3f22-074b-3aeed7c7bbf2@gmail.com>
 <CA+ASDXPYbCFsu0zoTafgc3atHvK1TAx=S_NTkfb0UNtKwuZOZQ@mail.gmail.com>
From:   Li Tuo <islituo@gmail.com>
Message-ID: <bfc07f58-80d0-32bb-149f-db8f41672520@gmail.com>
Date:   Tue, 3 Aug 2021 10:34:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXPYbCFsu0zoTafgc3atHvK1TAx=S_NTkfb0UNtKwuZOZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your feedback! I think we can test and submit a patch to drop
the excess check as the example you mentioned.

Best wishes,
Tuo Li


On 2021/8/3 4:44, Brian Norris wrote:
> Hi,
>
> On Fri, Jul 30, 2021 at 9:13 PM Li Tuo <islituo@gmail.com> wrote:
>> Our static analysis tool finds a possible null-pointer dereference in
>> the mwifiex driver in Linux 5.14.0-rc3:
> Wouldn't be the first time a static analysis tool tripped up over
> excessively redundant "safety" checks :)
>
> For example:
> https://lore.kernel.org/linux-wireless/20210731163546.10753-1-len.baker@gmx.com/T/#u
>
>> The variable cmd_node->cmd_skb->data is assigned to the variable
>> host_cmd, and host_cmd is checked in:
>> 190:    if (host_cmd == NULL || host_cmd->size == 0)
>>
>> This indicates that host_cmd can be NULL.
>> If so, the function mwifiex_recycle_cmd_node() will be called with the
>> argument cmd_node:
>> 196:    mwifiex_recycle_cmd_node(adapter, cmd_node);
>>
>> In this called function, the variable cmd_node->cmd_skb->data is
>> assigned to the variable host_cmd, too.
>> Thus the variable host_cmd in the function mwifiex_recycle_cmd_node()
>> can be also NULL.
>> However, it is dereferenced when calling le16_to_cpu():
>> 144:    le16_to_cpu(host_cmd->command)
>>
>> I am not quite sure whether this possible null-pointer dereference is
>> real and how to fix it if it is real.
>> Any feedback would be appreciated, thanks!
> I doubt it's real; the NULL check is probably excessive. I don't think
> there's any case in which such skb's will have no ->data. If you're
> interested, you could test and submit a "fix" to drop the excess
> check.
>
> Brian

