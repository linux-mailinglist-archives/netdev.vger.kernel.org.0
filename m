Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1512175C63
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfGZBC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:02:59 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41263 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfGZBC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 21:02:59 -0400
Received: by mail-yw1-f66.google.com with SMTP id i138so19857214ywg.8
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 18:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FXxdgJofBHTfqUont/xN09J93S988kXgtU9AsgYaVqs=;
        b=QK5weqvkNzeEcaSBLhlR27Gq3Pelk7aFxUKr5ZZ5mlWxb7g5ZwhRSWK+XnTKjAniKe
         7nIf/Bjv3xX4qlb4CMBC5+vWMVdehkRTF/iv3X11LeItcfjDNYFquDfx5hFy9XW+tnEX
         A2wSu3AwbOXnPuAMHPP59MOIkrGl8bovU9/btnm76H/ltdNSCr586mV/cwO1ews8Wy9E
         Gmk/t6LbKQraOKkr9xKE7LjFfAqf7KPhWFT8rP3w/MyA4Pf/KkwPnU/Ku3K3V2EPyh7s
         C5j4NwiZtERDNHJl+/armc5+5sJzZEWO3TsDW3ZYj0a8N7ASYIbfEzPueURG//CyOPsC
         bXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FXxdgJofBHTfqUont/xN09J93S988kXgtU9AsgYaVqs=;
        b=a5Nua0Tkr3oPfVYAOiwxg5wn8dW+3Qh4Ll62glMAastn2lpIagjIaBHgi6Lq5R+HBc
         CAHe/6FAqUVl8bwSOCmfx6ESwAdU4FtO1ago0Yg628QV7RvID9kZdYGewdEFJxXXl2tH
         +VH1J5dFnsYxOdoYBDiWyZksghjk7H1TK7YtAj//pQzSzHY2z7uKcEbmiNBwalDPxTjH
         AneKlRG55TLXFuNg90Y5hJWGvD+1et1rN1aRrFQ+3eVODZ7r+wOpirTGAXHjTx30m9t3
         YOTvjqxIcsGyLX9DPLTZc0xJBvVhudb5Dc6jjbSEqUOdqB5rynYpwl8egJsgbd+Ysj0C
         q53Q==
X-Gm-Message-State: APjAAAVdQcgeH8Kw5YWOo06tc0edHbpVKP16znDKva5zsANB6Ny9TO8b
        +E1Om8EFST7cXJbY11mEcNzeU5JC
X-Google-Smtp-Source: APXvYqzLvCBWYzp9O3r+7P6DfIKzSxdEeSu3ftNYIQq0aCSxmLERk0AnjC00kUfiFYYBfdrhnZxnpA==
X-Received: by 2002:a0d:ddcd:: with SMTP id g196mr52192578ywe.460.1564102976886;
        Thu, 25 Jul 2019 18:02:56 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id x67sm11925724ywg.70.2019.07.25.18.02.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 18:02:55 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id p85so6445509yba.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 18:02:55 -0700 (PDT)
X-Received: by 2002:a25:5054:: with SMTP id e81mr57568085ybb.390.1564102975137;
 Thu, 25 Jul 2019 18:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com> <20190725235432.lkptx3fafegnm2et@ast-mbp>
In-Reply-To: <20190725235432.lkptx3fafegnm2et@ast-mbp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 25 Jul 2019 21:02:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTScRHuDDTOLb4pryDNQrKXVxw_my55MkMmQqiURt5UEjeA@mail.gmail.com>
Message-ID: <CA+FuTScRHuDDTOLb4pryDNQrKXVxw_my55MkMmQqiURt5UEjeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 7:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 25, 2019 at 04:25:53PM -0700, Brian Vazquez wrote:
> > > > > If prev_key is deleted before map_get_next_key(), we get the first key
> > > > > again. This is pretty weird.
> > > >
> > > > Yes, I know. But note that the current scenario happens even for the
> > > > old interface (imagine you are walking a map from userspace and you
> > > > tried get_next_key the prev_key was removed, you will start again from
> > > > the beginning without noticing it).
> > > > I tried to sent a patch in the past but I was missing some context:
> > > > before NULL was used to get the very first_key the interface relied in
> > > > a random (non existent) key to retrieve the first_key in the map, and
> > > > I was told what we still have to support that scenario.
> > >
> > > BPF_MAP_DUMP is slightly different, as you may return the first key
> > > multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> > > don't have to support legacy scenarios.
> > >
> > > Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> > > to look up previous keys. Would something down this direction work?
> >
> > I've been thinking about it and I think first we need a way to detect
> > that since key was not present we got the first_key instead:
> >
> > - One solution I had in mind was to explicitly asked for the first key
> > with map_get_next_key(map, NULL, first_key) and while walking the map
> > check that map_get_next_key(map, prev_key, key) doesn't return the
> > same key. This could be done using memcmp.
> > - Discussing with Stan, he mentioned that another option is to support
> > a flag in map_get_next_key to let it know that we want an error
> > instead of the first_key.
> >
> > After detecting the problem we also need to define what we want to do,
> > here some options:
> >
> > a) Return the error to the caller
> > b) Try with previous keys if any (which be limited to the keys that we
> > have traversed so far in this dump call)
> > c) continue with next entries in the map. array is easy just get the
> > next valid key (starting on i+1), but hmap might be difficult since
> > starting on the next bucket could potentially skip some keys that were
> > concurrently added to the same bucket where key used to be, and
> > starting on the same bucket could lead us to return repeated elements.
> >
> > Or maybe we could support those 3 cases via flags and let the caller
> > decide which one to use?
>
> this type of indecision is the reason why I wasn't excited about
> batch dumping in the first place and gave 'soft yes' when Stan
> mentioned it during lsf/mm/bpf uconf.
> We probably shouldn't do it.
> It feels this map_dump makes api more complex and doesn't really
> give much benefit to the user other than large map dump becomes faster.
> I think we gotta solve this problem differently.

Multiple variants with flags indeed makes the API complex. I think the
kernel should expose only the simplest, most obvious behavior that
allows the application to recover. In this case, that sounds like
option (a) and restart.

In practice, the common use case is to allocate enough user memory to
read an entire table in one go, in which case the entire issue is
moot.

The cycle savings of dump are significant for large tables. I'm not
sure how we achieve that differently and even simpler? We originally
looked at shared memory, but that is obviously much more complex.
