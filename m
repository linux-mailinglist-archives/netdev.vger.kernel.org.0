Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE094DFD6
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfFUEvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:51:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36690 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfFUEvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:51:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so3574388qkl.3;
        Thu, 20 Jun 2019 21:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VvnORda2iqkRVhpfLhDked+KLobLp7Na4ZF1KkXC1M=;
        b=AJNrsTdJqrIRa55j4xh/JPVC7tydQoIHhDWlLtIZ7x7SK7yCSV2y3mJDLZlWvYREol
         gB6tPU5SiT/kM7Oz+FyxGUSqtWdQB5PTIzSntTLNz9M5BOZ/6N/acTtG1ez1AfxpQ7Wm
         SWxbWhMCsUEjWkXCx5MaaV/4nR93RdpdYPZnxHQUblHQJTgeL/TTHQP8ZVjnKA38JDs+
         UIVv5yNEDZE5rRyspsmrHR6y/LJBp/6zx9XS48RZd0OoRymvlh0hXuEyjhvOQwWJrkFe
         U+vk4dzxK7Ho4uG4BOFDhbXvSA5OHqM2/GvwbjBYpcI8cbzanZjtJ+aCtW7GnbwzEcUZ
         iosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VvnORda2iqkRVhpfLhDked+KLobLp7Na4ZF1KkXC1M=;
        b=pdc+DdNxvGFuhEN1rBbSiizOU3eqomb1ZmuJLb4w+iTRNhWfKkmZlmRqbsav50hhex
         /l7qUgGwZHzt6brABemr3eO2MmT3Qqfeeryvly3kPoxqFXzB3B21MPCcYI168LcTVO8Y
         VPWyHGeRb1N89ozkaWdG6j6ENiv3QjmIDF8LKuTOEUK9RZBQG01+4R2+bT2S7iKoMh9S
         HacfPOsEklu0l81nWSVRL0ocCGDN7m2uuk1T/920WLp3CTwU1M6UgymY2cx3+eCtnD53
         w5qq2Tehadzcx1aMzH/1WwqHGfCFYEcc7Av2SHS5C+yDlfSxyQ2+5wJiJDRFozKTwdOC
         4hZg==
X-Gm-Message-State: APjAAAWaAYefud0EsWzNFRl+1DUlqwWh8UMBR2odI+yx56kjhQDvD8hE
        2mdCjy52o1pHbFjEitDXlCpi8UykeGWoojlAEI7fBqfVZdM=
X-Google-Smtp-Source: APXvYqxGsmIviPGcxtIqZ+0nFPSOAKg+2xr8nk8cYa9m109icqq3pHietRkMK4Ur0Mw56yAGUcAu7AJiAWo2CATogzo=
X-Received: by 2002:ae9:d803:: with SMTP id u3mr4033947qkf.437.1561092659505;
 Thu, 20 Jun 2019 21:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190620230951.3155955-1-andriin@fb.com> <20190620230951.3155955-6-andriin@fb.com>
 <20190621000819.GD1383@mini-arch>
In-Reply-To: <20190621000819.GD1383@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:50:48 -0700
Message-ID: <CAEf4Bzakcj122-ZnQn3M3bjr8nhQPGXPw8wTYvA018K7Afoh6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests/bpf: switch test to new
 attach_perf_event API
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 5:08 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/20, Andrii Nakryiko wrote:
> > Use new bpf_program__attach_perf_event() in test previously relying on
> > direct ioctl manipulations.
> Maybe use new detach/disable routine at the end of the
> test_stacktrace_build_id_nmi as well?
>

yeah, totally, missed that.

> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../bpf/prog_tests/stacktrace_build_id_nmi.c     | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >

<snip>
