Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BAC2611FA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgIHNXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgIHLRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:17:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98DDC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:17:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g128so16556566iof.11
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 04:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Ls8MD+s0SAyoat96swxy8yotuWKIXDkuvC5773f1YA=;
        b=tAIqmQHPFfxX9t+hzQCz5xiubYqUVXJXmPLzSyr3u2Uf3RxaN2F5GOCAdKe8v76rvi
         67Y6eURVyGk4ILh6HT/7oGQBwsdASGDSsnIHA9GZyII71NOxf0t0IYSob5yVrOfl9Vin
         XOCEhpCg+kelH2L9b35EBH+gIf6p4uEVEFahD3nQZlK90xsv9gpOn3+WI9yWoOg+ZCf5
         8BnjoskhVriWZRNyQ72YUjloZjOk8JDWcaijF0S+Y4RkjYaLcGpnGzwcK4bAc5iR0DB9
         kmwT3yNiV2g2mhMffDxlwOD1LrswVffIOpvc+7sy1suo2/NHu5+WzFAOsauZ8eoxQ3ZT
         HAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Ls8MD+s0SAyoat96swxy8yotuWKIXDkuvC5773f1YA=;
        b=QCvH4cpEeozrtskQvX3v23QJrO8jvGy4h6jsOZRF/eSm7mS4gM1q4uvdWY33fts+1Y
         5kFYUuOvNJnMzrWkDd6OvyKv2K2j/AMTTFY99zZW/129+rdpacqRk520/dyS7C83qMI1
         nv3+K1oo2pYHzI0aLP3Lx+nMv6r/Hsz/nVScArCyIAfIcAgfEf0VQNVT+UMEjnc0dwNq
         IDf+Dg90XA/dg3W1dWMgF6jEHzirrcspyZh+P+QfcsjKqJDYltPPkAjuJTb8GPt+xBeu
         iBMB3CYc7/kWHlT/WTkePAf54JDkAx1PTZmuExv/UV6ts1Ojr57e9QkpZKAeBXBDbaUf
         g+yg==
X-Gm-Message-State: AOAM533CKKSigWqX1KEib8e/5ZKmOz3V/744UvQE6wO8s03QuUBTjrCF
        Jgj8VY0SwE5CheR2zKB2AFP4ajsRdq4jS0/0/NWvJwxZyI4=
X-Google-Smtp-Source: ABdhPJzX/d2H5inV7mmGARZqBb4inRhgnwSRdgj6uad3jLX+bsAMTNc+R4hnP9xz/PtEJRGtyGJ8SY+8AJeOs0MezV0=
X-Received: by 2002:a02:cd2e:: with SMTP id h14mr24075004jaq.6.1599563872927;
 Tue, 08 Sep 2020 04:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200903140714.1781654-1-yyd@google.com> <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
 <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com>
 <20200907212542.rnwzu3cn24uewyk4@lion.mk-sys.cz> <CANn89iKyES49xnuQWDmAbg1gqkrzcoQvMfXD02GEhc2HBZ25GA@mail.gmail.com>
 <20200908103723.e4klmj5u6hvh6s4d@lion.mk-sys.cz>
In-Reply-To: <20200908103723.e4klmj5u6hvh6s4d@lion.mk-sys.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Sep 2020 13:17:41 +0200
Message-ID: <CANn89iJ=5jXz8RxXx1qtVaaoibU+Rr-qvkH8f89N6gtxBoh84A@mail.gmail.com>
Subject: Re: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:37 PM Michal Kubecek <mkubecek@suse.cz> wrote:

>
> All this sounds as if the actual reason why you want this in ethtool -
> and implemented using existing ioctl - were to provide a workaround for
> your internal company processes which make it way harder to add a small
> utility than to embed essentially the same code into another which has
> been approved already. I understand that company processes sometimes
> work like that (we have a customer who once asked us to patch kernel for
> something that could be easily achieved by setting one sysctl on boot
> becuse it was easier for them to deploy an updated kernel than to edit
> a config file in their image) but I don't think this is a convincing
> argument for upstream code inclusion.
>

OK, we will carry this internally then.

We are not going to fight against some trivial change.
