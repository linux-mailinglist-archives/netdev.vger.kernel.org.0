Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB03142C26D
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhJMOMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhJMOMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:12:08 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B881C061570;
        Wed, 13 Oct 2021 07:10:05 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o83so4011615oif.4;
        Wed, 13 Oct 2021 07:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sH2np1Z5DqUsKwfJsrhSIKuDd4dJabl7lpV2qrEKXXk=;
        b=i3dQHCuWdjrzzkPtO+lEO88H1wFEN+V5IAhiBbw3vqAx9G1gpXsIftg+UECSezcD/s
         wS8BT+I0s5t1YrHepnY6ta8a7TTEhhcHhR9zf1zJp7yZXYnj65+WNLOW4QRJ4mFX+FU0
         YS3sbKu4UTblWDbuOx/3M0VgawyWkWTvrr3PQAe7+OxrNRdtuXUnEBeHDzpF4t55wGDd
         H0uVmIRZOcHW+y6UjAKSrJgd27D4fcXKDQoJmytigI5xnyrkgiv5zAIMXGiaziNCATwW
         iU6VHqotdtldcGv70xVNmmiqpQjxtwi2nMP99uzaPbX0SorUDNZdQUBJp5kuH1zfx2KB
         gU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sH2np1Z5DqUsKwfJsrhSIKuDd4dJabl7lpV2qrEKXXk=;
        b=Lz5yI2ra/kf7FbMCEe5IpT2bs3mmvc23N8q7EK6V2TNCzCovAZ0e9CB+Hrr6zq9ppO
         +AkIC72QwDvHfdYbxXpbAgwzvc6aBcGiNFZmctTk7GNym4goyzJn2KhBwO8ZKkQGTagh
         MFYm7H4Yfk4sBaDpV2gyHkWajEJ6zQxFHdGrMgr55oseMjJZTaYqGaik7YkjMaPn2Qqf
         NjDVVyFYjCZcmeK/Ij4ckpTJcCAp/Bo/9fFJk/IbxzHhhlVy4lRwv9bkWXbsE1/aPpmP
         XmC5FE3FSzak/lb9FkAJfiw8EXoEkbXEEbQ2FsMBnQ0IfuGAjQtmZNbek66k1fOQ/A6x
         NOZw==
X-Gm-Message-State: AOAM533OSVVRuQhbftKchr6yoow42+L2fC401P6WOcYYWXecWgFnZnq5
        pQCT03FYooSBsamex0TrUa/uaLGJ7S2dRg==
X-Google-Smtp-Source: ABdhPJxgVEo5Pls4v2RcQcKESUVDlgm+nd7W2QkSmLaFcWlm4izezcDlrVtsKHVTj62BQnrZEW4cfg==
X-Received: by 2002:a05:6808:2217:: with SMTP id bd23mr8612895oib.175.1634134204586;
        Wed, 13 Oct 2021 07:10:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 4sm3041872ota.48.2021.10.13.07.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 07:10:04 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net> <YWW4alF5eSUS0QVK@shredder>
 <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4504c95-7b18-1574-1a16-b26bbcd924b7@gmail.com>
Date:   Wed, 13 Oct 2021 08:10:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:26 AM, Daniel Borkmann wrote:
>>> a control plane inserts the L3 (without L2) entries manually into the
>>> neighbor table and lets the kernel do the neighbor resolution either
>>> on the gateway or on the backend directly in case the latter resides
>>> in the same L2. This avoids to deal with L2 in the control plane and
>>> to rebuild what the kernel already does best anyway.
>>
>> Are you using 'fib_multipath_use_neigh' sysctl to avoid going through
>> failed nexthops? Looking at how the bpf_fib_lookup() helper is
>> implemented, seems that you can benefit from it in XDP
> 
> Thanks for the pointer, we don't use it yet, but that's a great idea!

you should not have to do anything (beyond setting it if you have
control over that level).
