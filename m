Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F102DB120
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgLOQRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgLOQRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:17:44 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A582FC06179C;
        Tue, 15 Dec 2020 08:17:03 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id q1so19746108ilt.6;
        Tue, 15 Dec 2020 08:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMBkPaHV1FszY9RVVG5m6wG2LlkxrZUPhGV7sfd7dno=;
        b=tJHG0kgGuEoyqTsEA541iJvFTXFNGhZkLB91MRW+7InURYMd/fjNMy6/1PbVEZ+DXv
         9ee6GLpJIv7XQs5TZHH+vEHEGQcSVQJKUZr37syLwpJXiL2VC16q4Ur2Z1P4ykyTZjAC
         3FWoqIAMaeavBRzQWFjslh160PAyYxzhut7xbA2s9DErQ2C4F9llG55j8N3EbNl5BIqR
         /RgJ6ayTJEztL3+rVCEYpoG49kRMicGY9yO+HwCjNaMr/TyFdhNio9oktkFJQtnzX5Sl
         ZRH3Df03tcYXyHBgu7EYwAotcRmkMwUBiyWf0yYDJ5TWqP9L2/M+JYriJxSWDpp3Ojjv
         Mhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMBkPaHV1FszY9RVVG5m6wG2LlkxrZUPhGV7sfd7dno=;
        b=URS+wjWv160lswk8Ku8tsm4DGcOWxU7tzG0U1rbOGTOZepajMi8kePIzz7P69amFe8
         6AQrS25MnJI8fpSQlVryH2jzhYWNSeLJsQbLWH3yGgAmoxvOmqTqev/r9j1mJF8JXxcA
         JMP/rg+GexCiFOMhDmZs9aJmvzxNKaeJ05MCfmfsEjpdFdNy3rLdsvtEZa3kPaxvm1VA
         PyO+kd1DQdnZygMggp/tqJcwHTTocS4I7jAv76LmiKiuO3xXfmxdTVVeCddegmGsApTa
         cTM/ktTiHUV8i0p7MblDY5FKB1EzKceBajHm0bt4BkpSPvT050OZWct+R2T9jinnMNQr
         q8rw==
X-Gm-Message-State: AOAM530tHjzlOrbNsnsAkOdkVH+6mTKujnUTe+FEnSYU65yZYkKi/bcm
        X/RBlGvy/RNPVVOEqsjgBZd/rf7FBnAWDqClyF4qx/kcjYw=
X-Google-Smtp-Source: ABdhPJyRNQsk6jET9p1qToKYyX89IJpCScnKnmnzSE9j97VJ3/ST5m+ZwoSLkxRI4uqIk0XZ2tCqzLL2PRfUXQiXsTs=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr40842917ilt.42.1608049022875;
 Tue, 15 Dec 2020 08:17:02 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <0af4731d-0ccb-d986-d1f7-64e269c4d3ec@gmail.com>
In-Reply-To: <0af4731d-0ccb-d986-d1f7-64e269c4d3ec@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Dec 2020 08:16:51 -0800
Message-ID: <CAKgT0UfRWgkvezq2XVYGgxW2d1s+namb2r_e0=m9QN=e2O9WvA@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 6:44 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/14/20 6:53 PM, Alexander Duyck wrote:
> >> example subfunction usage sequence:
> >> -----------------------------------
> >> Change device to switchdev mode:
> >> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> >>
> >> Add a devlink port of subfunction flaovur:
> >> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> >
> > Typo in your description. Also I don't know if you want to stick with
> > "flavour" or just shorten it to the U.S. spelling which is "flavor".
>
> The term exists in devlink today (since 2018). When support was added to
> iproute2 I decided there was no reason to require the US spelling over
> the British spelling, so I accepted the patch.

Okay. The only reason why I noticed is because "flaovur" is definitely
a wrong spelling. If it is already in the interface then no need to
change it.
