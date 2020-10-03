Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940A5282260
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgJCIEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJCIEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:04:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309F3C0613D0;
        Sat,  3 Oct 2020 01:04:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e2so3955999wme.1;
        Sat, 03 Oct 2020 01:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uERDiUyRuB9/cXeVySNK9NZF5n/XIJzp+wEEQOJF6iM=;
        b=hiKi1GcGeqeFgFCCzgDiqEJETCZJ0/6Wt6USUGHUst7o+f8wiOabKrnvPhp8yRMnxk
         C7SDqzX6EALmOofalx3EM2ueGcTXCe9WcqsWu/CUQPmuBogQykxd9AA591jzpsrWH+wd
         JkmnsH92UFPMHJtZOHmLvRFu2FNZVnU0xUknOmYgleH2Iwc98i8ZJnBVGRIgqOMehWzR
         UUwcxvWkWSQNPWrpvlVC/n3ohdMNpZYDrNigg0ubA2/3I91RDMm0FStzUWOnwDDLmWdj
         ZRRIJJWqzaE0owgXUThdy1iSl0UO4HEQQCr3A/6RXGemcfAKH5JaO6tXyc4BSjZHPp6l
         cFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uERDiUyRuB9/cXeVySNK9NZF5n/XIJzp+wEEQOJF6iM=;
        b=VUUt1W3cXAz08EvaW+nhjkgMV0cCFPTVLXIssPyworOux0sM5L5pRXtPEWyskpbCO+
         LtODThYQ5YM6Op/pktWmLBsw0wowhPA4AUPzDdR9+b26bE/MQew+BysQTtULDioZOwcM
         6Uv3BRza2p8b/3+iLqedBEQIi9Wn/OHqRuDVWxDc6YgapMzJVqoF7Q4muBtxLI2nqIet
         GWUYiRyWAeqt+l2fCS9UWPSTe/3uelEUbR7p6W3HCFnj4s99Fe6KMaGriAJsTUFy+FZL
         xsXKCNSTsvAUBXZxMLckUWJWvA3XuvFYEbfq+wWYfZ20rpeIr2LULN4a1bV5Zby5iJja
         WhGw==
X-Gm-Message-State: AOAM530yWg2lIZhrBIzgjujPt4KmmBKBwGkpHO16x2DJxvyHoEEbXCWK
        MPEO7TQtV+YC1PNVarrGTKd4LMANXfKHDXveZjRarYMwqR8=
X-Google-Smtp-Source: ABdhPJzG2umMi+blVZTV6zKXzBYYQdh1RC4KVltpBbCMJUl4t/c+j+xPTsnrwNHI+LdV0lNu392sBkJfkgzKCv8YtAY=
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr6570045wma.111.1601712290948;
 Sat, 03 Oct 2020 01:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <780b235b6b4446f77cfcf167ba797ce1ae507cf1.1601387231.git.lucien.xin@gmail.com>
 <20201003041217.GI70998@localhost.localdomain>
In-Reply-To: <20201003041217.GI70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 16:20:17 +0800
Message-ID: <CADvbK_cS1Zz3iraOy1gbU0=f3TxGAUqo_etabFkm=x7tazEBQA@mail.gmail.com>
Subject: Re: [PATCH net-next 15/15] sctp: enable udp tunneling socks
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:12 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:07PM +0800, Xin Long wrote:
> > This patch is to enable udp tunneling socks by calling
> > sctp_udp_sock_start() in sctp_ctrlsock_init(), and
> > sctp_udp_sock_stop() in sctp_ctrlsock_exit().
> >
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.
> >
> > Wit this patch, the whole sctp over udp feature can be
>   With
>
> > enabled and used.
> ...
> > @@ -1466,6 +1466,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
> >       if (status)
> >               pr_err("Failed to initialize the SCTP control sock\n");
> >
> > +     status = sctp_udp_sock_start(net);
>
> This can be masking the previous error.
right, will add more logs in sctp_udp_sock_start().

>
> > +     if (status)
> > +             pr_err("Failed to initialize the SCTP udp tunneling sock\n");
>                                                  SCTP UDP
>
> > +
> >       return status;
> >  }
> >
>
> This is the last comment I had.
> Thanks Xin! Nice patches.
Thanks for checking so carefully!
