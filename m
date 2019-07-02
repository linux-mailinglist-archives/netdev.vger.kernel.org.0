Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C905D5CA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfGBR6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:58:55 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36433 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBR6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:58:55 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so39208311ioh.3;
        Tue, 02 Jul 2019 10:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XWkgrgSWSvEB382TVJr+9otYDyoyLn6vaF7/6YN7q2w=;
        b=koRY99TrUjotOP0Rhkx/FiUr0KXQ0xfnidMB3ggdJwv3ymKmqhXLBq5MQ3+XD1S91T
         6IOpTs19e23rhvRXoMd0GDMuYeMCOkfvNU6tcdeZTuhPba1zy5GAZsVPatWI4M0lPEUL
         nICQE0gALfA3jFUaGCAzzWMLdBD/jKuKFyGyj44KM5x8NhFhFxJVfWlrnqFauHlVfmYE
         wzadzGxV+iFxLW9GZYhYfo4BF11PEbPSzhDdXE42JdNpJL+FD0kaP0bhQrkO0UmtQOCZ
         2wI9k0+/ebsFNjWoVAfo1lOXP0Z+eQ3pKSVoNvzlgb8Ho6Wv0j4OHXhgbSHmh5qgxU5/
         ifvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XWkgrgSWSvEB382TVJr+9otYDyoyLn6vaF7/6YN7q2w=;
        b=LSyn/0Wklamhv75I3TV9ciyRgpxhFmnlRDXmXPKz7H764TvGaKV1wrF42j34eAsVCY
         Wbt1BDFUHfh7xXklrQXTDXuJ4Og6cM/2RVkfCxZ1xg75lmR9MGHd7nghCpAyIzyQClqE
         xYz1Qsjc16o2d07D1dXmz7ARruEaMp4nbngHj5NMqWEJ+gHlwuTe0SMG6rgcYq7TMJg8
         GUIx7TQz0q2VDp6wdr/bFfcOxNo8QPrMxwMNfdRNqlwOdTzgFGkBT7WyjtjDfc8OrnSF
         bd1jdj/rG70mcCVQhps241xFG1CEEYV1mnhZ/qNXh+wJ+RGZ8gSPhQn41247eVIagEPi
         1x8g==
X-Gm-Message-State: APjAAAUFARmA8gqfaDiTk6XB10dRNO8ucPJnfTZ/+E/B/oo785n8Tl8a
        EF2wInkguEoIvzEExJU2CsYkI3Mq7FoRVl5b2laRTzItxsc=
X-Google-Smtp-Source: APXvYqwrlDr8bzXvNxUMBATmvDUrKvDJYMbt3C2la9UesyC0i+ALBAX37TUntO7AzcXBpJ0LpxElG9JlXg010tINtIA=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr6284203iol.97.1562090334581;
 Tue, 02 Jul 2019 10:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <bf60860191c7d4ab0f50fe3143f3d175bd6ee112.1562089104.git.jbenc@redhat.com>
In-Reply-To: <bf60860191c7d4ab0f50fe3143f3d175bd6ee112.1562089104.git.jbenc@redhat.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 10:58:18 -0700
Message-ID: <CAH3MdRWkErtRCDG6hLheEcpzo9baoP2LR6QJ31niGpvCCmV+Rw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests: bpf: fix inlines in test_lwt_seg6local
To:     Jiri Benc <jbenc@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 10:41 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> Selftests are reporting this failure in test_lwt_seg6local.sh:
>
> + ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
> Error fetching program/map!
> Failed to parse eBPF program: Operation not permitted
>
> The problem is __attribute__((always_inline)) alone is not enough to prevent
> clang from inserting those functions in .text. In that case, .text is not
> marked as relocateable.
>
> See the output of objdump -h test_lwt_seg6local.o:
>
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>
> This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
> bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
> relocateable .text section in the file.
>
> To fix this, convert to 'static __always_inline'.
>
> v2: Use 'static __always_inline' instead of 'static inline
>     __attribute__((always_inline))'
>
> Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  .../testing/selftests/bpf/progs/test_lwt_seg6local.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
> index 0575751bc1bc..e2f6ed0a583d 100644
> --- a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
> +++ b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
> @@ -61,7 +61,7 @@ struct sr6_tlv_t {
>         unsigned char value[0];
>  } BPF_PACKET_HEADER;
>
> -__attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
> +static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
>  {
>         void *cursor, *data_end;
>         struct ip6_srh_t *srh;
> @@ -95,7 +95,7 @@ __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
>         return srh;
>  }
>
> -__attribute__((always_inline))
> +static __always_inline
>  int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
>                    uint32_t old_pad, uint32_t pad_off)
>  {
> @@ -125,7 +125,7 @@ int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
>         return 0;
>  }
>
> -__attribute__((always_inline))
> +static __always_inline
>  int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
>                           uint32_t *tlv_off, uint32_t *pad_size,
>                           uint32_t *pad_off)
> @@ -184,7 +184,7 @@ int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
>         return 0;
>  }
>
> -__attribute__((always_inline))
> +static __always_inline
>  int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
>             struct sr6_tlv_t *itlv, uint8_t tlv_size)
>  {
> @@ -228,7 +228,7 @@ int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
>         return update_tlv_pad(skb, new_pad, pad_size, pad_off);
>  }
>
> -__attribute__((always_inline))
> +static __always_inline
>  int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
>                uint32_t tlv_off)
>  {
> @@ -266,7 +266,7 @@ int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
>         return update_tlv_pad(skb, new_pad, pad_size, pad_off);
>  }
>
> -__attribute__((always_inline))
> +static __always_inline
>  int has_egr_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh)
>  {
>         int tlv_offset = sizeof(struct ip6_t) + sizeof(struct ip6_srh_t) +
> --
> 2.18.1
>
