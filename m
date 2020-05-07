Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B581C8D21
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGN6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgEGN6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 09:58:49 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47FCC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 06:58:47 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id p5so1643272vke.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8uA/76nadpV0n48ft4J9yLac2K2FRVkb2Mza3nvzUg=;
        b=k1IXCCD6gwOb9/zG8+an07w7jiYj0aQw60c/HzXzi+stYofZck4z1cU+2a/wHp6S0v
         Tr9MkNPKc25284f3xq828G2gnzHOlwSVZEh8WQHjvUxjMywiKOalXNRQakg+DdLEf7Vg
         wTqdMLRiI7MF0mdm/3zzXb8EDZSY6opYAihyY1zJHZIQLUhhYF9fUs2LQdRTOPu3njQN
         jXQkZi42bH6tv3rJ4BdDlvUr+I9OM3EysNTgBYQesLyuzdKuDEfZ3CzLiRcdM1cj5AKY
         SOZMm9uJJYdMLXNNnbxqyH8LP9zA5FpIytCXtbZSFLxX7udG6kwjWxeVuolWD9tlHAdS
         M8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8uA/76nadpV0n48ft4J9yLac2K2FRVkb2Mza3nvzUg=;
        b=OkN0W9KlIwVjFaKA4n5m7wXhZU5Ie7x1NGLzl8yTMIDg4hcMYNMegG6dmYd3o8p5n2
         SQhbSSGx6cypeuBVDx0umstIqBtsyyNqkLvHUWOg8imiF9H4bYVBe0H+ZQk6SWoT4x+t
         G8jb8Q+0x8Ed5UHOWrYEXEXaO6/yHTS+HXpvktUN1m1jxQ+nwzWIeB09P5oTZWA3bLEL
         NGOdI1UXIY4ujWfTNEHaQVhFZAHYtrZDoyHMK0CD/jgNjhdAje+38GOAZ0gcIzYtvB1b
         zwr29ezMmnnf86ektHdJnN3yln1lYNmWdCfwvy6Bbg/0ByBC0y4cfIUl1NnRyW1w8lQd
         0zlw==
X-Gm-Message-State: AGi0PuYLd7zoMx/eqV+3tn3pdSwDmhf6l9+mgrCxHLrwZqqNrz6XWJaK
        PlA+85bd2dSx2JSMp8cmjzp7H8SQrTMBmMkZ2DnUaw==
X-Google-Smtp-Source: APiQypIVMdFFosBKgh9kPxEDx0LR9JFOui3me6wN/Kd42lIjdVbhfKEzg5i2MNps+tviQkkMfhcLiY0icQBRD7TpS3w=
X-Received: by 2002:a1f:9a93:: with SMTP id c141mr11495460vke.4.1588859926782;
 Thu, 07 May 2020 06:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200507030830.GA8611@toolchain>
In-Reply-To: <20200507030830.GA8611@toolchain>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 7 May 2020 09:58:30 -0400
Message-ID: <CADVnQym+O5tgCyRO+MJopXzwcxsGGkCpTpdX648fTsAjMZO3Gw@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_mark_head_lost is only valid for sack-tcp
To:     zhang kai <zhangkaiheb@126.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 11:09 PM zhang kai <zhangkaiheb@126.com> wrote:
>
> so tcp_is_sack/reno checks are removed from tcp_mark_head_lost.
>
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---

Nice clean-up, thanks.

Acked-by: Neal Cardwell <ncardwell@google.com>

As Eric noted in previous threads, this clean-up is now possible after:

6ac06ecd3a5d1dd1aaea5c2a8f6d6e4c81d5de6a ("tcp: simpler NewReno implementation")

As Yuchung noted, the tcp_mark_head_lost() function is not used today
when RACK is enabled (which is by
default).

neal
