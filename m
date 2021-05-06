Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252883755E1
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhEFOrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbhEFOro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:47:44 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09734C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:46:45 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id v24so5699140oiv.9
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AysahfEni+wUr8Lln4oVGNY9wuIa3qppcoTpN4tVNRY=;
        b=vJ1dxDQxwlb2SnbfwRTdLdBXjnRCDTPnPyk+Ur0PBHTaP2TNVyZfTzyqOcl33Brjh8
         lktRe0oocBb9uvf7e+OAdxFJLFIVeWSAoTJeymPX1rF/t+5DmPRXiSlIPjEBcevc+ywk
         YqGh9OjPKSV5cK6Fjrz7dAWvbuqUB51elNTfRrxMR/aiHZ881TzTuHut7CtYeN8o/svH
         v5RqsDurpi8V0jP/Tb62ozDb/QAQMeyM6Wf4GTqQ1BG/qltmWA1qAyVcVkn56XGfde9r
         Ak2ShJgU+T+aUN6cUUg9SJz3z4UnQCBajHHzVgMI72aeDCj0opexWFyP+brS2InwTvjS
         nRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AysahfEni+wUr8Lln4oVGNY9wuIa3qppcoTpN4tVNRY=;
        b=tF3eu3nB5dr/AioAQQfG05r1dwFEOxk2iAvVybL3RdSFiylUBnOV7NqHqrcZrj+kKu
         NbYyo+jENzlUaq6qL/RLaRC3DwADqw2zNWEuI+TSoA5xMRZMxEbnLjaS+gD2kwtaKYPy
         2oS7Q/kJmYLcfpuF+OUQxLD7AhXEDH5Pyj3Zi0wha7VRAskgjE90q23WXv/2XNXm2B9R
         +0ElWHP4hkP1ciazuN0Hl8O7/3P1eiMtnI/UuyXiGaXDv4md+a80tRPCspoPCBbP4CzC
         M7ldPrwtxIhWiVWbNW4ZhsBWDcNoTWIc3f+Yur4nuJyC3gmdsR54OtpesYfpv6cOM1kv
         2Alw==
X-Gm-Message-State: AOAM533oBy11erpQ+nED/mtfRaN6CujJySLeOXBaRnDgd7WgspdsKtVI
        rCmE1WFHxBzumjfEsQgWMcqp2bueBtI=
X-Google-Smtp-Source: ABdhPJwnIreIULShBKU8nPn3uS6jacpONqwXSkR0HaU2Yn6cemup3igMGEE/jJayUlEkSBBAXDiKMw==
X-Received: by 2002:aca:4ec7:: with SMTP id c190mr11436852oib.32.1620312404560;
        Thu, 06 May 2021 07:46:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:73:7507:ad79:a013])
        by smtp.googlemail.com with ESMTPSA id r14sm628455oth.3.2021.05.06.07.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:46:44 -0700 (PDT)
Subject: Re: [PATCH iproute2] lib: bpf_legacy: avoid to pass invalid argument
 to close()
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <a401273d9c2e965d11c07cab76016d350b4f0b2c.1619887571.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54b95593-ea0e-dd20-ead6-3babab7b42bc@gmail.com>
Date:   Thu, 6 May 2021 08:46:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a401273d9c2e965d11c07cab76016d350b4f0b2c.1619887571.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 11:05 AM, Andrea Claudi wrote:
> In function bpf_obj_open, if bpf_fetch_prog_arg() return an error, we
> end up in the out: path with a negative value for fd, and pass it to
> close.
> 
> Avoid this checking for fd to be positive.
> 
> Fixes: 32e93fb7f66d ("{f,m}_bpf: allow for sharing maps")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  lib/bpf_legacy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

applied

