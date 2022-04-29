Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5E5515108
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378737AbiD2QpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376610AbiD2QpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:45:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD51483BE;
        Fri, 29 Apr 2022 09:42:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k14so6967225pga.0;
        Fri, 29 Apr 2022 09:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwO7JOOVGQF3gVakwvbVNF6yBHkItkffoETKadSEAgY=;
        b=ZuqGCM5qE1g+EvsPqefJW1c2b2jrR5jkaYwLXqHo8XabNKydys3JonwO/36b85brmK
         Ca4DwizzJlxQ0JTMAEkdrfdyVHF6C4kkw4HUT5N7C8AOq0kJ6VI++fmW1ve3luwmg198
         4iWtNbfmAIM6CbQ+6c+S6QY3xKq3jd9VNwsMmP5KurPBoJidMctjuz9ND5DVPmDUl5KF
         3E7Vi2ZBsUGkJTeef+iL87H0QXmS56IPqJ5CthX9fwlwMlmmcrXuFTgo/PJFE/8ekMjE
         oMdA4C0hbd8PCgC3J9iMbIkToAndLZE2SKaX0/WlTuzqPO6qzcfv0Y9vbczyEvXswvpL
         fUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwO7JOOVGQF3gVakwvbVNF6yBHkItkffoETKadSEAgY=;
        b=ioIJTYNHF6BMU0xWWGmFTUDak4PZEtxO6lExBu19lAQd4+vQOo8nwG6rG+JZJAtBvs
         wWEjg4LHGylU5snvFWc61x57gfhRKGDXPjHI2ujhx7TN2oDLjA2//zyXXjC4wn+4moT3
         tcHoAfc9VZqCrgZEoToDAZazuH97U5n0Oz2KEc+fY2AC5a5y4JH7YQQvzZxGfzKijujb
         wI1+BmF5Fi36IvmE9JR9dBuqVYtG3VWqOZbkG2MybMQz0Y5+I1lx4OM2sTa/S3QQNN++
         d+yj8ZAICXMY4bwnfhHPeefhQKBSTjwnPiTALxkHBM+Uy/weRMBTb6mK8SWF0Yr6Koaw
         /7Ew==
X-Gm-Message-State: AOAM533HlYb55GtetLhPh2LctBs03KOSqvZq1IxlMGK6W352c3A76cJw
        68kfBmqKcDDEopuDAh2SDPsgYOerii1NbWbedd4=
X-Google-Smtp-Source: ABdhPJx5+3KWS/HTDUik07sDf3LsHVX0y4tEApMpyqIRUSK4SbtkkkRvHu+nXdpPlZkl6nrSZu16JbuG3k8ZGl6+xpE=
X-Received: by 2002:a63:5163:0:b0:3a9:4e90:6d3d with SMTP id
 r35-20020a635163000000b003a94e906d3dmr247357pgl.48.1651250522335; Fri, 29 Apr
 2022 09:42:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220429111541.339853-1-maximmi@nvidia.com> <20220429111541.339853-5-maximmi@nvidia.com>
In-Reply-To: <20220429111541.339853-5-maximmi@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 29 Apr 2022 09:41:51 -0700
Message-ID: <CAADnVQJrRONd+pPpfahyzLG7WCP54y_eoNb_8zCsN_m=S_OSZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 4/5] bpf: Add selftests for raw syncookie helpers
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 4:16 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> +       SYS("iptables -t raw -I PREROUTING \
> +           -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
> +       SYS("iptables -t filter -A INPUT \
> +           -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
> +           -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
> +       SYS("iptables -t filter -A INPUT \
> +           -i tmp1 -m state --state INVALID -j DROP");
> +
> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
> +                           --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");

That doesn't work for test_progs-no_alu32.
sh: line 1: ./xdp_synproxy: No such file or directory
https://github.com/kernel-patches/bpf/runs/6227226675?check_suite_focus=true#step:6:7380

and going to be fragile in general.
Could you launch it as a kthread or fork it
like other tests are doing ?
