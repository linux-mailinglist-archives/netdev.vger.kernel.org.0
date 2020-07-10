Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1116D21ABDB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJABN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgGJABM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 20:01:12 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933F8C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 17:01:12 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o3so3543218ilo.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 17:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KDvtqlWzLaNt0DwWUuuvAfGfs4QUnKIb+nnT2vy7yfw=;
        b=NldQ8xB5TgFbskWvop5mWtMwa/8MYd33gqhlJlHeBTQPkcWRV5sSNG4c88tcCYhIwV
         mB4Rb0w3a+MxbpQ3uKOwR2dk/pctIu5RoJShsWVJsLgsGB/7Mp//CZS3baodkDmx6men
         /G9YJvEApswYLnAwUo9J+T1n52+QqIFuiIixVjp5zziY2V9UBREPmr/RRfLfg/Mu9iuM
         2AU3qZq/OOg2F/7qtZhi4UaWD7kcYQTWU94YjYvbqLKUGDpjEZLKaO0Vfv9VuAWYfPX6
         WEufYZcNvYmY5asu/MYFgLpnUC0F9glRH9Aax+/b/AUGWA5LVTxNnll/dgwqvUtlBRdk
         xzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KDvtqlWzLaNt0DwWUuuvAfGfs4QUnKIb+nnT2vy7yfw=;
        b=Vc108gZabSTfdJeJ1ImWz4FDlibd/yDx73pwoTPwJqL7E6T4CkIZzNzhrMpdalJQJ8
         6fvMf7SmKBA00D21plgBKIHr8MgQBlGRSbs+C+w1C6yh48BTRZSqbvBgUbUUT6nrJdxt
         XGGe7X+p3hlzMhLC0MeWy8eyuFhXtpGHiJMNwe6STonvH8H0rQ8IxhqU1LVQq/Too0bm
         hk+mvanILaOxXbN2UMr1vLyiuudbNC/vlAsI+dvzyTpWuPwZRGdFx2/mOe/9YeELqt5+
         sk5/9VQyys7dF8l2tPGh33MUM2ie6XDEtlMF3E4chGyrOx21pfbWnDcdMt1QETs/OAlU
         YYZQ==
X-Gm-Message-State: AOAM531jVLJukBX0FBqKtPQcWQqae3MVNaERerq6ILlbGMNksPc0AE60
        B7YXewel6HnjHSrI58cHUkrwX09mSPG3uZrnUqIFaNRl
X-Google-Smtp-Source: ABdhPJw8mbKDYKEF/p0bnciku26tugSKOb+qKw21N49EUEpDGKDclQujEtGmhQUJUb+A+QkRNAe7NvKXNXqRZNIQNPc=
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr48470864ilq.305.1594339271830;
 Thu, 09 Jul 2020 17:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200709.163235.585914476648957821.davem@davemloft.net>
In-Reply-To: <20200709.163235.585914476648957821.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 17:01:00 -0700
Message-ID: <CAM_iQpUqcSaxStB+2MnVPRfx+RS5_4CfJLRiV+BOFSmeBCXCJQ@mail.gmail.com>
Subject: Re: [PATCH net] cgroup: Fix sock_cgroup_data on big-endian.
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 4:32 PM David Miller <davem@davemloft.net> wrote:
>
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
>
> In order for no_refcnt and is_data to be the lowest order two
> bits in the 'val' we have to pad out the bitfield of the u8.
>
> Fixes: ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks a lot for sending this out (and correcting a stupid syntax
error from me)!
