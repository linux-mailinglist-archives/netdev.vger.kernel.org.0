Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1942D0CA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhJNDLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNDLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:11:48 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DECC061570;
        Wed, 13 Oct 2021 20:09:44 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id c29-20020a4ad21d000000b002b6cf3f9aceso1426932oos.13;
        Wed, 13 Oct 2021 20:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HE9z5tlF77mRAkHNqcUY/20RBkunTk9T3krwd45VGuk=;
        b=lCO/JQCREM+81cayvh0CHs3V7SF8AZi8+4VOYZPZfk9QH6Uk2pnPqm2euY+mChd1hV
         bjO7WeMzWiZEa7gV+6Bm4yZ21dNlaE1x9RujA4JVmvcxgiv9eMNk0orCLl+aX6SclQs0
         AyY5SXbI/PVot3uWMz25KOfwUJTG6MKsEHC86UEZY+51GrS9dSaZPO5uv94+bhi3oqps
         6Bb05EaGTQ7lllzx7mQ870sX1r/YohiSqheTiYnZLpbohwELF0vOSdl56owztHZTkRvD
         FWeXjaw6+vnfoN06lMOAymwWPe5qish0dtDWbqh3A7UOB8ImUs9GTa8UsEhR/IZx5WGR
         IrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HE9z5tlF77mRAkHNqcUY/20RBkunTk9T3krwd45VGuk=;
        b=lBG6r9UA63OHMGI2Px+U1gc2sU1X+JLgtzbcD6H9vYcltwTBX1TBJ18w3pC+tqqsY8
         TNWVdnZE9bJ3wig9FEjZs+kxw474hivivX4/hMcWYnEfVXMUkDF//5WGT+BgnxcRTgfg
         4P3Ir6BEWzDB0iixApvDXaA/oDMJA3LDOHBAAyfPNbVwVMW5GNO0UIkCmFFpbixSxFgP
         CsjipABUwxa/8qbiJqS5rF0nq6WmZT/G6ziX6Swo4WWNEJ8ZjqRdOspQXhruB1IesIL+
         BeCSUkAvTtKfTelU7nJ2HTNqhmFw4/5iHDrmsletPppi8dxUeXXVPw3ZAFlthEM1y3Gb
         WiTA==
X-Gm-Message-State: AOAM532+Ymrhui9ROYHGpj7shSm/U55I43snJ7cZfkaYCB4Zwvlijids
        J7mZdTpvjCDVeNXTrVI+wyqc5bX0lqzMEg==
X-Google-Smtp-Source: ABdhPJwNRtMu0D2MeivvDWc4qCFUdD03zkvdEBjopiN6PPThrvexnA1SdkWeszmICCg6kI68AJMl2Q==
X-Received: by 2002:a4a:430c:: with SMTP id k12mr2198711ooj.43.1634180983781;
        Wed, 13 Oct 2021 20:09:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id u6sm278423ooh.15.2021.10.13.20.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 20:09:43 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <9eb867a3751ee4213d8019139cf1af42570e9e91.1634107317.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7d8f3de1-d093-c013-88c4-3cff8c7bc012@gmail.com>
Date:   Wed, 13 Oct 2021 21:09:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9eb867a3751ee4213d8019139cf1af42570e9e91.1634107317.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 12:50 AM, Leonard Crestez wrote:
> Multiple VRFs are generally meant to be "separate" but right now md5
> keys for the default VRF also affect connections inside VRFs if the IP
> addresses happen to overlap.
> 
> So far the combination of TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0

TCP_MD5SIG_IFINDEX does not exist in net-next and it was not added by
patch 1 or this patch.
