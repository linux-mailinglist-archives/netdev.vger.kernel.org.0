Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA349DA20
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiA0FZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiA0FZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:25:42 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37584C06161C;
        Wed, 26 Jan 2022 21:25:42 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o12so3041043lfg.12;
        Wed, 26 Jan 2022 21:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TTswPHu4G8E0L98nz5NvT8+IhJEt9Zxslpz9HU5Znwo=;
        b=Z63ki8VSgihcFACkZfyd6bk/0J4DAT18qU95Yf1MebZyAg7dYEgk7G1gSr1US4qlV2
         U6fbp8AD4lf3bo3QARlY6qs2k3qXjmzk4pjcK3uZWr/So+odi6EetcE/5WCyiDqg3XsE
         9f6xBYGoLVk7AMsgVJjnfj9ZJ/tGGig3l4NQWeM0psxsfB3rWRnilJMB8WzPRhJMJQue
         UGL1pkPnTCibGZQYePGwbsn0Pocsy2Sz+TliLrU8nfvxIggIBlQOJqDTgVoXCrJWZbgk
         /uN/XuMBaamJkyyd+8WsUUxEuMKb+vHiktrHibLJMz/GYb1UZFxgefiCxg+WvYH8tKL7
         A5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TTswPHu4G8E0L98nz5NvT8+IhJEt9Zxslpz9HU5Znwo=;
        b=4NXe+C7UP6PWQcUt9oLwGInuW7ntmA4c1wOMOQSqDXlM+Nx8skxQ/cXwQDPANac61a
         jiBOOb1zQ8uCeK7td0vvhae5dMqO197z4A4yMxK8cMn7Zy47tNYpMjDa0jAYMdNsjS+p
         gTEzbeXDfIZ5Ui0yQvzDEy84LGnb4T4cT0zx3/sSSpZflDuNatk5S0kz7pnMxv85iZF/
         LRNTW3UCbudO+3lRWoBMCrst1JNJhWJpSvl8Abq7n9e7p/VsybExn7SC2eoHPJCFepmS
         EfhlGa1YOE17vcSQiQk/ApZmV3wFpMufR8XNC6/gEfCk86nbPSy6zc5Ptw6IUDkkFsib
         OdWg==
X-Gm-Message-State: AOAM531atzw7FkFZgchgrf5hO8bB/agJ6qaaqYqUqj18GHBkjU4XUZWx
        306juQ7O5SxcBxmkUjf6krJtqIZRD/tKMpPd8V4+eGoB
X-Google-Smtp-Source: ABdhPJyX5dSvZNLaWgPn7aHtwi8ZbamsOCJqa3qStjm/pJAhgNiDyJ8E53Xbgjk7pPdX7YkC0mCS7z3Ch+QLf+sEAho=
X-Received: by 2002:a05:6512:2252:: with SMTP id i18mr1890846lfu.194.1643261140334;
 Wed, 26 Jan 2022 21:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20220125081717.1260849-1-liuhangbin@gmail.com> <20220125081717.1260849-2-liuhangbin@gmail.com>
In-Reply-To: <20220125081717.1260849-2-liuhangbin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 26 Jan 2022 21:24:37 -0800
Message-ID: <CALDO+SaXqB0ywgUHhyodpitrsxcL0jdLEsOfPmkVispezA2_Gw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/7] selftests/bpf/test_xdp_redirect_multi: use temp
 netns for testing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:17 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Use temp netns instead of hard code name for testing in case the netns
> already exists.
>
> Remove the hard code interface index when creating the veth interfaces.
> Because when the system loads some virtual interface modules, e.g. tunnels.
> the ifindex of 2 will be used and the cmd will fail.
>
> As the netns has not created if checking environment failed. Trap the
> clean up function after checking env.
>
> Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>
