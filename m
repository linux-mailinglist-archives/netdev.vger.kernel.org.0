Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA9737BC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGXTUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:20:16 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44607 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXTUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:20:16 -0400
Received: by mail-qk1-f195.google.com with SMTP id d79so34572559qke.11;
        Wed, 24 Jul 2019 12:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jf56Nz05DOfwnERFUQkN8u7zsx4IFXTKejoTcl/rv6g=;
        b=kRCjPwpl3KV5JZ+jG9MW4RJlkRN421VxJjYbdreISYCOhxnOSwdD3ALzdA46vTmRly
         b7nqIstNMJQ8CAU19gYGlCqHwmsvkmk1UjR7qooCEt4iAV10ShQ0azpC72pD39vNnuyw
         5afkxEf2fctjRwkGzb7B1lKceftIqafcwVp1PR7d4PYfUGHL6zbknxbTJ1u+/fugQQQO
         S2R41s1q5jD1aKjbRJZoPherbeKwf4gyxVXnNxa5E6CyqtACUL4DLzQP6rWZiJ5W+UiS
         cdZ3IoAO7d2aR5yy0LtprKyxfFDvJvIoqAOBoX+h6zc0t3KdqN9/AXbhVBLEdJSakywZ
         sYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jf56Nz05DOfwnERFUQkN8u7zsx4IFXTKejoTcl/rv6g=;
        b=nYv/2C/FAZbQ9UysrJ366yOSvWKuqog3yU3yb8IzEEGRVJ/WmYQrPvfaFchK4bn8Yp
         l513bnQnyocfcLWOINoSXj58ViRT6AD7Z9eL6OXflRW5K4sbcFlACTQVZBovdYh+Ev9W
         Mqco9WqPDRlf6qcjMO8clOEGxYjTGugvNzsa8DSUVpyjOxO3299b00WmdrWmC90xt//u
         nKNMqvbb1xE6xPq1j0bfJTOfKaTclSTpmCBWa41XGTzUHyBesMb6m+WRa/YKZbgI5I8r
         ttHvGD69XkTsMBsqcPVvPipO7cjC0uZGkqLW84kcDYbVOWAagl/OwMw7J4+1ntpQ2/JJ
         1Uzw==
X-Gm-Message-State: APjAAAUWbHeoaN8ovk49SU+bjjnSYY1BDZefEG7PxYfkT3hJnYgpJugn
        QiI9XmQme882WyXYav7WZwWLjXTOcdTMH7Knbo8=
X-Google-Smtp-Source: APXvYqzU4aF1odzauC1/uuwbOPhg53aT8eaLMEi5QIzUZ//jTHnOwWUL6n9AYED8ykJtlRJ2izUgfx4GAeL/H9YNj14=
X-Received: by 2002:a37:a854:: with SMTP id r81mr56278918qke.378.1563996015218;
 Wed, 24 Jul 2019 12:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com>
In-Reply-To: <20190724165803.87470-1-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 12:20:04 -0700
Message-ID: <CAPhsuW7PU1PP91e8vD2diwhBAwGJHWu6wAKOoBThT86f4r5OJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:09 AM Brian Vazquez <brianvv@google.com> wrote:
>
> This introduces a new command to retrieve multiple number of entries
> from a bpf map.
>
> This new command can be executed from the existing BPF syscall as
> follows:
>
> err =  bpf(BPF_MAP_DUMP, union bpf_attr *attr, u32 size)
> using attr->dump.map_fd, attr->dump.prev_key, attr->dump.buf,
> attr->dump.buf_len
> returns zero or negative error, and populates buf and buf_len on
> succees
>
> This implementation is wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
>
> Note that this implementation can be extended later to do dump and
> delete by extending map_lookup_and_delete_elem (currently it only works
> for bpf queue/stack maps) and either use a new flag in map_dump or a new
> command map_dump_and_delete.
>
> Results show that even with a 1-elem_size buffer, it runs ~40 faster

Why is the new command 40% faster with 1-elem_size buffer?

> than the current implementation, improvements of ~85% are reported when
> the buffer size is increased, although, after the buffer size is around
> 5% of the total number of entries there's no huge difference in
> increasing it.
>
> Tested:
> Tried different size buffers to handle case where the bulk is bigger, or
> the elements to retrieve are less than the existing ones, all runs read
> a map of 100K entries. Below are the results(in ns) from the different
> runs:
>
> buf_len_1:       69038725 entry-by-entry: 112384424 improvement
> 38.569134
> buf_len_2:       40897447 entry-by-entry: 111030546 improvement
> 63.165590
> buf_len_230:     13652714 entry-by-entry: 111694058 improvement
> 87.776687
> buf_len_5000:    13576271 entry-by-entry: 111101169 improvement
> 87.780263
> buf_len_73000:   14694343 entry-by-entry: 111740162 improvement
> 86.849542
> buf_len_100000:  13745969 entry-by-entry: 114151991 improvement
> 87.958187
> buf_len_234567:  14329834 entry-by-entry: 114427589 improvement
> 87.476941

It took me a while to figure out the meaning of 87.476941. It is probably
a good idea to say 87.5% instead.

Thanks,
Song
