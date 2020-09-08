Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04551261C74
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgIHTU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731120AbgIHQCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:02:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7FFC061364
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:38:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z25so17517509iol.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eQABNCicuQhrPptqet9orwq8qFlF4pzqXxbKdjlJ5vw=;
        b=JLWAKGFNq2DiELqYyMyxenbEsimySatsiiR7k+7fo/RNFRFaP1VkmEFRlBEFBfHW7D
         iX6iXMUgIiKYslN/OnDel4HRQiFQpr7ue8ccTIltijNMoZcQy1NYizaAqQPAd6JGvi/5
         OwnuSP6Q+JV3Ko6sud5La++HcYQizohI2gOc29W+CvGXCEti/ZyxzCIu467hX5eA6DTa
         rF43qPXkBDwXzGm/i0SheBQDOHvGqplvAQLp3I2KYf1rq1K+WlU+3kGpI7rfHQn3DMHa
         V68Ji68PbRlbvW1jOf2vOpPebg7CZX79BcIbBDxQGQMFl4RdLMBtntSGf3PvOxmLyORS
         +uqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eQABNCicuQhrPptqet9orwq8qFlF4pzqXxbKdjlJ5vw=;
        b=e5p5X+otoHc6w+6Ucbb7uGDyi7zKHHE16dTnhH0ItrvHAsaLmSLKhvjEJcQROKsr9z
         BzWGj0xnscjehmxnMxfAp2d5KPrJgp19YZF4fwldeeuuF8x/07xdmLz/xvgK/r76u0BS
         S8hJxlpzhqU5ftZAYmIfA0Q4G28Bjxg9DWDBYI+awuWTcpbVSgEhWRbib75zHDHAA7on
         fPxeYhz9DG7szUHL3f8xmJ07a4MAA0y3MZqoosYNPU+TLBur4ADhT1TqyGnJY0pdTeEF
         1KDBNeOPW+XI+QGRle+SIyXWBtGvaU2gPs2H7mJtw3J73s3fA3HpIScUzar3PyyayVp2
         BIdA==
X-Gm-Message-State: AOAM533U9V7NoW7w1Bn/A4FLGtlANxn+E+gcNOnwK/3pxixdzG4LN/5v
        9A1tO+IUkJx16zmcoAGuf5WhHREWWC2QQA==
X-Google-Smtp-Source: ABdhPJzf3yQ3kEesE4YvDa+gqxa+ye2AyZejt32hNJRXgeQsDEIjvEMBOE5qdMobFyy3jTU+HKMBKw==
X-Received: by 2002:a05:6638:2049:: with SMTP id t9mr2169693jaj.14.1599579515038;
        Tue, 08 Sep 2020 08:38:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id v14sm5638395iol.17.2020.09.08.08.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:38:34 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 18/22] nexthop: Remove in-kernel route
 notifications when nexthop changes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-19-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea71a755-64be-3a79-dc9f-17b2e3bac770@gmail.com>
Date:   Tue, 8 Sep 2020 09:38:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-19-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Remove in-kernel route notifications when the configuration of their
> nexthop changes.
> 
> These notifications are unnecessary because the route still uses the
> same nexthop ID. A separate notification for the nexthop change itself
> is now sent in the nexthop notification chain.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_trie.c | 9 ---------
>  net/ipv6/route.c    | 5 -----
>  2 files changed, 14 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


