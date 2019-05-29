Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9712DC09
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfE2LjY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 07:39:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42493 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfE2LjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 07:39:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so2039640qtk.9;
        Wed, 29 May 2019 04:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9E0nYfWPs7a74TGtkChwlvLkwZ7IjxPSqPdyj4RozG4=;
        b=n26CHIk0NmWec02CC2UJ6i3wzRBHUn5ezO0tG03QsrOvuXQdIUA4KAjnDIWClphj/Q
         Pjkcji9kBdzzT4tznmGCx4bjzJJMjEyrtu3G6MgdbWevwJaNL2uePHx4C19V6jTEMLCF
         ZveNdZ1naTCrav2uUXT1X9siMhuUKRUp8wbDz+SNV/eb+eUB0wsLUNlAKdEt8Lme3iJN
         OyrdWCVz3m/VSp/R6mtGn5O8GHCEM/587Ge9/BeqEQtQMjY9G7ztwOJtgAioi7+g8Z06
         5KNvoo8JjSePzcaglPn11sUfSEXp4AoYuOJALtgg7r5STPkNzB2HnsFjJxtrBNfdhS5+
         HR3A==
X-Gm-Message-State: APjAAAVz18j43/zAYFqxbVBC60xmTbSH6QJCrZ8B0TPzCraG7NERxXOq
        tnU9FU1VljjyW4cpM3bxf2SWf4D3lPh5xlYRkE0=
X-Google-Smtp-Source: APXvYqz0EPhnldcISbzSfPUtTKsPXrltcC2TURmwXZayJpn/3MgULMOLoAS863/SSr+U9BaN4sQZRsVuLkMYuNUzw/c=
X-Received: by 2002:ac8:2433:: with SMTP id c48mr87599176qtc.18.1559129962985;
 Wed, 29 May 2019 04:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190528142424.19626-1-geert@linux-m68k.org> <20190528142424.19626-4-geert@linux-m68k.org>
In-Reply-To: <20190528142424.19626-4-geert@linux-m68k.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 29 May 2019 13:39:06 +0200
Message-ID: <CAK8P3a3yPBOfw+GhTXGXZzr3wdz1yA3kKZGqqWYnW6+TzXm_PQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] net: sched: pie: Use ULL suffix for 64-bit constant
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 4:24 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> With gcc 4.1, when compiling for a 32-bit platform:
>
>     net/sched/sch_pie.c: In function ‘drop_early’:
>     net/sched/sch_pie.c:116: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:138: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:144: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:147: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c: In function ‘pie_qdisc_enqueue’:
>     net/sched/sch_pie.c:173: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c: In function ‘calculate_probability’:
>     net/sched/sch_pie.c:371: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:372: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:377: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:382: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:397: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:398: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:399: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:407: warning: integer constant is too large for ‘long’ type
>     net/sched/sch_pie.c:414: warning: integer constant is too large for ‘long’ type
>
> Fix this by adding the missing "ULL" suffix.
>
> Fixes: 3f7ae5f3dc5295ac ("net: sched: pie: add more cases to auto-tune alpha and beta")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

I created patches for all instances of this issue at some point in the past,
but did not send those as we raised the minimum compiler version to one
that handles this in the expected way without a warning.

Maybe you can just ignore these as well?

      Arnd
