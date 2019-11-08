Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700A5F3D3B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKHBKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:10:31 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46189 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHBKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:10:31 -0500
Received: by mail-qk1-f195.google.com with SMTP id h15so3803270qka.13;
        Thu, 07 Nov 2019 17:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yWgT2PtMrJhC8pe46v7IsyFWFEwvv4M7Y8gpYa2TrLQ=;
        b=e9ZnAqhgpJORDTZKaHx/0NAxfTs61vhfOz7iHP3XPMaFcHjAiGsCsKzQGqp2ZP7zAo
         6D1jltU3ZgnUH6GwQQYB8neZfvFyS2Q4ShGCYkIQbFBhNyKhIWeoa4d0mH9YXjEu6RZd
         OElPmYMrLH1/sX3xl6ZeQqv1AcaEX+sLCf9yS/k7TY6gOtUqvVHYFEQjfV1iHzOUDjKI
         XR5IgTlhfus+G3ZYGFP7llbg04HtPM9M01Tx5acI4lreXI2vuPrQEGm/q2nQ7mIaDXTG
         Od9w4H8cUEnD2XJ4E2ENfYvH0GxG6MDnz7qAiMa0Gan4UQI4NsxCyhs4vi380AxycM3X
         bnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yWgT2PtMrJhC8pe46v7IsyFWFEwvv4M7Y8gpYa2TrLQ=;
        b=jDUYgWs+gyq9Tv8cDmpRocf1mfyzkvDXOj8MxvLMlH7Um96Y98nTp/Nd7hkxt8/1s8
         2z+viGvmlHgZX/6wxeMY8ptJscDv7KnLVb29rVpQG2To55KWYt2RsJS2Zv6E8o1dh+FY
         YnhX/OefO9hwcOL/LDTCGJ1xJE8HifVsLaHluEzr+d+dhWyyEzJzrmbVBflMRWG1K0z9
         RTaub7oViuRYYZNPMAR7cl7MMLzyWqj+ZXknka4qv0eokQZBP/A5WqDSIdj8+qgUKHYu
         K0yumo4+C3HW0B7MKKSnNfeKgZyRjI9JP2S0NoY+nVuFPevRyoimJBdzzMaduUjjOJnl
         8bzg==
X-Gm-Message-State: APjAAAUoj42pyPVbn9jm2hqAg7mNK7cKv8nEY++5hvDzjQhx3R71Yu6c
        PEsxWI8Mavr4b6ze7z0k6V2NV/0ytNaoJHmtKBI=
X-Google-Smtp-Source: APXvYqxzhYuzLASKZyYek9Ue6Upyl2gpWKz02Au5hT6K3K/Uk1kSOMoeTE1cWltDDqKC/XuH4swKamA+YukLmekZlp8=
X-Received: by 2002:a37:b801:: with SMTP id i1mr6376157qkf.497.1573175430133;
 Thu, 07 Nov 2019 17:10:30 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com> <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com> <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
 <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com> <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 7 Nov 2019 17:10:18 -0800
Message-ID: <CAPhsuW4gYU=HJTe2ueDXhiyY__V1ZBF1ZEhCasHb5m8XgkTtww@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 4:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 07, 2019 at 11:16:20PM +0000, Song Liu wrote:
> >
> >
> > > On Nov 7, 2019, at 3:09 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Nov 07, 2019 at 11:07:21PM +0000, Song Liu wrote:
> > >>
> > >>
> > >>>
> > >>>
> > >>>>> +
> > >>>>> +static int bpf_trampoline_update(struct bpf_prog *prog)
> > >>>>
> > >>>> Seems argument "prog" is not used at all?
> > >>>
> > >>> like one below ? ;)
> > >> e... I was really dumb... sorry..
> > >>
> > >> Maybe we should just pass the tr in?
> > >
> > > that would be imbalanced.
> >
> > Hmm.. what do you mean by imbalanced?
>
> I take it back. Yeah. It can be tr.
>
> >
> > >
> > >>>
> > >>>>> +{
> > >>>>> +       struct bpf_trampoline *tr = prog->aux->trampoline;
> > >>>>> +       void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
> > >>>>> +       void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
> > >>>>> +       if (err)
> > >>>>> +               goto out;
> > >>>>> +       tr->selector++;
> > >>>>
> > >>>> Shall we do selector-- for unlink?
> > >>>
> > >>> It's a bit flip. I think it would be more confusing with --
> > >>
> > >> Right.. Maybe should use int instead of u64 for selector?
> > >
> > > No, since int can overflow.
> >
> > I guess it is OK to overflow, no?
>
> overflow is not ok, since transition 0->1 should use nop->call patching
> whereas 1->2, 2->3 should use call->call.
>
> In my initial implementation (one I didn't share with anyone) I had
> trampoline_mutex taken inside bpf_trampoline_update(). And multiple link()
> operation were allowed. The idea was to attach multiple progs and update
> trampoline once. But then I realized that I cannot do that since 'unlink +
> update' where only 'update' is taking lock will not guarantee success. Since
> other 'link' operations can race and 'update' can potentially fail in
> arch_prepare_bpf_trampoline() due to new things that 'link' brought in. In that
> version (since there several fentry/fexit progs can come in at once) I used
> separate 'selector' ticker to pick the side of the page. Once I realized the
> issue (to guarantee that unlink+update == always success) I moved mutex all the
> way to unlink and link and left 'selector' as-is. Just now I realized that
> 'selector' can be removed.  fentry_cnt + fexit_cnt can be used instead. This
> sum of counters will change 1 bit at a time. Am I right?

Yeah, I think fentry_cnt + fexit_cnt is cleaner.

Thanks,
Song
