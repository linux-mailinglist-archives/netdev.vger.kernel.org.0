Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF3F2FFD55
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbhAVH0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbhAVHZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:25:57 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BEFC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:25:16 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so4102135wrz.0
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0RMHgtgB5xkk9LFRgCVaAj41J8LIc67kmbXqxtG5yCs=;
        b=qon2fEM6rh180J7M3KjDsm8AwEt8egILRlj07VO002ARml3WX7CHPFwDrwfqkCpWk5
         lR4pA6vtyfkDaqkwJ+7wd1kWxRYGn10pEtii1jnqHrUhuEnYaHw/aM4Xxdwy0k3maqu+
         oRg97p6xo64DjhG/buJlhwB63nyUGnNe6FqPvdVo4YsAgq1L2ffgXP4sfYXP9hq2csPt
         21NGDClEF56UkNNrLcMjFAzb7uJnyKXFqYv/kMU+ZzqC7PD012dYQj75jUIIsBQBhdcp
         KT9gQ1EiiGlD+FB9+mXyialvT+KJdocgNh1kPOB1HHDV1Uwu78P1ZQxyH1g6fTc3P3R9
         D7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0RMHgtgB5xkk9LFRgCVaAj41J8LIc67kmbXqxtG5yCs=;
        b=CCtA8lQBXhSkUYpDjx+nVCG8M5k9EFqGUrvmLwDW/x/SIekOn5h9kw+CfWmK/TKm3K
         okGdJmCPxX7zcxeneYtwa/kSfPhC4nJU7oM+GCBgqmU1ZD7kq+hVE1mUgFtwqOnPFjn0
         1tgv6TID3HJVlJnitNKP38aM29Df0fQz+FDm+0t9xpSURW+DtlzNvH0esZVqmK5tkTfk
         baCrkNpV3u4VbM3dpOG+knmGP8NUzHwjNCdlWc6a8V+4y4DvFpUjFfNfIsTCz2Jljtiq
         R8rsCx7/JcVyU+O2d0hUZtKJBUXy8OpPWLGnHe/FPmHwfMEh8PzNHI7I2igPjjpuWajT
         MiDg==
X-Gm-Message-State: AOAM531CVVt+CbTjgxfZaZTBSjpbUUUKSk/4MJyh94rFyijq9jMQjGxL
        EHA0aCh3Mx1djsXwykJx5g==
X-Google-Smtp-Source: ABdhPJyhVpydbyMWOVaue7Lc56NW98R2jHdkaemb7LEuK3xy3TSLkhZMoYv/4DvUxBMqvEtdvZvMAA==
X-Received: by 2002:a5d:47ce:: with SMTP id o14mr3168674wrc.18.1611300315611;
        Thu, 21 Jan 2021 23:25:15 -0800 (PST)
Received: from localhost.localdomain ([46.53.253.48])
        by smtp.gmail.com with ESMTPSA id v1sm10005521wmj.31.2021.01.21.23.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 23:25:14 -0800 (PST)
Date:   Fri, 22 Jan 2021 10:25:12 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com
Subject: Re: [PATCH v2 net-next] ibmvnic: workaround QT Creator/libCPlusPlus
 segfault
Message-ID: <20210122072512.GA3854@localhost.localdomain>
References: <20210121220150.GA1485603@localhost.localdomain>
 <20210121220739.GA1486367@localhost.localdomain>
 <20210121184454.0ef91be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210121184454.0ef91be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 06:44:54PM -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 01:07:39 +0300 Alexey Dobriyan wrote:
> > My name is Alexey and I've tried to use IDE for kernel development.
> > 
> > QT Creator segfaults while parsing ibmvnic.c which is annoying as it
> > will start parsing after restart only to crash again.
> > 
> > The workaround is to either exclude ibmvnic.c from list of project files
> > or to apply dummy ifdef to hide the offending code.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1886548
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> That's a bug in QT Creator and whatever parsing it does/uses.
> 
> Sorry we can't take this patch, there is no indication that the kernel
> code is actually wrong here.

It is QtC bug. It will take ages for distros to pick up the fix
(which doesn't even exist probably).
