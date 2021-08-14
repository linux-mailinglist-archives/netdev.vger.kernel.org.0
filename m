Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAC33EBF3C
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhHNBLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhHNBLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:11:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF73C061756;
        Fri, 13 Aug 2021 18:11:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v2so7537523edq.10;
        Fri, 13 Aug 2021 18:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PJhUcsspU97g7E83Bpc3xMjAAqh5e3B1I8VLV04Hlg4=;
        b=lvQlGkQMovEbhDOLkEx9FfNMFdUym7QHjOg8TV2oep0SJ3tQ8K2y2owZAeCFaow50x
         2VGtWy4UVBOA5Hgv2Um7p3LyrGWWlhoOMsocXgMiubAK4BqyJ7BiUZK3h2X8Llpv4ZQw
         k6Gz4suycc94X9lIr3rsjrX+qEQZi/OrloEcd4zZTfo40c/z+ms8sY96+2HI94Hbgyx3
         8ja3Youg4lK9LB9/A8W/qNaXmqTAfuDxcLGhYNslXyI9Olc4+3JxhEjZpUsjf3teFDlL
         2oSbRcOpVlSav3/aqavxHG5/c1qX5sqQlWvB+P/I/MrqlkhgtOERuvKS4J1xGnLwyj2w
         XsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJhUcsspU97g7E83Bpc3xMjAAqh5e3B1I8VLV04Hlg4=;
        b=WqsmKrerJZuqN8VK0J1/kSCU66d/MzSAZLLJ0lwIZt8aGg+B3FUQwsKKUcgDX7vxTW
         5936NEYntcymh7AL5WoKkpcoOh/CK2v7l6S3cWg5bX56MS3qA2rk5hgkQsfXYj3x0F8d
         8PJlyFthJzpmZKAXs2vVBjFmZ8exM+Kj9ePSjcOZD5yjPsWnRO0RTE9RHzDKy5wNf8Z1
         xztNZMVpcSezLUmacyTbuueoLb+4FljaBmZIElHIVqpsxN5GsPLtIUYd+1OSCXGrjfqu
         McOsNBN2JawN/5JZc+l3MoSdXzlWMwi7qVvi4XTEcmBlRL7kMnap6JcO28Fg5NWQ6mys
         H1PQ==
X-Gm-Message-State: AOAM533A7AzsjCbYetKfln1CGRUCjbFSPUaIg0sKvzwstR8pk1iDM0Sy
        lHg/2gN2UgPSNwxJBzFaTso=
X-Google-Smtp-Source: ABdhPJzbEz1C74QjqaquNCIRacBK6HSghnVyTzV009KuRSd/PsM34mJM8RMUbtWj+RkNCDXH4rnY+w==
X-Received: by 2002:a05:6402:26c6:: with SMTP id x6mr6754557edd.175.1628903476812;
        Fri, 13 Aug 2021 18:11:16 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id q30sm1595434edi.84.2021.08.13.18.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 18:11:16 -0700 (PDT)
Date:   Sat, 14 Aug 2021 04:11:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next v2] net: bridge: switchdev: pass more port flags
 to drivers
Message-ID: <20210814011115.agzyo3cydlupafvy@skbuf>
References: <20210812142213.2251697-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812142213.2251697-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 10:22:12PM +0800, DENG Qingfang wrote:
> These 3 port flags: BR_HAIRPIN_MODE, BR_MULTICAST_TO_UNICAST, and
> BR_ISOLATED, affect the data path and should be handled by switchdev
> drivers.
> 
> Add them to BR_PORT_FLAGS_HW_OFFLOAD so they can be passed down to
> the drivers.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> v1 -> v2: added more flags

If you insist to not write a competent commit message which properly
explains the motivation for the change, then please remove my
Suggested-by tag and resend. Thanks
