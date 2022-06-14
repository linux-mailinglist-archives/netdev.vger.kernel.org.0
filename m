Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354BD54B720
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbiFNRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357152AbiFNQ7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:59:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A011163;
        Tue, 14 Jun 2022 09:59:37 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w2so16179088ybi.7;
        Tue, 14 Jun 2022 09:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrzbgcNkUQ7Zz63xqhepzP97koEMht4Jhs6UIjwgzis=;
        b=V3/W/fKyA3uoUiUA9aT+aWTgy1wwkxhnteXP50eGwFpDuNmBHPwfj6nRaS3vncCqwu
         M15I7n3lpyYLg/3uEZlwW7lqd8DANUrPt2z2GsFBIWTozAUhtVHM8sjBPj4f9abuPDf7
         dYRck76N1vqEeSrMAe3tojVIybQK1yt2MH0ItTzORfuLs9VZBq8dG+khQSbbBz9r1+Ab
         fIVL8JrYpaqegZyeGvtBNgz9ql/O9oV6f6XToqU8C49EvHmF3H3L6i/tIx5Xd8C4GnvX
         IaeUnc8Sdn5EZEfryzaEQhYdxh3rT8qKls6yEHKxjR8iAKbAp+7AvbRoeLwKMhtb2loC
         jb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrzbgcNkUQ7Zz63xqhepzP97koEMht4Jhs6UIjwgzis=;
        b=JjSxnrMpqZPpl7v2EGqxhL9X+GDahnjXswIX9N9jf3tIsw+CsRSVXNdayiMdVrzcfq
         rgzU9IQxoFLa7bIx+WaAVDP2PmcM67aUdaf24xB9EK9UJox5PSA4Wsx93i+HZkKLqABN
         +HvBtYCYJpMd85PGLDisz0+PxlJE0ddiK+8hCbto+yYgR+Ce1eynYaKPTrLlcQEQttI3
         eaZzgQ2+gIP6PSBZLkshrHlJk2zT7LJzwJ0wv/E60DRZLW3ctZ4UEXpcTj9snvyF+Hfo
         ZiY7Jp+Wci2YSTqtr/2JuMIcr6j7fOdgnxJdwWyUCwD6MvVABtq/ii9qOBxekn/C+M6K
         fxmQ==
X-Gm-Message-State: AJIora8NXpqoi4bzof9/Xc7sajC4RiQ5PSGRMD/9DYVezPiALxPtCsWu
        lCuDf8IZNUNNfr72J3YjHPqyq8EjtCHFtIR4o9A=
X-Google-Smtp-Source: AGRyM1s0CA6NwVMVfHhR6mzaguUfsT3S3k/e7TA0AYn0Nyt4w9paFcqYcHihga4qUy8I2d9Gq0icGGz0RGnoMNxqmGg=
X-Received: by 2002:a25:90a:0:b0:664:3dd3:63de with SMTP id
 10-20020a25090a000000b006643dd363demr5919917ybj.506.1655225976180; Tue, 14
 Jun 2022 09:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220607133135.271788-1-eyal.birger@gmail.com> <f80edf4f-c795-1e1e-bac2-414189988156@iogearbox.net>
In-Reply-To: <f80edf4f-c795-1e1e-bac2-414189988156@iogearbox.net>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 14 Jun 2022 19:59:24 +0300
Message-ID: <CAHsH6GvWkyDg5mXnSNoyY0H2V2i4iMsucydB=RZB100czc-85A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add lwt ip encap tests to test_progs
To:     Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org
Cc:     shuah@kernel.org, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, posk@google.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 12:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Eyal,
>
> On 6/7/22 3:31 PM, Eyal Birger wrote:
> > Port test_lwt_ip_encap.sh tests onto test_progs.
> >
> > In addition, this commit adds "egress_md" tests which test a similar
> > flow as egress tests only they use gre devices in collect_md mode
> > for encapsulation and set the tunnel key using bpf_set_tunnel_key().
> >
> > This introduces minor changes to test_lwt_ip_encap.{sh,c} for consistency
> > with the new tests:
> >
> > - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
> >    TUNNEL_KEY flag
> >
> > - Source address for GRE traffic is set to IP*_5 instead of IP*_1 since
> >    GRE traffic is sent via veth5 so its address is selected when using
> >    bpf_set_tunnel_key()
> >
> > Note: currently these programs use the legacy section name convention
> > as iproute2 lwt configuration does not support providing function names.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
> >   .../selftests/bpf/prog_tests/lwt_ip_encap.c   | 582 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_lwt_ip_encap.c   |  51 +-
> >   .../selftests/bpf/test_lwt_ip_encap.sh        |   6 +-
> >   3 files changed, 633 insertions(+), 6 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> > new file mode 100644
> > index 000000000000..e1b6f3ce6045
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> > @@ -0,0 +1,582 @@
> [...]
>
> Thanks a lot for porting the test into test_progs! Looks like the BPF CI currently
> bails out here:
>
> https://github.com/kernel-patches/bpf/runs/6812283921?check_suite_focus=true
>
> Andrii, looks like we might be missing CONFIG_NET_VRF in vmtest config-latest.*?

Hi Andrii,

What's the next step - should I submit a PR to libbpf on Github for adding
CONFIG_NET_VRF?

Eyal.
