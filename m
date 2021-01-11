Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489DB2F1A72
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388524AbhAKQHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:07:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728569AbhAKQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610381183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vG0LkxvniU1+rRSLrUIIlJZUL0ieX/zuWHGQuX4PbVM=;
        b=eAh8sokvQoj/YS3PPMty3Du+IkIld7CEplc3/AC/W/sy+ecoZyqmSWUVrU/KMq1eyOEDu9
        8e7PRFX4E2QmSLxpI24vNUTk6+TqycHeCjAI3zu+X3GyoBR5ybftsars0osgqvEcopZO7w
        5ZPZ/6v1++3qt10Wgiiqxbhtp9nB78A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344--7vgAcBbMcqt9zA8FZT8og-1; Mon, 11 Jan 2021 11:06:21 -0500
X-MC-Unique: -7vgAcBbMcqt9zA8FZT8og-1
Received: by mail-wm1-f70.google.com with SMTP id 14so2117425wmo.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vG0LkxvniU1+rRSLrUIIlJZUL0ieX/zuWHGQuX4PbVM=;
        b=NN8aOxTcGzpDG6Dfyo7kBxU2lbEAs+UC5HJhf4Y4z56uf6vBX9Y3RBrK4petCN6DTr
         dQ/Kgywh4FhVXlxInC3swmO7/pCzmIUgbdDMha53NpSNVqY7hd2wP/0XA1XwpTR2XO3f
         ardIUIV+UyBNAoE0DYdZh0FlI8ozRclCkhy06gTskIipTYJiDNl8Jbg51kfuHFOw4swo
         1rqqSzo6Hs1uO5bGj+qvCOb+L2HtUZqtURgtMeDQYA3HnG4wEW9Ki0S+iuR5wtb5K8s3
         +srXcqwmGJ+uLQmWsuxpUL6LRzR8VWtgkY+BLVQyrmI7JnqpA4ITPNTGdviH+N3d524K
         KwbA==
X-Gm-Message-State: AOAM5334YwszKjwAZgf6951lgqkKgp4OfZDuDxtQfaryvVXlxG80ZOVV
        5IpIjIF6SukpJd0W+C6Xyru56qy6JbhrbJiyHsd6YMmUXkZRz1dtnSN2eZ02sObC5yRGUPssvQV
        JYDCFPcRguD83dCSi
X-Received: by 2002:a1c:7c03:: with SMTP id x3mr360408wmc.17.1610381180714;
        Mon, 11 Jan 2021 08:06:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQkoxyN4WFiKe/UxG6u7fSRgEw5SacLUxWx9QeX1CJgec+C6j1nBuH3UKp/aTdhXQLZ9m09A==
X-Received: by 2002:a1c:7c03:: with SMTP id x3mr360397wmc.17.1610381180605;
        Mon, 11 Jan 2021 08:06:20 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p8sm73495wru.50.2021.01.11.08.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 08:06:19 -0800 (PST)
Date:   Mon, 11 Jan 2021 17:06:17 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <20210111160617.GD13412@linux.home>
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
 <20210111105744.GA13412@linux.home>
 <68d32b59-4678-d862-c9c5-1d1620ad730a@gmail.com>
 <20210111154422.GC13412@linux.home>
 <80bab0bc-3c02-b6d1-3e67-90fdab912864@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80bab0bc-3c02-b6d1-3e67-90fdab912864@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 09:02:04AM -0700, David Ahern wrote:
> On 1/11/21 8:44 AM, Guillaume Nault wrote:
> > On Mon, Jan 11, 2021 at 08:30:32AM -0700, David Ahern wrote:
> >> On 1/11/21 3:57 AM, Guillaume Nault wrote:
> >>> Okay, but, in the end, should I repost this patch?
> >>
> >> I think your patches are covered, but you should check the repo to make
> >> sure.
> > 
> > This patch ("tc: flower: fix json output with mpls lse") doesn't appear
> > in the upstream tree.
> > 
> ok, you'll need to re-send.

Will do, thanks.

