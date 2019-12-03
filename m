Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC19C10FB90
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfLCKPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:15:49 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:35707 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfLCKPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:15:48 -0500
Received: by mail-pf1-f177.google.com with SMTP id b19so1635816pfo.2
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 02:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DKk2IUBi3mdO+O2zHCOm2ZGyT/hvCUHZiFW5LUr1COg=;
        b=bJK3+CxNwD5oEFZ2wDA5SCudGLeHrZcOR4JCRWaKdV5gJ/kDJbCgmI0rNq19POQMzU
         PuVwPIc3HbMHTCT0jpYfQvz59R19h9zB5WW26pLOGCNQ3VQ4Ho80ZGRQavL6jEqGRWU7
         VM1KdXFJWwq00lEaCb9GZFJy38du5QD8eEuqLoJ4+iGlodkwxgxDELZ48kZxb4gpDWH8
         CSFyORptU7xPbH3rrwc2WNsRsMHen1+HXM67EoduTnrD+BVg4J8/k7ZtlRvPVesu6JhJ
         1G1lGZqt2j6PaEeoMIkYNVk92HDezcSqrsCqSoPCqCTfvHq9ffUiaHVZ2aw0qTpXYeJf
         d4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DKk2IUBi3mdO+O2zHCOm2ZGyT/hvCUHZiFW5LUr1COg=;
        b=pvqjdwky4kcsroKvKX8a2HxXY/2dHg03WEB6oT8o/s0a1yug1UJ4yoMu7BCyAOGY4O
         nLD3SkUzvlZjQ1OWSxgwNTdAMB0OFzGrRlDC+esaSmf8dsE+Ok0wMa9QHtvZs+6gUtD2
         bUcgX5hSoHAUQAodHnYuM0l92S5e4Zd92Ix/3Pg8OzIPv4xTdnOL916e+Gd/fzGhUpyB
         Co3t19VnP+79VQr2F/btsrL0q9XVGokMjG7Fn5ev06KvKK0X5G5Gk9LzBbZmwqNDoab8
         Nvxg0URH4HvJOr18myxwwKsi1k/bWqBXDlYlLRmoZP1oXGFLQpzznMj1ZCDwMlbjeQsi
         fcQw==
X-Gm-Message-State: APjAAAUI5z0IWQvxgrMA/WVKnhxYhgPtXEp9zfmvZ+zazKOwfGHV7isd
        j0XNeRbRP9QRw12ewe/mZYc=
X-Google-Smtp-Source: APXvYqyj/UVxn9BsMo4Nd92Kj6aMXiDUa/WJma0DRvhvAcKZn3qHkbbInZ3Mwuha/ojhDmMsEAPDgA==
X-Received: by 2002:a63:190c:: with SMTP id z12mr4194402pgl.1.1575368147659;
        Tue, 03 Dec 2019 02:15:47 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s22sm2340200pjr.5.2019.12.03.02.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:15:46 -0800 (PST)
Date:   Tue, 3 Dec 2019 18:15:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
Message-ID: <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
 <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191202.184704.723174427717421022.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202.184704.723174427717421022.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 06:47:04PM -0800, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Tue,  3 Dec 2019 10:11:37 +0800
> 
> > Fix it by removing the dst_confirm_neigh() in __ip6_rt_update_pmtu() as
> > there is no two-way communication during PMTU update.
> > 
> > v2: remove dst_confirm_neigh directly as David Miller pointed out.
> 
> That's not what I said.
> 
> I said that this interface is designed for situations where the neigh
> update is appropriate, and that's what happens for most callers _except_
> these tunnel cases.
> 
> The tunnel use is the exception and invoking the interface
> inappropriately.
> 
> It is important to keep the neigh reachability fresh for TCP flows so
> you cannot remove this dst_confirm_neigh() call.
> 
> Instead, make a new interface that the tunnel use cases can call into
> to elide the neigh update.
> 
> Yes, this means you will have too update all of the tunnel callers
> into these calls chains but that's the price we have to pay in this
> situation unfortunately.

Oh, I got what you mean now. thanks for the explain. I will see how
to do this.

Thanks
Hangbin
