Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836D361026D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiJ0ULG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiJ0UKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:10:48 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096E055087
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:10:46 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h188so2734970iof.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b7m5/Wn1VQoIT3QEOaJrd2CbN7j3NScHjsuJE5XleaQ=;
        b=Vb1nzl9l3hATuoemmggmsmAl24QZRTfheup9MjMXIpq4wb9w6MQ2K1QrwiKvwM90sm
         x3GbGcVCAEv8z6e/hxes8PsdYM4+bU5mkICCOnb9SfGCZJ5hYiKTWQyTZzmYoe3S0TxW
         QjUfMoYZ2DJw4J6Mt5KWAFyFKN/Ev/dH3gVocPc+McpICTuvdSMTrpKavmyitTg3qxqC
         hy1dg5eFjJpqiXEWwVUhqCYn6YojRkYZrQPDRCi1vXdiq1jb8mwgy5AHqIf2LJCqGsDW
         HZSWO/akP376vE2kOZBna2mLROX9S82i+YH/ThweFgpKsKOEsp7SmDhw4jvxo+rcSgyF
         8fZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b7m5/Wn1VQoIT3QEOaJrd2CbN7j3NScHjsuJE5XleaQ=;
        b=JP6mHqKTjpO2TuLavX43BXwi4imarsfm42h/TLHjiHssBnFeo8Ks1qTH9Rt+xQlo73
         eQnrVuhCUrlveFzWSPa/eX90NgQm7L3+dwjCUQULAXOpYtunSzA8/dMK6dY0EGTQJjEo
         rhMrOHVHpQTfUFZwRHz7qwT03AQv4Bi8Ns18teVekFxEJrqPZOZIq2U9gKWkehQyXLvQ
         Hh+DT3Ej+ZcByXnp92q5hVdrfMcIevqqB+qqhvYTK0SAS4EOuEDyMKg4lkJTFIi+z6v9
         JTJSSPhMhuZZaMbyt+XH7KEWiXiss/GkyvBhPmxPsjcwymgaGQxPYS7idspeduUhiMOn
         IObQ==
X-Gm-Message-State: ACrzQf3V5gUTH4wy1B/6xsAQAw0s3W4c7ttcf7ClQnsjz0ZKwNqN6ycW
        UzEG+hLEg13033TYFlISGzkClrBFv4rphx/VAz1nkA==
X-Google-Smtp-Source: AMsMyM53fMrRH5graXVt/8fPM1BLXWdIPfu7BZ9i7KSEUcVEVWLW++jk/o/kJ3A+i0YqnhNJFItThjeFJPHQpV+4+h8=
X-Received: by 2002:a5e:c80b:0:b0:6c0:8106:f229 with SMTP id
 y11-20020a5ec80b000000b006c08106f229mr7846062iol.49.1666901445137; Thu, 27
 Oct 2022 13:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-4-sdf@google.com>
 <CAEf4BzbgjOaxVFAfnrRyPP0_1Rh-gC3er4tKLkfr=OPb_x-ueA@mail.gmail.com>
In-Reply-To: <CAEf4BzbgjOaxVFAfnrRyPP0_1Rh-gC3er4tKLkfr=OPb_x-ueA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 27 Oct 2022 13:10:33 -0700
Message-ID: <CAKH8qBt_GS-9jdR1fDHNBgDHTOn6Zqh79X_8CNOFzidufLZZ_g@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/5] libbpf: Pass prog_ifindex via bpf_object_open_opts
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 1:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 27, 2022 at 1:00 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Allow passing prog_ifindex to BPF_PROG_LOAD. This patch is
> > not XDP metadata specific but it's here because we (ab)use
> > prog_ifindex as "target metadata" device during loading.
> > We can figure out proper UAPI story if we decide to go forward
> > with the kfunc approach.
> >
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 1 +
> >  tools/lib/bpf/libbpf.h | 6 +++++-
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 5d7819edf074..61bc37006fe4 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -7190,6 +7190,7 @@ static int bpf_object_init_progs(struct bpf_object *obj, const struct bpf_object
> >
> >                 prog->type = prog->sec_def->prog_type;
> >                 prog->expected_attach_type = prog->sec_def->expected_attach_type;
> > +               prog->prog_ifindex = opts->prog_ifindex;
> >
> >                 /* sec_def can have custom callback which should be called
> >                  * after bpf_program is initialized to adjust its properties
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index eee883f007f9..4a40b7623099 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -170,9 +170,13 @@ struct bpf_object_open_opts {
> >          */
> >         __u32 kernel_log_level;
> >
> > +       /* Optional ifindex of netdev for offload purposes.
> > +        */
> > +       int prog_ifindex;
> > +
>
> nope, don't do that, open_opts are for entire object, while this is
> per-program thing
>
> So bpf_program__set_ifindex() setter would be more appropriate

Oh, doh, not sure how I missed that. Thanks!

>
> >         size_t :0;
> >  };
> > -#define bpf_object_open_opts__last_field kernel_log_level
> > +#define bpf_object_open_opts__last_field prog_ifindex
> >
> >  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
> >
> > --
> > 2.38.1.273.g43a17bfeac-goog
> >
