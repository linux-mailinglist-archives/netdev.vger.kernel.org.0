Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB5345111
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCVUqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCVUqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:46:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC3DC061574;
        Mon, 22 Mar 2021 13:46:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id jy13so23498781ejc.2;
        Mon, 22 Mar 2021 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QwNoveBbxUWKiYT/TkD+IkTs6AcuFVuwEmdnK9REmoQ=;
        b=ey6ocjnGXOhhpIdY3LxPQOyggqSPyqDslcG7na2LB/IzaevyeVrfoOcmdRF789UTaG
         OZ3gX30eIdPU2NMld91Yc34VYSZBqsHlY7vfF9+ANxuSYK3rCuTpVc/52IqNAlParySQ
         dKtCyQIa7QgCvexojB1D5z4YMbJVqCINTQradVAIkfJgSmoWy9TFzhW2x8HBHj/8vlez
         OmSXBkVKVAT5Bt9ClQNAfXgyvvh0nZTTOMcsQ2Is/bkTaWTdvcwVpLbTvo23AfsFjT1f
         +4ftEdfcDySn64Otodr0L6p8UQhmatmkazjN/EsfCZl6f9NO/KA0w6mOCnMxkb/nS6Lw
         ywCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwNoveBbxUWKiYT/TkD+IkTs6AcuFVuwEmdnK9REmoQ=;
        b=FCH+GNYGbEh3jtEM0LD+s42au5eWxibIfZuSgpCb5HqQkw0DsQMw3mAZnl0QaVKEBx
         wV/GWeOedyUlxLHFFv05VmqJ+mQJbCqqf5M9RTqfkyIeL5xfys0//7QVRGv2DmEvX6wJ
         M5xYbUrPbTYZAYl9UHC+FPpqxwzOBXmyzcvdKzVVqVtbu/Tyqr9gUym1viEHk+1V33ZT
         JET6z4HoeKz5UnMlAwH/CjnT3P33S0+FT/7DA3UVZRtBfGERs6ZH0AucPUJvpctKDh9s
         qMaaW1Vzw30i7KZEJldQ0JnbCx1FWLqb+M3AEkAUmNkF+WyqOBGuzJAl1R1EOPgzDrca
         flXA==
X-Gm-Message-State: AOAM532zqYGR1QzBDUWVt3LCoG7B3qeH40HQfxoWWdNQ64E3kY8N81JN
        B0Y7w25+NAHuK6wdmnKa2AGiO8BM1AA=
X-Google-Smtp-Source: ABdhPJxbv2/tqOKItEawaQi9puR7WBdhQuPJ/PeBQgEGNl1xzFRDJ2Kyy4ptdNyC3wqtVEgKYLHIIA==
X-Received: by 2002:a17:906:74c4:: with SMTP id z4mr1612835ejl.512.1616445995184;
        Mon, 22 Mar 2021 13:46:35 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id j25sm12215887edy.9.2021.03.22.13.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:46:34 -0700 (PDT)
Date:   Mon, 22 Mar 2021 22:46:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: don't assign an error value to tag_ops
Message-ID: <20210322204633.ptvwd2jinybnxcje@skbuf>
References: <20210322202650.45776-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322202650.45776-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 03:26:50PM -0500, George McCollister wrote:
> Use a temporary variable to hold the return value from
> dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
> an error value in dst->tag_ops can result in deferencing an invalid
> pointer when a deferred switch configuration happens later.
> 
> Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Who dereferences the invalid pointer? dsa_tree_free I guess?
