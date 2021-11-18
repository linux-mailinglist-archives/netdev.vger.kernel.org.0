Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC802456016
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhKRQID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhKRQID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:08:03 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48E8C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:05:02 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6111593pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Wi+Td4r6H8IIPLc8dF3k1j/ASIXAJ6TaqjW3jefuu4=;
        b=y8BrdIWd6j3fW08uIhNafxOmUTaRaAPfhiyhQhOeooRKedZI3RpfTRhlQ+Vfo7SaIR
         Xr2fL7Xv/lmDfO2wWkzoq8vWGyRWblh/L0Hfqs5K0Us31pQe6etNyd4b4JkCzZHZLQwT
         q/L5kkr+q3xbVdbQAldvQJra4tCYbzptGTKjnS+ABaEkHfAlui6uHFa+ssHoYLAyenWQ
         iHG1jDOjk1lZ3WG/upN1shTtN0DcKHjo/z6O+xdHqbIgyfZU2tYoBtZomn4fNFUEz+ZY
         3UyIL0GX/JY8WIuBkQ6drZJH+yYB5Z2axDxMivR9ZrLtWzKFtshDrwdHNPG4YXBIre2n
         PrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Wi+Td4r6H8IIPLc8dF3k1j/ASIXAJ6TaqjW3jefuu4=;
        b=7yko7luL4p1uzicpZIOAaK/sJjMYFfUrzzPl2nr5aZbZpT0XpQbQj/0mk4iqM7FEoz
         VCwV6q4D/P8lMGhehr8SHdZy+/tfeILwFCCI0y0AmNu/7CbQYho7X8BZwf6EMi4i67Ra
         p0C/xeEqL/ZtN8Uf4fakcsGXkNlK+z9rR6w61aBaMYZD6VBvr3KHvlNefRkoq+QLJH3I
         kMrXVMMRaUvJOSvSYdZNKFFNOTf/Ixr+KGvnfRykcP9R45fDgIOL8/um8Vb5E8LgDiOa
         xTrkDhOL69o5KNe/R2ovUJN0gl7O/MLepSKcL55Qa8v+TC5rLkh5wEkx0qBGWLk3i+KC
         VlUg==
X-Gm-Message-State: AOAM531tyWLqqXX/i2aNLzzhEW6tvwmUBOFg3bT+Q6kdpSJbTVsF7LbG
        sxtYATEOLeZrQty6cjT4Nr0ouw==
X-Google-Smtp-Source: ABdhPJz1llsX1uFZObnslzRKEjH6GvDzvEMwxhybikyDQV7QNbEw5Dwz6b/Y9m4zt+2VA9kQIyfu5g==
X-Received: by 2002:a17:90b:4c89:: with SMTP id my9mr11577476pjb.229.1637251502237;
        Thu, 18 Nov 2021 08:05:02 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id j8sm104637pfc.8.2021.11.18.08.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 08:05:01 -0800 (PST)
Message-ID: <90fece34-14af-8c91-98f5-daf6fad1825b@linaro.org>
Date:   Thu, 18 Nov 2021 08:05:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
Content-Language: en-US
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     elver@google.com, nathan@kernel.org, ndesaulniers@google.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, willemb@google.com,
        pabeni@redhat.com, cong.wang@bytedance.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        keescook@chromium.org, edumazet@google.com
References: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
 <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
 <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211112.154238.1786308722975241620.davem@davemloft.net>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20211112.154238.1786308722975241620.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/21 07:42, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 11 Nov 2021 09:54:44 -0800
> 
>> I'm not sure if that stalled due to lack of time or some fundamental
>> problems.
> 
> ran out of time, then had a stroke...
> 
>> Seems like finishing that would let us clean up such misuses?
> 
> yes it would
> 

so since there is not better way of suppressing the issue atm are
you ok with taking this fix for now?

-- 
Thanks,
Tadeusz
