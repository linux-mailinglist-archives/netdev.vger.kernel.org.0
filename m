Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BE63377B3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhCKP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhCKP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:28:54 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37B3C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:28:53 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id q127-20020a4a33850000b02901b646aa81b1so765748ooq.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8TQKP54PhChviMPYmfwUXZ90k2UnJV6ljHtOVXQTIkE=;
        b=Urg/17vMdV7IJ6sV9aECwZAjkS6lnOOyFKvY+VqGmUmcsiBrnc0UJmDzD910XzLQUl
         cZ1OoQ1N1LXkg64lkuwfnksxgwSDGHYCutkveX94/Bmc8cErH00LW3zcxIXedHVVU8UP
         67QiseKvA07jYOQcF3dOWlUlbNItZFqlSOB3pnFO2eERZpPL76qgwQIpyIk88xMIzXT7
         oQQg4cIzFq/azGb77zMvK4YQXjxrpn2PcHFXHyNg5oxQgbyHGgnFkXDuHviKNFVwMGJP
         Xr8oI066zuNVdtjRvc60SmhNDvPDueaGO0fLiA6WJYJnT18xM8fLTmbmEXVqhkaWQC61
         qqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TQKP54PhChviMPYmfwUXZ90k2UnJV6ljHtOVXQTIkE=;
        b=gy7nXTSge+L78dv3SK9nuqQg1Z+8BAAcE0RvWxk4aMmLKVINUT4/kn8hfpmsCUhf+R
         22sf28zDKvou6ZEu5S6sSLV21Ct/7Gr60pRTvaf1ozNcz9Oa/4xRgyUVlboIf5e0YPuZ
         XlpQB42IvKSLXnzP3GJfQIA3FnY8ZIcTIzWCQN4cVDnVSzQ0O1Sne2dsp5Xjif0F2hMr
         7NdtunenIwds3mOvSnAXZbMasjMNorm2+urNY3rbNAGuhP+GJRrogPdDr9wk72Hs8a9W
         qMJfNEgRBYiPZyZ4coKqe9plMdKfE+XrYI+usiyPcoSOMeCiZQGR3mPrcrsvTDQQxqGe
         PxRw==
X-Gm-Message-State: AOAM530vMQ4lJcQWZnicyhejL1AwJFLmDgXgfQfiNcu8A8F6e6R467Er
        W2iRr7eHxhhilFJ6Ckl55zY=
X-Google-Smtp-Source: ABdhPJx3n+3e6H/RIZpLfUX8VC5TSgKagjw3urgXy2Mx1vUvbdAihteVVSaLVbE82+Mdhha9nW2wwA==
X-Received: by 2002:a4a:88ee:: with SMTP id q43mr7052789ooh.61.1615476533413;
        Thu, 11 Mar 2021 07:28:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id y11sm605258oiv.19.2021.03.11.07.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:28:52 -0800 (PST)
Subject: Re: [PATCH net-next 03/14] nexthop: Add a dedicated flag for
 multipath next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cc5ef4d-2d33-eb62-08cb-4b36357a5fd3@gmail.com>
Date:   Thu, 11 Mar 2021 08:28:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> With the introduction of resilient nexthop groups, there will be two types
> of multipath groups: the current hash-threshold "mpath" ones, and resilient
> groups. Both are multipath, but to determine the fact, the system needs to
> consider two flags. This might prove costly in the datapath. Therefore,
> introduce a new flag, that should be set for next-hop groups that have more
> than one nexthop, and should be considered multipath.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - This patch is new
> 
>  include/net/nexthop.h | 7 ++++---
>  net/ipv4/nexthop.c    | 5 ++++-
>  2 files changed, 8 insertions(+), 4 deletions(-)

This patch looks good:
Reviewed-by: David Ahern <dsahern@kernel.org>

> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 7bc057aee40b..5062c2c08e2b 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -80,6 +80,7 @@ struct nh_grp_entry {
>  struct nh_group {
>  	struct nh_group		*spare; /* spare group for removals */
>  	u16			num_nh;
> +	bool			is_multipath;
>  	bool			mpath;


It would be good to rename the existing type 'mpath' to something else.
You have 'resilient' as a group type later, so maybe rename this one to
hash or hash_threshold.

