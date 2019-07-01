Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70D65BD49
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfGANvM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jul 2019 09:51:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32874 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfGANvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 09:51:12 -0400
Received: by mail-lj1-f195.google.com with SMTP id h10so13296552ljg.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 06:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RUkQ1p+oYMFsbNOv3BrbEawl9u1j7dcZAIuDmtA+aH8=;
        b=kqqCcllS4xKa4ciF/c4XVFq8Kh1dkLmh3ldvdQ6hLLtusjMItrlqsKrSby2tIQTPi3
         9JeJagOQnEcFaLqEqqoWRZKqTr2eZ0V5vEnQc/EIld8wZOUmtUSOfrcXfOjWGnFYnhrf
         +syrSoo6hOMXrhfQrouAOR8AtIwJ283lzQRMFatiIorJjXle/DjKOHJ4rPIDdTaTvnco
         vv3Kv/Qeq73fpaMWAgF3dIJZrIDPYXQBkz3sB1P1Mt6J8wKwn/nIid6tFu5xfcdoOuf1
         9zOOtvrXYVeFgbnIk8/9SCdgvdyNPg9/Q14z7dRfitXYFKotL9zmYduNmF3tbOHBTbXi
         aMiA==
X-Gm-Message-State: APjAAAXPD3pfTmtIVQ201yt3X3CSJlCzCtfiZvlFsAmhmJlireVitVJR
        wdHUDxWz1UP3AHz0BcNsbFebZNjeU/TNlqbzKLNCSz+Q
X-Google-Smtp-Source: APXvYqyNrtNaOtgrooLs9XK7GL/b/N4p3AfJWiVtM+m37BjPtz1+RaWEmtUPgVUh+A3E22yAw1EO6itIR0yO7sSpP0E=
X-Received: by 2002:a2e:9117:: with SMTP id m23mr861741ljg.134.1561989070102;
 Mon, 01 Jul 2019 06:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190630192933.30743-1-mcroce@redhat.com> <e2173091-1c7a-fd74-95ea-41eedbab92d3@6wind.com>
In-Reply-To: <e2173091-1c7a-fd74-95ea-41eedbab92d3@6wind.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 1 Jul 2019 15:50:34 +0200
Message-ID: <CAGnkfhz92SA7_kbARMzTqj3sTE3pgE=FEOXzFQxX6m=cemJUkg@mail.gmail.com>
Subject: Re: [RFC iproute2] netns: add mounting state file for each netns
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Aring <aring@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 2:38 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 30/06/2019 à 21:29, Matteo Croce a écrit :
> > When ip creates a netns, there is a small time interval between the
> > placeholder file creation in NETNS_RUN_DIR and the bind mount from /proc.
> >
> > Add a temporary file named .mounting-$netns which gets deleted after the
> > bind mount, so watching for delete event matching the .mounting-* name
> > will notify watchers only after the bind mount has been done.
> Probably a naive question, but why creating those '.mounting-$netns' files in
> the directory where netns are stored? Why not another directory, something like
> /var/run/netns-monitor/?
>
>
> Regards,
> Nicolas

Yes, would work too. But ideally I'd wait for the mount inotify notifications.

-- 
Matteo Croce
per aspera ad upstream
