Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4E2920F7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgJSBxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 21:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgJSBxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 21:53:44 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C5C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 18:53:44 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id z2so8831919ilh.11
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 18:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E67OMz7wwa5ZSw3cRfXNuN2wMMPoDc2fvlnKJRZaDZo=;
        b=twOUHosWrCkgcYt8VaduFLdXS2nJaxIisOhJWc4owo06+PkUHKTg8QsnyMvfO2fdol
         mC/8ku5r7ZH5kzMz/k383580zdd/MthvnEnnXJB9+eIAxTQc1nxOz3sbkY/4E4UxcYvn
         03+BA8boPhOpDGt1gu/pQV0N9An2lSMCfxSbnH/XG72WXLwTH/VwBa5M22TNCq7dcFx2
         3NdtT3LePf6+6ofpAGXvnm/8BTg42bBVXaRLcZVKyFx81fkhE8okSo0FWD1nG3lmuH2y
         fFhm4CxhceJ6p05ftQ2y5Z8LX73INjKyfIVa/YX9K6FpXOM3pz7Lx4C3ay0ULuPnC4/U
         +4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E67OMz7wwa5ZSw3cRfXNuN2wMMPoDc2fvlnKJRZaDZo=;
        b=fee1XLlLxO+Aqn5ZOLfKdCZ1JYqjt4yI2q/GfVxN9IfdnKWAJJXmgLwvp/zmuzSgcK
         OjGyf7QGv2hJIcozZeluYhr0a6NLjSPVPFaczSw3NDX6HPqLiNEZwFxGZomByq9xtWZx
         goxtfMWxBGRuTD+077n9EmvZcGW+ByhZHMRI70asG1ThQwTRgEIUgBjxiT2whRwmGUk2
         YUMeWYs9nkdYEjuKC9pvMHz4HceAOItqVmavbn24sDHlTkJiLSBK9E4wNaqAaku7tWXj
         lastH4eDP1BIzHIn2LMBM9Ye+/+4YDdmjnW8CFalnw5rBJD3EztcM9Zu2CH4LjV/K8e2
         btuA==
X-Gm-Message-State: AOAM531SXk6xBdul5gSZddoUJOiIEEH4iX5ZmyWfvjffdZJq25fdQB12
        ChfsrqToT/uxfSLyRD7ff8o=
X-Google-Smtp-Source: ABdhPJywdFnJOLZucVlAXgKQJPSw3IqLMDeQj7gHMUOPLDnvVprEVB+aZDzfEgFeO5ywGzN7otgGSw==
X-Received: by 2002:a92:6501:: with SMTP id z1mr1383866ilb.8.1603072423296;
        Sun, 18 Oct 2020 18:53:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:d908:7fe8:cfc0:66e2])
        by smtp.googlemail.com with ESMTPSA id d6sm8638208ilf.19.2020.10.18.18.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 18:53:42 -0700 (PDT)
Subject: Re: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, sashal@kernel.org,
        mmanning@vyatta.att-mail.com
References: <20201018132436.GA11729@ICIPI.localdomain>
 <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
 <20201018160624.GB11729@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33c7f9b3-aec6-6327-53b3-3b54f74ddcf6@gmail.com>
Date:   Sun, 18 Oct 2020 19:53:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018160624.GB11729@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/20 10:06 AM, Stephen Suryaputra wrote:
> $ git --no-pager show afed1a4
> 
> commit afed1a4dbb76c81900f10fd77397fb91ad442702
> Author: Sasha Levin <sashal@kernel.org>
> Date:   Mon Mar 23 16:21:31 2020 -0400
> 
>     Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
>     
>     This reverts commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5.
>     
>     This patch shouldn't have been backported to 4.14.
>     
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 

My response last November was:

'backporting this patch and it's bug fix, "ipv6: Fix handling of LLA
with VRF and sockets bound to VRF" to 4.14 is a bit questionable. They
definitely do not need to come back to 4.9.'

Basically, my point is that this is work that was committed to 4.19-next
I believe and given the state of the VRF feature over the releases, I
could not confirm for 4.14 that everything works as intended. Hence, the
comment about it being questionable.

If you / your company are actively using and testing VRF on 4.14 and can
confirm it works, then I am fine with the patch (and its bugfix) getting
applied.
