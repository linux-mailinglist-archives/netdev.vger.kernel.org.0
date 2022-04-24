Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CC650D3ED
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiDXR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 13:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235912AbiDXR0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 13:26:50 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8318C6F29;
        Sun, 24 Apr 2022 10:23:49 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2f7d19cac0bso21354617b3.13;
        Sun, 24 Apr 2022 10:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YP4CFWK7HD5zbQQCiHXFOxCd4gvriaqa4PSVAkwYD2Y=;
        b=J1B76Uc6W5H4i84tst6fK/J3fqrqroX17RTpUKxb5+lSi681fWSr7h2nuCVJRBju6e
         9x7rvOHsIGg23NBlKqw2IgEm5oaziaxxc9pPuSFciMDCCuncjy+gd+alyx9fCXu/Rmji
         2w/E7oYzl7Oaa3WNzbTKp4WEHrbd889u1S0lqi5FQOh8JyLS9L8IKYGzpZ7GmOzZFHQL
         WEmp7SkoSwTMny7h5CoQiHrvmPzq0EpswgDUbBIHj4bKVVw81FDGWqp81c4kYJogwBV4
         ZLejh5FP0Und6A/2RqdH3FDTeoo4QF7wActcNHvMOAtDaadiptURUjm+15jd4YPMCrwI
         zGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YP4CFWK7HD5zbQQCiHXFOxCd4gvriaqa4PSVAkwYD2Y=;
        b=0fj2HheEq0Nv4Tm46mrkqSIqlVqyd/qPj0bHiJGCbcwjuGq+vnp2In7cs57fnnB4xo
         j5QKY6vfjZCjrrneOym1BIBB1VkWZ9etjyfcALReN7oPqt1a9LTEyFeuD95qRjIXGjhg
         HBHab1CjMqL4Vzhk0OKK7Nj8IZnEcTgNQhyOGA5EpUJhAAAf3r27hpFG3BTZ83gcYXHI
         g0ncZIOOEP1iou5zsOGfKYgZ+GjDLpfsDjpmgeBnW8eSrHCCKN2RHX8Hp8uw6Lo0cGK+
         KPzUwIDmnmPP3xcAZUUtbgfRiiglMISXidrWOoedtTrWJ9PqLQijRLbk1ByMTTKGArhW
         7W5w==
X-Gm-Message-State: AOAM532IZR5iEAOAnWaYLnSdcfcvvCfRe/5/1fM/ie3doifgyU8d4q3X
        rO+r8o6f79+h16PkAg2xWwTUWh3y05Uxm/ld0QM=
X-Google-Smtp-Source: ABdhPJxMx12ZFvBuKwIXcIKSrgtMOfuE8SGnBNhjMk2G8yiYyFJtpKy9xK6jCLZkWDmgtwMB5dox4jIFRT6S1I0q7h0=
X-Received: by 2002:a0d:f041:0:b0:2f4:cdae:6046 with SMTP id
 z62-20020a0df041000000b002f4cdae6046mr12859500ywe.315.1650821028778; Sun, 24
 Apr 2022 10:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220424165309.241796-1-eyal.birger@gmail.com>
In-Reply-To: <20220424165309.241796-1-eyal.birger@gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sun, 24 Apr 2022 20:23:37 +0300
Message-ID: <CAHsH6Gtpu-+79r2wrs1U=X=wMjVh2MfNxdgDtsL7yOfsKzKXDA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test setting tunnel key from lwt xmit
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, posk@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Sun, Apr 24, 2022 at 7:53 PM Eyal Birger <eyal.birger@gmail.com> wrote:
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
> diff --git a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> index d6cb986e7533..39c6bd5402ae 100644
> --- a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> +++ b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c

Thinking about this some more, I'm not sure if these tests fit better here
or in test_tunnel.sh.

If the latter is preferred, please drop this patch and I'll submit one for
test_tunnel.sh.

Eyal.
