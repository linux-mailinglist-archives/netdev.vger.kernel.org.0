Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFAE3DDEDA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhHBSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 14:04:14 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D174FC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 11:04:04 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id o185so24986572oih.13
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 11:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ub3iNB9nu3tAdrRcFhLthYkZMNu6YCAg1v/gDWW65is=;
        b=M3dmhjpAiRH2+7OT+1Bz2opmZfitPS8r6XDKxv4TJGhI45F4r6HuzYBzQJjB8vMznn
         ojLSoQ+FDZyaNuDlP+Im6A/FXzKYIxt9bHvjkAMZSwWZ5o8oDuQMCxepsuzr0S3QTG5x
         573PIeXJJfODTPiVA4jtx9lC5T2jCDrOikasrXbWyEwDHMNiKIaSgACp3vJ1VocLemuI
         iudeT5vwVmxv0BqzQro/r0wOR9EyvjxUgz0QEuO0D1LbDSERnPNMRS2LWpapMrGrlkB0
         pGpkOX3Z8+gY1lppFltKtnkpfQTRKVN5mIuZwNNQow8qY1V8CTOSX+NzhVE2BzGOuegR
         F2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ub3iNB9nu3tAdrRcFhLthYkZMNu6YCAg1v/gDWW65is=;
        b=CACZy2EPNTEjQc8WVSsqw4N6taU7o388IlLdeQ17OJ5IIZ+4U9Ed4yPwt+LtiOQeAm
         6Hle4KY8ZPR4CQfTWBlCJoiGmxG+EjfnFjcWSSVWgDhWzpp6Cw/vMJ2GSoTQEuz3sTR/
         1dULw2wJhvXJebXEkU1aogMWTGNRP0B8ftdxt68PIwEl3v89AWx/vE4H2y+TIipniPI6
         uHLZKX+VimAxQIQpunFS02xuL9vRFwiAAIgiwnSYUp9KS1umK97NNtlDqOIZIR4gtVfi
         Bcag+xDqgv9mg2PGGpGjX1iLa5NL24skq6NM6qy0eYwvNA09/YWTVe9WNzNue6RZmAjA
         iJLQ==
X-Gm-Message-State: AOAM532IxVXl2gJPYlzv44TziCjC5z+14qHMpusD7rOBaBjp+rzdL5u3
        duHEnV/21J3Nv5To9pfxMNU=
X-Google-Smtp-Source: ABdhPJzYdDKz5E0ryiA7GksamLuu6rjuxlI0PhsIE09DmgpgyUPE17tP226svioERasQdlo/R/brSg==
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr11376281oic.51.1627927444231;
        Mon, 02 Aug 2021 11:04:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id c11sm1813987oot.25.2021.08.02.11.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 11:04:03 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv4: Fix refcount warning for new fib_info
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Ahern <dsahern@kernel.org>
Cc:     ciorneiioana@gmail.com, Yajun Deng <yajun.deng@linux.dev>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210802160221.27263-1-dsahern@kernel.org>
 <332304e5-7ef7-d977-a777-fd513d6e7d26@tessares.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <21559c43-d034-2352-efe4-b366d659da7c@gmail.com>
Date:   Mon, 2 Aug 2021 12:04:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <332304e5-7ef7-d977-a777-fd513d6e7d26@tessares.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 11:58 AM, Matthieu Baerts wrote:
> Hi David,
> 
> On 02/08/2021 18:02, David Ahern wrote:
>> Ioana reported a refcount warning when booting over NFS:
>>
>> [    5.042532] ------------[ cut here ]------------
>> [    5.047184] refcount_t: addition on 0; use-after-free.
>> [    5.052324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xa4/0x150
>> ...
>> [    5.167201] Call trace:
>> [    5.169635]  refcount_warn_saturate+0xa4/0x150
>> [    5.174067]  fib_create_info+0xc00/0xc90
>> [    5.177982]  fib_table_insert+0x8c/0x620
>> [    5.181893]  fib_magic.isra.0+0x110/0x11c
>> [    5.185891]  fib_add_ifaddr+0xb8/0x190
>> [    5.189629]  fib_inetaddr_event+0x8c/0x140
>>
>> fib_treeref needs to be set after kzalloc. The old code had a ++ which
>> led to the confusion when the int was replaced by a refcount_t.
> 
> Thank you for the patch!
> 
> My CI was also complaining of not being able to run kernel selftests [1].
> Your patch fixes the issue, thanks!
> 
> Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> 

Given how easily it is to trigger the warning, I get the impression the
original was an untested patch.
