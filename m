Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374B963F769
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiLASVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLASVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:21:19 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775BAA430F;
        Thu,  1 Dec 2022 10:21:18 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id td2so6192005ejc.5;
        Thu, 01 Dec 2022 10:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kN4208hsce3SHRoaG9mzfo6G9M6qlvqdZeD2xS9Y30Y=;
        b=Kn7lsPSRaeviDF4KcfkeCZMoKGapjvtJZ4qGaRJ/mcJnBdd5f4eJoQeJnTuMFRK623
         9LdYB2n+ZDPwgx9bIp8bal3xXnlLWAkk5CJm1E0eMTkkB6z6n0zFP3FFz+4UdeCRItAx
         +umcntRjf+isG3Dct/aWhQV9NGCyEJkPWR799uRUU44OTku+H/rQUq0J/Kh8BBo7duAN
         4bCRYnUq2oJ8da5DbQmGOHVskBfUr0RF+gyxGuqLyG23lOllKfLPDXadNlleJlObttsw
         M0k97aknVVwC37MT3qpSjj5zwI6+SoRQw2Uw+hZKdhPmR+T4npSIA4Bl1ut2TNludqyl
         OkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kN4208hsce3SHRoaG9mzfo6G9M6qlvqdZeD2xS9Y30Y=;
        b=h5bFCUE9i/LNqRZvmettVy9Qj+v6AqZzpThkNDTRlZ4malytLaB2Ik7fcTgSShqhQq
         CD+SgsNSku4+EQvE0mt9xaG970N286U1+OH9xmlJiqCnUG8J5emXM6zBFuR8QxcMo5GI
         DueyH2CU7zCsGxM2e3L31CIuP++X7L9MQt1QCp5jecBwD7SZZrhQQ1A2LQhUH6Z9HCWH
         kpfrqtlXb8wCw8TITncT4/12AT1oSKn/QTKEe29mU1tv5DSIT/dvRhH5NkpP8n1w2Onm
         20Q+ZrsMUnPGx2oYpXxf01gd8tTDfaudELpcW6dua/ImD3yvjl7WTlcZqgOan00OTWmj
         eHhg==
X-Gm-Message-State: ANoB5pkSu5fxg7MJkE+FIjdGL0TxIbU3ktmdgEC69LLWxTRz5tcpI8jq
        2wlPhu2/ne271siwylo8iS7ALQ+QpxPBxBfnA0E=
X-Google-Smtp-Source: AA0mqf6bS4ZWZp4LkTyr+VR9fFZzERdRmQ590gokW1YJVyl5Cyn6gJPqOVqdOvX/Kd5m1hHqQBr2J8embxFnZzIja/Y=
X-Received: by 2002:a17:906:180e:b0:7a2:6d38:1085 with SMTP id
 v14-20020a170906180e00b007a26d381085mr40905835eje.114.1669918876737; Thu, 01
 Dec 2022 10:21:16 -0800 (PST)
MIME-Version: 1.0
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
 <20221124151603.807536-2-benjamin.tissoires@redhat.com> <CAEf4Bzaq3QfhzqQK=BqCkzNcoS3A5L-ntJ5vj16uMc=jS4bxkw@mail.gmail.com>
 <CAO-hwJKwDWJ6ZKK=+BjrDhjfyG00VKFznJ+HO-0MV1AQ1U8D-Q@mail.gmail.com>
In-Reply-To: <CAO-hwJKwDWJ6ZKK=+BjrDhjfyG00VKFznJ+HO-0MV1AQ1U8D-Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 1 Dec 2022 10:21:03 -0800
Message-ID: <CAEf4BzbmgAkfSV0zeWuhzritA3_iH81dE-JODZqUz1CsW=awHg@mail.gmail.com>
Subject: Re: [RFC hid v1 01/10] bpftool: generate json output of skeletons
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
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

On Thu, Dec 1, 2022 at 6:23 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Thu, Dec 1, 2022 at 12:06 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Nov 24, 2022 at 7:16 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > So we can then build light skeletons with loaders in any language.
> > >
> >
> > It would be useful to include an example generated JSON. Other than
> > that the overall idea makes sense. Kind of machine-friendly "BPF
> > object schema" to allow automation.
> >
>
> Great :)
> I'll add the generated example in v2 then.
>
> However, I have problems figuring out how I can hit the
> "codegen_datasecs()" path. I think that's the only code path I am not
> duplicating from the do_skeleton() function, but I don't know what
> kind of .bpf.c program will trigger that part.
>

You'll hit this whenever you have global variables in your .bpf.c
code. It's very important part, so let's make sure it is covered. Try
using both `const volatile` read-only variables (they will end up in
.rodata datasec) and global non-read-only variables (they will go into
.data, if initialized to non-zero defaults, or .bss if
zero-initialized).

> Also, should I add some tests for it in tools/testing/selftests/bpf?

Yes, it probably makes sense to check expected JSON output is
generated for a few example BPF object files.

