Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33477512304
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiD0TrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiD0Tqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:46:55 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1452E0AF;
        Wed, 27 Apr 2022 12:41:45 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e1so639858ile.2;
        Wed, 27 Apr 2022 12:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYyd8f+4MS3/jYQdz3LNAtCwqcYH62ijIlbkCSXhveE=;
        b=lU2OBhENOUesSEP9Nu53tal7OK8ZyFxE7L/PYW7GcnNHoHTsjUTIZ1YY8ceLs93VjN
         rZgsZwM9DlXR6O/rpqbL+nYp0dwmQpeYurc8+riZ1B7SK7EUwW4jmQUJOqaIZbfq4YIq
         5DHMi2FDQzi4lwsHZMxMI9EpNbBRkT77ulEQ9IUmTQcEV3RAV0uc3XKmb75GZ51LO26H
         DhFl/xlWIxLmkAkBkq5W98dif/RKSH0OjZbIEaoxGyzu/f6xhKmHtY367Uhj7Hm9Htkm
         bkyv4NLksyelkcYyfFondB3fLniOgWoz7F6IsCyO3iJsU68X5fGim1fzJ4znOkqmMIOG
         Fx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYyd8f+4MS3/jYQdz3LNAtCwqcYH62ijIlbkCSXhveE=;
        b=P23gwsGFjfPMgJATNXHEi5WtsTqL2C8evM+V2goH2uQxai/WhLwpCfrksRIuIOjPhW
         unIjx2AAZLanvq8XCpH4oT7+xPhSLHKeerLYw52mpZgBp9e07o7pBxZgwwCWJmr5IWTW
         NdALhbA9MQrorHwmIB960GqxVO9lzabdNhoig3wkTH25iGZA0dS5YWDZsaVFEaS+jTsE
         7XNRV6clFGH5okvh+Q1gMxNO76PgJ6MVvr4BmeyXr+5EFGNMa68aZc0nQuZBs1tkXdaX
         3vrDoPD+7Ry6zQZas7eqZyubLp9ZsQlSo7wW9L+/wzTX5gpN4+SizfunIFsTtCfasXpt
         XJEA==
X-Gm-Message-State: AOAM5306ENK2v2cKD4PwO4i7QRgRAjyMAZ2GV0roxGwyfvbK2JUD/5F+
        1eueUUCDrWU2IKyLEZi2TbQPEwvnN49RWpGbLk8=
X-Google-Smtp-Source: ABdhPJw4ckNz7Kmxd5ZZeN5OjxU4vq38Zzc16PBABufm+ECrpbmaM0ol3Id8rhaD/Bjzcyxb6vG+geljyW3PUeVQvzI=
X-Received: by 2002:a92:cd8d:0:b0:2cd:81ce:79bd with SMTP id
 r13-20020a92cd8d000000b002cd81ce79bdmr8526344ilb.252.1651088505314; Wed, 27
 Apr 2022 12:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220424165309.241796-1-eyal.birger@gmail.com> <CAHsH6Gtpu-+79r2wrs1U=X=wMjVh2MfNxdgDtsL7yOfsKzKXDA@mail.gmail.com>
In-Reply-To: <CAHsH6Gtpu-+79r2wrs1U=X=wMjVh2MfNxdgDtsL7yOfsKzKXDA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 12:41:34 -0700
Message-ID: <CAEf4BzZ3vDvLDQ+Wsj1z2=-exZO-t510JdWXA-1bao-shO4PJg@mail.gmail.com>
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

On Sun, Apr 24, 2022 at 10:23 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> On Sun, Apr 24, 2022 at 7:53 PM Eyal Birger <eyal.birger@gmail.com> wrote:
> >
> > This commit adds test_egress_md() tests which perform a similar flow as
> > test_egress() only that they use gre devices in collect_md mode and set
> > the tunnel key from lwt bpf xmit.
> >
> > VRF scenarios are not checked since it is currently not possible to set
> > the underlying device or vrf from bpf_set_tunnel_key().
> >
> > This introduces minor changes to the existing setup for consistency with
> > the new tests:
> >
> > - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
> >   TUNNEL_KEY flag
> >
> > - Source address for GRE traffic is set to IPv*_5 instead of IPv*_1 since
> >   GRE traffic is sent via veth5 so its address is selected when using
> >   bpf_set_tunnel_key()
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
> >  .../selftests/bpf/progs/test_lwt_ip_encap.c   | 51 ++++++++++-
> >  .../selftests/bpf/test_lwt_ip_encap.sh        | 85 ++++++++++++++++++-
> >  2 files changed, 128 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> > index d6cb986e7533..39c6bd5402ae 100644
> > --- a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> > +++ b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
>
> Thinking about this some more, I'm not sure if these tests fit better here
> or in test_tunnel.sh.
>
> If the latter is preferred, please drop this patch and I'll submit one for
> test_tunnel.sh.

general preference is to put test into test_progs as those are
regularly and extensively exercised, while test_tunnel.sh is not

>
> Eyal.
