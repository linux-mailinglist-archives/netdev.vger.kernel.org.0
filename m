Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD51CD9EA
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 02:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfJGAcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 20:32:06 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44340 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfJGAcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 20:32:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id q12so3035877lfc.11;
        Sun, 06 Oct 2019 17:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXKU32HmscR7CODDGOBJlDNmjfrQGpULmr8c1HZ06hE=;
        b=GG8ZNtBOFfOB0LQtMLD3SO5EBTteh0bA2O4iUKlzvySJmEh0U+rDfMotgGX/8LFoOo
         5pX9UUvHTVUpMkYOXW+0TMrzM6gsAWOWArYfta/2usNP574JZobGA+14T/x3EvX2S8zm
         Bt99C93R24W4Yx0RZnhg6hcrEsguL0LaN1zVkE4/dQMRyejyeBkxDqTb4cXPQCw2iihb
         VxpLx445M27NkYvKEaBK7tr7zmgL5GN1RbyYp2J5f9JWVaqNWGpZoPEp+uE6MIH6ssN5
         org3ToEQ8ZH1xb3qDxN8YMYUjTVm33vsOQZeajc9DFouuPkxpew2nl7jdqln9Y2HDpIJ
         UJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXKU32HmscR7CODDGOBJlDNmjfrQGpULmr8c1HZ06hE=;
        b=TYpsMxEiwSozNrzM1mNXw3vtwb5JpAi02QdMGtAcgqhjvvIwLy2z9cyHpXDZxB3fu1
         qWiY0Jn3fZGsQYTNfQWStTkkaJ9K9d+4JFmDaFgbzKF9KQcpxTWFX7+gF3qlw0PPbeD3
         9AFQdsY3p1hUrWI2FvuK3Tdlbq+TSph/kYJ4u3Iu3MWmXo3NymqYSKHy7h3kkzPHtYNA
         VxhCZX5QTeoEPnIBmEd2YEJ+KKib2uiGSIC7TYP0CjfPeK6W2UCfuA41BR7q4VUfVCjV
         /lnsr/Ic8ByfzwPA+4TemSdEavFo08thwDaltm0nO9UoHEJMskYLZ5Yvp8E+bcGhumAJ
         +QRQ==
X-Gm-Message-State: APjAAAWsWXnH9DuGxeQ/c5Lw4O24sfdpAy7hSFu0SNA+4u/dcbXPnCR2
        cpRXw81QQEwJN0+AeOzDslu7w4v4ewa3b18puJ4=
X-Google-Smtp-Source: APXvYqyxQwRyoEjXRHTjT095N17gSy0m30yXFhf+ksjRj7OobwNCFdovGjVaWVWYyd3t1KzThT9vvw78FSJqC9BC5is=
X-Received: by 2002:a19:6455:: with SMTP id b21mr15288529lfj.167.1570408323942;
 Sun, 06 Oct 2019 17:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191006054350.3014517-1-andriin@fb.com> <20191006054350.3014517-4-andriin@fb.com>
 <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com> <CAEf4BzZ5KUX5obfqxd7RkguaQ0g1JYbKs=RkrHKdDFDGbaSJ_w@mail.gmail.com>
In-Reply-To: <CAEf4BzZ5KUX5obfqxd7RkguaQ0g1JYbKs=RkrHKdDFDGbaSJ_w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 6 Oct 2019 17:31:52 -0700
Message-ID: <CAADnVQJDFhqqxzFXoWxJk5KAnnfxwyZw-QGT+e-9mOUsGEi8_g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 5:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Oct 6, 2019 at 4:56 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Oct 5, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> > > auto-generate it into bpf_helpers_defs.h, which is now included from
> > > bpf_helpers.h.
> > >
> > > Suggested-by: Alexei Starovoitov <ast@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/.gitignore    |   1 +
> > >  tools/lib/bpf/Makefile      |  10 +-
> > >  tools/lib/bpf/bpf_helpers.h | 264 +-----------------------------------
> > >  3 files changed, 10 insertions(+), 265 deletions(-)
> >
> > This patch doesn't apply to bpf-next.
>
> Yes, it has to be applied on top of bpf_helpers.h move patch set. I
> can bundle them together and re-submit as one patch set, but I don't
> think there were any remaining issues besides the one solved in this
> patch set (independence from any specific bpf.h UAPI), so that one can
> be applied as is.

It looks to me that auto-gen of bpf helpers set is ready,
whereas move is till being debated.
I also would like to test autogen-ed .h in my environment first
before we move things around.
