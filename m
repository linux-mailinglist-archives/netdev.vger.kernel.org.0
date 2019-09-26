Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE28BF533
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 16:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfIZOnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 10:43:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46666 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfIZOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 10:43:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so1661807pgm.13;
        Thu, 26 Sep 2019 07:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jNdgPZH4pEjhG+dTnjeGV8hSbsj0xVEU/isgoWCCkII=;
        b=dQW1+e7VzNNFdh1fXvomKhMTUOjvWawf0uQGeUnUtKJb6HbpQF7MflsS7b6N4Xj0ZN
         EI1eoz8OzxEOCTQQ645XK7Im9AakdQuZyq5dffRMT70IWT0jhjWwafKOAnnGWOCCHKzb
         poIldBKbn6Cx23JIqMvK8ZW78+YWmauMPQjeu7gOr6nHK2NUgC8eYCgTZ6sMeGkfF17z
         Kw4uRxOeH/9qm/xcixg4jGvsquhXovfTPJYyS3GBVY2xSteKKo9M+5VfLZ3DNWnDVOK3
         GC7nGuxt2zeQSwDd30W113r7wqISl/eNS7hRgf8ZbXi0RKA2aMoid6ToImjSvZG3ntxD
         CHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNdgPZH4pEjhG+dTnjeGV8hSbsj0xVEU/isgoWCCkII=;
        b=kM9TfisvBtrYohj23jLDpkHUJYXqvRckoPo+pmw7ZSKAbO70CkQKwKffttafdHaCWr
         5yKGYkbLJsWVFZS18rBW4d6urLWQnQ2CtR6cvhCFWHFxRxG3zOq8Sx326o+Z6IhQZBIo
         wtxsW75olE0C7JAHNb5geDK07nzHB3FEIcgqNic1TUR0TTct0cU2eL16gwjWT5Vk3ukL
         WQUUk0mAvA1vwcSw1z9lDbWjvarNxL28tlF/L0EvQ1iXIASTMM9To30yRBkDltRBSOlS
         0X8yJ1+4mdyvdQvTiPXCmB8Li7mgl/5JoR4m6FZS7HXdlSryMnMiHBm/y5Jevt4l3Dig
         MLmQ==
X-Gm-Message-State: APjAAAWiHXcBuDvr0UuXx9hF/ogy9vWVl2eeCY6bJs5Vimmjyn4jIbOf
        xiOY3wdj/qDUt1gxGG8cl9Wj5+STuaU=
X-Google-Smtp-Source: APXvYqyNjb36i3ndCum2uolyoO0lv4ZL9MLFFRzDxCbrHgcWQ9EciECYsZ6GFrTBVdgaRCNUVAN/sg==
X-Received: by 2002:a65:4782:: with SMTP id e2mr3491673pgs.402.1569509031156;
        Thu, 26 Sep 2019 07:43:51 -0700 (PDT)
Received: from [172.27.227.146] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 16sm2761383pfn.35.2019.09.26.07.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 07:43:50 -0700 (PDT)
Subject: Re: [PATCH v2] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        weiwan@google.com
Cc:     stable@vger.kernel.org
References: <20190924.145257.2013712373872209531.davem@davemloft.net>
 <20190924140128.19394-1-Jason@zx2c4.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <22ee9da6-6bc4-7f6f-d19d-1d492bfe8e7e@gmail.com>
Date:   Thu, 26 Sep 2019 08:43:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190924140128.19394-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 8:01 AM, Jason A. Donenfeld wrote:
> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case added here
> causes the reference underflow by causing packets to evaluate a suppress
> rule.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/ipv6/fib6_rules.c                    |  3 ++-
>  tools/testing/selftests/net/fib_tests.sh | 17 ++++++++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)

Thanks for adding the test case.

Reviewed-by: David Ahern <dsahern@gmail.com>
