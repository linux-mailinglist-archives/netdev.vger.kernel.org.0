Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F241128194
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLTRoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:44:55 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38219 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:44:55 -0500
Received: by mail-qt1-f193.google.com with SMTP id n15so8885348qtp.5;
        Fri, 20 Dec 2019 09:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXioLGJ/HOo+TcdumPwT8VxWceb6rylqhibjXYXAy8M=;
        b=trk+heeZMkwa9yGualln6us4653B6hoINKyYjXJSwzqQyWIY5apdUdREy6BJw436fP
         PQ1TWaTBtZft+w3k/akSpHms8QJKk/ngcagXRVTe86INsYqU6AhUN7RyfBr8DUzzlqHd
         FazLYF0vAeYcnKPcZq1iOa0lke/6knPTwE51WpM8Zb7swn9vq4COOZfsCL43vB/jOBx8
         Y+1Ulks9x4PGKTqMVeOGAoUO3Hhx7EvM7+BtbLgFxcVgCxZOUZMNDK0E62FiivmBSpUj
         QbNlVBjYBaYng1I+orZhlneTjcH25x02AuVqOEXrPjAfZx/ZRYfxbotDY1VjBbK5fwAW
         CbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXioLGJ/HOo+TcdumPwT8VxWceb6rylqhibjXYXAy8M=;
        b=Kldrxn2oGIO4fkPB00RhIGhujz89075u9/3kIwwE6TtRy7Z9rpVsu/nHzPbRZA/zc0
         PHmaT/Dm5+a2TXUDT+jdLB6U2+xdmHeefgm6adPmSTPaRh7wv42TtJxKzLVMuIYjhAGl
         OxddhfTREzhtifdPPiHHQdExH6IWTzYNxw637mQKNczdW8E7fEUy2zL8jp6Xf+FT5Bzq
         Dobeto8FCtNpvIO2zJo3IsGMXAfFBHm6pr/6jyT2WIf7vofPcbg8nbtGtVv1iJNdWGOl
         natYEONTcFwJQWfdSp/m7NQYtmM+jBuCeWiCBakX1Jh5kL7GZLFJ+NHUhAu7Ztl0T7pI
         JoqQ==
X-Gm-Message-State: APjAAAUFOwtaihngJYES1siFcRplOiHjRyqZAsUg6qM7mBw57JC3T+N7
        poJ3Z8XAHvWNkX5UoUikmi7+sEdYz0CzN/ZwSQk=
X-Google-Smtp-Source: APXvYqzKL3BW/Ztf/c+tlhipMeX2437hmDhFBidGE96aV6lDpkX6C0sIPitlxPKJLpZZG3R6bpQLclsuhx9Njx0LlbA=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr12337997qtu.141.1576863894000;
 Fri, 20 Dec 2019 09:44:54 -0800 (PST)
MIME-Version: 1.0
References: <157685877642.26195.2798780195186786841.stgit@firesoul>
In-Reply-To: <157685877642.26195.2798780195186786841.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 09:44:42 -0800
Message-ID: <CAEf4BzbnL43Dka+qsTmUYvEnqSHOS72J+eE1qOnHCQdMAkR4Zg@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: xdp_redirect_cpu fix missing tracepoint attach
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciek_Fija=C5=82kowski?= 
        <maciejromanfijalkowski@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 8:19 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> When sample xdp_redirect_cpu was converted to use libbpf, the
> tracepoints used by this sample were not getting attached automatically
> like with bpf_load.c. The BPF-maps was still getting loaded, thus
> nobody notice that the tracepoints were not updating these maps.
>
> This fix doesn't use the new skeleton code, as this bug was introduced
> in v5.1 and stable might want to backport this. E.g. Red Hat QA uses
> this sample as part of their testing.
>
> Fixes: bbaf6029c49c ("samples/bpf: Convert XDP samples to libbpf usage")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/xdp_redirect_cpu_user.c |   59 +++++++++++++++++++++++++++++++++--
>  1 file changed, 55 insertions(+), 4 deletions(-)
>

[...]
