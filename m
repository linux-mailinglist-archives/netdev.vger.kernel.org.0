Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98954D557
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbiFOXbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 19:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350030AbiFOXbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 19:31:35 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474CE13F0A;
        Wed, 15 Jun 2022 16:31:34 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y19so26122681ejq.6;
        Wed, 15 Jun 2022 16:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uywbVqQj1UUa1x49fXsITPkeRamAeteYpQUEtRIFol4=;
        b=mAIQ1JXBEx71YnBFqIbN01cbrkXILJ3RXf7RD/MsqRPM2F6/F7rA6flHjLEmRUzc7/
         JVkf6RyXpnx95ckmwLW77OJWb3AnzMDLff7WO7Ocu0ByUeQtZdDC8F+c0VPM7OVtU511
         N/mAFITqEtkWcZlrPt0NLBfpa6tcY0UyRHxTtKxJENodengqtNC3H4G6WcZcQF08EDpB
         e0TQEq9ITh01nxFZEnOQzk/t2R5gY/crI0llhGT3nfBguhTGMzQO9WejP4tv/Iv0udsq
         bxcb9aVCnH/fO6ckH41hf5ZQLex7OeyPlY3BZ4nZeg92pnZjl4j5zMiV2wCvG7nmGoG1
         Lflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uywbVqQj1UUa1x49fXsITPkeRamAeteYpQUEtRIFol4=;
        b=ZFYKsqMaz3RMTUKeWK2tHzgVIMQqV/YxdnD89qFxFhLks4pWEcRM9Cq1MLH+b+IZ+t
         FmQHvDUX9mG1hslRY4YYwdwPyHyaIu+ODrMTrzmy9ovd7SKDegtbirh+/22rFGy862Sd
         6n8R2P261UdradnJR/JV55secTMw0DyNGl+ya1z/aeen9jnzzvk5rrjXO6rIAbdZYxbg
         5vtYJIxuczjpxszFpPf9ZCjZ5k/A37eibkkIdnSRy8mFgXjHk5xezEL66MKPQCceWGU3
         3Q7+DfwfeiDpahSfZTHsm7GshV7vctlFBhDJH3e+BrouNAOTcA2a2ICrA8ZgtQqs//U0
         g+ZQ==
X-Gm-Message-State: AJIora8qZ15/Ya63POLTjv5BcNCNK8kmuNTQw2kJIxWsmRTQtRaj85VG
        UoAAdWE/7RiM/4XcWzNs3tqlU2yaDCvk6W2Xwu4=
X-Google-Smtp-Source: AGRyM1ucMnDhOPT2NHAtF43xNrfO26e4c21AUOICAmCyD+r324xzulHXtANz/X9WMY7GtxCw+MeJD9ZkgSxCUAKjaGo=
X-Received: by 2002:a17:906:3f51:b0:712:3945:8c0d with SMTP id
 f17-20020a1709063f5100b0071239458c0dmr2107499ejj.302.1655335892744; Wed, 15
 Jun 2022 16:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220607133135.271788-1-eyal.birger@gmail.com>
 <f80edf4f-c795-1e1e-bac2-414189988156@iogearbox.net> <CAHsH6GvWkyDg5mXnSNoyY0H2V2i4iMsucydB=RZB100czc-85A@mail.gmail.com>
In-Reply-To: <CAHsH6GvWkyDg5mXnSNoyY0H2V2i4iMsucydB=RZB100czc-85A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jun 2022 16:31:21 -0700
Message-ID: <CAEf4BzYMqXZ6H-Mv=xSvRTJ0o8okrLQjVVYzgpG1D-8+3HNj1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add lwt ip encap tests to test_progs
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, posk@google.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Tue, Jun 14, 2022 at 9:59 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> On Fri, Jun 10, 2022 at 12:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Hi Eyal,
> >
> > On 6/7/22 3:31 PM, Eyal Birger wrote:
> > > Port test_lwt_ip_encap.sh tests onto test_progs.
> > >
> > > In addition, this commit adds "egress_md" tests which test a similar
> > > flow as egress tests only they use gre devices in collect_md mode
> > > for encapsulation and set the tunnel key using bpf_set_tunnel_key().
> > >
> > > This introduces minor changes to test_lwt_ip_encap.{sh,c} for consistency
> > > with the new tests:
> > >
> > > - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
> > >    TUNNEL_KEY flag
> > >
> > > - Source address for GRE traffic is set to IP*_5 instead of IP*_1 since
> > >    GRE traffic is sent via veth5 so its address is selected when using
> > >    bpf_set_tunnel_key()
> > >
> > > Note: currently these programs use the legacy section name convention
> > > as iproute2 lwt configuration does not support providing function names.
> > >
> > > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > > ---
> > >   .../selftests/bpf/prog_tests/lwt_ip_encap.c   | 582 ++++++++++++++++++
> > >   .../selftests/bpf/progs/test_lwt_ip_encap.c   |  51 +-
> > >   .../selftests/bpf/test_lwt_ip_encap.sh        |   6 +-
> > >   3 files changed, 633 insertions(+), 6 deletions(-)
> > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> > > new file mode 100644
> > > index 000000000000..e1b6f3ce6045
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> > > @@ -0,0 +1,582 @@
> > [...]
> >
> > Thanks a lot for porting the test into test_progs! Looks like the BPF CI currently
> > bails out here:
> >
> > https://github.com/kernel-patches/bpf/runs/6812283921?check_suite_focus=true
> >
> > Andrii, looks like we might be missing CONFIG_NET_VRF in vmtest config-latest.*?
>
> Hi Andrii,
>
> What's the next step - should I submit a PR to libbpf on Github for adding
> CONFIG_NET_VRF?

Yes, please, for [0] and [1]:

 [0] https://github.com/libbpf/libbpf
 [1] https://github.com/kernel-patches/vmtest

>
> Eyal.
