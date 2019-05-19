Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5CA22866
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfESSow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:44:52 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46360 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfESSow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:44:52 -0400
Received: by mail-yw1-f67.google.com with SMTP id a130so4932095ywe.13
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 11:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDPtq1zhnEX4awgYpuSSAKr7uq74Q/mnHFav4e1VSNQ=;
        b=Fx8pX7dNBRju6fhB4eAHfXxIpZj2UIhgTL0B/H2VkDfksr1OT7ahQJotnt8zcXaKJN
         OrPgC2zeGtYRSZf4FVWd56LYeabrvAXDbxjXPGt++BaB2Cpq4AmfEy571qjOR71PLHZS
         ZkIGGPGrOtacIuCAMrAxeBIr/GD7lv7maHRhWWWWrzs9CLUyJBvu+E9GcMj6TYnwxVlF
         Ko1L8SrHPjuPQCIGPZ8AgwMMEygvhHh293kxbXHcBA3a4xluaeYnp2A51yrUBnWzV27C
         sdjqPb0tuUK8Jj/C00yIU/fCSSFw3GOIKoGLuaknv3hBMxu8RIYQIyEn2u6PmvO512z2
         6e9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDPtq1zhnEX4awgYpuSSAKr7uq74Q/mnHFav4e1VSNQ=;
        b=rPIes8dKjadF02qEQd1RHxdXvO7W+3FkyhpeZoZn4aHJWHoglfxxRxwyAs3w2bqYQU
         XmiDbO304DmCL9caCfIlLwmLr7cXi6IYV59utiuJcF3TOKorONfL/FBAhsVajnldke7C
         z0vnU+wxSekWB8kcBBS2BkCWNU8KyZwe7YTu0fW2h+IfRdY0R72Ox2ND6zPeC+GGfrJ0
         ftekzWBFKPTI0H0aXsdLDMwEmIHSZFx4ADm6QZhXY5ChQorHnQDa1Jni8n8YRZRgm5ep
         Isa5CpfawRtfxW/xjkHb/NNfEB+wvT0pKDQtDWTRxzjiXvYVcKBeVIjdQXAIf7cNkrde
         VOfQ==
X-Gm-Message-State: APjAAAWKoT7XVrbtk0i2gIHYZKv3RSmJtwqh/TdvwYUKfU7l1KGvF4QU
        V6YXrazHUhhArPEwr7g0UV4U406ClLPdXccvxn0tT5M8lxc=
X-Google-Smtp-Source: APXvYqwartGeASgta1G791iJh55lRKRvPgrV4NsKGSlaG/6fsMMN/ulEgxafR12KffEwIDfntjTbppDNLfxQYUT3Ceg=
X-Received: by 2002:a81:91d7:: with SMTP id i206mr14666641ywg.147.1558250628692;
 Sun, 19 May 2019 00:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 19 May 2019 10:23:37 +0300
Message-ID: <CAJ3xEMikS1gNpkTkX1fmQD6GFJutg1qzU_-3dgQA57u0Z09iGg@mail.gmail.com>
Subject: Re: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
To:     wenxu@ucloud.cn
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 12:45 PM <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> The mlx5e support the lag mode. When add mlx_p0 and mlx_p1 to bond0.
> packet received from mlx_p0 or mlx_p1 and in the ingress tc flower
> forward to vf0. The tc rule can't be offloaded because there is
> no indr_register_block for the bonding device.

For the bonding case, the offloading strategy is tc block sharing,
namly have user-space
share the tc block of the upper device (bond) with the lower devices
(mlx5 p0 and p1).

This is implemented for example in ovs.

You can read on tc block sharing in the mlxsw driver wiki [1]

Or.

[1] https://github.com/Mellanox/mlxsw/wiki/ACLs#shared-blocks-support
