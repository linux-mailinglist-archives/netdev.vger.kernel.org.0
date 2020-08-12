Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670712425DE
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 09:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHLHNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 03:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLHNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 03:13:38 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790D8C06174A
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 00:13:38 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id o21so942507oie.12
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 00:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=wj4Ax4hjDfmuJTrGRf1kEOPON3vh6GEwaa/o7TlxCss=;
        b=u7gKR4Uh61t+Lh6JPAuLIEKr85iYihwPdNqt9S2dN9VHYBzgaLoAon05sa92zzz6+/
         +O7Qm1FSMotm6bCbLTpZ9kb/Cv71JACLcRDM9TsH5HyCaK8bIZ5zwIvX6egHayv6l3BD
         2tJ3S+zxxJlmvi2Ql3we4/EZzbE5sYJgsTArXwuvzjVVVnWfcyKYQwfBqE+ZJBRLvI/Q
         n3egStI4Cr6qpKFQSLcaze+36+Gp6yh7d29PhLHc6fkScwLHQP9le5oC0W8OULUc6yzP
         22CzvM1mzseD1hBjOoCWhN+MGiiJ+shIcktpDo3LQ0GLjWAHGSu3GoPu70YwZv/T6q/4
         kdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=wj4Ax4hjDfmuJTrGRf1kEOPON3vh6GEwaa/o7TlxCss=;
        b=FtspdeExzLv2lwPjUE9+6MZIagUc/7EjcY0m2+nfNbG3CnV46j9jXmUBwszVBF8BUW
         ya7byEoZFU3uDI0cExfYV5sjHvt0QBzNz0qnlxUNxFjz6cha5+YIbPUZjSZbVQWJ48Yf
         JCxcHIN6bNv5QWFnliPISW53fNRnR4Asxh3cQItDs9iJ6KOX1tF4jEcUR6/2Rv7wpVRz
         aPgf5Tf7x4v6+SgTFeUu+hD4fakPypeGSPjL1g6YYuvvTVQ8FNePHvVGBCUYwn05b3xB
         Ya3QyZ3204Dv+Er2vbfk0GHE0CLywEq7xiAis1jwpcsjMt1Svr78SDHyVJXVVT2750HP
         3qww==
X-Gm-Message-State: AOAM530DlT8alFM6UUMbOgEFZjTedJU654MWv025MnL114gQYl8Rh8tX
        pRc/3iD9dkbeNfUIGziQOWtkw+c00OIE7b2S82XfaTq6JZ8=
X-Google-Smtp-Source: ABdhPJwgeAyEykD0QyR908cTn4zDI1hm8zA33ofHwZGsNDwdQjaAmwiEQdVeLerD4tk4QI9BPwsAbqSDtpWuMmYpGmU=
X-Received: by 2002:aca:4e92:: with SMTP id c140mr6085654oib.70.1597216417938;
 Wed, 12 Aug 2020 00:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <CA+icZUVNt4H5Tm2wTxq-7nS9w3nn7PKVQ=8CW-egyTJqTzUWZQ@mail.gmail.com>
In-Reply-To: <CA+icZUVNt4H5Tm2wTxq-7nS9w3nn7PKVQ=8CW-egyTJqTzUWZQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 12 Aug 2020 09:13:26 +0200
Message-ID: <CA+icZUVa2wuWB-Mk0FW=1GX27ai2mk74aTnF8b1eRcRbXJwDUg@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 8:35 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> [ INSTRUCTIONS ]
>
> echo 1 > /proc/sys/kernel/sched_schedstats
> echo prandom_u32 >> /sys/kernel/debug/tracing/set_event
> echo traceon > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> echo 1 > /sys/kernel/debug/tracing/events/enable
>
> /home/dileks/bin/perf record -e random:prandom_u32 -a -g -- sleep 10
>
> That gives me now some perf data.
>

I perf-probed for tcp_v4_connect:

/home/dileks/bin/perf probe --add tcp_v4_connect

/home/dileks/bin/perf list | grep probe:
  probe:tcp_v4_connect                               [Tracepoint event]

/home/dileks/bin/perf record -e probe:tcp_v4_connect -a -g -- sleep 10

/home/dileks/bin/perf record -e
probe:tcp_v4_connect,random:prandom_u32 -a -g -- sleep 10

/home/dileks/bin/perf report --stdio

- Sedat -
