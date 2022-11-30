Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0663E43C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiK3XGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiK3XGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:06:11 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28D397033;
        Wed, 30 Nov 2022 15:06:07 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s5so76819edc.12;
        Wed, 30 Nov 2022 15:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UQlapujHjKw7zEIFDE0bIVyHKZ7ZDtpnlk0TFhcybwA=;
        b=Ysm8TV/wU765nO4TfDrEonAPGjEFGm6E5iiVUYJOpUTVRLXFO3g8PSVucc0QBO77qc
         RotMShY3b1/V8LPZ+LTzTvOwYtDXl1whxa23u4QnDrou4mw86hzWbB2eCC69gybYw7TW
         smQ5ZQXFdzRLVJu1tRka0CNIHqBmT/wN6ONRqZOsbUTSP9z0IdRTPONmCLEg8YTZND9D
         KmvHnVx4MzMB4nGmQMVWwjCW9Tt/5g8kUHJEpPsSx6OdWTbHV0/fS8i0NaJWBnhCCTEJ
         jppNDTC7lFN5JUGJCU/NNBRqRydvrYiGDi+FAvFuu7z25o5hk8qSlAm27IylwMNvc2k/
         K9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQlapujHjKw7zEIFDE0bIVyHKZ7ZDtpnlk0TFhcybwA=;
        b=0oF7Pz2wmfcwxj93D4G47KqsMaJxgUTSEmbxJMeNa30l4U30ihwuvMaNvroOCLGBs3
         pCjillY+bSJN+RHdli34+TUTR9wdQe9i5v2uC9YjPdUFUYORQVwKCEk5hr7b0h18zUB6
         8gdWzgeMG3jZXKnL99jWgxwobui0AhzYfMaQZ+nQT3bl48USzzqpXClO+n4mJTeGyMlH
         Kfi1L/ciG7gkLZ853QjxtKYlEFDMvCltajBaNPNLSuQqVDFzWWliuwtt0TTU4X9yjyp6
         AY2PHtXAyv0Q116O1n5tVicLpqtxsy9DTnDwL2WbjY4vCWZg28uGs+Yj8GwhRBdiI8Bu
         GAbQ==
X-Gm-Message-State: ANoB5pnqQXRdiCXUr6jtmc8poYzQ68Qjp3ExJJc0S/da3IlIxESx7eKL
        HvDW4Ip/WNTqHjw0Y3NNHcuVCQQQcBpcsWw4ql/ePrCl
X-Google-Smtp-Source: AA0mqf7PtDPrIxDqKatcWfpFTL79ZuvV3WUTnTPNI4tc9Zv92huJfMiwWmwTqHWYV+x88CA6tbxVdC/+182b6AVVNFs=
X-Received: by 2002:a50:ed90:0:b0:46a:e6e3:b3cf with SMTP id
 h16-20020a50ed90000000b0046ae6e3b3cfmr21089221edr.333.1669849566068; Wed, 30
 Nov 2022 15:06:06 -0800 (PST)
MIME-Version: 1.0
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com> <20221124151603.807536-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-2-benjamin.tissoires@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Nov 2022 15:05:53 -0800
Message-ID: <CAEf4Bzaq3QfhzqQK=BqCkzNcoS3A5L-ntJ5vj16uMc=jS4bxkw@mail.gmail.com>
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

On Thu, Nov 24, 2022 at 7:16 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> So we can then build light skeletons with loaders in any language.
>

