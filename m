Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2E31E7E3
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhBRJVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 04:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhBRJS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 04:18:58 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BBC0613D6;
        Thu, 18 Feb 2021 01:07:25 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so740380pgl.12;
        Thu, 18 Feb 2021 01:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mQBztfjp/3MStXH0+mDXVbD87NdXIglzoEnDzflrmdo=;
        b=INyf+rS1a7pOuZUIhaR+wFHLLKpfHZAS7UUgssDvlYB3GEsesmLx/Dwx8MkLzl02Db
         NoWvuMnGyis3hfOs0LbWrnaYIs4Xu4LibjIJH7P2CTIbFGMCXjPpCvXeuzHXNv6+qkJ0
         ffWuVk4MgszZVYs531kCG+T4f7NaLTwB4LUzjPmIHwQwyd9dz+njhS/wBtMQHWDqhav0
         61LMCyWdXzpy5WeNP5XVrGo28WqQjN9w6lm+INpPGPZBpTaueOc/JpJ48Db0J1HHjBC4
         pmnah0vJHqY9sBUx7V2YUnd804JzEtrKInVgt3B20jRuOWo3xi23R9aQ364tziUDeI8B
         ftog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mQBztfjp/3MStXH0+mDXVbD87NdXIglzoEnDzflrmdo=;
        b=O6IpWDtZIV+9rVWqwLVn6qTcRafMTBLxhrmSao742PUzSNSdxaknvWVZ3IB87d0j1Y
         PFlj1nLIp/CWAcZE4AQ7qfKcRy49aBYy4X3Uy5jqmg+BvQOzM0yJ18pjfRpJQcYIZKWj
         QbbZ7psAGzKTH8N5FTE+dO2Mhcrm1OFiTsRIvjrGaK+9H/s8wChwuJfS8d1DwWgT7WDS
         Nu9WZR2UNZ07fVXmdh90zTA9YSWiepGWsg2wEDJ84e9uTTi0P7pNfNWI1YfiVKSWFotp
         p187nKco7ULhAi+42VMHvb7do2rAK896X5kdO1KEJmewHPm3Ycb4RT6lQQTHSgRAuj+t
         8rPw==
X-Gm-Message-State: AOAM532Y+jsc7pmgL2PlmmqMNeKTSNm73Ra69xcP1z2aDSA/o0Ad4W9s
        DYi2Yco4FqcVfcTKhDPSWYYyparLXnQ8xDAXSYAvOTab
X-Google-Smtp-Source: ABdhPJzDuaH1uYb29WOSAr21IwnzgzNKW9cyYbpWxiVt1YIFFFs0Ru+UTrHhhXvYqqF+PGHLNeaAfhLM9zUsnVdb/Uc=
X-Received: by 2002:a63:7f09:: with SMTP id a9mr3189133pgd.63.1613639244721;
 Thu, 18 Feb 2021 01:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
In-Reply-To: <YC4sB9OCl5mm3JAw@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 18 Feb 2021 01:07:13 -0800
Message-ID: <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 12:57 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> It is nice that you are resending your patch without the resolution.
> However it will be awesome if you don't ignore review comments and fix this "3 - 1"
> by writing solid comment above.

I thought you already agreed with me? It looks like you didn't?

I still don't think there is any problem with my current way.

I still don't understand your point. What problem do you think is
there? Why is your way better than my way? I've already given multiple
reasons about why my way is better than yours. But you didn't explain
clearly why yours is better than mine.
