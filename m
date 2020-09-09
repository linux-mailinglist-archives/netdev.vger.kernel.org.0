Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69C2625DD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIIDZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIIDZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:25:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FA5C061573;
        Tue,  8 Sep 2020 20:25:56 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so839585ybp.7;
        Tue, 08 Sep 2020 20:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQzP3qMNJLuczXCC+WxQGE1gywPOFL//QF+1PhnCBDc=;
        b=SXTA3f3ADlLymiETeg3VniPCAQBArC+CgNSjzFpsL+pH/j9uaCzQSWweQKaMovXn/s
         Pyru3CF7T6bZ3H0f8C4Q0JZRv1KS0QMLDZk89aHaVKfoJpAWVlPD5Owj50IrDLZ5qCDm
         8Bv+fjpqaHTlmLvYaWlRHYVRCn3gy4zaqp3gDk6d7zYyBIYZXfZq2ZCjgwMACWpOJQ38
         eERvpWjU/f782orkjuIJ+D+/L84YPCR6Zhe9xgz2Hap9a8zECcVSV9Cr5wTolW1ZjHVo
         6cZ3GgMQmpVrxzvroMr+oiGP5ZFOVFFaKILPQHCE9MqC1L4xT1q5xU8yV9YEVE99/LX6
         qYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQzP3qMNJLuczXCC+WxQGE1gywPOFL//QF+1PhnCBDc=;
        b=UC0lOYk5kwBL7fkg1/SE2CnShqOh28JjZE8pbB/lGA9vYbuZb2d2Q/5cJH4/7q1S8J
         x74RBLse7fnZx8hwb+EvFpX0zLIcoKlhjoFUt9uiFq5NDy/aiJv+awm33ZyatCpx33fa
         ESXWGPl99jwX67Im5DmfZNfZ7trjN8maZDRTnwS1Uonxfz17OeqOmKz0GXhu6vnGeIpM
         JTsb2OESgmewQbaQt4a7Fz0UbQoVWG0uEz65tM+mZ/NV83pSgmHOafQBW9eDRhbEIYGD
         DndUC3NQAoi4H1YRIb5UKvWByP9kRclGeEC+EjnuYeDiq0UMtey/IQSNhz9aPXG54dm1
         g29A==
X-Gm-Message-State: AOAM53029dYiwn5XE0w23REIDMAiu7bI/tlQgDPidVth3m7DNb8KmcZr
        2fdxI1tAK2Vz3CVwpAdlird83LGXyliTO49wgR8=
X-Google-Smtp-Source: ABdhPJzCZDN4a9Tfak/V0n/2f+/JXLRqo1YfvAKlBUHDP+/A3Pf3oFBbH44Iq3uOuY2RKOUleeFN3rPwV9Ka+s1JvYI=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr2887086ybg.425.1599621955706;
 Tue, 08 Sep 2020 20:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200907163634.27469-1-quentin@isovalent.com> <20200907163634.27469-2-quentin@isovalent.com>
In-Reply-To: <20200907163634.27469-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 20:25:44 -0700
Message-ID: <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
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

On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The function used to dump a map entry in bpftool is a bit difficult to
> follow, as a consequence to earlier refactorings. There is a variable
> ("num_elems") which does not appear to be necessary, and the error
> handling would look cleaner if moved to its own function. Let's clean it
> up. No functional change.
>
> v2:
> - v1 was erroneously removing the check on fd maps in an attempt to get
>   support for outer map dumps. This is already working. Instead, v2
>   focuses on cleaning up the dump_map_elem() function, to avoid
>   similar confusion in the future.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
>  1 file changed, 52 insertions(+), 49 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index bc0071228f88..c8159cb4fb1e 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
>         jsonw_end_object(json_wtr);
>  }
>
> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> -                             const char *error_msg)
> +static void
> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
> +                     const char *error_msg)
>  {
>         int msg_size = strlen(error_msg);
>         bool single_line, break_names;
> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
>         printf("\n");
>  }
>
> +static void
> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
> +{
> +       /* For prog_array maps or arrays of maps, failure to lookup the value
> +        * means there is no entry for that key. Do not print an error message
> +        * in that case.
> +        */

this is the case when error is ENOENT, all the other ones should be
treated the same, no?


> +       if (map_is_map_of_maps(map_info->type) ||
> +           map_is_map_of_progs(map_info->type))
> +               return;
> +
> +       if (json_output) {
> +               jsonw_start_object(json_wtr);   /* entry */
> +               jsonw_name(json_wtr, "key");
> +               print_hex_data_json(key, map_info->key_size);
> +               jsonw_name(json_wtr, "value");
> +               jsonw_start_object(json_wtr);   /* error */
> +               jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
> +               jsonw_end_object(json_wtr);     /* error */
> +               jsonw_end_object(json_wtr);     /* entry */
> +       } else {
> +               const char *msg = NULL;
> +
> +               if (lookup_errno == ENOENT)
> +                       msg = "<no entry>";
> +               else if (lookup_errno == ENOSPC &&
> +                        map_info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
> +                       msg = "<cannot read>";
> +
> +               print_entry_error_msg(map_info, key,
> +                                     msg ? : strerror(lookup_errno));
> +       }
> +}
> +

[...]
