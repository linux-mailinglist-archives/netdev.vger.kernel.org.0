Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537851EC139
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgFBRj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgFBRj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:39:57 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B641FC05BD1E;
        Tue,  2 Jun 2020 10:39:57 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c185so13350496qke.7;
        Tue, 02 Jun 2020 10:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdvA9kDIBzucfn/6IgtzkjYebMxFXuhS6oUsUI3IUbg=;
        b=qIJMtL0f5UBsR6FtXMMz4qvs5BxZxXnR0kiWutWBXQeYEi50JyBCH5HzOZzd0uFit3
         tuO58iYAgRyPBpslUryfngBZC6J9zP7ajVq3Rx5H/CytJqQfMBN8tWQfYTJ6Qb3tDh8w
         aOxbWyNkfNjs8hg68n8sedVy5+oKXhFZVZsyqeQepJC/XE1JLMQOzyCCGwiX6CgDCSJF
         eb/jWTXGP+WHrX6fKwYsdSBxEMi/NG34Z4eboglWLDHP62i/1n9BywVb1Kbg91ydPXIc
         XikwWgIZbZmMOSFsuId7668TOMx9HoT9YMbi1qJgoqQOH4g4XjsBccyJtPGtzydK4DWH
         2L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdvA9kDIBzucfn/6IgtzkjYebMxFXuhS6oUsUI3IUbg=;
        b=MYW2OL91WPoE8g3gTaDcAceT1adkiH8rZadGKgKUyvlsWuGfkso+3r/Lx6JrXIjCqB
         mzp5sfBh197QtHg6vGCZl1NOG7NfXeDasGQNXUzHSBfAuW8C098NW1VRPsSAg+3bucLL
         Lm3pLRlv2bLrc0mrVdTpM+yJ80mUJo5nP/dwSRdxNPRy9qZqwO5O+ICswqlD1RtClEU0
         u5wdu6j7yAN2984iAMfU13dKtcqpQ9u6hHqH93OU1A2VzLSvQAjFEp8zVmwttgSb2PTS
         F8JzH1K73vNuHX4nvgWIfz8qa9H7ve3uQbk7HA+ksIkhdrWx49hTwDtqhHdWEpU+13uF
         ziVA==
X-Gm-Message-State: AOAM533N4hvYEg4Ek08pDXGNc5dnEuUdyzyHcbE5E3ezNux8wFRG37df
        4YahbmNCrstopQGVDDGyhNg6xFrFv/viVJhRBOw=
X-Google-Smtp-Source: ABdhPJxSuUJI8zaC9OIAbfjZ7c4dKwnBkDkguezcDY1oDaRpnB1uxvSREFoHXvB0g/CW2n4diYN4h+ILkWy2aP84uu0=
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr26248551qkn.36.1591119596968;
 Tue, 02 Jun 2020 10:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com>
 <20200531082846.2117903-8-jakub@cloudflare.com> <CAEf4BzZqtuA_45g_87jyuAdmvid=XuLGekgBdWY8i94Pnztm7Q@mail.gmail.com>
 <87eeqx3j22.fsf@cloudflare.com>
In-Reply-To: <87eeqx3j22.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Jun 2020 10:39:46 -0700
Message-ID: <CAEf4BzZHjMKfzVBqOq2Zgobx9iniZV+ve1EEirxvDbRAHan6OA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/12] bpftool: Extract helpers for showing
 link attach type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 2:37 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Jun 02, 2020 at 12:35 AM CEST, Andrii Nakryiko wrote:
> > On Sun, May 31, 2020 at 1:32 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Code for printing link attach_type is duplicated in a couple of places, and
> >> likely will be duplicated for future link types as well. Create helpers to
> >> prevent duplication.
> >>
> >> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >
> > LGTM, minor nit below.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> >>  tools/bpf/bpftool/link.c | 44 ++++++++++++++++++++--------------------
> >>  1 file changed, 22 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> >> index 670a561dc31b..1ff416eff3d7 100644
> >> --- a/tools/bpf/bpftool/link.c
> >> +++ b/tools/bpf/bpftool/link.c
> >> @@ -62,6 +62,15 @@ show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
> >>         jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
> >>  }
> >>
> >> +static void show_link_attach_type_json(__u32 attach_type, json_writer_t *wtr)
> >
> > nit: if you look at jsonw_uint_field/jsonw_string_field, they accept
> > json_write_t as a first argument, because they are sort of working on
> > "object" json_writer_t. I think that's good and consistent. No big
> > deal, but if you can adjust it for consistency, it would be good.
>
> I followed show_link_header_json example here. I'm guessing the
> intention was to keep show_link_header_json and show_link_header_plain
> consistent, as the former takes an extra arg (wtr).

It's fine, it's a minor point, even though this order feels backwards to me :)

>
> >
> >> +{
> >> +       if (attach_type < ARRAY_SIZE(attach_type_name))
> >> +               jsonw_string_field(wtr, "attach_type",
> >> +                                  attach_type_name[attach_type]);
> >> +       else
> >> +               jsonw_uint_field(wtr, "attach_type", attach_type);
> >> +}
> >> +
> >
> > [...]
