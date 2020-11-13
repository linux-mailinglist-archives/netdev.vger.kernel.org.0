Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F66C2B14DC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgKMDv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMDv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:51:26 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5288C0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 19:51:25 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id g11so3891789pll.13
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 19:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eH00tBsvwnZ10oqgW5MOcJWnhYAnglEk3budO0Y+hA8=;
        b=WT/yryQXeZLReN5U9+9T6fTm3WRNDH4YlqhAr+X6wLy9GiXxv6ssuA3AOlxP5iTX/B
         HhLpkb07jdob8d6+2YV4859VnvRRafvyQFnI64DlZkgdcvDbIJdblOBaFAjxalakpcdg
         JUYVGGG7E9uLIe8i+pb4gihCqDoxCuSc3vw1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eH00tBsvwnZ10oqgW5MOcJWnhYAnglEk3budO0Y+hA8=;
        b=ie6VS4esA/UHc8TaIBL4le7QMm0IMyJwZZAKCtONlDruVpPf94m56Z2pRZyz5V5CXh
         6DEWkFHYlNvw3gn7+Elpc7ihOx38UvYoqAIXVkRmstSq+p2bt/zQaN5PSk2nJ0QJ499I
         zKJtDr2GB5AYKG+l+bxY2GcnlAo1hKxzLCGfAc0JFv4AEJX/RhVOm2yRrH9f8D2Kw79l
         XWuJaml123ClmzPY5iwO5swIwEMPCW5BkIaNP2loycs2lc44r1goUnf2AXui2vu+pm94
         pa8/IZRnXB5QDW15/1wj6tcD0VCPTYmMA75GSfwMZEose26OBMd313xtSTI07MxcUjH5
         +OEg==
X-Gm-Message-State: AOAM532GB/2Cd3L3Wy5U8QT2/fYAFwXoVg6H5BJjYf0pu9mmjyZzICap
        MXFNmQ8e+14i7IyWh8btcsaKzQ==
X-Google-Smtp-Source: ABdhPJxIJwikyfhJ5Ge5f9x5BGqGRdfAb+6Um6Mr9Wqs+t76Ob7LT8eeJuBJ9c34fhFDdLMEiHq2pQ==
X-Received: by 2002:a17:902:7594:b029:d5:eda6:fb45 with SMTP id j20-20020a1709027594b02900d5eda6fb45mr485561pll.5.1605239483347;
        Thu, 12 Nov 2020 19:51:23 -0800 (PST)
Received: from google.com ([2620:15c:202:201:8edc:d4ff:fe53:350d])
        by smtp.gmail.com with ESMTPSA id v191sm7941313pfc.19.2020.11.12.19.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:51:22 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:51:19 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        vpai@akamai.com, Joakim.Tjernlund@infinera.com,
        xiyou.wangcong@gmail.com, johunt@akamai.com, jhs@mojatatu.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, john.fastabend@gmail.com,
        eric.dumazet@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
Message-ID: <20201113035119.GA1914997@google.com>
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:25:38AM +0800, Yunsheng Lin wrote:
> commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> 
> When the above upstream commit is backported to stable kernel,
> one assignment is missing, which causes two problems reported
> by Joakim and Vishwanath, see [1] and [2].
> 
> So add the assignment back to fix it.
> 
> 1. https://www.spinics.net/lists/netdev/msg693916.html
> 2. https://www.spinics.net/lists/netdev/msg695131.html
> 
> Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

For whatever it's worth, we've seen similar problems (particularly,
ENOBUFS on AF_PACKET sockets) and have tested this fix on 4.19.y (we're
also queueing it up on our 5.4.y branch, but haven't tested it as much):

Tested-by: Brian Norris <briannorris@chromium.org>

Thanks!
