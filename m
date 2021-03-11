Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62183337927
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhCKQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbhCKQUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:20:31 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D435C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:20:31 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id c13-20020a4ab18d0000b02901b5b67cff5eso810643ooo.2
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AOr/BzGR7P+MTER/37T8M0dhtO+uGoxNGzjewMj0xf0=;
        b=UGzOD0cbArtxdVriCfG8sn2eVewlIsLEqg0aufBg3JCR8pjU5Ba80RTj8wngaVnmya
         LM1zmaey/P8CvLL8bM3aQSG5DvY158PN0f38g4Uf4lEjIryQN2xRWNrGKBkGBFIedbyo
         Gyl4ASbcTtNs5Xy8HDw7Mtuh1kaWBopudNvPNuBi1vlI3BZCfIUMY7cLIphasHAZTlwG
         nveXFIVYrCpFy1DfRcJAcJkDQBJMAAMIwtQ+YsFnAWhyL+8j8BcvQ2plINK9w+a3BOxj
         fEpGz4u8BMkAwWghUj4vdp7QwqEyMWjM5ySRsoFJtDVLoWsj+auBvYqU+WjIfWr+rLkV
         DkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AOr/BzGR7P+MTER/37T8M0dhtO+uGoxNGzjewMj0xf0=;
        b=AtIsrtYRY6QO1pMtwO/fMyliYp0gTKXC23aRh/b7OqnOV3z1e+o0xyVZgNxYWmRl/G
         XSMQdM6kDEHfHtUeMsCcLFDy3XYXCf+gNXZU2f2eXwBkIZLWaQ5me6n49owPkWpfRuxj
         w+LTTV7JDk9TRa9nvv5njl1GC/cUdPUD/wqjjTaMgw0W8tqN8BKGRbQzgwl82cFU1/ML
         hXs0kTa91nm4SLrNUrACrPRH7wGh2DQjbBcMORxwgPcnfm9Rh2v2bet7GBDoEL3GhPPv
         b6cGCl3Et3Dq0PZIP+KOYeRziYelmlyUPLxp0QOsVKG9JeIL1Ot0ozGrLNWw6qYYNqns
         j4LA==
X-Gm-Message-State: AOAM5310sjM1w8WvxHixPtsnQ2noo2wINzFDTqCB4TtHxjQXj0bl8M/o
        GB6duw+jDYRpJ0zmOQoJQd3Eooa6kS4=
X-Google-Smtp-Source: ABdhPJx7zEbGbtkWB+BOP85n57XQwLiuhU+22EmTJ3Crf94XuhviTMM6RYA93TcXg6X0Vilq4bZ7nw==
X-Received: by 2002:a4a:e9a2:: with SMTP id t2mr7207931ood.15.1615479630705;
        Thu, 11 Mar 2021 08:20:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id f29sm746619ots.22.2021.03.11.08.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:20:30 -0800 (PST)
Subject: Re: [PATCH net-next 14/14] nexthop: Enable resilient next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <b3ca94c2e8fee0d5c9a6f4f717893ceda7091af3.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a74f9396-288f-2368-a8dd-dfa1b2b0733e@gmail.com>
Date:   Thu, 11 Mar 2021 09:20:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b3ca94c2e8fee0d5c9a6f4f717893ceda7091af3.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> Now that all the code is in place, stop rejecting requests to create
> resilient next-hop groups.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 4 ----
>  1 file changed, 4 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

