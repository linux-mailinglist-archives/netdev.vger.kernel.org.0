Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8547264A0E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIJQmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgIJQmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:42:07 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41EAC061757;
        Thu, 10 Sep 2020 09:42:06 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s92so4514146ybi.2;
        Thu, 10 Sep 2020 09:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j/FAmiZLn2NHIdt/BnIyuZauPsBcI5Y86mudxaO7W+4=;
        b=Ajp9JS6MNey+us9Pc1QKgvFboU9E/e1Pwlspo3+49G1H6ft2I1ZUozdSuKVVIwDPOb
         lhaNJAInMr+95/F6LKoREd2RcwK7vFZz7x478HSbsnNMFbdtZAFCNz5YFazFjaH1T4G/
         VPrHgjMvnN6eJCSWxoEDe6ylKEE1uJm00HlwygkfffgvZZn/YZVV09MfRIkrefqzE3oN
         J7wPfb/wsJALPy2gDnB6ektUFXayWMgQLDBKmRIYp+zjsPKJe8pPdrt5qouvbR6n4gtG
         of5rVBkUWNyoWD0FZIUa11PVFbo2qaYkRYyhf1ODnS72+Jjy3tBS9dOYLtLuUBP+SU7O
         6x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j/FAmiZLn2NHIdt/BnIyuZauPsBcI5Y86mudxaO7W+4=;
        b=hWkv3T0NgdFJhjQxs5fAAXg6ojGQPSV9uV1bTTkQ7ABGPPKodhowD8Yf5FMDyNUk74
         pbAchsuyXyRDfeWLH3E1bKVf4UF+1gSjW6aKpaQMerQnSu518IDtpcSGny56V04caxTr
         ESfehN21r5Uy0jlqPAJOfoQIrYt1AnpU8xSqvohqlg0yLpZJGxV5FAvZQhTbhQIQvehy
         BseYQU4GxcnYbNVID8JSaiaQDIQyWwVTDnJh85WzJFZ3qPzAcrJ+glzSHL0E8UgI9OCw
         IpeqEuBWp1JEmngMAl9UVPEYPHmL6NFBVYJNJtNsT6K0aj10sDWvVTrGKpzMM3wqU/B4
         I8DQ==
X-Gm-Message-State: AOAM530O/naGoyNglA/Oe83Llm/y3+hE44L2brp1VAcHykXNVPDvpnzB
        o/D4znjEtS+o5dSeoeMRmexzDC34rSk+klqoako=
X-Google-Smtp-Source: ABdhPJyzeGX3FoeVhy4QEitIwFXb5GtZQ9yWK2Pwrzabmy/UkJR35cq+MC+7medqY4Hrshir1WO4OS5ZXPPQTcAutss=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr12631415ybp.510.1599756126120;
 Thu, 10 Sep 2020 09:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200910102652.10509-1-quentin@isovalent.com> <20200910102652.10509-2-quentin@isovalent.com>
In-Reply-To: <20200910102652.10509-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 09:41:54 -0700
Message-ID: <CAEf4BzZZce3evrwkjQ1EbiHo5b_QKWn1kvCkZ=04X594Ee9RjA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] tools: bpftool: clean up function to dump
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

On Thu, Sep 10, 2020 at 3:27 AM Quentin Monnet <quentin@isovalent.com> wrote:
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
> +       if (map_is_map_of_maps(map_info->type) ||
> +           map_is_map_of_progs(map_info->type))

&& lookup_errno == ENOENT

?


> +               return;
> +

[...]
