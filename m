Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFF437318
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 09:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhJVHyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 03:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhJVHyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 03:54:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8250C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 00:52:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y22-20020a1c7d16000000b003231ea3d705so2367715wmc.4
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 00:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZGkkcIATP7tkJhI/YWZUq+/pAJoPOuk4aY2DDO0hra8=;
        b=OXGtnWpuobS+pJd4nmeaN8nEKYGiiT5yhs/yH7P9n81r7E08crC5THXfbeoP0LlsW8
         1Itb6xcTMq8SQB62LVO1OOPLVnknJTohlzbdMJzomwsbquppjKaZxAPDMhlUowmuVgIm
         rI+dH0Iw74hP5BwEer5iXDRC2EbwOK8o7UDN7R5CH3Jo2SH4khrsG7nBxijwVzSfKcbj
         xi9CsoTtLrg4SfND6BBh39PSCJDpfJMDbb5UyRokqqHl6Df6DE0LoAw8pitDmWkt2JNW
         Hg4PfRUr8ThIJ+RS4dA51Yd7uBBJfoWiO6T2UUhsZjWD1Jis3RjVk5w1QhDZCh8sbg18
         Uhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZGkkcIATP7tkJhI/YWZUq+/pAJoPOuk4aY2DDO0hra8=;
        b=64w4d/91CGAhz6wi4HzTa/nZ9kSSc6sfA8MS7Z9hNdrXRzNn2Kx9yu8OMOYTYilR8o
         yAVC+6lhzPqeM4QXbPZHF3o+BbMDIkkwwb6v88aZxFboqVhuQq19vdQGL+37THdzmPja
         wceuMAiGA6sUd6LbZLDsZ4/BoxyUOC0YySF8pw1Q8uHL8J4pgCjWgmDlWoVuPOjmkheW
         2Twx4tlke4IB6HF6/5Sf7VavlUR6XyYdv+kr6120kRU8ag+fAp0He+Fjxmti2ApcDN8a
         WUwkeVKV428E6yHHIe2AN6lRAMQZh9wXF5XmI2N1SEpsX4iGjqZ7a+SYGKdqxRbf/Z7b
         L9IQ==
X-Gm-Message-State: AOAM533IbUMwGj62kExovSPo54+/aKBSCmGfATHLA+qnx3cHtUz3GWse
        Aa3aJ0lPDMcnVImRDu5aIpH7Vg==
X-Google-Smtp-Source: ABdhPJwcMSxU2KnkdD4TtHsImST7xVvjXBnDmJMNqxZcd5jcVBfHFCaexxm6dUrkpFSlWLD0jarjOA==
X-Received: by 2002:a7b:cd8a:: with SMTP id y10mr6316137wmj.185.1634889145405;
        Fri, 22 Oct 2021 00:52:25 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:7427:5864:e0f7:67ef? ([2a01:e0a:410:bb00:7427:5864:e0f7:67ef])
        by smtp.gmail.com with ESMTPSA id u13sm7497788wri.50.2021.10.22.00.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 00:52:25 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2 v2] xfrm: enable to manage default policies
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, antony.antony@secunet.com,
        steffen.klassert@secunet.com
References: <20210923061342.8522-1-nicolas.dichtel@6wind.com>
 <20211018083045.27406-1-nicolas.dichtel@6wind.com>
 <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
 <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
 <5e6586d2-3bbc-1499-a578-77f4a2320801@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <13d6921b-6779-7b72-439b-734ba97783e4@6wind.com>
Date:   Fri, 22 Oct 2021 09:52:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5e6586d2-3bbc-1499-a578-77f4a2320801@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 22/10/2021 à 00:10, David Ahern a écrit :

[snip]

>>> that is already updated in iproute2-next.
>> But this is needed for the iproute2 also. These will be in the linux v5.15 release.
> 
> new functionality is added to -next first; that's why it exists.
My point was that uapi from iproute2/main was not in sync with linus tree.
This is now fixed.


Regards,
Nicolas
