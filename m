Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26D3F90CD
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhHZWwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhHZWwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 18:52:45 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C3CC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 15:51:58 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t1so4354217pgv.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VKG0hwPqDfPcwLUWpnPDne6tm2UTpFpIYJsoL2onYGU=;
        b=cNa5v0XLHRKgENhd9savbRRTC4xY3+Avy8wXG3uVr+4lcUx89JTfkug051EL6dc7f7
         4BVefS498aD3SglfPLRdk+9EOJjtxurVLQZHEH/16irySpdQ8192+QVhraRB0LjQ+H89
         j3p/SiZB2HqksRdtzN/w7KovGaNyrh9I4ICAdP3WhS6hCyG4k0kAV43DQu8GNz//qysb
         g09vkX9S242hQqohVOgRhxK+w2SG/NdHk24JZ0JHFc/vJ9ANNvYSfLfDPwaYYeE5u+o9
         6Pa6g6Wo6bOsOAhNkCqrskJENpQHBnAMVumQw1PGmP2IT48fFEeAFv1yXVBYCzHUQ9bH
         dqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VKG0hwPqDfPcwLUWpnPDne6tm2UTpFpIYJsoL2onYGU=;
        b=WmG11N7+m2VdgtgMR7/MyzoYtpG46QUCj479XofuZwMm6cZozcjyMaUw4xviDnf6ck
         3CiPkdaJ8GSnnLvLvYTZY2uoyrm07ozWgBQs2obnNLxowrWS/PoIC7773914J/AbbFac
         vNBk5SdP/bbfy2pdSpJ312vY5d6Mxn5nM3Foi5pZaWl3ceCULHRt/Gg1wQaUgi1CFzG9
         UgUUz2CaVEZcW1Vo/oFz8i8BR9uDDmLXz3Jw3fCN0s24PyqmsyGTzD1b1wBzleedS7tj
         ofYPYc8Cm2bHgsPu5QX3sKGXibFlyrjBugZEqKLPr06gCJSS6IqHqxZ6OEwo2KYiGzmA
         9EGg==
X-Gm-Message-State: AOAM531oWvHipHVtNZZAAqd1yA6EHQJU/hRfPas/e1TkrBk6tWiCCBAO
        aMAVm6cApvLJdr3D1pY/883XvzY02aA=
X-Google-Smtp-Source: ABdhPJxzg5rkK80WE4OYzQbpKLAh44dQ74ygtA0YNia0uIFuVWutI/dbRTY3UwJyHEZav0XHOYFiiw==
X-Received: by 2002:a62:7a15:0:b0:3ed:820a:6242 with SMTP id v21-20020a627a15000000b003ed820a6242mr6091545pfc.4.1630018317604;
        Thu, 26 Aug 2021 15:51:57 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s5sm4584042pgp.81.2021.08.26.15.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 15:51:57 -0700 (PDT)
Subject: Re: [PATCH net-next v3] tcp: enable mid stream window clamp
To:     Neil Spring <ntspring@fb.com>, davem@davemloft.net,
        edumazet@google.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com
References: <20210825210117.1668371-1-ntspring@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <90c5570b-00e1-7f3a-c42a-7525a8d02cdf@gmail.com>
Date:   Thu, 26 Aug 2021 15:51:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825210117.1668371-1-ntspring@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/21 2:01 PM, Neil Spring wrote:
> The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size
> of the advertised window to this value."  Window clamping is distributed
> across two variables, window_clamp ("Maximal window to advertise" in
> tcp.h) and rcv_ssthresh ("Current window clamp").
> 
> This patch updates the function where the window clamp is set to also
> reduce the current window clamp, rcv_sshthresh, if needed.  With this,
> setting the TCP_WINDOW_CLAMP option has the documented effect of limiting
> the window.
> 
> Signed-off-by: Neil Spring <ntspring@fb.com>
> ---
> v2: - fix email formatting
> 
> v3: - address comments by setting rcv_ssthresh based on prior window 
> 

SGTM, thanks.

Signed-off-by: Eric Dumazet <edumazet@google.com>

