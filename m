Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D258512306
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiD0TsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbiD0Trz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:47:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729AD41333;
        Wed, 27 Apr 2022 12:42:49 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i20so2708497ion.0;
        Wed, 27 Apr 2022 12:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vfg73oyluXpxOQB2fOlxh19EAShpjxZ8ZY0CGGydxjM=;
        b=g+Bvv3lNI8BD8ycaCTImlls3hRGqGNLIK7B1EGmMgUTAWc/CEex9IvEuEOrQKPwEYz
         NtD2y2wZ77QpvcnE7fQp7XOmLlkfa7psPAo3vXs0QH0AOQ6FHiKqVUzJXlOLsKugZ6iN
         bEMrsEmD5giEPY6q+2G0iIz6fZMdjLOTigk8zWmSiSRrFNh0sdDKHWAFbo7R8FouD1Ir
         9ojtCpsduQMkGGjqV9dyBmTXe7AI7wLroEckZdCrlCSrGVTf3SjyE1OpdV2ieuUatw47
         IHsQxfhvSqv9y1wv1V2aVv+YzyTqaTjS/6uEhSzBgHW0AKrZjsh75n4wmTy7eGJdXqkB
         emkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vfg73oyluXpxOQB2fOlxh19EAShpjxZ8ZY0CGGydxjM=;
        b=iHjoydcTd5azjQfjQJe3MZ4Ss82PNxZUSiB3f3qL4kRY6c97yfNV8K/fDo2aFeTRKn
         uNzTlGq2WJGyE1+eSZIOBfqp0oAzEbf2LnOsXmneWGsKExxGGZJUa1vMCzvE7asaeSO7
         XlayeBcvhS7RZvCbYKKyQEzFfN+hIxogopFoIKGvAIoAac3b7hlZtaJgBFU/R/SH6adt
         sp49iZ2XyZ1Yc5Jfl65LkJ16zJg4wTWDuDpZJz7KvaEhO8frv5d55d5MhuRYSH/kAXvs
         u2U39/V/1AMhAxXA4F2DKL0mHtjt+ZzvYVaJh3Sf8uddKdck4UiW+9sIJfuGj2PStA3f
         7sHQ==
X-Gm-Message-State: AOAM532Fb1tfVdrAVI4opl85/e8qOpcIf/xUmCBUxv4bd54475DW4iNw
        HKQhln0NJQfjK89xOaEdxKCD/q5twPMjBzip1M0=
X-Google-Smtp-Source: ABdhPJxxt+kNVZnM+u1yaMCqk9iI8N4YGCihHBSm3t6sN8UE64Xw+ROXO8f+Bb3mxZ2G2FBfTGIR3kXA6zJVC42cWeQ=
X-Received: by 2002:a05:6602:1683:b0:64f:ba36:d3cf with SMTP id
 s3-20020a056602168300b0064fba36d3cfmr12191382iow.144.1651088568808; Wed, 27
 Apr 2022 12:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220424165309.241796-1-eyal.birger@gmail.com>
In-Reply-To: <20220424165309.241796-1-eyal.birger@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 12:42:38 -0700
Message-ID: <CAEf4BzakwPD-63UGUekpSSxy+KordBf2Hs5+bqcFkyzv8y7YOQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test setting tunnel key from lwt xmit
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, posk@google.com,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 9:53 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> This commit adds test_egress_md() tests which perform a similar flow as
> test_egress() only that they use gre devices in collect_md mode and set
> the tunnel key from lwt bpf xmit.
>
> VRF scenarios are not checked since it is currently not possible to set
> the underlying device or vrf from bpf_set_tunnel_key().
>
> This introduces minor changes to the existing setup for consistency with
> the new tests:
>
> - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
>   TUNNEL_KEY flag
>
> - Source address for GRE traffic is set to IPv*_5 instead of IPv*_1 since
>   GRE traffic is sent via veth5 so its address is selected when using
>   bpf_set_tunnel_key()
>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>  .../selftests/bpf/progs/test_lwt_ip_encap.c   | 51 ++++++++++-
>  .../selftests/bpf/test_lwt_ip_encap.sh        | 85 ++++++++++++++++++-
>  2 files changed, 128 insertions(+), 8 deletions(-)
>

[...]

> @@ -73,6 +77,7 @@ int bpf_lwt_encap_gre6(struct __sk_buff *skb)
>         hdr.ip6hdr.daddr.s6_addr[15] = 1;
>
>         hdr.greh.protocol = skb->protocol;
> +       hdr.greh.flags = bpf_htons(GRE_KEY);
>
>         err = bpf_lwt_push_encap(skb, BPF_LWT_ENCAP_IP, &hdr,
>                                  sizeof(struct encap_hdr));
> @@ -82,4 +87,42 @@ int bpf_lwt_encap_gre6(struct __sk_buff *skb)
>         return BPF_LWT_REROUTE;
>  }
>
> +SEC("encap_gre_md")

This is not a section name that's supported by libbpf in it's strict
1.0 mode. Please update all SEC() definition to be compliant. Is this
SEC("tc") case?

> +int bpf_lwt_encap_gre_md(struct __sk_buff *skb)
> +{
> +       struct bpf_tunnel_key key;
> +       int err;
> +
> +       __builtin_memset(&key, 0x0, sizeof(key));
> +       key.remote_ipv4 = 0xac101064; /* 172.16.16.100 - always in host order */
> +       key.tunnel_ttl = 0x40;
> +       err = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
> +                                    BPF_F_ZERO_CSUM_TX | BPF_F_SEQ_NUMBER);
> +       if (err)
> +               return BPF_DROP;
> +
> +       return BPF_OK;
> +}
> +

[...]
