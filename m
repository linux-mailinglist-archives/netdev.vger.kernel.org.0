Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE938337895
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhCKP5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhCKP5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:57:42 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB4FC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:57:41 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id f8so1891725otp.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aojLrIHwegBFKEhgn5pPRgJgpJDWYNggkQp5oR84lDI=;
        b=g5xQJvHURhDeYTwLktuOKnq0zLn4paPvJG/NnrcGlmJUccWXmMdPtRiBPi1HbkK+FP
         LD9HXpogBgwDViRYIzP4cEwpvEjpVOePtFOQmWNKQFHCOi6qd6DGF83ab68II80aQUFX
         nsbqGElx8j1BNLE5OdBUtB3XXsSFrAwKajf44gBnzP/yzNVvouQ+18uPozZWUtpMrDun
         oTm5ewHzo0a7NaqIRgkhT3CaR5hCg0HmuOl2vXwlXaLd6SDcddjwQkPIZwlEVK097C68
         L7zz2lEw9E0MY/Jtvweae/sqo+aPttvgVQ/C8yfPG8oGw7XBO8TTZfaBTwoYrsMv39Rw
         hUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aojLrIHwegBFKEhgn5pPRgJgpJDWYNggkQp5oR84lDI=;
        b=tcVadsqfKWdFzlIfqIkNQQhbs2A581DCBYd4Ifs1Pp3PO8jq4Dn/Tgabf8IUehr3gU
         NQMVXBjqT0iEEhC085sGbMAFnkhE7l9XJzWlSHqAXmR/BLyTWFMlKoGcQtdpQeMvCkB8
         4CeiQOizb91PJlXTA5wNHUmoOSonZDtQVFTQ8TlFTYBRjtX/u5jxWAb6IYfYpNC6Nks9
         x2OySgRZ9lN9rjwWjnVL6oGoPBIl0oPMaHlblhKKD8HZeGm9TBVZC8DEmb6mbVia6hZl
         6hczsPaf3OV5Yco5bmwKOzgM+QvrZBB5Y5DRjJe2xllMFUA4DiQqejYt0WNdChJed+h+
         7Svg==
X-Gm-Message-State: AOAM532HF3LOgbLTkMNS+OFKseTjBAY+CEWbUU/AuotZ00lg3+4zEUZk
        /Atrl3G2fTWao1zN2N1JwrVVCp2ccjI=
X-Google-Smtp-Source: ABdhPJxuufflP3WcfftFL1CXbkKOzSZpG7tAxmXI/Y8g9m1wa6ghlaugWoEzNuYibGif4yDkaJ97Ig==
X-Received: by 2002:a9d:6e09:: with SMTP id e9mr7361163otr.195.1615478261253;
        Thu, 11 Mar 2021 07:57:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id y10sm614749oih.37.2021.03.11.07.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:57:40 -0800 (PST)
Subject: Re: [PATCH net-next 07/14] nexthop: Implement notifiers for resilient
 nexthop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <df2dacdf19a854e15b57349e654d3f9820d0bcd1.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cc69b87e-4210-bcee-993a-64af0593d29c@gmail.com>
Date:   Thu, 11 Mar 2021 08:57:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <df2dacdf19a854e15b57349e654d3f9820d0bcd1.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> Implement the following notifications towards drivers:
> 
> - NEXTHOP_EVENT_REPLACE, when a resilient nexthop group is created.
> 
> - NEXTHOP_EVENT_BUCKET_REPLACE any time there is a change in assignment of
>   next hops to hash table buckets. That includes replacements, deletions,
>   and delayed upkeep cycles. Some bucket notifications can be vetoed by the
>   driver, to make it possible to propagate bucket busy-ness flags from the
>   HW back to the algorithm. Some are however forced, e.g. if a next hop is
>   deleted, all buckets that use this next hop simply must be migrated,
>   whether the HW wishes so or not.
> 
> - NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE, before a resilient nexthop group is
>   replaced. Usually the driver will get the bucket notifications as well,
>   and could veto those. But in some cases, a bucket may not be migrated
>   immediately, but during delayed upkeep, and that is too late to roll the
>   transaction back. This notification allows the driver to take a look and
>   veto the new proposed group up front, before anything is committed.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


