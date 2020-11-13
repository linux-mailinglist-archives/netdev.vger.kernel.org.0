Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B41C2B217B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKMRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgKMRGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:06:04 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DBBC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:06:03 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id s24so10427434ioj.13
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 09:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZzkYhypxoa0I35MEZMu6CatIuch2sLYMY75i1GLDhAk=;
        b=N/rEvcJciwRZ0TmHIkucL7J92F2KZiPZCY6KRz5Cl1tXfe1WXT6DSuwCAmapix8m7y
         8Wb3eNIpsN3ao1N0PfYGDvPCKywcAnGyWWQCqkczekiHu5MVBBUSeMEXReKIpFUhEJWh
         yDRO+JpiONhNTgEV01/hKHjRfPfyo5IQud8bowJPJS+7jvzPvIOitzKkkYvLmyLbYc8m
         JvJBmkYbbc752odJ83Vto1XWnJbrcPkCZXu6i+Lz29Pi6VzzrQqRM0l/3Jf6MdWaL2Rx
         3VCP1cM6h7jYuhYmGHEpVX3gCsbEfefx5sbFpJcuUL5GGD18bZzy1j/u3ADDNrXjsep+
         wimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZzkYhypxoa0I35MEZMu6CatIuch2sLYMY75i1GLDhAk=;
        b=ckPC78XJEzRrRn0/Q28YpTqHj3ONLZTOZ59waeqlqmhCLuL8bLyKmzzRuKfASLq1v9
         SWJ927VsJ1bllAuAIBsf61Wl5dIM2TDQLVduFu/Eh3jfuUp3n2wi+v5f4HqH7RkaDWDV
         ZpH4bOC+/7SjcHaKreHjotfzUcsApy5X7C+8kUFDR1I10DRZWTfaE8cUuy86aDtHIoiN
         u/PtAwRX6TEurrVGLgvICRB+LdIrkewnKILj6UJALHViNXcADCex8/35jvpmN09S78ok
         lJK6NtO17mQCgdbC/AwO3C2sZ6keCPzOy2bk5neKCHBBcDALRdI0qQMyWwu3rkeEMGFE
         knGA==
X-Gm-Message-State: AOAM532x4y8/xMQ0SXJOFIhDQyYMuYURFBcZR6f/uu1NuUXYeTEHha/R
        1DOQIXhIs5Tj7M4DNDtK0rkaiq2EpT0=
X-Google-Smtp-Source: ABdhPJxXznnV/esZOgtrlS3oXUVMQHFHjM5WQ9Pm7JSqoo1j7tnQpmPWkrrYaHdXzm/3WbXc1+wfGQ==
X-Received: by 2002:a5d:91cf:: with SMTP id k15mr529700ior.161.1605287158333;
        Fri, 13 Nov 2020 09:05:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id y19sm4773095iol.9.2020.11.13.09.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 09:05:57 -0800 (PST)
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <202011131747.puABQV5A-lkp@intel.com>
 <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c7623978-5586-5757-71aa-d12ee046a338@gmail.com>
Date:   Fri, 13 Nov 2020 10:05:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 9:57 AM, Jakub Kicinski wrote:
> Good people of build bot, 
> 
> would you mind shedding some light on this one? It was also reported on
> v1, and Andrea said it's impossible to repro. Strange that build bot
> would make the same mistake twice, tho.
> 

I kicked off a build this morning using Andrea's patches and the config
from the build bot; builds fine as long as the first 3 patches are applied.