>
> Cheers,
> Benjamin
>
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > ---
> > >  tools/bpf/bpftool/gen.c | 95 +++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 95 insertions(+)
> > >
> > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > index cf8b4e525c88..818a5209b3ac 100644
> > > --- a/tools/bpf/bpftool/gen.c
> > > +++ b/tools/bpf/bpftool/gen.c
> > > @@ -904,6 +904,96 @@ codegen_progs_skeleton(struct bpf_object *obj, size_t prog_cnt, bool populate_li
> > >         }
> > >  }
> > >
> > > +static int gen_json(struct bpf_object *obj, const char *obj_name, size_t file_sz, uint8_t *obj_data)
> > > +{
> > > +       struct bpf_program *prog;
> > > +       struct bpf_map *map;
> > > +       char ident[256];
> > > +
> > > +       jsonw_start_object(json_wtr);   /* root object */
> > > +
> > > +       jsonw_string_field(json_wtr, "name", obj_name);
> > > +
> > > +       jsonw_bool_field(json_wtr, "use_loader", use_loader);
> > > +
> > > +       /* print all maps */
> > > +       jsonw_name(json_wtr, "maps");
> > > +       jsonw_start_array(json_wtr);
> > > +       bpf_object__for_each_map(map, obj) {
> > > +               if (!get_map_ident(map, ident, sizeof(ident))) {
> > > +                       p_err("ignoring unrecognized internal map '%s'...",
> > > +                             bpf_map__name(map));
> > > +                       continue;
> > > +               }
> > > +
> > > +               jsonw_start_object(json_wtr);   /* map object */
> > > +               jsonw_string_field(json_wtr, "ident", ident);
> > > +               jsonw_string_field(json_wtr, "name", bpf_map__name(map));
> > > +
> > > +               /* print mmap data value */
> > > +               if (is_internal_mmapable_map(map, ident, sizeof(ident))) {
> > > +                       const void *mmap_data = NULL;
> > > +                       size_t mmap_size = 0;
> > > +
> > > +                       mmap_data = bpf_map__initial_value(map, &mmap_size);
> > > +
> > > +                       jsonw_uint_field(json_wtr, "size", mmap_size);
> > > +                       jsonw_uint_field(json_wtr, "mmap_sz", bpf_map_mmap_sz(map));
> > > +                       jsonw_name(json_wtr, "data");
> > > +                       print_hex_data_json((uint8_t *)mmap_data, mmap_size);
> > > +
> > > +               }
> > > +               jsonw_end_object(json_wtr);     /* map object */
> > > +       }
> > > +       jsonw_end_array(json_wtr);
> > > +
> > > +       /* print all progs */
> > > +       jsonw_name(json_wtr, "progs");
> > > +       jsonw_start_array(json_wtr);
> > > +       bpf_object__for_each_program(prog, obj) {
> > > +               jsonw_start_object(json_wtr);   /* prog object */
> > > +               jsonw_string_field(json_wtr, "name", bpf_program__name(prog));
> > > +               jsonw_string_field(json_wtr, "sec", bpf_program__section_name(prog));
> > > +               jsonw_end_object(json_wtr);     /* prog object */
> > > +       }
> > > +       jsonw_end_array(json_wtr);
> > > +
> > > +       /* print object data */
> > > +       if (use_loader) {
> > > +               DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
> > > +               int err = 0;
> > > +
> > > +               err = bpf_object__gen_loader(obj, &opts);
> > > +               if (err)
> > > +                       return err;
> > > +
> > > +               err = bpf_object__load(obj);
> > > +               if (err) {
> > > +                       p_err("failed to load object file");
> > > +                       return err;
> > > +               }
> > > +               /* If there was no error during load then gen_loader_opts
> > > +                * are populated with the loader program.
> > > +                */
> > > +
> > > +               jsonw_uint_field(json_wtr, "data_sz", opts.data_sz);
> > > +               jsonw_name(json_wtr, "data");
> > > +               print_hex_data_json((uint8_t *)opts.data, opts.data_sz);
> > > +
> > > +               jsonw_uint_field(json_wtr, "insns_sz", opts.insns_sz);
> > > +               jsonw_name(json_wtr, "insns");
> > > +               print_hex_data_json((uint8_t *)opts.insns, opts.insns_sz);
> > > +
> > > +       } else {
> > > +               jsonw_name(json_wtr, "data");
> > > +               print_hex_data_json(obj_data, file_sz);
> > > +       }
> > > +
> > > +       jsonw_end_object(json_wtr);     /* root object */
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  static int do_skeleton(int argc, char **argv)
> > >  {
> > >         char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
> > > @@ -986,6 +1076,11 @@ static int do_skeleton(int argc, char **argv)
> > >                 goto out;
> > >         }
> > >
> > > +       if (json_output) {
> > > +               err = gen_json(obj, obj_name, file_sz, (uint8_t *)obj_data);
> > > +               goto out;
> > > +       }
> > > +
> > >         bpf_object__for_each_map(map, obj) {
> > >                 if (!get_map_ident(map, ident, sizeof(ident))) {
> > >                         p_err("ignoring unrecognized internal map '%s'...",
> > > --
> > > 2.38.1
> > >
> >
>
