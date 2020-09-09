Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F86263299
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgIIQqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731122AbgIIQqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:46:42 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29D3C061573;
        Wed,  9 Sep 2020 09:46:41 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h20so2184373ybj.8;
        Wed, 09 Sep 2020 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xjky72/eXkU1IWx1SYAxUfxbytZkGrTfS89mScUWxRM=;
        b=layTVNFeoOAhMnKFQAHUSpSRwnn98zi5mVWD93/jTfTVB/uDuvt7xxGroy3euXb6uW
         GiPMTI9B4JdG5McuSc2uTwPYl17fBMWkHHjoXgOXFy7hZShBZ9elvR8x+fHSQ0efORUZ
         hziZon92f8msXlsw0dPHltZvY6/UUa7OwpW+8syhHh4zgRVhzXasXi2Bh0IT4mJ59NXW
         AZmy25H9+IVWsXlAfV81R3vei0rgGUDqGSBbXhGLE68AzEYAzEazJ4Dgjx6ZbvmpKhiI
         sgZJuCOOJFgp2iyCUmEnxPQHcLS+3Qf2GhRLfAcmIiN15ZyUgnREZ1yoRpGuhtE4GDZQ
         2ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xjky72/eXkU1IWx1SYAxUfxbytZkGrTfS89mScUWxRM=;
        b=KSdBQBMi1vFIQWWIZj3rIQnNNfldfBd9p9vQbzFmoU9fZiDmWnDVGJ0XI7ipWIpgeq
         h3XiVSNoKYxGrQlzNq/yFkQNe+4NuLqj0alv/LQ2v/uQehOxYnX3v2gL0MD+VCu86whQ
         kB87Gnn96+55CIEBwYnSTzJA6F9v3vE+loRSIfJxCFnzf94VHcP9bmHmaSrKFxn0Lxh3
         ZRxgstyVf8ygMIeAkv/EMjNlTk3tb+ywzqYfRKp98Ys0NKxGFVcfcVutPGxf08wmV6H+
         CWNtywhQ8jpZ8y28LOWWcq79ggSU2tEJhp4EIwzEDukmB2vkR9jmsjQvtUtMJEVl4swI
         9vrg==
X-Gm-Message-State: AOAM531mQUB5znL1B7BO1mTKOB+0jtu5O0I8csCVTO2RkO/HYkUc0vHA
        /43nJJTaNToWnBhlzfhG+IKzrE8BhY9T5sdzob0=
X-Google-Smtp-Source: ABdhPJwx64fE2sXx+vfSwZu4lfiGkLK1h8oSb1aaNGLGfpIBEexAcm1FHFTi7ydhCSsn0ro1N+1bJ8sz0tR49xHRLT4=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr7233898ybc.260.1599670001028;
 Wed, 09 Sep 2020 09:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200907163634.27469-1-quentin@isovalent.com> <20200907163634.27469-2-quentin@isovalent.com>
 <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
 <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com> <CAEf4Bzb0SdZBfDfd2ZBXOBgpneAc6mKFhzULj_Msd0MoNSG5ng@mail.gmail.com>
 <5a002828-c082-3cd7-9ee3-7d783cce2a2a@isovalent.com>
In-Reply-To: <5a002828-c082-3cd7-9ee3-7d783cce2a2a@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:46:30 -0700
Message-ID: <CAEf4BzZA3Zcf9imXVEQ_x0cTiC8JV8jXV-iaaQC+NP4mqt_V_Q@mail.gmail.com>
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

On Wed, Sep 9, 2020 at 9:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 09/09/2020 17:30, Andrii Nakryiko wrote:
> > On Wed, Sep 9, 2020 at 1:19 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> On 09/09/2020 04:25, Andrii Nakryiko wrote:
> >>> On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>
> >>>> The function used to dump a map entry in bpftool is a bit difficult to
> >>>> follow, as a consequence to earlier refactorings. There is a variable
> >>>> ("num_elems") which does not appear to be necessary, and the error
> >>>> handling would look cleaner if moved to its own function. Let's clean it
> >>>> up. No functional change.
> >>>>
> >>>> v2:
> >>>> - v1 was erroneously removing the check on fd maps in an attempt to get
> >>>>   support for outer map dumps. This is already working. Instead, v2
> >>>>   focuses on cleaning up the dump_map_elem() function, to avoid
> >>>>   similar confusion in the future.
> >>>>
> >>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >>>> ---
> >>>>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
> >>>>  1 file changed, 52 insertions(+), 49 deletions(-)
> >>>>
> >>>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> >>>> index bc0071228f88..c8159cb4fb1e 100644
> >>>> --- a/tools/bpf/bpftool/map.c
> >>>> +++ b/tools/bpf/bpftool/map.c
> >>>> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
> >>>>         jsonw_end_object(json_wtr);
> >>>>  }
> >>>>
> >>>> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >>>> -                             const char *error_msg)
> >>>> +static void
> >>>> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
> >>>> +                     const char *error_msg)
> >>>>  {
> >>>>         int msg_size = strlen(error_msg);
> >>>>         bool single_line, break_names;
> >>>> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >>>>         printf("\n");
> >>>>  }
> >>>>
> >>>> +static void
> >>>> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
> >>>> +{
> >>>> +       /* For prog_array maps or arrays of maps, failure to lookup the value
> >>>> +        * means there is no entry for that key. Do not print an error message
> >>>> +        * in that case.
> >>>> +        */
> >>>
> >>> this is the case when error is ENOENT, all the other ones should be
> >>> treated the same, no?
> >>
> >> Do you mean all map types should be treated the same? If so, I can
> >> remove the check below, as in v1. Or do you mean there is a missing
> >> check on the error value? In which case I can extend this check to
> >> verify we have ENOENT.
> >
> > The former, probably. I don't see how map-in-map is different for
> > lookups and why it needs special handling.
>
> I didn't find a particular reason in the logs. My guess is that they may
> be more likely to have "empty" entries than other types, and that it
> might be more difficult to spot the existing entries in the middle of a
> list of "<no entry>" messages.
>
> But I agree, let's get rid of this special case and have the same output
> for all types. I'll respin.

Oh, wait, I think what I had in mind is to special case ENOENT for
map-in-map and just skip those. So yeah, sorry, there is still a bit
of a special handling, but **only** for -ENOENT. When I was replying I
forgot bpftool emits "<no entry>" for each -ENOENT by default.

>
> Thanks again,
> Quentin
