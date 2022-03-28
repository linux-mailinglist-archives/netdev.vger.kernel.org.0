Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42384EA2BD
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiC1WPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiC1WP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:15:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F82C46150;
        Mon, 28 Mar 2022 15:07:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x31so7507550pfh.9;
        Mon, 28 Mar 2022 15:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hlR9qEfCvrZwyaQ5xtdsxElww4Nf53O/UN7Elp2nyOU=;
        b=jnrn2Qg/DbrQTBXsnE4hyLZDU69939cYb8U50T9Ut8RRmQvnY4DbFGLFg7hNMbHB2a
         83l6FfeFS0ztLfO0j+anemo2qea+RxUTMOWGp/Sy9ZMwqWUwexq2+VVTl7I2WuKXh5n1
         0oPGnw5+TvNoKWSONpDFepm6Ce54dsDmuAizaxzKf0zQBfrq8VJRTkvtcZlQi98axaZe
         UL0qCmYELjFjm+sNaAdhcqBXtFE5KoyeBcDs0hhT4JmELPynN41tERfgLXrfV2pNMnSP
         gzZ96pxXudnBj77pvtc8orVVOijkHHJ/IMPqVjw5giR//GO6tI2QfrBcU5FVx4mjooUu
         cnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hlR9qEfCvrZwyaQ5xtdsxElww4Nf53O/UN7Elp2nyOU=;
        b=pHD/Vy3k6WwISn7VQR/Vorj00yF9doMxiA0g9IlCQ0IE/oNlf5S9HnsiLV62WAjFPd
         aP4FQlUaLLtFNrPKxRFPBUA9zyiUVtrr+VhohhzEcqVnV/fYoeHlBvbxsHys7KxvLRxl
         cJXSHO+x4drQ5jVL+e5vxJLP763mXyNuyKj+Ce2UAEMpq6xdt6x8kP22lP2Xvi3xWZYB
         3wIk7zo4SvsDNRnneffXygezZfj89l0vyGkUWFg8E6ORqoD6I2FTU6ZComVt/VlHaxWh
         QHxKOMtJHBao9R5CeBr7kgzklLslTB09v3nRoswvWYuKG/xOvTJE7UuihHqpGET+Q7aj
         56/Q==
X-Gm-Message-State: AOAM532jwY+oE6HgVmRgbFKrjYEjoeIZ/mIfDKGEQt8q9qn6WJxn+ED2
        0w3VDsruma9UYKpGHg7+bBOnVp+kZUjAJhiGpXuBGf7m
X-Google-Smtp-Source: ABdhPJxbCkVUS1w96/yUmEP61b0UEln4kxfwqP/H8HkkIxUSf5PeBhAHE4HJ2jBpooC8lVsRPpXtQkw0lE2AApPJLhg=
X-Received: by 2002:a05:6e02:1a23:b0:2c9:c008:8ad6 with SMTP id
 g3-20020a056e021a2300b002c9c0088ad6mr2400965ile.98.1648503127179; Mon, 28 Mar
 2022 14:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220328083703.2880079-1-jolsa@kernel.org> <9a040393-e478-d14d-8cfd-14dd08e09be0@fb.com>
 <YkIDfzcUqKed7rCq@krava>
In-Reply-To: <YkIDfzcUqKed7rCq@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Mar 2022 14:31:56 -0700
Message-ID: <CAEf4BzaCnG7A+Ns1dw8KYbmzU_q_T96-Niu=1j6o=+KRxYT1bQ@mail.gmail.com>
Subject: Re: [PATCH] bpftool: Fix generated code in codegen_asserts
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 11:50 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Mon, Mar 28, 2022 at 08:41:18AM -0700, Yonghong Song wrote:
> >
> >
> > On 3/28/22 1:37 AM, Jiri Olsa wrote:
> > > Arnaldo reported perf compilation fail with:
> > >
> > >    $ make -k BUILD_BPF_SKEL=3D1 CORESIGHT=3D1 PYTHON=3Dpython3
> > >    ...
> > >    In file included from util/bpf_counter.c:28:
> > >    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function =
=E2=80=98bperf_leader_bpf__assert=E2=80=99:
> > >    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: =
unused parameter =E2=80=98s=E2=80=99 [-Werror=3Dunused-parameter]
> > >      351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
> > >          |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
> > >    cc1: all warnings being treated as errors
> > >
> > > If there's nothing to generate in the new assert function,
> > > we will get unused 's' warn/error, adding 'unused' attribute to it.
> >
> > If there is nothing to generate, should we avoid generating
> > the assert function itself?
>
> good point, will check

we can use this function for some more assertions in the future, so
instead of trying to be smart about generating or not of this
function, I think unused attribute is a more robust solution.

>
> jirka
>
> >
> > >
> > > Cc: Delyan Kratunov <delyank@fb.com>
> > > Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   tools/bpf/bpftool/gen.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > index 7ba7ff55d2ea..91af2850b505 100644
> > > --- a/tools/bpf/bpftool/gen.c
> > > +++ b/tools/bpf/bpftool/gen.c
> > > @@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *ob=
j, const char *obj_name)
> > >     codegen("\
> > >             \n\
> > >             __attribute__((unused)) static void                      =
   \n\
> > > -           %1$s__assert(struct %1$s *s)                             =
   \n\
> > > +           %1$s__assert(struct %1$s *s __attribute__((unused)))     =
   \n\
> > >             {                                                        =
   \n\
> > >             #ifdef __cplusplus                                       =
   \n\
> > >             #define _Static_assert static_assert                     =
   \n\
