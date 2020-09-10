Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5687264A1E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgIJQpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgIJQnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:43:50 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240E1C061573;
        Thu, 10 Sep 2020 09:43:16 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id s92so4516558ybi.2;
        Thu, 10 Sep 2020 09:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ewHZcDn+dXXNS1Aeg61LmSAwCVon+5r9x8BXoLZPFqQ=;
        b=FS7m6qSmAvOB+0hNtiHyCIpHmn4tL6iCbJtZ7StfNQRKGvtw3va6ISaZ7/wOgh00sL
         xiIuzKnzRoLpwWERwE92RHgSv08mScs+QN8KM+IRwYJvCKrpnDsW6Mmxs/OHmAE6+VpV
         uuqO2m21UxmVOc/fTK7P+GTjUd6JRhxOk3Sb0/YBBjs++2pSbttJ8z6k0zGPkXK++YCo
         WAfB8EIS24LHdcvdlkI7pv1/kl7wC2Z9e6vIAgi1yt32+FVIpPTtXevHSNV1o8sfQ7Gm
         KqZbIEmAWbEx8Qj6sXq1I6gQyExMND44Qw7MMqGibVTjpsht4Nb3bEXgZw2VkrSytbeV
         XUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ewHZcDn+dXXNS1Aeg61LmSAwCVon+5r9x8BXoLZPFqQ=;
        b=gsjNQNxh/bLlRlTy1SudK9GUuZRQGQu+5nHZ2I3wKVr18k8Y3RhGJIi1vcr5oU1JX+
         CajSMuOSql+YuV1XrbkYPGXR4i2lbiP8nQpqAbiErtx8lzu3siOkM9TnqeczTwI/UVqJ
         JPe7/fpP4byvWp5K+VjP6I63PjoihWgnU8rl6QOhWehsurnOZ6cSaws/gXYhstekJUuX
         d5RHdfE1J6OL+eUmwJJNbGP8ns6cJnJj5HdDYuCoCMWkarkcr4/pF3QEK6fVraaFgynl
         19dCVOLm4nffM1dupSckTz0650byASdAK6HFxH502KQoHURW5Vi5l5GI8FnTnbwXOs6u
         bjxw==
X-Gm-Message-State: AOAM53309GOdceb4wo1O9oQ7n/IBlS+9JIIk+VYepq9z2AgsCnTsJYer
        /Lg+kPB8R9MvWK9SVucl8fLmQOHGo87jzbT2/Vs=
X-Google-Smtp-Source: ABdhPJwZzlVFx3Wpv/EXpoRWNuunIcs8q5FVj7E1g/plvz1KrV+Htl1brI8knhy5taiUouMi1iedkEH9KdisxqMENlM=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr14583231ybc.260.1599756196182;
 Thu, 10 Sep 2020 09:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200910102652.10509-1-quentin@isovalent.com> <20200910102652.10509-2-quentin@isovalent.com>
 <CAEf4BzZZce3evrwkjQ1EbiHo5b_QKWn1kvCkZ=04X594Ee9RjA@mail.gmail.com>
In-Reply-To: <CAEf4BzZZce3evrwkjQ1EbiHo5b_QKWn1kvCkZ=04X594Ee9RjA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 09:43:05 -0700
Message-ID: <CAEf4BzY3EVQg_THrPaQW5LKWQokKuj3gvJq3Yqmm+ehXQ1604A@mail.gmail.com>
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

On Thu, Sep 10, 2020 at 9:41 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 10, 2020 at 3:27 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > The function used to dump a map entry in bpftool is a bit difficult to
> > follow, as a consequence to earlier refactorings. There is a variable
> > ("num_elems") which does not appear to be necessary, and the error
> > handling would look cleaner if moved to its own function. Let's clean it
> > up. No functional change.
> >
> > v2:
> > - v1 was erroneously removing the check on fd maps in an attempt to get
> >   support for outer map dumps. This is already working. Instead, v2
> >   focuses on cleaning up the dump_map_elem() function, to avoid
> >   similar confusion in the future.
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
> >  1 file changed, 52 insertions(+), 49 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > index bc0071228f88..c8159cb4fb1e 100644
> > --- a/tools/bpf/bpftool/map.c
> > +++ b/tools/bpf/bpftool/map.c
> > @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
> >         jsonw_end_object(json_wtr);
> >  }
> >
> > -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> > -                             const char *error_msg)
> > +static void
> > +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
> > +                     const char *error_msg)
> >  {
> >         int msg_size = strlen(error_msg);
> >         bool single_line, break_names;
> > @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >         printf("\n");
> >  }
> >
> > +static void
> > +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
> > +{
> > +       /* For prog_array maps or arrays of maps, failure to lookup the value
> > +        * means there is no entry for that key. Do not print an error message
> > +        * in that case.
> > +        */
> > +       if (map_is_map_of_maps(map_info->type) ||
> > +           map_is_map_of_progs(map_info->type))
>
> && lookup_errno == ENOENT
>
> ?

Never mind, you did it in a separate patch.

Acked-by: Andrii Nakryiko <andriin@fb.com>
>
>
> > +               return;
> > +
>
> [...]
