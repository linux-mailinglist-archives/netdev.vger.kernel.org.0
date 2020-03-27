Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63B19618B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgC0Wyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:54:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46142 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgC0Wyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:54:46 -0400
Received: by mail-qk1-f193.google.com with SMTP id u4so12610906qkj.13;
        Fri, 27 Mar 2020 15:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s0yMrTSs7hjV9K30fjNglb+v9BtEqlXDjGrHrxSiYyo=;
        b=TMrRXS4IJtnTx8GissmJhaQ/Z2+96EsYxhiCxUytVL3+5yp3iWlgWcWkGcSlMp9axg
         t8AJz6RmC5T3I3CShNgpAo7lNiUqEk3/wEFHiNqXhVQIfG89v9IJxHESQgPBQ5j2VYZE
         mCzFAxcVdPU/5x1LuVRShZX8695UXMN5nu3bxAyyQ9Q49JjgN0/8M8s9NRCj8z8q+OXo
         SOr9YomhpAmG1ROrd2rNQqOZcTtzH7qohch2IsULnCLMHFTnRZTzNerJHSkrYj6NZN+R
         Ky2T6Aydw/4MTPzByv3ut5aSnYosHjdyIl3aeDhiA9DNc6vC7Nv5TZZoNcZ8Di8dS8Fq
         K1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s0yMrTSs7hjV9K30fjNglb+v9BtEqlXDjGrHrxSiYyo=;
        b=N7NVcDFx3WnKF3zBqEc4TqfFqhBjlqLo/ftvPmRuvMSeqJBuVSfjSvzJF1QT/Nc432
         ZzVlnrPdz8tJtgSOj0ku44NbSRep0MjFHS0hWDlApITiv07ygY3EyLn+Bje7i6v3rN0D
         KfV5KZo5ngZqcPr5bMLc4Mn4enfpLtJQw3czO4tJMYPRNuPztuDTRoiSmN8w2Pr1pp/C
         Zj7nLn4OJw8hnsAsc8/GDTluMAkTfhqrMVfk+XcwG9w3Kppnf30ybPA/xxCV1Ho95Uqd
         hHliTMpZkdZKATlF8uV+AJ/mPlzeZgyedGTzCqyOFXOmLQKLqXNBgDK46fItQAXajuG/
         5qIA==
X-Gm-Message-State: ANhLgQ0QBYqXUxZFH+GQJ7ntt2h7/kRQNIkYCq/cA38iy2ypTkhdmOy+
        j/owVx9+W/wkScNbYQqMa6Qyk3kfrevs4f5djLE=
X-Google-Smtp-Source: ADFU+vuV9NBau6R5xAANhzPFZrvOz+h+I6M9vVaNxQm8D7z2aNvD1xZDnzTtahMEPCM2/GToEEpAi+Mjo4LwITbSy/8=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr1755394qka.449.1585349685406;
 Fri, 27 Mar 2020 15:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <87lfnmm35r.fsf@toke.dk> <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
 <87wo75l9yj.fsf@toke.dk>
In-Reply-To: <87wo75l9yj.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 15:54:34 -0700
Message-ID: <CAEf4Bza8P3yT08NAaqN2EKaaBFumzydbtYQmSvLxZ99=B6_iHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 3:17 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > Please stop dodging. Just like with "rest of the kernel", but really
> > "just networking" from before.
>
> Look, if we can't have this conversation without throwing around
> accusations of bad faith, I think it is best we just take Ed's advice
> and leave it until after the merge window.
>

Toke, if me pointing out that you are dodging original discussion and
pivoting offends you, by all means, you don't have to continue. But if
you are still with me, let's look at this particular part of
discussion:

>> >> For XDP there is already a unique handle, it's just implicit: Each
>> >> netdev can have exactly one XDP program loaded. So I don't really see
>> >> how bpf_link adds anything, other than another API for the same thing=
?
>> >
>> > I certainly failed to explain things clearly if you are still asking
>> > this. See point #2, once you attach bpf_link you can't just replace
>> > it. This is what XDP doesn't have right now.
>>
>> Those are two different things, though. I get that #2 is a new
>> capability provided by bpf_link, I was just saying #1 isn't (for XDP).
>
> bpf_link is combination of those different things... Independently
> they are either impossible or insufficient. I'm not sure how that
> doesn't answer your question:
>
>> So I don't really see
>> how bpf_link adds anything, other than another API for the same thing?
>
> Please stop dodging. Just like with "rest of the kernel", but really
> "just networking" from before.

You said "So I don't really see how bpf_link adds anything, other than
another API for the same thing?". I explained that bpf_link is not the
same thing that exists already, thus it's not another API for the same
thing. You picked one property of bpf_link and claimed it's the same
as what XDP has right now. "I get that #2 is a new capability provided
by bpf_link, I was just saying #1 isn't (for XDP)". So should I read
that as if you are agreeing and your original objection is rescinded?
If yes, then good, this part is concluded and I'm sorry if I
misinterpreted your answer.

But if not, then you again are picking one properly and just saying
"but XDP has it" without considering all of bpf_link properties as a
whole. In that case I do think you are arguing not in good faith.
Simple as that. I also hope I don't have to go all the way back to
"rest of the kernel", pivoted to "just networking" w.r.t.
subsystem-specific configuration/attachment APIs to explain another
reference.

P.S. I don't know how merge window has anything to do with this whole
discussion, honestly...

>> >


> -Toke
>
