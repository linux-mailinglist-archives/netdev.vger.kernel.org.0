Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA762631F0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgIIQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgIIQa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:30:29 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B74C061573;
        Wed,  9 Sep 2020 09:30:28 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h126so2166419ybg.4;
        Wed, 09 Sep 2020 09:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0QK7G3OyjCcv7IbDXGjZ8zdSkmHRX5aAM05FHu5la4k=;
        b=U0xW/PWyO6Nq24v7Hzrq4Vhx+mevveDvk03yjC48qc7I7KrPdaM/5vhnerYJxdA8in
         3BDNEJsvpMRFbQtxKF1SQpDVtIDWbn/+z1ZkNN9rP10pWCtA2YP4JJLhoA7wmgJJ6sLH
         lMy+MEQ73NuggqnBxjYzlI+JKSl8T4uNfTTBA3lVmdLxvhXKwkvplxeD6LPrfb9fV6y5
         H+AMeWvA0QV35g2m2iiGUYsF35Zxk0A7F3MZIcim5HuqnOan+Lpk0dFZWVwz6uHIr/5A
         Ys8/WHE9SKMQ33MyrwfGF5Hv3kqTTSs4z1wbJs0I47siKY917bqy6h5OR1at5dkDEXSU
         rLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0QK7G3OyjCcv7IbDXGjZ8zdSkmHRX5aAM05FHu5la4k=;
        b=igliwoVdXUFfc6nptbvZ4IlFXOQ7mgGkR9DxsTKc/8rhyeyOv+xCtjylgwVx+JX7Re
         7ufff07BBOKx6/zdsxc8mRGQ4IcLeVHiWohgEgLI3sxhyqk9WC1uYMf5fnPXsJ4HWVZY
         F8sdJGhpwpwQqdSBcAsXLzWoOYx5N4gRYlN2Y5F94reMmm5SFDj8TNi+WGHp63sy0ZkI
         gSMWo069bUtdy+JFCl4Qu/YAGD/Nl0UxwzsXW5zoDfa6LRJCDo00IS7k7H2ZZ3GSLb3e
         apFOxoT9rCZNeR2t81x3E1P6G0IuINoVuIF9q2d22fIq993eWQp/L8/BroHtNUccOHSk
         Vg9Q==
X-Gm-Message-State: AOAM532TFd96o6dejaYhGwZV0V161HgfIRMPhS3X1u/y2mZfINugRfyd
        oM6vnCz0oYLifpI8GVpKtyoW9D61JZrfI2wRamGid8iG
X-Google-Smtp-Source: ABdhPJzYGsROsXcSMqxr70PK+Sazr3tYarpSZreyWmoD7y0iqrPw9uoP98rkWCw2VhySkVngI0ukNX2iM9K+9yFY8o8=
X-Received: by 2002:a25:c049:: with SMTP id c70mr6935662ybf.403.1599669027080;
 Wed, 09 Sep 2020 09:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200907163634.27469-1-quentin@isovalent.com> <20200907163634.27469-2-quentin@isovalent.com>
 <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com> <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com>
In-Reply-To: <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:30:16 -0700
Message-ID: <CAEf4Bzb0SdZBfDfd2ZBXOBgpneAc6mKFhzULj_Msd0MoNSG5ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] tools: bpftool: clean up function to dump
 map entry
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 1:19 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 09/09/2020 04:25, Andrii Nakryiko wrote:
> > On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> The function used to dump a map entry in bpftool is a bit difficult to
> >> follow, as a consequence to earlier refactorings. There is a variable
> >> ("num_elems") which does not appear to be necessary, and the error
> >> handling would look cleaner if moved to its own function. Let's clean it
> >> up. No functional change.
> >>
> >> v2:
> >> - v1 was erroneously removing the check on fd maps in an attempt to get
> >>   support for outer map dumps. This is already working. Instead, v2
> >>   focuses on cleaning up the dump_map_elem() function, to avoid
> >>   similar confusion in the future.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
> >>  1 file changed, 52 insertions(+), 49 deletions(-)
> >>
> >> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> >> index bc0071228f88..c8159cb4fb1e 100644
> >> --- a/tools/bpf/bpftool/map.c
> >> +++ b/tools/bpf/bpftool/map.c
> >> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
> >>         jsonw_end_object(json_wtr);
> >>  }
> >>
> >> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >> -                             const char *error_msg)
> >> +static void
> >> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
> >> +                     const char *error_msg)
> >>  {
> >>         int msg_size = strlen(error_msg);
> >>         bool single_line, break_names;
> >> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >>         printf("\n");
> >>  }
> >>
> >> +static void
> >> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
> >> +{
> >> +       /* For prog_array maps or arrays of maps, failure to lookup the value
> >> +        * means there is no entry for that key. Do not print an error message
> >> +        * in that case.
> >> +        */
> >
> > this is the case when error is ENOENT, all the other ones should be
> > treated the same, no?
>
> Do you mean all map types should be treated the same? If so, I can
> remove the check below, as in v1. Or do you mean there is a missing
> check on the error value? In which case I can extend this check to
> verify we have ENOENT.

The former, probably. I don't see how map-in-map is different for
lookups and why it needs special handling.

>
> >> +       if (map_is_map_of_maps(map_info->type) ||
> >> +           map_is_map_of_progs(map_info->type))
> >> +               return;
> >> +
> >> +       if (json_output) {
> >> +               jsonw_start_object(json_wtr);   /* entry */
> >> +               jsonw_name(json_wtr, "key");
> >> +               print_hex_data_json(key, map_info->key_size);
> >> +               jsonw_name(json_wtr, "value");
> >> +               jsonw_start_object(json_wtr);   /* error */
> >> +               jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
> >> +               jsonw_end_object(json_wtr);     /* error */
> >> +               jsonw_end_object(json_wtr);     /* entry */
> >> +       } else {
> >> +               const char *msg = NULL;
> >> +
> >> +               if (lookup_errno == ENOENT)
> >> +                       msg = "<no entry>";
> >> +               else if (lookup_errno == ENOSPC &&
> >> +                        map_info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
> >> +                       msg = "<cannot read>";
> >> +
> >> +               print_entry_error_msg(map_info, key,
> >> +                                     msg ? : strerror(lookup_errno));
> >> +       }
> >> +}
> >> +
> >
> > [...]
> >
>
