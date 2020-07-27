Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC30E22F981
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgG0Tul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0Tuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:50:40 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E1BC061794;
        Mon, 27 Jul 2020 12:50:40 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id w12so4667245iom.4;
        Mon, 27 Jul 2020 12:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKPEIvRnGmOIiRW3hkgHDbFWruyoPp9+tzWubRQC29M=;
        b=eyN6Tfy3dTAC8horMFbjFWcPSq2GlcFnpKV1J/Fdu/CAxMldKyfn3aie6b5gl96tBh
         y17nXeuS9sKdqESZ0MRUc6kZbyixZUAL/Ml4AcNVbn87nqdFN3JN8i+PSHI0vaSooSZZ
         ECb90vPwMhJYsJ61kFgedhQko0BeZtphczkSLcU4Rld7mhyVv1nI8PphkEl2RJzUGPW7
         R1T5W58nmryzh975BfFoJDGfNd1gA8LpbchBLFgLthQgT1b+gqeRKsaaa3o32LHZ/56E
         cwS1MOyBqeceDVwyHJeR88hLgAaVrRRAmzR9x7oTUVua8dDTLP4CFlIn//ZyOVbETaqZ
         vBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKPEIvRnGmOIiRW3hkgHDbFWruyoPp9+tzWubRQC29M=;
        b=hCz9Z7WEtzjXwT7y/zlPG4xF35Btf+hJ79VgcxiK1qrlVrwzfQrKiOMfQgMV6ETsec
         n4YYdJO4uSmyQYzSHmYZihBP/i8yInbX5gAEzOEBdlT3sFTaHwDT+BZb28omqUMA7iOe
         MNrCY06VTAv/687mQrbzY5iqgUK1f4T+GZ4gfiA3Mj3/LplkOalK0LG4U66+cnPH2Bsn
         XX5Btdd/gzgwcnWvIq6bTUiMUJrDw16mjiD6wfBhdN1nyPy7KMKUCfH/LKS0mcAKFSn2
         F2KjTa6tFEDA9Ctayf4FCJYu5iG8TRt5WYOxl6wnyt77WCT9KQJwPqplI1TVRqKij1vr
         nkiw==
X-Gm-Message-State: AOAM531+KaxlZz7GnDEVSKCUQVCbpvrQF2oXGx8qoJhNZCOyjVTBSK0I
        5/A0A3A27/DXqzmW+XxWbgJ5fk7z+8HCgZV+c1s=
X-Google-Smtp-Source: ABdhPJxIF+iJ26Dsde/xBHkvxdLPkjp3U8eTiaZIMnGo8VgedN0+AUm4284sh3Hvm6sv0wv7SpVS9ASTZ6QB1xOhxhQ=
X-Received: by 2002:a5d:9b86:: with SMTP id r6mr5734317iom.44.1595879440133;
 Mon, 27 Jul 2020 12:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200727033810.28883-1-gaurav1086@gmail.com>
In-Reply-To: <20200727033810.28883-1-gaurav1086@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Jul 2020 12:50:29 -0700
Message-ID: <CAM_iQpW+Z=y6myMRfkmKuqQpVTLD52vpTB41esJc5zRFW4DK2w@mail.gmail.com>
Subject: Re: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 8:39 PM Gaurav Singh <gaurav1086@gmail.com> wrote:
>
> ipv6_pinfo is initlialized by inet6_sk() which returns NULL.

Why? It only returns NULL for timewait or request sock, but
I don't see how ip6_autoflowlabel() could be called on these
sockets. So please explain.

> Hence it can cause segmentation fault. Fix this by adding a
> NULL check.

Which exact call path? Do you have a full stack trace?

Thanks.
