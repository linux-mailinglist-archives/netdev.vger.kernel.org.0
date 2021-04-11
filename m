Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF135B67B
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhDKSI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhDKSI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 14:08:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976B1C061574;
        Sun, 11 Apr 2021 11:08:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z1so12346598edb.8;
        Sun, 11 Apr 2021 11:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TVMBB3xuRvbJBOIyzu5OlQfaE46I0yjqh/vw0aczGA4=;
        b=liMgJRCCOcGO4y6Ci/uMP72aiiSb+3YiPFSO8HXC2fKomF89RzfzqX4uYDQbZz8tHH
         gfKWXl8bStMBM79WKJgQUMAZXLr3KXxEqsnIX7E2Cc8HXBfDfGdTt8a1F3jCE4vmy6jz
         6T5u1cfFUWUPpqj/BC1BY2Ktet3DAPQ3fjShJkyAhOJXy+2NH2hiKKz9EiF10PkO3brI
         fnwn9/fG+fqKNg+0ItvSKnsg9QI4HXa59xYRMPcbW4gS3l3WqLoLIiKNCD+Ah+XSA8fp
         v6FDKiLflL1aSB0OsLD2fahZV3/qj0ZUUoyGgAYqkIjVawSGak9EYpLCFyhTXqd8KnWk
         UsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TVMBB3xuRvbJBOIyzu5OlQfaE46I0yjqh/vw0aczGA4=;
        b=BkENCh4zwGrcNweDz/gIzkBHIU63BlntA78NG1kBvu1iX6uRuH0n6tbTopQK8C98AB
         Z3DDyrqgbr99IwznghoTAwnYh1HJEyXPEAUtW8YXVs0S9rnXkLBj1w7H3sbaVYKju/6B
         +kH+zSn/9nOt2nhtOzxnpWy9hCOKFbdh48Xwn8Qpe/Zc93qH1A6mIUCBxNskVmzfJ/H8
         2Cif+qQ90d/BXPpUqGXl4mbD89G+Xv99P59iF3ubAZso9ijJdz3cqCzezg+RMW+WCLwW
         elHEj/ulPEigpELro8lWT+b2B5HQRHu4JJLAeUNHW74ie3gR0L01ldnmPSZNYdDsikxm
         GlKg==
X-Gm-Message-State: AOAM530JxONNxK2ed3DgMccBWK+Uv7zs2DG/2FRS9oMkBLvbowjeZhSN
        MBTbAUInABXn7E8aajLkQ6u0q/DodcLe2w==
X-Google-Smtp-Source: ABdhPJxDQWpLctbWA6n8qjv0N/8a+NbZH1KghxfV/pEzYDLXaaMuu/G04jNF+xcwItJ6Rm2DqPX/4Q==
X-Received: by 2002:aa7:de12:: with SMTP id h18mr19769453edv.380.1618164490186;
        Sun, 11 Apr 2021 11:08:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.gmail.com with ESMTPSA id b8sm5191891edu.41.2021.04.11.11.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 11:08:09 -0700 (PDT)
Date:   Sun, 11 Apr 2021 20:08:06 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <YHM7BhTCuIVLRUCL@Ansuel-xps.localdomain>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411200135.35fb5985@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> On Sat, 10 Apr 2021 15:34:46 +0200
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Hi,
> > this is a respin of the Marek series in hope that this time we can
> > finally make some progress with dsa supporting multi-cpu port.
> > 
> > This implementation is similar to the Marek series but with some tweaks.
> > This adds support for multiple-cpu port but leave the driver the
> > decision of the type of logic to use about assigning a CPU port to the
> > various port. The driver can also provide no preference and the CPU port
> > is decided using a round-robin way.
> 
> In the last couple of months I have been giving some thought to this
> problem, and came up with one important thing: if there are multiple
> upstream ports, it would make a lot of sense to dynamically reallocate
> them to each user port, based on which user port is actually used, and
> at what speed.
> 
> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> ports support at most 1 Gbps. Round-robin would assign:
>   CPU port 0 - Port 0
>   CPU port 1 - Port 1
>   CPU port 0 - Port 2
>   CPU port 1 - Port 3
>   CPU port 0 - Port 4
> 
> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> with 1, 3 and 4 free:
>   CPU port 0 - Port 0 (plugged)
>   CPU port 1 - Port 1 (free)
>   CPU port 0 - Port 2 (plugged)
>   CPU port 1 - Port 3 (free)
>   CPU port 0 - Port 4 (free)
> 
> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> CPU, and the second CPU port is not used at all.
> 
> A mechanism for automatic reassignment of CPU ports would be ideal here.
> 
> What do you guys think?
> 
> Marek

A function called on every port change that checks the connected ports and
reassign the CPU based on that. Fact is that most of the time devices
have at least 2 ethernet port connected, one for the wan traffic and
other for some LAN device, so some type of preference from the switch
driver is needed, to also try to skip some problematic switch that have
CPU port with different supported features. A good idea but could be
overkill since we have seen at most devices with max 2 CPU port.
