Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE430FDF3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbhBDUS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhBDTyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:54:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CE7C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:53:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lg21so7603753ejb.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MdHkTFHEAx2xX26RFfkpT4AOjh1YCZnrmi1Nm4gJD5k=;
        b=p20kQuKNbgLJjpSZGST7nWg9KEWQ4lW9nPetUy6zZaz+KPuLaA65FRCVWv5NPIKQ6N
         I0PPECbyJbZ6VYXeZmSWIluPZBhURTBFfgtFvXcNYl6oUgkvt+qqpzaPvgR7IouvJOdt
         tnnYWQqJ/or8tygfFDtXK1cOGBONrQxWU1v5hmisjbb5ILpdiPrE/U56erGQzvmHuYlP
         PCikqpn9NU0bUIJ7aYIkhTp/0lQiqiuHpNMsJev8Asf6Yi5USoO45QTnVX8tNWRWUeSb
         J9TC5na+m8Bi7J1p+f1zrbG7YKU25xarA5sjdQU0Z+/Yw13+zwOiX41WmN38LYZDPsRp
         Kjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MdHkTFHEAx2xX26RFfkpT4AOjh1YCZnrmi1Nm4gJD5k=;
        b=X71W1aGoI96OmK6tGbGVZ88sszxcBeedT0zt+ZmDjEy5xAtjf87WvN0CaRIl1hxcP7
         8DhnvSRP8dEhm8dTDfVM7iyr543RjDQy/Q+VVV2a33irUcibl430DjYPcHq/gfLuX2GT
         PRxPVJaKOxbqyDQLn1hXJWhLpC6mVdbbmKVfhLxRrsm13BCRCeiRAsClff/Gd9bH2ZK4
         V+fGysI9p5wgnaESmqXEQ++H5bRrxYTHmeZfBWw3Ac3nTU7oLJ6qo4qe81Ui4Tyxlz38
         lIqOyRYB+YM/pnoygJce0H5+vnwlaR8p0aBjWsi+0N/SbB8uPEpTJXaepl6aOsdUezeX
         08Og==
X-Gm-Message-State: AOAM5337D+a8GUDICug0vfCB0CcG0CB0uAM5h8AigMKz5gngPcfeC8v0
        BG+tQCCT5Ni8IKrG0/CJonBK/0KamRKAtPspqP4=
X-Google-Smtp-Source: ABdhPJwkW3r56uyfRAvUz8j1kcMiVn7ChxnWKDhQ5PX65GckATTY5UUVGaxqqiQESvDioDFzd49rur4zOpM6T/pjUR8=
X-Received: by 2002:a17:906:7698:: with SMTP id o24mr687815ejm.504.1612468409373;
 Thu, 04 Feb 2021 11:53:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com> <9d167c46fbfb38ab8559695524b5a84449855e1b.1612393368.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <9d167c46fbfb38ab8559695524b5a84449855e1b.1612393368.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 14:52:53 -0500
Message-ID: <CAF=yD-LL-EWTUnEPmm1C07fYNpcuLmyCvbiKH-hL3V6RDkUW_g@mail.gmail.com>
Subject: Re: [PATCH V2 net-next 3/5] net: add sysctl for enabling RFC 8335
 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 6:29 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Section 8 of RFC 8335 specifies potential security concerns of
> responding to PROBE requests, and states that nodes that support PROBE
> functionality MUST be able to enable/disable responses and it is
> disabled by default.
>
> Add sysctl to enable responses to PROBE messages.
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Combine patches related to sysctl into one patch
> ---
>  include/net/netns/ipv4.h   | 1 +
>  net/ipv4/sysctl_net_ipv4.c | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 70a2a085dd1a..362388ab40c8 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -85,6 +85,7 @@ struct netns_ipv4 {
>  #endif
>
>         int sysctl_icmp_echo_ignore_all;
> +       int sysctl_icmp_echo_enable_probe;
>         int sysctl_icmp_echo_ignore_broadcasts;
>         int sysctl_icmp_ignore_bogus_error_responses;
>         int sysctl_icmp_ratelimit;
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index e5798b3b59d2..06b7241bc01d 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -599,6 +599,13 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec
>         },
> +       {
> +               .procname       = "icmp_echo_enable_probe",
> +               .data           = &init_net.ipv4.sysctl_icmp_echo_enable_probe,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec
> +       },

proc_dointvec_minmax with zero and one.
