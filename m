Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA4214F73
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgGEUlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgGEUlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:41:11 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499CBC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:41:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z3so6830335pfn.12
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SYBh4KDQbact5IFFg/52J3KIFLzTz0f7abJjdDHUEww=;
        b=B66DDPs//ma6pfcC/uCi/Sojnsn4W2DtKLZzDM5lMY03RHYYsZiDJ1BFmp6JrQ0TA8
         C/d+5eG+a755ZiuGbNWgd2C7KhR14lHDjZMyEZBeS2zeiyCqWeBXv8QdC22GiiBX0NnR
         3ITu5R9ERXjpHBH3lp+iybykopx6KNGrTuKhCxU17rSgg9YBpyDvPtTfmiH6g9PEIvrq
         HzHyewZNHTHKc4kRvpwaWKk7o6mmMKNb/Gn94VpOO9pyHJb6B7UP9R1cxcXqz2S28hxG
         RH98wj2oQ9Lkl3egpBuvMVAg41LakpR8uc12uKyRhYauYXr1rUKFfkiYZsbPke/tlL9p
         7pPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYBh4KDQbact5IFFg/52J3KIFLzTz0f7abJjdDHUEww=;
        b=p07Lf99kKEObpFhbYIhG+MHw79f1cJLFHD600WkTxoPzkNyyyO950dRrAaJI1Z1cJI
         7K+PvVqcjjFED5hZkE0tSGg7tutmJWAxRXJP+lqF1d++l0iiyMzuZdTsl2+Lhi2OnoQu
         ktdX7xPBWoVpKR/1mEZXpFWdn01DFXGnvUf5CTKFdVsAGKInQEKQEW/Hrch+Mc9v3+YM
         5hKlsc++mnPIHZHyUL8ATT0kYZVhz2bXxiqUvRZDHbKDw356KEGn4EjmZmWHQywW814G
         XWp28pBLjndzVIFSOsUOR1azW36Y7PKxP693tPog5ETt103PXIdb+8B8ysbn5eQ0qQnb
         pA/g==
X-Gm-Message-State: AOAM531fnqKqFp8tsPhtv6fGgjQvBKf0Q2gtvf6MPnYC6CkGRpK61Rfo
        y2VPRi84ZUewpwvjJAF6qa8=
X-Google-Smtp-Source: ABdhPJydR7zBaojoNXE954EswSScNSCY2bzC4zu5OLKD7WIE2fzdkc9Yy8TUbIbWwwooHnMST5ApMQ==
X-Received: by 2002:a63:7cf:: with SMTP id 198mr36702822pgh.309.1593981670918;
        Sun, 05 Jul 2020 13:41:10 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id y24sm10684047pfp.217.2020.07.05.13.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:41:10 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] net: dsa: tag_ksz: Fix __be16 warnings
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705193008.889623-1-andrew@lunn.ch>
 <20200705193008.889623-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0d9e0de-adba-4309-83f7-c85783e7b557@gmail.com>
Date:   Sun, 5 Jul 2020 13:41:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705193008.889623-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 12:30 PM, Andrew Lunn wrote:
> cpu_to_be16 returns a __be16 value. So what it is assigned to needs to
> have the same type to avoid warnings.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
