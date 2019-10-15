Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C305DD846E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbfJOX0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:26:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38322 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfJOX0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:26:41 -0400
Received: by mail-lf1-f67.google.com with SMTP id u28so15821063lfc.5;
        Tue, 15 Oct 2019 16:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDs1JHwBlFGdzpyUjdaStx/cOvaK1y2mtSlznl47O9E=;
        b=Ls6mDDHnZl/LyAA2DLCEjpiFJooX5Wt2XPhod6eyK9FGEY3dg7ZUGqdUcCoqcveYAZ
         olbkf4NiSrrAFDhNZXdaT5woFr+0gpJO+XMUKJmCjBQIyNIvcgN9r4yzYYp6G13/VZGc
         tbw+Aq0/pbcUSDRB/WwQZ3f9pqhYAqpboApbwpQTCqut/CxFSloAOcgKxaZx/H21+tAe
         jUQlIgc6HNvN7h90Q+6WSAOz+WOcOH4/WAWiMNyz+KsO67uEs8smn+m8gwJMwpNcTxWY
         zt8M1yyLozdPqONIv9aWRnTc3KFyLAsmdkQpxGxP4DyhJhH7F/xuClqls57LEiCtaqkO
         OzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDs1JHwBlFGdzpyUjdaStx/cOvaK1y2mtSlznl47O9E=;
        b=pj7C97K/ssYCpF5aOgaI47FqcEyUkIDIa1vQ9QOw8z9z7W4vG5yWAIpeG4Cma8iJQ9
         HX4rNu3+HhjnzNlPTNhsrBr8Q/YBzkYRDUhvipqNVaUD00YgubGPlPhINO2xLH+eq8sN
         CQ20bVIvHASqpsmvfCiu6K8SzEAiORUm2egKb3bRLCGR5mFVz/ofsadHZx6K+VG4rNuX
         /CoLQFcvUg7pstcgmwRnFMvZ05kRt0XDkNdARrhsnEW8LbsydxTB/lMh61jggTrtF+d1
         RXJs+EBMFFXdjOnU7nUhM8smKeP2Oxq0BUojADLh5JZY520kgOsYq5CEKFmJ0HHtRaln
         HFYg==
X-Gm-Message-State: APjAAAXpNBn7GPceMxLe+Y94qcqxoBHVbY6sEMlSt8fR31jF81QwTmRv
        JOY9xxKNLu1qba5gxBdh6niO5kiqZIQ7JESVhhc=
X-Google-Smtp-Source: APXvYqwTxC/J4b26ByDzVFejz9YQasxo5GS5ms4inUSeptR+lrWA0oSKVPoujGUm4J9bFAlvBGWVrSvRZ719bDTzXSc=
X-Received: by 2002:ac2:5637:: with SMTP id b23mr10509331lff.100.1571181999530;
 Tue, 15 Oct 2019 16:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191015183125.124413-1-sdf@google.com> <CAEf4Bzb+ZjwA-Jxd4fD6nkYnKGAjOt=2Pz-4GNWBbxtNZJ85UQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzb+ZjwA-Jxd4fD6nkYnKGAjOt=2Pz-4GNWBbxtNZJ85UQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 16:26:28 -0700
Message-ID: <CAADnVQKUV2TEDdekj0xApPqm6q0kCK-SvvpT5=80YQcsfuvXFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in BPF_PROG_TEST_RUN
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 4:15 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 15, 2019 at 2:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > It's useful for implementing EDT related tests (set tstamp, run the
> > test, see how the tstamp is changed or observe some other parameter).
> >
> > Note that bpf_ktime_get_ns() helper is using monotonic clock, so for
> > the BPF programs that compare tstamp against it, tstamp should be
> > derived from clock_gettime(CLOCK_MONOTONIC, ...).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  net/bpf/test_run.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 1153bbcdff72..0be4497cb832 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -218,10 +218,18 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
> >
> >         if (!range_is_zero(__skb, offsetof(struct __sk_buff, cb) +
> >                            FIELD_SIZEOF(struct __sk_buff, cb),
> > +                          offsetof(struct __sk_buff, tstamp)))
> > +               return -EINVAL;
> > +
> > +       /* tstamp is allowed */
> > +
> > +       if (!range_is_zero(__skb, offsetof(struct __sk_buff, tstamp) +
> > +                          FIELD_SIZEOF(struct __sk_buff, tstamp),
>
> with no context on this particular change whatsoever: isn't this the
> same as offsetofend(struct __sk_buff, tstamp)? Same above for cb.
>
> Overall, this seems like the 4th similar check, would it make sense to
> add a static array of ranges we want to check for zeros and just loop
> over it?..

I wouldn't bother, but offsetofend() is a good suggestion that
can be done in a followup.

Applied both patches. Thanks
