Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380C061F6E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbfGHNRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:17:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39401 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfGHNRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:17:49 -0400
Received: by mail-qk1-f193.google.com with SMTP id w190so695423qkc.6;
        Mon, 08 Jul 2019 06:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+wz0H7gl6Q8zjC86ZgnxBevLyGHVnIvyQ3olnsvn8E=;
        b=fjJxDPyFBybE513GphmBzJNiI70XekMgiG/AZaGOdL0cgXs2PZE+gyW0OE9tAmh8AJ
         ryieVUBI2sqF1yUC+uF5doJF+ycYQpGL7ntNuJIUMn04R2OQpY9wtgU4duXuKnduqjWy
         JwjccKHArKxO+ypso89Mo9XBAc+iP8rnrqtN2lrA5/sYhtPXWGlln8n6t43PMOTlNPNB
         n/sGC8LpQMXqCiOjrHinmb+xWGqtwJUrWjklnP/RTR41UMJbJXjAZnAvJKGHCBaNy0sz
         djrXbmqc0d3szCj3kFyiFRV/qZU9gSsA5J75KqnIo6ACnaR5+cL9y4wUI5z8HTNkDEOh
         9yjA==
X-Gm-Message-State: APjAAAWMRiibaw4/lMS2fYmR2VspnE5h/W4qWmox53fsM9cIyciLmHvd
        4+GdZ7oooKi/yNmcrwiyQLV63+wKgQuidGpAkqw=
X-Google-Smtp-Source: APXvYqyIS1Sjxxl24XUtXEUwisidsyy4+zyUtieDs6+t7pHB0J8zaYr1exFbHgLoYk5Qry+Zjrak17QcUlXg0jtwXFc=
X-Received: by 2002:a37:5f45:: with SMTP id t66mr14271104qkb.286.1562591868590;
 Mon, 08 Jul 2019 06:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190708124547.3515538-1-arnd@arndb.de> <20190708130010.pnxlzi5vptuyppxz@treble>
In-Reply-To: <20190708130010.pnxlzi5vptuyppxz@treble>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 8 Jul 2019 15:17:31 +0200
Message-ID: <CAK8P3a0NggP8KbETOfXqoNfu6Gc13QTT+ME3SbK14nWaTWXvCg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Revert "bpf: Fix ORC unwinding in non-JIT BPF code"
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:11 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Mon, Jul 08, 2019 at 02:45:23PM +0200, Arnd Bergmann wrote:
> > Apparently this was a bit premature, at least I still get this
> > warning with gcc-8.1:
> >
> > kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x44d2: sibling call from callable instruction with modified stack frame
> >
> > This reverts commit b22cf36c189f31883ad0238a69ccf82aa1f3b16b.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Yes, I have been working on a fix.
>
> The impact is that ORC unwinding is broken in this function for
> CONFIG_RETPOLINE=n.
>
> I don't think we want to revert this patch though, because that will
> broaden the impact to the CONFIG_RETPOLINE=y case.  Anyway I hope to
> have fixes soon.

Ok, sounds good. Thanks,

     Arnd
