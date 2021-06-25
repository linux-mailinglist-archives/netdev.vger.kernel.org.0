Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710693B4889
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 19:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFYR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYR7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 13:59:49 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBE4C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 10:57:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id d16so12904557ejm.7
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 10:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=arRhN62j44m4VA64Q3RmWl4Xr3lAv7AA6ZGCOSiWYN0=;
        b=OZT6dW0up4Hk8JNW1J9IATWzn3DNme20t1n201zhzHM1CRQLX7c9adj0YogqtqN6Fg
         lyf/uR9qH/8UQG5Xg48BT6fSjXoJ6SF2e5zOI2G99zUFdE+VRxnvzyhFw9z3HDks7PGj
         soNjTN3MLAZTm6CSNQtB2n4mrRRnqNK76yxCwMBPJcTGd8w2CF1ytJdkEaHh95UonyuV
         Jdn2CpTGJ6tSY+N9sCa7TmAzablRJ5cNAaaSykMThb+mND8iplNc2ptOR5T3D156DBY+
         /Sc6vn3U3PjXxz58ROLD2gxdzzvmCWYwBXchgJa0h3MUImqHaaC1ay3UnlodhgNU/Vzk
         Zc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arRhN62j44m4VA64Q3RmWl4Xr3lAv7AA6ZGCOSiWYN0=;
        b=Cdk94y/wobPcD5QragOSjC0ifqpSI+gN6mZwLVVNosEWxB7/4tqjZQ7kfOmvYkNY26
         huT2q5Od90yDad9IfpM7IwrkJmxoOODBv6qhGjg2vlLOFuFn+I0Ees6O5a2qw7MT1g0q
         WirreFefBAZWBeTjP4ZHj8CzBAvIB39ALPirlfYKcKcWrvx2AT9ufHEHwzkvSl+8NMRN
         zJg8clmTCCNgDPsi6u6WKZKK31fPGJ1GmvUy7SBbdgxZrl+/sLRvuIAJtEK+OEUPVRZQ
         ZgkamiYlNL6uFmrdMm5ZvdjftzqnUgvW+SVhm1e3jFhOhGto0/tJkKZZtFmmHUyNK902
         dz/w==
X-Gm-Message-State: AOAM5308aJ2yREbB1w+39SnLaZ3EygPdaBC4M6vnQBOrYoHWZlukA/k1
        7qqiPUAd7QP1yNFD7MCZajUvjxXYRJrhjQ==
X-Google-Smtp-Source: ABdhPJzjMpSMtBDTCQREqxlYhWkMfxrkv5P/NNh9WQxIETm/xl7k+N344ZScP6MzClD0LCfzjgvlqA==
X-Received: by 2002:a17:906:8c1:: with SMTP id o1mr12377794eje.530.1624643845370;
        Fri, 25 Jun 2021 10:57:25 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id ml22sm1185469ejb.71.2021.06.25.10.57.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 10:57:24 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id o22so5844626wms.0
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 10:57:24 -0700 (PDT)
X-Received: by 2002:a1c:7c0b:: with SMTP id x11mr11959013wmc.183.1624643843964;
 Fri, 25 Jun 2021 10:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <98f7ab5fb176f1d1565a001c3324f1db6c0e6d4f.1624632443.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <98f7ab5fb176f1d1565a001c3324f1db6c0e6d4f.1624632443.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Jun 2021 13:56:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf7oXy3xQ8yetP7e8q_bpf_FwHmW5QHdQL7csz0i0O56w@mail.gmail.com>
Message-ID: <CA+FuTSf7oXy3xQ8yetP7e8q_bpf_FwHmW5QHdQL7csz0i0O56w@mail.gmail.com>
Subject: Re: [PATCH net-next V3] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 11:19 AM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
> and adds functionality to respond to ICMPV6 PROBE requests.
>
> Add icmp_build_probe function to construct PROBE requests for both
> ICMPV4 and ICMPV6.
>
> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
> icmpv6_echo_reply handler.
>
> Modify icmpv6_echo_reply to build a PROBE response message based on the
> queried interface.
>
> This patch has been tested using a branch of the iputils git repo which can
> be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes:
> v1 -> v2:
> Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> - Do not add sysctl for ICMPV6 PROBE control and instead use existing
>   ICMPV4 sysctl.
> - Add icmp_build_probe function to construct PROBE responses for both
>   ICMPV4 and ICMPV6.
>
> v2 -> v3:
> Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> - Move icmp_build_probe helper to after icmp_echo to reduce diff size.
> - Export icmp_build_probe for use in icmpv6_echo_reply when compiled
>   modularly.
> - Simplify icmp_echo control flow by removing extra if statement.
> - Simplify icmpv6 handler case statements.

> @@ -908,14 +921,12 @@ static int icmpv6_rcv(struct sk_buff *skb)
>
>         switch (type) {
>         case ICMPV6_ECHO_REQUEST:
> +       case ICMPV6_EXT_ECHO_REQUEST:
>                 if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
>                         icmpv6_echo_reply(skb);
>                 break;

On second thought, maybe it is cleaner to keep a separate case, and
then check both sysctls here:

 +       case ICMPV6_EXT_ECHO_REQUEST:
 +               if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
 +                  net->ipv4.sysctl_icmp_echo_enable_probe)
 +                       icmpv6_echo_reply(skb);
 +               break;

>         case ICMPV6_ECHO_REPLY:
> -               success = ping_rcv(skb);
> -               break;
> -

Unintended removal

>         case ICMPV6_EXT_ECHO_REPLY:
>                 success = ping_rcv(skb);
>                 break;
> --
> 2.32.0
>
