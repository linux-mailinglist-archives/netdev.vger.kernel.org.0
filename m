Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75108383993
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbhEQQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344054AbhEQQYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 12:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C05F6108D;
        Mon, 17 May 2021 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621268573;
        bh=j9ObgA0Uk0FJTFckH7PgM4hmZSrWR4u/1ilgsCcRn7E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rd50zs6A4bzYGrtxcIExxHzwdZq86wjzG7l67Y8zn5Kr2Uj9KUwjMmFb5DXxrShkH
         +Bq9tPNQoAQeBNQD4UpOyNm9z8nQgXgsYljNyatn+WoUUEczg3FbsMAT6EZ//6340z
         d7e05eOMQ85m9y/cQc3MLtSO8Omn/CToHGOPj3kjWXkuCPd7jkEjZU5QMTLE3DoD7s
         GXNizNqk6Kz8FyLNEG8okPJeKeKBQF0ObzFKv3sSBO2rHeq7h/2aYZZ3oMFxc8vDt+
         UROqgJM2PNZmg7EvXIELTAgdhHQByIW3vwoAxrmeEaGdUMts+oVXvdtMU62Wa+fhLi
         zBkkMff6WzXTA==
Received: by mail-lf1-f48.google.com with SMTP id v9so8338978lfa.4;
        Mon, 17 May 2021 09:22:53 -0700 (PDT)
X-Gm-Message-State: AOAM533hrl3+VHtzhhG0RLEjmtUWfOamhp6PQCHx5cIo/TQm2f8j9wEb
        ixdoOeEmYDFT/EIpod3X/UZEqrlCbRdMD7De3+o=
X-Google-Smtp-Source: ABdhPJyRdS1gs0WUYWGUfuCZ2HnZE1eV0GPJnEiXBDTZQ6cloD1OCWxdAQ5Q0NmBUOeiUVO5+fX71WNPFVAbewJp9u8=
X-Received: by 2002:ac2:52b6:: with SMTP id r22mr476382lfm.261.1621268571928;
 Mon, 17 May 2021 09:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 17 May 2021 09:22:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5XVnaL98Qnxtqa1yY4JWW5SSiC+VXXMidKC99JCdjD7A@mail.gmail.com>
Message-ID: <CAPhsuW5XVnaL98Qnxtqa1yY4JWW5SSiC+VXXMidKC99JCdjD7A@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 8:33 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> sk_psock_verdict_recv() clones the skb and uses the clone
> afterward, so udp_read_sock() should free the original skb after
> done using it.
>
> Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Acked-by: Song Liu <song@kernel.org>
