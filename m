Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562FC2FE0B7
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbhAUEa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbhAUEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:30:20 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A70BC061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:29:28 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id g69so68989oib.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=35jDEwyAOn6EXcsqc3zljtTA3F7CvH6/tVllcXMwmgs=;
        b=ugNd4a1gXDlrwbm0pz46csZ6C3VffAsO+uRgk4OasHCYCJCZXmuo8zTSn1t5wbMsvb
         YvCzghDcyVLIX2kIjPS0mtqXuIG2KsBisWa3Mf8vEaxlp8wF2W17thZGbPGP8SQpEoPD
         hdJhPdVAGEqkDB6wyzyHsdZpI8icuGYRFDt4xobBokd/lQ0dT+BBmWTeNtd4GMjWi19p
         b6mm1pRQs8D0d/ljjElKOfsZmNizetxPBSOdgSE9pasB77brsl0K0wj86ChsyD9wV6Yh
         tTfE5fi9VRsG+2byQIcngAYBJ4kbgtTgqSI9WiaSjNl1VhI7kGM9NudG6GhZySNupd/j
         m3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=35jDEwyAOn6EXcsqc3zljtTA3F7CvH6/tVllcXMwmgs=;
        b=DT6fbd+LmZYACi7UQ5xvllNUzf4W188Hb/jIHhrBz561vprPlhrzM8wlker5nIEjGg
         Q6p2XPOJnHVZB2y8WQLpv3PQ6UwZPL6H6xdEncvWcaMp1dgpGZJe2nh4OCe54WhYBMa3
         u8vxH6v9qwTQOLVhbeytzydENHqnxotwvDahhYU0AUnJjtBJnuWa60K6Pa2r+09vEtJI
         vatdvHFEB9YEwcN1nWEOKmXr/49XdPD6x9JiAZewffiYoqY+8Asitb81SKfmcnlTIaCN
         xQqiXjpGhdICqd38fCqz2NM40+mmniSTCMhcGOtyF2RLYHWCTdYuqkjt79FTbUdcO5Wg
         6JUg==
X-Gm-Message-State: AOAM532o6kE3uooBEL3p9k0jI1EL+2O3a2Au4O+BLe0dyIE2GvcQ8/Te
        UqQIzjKgprAsHvb+TED0OGA=
X-Google-Smtp-Source: ABdhPJzH4CfDeS7M+obaJLQIA6BIyCvK/D0bmiEfcNLw6zpQNwlPy9S/jXtV5jHxrRuUTtXiNN0RIA==
X-Received: by 2002:aca:3404:: with SMTP id b4mr4963695oia.77.1611203367688;
        Wed, 20 Jan 2021 20:29:27 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id p25sm859856oip.14.2021.01.20.20.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:29:27 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/3] nexthop: Specialize rtm_nh_policy
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611156111.git.petrm@nvidia.com>
 <2d81065f0ea682aa00dd4f32c52f219d6f2e7022.1611156111.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <73839ca0-6e9b-de8f-bac5-96d94369c282@gmail.com>
Date:   Wed, 20 Jan 2021 21:29:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2d81065f0ea682aa00dd4f32c52f219d6f2e7022.1611156111.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/21 8:44 AM, Petr Machata wrote:
> This policy is currently only used for creation of new next hops and new
> next hop groups. Rename it accordingly and remove the two attributes that
> are not valid in that context: NHA_GROUPS and NHA_MASTER.
> 
> For consistency with other policies, do not mention policy array size in
> the declarator, and replace NHA_MAX for ARRAY_SIZE as appropriate.
> 
> Note that with this commit, NHA_MAX and __NHA_MAX are not used anymore.
> Leave them in purely as a user API.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     - Do not specify size of the policy array. Use ARRAY_SIZE instead
>       of NHA_MAX
> 
>  net/ipv4/nexthop.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


