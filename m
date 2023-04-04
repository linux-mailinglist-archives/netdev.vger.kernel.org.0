Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7248B6D706D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbjDDXLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjDDXLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:11:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B659F3AB0;
        Tue,  4 Apr 2023 16:11:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50263dfe37dso6686a12.0;
        Tue, 04 Apr 2023 16:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680649887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2FBAJxXkoaN/CPYOJ6A/KDIsU0bsPXeU+iokgEep4Q=;
        b=QNWAMIeZOH7EfbE/re5Q6Aee7PrFDsr1NGbvNvZpL7St/SBX1ofpR2LTTTjsMr5iq0
         w/Uit7xfMeLOXQTNBhKfQW2ic2Hx7FmIRfCYD1CcsCdQ3OhKNyC0c3Wh9wn7yVWWxCpe
         ywW9mjTYLMndYw9DrzzIs/Nfgy5Zu3J4xVMw/U+z9YEjrOD1XceVTWWc1Z1Jt+j/FcHC
         8gpmtFlrblaJgXR374G1yMVFdhNPvAeZR75pNf874qmIEHF5xVcXO32c8uPl04ZPB9f9
         kt7XXqVYCuyqzlIf6AyE/8OrtlDrlxmwolpwrTxcxCSnwQODPobDYAWetEDeD6SKqfxZ
         1/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680649887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2FBAJxXkoaN/CPYOJ6A/KDIsU0bsPXeU+iokgEep4Q=;
        b=r8Jb6FWr5gjNLBSO/jYO4Ey+aPtGTCOdh9hXFid4gqhv/jxX3Ow3IH7f3fYWeVN30Y
         AZxSwi14TGqK2Xuvc+cqyL0UDoECektpKTbtPXldFOlmF+RSo0/EK1L6de58s7jpKpb0
         Pq/3e7oFXfHpI/h7kB6obQ3tTirSYfl1XSQr9HT5VL29jw52/KaPnfunmQjheEzJpNsF
         5B3ZlG+LmnqL2sxeRA7/0caxVFS/5a4r0IXPyLSR3xQVuju4Ajt8MTnyMnJF+AkGuny1
         UBz1yVrQeXnfRxqEJIrUz1bTjySnJsJXdUVkYSFFH3obuf/FVYVQICQV4+VOYma73HgK
         IgtQ==
X-Gm-Message-State: AAQBX9dMCmpIjDlJZYsmNzsBplDFJQQ7/AMqixU3q1UW/zW+O7WsYA8p
        ktvgoH0P6fim9Sxuuf85ZjoZNuKEbWCZhBnGws6KDRan
X-Google-Smtp-Source: AKy350YdkhKI41rRfN7/LeABTxQH0sOsIhv95qomzVUoN+YvUur3B8FKyTYN6DB2I4gO99IZmRqH25NbLbb9Na2xEbc=
X-Received: by 2002:a05:6402:2744:b0:502:6e58:c820 with SMTP id
 z4-20020a056402274400b005026e58c820mr4829edd.1.1680649887215; Tue, 04 Apr
 2023 16:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230403120451.31041-1-kal.conley@dectris.com>
In-Reply-To: <20230403120451.31041-1-kal.conley@dectris.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Apr 2023 16:11:15 -0700
Message-ID: <CAEf4BzYO0fsyUsLHe0t9yuw+BWaBJrvGBgBw213BpLNif=SOTw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: xsk: Disable IPv6 on VETH1
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Weqaar Janjua <weqaar.janjua@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 5:05=E2=80=AFAM Kal Conley <kal.conley@dectris.com> =
wrote:
>
> This change fixes flakiness in the BIDIRECTIONAL test:
>
>     # [is_pkt_valid] expected length [60], got length [90]
>     not ok 1 FAIL: SKB BUSY-POLL BIDIRECTIONAL
>
> When IPv6 is enabled, the interface will periodically send MLDv1 and
> MLDv2 packets. These packets can cause the BIDIRECTIONAL test to fail
> since it uses VETH0 for RX.
>
> For other tests, this was not a problem since they only receive on VETH1
> and IPv6 was already disabled on VETH0.
>
> Fixes: a89052572ebb ("selftests/bpf: Xsk selftests framework")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---

Can you please resubmit with [PATCH bpf-next] tag, so BPF CI can test
it against the bpf-next tree. Thanks.

>  tools/testing/selftests/bpf/test_xsk.sh | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/self=
tests/bpf/test_xsk.sh
> index b077cf58f825..377fb157a57c 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -116,6 +116,7 @@ setup_vethPairs() {
>         ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer n=
ame ${VETH1} numtxqueues 4 numrxqueues 4
>         if [ -f /proc/net/if_inet6 ]; then
>                 echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
> +               echo 1 > /proc/sys/net/ipv6/conf/${VETH1}/disable_ipv6
>         fi
>         if [[ $verbose -eq 1 ]]; then
>                 echo "setting up ${VETH1}"
> --
> 2.39.2
>
