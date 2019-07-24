Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C93A73D12
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404813AbfGXUOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:14:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37030 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404068AbfGXTza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:55:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so48179881eds.4;
        Wed, 24 Jul 2019 12:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgiQF2cvC8jfXzt5HL3uJMfZaBJ8NW3XQoRQC8ii038=;
        b=vQHeAiyXQ/fCWx93RMqspZg1DqWs3Ss8caJgC5JiNt1q2PzivWVm84dLQmP+XWPMBJ
         wiM8lTSMXvxMkz5oJReFb1oqB5mBoC0dfhceBItUItDfaKYJuiQuwzJQIp9MHNmubDnM
         Hds5/qNqyc8M+MnlPxI4ary5YddYAtlyLSbFFgcR5W/TTXYK6PlvEwlRN2OuFo9tO3E0
         vGkFfsvGiINEUILt8rxNw2oCJPkB3cbjEeOIVoGHkQJPpucIBZWG53bDgkWZR8gLCwRb
         IKvmqXEZEfLxA2ClNvYwQrE/YOQr7QqRX90PgnXj/7aHOC81GSClCaAVu7UTdbjzOZtg
         Az/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgiQF2cvC8jfXzt5HL3uJMfZaBJ8NW3XQoRQC8ii038=;
        b=V59YyzLW4j4i4sPf+gLYnGFxtm9Q2iG+Ij1DwNU90qKoagLKVYGRZvyew2iicc17nK
         dGWCRRIYvwDaP0LYVq8vA+igDBGF/oR0zfRSUyHvsgkzUw6a2lwxfW6QDTT+ZyYvoes1
         Tyjfvg4HyxUCQUw8XZCWvwEKQL90Kffk4g+v7B8m7JCQEU0KSn9WuHlcM167ruGMHNhD
         HoueKZVjIrRCWW+mErF+dIDcckv52VDC16kLv+9NtgLe4oh5qGLgezdFjr0a47WPgkCe
         pIIVxtndjG/ag9LQCsbLArXJFWGbg6Fzia5CZR0fHdtHAe/MteLz76/OGltraUBX3a81
         JKPQ==
X-Gm-Message-State: APjAAAVL95xc01TZtrLi97XVX7ZW6bGzTmXlMYYbzbLTaVgNL4DIufEi
        OmgFg6oVPsKb3aAH1NibahwVwGkp1J/VDPLXEJss+w==
X-Google-Smtp-Source: APXvYqxlAArBe8lODQMcY4CpIrmB367EyP3gjRlWspBDi7tNnt9o7OTfGDWGL3ZxZG4lQwVNWoGp9sIGlniTSexzPB4=
X-Received: by 2002:a50:eb92:: with SMTP id y18mr72682568edr.245.1563998128385;
 Wed, 24 Jul 2019 12:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
In-Reply-To: <20190724165803.87470-3-brianvv@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 15:54:52 -0400
Message-ID: <CAF=yD-+a=t_YizdJpb_Q+zxR7iP-V-EarNsp9tjnFTRBjOtFvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:10 PM Brian Vazquez <brianvv@google.com> wrote:
>
> This introduces a new command to retrieve multiple number of entries
> from a bpf map, wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
>
> To start dumping the map from the beginning you must specify NULL as
> the prev_key.
>
> The new API returns 0 when it successfully copied all the elements
> requested or it copied less because there weren't more elements to
> retrieved (i.e err == -ENOENT). In last scenario err will be masked to 0.

I think I understand this, but perhaps it can be explained a bit more
concisely without reference to ENOENT and error masking. The function
returns the min of the number of requested elements and the number of
remaining elements in the map from the given starting point
(prev_key).

> On a successful call buf and buf_len will contain correct data and in
> case prev_key was provided (not for the first walk, since prev_key is
> NULL) it will contain the last_key copied into the prev_key which will
> simplify next call.
>
> Only when it can't find a single element it will return -ENOENT meaning
> that the map has been entirely walked. When an error is return buf,
> buf_len and prev_key shouldn't be read nor used.

That's common for error handling. No need to state explicitly.

> Because maps can be called from userspace and kernel code, this function
> can have a scenario where the next_key was found but by the time we
> try to retrieve the value the element is not there, in this case the
> function continues and tries to get a new next_key value, skipping the
> deleted key. If at some point the function find itself trap in a loop,
> it will return -EINTR.

Good to point this out! I don't think that unbounded continue;
statements until an interrupt happens is sufficient. Please bound the
number of retries to a low number.

> The function will try to fit as much as possible in the buf provided and
> will return -EINVAL if buf_len is smaller than elem_size.
>
> QUEUE and STACK maps are not supported.
>
> Note that map_dump doesn't guarantee that reading the entire table is
> consistent since this function is always racing with kernel and user code
> but the same behaviour is found when the entire table is walked using
> the current interfaces: map_get_next_key + map_lookup_elem.

> It is also important to note that with  a locked map, the lock is grabbed
> for 1 entry at the time, meaning that the returned buf might or might not
> be consistent.

Would it be informative to signal to the caller if the read was
complete and consistent (because the entire table was read while the
lock was held)?

>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