It would be useful to include an example generated JSON. Other than
that the overall idea makes sense. Kind of machine-friendly "BPF
object schema" to allow automation.

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  tools/bpf/bpftool/gen.c | 95 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index cf8b4e525c88..818a5209b3ac 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -904,6 +904,96 @@ codegen_progs_skeleton(struct bpf_object *obj, size_t prog_cnt, bool populate_li
>         }
>  }
>
> +static int gen_json(struct bpf_object *obj, const char *obj_name, size_t file_sz, uint8_t *obj_data)
> +{
> +       struct bpf_program *prog;
> +       struct bpf_map *map;
> +       char ident[256];
> +
> +       jsonw_start_object(json_wtr);   /* root object */
> +
> +       jsonw_string_field(json_wtr, "name", obj_name);
> +
> +       jsonw_bool_field(json_wtr, "use_loader", use_loader);
> +
> +       /* print all maps */
> +       jsonw_name(json_wtr, "maps");
> +       jsonw_start_array(json_wtr);
> +       bpf_object__for_each_map(map, obj) {
> +               if (!get_map_ident(map, ident, sizeof(ident))) {
> +                       p_err("ignoring unrecognized internal map '%s'...",
> +                             bpf_map__name(map));
> +                       continue;
> +               }
> +
> +               jsonw_start_object(json_wtr);   /* map object */
> +               jsonw_string_field(json_wtr, "ident", ident);
> +               jsonw_string_field(json_wtr, "name", bpf_map__name(map));
> +
> +               /* print mmap data value */
> +               if (is_internal_mmapable_map(map, ident, sizeof(ident))) {
> +                       const void *mmap_data = NULL;
> +                       size_t mmap_size = 0;
> +
> +                       mmap_data = bpf_map__initial_value(map, &mmap_size);
> +
> +                       jsonw_uint_field(json_wtr, "size", mmap_size);
> +                       jsonw_uint_field(json_wtr, "mmap_sz", bpf_map_mmap_sz(map));
> +                       jsonw_name(json_wtr, "data");
> +                       print_hex_data_json((uint8_t *)mmap_data, mmap_size);
> +
> +               }
> +               jsonw_end_object(json_wtr);     /* map object */
> +       }
> +       jsonw_end_array(json_wtr);
> +
> +       /* print all progs */
> +       jsonw_name(json_wtr, "progs");
> +       jsonw_start_array(json_wtr);
> +       bpf_object__for_each_program(prog, obj) {
> +               jsonw_start_object(json_wtr);   /* prog object */
> +               jsonw_string_field(json_wtr, "name", bpf_program__name(prog));
> +               jsonw_string_field(json_wtr, "sec", bpf_program__section_name(prog));
> +               jsonw_end_object(json_wtr);     /* prog object */
> +       }
> +       jsonw_end_array(json_wtr);
> +
> +       /* print object data */
> +       if (use_loader) {
> +               DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
> +               int err = 0;
> +
> +               err = bpf_object__gen_loader(obj, &opts);
> +               if (err)
> +                       return err;
> +
> +               err = bpf_object__load(obj);
> +               if (err) {
> +                       p_err("failed to load object file");
> +                       return err;
> +               }
> +               /* If there was no error during load then gen_loader_opts
> +                * are populated with the loader program.
> +                */
> +
> +               jsonw_uint_field(json_wtr, "data_sz", opts.data_sz);
> +               jsonw_name(json_wtr, "data");
> +               print_hex_data_json((uint8_t *)opts.data, opts.data_sz);
> +
> +               jsonw_uint_field(json_wtr, "insns_sz", opts.insns_sz);
> +               jsonw_name(json_wtr, "insns");
> +               print_hex_data_json((uint8_t *)opts.insns, opts.insns_sz);
> +
> +       } else {
> +               jsonw_name(json_wtr, "data");
> +               print_hex_data_json(obj_data, file_sz);
> +       }
> +
> +       jsonw_end_object(json_wtr);     /* root object */
> +
> +       return 0;
> +}
> +
>  static int do_skeleton(int argc, char **argv)
>  {
>         char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
> @@ -986,6 +1076,11 @@ static int do_skeleton(int argc, char **argv)
>                 goto out;
>         }
>
> +       if (json_output) {
> +               err = gen_json(obj, obj_name, file_sz, (uint8_t *)obj_data);
> +               goto out;
> +       }
> +
>         bpf_object__for_each_map(map, obj) {
>                 if (!get_map_ident(map, ident, sizeof(ident))) {
>                         p_err("ignoring unrecognized internal map '%s'...",
> --
> 2.38.1
>
