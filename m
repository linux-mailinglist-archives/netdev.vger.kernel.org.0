Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430993ACC8C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhFRNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhFRNq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:46:27 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96290C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:44:17 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so9773806otl.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s3nExGaa123+HTz/XBu/9Xe1ZsS9cU/LEw42UZzjURU=;
        b=Q6WApYjBuGpB5Jf+fGYgI9zI+wZx7eJVbenT3jAX5GGTJhJZ3W68PVk1R7J9lZHBFA
         C0uNpPJxMuBhvJI2XrZda9sINX1kxNtNfmdGA1c8oy7FIB6eWy3id0VknyWsKr5P1rrL
         q0FBVBd3dXSYNRRf6oWOCFj9BJtq2CJ0X7YqebceQ8doQCnwpGis14gJKX6iYXdoYn2h
         5RkqZZGZPbR6NB9kGYF0A2Q60I4VQ/5zkQo0zzso7z/hR6+VmowPI+NHmvTYHgdG071M
         FivnWeDRy/EBZoXGJSaQ/9wCS5xY0XHu3kA/5I16ue6eSWB753dydZzLwsYVVeJRadTK
         ryag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s3nExGaa123+HTz/XBu/9Xe1ZsS9cU/LEw42UZzjURU=;
        b=fBFuph+sgQtAexmL0JO5fI8oFLL2G5N8vZ26tyNVp5NVyYUG4/3K86+nv4Sw5u4jWK
         JRT9DQ/JQdky9Sl8DS/nAhPsmpRfhUH0XBYekuc9R27UnilhpLBFyrh8opcgVTdvY4Ql
         HN8DHYtOQc9DGrWMw0nBhEiy4SlmiNHRN1J04sfe78xKotp1yHheP/FhA63wCthX2J1R
         M7yqNqNO+nx5m3UOEVeIKgg+0fTbf8KAXW6ZxgR0sdu5YVy/UfBcGMS5Qd5RxxaXrOYW
         eP6UDgmd/7SHyCpqBDk5RFhIZ+SgpWkrp4l5DLleSqjDNWY4IsVSDW62WIVGi3rbc6++
         iNUw==
X-Gm-Message-State: AOAM532HGsln9L3j807Hb9LeGQIHRAMdLkakg7ww28P8PqkYSoslbz96
        JVPMF5VIR84h/zQZeZ8m+Gw=
X-Google-Smtp-Source: ABdhPJyW/SXJOSJ1m+/t7zl+65FbenpSGs2JLVdKXlLUA92J5YIty3QPWT2O9X+zHMSuzHaYa9tntQ==
X-Received: by 2002:a9d:a78:: with SMTP id 111mr9709976otg.93.1624023856956;
        Fri, 18 Jun 2021 06:44:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id e29sm1826945oiy.53.2021.06.18.06.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 06:44:16 -0700 (PDT)
Subject: Re: [PATCH net v2 2/2] selftests/net: Add icmp.sh for testing ICMP
 dummy address responses
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
References: <20210618110436.91700-1-toke@redhat.com>
 <20210618110436.91700-2-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91915a59-2e69-112d-6fcc-5ba07ad6d313@gmail.com>
Date:   Fri, 18 Jun 2021 07:44:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618110436.91700-2-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/21 5:04 AM, Toke Høiland-Jørgensen wrote:
> This adds a new icmp.sh selftest for testing that the kernel will respond
> correctly with an ICMP unreachable message with the dummy (192.0.0.8)
> source address when there are no IPv4 addresses configured to use as source
> addresses.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/net/icmp.sh | 74 +++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100755 tools/testing/selftests/net/icmp.sh
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks, Toke.


