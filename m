Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB68E26997F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgINXKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgINXKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:10:23 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04691C06174A;
        Mon, 14 Sep 2020 16:10:22 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b142so1075327ybg.9;
        Mon, 14 Sep 2020 16:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PbWNT4gxMjEMOnL7Nnds+HzJhYLvf7p+m43a5dhww1Y=;
        b=HrMMScLTJKRC7yddrcO92v/93Fmbb5mvQrUpiLc6/Ll4c4WlYB8OSYE7OV9a0VnNKE
         AWyb0Cebn6qKf8MPN9iIrVXmZ34mEHMF1REZz3MGJoDfPobpmr/T8UsSmtAFNNxzJWjj
         67WW/JznnflQc1vqPG4rubIg61JBD/54RLSl3KnCXPxid3bhkMcnf9LmXkGz2Dfoju6V
         OMVt6Ou4QheDxHReNRl1YcSOIyvI4DnlcjMicHBChNmofLDBs6IBk+AASJTdL2NYVaUi
         BkyMKDMtMaFKwLm4o6E5Kn8Usicy1e4paWP88T/V/dkdZiyUtuSp/3D8nGNDvH1ep5No
         Ej4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PbWNT4gxMjEMOnL7Nnds+HzJhYLvf7p+m43a5dhww1Y=;
        b=TA9+wixOknJEDNVGWOJ/ua967cMvHe16VOVHi2xFC169kpvGDtZ2JDSsd4U/UUl9yP
         td8ij+zoxSDpnCKVtMwhg2Ci3gQaRtQbOJS9xkaLyx5SaF9q4TSqpQlDqaddYARRZSmN
         9KH3R7o4w11pL4qbNr8EzSBsKjmuE0IxcfJiNqTB1/J5PuudW8Nm+cXa5igSV6LSH5Qe
         lioPn7teeQm7O0+sXCpV6kAc1OQugg/ou8gIZ7gBlyrLx6I+aw1pp72J9bRF84jFRXYT
         rpP0IaGzHpth0dlqlaJiiCNkQQ611epZNL4wJgdEETGSS/lxlRxaiXaEtCtl9RXEc2x4
         /8Pg==
X-Gm-Message-State: AOAM533aFK1Z5zpxppC03cmVSRuXua7VwaW3qpQyOGxUPAftAIMAdMvN
        XbqXAIceK6py0poMTajRl1BJwloQ1qV05uH1Jns=
X-Google-Smtp-Source: ABdhPJyFtE9o9uKYMkUf4bRxwmxmPWnmeI6kWDxCBRl5V+oRmebZ7hcqU5OtNugbCHtET41Mox4fX8T8U+AOWYMa7LQ=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr24200250ybi.459.1600125022125;
 Mon, 14 Sep 2020 16:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
 <159981835908.134722.4550898174324943652.stgit@toke.dk> <CAEf4BzZMj0sPisgUZ+3qKvqaAxfzzRNHZTpoR-zuDXvKcY3URQ@mail.gmail.com>
 <87imcgz6gk.fsf@toke.dk>
In-Reply-To: <87imcgz6gk.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 16:10:11 -0700
Message-ID: <CAEf4Bzb9Xw65jL1UxVjOz5HdwgMckEkFHWrYdEPbnj01a7X1hQ@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 4/9] bpf: support attaching freplace
 programs to multiple attach points
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Sep 11, 2020 at 3:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> This enables support for attaching freplace programs to multiple attac=
h
> >> points. It does this by amending UAPI for bpf_raw_tracepoint_open with=
 a
> >> target prog fd and btf ID pair that can be used to supply the new
> >> attachment point. The target must be compatible with the target that w=
as
> >> supplied at program load time.
> >>
> >> The implementation reuses the checks that were factored out of
> >> check_attach_btf_id() to ensure compatibility between the BTF types of=
 the
> >> old and new attachment. If these match, a new bpf_tracing_link will be
> >> created for the new attach target, allowing multiple attachments to
> >> co-exist simultaneously.
> >>
> >> The code could theoretically support multiple-attach of other types of
> >> tracing programs as well, but since I don't have a use case for any of
> >> those, the bpf_tracing_prog_attach() function will reject new targets =
for
> >> anything other than PROG_TYPE_EXT programs.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > It feels like using a semi-constructed bpf_tracing_link inside
> > prog->aux->tgt_link is just an unnecessary complication, after reading
> > this and previous patches. Seems more straightforward and simpler to
> > store tgt_attach_type/tgt_prog_type (permanently) and
> > tgt_prog/tgt_trampoline (until first attachment) in prog->aux and then
> > properly create bpf_link on attach.
>
> I updated v4 with your comments, but kept the link in prog->aux; the
> reason being that having a container for the two pointers makes it
> possible to atomically swap it out with xchg() as you suggested
> previously. Could you please take a look at v4? If you still think it's
> better to just keep two separate pointers (and add a lock) in prog->aux,
> I can change it to that. But I'd rather avoid the lock if possible...

I took a very quick look at this specific bit, planning to do another
pass tomorrow.

What's the problem with adding a mutex to bpf_prog_aux? In your case,
now you introduced (unlikely, but still) extra state transition for
tgt_link from non-NULL to NULL and then back to non-NULL? And why?
Just to use atomic xchg, while using atomic operation is not an
absolute necessity because it's not a performance-critical path at
all. We are not optimizing for millions of freplace attachments a
second, right? On the other hand, having a mutex there won't require
restoration logic, it will be dead simple, obvious and
straightforward. So yeah, I still think mutex is better there.

BTW, check Stanislav's latest patch set. He's adding used_maps_mutex
to bpf_prog_aux with no problems at all. It seems to me that we might
want to generalize that used_maps_mutex to be just bpf_prog_aux's
mutex ('prog_aux_mutex' or whatever we'd call it) and use it for such
kinds of low-frequency bpf_prog metadata manipulations/checks.

Thoughts?


>
> -Toke
>
