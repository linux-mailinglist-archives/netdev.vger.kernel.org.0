Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02A197128
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 01:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgC2XxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 19:53:12 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45975 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC2XxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 19:53:12 -0400
Received: by mail-qk1-f193.google.com with SMTP id c145so17234357qke.12;
        Sun, 29 Mar 2020 16:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=muZcqdyzC4F2pH+3BqIiv8M4ZN/NKrjPmBvgSSUPEzs=;
        b=WDpTWaJVpx6haC2JHHaVwSATWPRuG3ccoGvqioTHIWmhqaDcyf64uCHtVsyX0GRS7e
         uRTrnpl3I5kuVgwolOfiVq7ciyC61SZZiP6uIvoQIoTYqPJxw7X+x0URYnBpynF0B1ZU
         h6fNueb/k3ZqCi1hnrAPsohfDSw1FHYXs8vVbfPrBkPLBzHIHy9zjpXwnCIlHwZa8BHQ
         Al6wGuY/49K2qBR1Fm7fhRV35nyeUDR5LmCzPmfL5QXETxiZHntKQNus/6KfYMlA24rl
         hh9MvQj/gXd7F2ZCbeaNqxECLCEnHqPEjEYIOwvgU2uDR3GrkNsGtxK3ipklshZUeTEM
         ONvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=muZcqdyzC4F2pH+3BqIiv8M4ZN/NKrjPmBvgSSUPEzs=;
        b=aD+yKGukYM2PSQ5yMQZQXq5smBfoeluJw8q41atHX9VWT7KkXh8xF/8FRqVvl1EER6
         mNiooBodWH/OBQlBhBxlp0BvKYRa+tN7Mdolx/hXUDs2gmUemB+KSNPFqfXMAZyczUcA
         e7+Efx4AlcywFjIWqHRqV0NrrgKLu+kTdCA9D9bLlQyoehSao+tGRt0Nn2R5oA5fUO0S
         3qHW9g/Oo/cqO9BHx8zFBGxdOJFtN5FOwUCO32r5m6UtysyjZfd6D3jc1N9bhYNDh6VB
         x6i2JudjAe32nwc/1WLS3so8e/iBIond9hJLgcz/Xdfm4j9Te8robRI9Cha4LIRyI9oD
         GgsA==
X-Gm-Message-State: ANhLgQ1TA4RjrS2swB8/9hLyILiulKAFWgxERJr3iz5rx+9coJQOwSYo
        WSjMPegCKaD/Wp52JSz84RzrdIFnlknRATD1scU=
X-Google-Smtp-Source: ADFU+vsnY1ZMlbviv8qiXoRPyVBuIqEo7zFGugNVxLExGfLzIYeVaeb0zjr+CJlghzLLuOA9ktXTZSGNwempB1i5K1I=
X-Received: by 2002:a37:b786:: with SMTP id h128mr5827140qkf.92.1585525990818;
 Sun, 29 Mar 2020 16:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200329231630.41950-1-eric@sage.org>
In-Reply-To: <20200329231630.41950-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Mar 2020 16:52:59 -0700
Message-ID: <CAEf4BzY_s_2YHgrbNzVPTC6qtVXmz9LvVPtZcw1AWSffi8aYtQ@mail.gmail.com>
Subject: Re: [PATCH v4] samples/bpf: Add xdp_stat sample program
To:     Eric Sage <eric@sage.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 4:35 PM Eric Sage <eric@sage.org> wrote:
>
> At Facebook we use tail calls to jump between our firewall filters and
> our L4LB. This is a program I wrote to estimate per program performance
> by swapping out the entries in the program array with interceptors that
> take measurements and then jump to the original entries.
>
> I found the sample programs to be invaluable in understanding how to use
> the libbpf API (as well as the test env from the xdp-tutorial repo for
> testing), and want to return the favor. I am currently working on
> my next iteration that uses fentry/fexit to be less invasive,
> but I thought it was an interesting PoC of what you can do with program
> arrays.
>
> v4:
> - rebase
> v3:
> - Fixed typos in xdp_stat_kern.c
> - Switch to using key_size, value_size for prog arrays
>
> Signed-off-by: Eric Sage <eric@sage.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  samples/bpf/Makefile          |   3 +
>  samples/bpf/xdp_stat          | Bin 0 -> 200488 bytes

Add xdp_stat to .gitignore?

>  samples/bpf/xdp_stat_common.h |  28 ++
>  samples/bpf/xdp_stat_kern.c   | 192 +++++++++
>  samples/bpf/xdp_stat_user.c   | 748 ++++++++++++++++++++++++++++++++++
>  5 files changed, 971 insertions(+)
>  create mode 100755 samples/bpf/xdp_stat
>  create mode 100644 samples/bpf/xdp_stat_common.h
>  create mode 100644 samples/bpf/xdp_stat_kern.c
>  create mode 100644 samples/bpf/xdp_stat_user.c
>
