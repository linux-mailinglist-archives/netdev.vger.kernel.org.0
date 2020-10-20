Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980602937F5
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392789AbgJTJ0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391503AbgJTJ0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:26:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF91C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 02:26:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id 33so1073266edq.13
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 02:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=if02MItxpFpQD7CS13GFSz6oa7VooxpaKXbIaJtGIlk=;
        b=LwyoecrOIWf1QjIlGH5XyEFZSruVH8CNEDOgKXK5tkJFwfxSGp5zSLG8occ90AwSVq
         DVCaqXUYL60d4dftdLVUIsB4HNYBZLb4DEJPrIjCQy37D17RrfHJuMXTg9jJcOidxgyw
         IPCU8A57Dv2eShEtZNoCXnYDRJcGCIaUhnL2ROhGgVDRdI0dXoCnIuUFQ+pw1xRLGN6X
         /TVTBgLrU6Jok2fn08tbNXEZWGgHYl25qxwp1jzbiffualrTyJHbcPJo710WMQYJylks
         owP/DEK74M8mH8V2RKGovjy/Q9YGI3kyYDvGB9a09xqJTL/I/Hw/RAHQqGl/i9CaeUQL
         2OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=if02MItxpFpQD7CS13GFSz6oa7VooxpaKXbIaJtGIlk=;
        b=her7qaXHUkw8rBMnyshTkrbAFL/dJiQfbvLQgN2KRcbE+qeKJBH43a4grGVrOeip9Q
         5lSU0FWHjTNHBl1aIGg5L4PlzrtEu+QhPs1alVkl74TzswW1WYtXMWlpemS9voCQhqXe
         rvsVGDlQE7nsuoKbyXwfnTgq7RWvnHs5JyVAwMr8rn1ufSXpIeCR+lPUa4W2iE0riJH/
         DKHOToFrLFdszNVBYuzm30i5q/b+3yiQ0rE2sUxSv6jFl+iZJpEs6rzPg421Inb9DuZk
         g3Yhs1RydQxoxHAlaFNt5ANBJXeqPe56t5Z39lkGhJpz/NW2uBNZ+6SO6xiP6x0lUyff
         Y4KQ==
X-Gm-Message-State: AOAM532MKu6PKLCTXeyREKgadlZcJ7KsTkkRUMUbDq/a6ZdmZqROYZIm
        yYtBeb6IK1J3Bzcx4vzd0U06pOgmKy/Yo3uy
X-Google-Smtp-Source: ABdhPJzBPT8wAuoJ4LDtodbHJb7iR/mwFWeeH/HgvVIjgdM3r+cThQeWOOztPAMHgJQT2EJhsvfGyw==
X-Received: by 2002:a05:6402:184f:: with SMTP id v15mr1881639edy.341.1603185996658;
        Tue, 20 Oct 2020 02:26:36 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:53fa:8da9:45da:8127])
        by smtp.gmail.com with ESMTPSA id d1sm1872796ejo.17.2020.10.20.02.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 02:26:35 -0700 (PDT)
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <20201020073839.29226-1-geert@linux-m68k.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
Message-ID: <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
Date:   Tue, 20 Oct 2020 11:26:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201020073839.29226-1-geert@linux-m68k.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thank you for the patch!

On 20/10/2020 09:38, Geert Uytterhoeven wrote:
> MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
> not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
> is done for all other IPv6 features.

Here again, the intension was to select IPv6 from MPTCP but I understand 
the issue: if we enable MPTCP, we will select IPV6 as well by default. 
Maybe not what we want on some embedded devices with very limited memory 
where IPV6 is already off. We should instead enable MPTCP_IPV6 only if 
IPV6=y. LGTM then!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
