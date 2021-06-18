Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1A33AC8D0
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhFRKbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRKbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:31:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD1CC061574;
        Fri, 18 Jun 2021 03:29:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s6so7924030edu.10;
        Fri, 18 Jun 2021 03:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2fvTs+2Fdfq6ppyqbx85N4qPneZ48SNzU4u0id5Uqwo=;
        b=DQYQEho2d+iDoUYI7GpQ826KA4AYhsjIqsrCBMbccCo0jXPf45wGtAWSEuVwoYzSvW
         wra0B+Da/o8M5kwNT3NoZlITot/2lfVW52NdUAY/sK7JHk4f+z1YX++WiSYZtxzrByB6
         4MgBTHI2XyS44aJnOZC7QbjZBINpOpCozi2njmKoEGFXd2f+dseR+ehfxkbvJZdlfp4o
         am3FMV/Zs5XueOtvKZhNKSNHBSwf1lPqmCEDwiHK9SAq1kTQg8HB+pO3AQwiLz9hzrlN
         HkJwJ3jxfWQ4lVLvfNJLBeq7aRjRgk28kApVHgG47VhRRdlODE3+vggq6JqBsnqkTv1z
         1Jgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2fvTs+2Fdfq6ppyqbx85N4qPneZ48SNzU4u0id5Uqwo=;
        b=JWd/8QUsqKWZ6ksfc6b+a9uh8CE/2ODHzPNkKwUDZWN6KURGCPreKveoXV0heCu1Fz
         6n/WXtDw5PPP1cvR0Lkbhpg7aMi9ChGN01yquHTsO9E+U+Ya7ubXZIVlu42Xz9dVdZqn
         Rb+pw0XB9PyoUAJwCv51yVIpiPUlEndl0GMyLViLTQewRaP8EnndWChK2ch8EhZHE9pB
         +bb9xMJLr+80tDwbtwoxzJQ+y4Xs+zjF7qy3F7UyGpEFP5Vtk2MLnapG12ogxx4u+vxv
         KSVpoalVL8RhcwaL3P9WX9eUq1xXLC0MkJde8N4Ztu1WkaOjZ5iWrC+61WjjywdeuPDR
         KONg==
X-Gm-Message-State: AOAM5303/Jq+Yxt7RL4TG51h+q3eQgSrQ2r7iAdeGurvpgJbI6sSbRvr
        yu2DP5eCIi5aANasW72gTY613x7c5Pr9yltOdww=
X-Google-Smtp-Source: ABdhPJwkHaCLbv6wIc6aD5b62mv7QbPQUNuHY1xLE421Pou6kbsFrx6Fann47/PattPdhxZf/m3ai1n8cVujsebWBTY=
X-Received: by 2002:a50:d943:: with SMTP id u3mr4084110edj.175.1624012175072;
 Fri, 18 Jun 2021 03:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <60cc6c9a.1c69fb81.70a57.7034@mx.google.com> <YMx0ZIAkTloug34m@kroah.com>
In-Reply-To: <YMx0ZIAkTloug34m@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Fri, 18 Jun 2021 13:29:23 +0300
Message-ID: <CANEQ_+JLe-nA=7T+_nQgfwJMe4OBz+8MRo1kR47adz4DPafw+g@mail.gmail.com>
Subject: Re: [PATCH 4.14] inet: use bigger hash table for IP ID generation
 (backported to 4.14)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe you ask about this one:
[ Upstream commit aa6dd211e4b1dde9d5dc25d699d35f789ae7eeba ]



On Fri, Jun 18, 2021 at 1:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 18, 2021 at 02:51:22AM -0700, Amit Klein wrote:
> > Subject: inet: use bigger hash table for IP ID generation (backported to 4.14)
> > From: Amit Klein <aksecurity@gmail.com>
> >
> > This is a backport to 4.14 of the following patch, originally
> > developed by Eric Dumazet.
> >
> > In commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> > I used a very small hash table that could be abused
> > by patient attackers to reveal sensitive information.
> >
> > Switch to a dynamic sizing, depending on RAM size.
> >
> > Typical big hosts will now use 128x more storage (2 MB)
> > to get a similar increase in security and reduction
> > of hash collisions.
> >
> > As a bonus, use of alloc_large_system_hash() spreads
> > allocated memory among all NUMA nodes.
> >
> > Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> > Reported-by: Amit Klein <aksecurity@gmail.com>
> > Cc: stable@vger.kernel.org
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Willy Tarreau <w@1wt.eu>
> > ---
>
> What is the git commit id of this patch in Linus's tree?
>
> thanks,
>
> greg k-h
