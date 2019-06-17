Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0D48BA9
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFQSNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:13:40 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42858 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfFQSNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:13:40 -0400
Received: by mail-lf1-f65.google.com with SMTP id y13so7225668lfh.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J081FiTz/dcpmcwzq5O6GF0XKXf+1rYscrgrosKZT9c=;
        b=HBku58NGVAv95CcjvbfqVxo4zSvDzDkjpBqEa1eT1BUBn499MwtAVYnMb8KuIY8q1x
         tRdMVTbOCh2URPJ2ZL0QtQNOYWR65ySiiK8lBU7nvffrP+x6MGzSjtH5IXIMF7+XVEV/
         Dp3mtWFQ74+2UcMPuzNH0qKa44Gwg/tiwMvL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J081FiTz/dcpmcwzq5O6GF0XKXf+1rYscrgrosKZT9c=;
        b=ESluhkWzsBmBnA+o6xuXovuH20HlhJcTknzCUb8doc1j/rKPN9loh8HpUvHOkHShoX
         QBvhg7nAWRrHM9z29Dir3EIa7rqpR0Aw0xcrs/G9mIxqvYrj/hm0Mg/8keuODCUVM08B
         cP/Q6SGaoNdrNxtCeHGRaCuj37f+zvzHypGtvDWcaqDtM5CKcJMjfSxDkGqO9VzfpAm+
         S0pTyxX7EZoyIKlDOuyWf0We37sdJFl/+k5ANmzgiPNMn+7mA3+2K3YbWFBRjqKr8ajG
         /RrKYg7mRsbU3JHmyb34BrHnUqRTNFeW3F0mHKm1cny73KRdY0VD+PWxyVgihmcdbc1u
         QPKw==
X-Gm-Message-State: APjAAAXd052YQ+KJ7kpVzjRu1FoFGL89rH1yacgdt8ZGnmuw4uL5LTip
        6wbVa4wAaTZR1iz1KC0hbXN0Avwe9EM=
X-Google-Smtp-Source: APXvYqyFPJLnxPcwORQ/smdUuhWkxWdkdGaIXJrwEsuwdkSuaNZJVyafF3wQKNyUoYO7J1aAeWO1Bw==
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr42402766lfn.46.1560795217770;
        Mon, 17 Jun 2019 11:13:37 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id m10sm1870118lfd.32.2019.06.17.11.13.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:13:36 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id s21so10245626lji.8
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:13:36 -0700 (PDT)
X-Received: by 2002:a2e:9bc6:: with SMTP id w6mr17483710ljj.156.1560795216288;
 Mon, 17 Jun 2019 11:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com> <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
 <87sgs8igfj.fsf@oldenburg2.str.redhat.com> <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
 <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 11:13:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
Message-ID: <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
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

On Mon, Jun 17, 2019 at 11:03 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> There's also __kernel_fd_set in <linux/posix_types.h>.  I may have
> lumped this up with <asm/posix_types.h>, but it has the same problem.

Hmm.

That one we might be able to just fix by renaming "fds_bits" to "__fds_bits".

Unlike the "val[]" thing, I don't think anybody is supposed to access
those fields directly.

Of course, "supposed to" and "does" are two very very different things ;)

                  Linus
