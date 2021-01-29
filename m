Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68E308432
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhA2DWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhA2DWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:22:40 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31186C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:21:59 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id i25so8435348oie.10
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VnzpmhCGpNJY+MfIlrkeh6fAtM/GejtWOi4AfRbXres=;
        b=Ck49nAgNRKAPIJNbQJU2gYOG8RGBV+l6vUC3moJYgNzNF74nNMOZIRjhIFiVB/5iNG
         NG/DP8ogIJXP2orCvXMIF1+GxccRcY0W45JKK/shLq1RUH9ADx/KyvAd1CGrYxBwZzxx
         1psxY1D55ftWPxc/1JShS9EbrBwHsKhWGbGs5e08/HJznxejUTBVJ6kIqvwP+PPxI64S
         q8J893B2v8pZUCHhmizJte/QD3Vf98E99udHg7XcuKo7ofryzbDVLoaRv9CJTxrvulyI
         zYb83tYrRLX5d7C3pn+eFDiKFBSHBWh2rSf0fo0in1XyF4U6WHTDqnnf9ZgS3vFVtLSd
         f6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnzpmhCGpNJY+MfIlrkeh6fAtM/GejtWOi4AfRbXres=;
        b=DoECdli29Mu2nPdtGigBy2UmQgEgEQZaSd9t5k/sUTJT/15QRwCzghnNddu9gPGXgA
         2ODqh3OY7zqttdF2oU2hP8fqwJWt9NEDNKp+qVyZG9z1VcbqIiJG/Xikg85qflWwOcoT
         cVKwo7wH3lEVCwfTk5PyLONsIclSTNkQV8ZYop73W3CT+auGEJMv6J1O9jOJMlUD+dkH
         x+uj7HLpnjnN2NJi0BB63p+l7ta9mVkxGUlepwqyvIv3lmslm0Axw/+0lA3Z4RZaCnDB
         Nq7udsJ8UHMWAN8JQgpjQzQ7o99wUd4apPngxteALB3VO6dLGNQLC7tNLZLLb2d4cLCe
         x68Q==
X-Gm-Message-State: AOAM5300BcFvSpLuSV3crJMmLvjwKkTLn5QYN3HIRYcksUQseeG38EE3
        g8idxIqMFhW9zk2wC9+IkoA=
X-Google-Smtp-Source: ABdhPJwJqTS36LNGxb/cig8syOjb1UvCXFGrTnWlPLqoI/iE+K9ngaQjbyYnQkp9yyyFCWwyAVw1aQ==
X-Received: by 2002:aca:5b46:: with SMTP id p67mr1567214oib.179.1611890518666;
        Thu, 28 Jan 2021 19:21:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id h11sm1866384ooj.36.2021.01.28.19.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:21:58 -0800 (PST)
Subject: Re: [PATCH net-next 12/12] nexthop: Extract a helper for validation
 of get/del RTNL requests
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <69b7beb0f8ae239762f08b8385fe74640f3b3f64.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <49569963-f202-373d-7624-9bc94612fbd2@gmail.com>
Date:   Thu, 28 Jan 2021 20:21:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <69b7beb0f8ae239762f08b8385fe74640f3b3f64.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> Validation of messages for get / del of a next hop is the same as will be
> validation of messages for get of a resilient next hop group bucket. The
> difference is that policy for resilient next hop group buckets is a
> superset of that used for next-hop get.
> 
> It is therefore possible to reuse the code that validates the nhmsg fields,
> extracts the next-hop ID, and validates that. To that end, extract from
> nh_valid_get_del_req() a helper __nh_valid_get_del_req() that does just
> that.
> 
> Make the nlh argument const so that the function can be called from the
> dump context, which only has a const nlh. Propagate the constness to
> nh_valid_get_del_req().
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 43 +++++++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 18 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


