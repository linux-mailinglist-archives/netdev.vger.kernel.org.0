Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0855E79C3
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfJ1UNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:13:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38130 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfJ1UNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:13:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id c13so7667461pfp.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 13:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pt5I/I5h4Wv/bTOiFA1nQtOPc9xtCs00uVzh+0NgzFo=;
        b=ORAUPDn0xqRHNPv7q/t/fryPMDka1e4usg7Czof7TITqS0SUWWFnlRS5GhR53lt4Hq
         OoHEKDl/jAjRpNRPsKhQ2oWH9jJkbt6krVGjMsqvQp/XmLaiqUvFNzJNKjHCNT0/R/Qr
         4gD3WNhbNKoI0lPnKNlzSGkRCQ8AAH2Neo+om9c0CR8TIz7wStVz9qJBn+jetbr/44qY
         vyTkXNssseO9+wzI0QrAElgsvSVk8COtVdp9Tl5WFyzDGZndTCnmqG0gBlQzFXxMgnxW
         0t48nyVXHVTJ683vh7XN210EOakYc8pASG6X+K2teT8YHOQOzf4sXt4X4BWCUDOKaiWF
         4IDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pt5I/I5h4Wv/bTOiFA1nQtOPc9xtCs00uVzh+0NgzFo=;
        b=STeb0UDEgGxK6O8hGPp4QFvrFoswulNQ+1VA+p+5rkHfCVYtobo7oxbzwBYX+3ZjD+
         24jO+G2NsuJHRZMuEmCe7mGU32KieMGx8mJcC2mQqPKtXqZzgEXBMbdulRo1f9tENxqo
         EFEdsB43gQVana0iGc5D7wWYv0NDzb4mRs6Dr46Zp95wbPVrDHXjGvO7pw8QJcWdq1gd
         p0W1zBQovy4OXiz15zeRnZyg4AInJr9zpWVUqvNQohNVHQ3vj92O6sHIr248RcqyCsyy
         abYpb216RPAq2t1HUV8l1jhGo7heuDVUfv4fEZJfFWgSJbWQBbNhBCXcru97YfgrzAU3
         sYBQ==
X-Gm-Message-State: APjAAAXxvtLGkXIDxwpY7LGmtqcYYT1/L8St1nMAkdSfvYeEQZqFo/cK
        7CYcuPfKACN0fVu+0tFvhri8Xg5UFWcWmssDgRruZxna
X-Google-Smtp-Source: APXvYqxSH1MGg5UCal6TDerPycgPwUEYqiXvQJY0eoqVWuYoTecCmSdGyUWULIYdvWT66dKFhSfB/nOL9b3neYVUPdA=
X-Received: by 2002:a17:90a:c48:: with SMTP id u8mr1499261pje.16.1572293598080;
 Mon, 28 Oct 2019 13:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191028.112904.824821320861730754.davem@davemloft.net> <CANn89iKeB9+6xAyjQUZvtX3ioLNs3sBwCDq0QxmYEy5X_nF+LA@mail.gmail.com>
In-Reply-To: <CANn89iKeB9+6xAyjQUZvtX3ioLNs3sBwCDq0QxmYEy5X_nF+LA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 28 Oct 2019 13:13:06 -0700
Message-ID: <CAM_iQpU1oG8J9Nf-nZoZDf3wO9c4dHAaa0=HK0X-QMeHMtmrCQ@mail.gmail.com>
Subject: Re: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 11:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Oct 28, 2019 at 11:29 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > Date: Tue, 22 Oct 2019 16:10:48 -0700
> >
> > > This patchset contains 3 patches: patch 1 is a cleanup,
> > > patch 2 is a small change preparing for patch 3, patch 3 is the
> > > one does the actual change. Please find details in each of them.
> >
> > Eric, have you had a chance to test this on a system with
> > suitable CPU arity?
>
> Yes, and I confirm I could not repro the issues at all.
>
> I got a 100Gbit NIC, trying to increase the pressure a bit, and
> driving this NIC at line rate was only using 2% of my 96 cpus host,
> no spinlock contention of any sort.

Please let me know if there is anything else I can provide to help
you to make the decision.

All I can say so far is this only happens on our hosts with 128
AMD CPU's. I don't see anything here related to AMD, so I think
only the number of CPU's (vs. number of TX queues?) matters.

Thanks.
