Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71413340A62
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhCRQkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhCRQkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:40:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DCEC06174A;
        Thu, 18 Mar 2021 09:40:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k24so1802859pgl.6;
        Thu, 18 Mar 2021 09:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sQ7sphuRAvIZYwnemV5l2KNTUGdlBlXVyGrSJ4rSYE=;
        b=Xwvboc7wCM2hjrRhYvjCeLseIGmXiG4wE0hxw+OnyDK+AvDUuRBB63KLU2ecvj2SH/
         jNYTEfzH6C6+8PNyhHpiN4YDi6VMUbJedgy9PuUZQ3ToAjghsQUuymHv1ipoMEOww0Xo
         xMm6viN2QXKWIp0+1jDvxWIOY/6s0M2u2r0FkUmSLd12t5m1HVxP/shFPyH9+Z+by6Fk
         bb4xyCsMAfldaYm1Q4WyUewpV8hcO4uHG4t2ci+Iqvhj2QPFXeFgIcVQ41r9jXNThE5O
         NdoEko4YmaM//u1uP7oa1X19sr+4fboR0Q1aYcnrzUpaDegs2xUKaJ9idCuLyPGRcTBb
         6jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sQ7sphuRAvIZYwnemV5l2KNTUGdlBlXVyGrSJ4rSYE=;
        b=DTijcTbHiO1uNTAl8xA+GoLEDvbrS4GJv7TRdHXam22UoZIfg2rqflgShcXin/EUj0
         ILbNw6u+QGB5ZqxgnzJofQUbWppnkRIsNwcEr8YJVpS+t75+RLqBUOFbLq1vg/HFFdd0
         xTGAR3bq8PABKKCfPjDMTzm3luN2tvk9EkjDplFDJaZsQg9GnjNUmO4ZIhMJm4YPDFdA
         dEGDRAagKNAptEQ0II/JY943qtHM3xoJBeaE2DZeUJHxPGtnT/V0KpYj53XCSF8F444T
         lnmpZ0r/9bzUGd+E9Edc+QZL4yzgW2AFJfFGXuuivmBO0jwZeeK9ipnjpiHR7bFoVoRS
         SYsw==
X-Gm-Message-State: AOAM533OKPSWOyZNJ3Yo2DKy5X6vV/7IDYQIhA1G4kDyRDwEilYIORVS
        fuOwc5JKafsDZJZ4CpjqwX+X35YuQ6d30DpCg0M=
X-Google-Smtp-Source: ABdhPJwEWbRTUilMRjZR1Asb7ihoM4D9bJX/mqW8uHl2ADek3puOX7sm38P+ugGNE6PNxQ2vKITlPa/91pQZDHa+gjE=
X-Received: by 2002:a62:8485:0:b029:1fc:d912:67d6 with SMTP id
 k127-20020a6284850000b02901fcd91267d6mr4906112pfd.80.1616085652002; Thu, 18
 Mar 2021 09:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
 <20210317022219.24934-7-xiyou.wangcong@gmail.com> <20210318120930.5723-1-alobakin@pm.me>
In-Reply-To: <20210318120930.5723-1-alobakin@pm.me>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Mar 2021 09:40:40 -0700
Message-ID: <CAM_iQpVYqcYCA97KTx6bRAEkkO4gpy_t8YCGTUQ2XRDnJ=-sFw@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 06/11] sock: introduce sk->sk_prot->psock_update_sk_prot()
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 5:09 AM Alexander Lobakin <alobakin@pm.me> wrote:
> Regarding that both {tcp,udp}_bpf_update_proto() is global and
> for now they are the only two implemented callbacks, wouldn't it
> be worthy to straighten the calls here? Like
>
>         return INDIRECT_CALL_2(sk->sk_prot->psock_update_sk_prot,
>                                tcp_bpf_update_proto,
>                                udp_bpf_update_proto,
>                                sk, false);

I get your point, but AF_UNIX will implement this in the next patchset,
and my colleague is working on vsock support too, so it will go beyond
INET very soon.

>
> (the same in sk_psock_restore_proto() then)
>
> Or this code path is not performance-critical?

It is not on the hot path, updating proto happens when we insert
the socket to the map or remove it from there.

Thanks.
