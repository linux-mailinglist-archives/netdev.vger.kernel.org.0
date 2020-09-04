Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD625E394
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgIDWDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgIDWDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 18:03:40 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D48C061244;
        Fri,  4 Sep 2020 15:03:40 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id r7so5256624ybl.6;
        Fri, 04 Sep 2020 15:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9rTuwDalLim1/NR0+c7mjQEPr/Nd5oT0U6Lw6aLPC4=;
        b=QZKfzoJVb0WDsk9Rrz4oE+wBEld63kqfBJOFD6PiCqM4z+ae2NIFN1LoWicNQQtKna
         dheTUmlvDj4q9ZglW59btgcRvWZJZWsvdeXuq2At7WF0w3+/nRNtUmD0agcQdLs0hlCw
         UT6YfCtDQTmp415gDxc6VydUs8oiwuhJ3ykgcTS6lc2BmLnGc9Rrndpdlr8J0wqB0NOk
         l2lrdgPtEoHMvhBPwCIGDIQFN8woel4P2+vVHaEHPhABiISIGwvzuSzfXEA6S5a/oEk1
         OWMJDqHLMQdplrn6ZLGu0UhfGdqF7lIS0zPOhPK0dyFbKrULuqwg+ek2BO+J2IG2W2Nb
         6DJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+9rTuwDalLim1/NR0+c7mjQEPr/Nd5oT0U6Lw6aLPC4=;
        b=lFnAmVpgn4rNkiQGgBBEV4gADeS0Xw8K84/0spKJcFvbHXNyrYD8ve3AIKBSy4r7tO
         2Gh1BIO5f5ZzVZA86s+OQnpojLDSw8bpS/OV/FJ1+tJa8XfwihDOIF5HnZGE0ONpAcy1
         bsXjbWwTEqJja4Ms8CjHUMU5t8r1PBju4vj464ZiPXZAbViWbiXHCAKoaGIuMyLkjUqW
         6yf6BCvyYhHLKkK0mcTMRPMor8YIalwwwdE6LP+uXw57Ijxn/qoS21n7qv3+VMA/84a2
         waXHE+cmeCgMT4YL4vhUQeLo1qc9Ee9OMOiuAKq/Up44zx0jl7gAjt4gI9embnx7uf0x
         zMlw==
X-Gm-Message-State: AOAM532oqpApMyIbEUwtMfLcj56qZdJn3TFWz1hoOdm27QbX3zojAdNs
        RtWamF7iaN3z9vxiIRx/ngm9UK3lnc1UnTG9E3A=
X-Google-Smtp-Source: ABdhPJxx43pri/z/DfGwMxmy3Dt+aDzXPW2iKll06QumFJ/4k527EYLeurt8frB2OMymIbjuQvCRpdImAMi99ZtGNj8=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr3644870ybi.459.1599257019603;
 Fri, 04 Sep 2020 15:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200904161313.29535-1-quentin@isovalent.com> <20200904161313.29535-2-quentin@isovalent.com>
In-Reply-To: <20200904161313.29535-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 15:03:28 -0700
Message-ID: <CAEf4BzbEE9sGp=z6MUuFoR=1_Ma27p-nH5BkEN+p2j20mhJ3mQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] tools: bpftool: dump outer maps content
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 9:14 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Although user space can lookup and dump the content of an outer map
> (hash-of-maps or array-of-maps), bpftool does not allow to do so.
>
> It seems that the only reason for that is historical. Lookups for outer
> maps was added in commit 14dc6f04f49d ("bpf: Add syscall lookup support
> for fd array and htab"), and although the relevant code in bpftool had
> not been merged yet, I suspect it had already been written with the
> assumption that user space could not read outer maps.
>
> Let's remove the restriction, dump for outer maps works with no further
> change.
>
> Reported-by: Martynas Pumputis <m@lambda.lt>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/map.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index bc0071228f88..cb3a75eb5531 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -739,10 +739,6 @@ static int dump_map_elem(int fd, void *key, void *value,
>         /* lookup error handling */
>         lookup_errno = errno;
>
> -       if (map_is_map_of_maps(map_info->type) ||
> -           map_is_map_of_progs(map_info->type))
> -               return 0;
> -

this code path handles the error case when lookup fails, or am I
misreading it? It's fine to remove this restriction, but the commit
message is completely misleading. That whole dump_map_elem() code is a
bit confusing. E.g., what's the purpose of num_elems there?..

Also, can you please update the commit message with how the output
looks like for map-of-maps with your change?

>         if (json_output) {
>                 jsonw_start_object(json_wtr);
>                 jsonw_name(json_wtr, "key");
> --
> 2.25.1
>
