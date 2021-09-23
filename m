Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C534161C3
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhIWPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241792AbhIWPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:11:59 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD41AC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 08:10:27 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 67-20020a9d0449000000b00546e5a8062aso8891985otc.9
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sR+FPZ6feC/HJkRNXfbYmOL8Bok1T94jo/Ne/ioKryY=;
        b=k7CdHHK90vN56r9sAAIM892j+keVCkXXaGMgOWduO90u1fR5/MnkIlT0SsGqyo00NQ
         Zp1D5DvoJYgyatEFfN/q6jn+nnDJw9LmpK+RORFAdTPVXfyWBWHsqQUNNr5vbLAXcikH
         R7fK6+aU75pUSurJ5XLYpdxNZ+mMcq9SCJRHtZ9Ro5nHN9Nc0IowyyKj5RFO6tuy16lg
         o4/673r28+nkhLb5oVnWdWqGbeWPHcLLqANhqzVgV+MOjlS/Z/nV42PDWNcCxTiFG/Og
         xNJ8BOa4/FmENGTeKzr9S7eIQE5FZYwtEJYhZkEuf+/CWUUgbeMsuLlPHdNzd2T7Pk9a
         uM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sR+FPZ6feC/HJkRNXfbYmOL8Bok1T94jo/Ne/ioKryY=;
        b=R4HtArFOe6t9PXpVHWSJ9T2mjV9rlVUnmrF3M14MbNI4P0dREjvGNERcVYE6FEHeIe
         IYPv6DKAgEYHWF4Sj0nG83oRJew/xQvbPhMlZ4z0yhET+hmn/lZWuv7KcFTOFiYwh8SY
         bSsgX61DA2uUmPsxXOJPWcdS+pOGzf3++lbYQ7MPmGLiW2jG6nyO1vomROhmv9ed1IGf
         KvTZV9aeiOVdb9CAErO0lABwA5xj/Algz01N2aUW0LSSTt+Iy7alpwA2ZkmRPAwvIiU8
         oXHfcX9WLHp+u2gV32NWcNPCIJPCj5nATwcOeudMcSVZO/duGLIMY5SdSB0oJKGci3ix
         fr2Q==
X-Gm-Message-State: AOAM5314d+gLxEdBf4/jI2lbXtQkzxd5RWjCejP3bLUcBLX1sf3vAaI7
        oRiiaHkewWRdVWMLe2bP3V4=
X-Google-Smtp-Source: ABdhPJxdqDvv0kBW5t9jg92XkXnwoZmUBvdV4UiU8fjmsli6PuYSwP5A9c9HwD7HmiKggg7mwEtyDQ==
X-Received: by 2002:a05:6830:118a:: with SMTP id u10mr4835476otq.32.1632409827097;
        Thu, 23 Sep 2021 08:10:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id i23sm1131980oof.4.2021.09.23.08.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 08:10:26 -0700 (PDT)
Subject: Re: [PATCH net v3] net: ipv4: Fix rtnexthop len when RTA_FLOW is
 present
To:     Xiao Liang <shaw.leon@gmail.com>, netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20210923150319.974-1-shaw.leon@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <83b55c4a-3564-ae55-534d-c1bc6f53084a@gmail.com>
Date:   Thu, 23 Sep 2021 09:10:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923150319.974-1-shaw.leon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 9:03 AM, Xiao Liang wrote:
> Multipath RTA_FLOW is embedded in nexthop. Dump it in fib_add_nexthop()
> to get the length of rtnexthop correct.
> 
> Fixes: b0f60193632e ("ipv4: Refactor nexthop attributes in fib_dump_info")
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
>  include/net/ip_fib.h     |  2 +-
>  include/net/nexthop.h    |  2 +-
>  net/ipv4/fib_semantics.c | 16 +++++++++-------
>  net/ipv6/route.c         |  5 +++--
>  4 files changed, 14 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


