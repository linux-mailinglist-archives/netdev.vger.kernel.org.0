Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF85A8F7CA
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfHPACw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:02:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40947 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHPACv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:02:51 -0400
Received: by mail-lj1-f194.google.com with SMTP id e27so3721148ljb.7
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 17:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lza6H1FoY4m6qqMayAfs0Hx3WiLWd4rPZ1lMI0/cOPg=;
        b=rVyV//ugz16khuZTT6UsGu/IDwxaPkuc5Z7xNm61cBfhNTfq7z7NSKkXUCDkcagRYd
         aKs6gAntP+rkghDfZR7BbPoTLIt7sgh8EHeKvmbGCd+HMvyEQ10GORSBWMqA9A0WYh+o
         C9xo4HYum4ybiSOR1fBn/j7WrZkQsfx5HaEpArtrsDmZhwRMY49p4kTu2GuvnVnGLJwT
         /c67vU7xlIQgWHAut02yuGGRj2UdlI403vqS1JkSytYMrJVSGhDqZL8phmnhYl9BfMO5
         EPViNM+/qnYu+Uj7wZiCKUxaEb7zdzTQejl7tBkhmrMmLpevxQCvyCb170BbONPVBY8d
         0zEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lza6H1FoY4m6qqMayAfs0Hx3WiLWd4rPZ1lMI0/cOPg=;
        b=pSm9P/sX7c7SDxUAxYyvGbvM3dkZZ5USSgn7b+FFlSmaz7yZUfES8e5Vgk4zKmbGub
         8oM4NhW76Gfmcb8pj8CitKho1dbHVJBIIs1989SyuFh9KymY7IYKJSFUZkAuPHXsP5zW
         rnD0ag0eGEeJUfULOrgvFfjFLWecmp02s3PvNjqY4hPMugWXwbJrjMkNDiYMpSF89ZqI
         unHlS3mCSmt5v9CfKoE1KdnYwXZHDUHKcJthfLgBooSDPARBCxMyf0Q4NPtV/OksIduF
         j7USfVzgei+B1Gse6eZ0XKpNgkd53MOgsvUnpZklPACAOC2KOg9kLikihe6h01xjc+xE
         AsaA==
X-Gm-Message-State: APjAAAWdNrNtIUCuYweWmJZvLmXUoEbZXdI9HFnxu4A1zbqK5Vmv6j6E
        9fkidWgWIEP/xIK35pEG7B7oxDuRNCVhrqqUqSw=
X-Google-Smtp-Source: APXvYqxZCHkkwQpfX7hjJFTcFR8uJH1G/3EJJ7Btoxc4C3WO4pAx3kbybrmcR0OWXpmLwPMq9NH1ANN3p1gYcoOAPTU=
X-Received: by 2002:a2e:89da:: with SMTP id c26mr3412507ljk.214.1565913769709;
 Thu, 15 Aug 2019 17:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190813024621.29886-1-danieltimlee@gmail.com> <20190813144303.10da8ff0@cakuba.netronome.com>
In-Reply-To: <20190813144303.10da8ff0@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 17:02:38 -0700
Message-ID: <CAADnVQLhFNCnhAoZPmtNCG8f8a+aTNRmBUuLgfrRW9qg4PTpmg@mail.gmail.com>
Subject: Re: [v5,0/4] tools: bpftool: add net attach/detach command to attach
 XDP prog
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 2:43 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 13 Aug 2019 11:46:17 +0900, Daniel T. Lee wrote:
> > Currently, bpftool net only supports dumping progs attached on the
> > interface. To attach XDP prog on interface, user must use other tool
> > (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> > can attach/detach XDP prog on interface.
> >
> >     # bpftool prog
> >         16: xdp  name xdp_prog1  tag 539ec6ce11b52f98  gpl
> >         loaded_at 2019-08-07T08:30:17+0900  uid 0
> >         ...
> >         20: xdp  name xdp_fwd_prog  tag b9cb69f121e4a274  gpl
> >         loaded_at 2019-08-07T08:30:17+0900  uid 0
> >
> >     # bpftool net attach xdpdrv id 16 dev enp6s0np0
> >     # bpftool net
> >     xdp:
> >         enp6s0np0(4) driver id 16
> >
> >     # bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite
> >     # bpftool net
> >     xdp:
> >         enp6s0np0(4) driver id 20
> >
> >     # bpftool net detach xdpdrv dev enp6s0np0
> >     # bpftool net
> >     xdp:
> >
> >
> > While this patch only contains support for XDP, through `net
> > attach/detach`, bpftool can further support other prog attach types.
> >
> > XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.
> >
> > ---
> > Changes in v5:
> >   - fix wrong error message, from errno to err with do_attach/detach
>
> The inconsistency in libbpf's error reporting is generally troubling,
> but a problem of this set, so:
>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied. Thanks
