Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6957660B5B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 20:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfGESVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 14:21:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38623 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfGESVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 14:21:38 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so20941766ioa.5;
        Fri, 05 Jul 2019 11:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYjI45C/kSSnCkFWasS9QKkJFPdOec67q3drkdn8VJQ=;
        b=gRj9k6BqhPCX93fTsAbVVnqfLZISsRapMdd8BqIZ/v/Ih8mW27koJ88uoiA0B5Ev9y
         jmolrmGiMU9/Y7k6wtCCYauVFyPrDAg5zCVUHk6TB75W3uH1r/VmeMmNs/M9gU4/cfda
         Lz7eFMBlg1bONid875t1LG90yqF8LRqc2M+QD9VXGywBjoQ+Gm8K+dhi4Ts+VLg2AAiK
         zFqMJjKBdHIZGCnmnt55t0NuOJOZkgUKMSwKNW3PG6Nnw+I7NMDOJ+vgpZ9p/0ss+MUl
         d+LEYgzNaDwmYag0lCD0W8tTm9BlhC6dk29893YiFiWK0n3JN70re8jP3VwRh12s5xkE
         BO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYjI45C/kSSnCkFWasS9QKkJFPdOec67q3drkdn8VJQ=;
        b=gFalxrDCbuYa7ZXHk1sV9Jh7d3su841tyVeMmBkhHB1xGn22avSwask9j+uX5rFaD0
         pFZwHrx+mwkPgu6e4VjVKNxCILLdmFIrsHPgX3HOue8+ngE7wQP38nkjkgqSPFg03ZP3
         ICeDIF08MUzot4fio0O2rKicLUnnJ9/X78ohFcBXZmwvgNq2Aqk1DdSxt8FIJKUuEklO
         4I52q69XJq44UpfMaoNE6myiLLUN5X7yDrrJ7NxgKnM3MkXj5J9fKz0wN/TrgyVUv2OU
         P0wpN1Vyr1CVF2NPv/gOO1ySr4YapbjuJPARB+vARB635UHdFFFS2qlzeOZ9HNWdeOEy
         MPTg==
X-Gm-Message-State: APjAAAX24Ah13GFCVu0eAXZYLjLqXJbp005aTuufoH2KKsIgb73AGLku
        ZNIhRTjniWomztEXR5ip/oqJQqlEbjYjhsBFc1I=
X-Google-Smtp-Source: APXvYqzFXjKle9f3XwdReydVJAMWWRYnsHEwpFUA87CNJCi2Ti1GtXoyUA2Lh9GbTVnpdn9vgf923zGzl5V8JD5gtW0=
X-Received: by 2002:a05:6638:199:: with SMTP id a25mr3546599jaq.18.1562350896952;
 Fri, 05 Jul 2019 11:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190705175433.22511-1-quentin.monnet@netronome.com>
In-Reply-To: <20190705175433.22511-1-quentin.monnet@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 5 Jul 2019 11:21:00 -0700
Message-ID: <CAH3MdRVFhWfNLjQfgTLbmxL6gO42Rj2g9AcwJ1be6WLPDPxtRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] tools: bpftool: add "prog run" subcommand to
 test-run programs
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 10:54 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Add a new "bpftool prog run" subcommand to run a loaded program on input
> data (and possibly with input context) passed by the user.
>
> Print output data (and output context if relevant) into a file or into
> the console. Print return value and duration for the test run into the
> console.
>
> A "repeat" argument can be passed to run the program several times in a
> row.
>
> The command does not perform any kind of verification based on program
> type (Is this program type allowed to use an input context?) or on data
> consistency (Can I work with empty input data?), this is left to the
> kernel.
>
> Example invocation:
>
>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
>             pinned /sys/fs/bpf/sample_ret0 \
>             data_in - data_out - repeat 5
>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
>     Return value: 0, duration (average): 260ns
>
> When one of data_in or ctx_in is "-", bpftool reads from standard input,
> in binary format. Other formats (JSON, hexdump) might be supported (via
> an optional command line keyword like "data_fmt_in") in the future if
> relevant, but this would require doing more parsing in bpftool.
>
> v2:
> - Fix argument names for function check_single_stdin(). (Yonghong)
>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Yonghong Song <yhs@fb.com>
