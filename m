Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6729D9BB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389971AbgJ1XCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389972AbgJ1XCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:02:00 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ECBC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:02:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n16so730013pgv.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TUlnabYwJbmwCsAq+3MDXPWMYoadiAajc+ALYtRJQ48=;
        b=Qhhd7c8anPZmWdBLktiMl/rUykryd9F84GkzD6KfPs7wLCdJjgvK3o7TQqTpC8iROa
         r9tWuwxfsvYzGiv7GERO94arW92pAJ0YUwTBDNq5JDMw+7anpT0GAu0D5x/7/cVRfUwL
         raBlz+yqt568jfsAUyCp5OizILWIub/fGK+s/kz2jPiKi33vvBkfWRB9aQ9vDxXg23aX
         m/0py+MiNoCMiLo97wrrANneovtp+tC49aGRYYdXL+KDILJXituSgZY3p76MUsERqA2D
         bDV8nlD5veRiNGIR5FG0QrbfyYSv+q7O2pF5RY9Kuu9tnMxPTpJhO9l82TcXGYqn/XME
         mt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUlnabYwJbmwCsAq+3MDXPWMYoadiAajc+ALYtRJQ48=;
        b=Kqkv6WNtPo6PMu3TCa2+PzQETzafSf7XhxcwUIACr9dk6qpdjgx9DBFYuOn6lR4SNx
         n/uXhGgVYRwRXWOFzJtp0EtlFad7XNDIRJWmb+4cxIvSswHCIA2K10iBwKF+rhY8tw2R
         B2YW53xlFdE2ZtjYV+Gsig0/NHb0SfRtc/wFikDjeahL2RLmosPyeGOVKJ3S4fZ+9afP
         4FTdedS0ra3UOFyaSSKEgzIKxU6/vfm0LW1jzgw2PuTPj7TVYU6cNij+4qX9Ttvdv4sE
         KubiEQJqa9npkdwBCzPbPbGWz6BnAFSmtKHBH3iOcD5g3UUpFdW5nPqzHDFPBLPPoAkG
         q/+A==
X-Gm-Message-State: AOAM532dH4J4Z9FBIkPdslXD22A4Acsk2OLOOoAAMAu1tOOBOADDSn0S
        NhBRM0XtrXSiiK40eZ4zlplXnm9e/Qg=
X-Google-Smtp-Source: ABdhPJxZfezvwGzUluoOtJVRv0UarYbk/SG/dOBiAprj4uONRAx2Tq7+ZjUFnQ2P9q6n/xYJGbrcOA==
X-Received: by 2002:a05:6e02:112:: with SMTP id t18mr6091468ilm.299.1603898570219;
        Wed, 28 Oct 2020 08:22:50 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e1b0:db06:9a2d:91c5])
        by smtp.googlemail.com with ESMTPSA id m13sm2765612ioo.9.2020.10.28.08.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 08:22:49 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Laurent Fasnacht <fasnacht@protonmail.ch>
References: <20200331132009.1306283-1-vincent@bernat.ch>
 <20200402.174735.1088204254915987225.davem@davemloft.net>
 <m37drhs1jn.fsf@bernat.ch> <ac5341e0-2ed7-2cfb-ec96-5e063fca9598@gmail.com>
 <87tuugkui2.fsf@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <feef6da5-efbe-6ab9-0a2e-761cd7340cf7@gmail.com>
Date:   Wed, 28 Oct 2020 09:22:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87tuugkui2.fsf@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 1:17 AM, Vincent Bernat wrote:
>  ❦ 23 octobre 2020 08:40 -06, David Ahern:
> 
>>> I am wondering if we should revert the patch for 5.10 while we can,
>>> waiting for a better solution (and breaking people relying on the new
>>> behavior in 5.9).
>>>
>>> Then, I can propose a patch with a sysctl to avoid breaking existing
>>> setups.
>>>
>>
>> I have not walked the details, but it seems like a security policy can
>> be installed to get the previous behavior.
> 
> libtorrent is using SO_BINDTODEVICE for some reason (code is quite old,
> so not git history). Previously, the call was unsuccesful and the error
> was logged and ignored. Now, it succeeds and circumvent the routing
> policy. Using Netfiler does not help as libtorrent won't act on dropped
> packets as the socket is already configured on the wrong interface.
> kprobe is unable to modify a syscall and seccomp cannot be applied
> globally. LSM are usually distro specific. What kind of security policy
> do you have in mind?
> 

nothing specific; I was hand waving.

There are bpf hooks to set and unset socket options, but those seem
inconvenient here.

I guess a sysctl is the only practical solution. If you do that we
should have granularity - any device, l3mdev devices only, ...
