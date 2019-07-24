Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EEF7415E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfGXW0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:26:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43133 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfGXW0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:26:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id y17so21466530ljk.10;
        Wed, 24 Jul 2019 15:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NpDJrirAU6J86zmzabuWEnhe0+gl0qHG+YR8aafVBDI=;
        b=m2DjP/k7Q2J39wDkWM1klxd+sDq2MGRYC9T2wAYVvYuSlY9BW8xMKQS8U7FukwEB5w
         oHGaso9Zioery3GBjA/DfjnwtTza9zvpycb315hOrb1RblZ1BlQ5Dk6cnluWvVanCi+/
         3NPnEkqRhW4ihK9cg89G0kXPWDurIJUeBP6sdbMXXd2r9kpmZ2bpn2vChOIvmbUhoHva
         d1S9ZMdWoFzbXVBikuXOkr+NormyqgbnpqyObwWocER5kuWIb3wP1Te+STy7O8Tk7DX+
         zkx0ybVWycWo6Z3m1tKxRwRm1GML+ThIehgf2AHy/yKMOphft7GQyAEKSVB7NkKUxj6T
         uMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpDJrirAU6J86zmzabuWEnhe0+gl0qHG+YR8aafVBDI=;
        b=h7EDdknI3RsppATwQLE1BQkSeTR7JLpHqCsYfl53N/TUwSLHZx4q2HrnePronpNtTf
         VxRfiD/psCkXYmWzkcYk+nim7JTFDN6PvEHmig8dzFJJWXacIGoa7sI/GPE7/Cs5xwrk
         0CwjsXa5rBoGQyHTyYIz5UJQvaGfDfxY5Nz2sgRijNngwZx9ekB21runesa/9KLG4MzI
         PeHWK4ODiPzHSyr0aazbhA3TLCLJxG0hF3GS2ZrRvL2mFRanVJjTKmqOonoAxISCur3w
         dOBXO7wAZSnhJHWJc5Rxh3IWDobH558hwYfKNYPkSHqeJ4RW8uRnG1Ds6iuj8YjTQaeT
         tTNw==
X-Gm-Message-State: APjAAAVlg7RSM7QK9xiuvPr0/PU4MyuNBVowiIGUZuQ70lews/A9Uqiz
        6gftvtQpbxbVVdMGGmb7rgPvzbzhPSTyzDPsWemVQA==
X-Google-Smtp-Source: APXvYqwioRVRlVoayRFRYTmlYqDLp5RvxXEPtSS2/RMXGEmjjHalEtyvoNJOkEKSC27RM5pkqs5QeGvBcul6NMZsaEo=
X-Received: by 2002:a2e:1459:: with SMTP id 25mr43207432lju.153.1564007176324;
 Wed, 24 Jul 2019 15:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAF=yD-+a=t_YizdJpb_Q+zxR7iP-V-EarNsp9tjnFTRBjOtFvA@mail.gmail.com>
In-Reply-To: <CAF=yD-+a=t_YizdJpb_Q+zxR7iP-V-EarNsp9tjnFTRBjOtFvA@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 15:26:05 -0700
Message-ID: <CABCgpaWCLJtDx8kHNiQZneqYZkZ3fzRGnipT5__kmwMhu01g=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
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

On Wed, Jul 24, 2019 at 12:55 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 1:10 PM Brian Vazquez <brianvv@google.com> wrote:
> >
> > This introduces a new command to retrieve multiple number of entries
> > from a bpf map, wrapping the existing bpf methods:
> > map_get_next_key and map_lookup_elem
> >
> > To start dumping the map from the beginning you must specify NULL as
> > the prev_key.
> >
> > The new API returns 0 when it successfully copied all the elements
> > requested or it copied less because there weren't more elements to
> > retrieved (i.e err == -ENOENT). In last scenario err will be masked to 0.
>
> I think I understand this, but perhaps it can be explained a bit more
> concisely without reference to ENOENT and error masking. The function
> returns the min of the number of requested elements and the number of
> remaining elements in the map from the given starting point
> (prev_key).

That sounds better to me. Thanks!

> > On a successful call buf and buf_len will contain correct data and in
> > case prev_key was provided (not for the first walk, since prev_key is
> > NULL) it will contain the last_key copied into the prev_key which will
> > simplify next call.
> >
> > Only when it can't find a single element it will return -ENOENT meaning
> > that the map has been entirely walked. When an error is return buf,
> > buf_len and prev_key shouldn't be read nor used.
>
> That's common for error handling. No need to state explicitly.

 Ack

>
> > Because maps can be called from userspace and kernel code, this function
> > can have a scenario where the next_key was found but by the time we
> > try to retrieve the value the element is not there, in this case the
> > function continues and tries to get a new next_key value, skipping the
> > deleted key. If at some point the function find itself trap in a loop,
> > it will return -EINTR.
>
> Good to point this out! I don't think that unbounded continue;
> statements until an interrupt happens is sufficient. Please bound the
> number of retries to a low number.

And what would it be a good number? Maybe 3 attempts? And in that case
what error should be reported?
>
> > The function will try to fit as much as possible in the buf provided and
> > will return -EINVAL if buf_len is smaller than elem_size.
> >
> > QUEUE and STACK maps are not supported.
> >
> > Note that map_dump doesn't guarantee that reading the entire table is
> > consistent since this function is always racing with kernel and user code
> > but the same behaviour is found when the entire table is walked using
> > the current interfaces: map_get_next_key + map_lookup_elem.
>
> > It is also important to note that with  a locked map, the lock is grabbed
> > for 1 entry at the time, meaning that the returned buf might or might not
> > be consistent.
>
> Would it be informative to signal to the caller if the read was
> complete and consistent (because the entire table was read while the
> lock was held)?

Mmm.. not sure how we could signal that to the caller.  But I don't
think there's a way to know it was consistent (i.e. one element was
removed in bucket 20 and you are copying the keys in bucket 15, when
you get to bucket 20 there's no way to know that some entries were
removed when you traversed them). The lock is held for just 1 single
entry not the entire table.
Maybe clarify more that in the commit message?

Thanks for reviewing!
