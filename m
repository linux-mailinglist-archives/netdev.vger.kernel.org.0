Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD216809BC
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 08:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfHDGwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 02:52:54 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37700 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfHDGwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 02:52:53 -0400
Received: by mail-io1-f65.google.com with SMTP id q22so41268564iog.4;
        Sat, 03 Aug 2019 23:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLECg9teQ0cKlRjb3FgpXIcLlpfHxOQRrARpjQ9WQs0=;
        b=KdMEqQB+vQxoKeYwU0NEH9zo0HI3Bp2/egvH/7zKOrhq0ruR9uQyGJcb5k7z1KTiUo
         qgi/vH1YopnOv21vXbUs8U2nF3ftHRH98CWIyaHgJK8VrtVsWVJmXOD9cOY+iJID3bsH
         5fFZOecf+fM7QOyCo5vZPjXsGfwoDyCuFhp9snHoeGNJu9mtoFFqsKQbXclKlxHuCWiT
         Swvg1vzbT3clPkHSHXQi1Upr7vBAsJ8tJ7n0T5+Awq1FtQurAcE112Dj9jQAc6TunC54
         JpAaZL23xlDl6CAuFpf4SS3fvEgiBSM5mIlqz/r1nnZWU179eaOg1bfSABoQ+P1Vz9Rl
         K7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLECg9teQ0cKlRjb3FgpXIcLlpfHxOQRrARpjQ9WQs0=;
        b=jVY1feaU1G4SQAOlA9T6ZS/k2f1CdDCEjbaQovuTZ7NCQzE9KllQNCr61F4jiau+/A
         Db+6nUoqVV3RExmFeBQifizqXOLc2zM0S6hWmCKl3fHRqUXEpOU7dkk859WrjWAZCFAl
         WF0UQN+devKsfUXjrshcNsBQFDb2CoJ4kfTisy7SJB/a2gXrRZXOb5FlQGMz93/EvewT
         uG4T6tiAteyLD2zyC16gq9+llsTn9L0YU/gPcwjiHsuMuxctYmyrZoTiV9Hsphn+f5ne
         rdXIkAv+hZTaJThYmQvGdmqKUpgmo0lJINd0vquEPbO0rQNS86Ff/HvcFrLbwxE5s9Vo
         YnaA==
X-Gm-Message-State: APjAAAVNfbLuHBQH0cwPTktyRpYu/wrbushyZiLeNy9VTkDwIPlGmZtl
        9BM0Ndz+j0e7VK2akB2r7Vzn2K/1GXNlTXo3WYkoRVra
X-Google-Smtp-Source: APXvYqziOUBnQyX6n71woU+Fe//DRiYLi3mLgUkvt/TXTZyItXi8eOqVyDewr/1babN2XzlLBgfsSkjKXyQwyhk1xTs=
X-Received: by 2002:a5e:aa15:: with SMTP id s21mr3983687ioe.221.1564901572602;
 Sat, 03 Aug 2019 23:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com> <20190803044320.5530-2-farid.m.zakaria@gmail.com>
In-Reply-To: <20190803044320.5530-2-farid.m.zakaria@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Sat, 3 Aug 2019 23:52:16 -0700
Message-ID: <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
To:     Farid Zakaria <farid.m.zakaria@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 3, 2019 at 8:29 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
>
> Foo over UDP uses UDP encapsulation to add additional entropy
> into the packets so that they get beter distribution across EMCP
> routes.
>
> Expose udp_flow_src_port as a bpf helper so that tunnel filters
> can benefit from the helper.
>
> Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
> ---
>  include/uapi/linux/bpf.h                      | 21 +++++++--
>  net/core/filter.c                             | 20 ++++++++
>  tools/include/uapi/linux/bpf.h                | 21 +++++++--
>  tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
>  .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
>  .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
>  6 files changed, 131 insertions(+), 8 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c

First, for each review, backport and sync with libbpf repo, in the future,
could you break the patch to two patches?
   1. kernel changes (net/core/filter.c, include/uapi/linux/bpf.h)
   2. tools/include/uapi/linux/bpf.h
   3. tools/testing/ changes

Second, could you explain why existing __sk_buff->hash not enough?
there are corner cases where if __sk_buff->hash is 0 and the kernel did some
additional hashing, but maybe you can approximate in bpf program?
For case, min >= max, I suppose you can get min/max port values
from the user space for a particular net device and then calculate
the hash in the bpf program?
What I want to know if how much accuracy you will lose if you just
use __sk_buff->hash and do approximation in bpf program.

>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4393bd4b2419..90e814153dec 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2545,9 +2545,21 @@ union bpf_attr {
>   *             *th* points to the start of the TCP header, while *th_len*
>   *             contains **sizeof**\ (**struct tcphdr**).
>   *
> - *     Return
> - *             0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
> - *             error otherwise.
> + *  Return
> + *      0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
> + *      error otherwise.
> + *
> + * int bpf_udp_flow_src_port(struct sk_buff *skb, int min, int max, int use_eth)
> + *  Description
> + *      It's common to implement tunnelling inside a UDP protocol to provide
> + *      additional randomness to the packet. The destination port of the UDP
> + *      header indicates the inner packet type whereas the source port is used
> + *      for additional entropy.
> + *
> + *  Return
> + *      An obfuscated hash of the packet that falls within the
> + *      min & max port range.
> + *      If min >= max, the default port range is used
>   *
>   * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
>   *     Description
> @@ -2853,7 +2865,8 @@ union bpf_attr {
>         FN(sk_storage_get),             \
>         FN(sk_storage_delete),          \
>         FN(send_signal),                \
> -       FN(tcp_gen_syncookie),
> +       FN(tcp_gen_syncookie),  \
> +       FN(udp_flow_src_port),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5a2707918629..fdf0ebb8c2c8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2341,6 +2341,24 @@ static const struct bpf_func_proto bpf_msg_pull_data_proto = {
>         .arg4_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_4(bpf_udp_flow_src_port, struct sk_buff *, skb, int, min,
> +          int, max, int, use_eth)
> +{
> +       struct net *net = dev_net(skb->dev);
> +
> +       return udp_flow_src_port(net, skb, min, max, use_eth);
> +}
> +
[...]
