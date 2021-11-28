Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC02460A5C
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 22:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhK1VlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 16:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbhK1VjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 16:39:08 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4DC061574
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 13:35:51 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so22703506otj.7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 13:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=19jfq8NAkngt5WmeNAQHwt32b8mM7OVqSc5ixcyl4Ng=;
        b=SiBjonBeGPUVYw7qv7L+5TfKisv5/McCBOXLmBXUz1+/VsJ9gI3UPGibBXqcBZ80BU
         x7XyxyvwoUrguqjvXc4gOU8Fdy1186y6xiLrG1ragIDSXK1N82vJi2PPMnU9aDoqyME3
         XEfhd53SWw2GijC+tUWECqYLSwxs8/7dJyF7BLg4bndS6jVzyFjk+iSJUw4yn47/BuJ+
         ROf2Fqx2XwdMATOXEeH/GLSjdmRm/PKTYCHOfsTrCN4i2YfyvX1L5DLLc+N1nKOlZLfa
         z6EalvozSYI9EDD83H8klyni1vET8sc2QOhBTE9hTkQI8J2fZu2t7+geZX4TjDXcNkh+
         9W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=19jfq8NAkngt5WmeNAQHwt32b8mM7OVqSc5ixcyl4Ng=;
        b=uNXI6r6NSfozNjgXZOeQuzL1O84XYPWs8i+pE+TUxSRIw6yM8RGRNq29fSbnB4z2FK
         sCH7jlkeoOigy+aocd+8/H0ETJ1Fv8Lu6Q1PuwvFeJ8JJiuiR65L7QDuPxKmEwT9tQCg
         kuX8EfP7BfDCo7zVLmz8x1Rvg1DDSui+Clkr0aUfTW49cbAp+Z5gzuGcxuswG1k2hXFr
         CMIzx5Mn3ASJWxKS38x7gg81RJpzPArTIoQOTabhfQitF3YB2yzPxY/nNbJoGrtRrL7I
         YMqwHVyfJc4jz5XW59KL6eSa/6TpjFB8zD+OmXbHEAR9PaaMWP90ZV7WCceNBq7LAhHj
         dakw==
X-Gm-Message-State: AOAM5325BqcK9izyjFWbm1MuDDmQ/uWvMiX26fbhPcylUzFHHwVLgEfi
        ADh+MuRV0S5rzJWV7OkVgePvBGHyEJU=
X-Google-Smtp-Source: ABdhPJw71N9PW7PWxReq+F72QME3PFNmaXzKM7lrM8RgHlGTe0s626OZxMRSD8ZRdKZnpR39uZOGqg==
X-Received: by 2002:a05:6830:1049:: with SMTP id b9mr41140506otp.60.1638135351271;
        Sun, 28 Nov 2021 13:35:51 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s6sm2693155ois.3.2021.11.28.13.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 13:35:50 -0800 (PST)
Message-ID: <89face48-9b1b-fc0a-2ae2-212bbb1c5af6@gmail.com>
Date:   Sun, 28 Nov 2021 14:35:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net v2 1/3] net: ipv6: add fib6_nh_release_dsts stub
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org
References: <20211122151514.2813935-1-razor@blackwall.org>
 <20211122151514.2813935-2-razor@blackwall.org>
 <28dd7421-15f3-db72-4e1e-3d86fa2129d7@gmail.com>
 <b75dd859-266e-16d7-f37a-1c349fccacd4@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <b75dd859-266e-16d7-f37a-1c349fccacd4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/21 1:14 PM, Nikolay Aleksandrov wrote:
> It duplicates a part of it but in a safe way because the fib6_nh could still be visible,
> while fib6_nh_release does it in a way that assumes it's not. I could re-use
> this helper in fib6_nh_release though, since it doesn't matter how the entries are
> freed there. I'm guessing that is what you meant?

yes, that is what I meant - it duplicates a chunk of the code in
fib6_nh_release.

> I'll take care of that and of the few possible optimizations for nexthop in net-next.

thanks!
