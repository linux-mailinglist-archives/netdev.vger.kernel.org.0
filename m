Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB523C58D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgHEGE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgHEGE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:04:28 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C195C06174A;
        Tue,  4 Aug 2020 23:04:28 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x2so3044192ybf.12;
        Tue, 04 Aug 2020 23:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BKBYK/LCXq8DM95qZATverzrXGld4V/iuWY52L6fQFw=;
        b=gJyjPcvK9DIkO9kOnThHniErRVNijm5oNOy3qKiIrZ0AQoTpGt1foi5W/ZSt1jr1o9
         ebPdawleL7yPrVILGi87o8LoB7y5By6NcLrXmp+eZ/fSRuGFKlrQweOTG0aNDXRtAuql
         FaezsQhz3211JfwDUgoB0wTc9IcJUFbPE4o0sFEckRTnJhTgbu3yAkL3l6tHIjUeifoe
         U8KH/ULUOa4EaWiJwusIk555ehvcV6VSTeEavXil+DhKcSg/tw+9l4/2VowWBcaTMOdx
         Vadqt7BIqaNpD4W3czyG7Am6bhCNRQ3X4yIEdZE6hAKO8E7SI3JRjYCwvXE0Ag4AUpKs
         6jhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BKBYK/LCXq8DM95qZATverzrXGld4V/iuWY52L6fQFw=;
        b=aRDNqdszLjn3z6Wxgn0kXn3L2QBV86/BoMFprd5aOiyTjBphlieM2WogoHTDZZiJfN
         VQL9gwNbwzwIciOIAgm2ByAZEiGvQsiBZpQV7KQmz6awN/Coz2q7q91kv8gn/eKXqaI4
         cZqGCchqK5IczD+J3k1j1clinl+4unmmKpPmAsPY77Q1Azb1gP6yzN96H3OncUqQ4Ur6
         +lEiRdv07+BJkLjqdFriHLeNbcqySONbilT19/IhVnxbPpkHTtQvv8tU/fyNOXEQMkHC
         KMEbEA/pvauCwUbcl9x12pzbvtYN7HRB8z5gakk1y2Snn8Wue6xuCQm2rWpK6zqxrD7G
         6u8g==
X-Gm-Message-State: AOAM5328o+kbC97r0m5Wgl4/wK/TQYhH6Km6LY67tGsTLLbFj9MP9LvQ
        UG9OtGJrDi5OmCnRSHTipu8msh+1AvseRx7X8ZY=
X-Google-Smtp-Source: ABdhPJxf5rvurEADYCiVdD4ayMK1no3mM/1dS3013jTDQLryepLa83TdQS0KI+APb239REtVJ8kmtqC20oNwE9q7Ru4=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr2326414ybq.27.1596607467898;
 Tue, 04 Aug 2020 23:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-3-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:04:17 -0700
Message-ID: <CAEf4BzZqAn5ojg2MFOY5=T8GbRvJ8C7j5Szr+0etEWjU30f8NA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 02/14] tools resolve_btfids: Add support for
 set symbols
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The set symbol does not have the unique number suffix,
> so we need to give it a special parsing function.
>
> This was omitted in the first batch, because there was
> no set support yet, so it slipped in the testing.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/resolve_btfids/main.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>

[...]
