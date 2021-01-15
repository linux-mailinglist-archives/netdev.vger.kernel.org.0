Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834D72F88BE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbhAOWqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbhAOWqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 17:46:52 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC1C061793;
        Fri, 15 Jan 2021 14:46:11 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id d203so11241694oia.0;
        Fri, 15 Jan 2021 14:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfgrriKpVh6hOL3sjDbmVTYMk8KNWaVy1vDDkNVhF1s=;
        b=l/dB/BAU06xQUdTpbcYVfukPz8qLKOVv8aw+PGwsYCCEL+/p0MzAncB3pSohMiKC/0
         8ADHh0QLD+jrCivEANX8rsjWE3LWWQ+0TLn5ijmGsCq64g7OZyb2Hwd7lzKepgya0Czy
         BqlNIjYi8LAuMbyorUItThkTPt0FtpDW1AWjS0yLxgzZAnKYSW74l5P2Wuu14wNOw35z
         XH1aOONPtqQbVqWWO4UwJm7fN4R7cphiPW+/ukH/b1x0nCJdJlwukWAZUTi6Xa9BREoa
         TCPPMLtAsrdnEEaazZXiFKYp+vw0GdxFS2mb4TgWx4Q/k/CtUkBla9FT5s+6pHkoUJxQ
         gTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfgrriKpVh6hOL3sjDbmVTYMk8KNWaVy1vDDkNVhF1s=;
        b=Wzu2UICkZfodgC0fs8IiI98IcBYyvuIoUyBo6tCIDR91d5jVjDf+3UJZxsPOrncZJw
         RNyEeZPI5vulgNZ/oa59VYn9s57KoN/LOWBrtRltSV7+k38wAYXNdWI0HGNB1zy/qjXX
         ibcnjQeILURFpHlvcg8DHKaz/oNtU8/8szr9D5cDXXQ+UOZIaUHnY6OL+kKCNdy6RdKd
         HAaRebN/xLW75cLmY1CW36+zcUJoDSECDBW+SI0PE2AFbsSLRyDPA2pmFfXf6hDFjd5v
         /DA1T/WCZ6gbhcP3V7sPimlJ62P3IMAAtSoyQvw6Pvns6H/AtEfdreBgFxYI+Ck63/nY
         PEiw==
X-Gm-Message-State: AOAM533RmjaRNPiGsBB3fypngGO7G3kDd3yE+2NbuaHru7BcOhaBwKyn
        G3FqMWAWz98QCIBQW5y+oPyDzjGjyzetRM9j3wEcLhFuCOI=
X-Google-Smtp-Source: ABdhPJxxGiDHQZLR7ZVMRXijvgsYniTE62FoeWN0IpUP2zUsZ4h9D9yygZ5ez1wn66g6xuJ0VXRP98lLDAYm1jwV8qc=
X-Received: by 2002:aca:5d42:: with SMTP id r63mr7123864oib.94.1610750771280;
 Fri, 15 Jan 2021 14:46:11 -0800 (PST)
MIME-Version: 1.0
References: <CAFSh4UwMr7t+R9mWUCjdecadJL6=_7jdgagAQK6Y1Yj0+Eu0sg@mail.gmail.com>
 <CAFSh4UwAmR+sdfbdyxHRDnDr8r+TXxo2bvWtY3gmLAJekWc3Sw@mail.gmail.com>
 <CAFSh4Uwsj5GfPRUe+oT8h=DBxHppqbE-zsDV8-J5rTK3-xyZFQ@mail.gmail.com>
 <CAADnVQ+tfm-k1Pz3bGm9oVJzayMgg=prenqhqrPfm3QnaCqL7Q@mail.gmail.com> <CANn89iL87E65sYSP0JTa8_WmKsOySM1NQqxg0Ot8+ggZ73F+vg@mail.gmail.com>
In-Reply-To: <CANn89iL87E65sYSP0JTa8_WmKsOySM1NQqxg0Ot8+ggZ73F+vg@mail.gmail.com>
From:   Tom Cook <tom.k.cook@gmail.com>
Date:   Fri, 15 Jan 2021 22:45:59 +0000
Message-ID: <CAFSh4UzG=WpnLr5ZYCK16t3M22HV9gf-UuvM4Un+8sQBm2uSVw@mail.gmail.com>
Subject: Re: cBPF socket filters failing - inexplicably?
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 2:16 PM Eric Dumazet <edumazet@google.com> wrote:
[snip]
> > My wild guess is that as soon as socket got created:
> > socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
> > the packets were already queued to it.
> > So later setsockopt() is too late to filter.
> >
> > Eric, thoughts?
>
> Exactly, this is what happens.

I understand.  Thanks for the explanation.

> I do not know how tcpdump and other programs deal with this.
>
> Maybe by setting a small buffer size, or draining the queue.

libpcap has its own cBPF implementation which it applies after it
receives the packets from the queue.

Thanks again,
Tom Cook
