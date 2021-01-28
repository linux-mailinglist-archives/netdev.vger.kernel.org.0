Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663E6306BB5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhA1DfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhA1DfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 22:35:02 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CCDC0613D6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:34:22 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 36so3938154otp.2
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zxEtsWSfmHwAZG2w4SkYDMtBDhR2a9/WNy+qpxZTrx4=;
        b=U81Fq/esiouJnysUE+n1KB68tuOvano1bKl761scE3usf73rolWKZVPT8Em6K1XXjM
         O0TGtbfPb9zvVPjsboMTbT/TUT8utEH58zu7IYuWIbQMKQuX6ASAEhh1bsdRgTBbLxHH
         CGDBKbjgy0aHWk0vL0GfNR1zWndtx/KTixjGMWbu6IN5bnYIyxYowMxqepTeqeoSFo68
         6wI6sizJ/RH6mhCwCON/gd43n71iAij39BO9MRTLEElVP9OODfcCJtof6yUfq5k52rN2
         Et11P1dASg+5ZVCEiV06hOZtHci7JpLr9FYdULWrKdBBAEmL9nEg8HkvqBqbTqTSQNps
         aWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zxEtsWSfmHwAZG2w4SkYDMtBDhR2a9/WNy+qpxZTrx4=;
        b=sM48ZR3IIV9Lucui8PIQqZI4IpyCxlgkj68TTUZ3+4UdIr4EYsfpVJ2FpFxJA2aY46
         zxo8jMm+6R+tZVucrKBpYoItoSapiZcwC7P8zrfE4lt31PZg3//a0t72kWq+bFxSZqgK
         0Zym3khqru30u2uVicJ7Q9mM2MnIS69qq/l34aQJokM4aiO+0uyr13NeU3TTbtEyIbJB
         kPT+vSk/ZnzOcJyUhCgdyjJB6E29laWYC3S0Ep1T13k4FQ9pBVNs++mdmhsBazd2FMxI
         /WT47lSLAAlFrhkRm5ov8qjwkd+jUqx/TdHsgeXZ+yaRCy0q4Fp0fD4x4oH91j2dtaAf
         2QPA==
X-Gm-Message-State: AOAM531y4Ys71fuzP9FyKxPCqU9CvrfydpJMpgc8tcFxRNDaszl/wcnn
        4BO2OpaQH8DHjPKdVRtDb2hC/1+x6ZE=
X-Google-Smtp-Source: ABdhPJwaxkiM+VDL/femgksc+sedbxJh3DWMjjL8Jj5wxScZHsr88nsZUPvalVmXa+NI9eYzgDFo9g==
X-Received: by 2002:a9d:6a13:: with SMTP id g19mr6963568otn.64.1611804861892;
        Wed, 27 Jan 2021 19:34:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id m10sm855060oim.42.2021.01.27.19.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:34:21 -0800 (PST)
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18e32566-b38b-3ee0-f8a4-a9c705ac68c8@gmail.com>
Date:   Wed, 27 Jan 2021 20:34:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> After installing a route to the kernel, user space receives an
> acknowledgment, which means the route was installed in the kernel,
> but not necessarily in hardware.
> 
> The asynchronous nature of route installation in hardware can lead to a
> routing daemon advertising a route before it was actually installed in
> hardware. This can result in packet loss or mis-routed packets until the
> route is installed in hardware.
> 
> It is also possible for a route already installed in hardware to change
> its action and therefore its flags. For example, a host route that is
> trapping packets can be "promoted" to perform decapsulation following
> the installation of an IPinIP/VXLAN tunnel.
> 
> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> are changed. The aim is to provide an indication to user-space
> (e.g., routing daemons) about the state of the route in hardware.
> 
> Introduce a sysctl that controls this behavior.
> 
> Keep the default value at 0 (i.e., do not emit notifications) for several
> reasons:
> - Multiple RTM_NEWROUTE notification per-route might confuse existing
>   routing daemons.
> - Convergence reasons in routing daemons.
> - The extra notifications will negatively impact the insertion rate.
> - Not all users are interested in these notifications.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 20 +++++++++++++++++++
>  include/net/netns/ipv4.h               |  2 ++
>  net/ipv4/af_inet.c                     |  2 ++
>  net/ipv4/fib_trie.c                    | 27 ++++++++++++++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  5 files changed, 60 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


