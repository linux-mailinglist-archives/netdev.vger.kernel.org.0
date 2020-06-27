Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40D20BD86
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgF0A7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgF0A7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:59:53 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AF8C03E979;
        Fri, 26 Jun 2020 17:59:53 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h23so8938057qtr.0;
        Fri, 26 Jun 2020 17:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KelEjp51gNhK+B+8e+wjW97bx3pRRdg5YUU9mIo3lWM=;
        b=L3V9tcnEoIa3viM94JOgveFzjGWwYqb5/CAknv66c/boxh7n7ONvFGgLEadOZbkwgN
         PuuGYPCliPIOIYwHnoZpBth2HCyoO+ibzo/MyOlSSAByeZV9sWymBi7ih5jX4zYooEBE
         s0YyV9xY/aHeUfeH/EIiG0G8/lKiahLOwZjTIs4AaQG7/Pf8EBOZTCrmjK83rTtLD555
         fmC/5LiSBBX5ZyTg+UMVsGGG+YxDmCxh/qbuocSFMZeHg83TLCzAPEB0MBeq4Xpxxsl7
         N8EbK96MelPBnUIPdESq0DXngAxIHL+JO9ObNNmvSrokbj6IeyTYt0WogV6jsw7x0XoE
         HVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KelEjp51gNhK+B+8e+wjW97bx3pRRdg5YUU9mIo3lWM=;
        b=h99tdE0HjNJHPKQrTVNklYOFRELky3Fr3CO35T/Gj2LZWfytQU5w8X6XFl1MttvnC/
         RUHCHcRW65SlyLQvMCjnv2TgW5wbJckGtefjYD3+DjVoDue7jYlNgAYlyGwqQkE98pQa
         N4wbqJRqoSiZ1PS3gjTAJitzuoFUwAGXM1He7tfYk7gvLuzvQOduEBoQwhTcqsxWSY4Q
         G3MhLLlSXF6AR+FOTQGV2d8wgELjXUoiLmH7THUUDKss3nxex8vNt0sYNRGDvjTqEnRu
         QZ+y6K8iuL6269DyD7rjH/rB9t9C3HtQIpCkmwEAJMELDa0QGOPEBqa0Wd/HBeYx7WF5
         7+6Q==
X-Gm-Message-State: AOAM533wniE1WOy89XkVHdVi6vZ5yMMOrM5XUwlAX/VMmx2avUPpxWMZ
        MoMPYXTw8n80j6+4QLR9E60bCZe6H+WQdrArOXk=
X-Google-Smtp-Source: ABdhPJwPbzsnZ6DouuK5x2mMIcYGk+yIaHVvdpDAkkjxIqGh64oIzH1iQzZGSxC6ReFzU8Vfovkjq5hLEYNiQmMhmGY=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr1332202qtk.117.1593219592501;
 Fri, 26 Jun 2020 17:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200626165231.672001-1-sdf@google.com> <20200626165231.672001-2-sdf@google.com>
 <CAEf4BzYWUZhgK-XpOxV76bzk1pnVzKgyu3AtCRtdVbW2ix4D7A@mail.gmail.com> <CAKH8qBtaEWJPFWGqXuZzz8ymOCxwK1NWdrstvj7g2Z3z2khh_A@mail.gmail.com>
In-Reply-To: <CAKH8qBtaEWJPFWGqXuZzz8ymOCxwK1NWdrstvj7g2Z3z2khh_A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 17:59:41 -0700
Message-ID: <CAEf4BzZxasCcvrT2fQ9szXe6TjFwPGiv9vsGOjPJdKcozn70XQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 4:52 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jun 26, 2020 at 3:08 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jun 26, 2020 at 10:22 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Add auto-detection for the cgroup/sock_release programs.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> >
> > Left a bunch of comments on v1 of this series, oops.
> No worries, there is not much changed since then, thanks for the review!
>
> > But where is the cover letter? Did I miss it?
> I didn't feel like it deserves a cover letter. The main patch is
> small, most of the changes are in libbpf/selftests and I mostly split
> them to make it easier for you to push to github (is it still a
> requirement or I shouldn't worry about it anymore?).

It's not a requirement, sync script is pretty smart about all that, so
no need to do it specifically for the sync purposes. Still a good idea
to have selftests separately, IMO.

As for the cover letter, unless it's some trivial independent fixes,
cover letter ties everything together and is a good place to track
"what changed between versions". So I'd recommend adding it anyways.
