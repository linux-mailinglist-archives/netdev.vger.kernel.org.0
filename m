Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99FB48BBD
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFQSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:16:24 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42382 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfFQSQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:16:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so10245616lje.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3KbGZcl0Gi0jNy9coPKcSJr5heE7ZQLRdeNj3JGzwpA=;
        b=T15jTJllZ2uRduB3YrgRGX6wMT+z9NIUkv1VPJmC8yz0PENs8is1UxhM80bHpn8Wjc
         LHml4nVfexaFPrpvousJxFP6ZKHWn6WTtjuwP5+9yj+P/JOWZf04CZCjP8YosgpSq8m6
         YDg70VW3sT3LWCqjEU3XU9676uzdpl6cv7EhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3KbGZcl0Gi0jNy9coPKcSJr5heE7ZQLRdeNj3JGzwpA=;
        b=pmA+yGfdTuVI562lD7o87/SEFFIhOiO6/k4jBCncpBQoTVnxDjOMaQRpHnJ6/zxOTp
         QYIGyWnCCqu4X7DEtca4172+dfU/kuWuJCCzQnEHr/rWSxgcJcZZ2/NNW3A7+3Yws/6C
         Sin2dpHAdP7ys5/Qtt9ekwgss4IQ51LE6cOjXhjkAo+1InCALhmGnGhswytByUBnxlVf
         sAaujtQWXv4CNPctnaU6qt0ILWJfX0O96TfseHlPjXlXrM7qFDlactmMQPeJNOwXl4aK
         UmUrD+yNmYlV8WHTgyEKuOnVyLpQgqNzBhm+VtKUS5grBDBegN97L9Cs2dy6mVdcOUze
         /b/g==
X-Gm-Message-State: APjAAAWIZd31vgxXm1gGzGqMaTg8s4NXqC/rRTgYTkOX21yZi2sLx627
        HpDpN1wnyKUkv/P3OJcbeA755B6M6aE=
X-Google-Smtp-Source: APXvYqwWD4cErJDWjvNSNO0emxGCADhMm30NRF7oWCQOFB18t9qArnZGXRSJJM21BIhTnpLScnVC3g==
X-Received: by 2002:a2e:9003:: with SMTP id h3mr26708964ljg.194.1560795380657;
        Mon, 17 Jun 2019 11:16:20 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id l24sm2232894lji.78.2019.06.17.11.16.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:16:19 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id v24so10236162ljg.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:16:19 -0700 (PDT)
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr30169158ljm.180.1560795379164;
 Mon, 17 Jun 2019 11:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com> <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
 <87sgs8igfj.fsf@oldenburg2.str.redhat.com> <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
 <87k1dkdr9c.fsf@oldenburg2.str.redhat.com> <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
In-Reply-To: <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 11:16:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkCOVzXeju8H8iWeh-vWorpWSZG6USFKcOWQ36XokZMA@mail.gmail.com>
Message-ID: <CAHk-=whkCOVzXeju8H8iWeh-vWorpWSZG6USFKcOWQ36XokZMA@mail.gmail.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:13 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That one we might be able to just fix by renaming "fds_bits" to "__fds_bits".

That said, moving it to another file might be the better option anyway.

I think fd_set and friends are now supposed to be in <sys/select.h>
anyway, and the "it was in <sys/types.h>" is all legacy.

                 Linus
