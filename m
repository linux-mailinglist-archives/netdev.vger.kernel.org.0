Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2553096CA
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhA3Qfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhA3OaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:30:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD172C06174A;
        Sat, 30 Jan 2021 06:29:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s24so7278173pjp.5;
        Sat, 30 Jan 2021 06:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nkx9uFScRqctjDlwBC992ocBDlhUqlgA/eQzRKO6pEo=;
        b=np49WVh5Hdtn/4dlc9UfL4hMeh3AM37lFA867olQjLMMGUr9rc1YHeMvq2H2c6mvnb
         X/oFZtkBP7PwcirZHNoYsNtTJnjTFVevA7XXtu4arT6BAc+viA38faGtljoyKWO8XUPs
         K2CSYrR64K9hr2lIgeRER7Uu+wicIstBS5JqCucyoFx5jqrJro267wNL6fKJokDKTOEx
         vAXfHTBpgvPuwoZi/cbeie3nwhXMtDY9F9pLHIS2y0R0ve927dWvR8wNiHcjI8Ism+ek
         9ntuImRyQgg6Xpur8TntWnIpbsqSNOnl92DP8FOKzQ4lzhSBn9q46P+QeNabTFoGrOKZ
         ZzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nkx9uFScRqctjDlwBC992ocBDlhUqlgA/eQzRKO6pEo=;
        b=XLd3hj8HQ/QGvTjFv2Lc7y+UHO7YvJJmjSCkWe8GmleypEYHft1vKdn966olXraYtq
         aKesohP6xCJuusF0qjZpkM6BMzwXZLr/58mXLoiBD+GKlrSoMqvJp3z7oHtV8Nx+9o9n
         xKM4iY08AAw4qyi5nXDarB+Yqtjh90aCQJr3AMRnFtLcPYf3dcQtdHTN3SR6zct6rE5c
         RPYEfoCpQXox+SvQgBphDpnrgUu4wGrXh8qCVBwXiVAryR2jsRnzk3Zz3f+U8JSI6eGS
         ufae+WusALU2khhAVObL+Rrr5b143USoEs4gswX+uzoc8cEXsJplKeddGddprRIwCYM5
         xVkA==
X-Gm-Message-State: AOAM531CRiRVFKXZQyxE6/MmPVZTOpIghxr2H81r1wiP9zbKTSHQbRi6
        k5s22LktWMeqWICE9dS+CTjisIsMwznroNEFWgw=
X-Google-Smtp-Source: ABdhPJxlDZZVEyCnDCGicthJ0wFieV9xlRfczDlr4w8KAG+ZMB2oBh8RlCToOF3Wo8NIhR3yyxFONCet4rbUR+SrJbE=
X-Received: by 2002:a17:902:9a4a:b029:dc:435c:70ad with SMTP id
 x10-20020a1709029a4ab02900dc435c70admr10068737plv.77.1612016971407; Sat, 30
 Jan 2021 06:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de> <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 30 Jan 2021 06:29:20 -0800
Message-ID: <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 5:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I'm still struggling to wrap my head around this.
>
> Did you test your code with lockdep enabled? Which Qdisc are you using?
> You're queuing the frames back to the interface they came from - won't
> that cause locking issues?

Hmm... Thanks for bringing this to my attention. I indeed find issues
when the "noqueue" qdisc is used.

When using a qdisc other than "noqueue", when sending an skb:
"__dev_queue_xmit" will call "__dev_xmit_skb";
"__dev_xmit_skb" will call "qdisc_run_begin" to mark the beginning of
a qdisc run, and if the qdisc is already running, "qdisc_run_begin"
will fail, then "__dev_xmit_skb" will just enqueue this skb without
starting qdisc. There is no problem.

When using "noqueue" as the qdisc, when sending an skb:
"__dev_queue_xmit" will try to send this skb directly. Before it does
that, it will first check "txq->xmit_lock_owner" and will find that
the current cpu already owns the xmit lock, it will then print a
warning message "Dead loop on virtual device ..." and drop the skb.

A solution can be queuing the outgoing L2 frames in this driver first,
and then using a tasklet to send them to the qdisc TX queue.

Thanks! I'll make changes to fix this.
