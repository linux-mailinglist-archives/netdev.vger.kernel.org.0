Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763983AC013
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhFRAXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 20:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhFRAXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 20:23:13 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2E4C061574;
        Thu, 17 Jun 2021 17:21:03 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id s19so251739ilj.1;
        Thu, 17 Jun 2021 17:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwBUHPn/nUswAacAb8l0k4vEO1b585QgUKlF1XS0z4E=;
        b=VOsoZyvUte64GBeqs6fU8Na/chZEVaeJt4neq1Z8kpQULdHUNTU6F/cRYUTRTOOkQi
         VDeJoARqjKjPvgnc7U5WT/7Og0mSkcBjc7mPqwsK5xiPKTabSt+y+LyxqkjDIA4C+UUK
         uF67rZj9o6NNHZtxsq2CV+12IhbgKXc/+SCgplZZ7ntlRR0wmBlAI+jpU7mtgUbo4cZC
         ibk0w4LgPwsIoMPtEHGXpl9tdQeNT359tIrZSvhaE0YmStZ2xvo2WSAJtmEC9kkRXbzD
         PmXrpj/Zx4AAJYAMNppBw9yK3uMpZm1QfPVDzWFMWlybAb9/xoQ/DG8Pivn0mGK8Gnrz
         PNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwBUHPn/nUswAacAb8l0k4vEO1b585QgUKlF1XS0z4E=;
        b=crqF+cyCliBGUCQJVrC1C1radgFsRr5wj4c52KwaJ8yxWxNnV/pK1rv/NpjgShpyRQ
         S1GrbVXoVDZjlBAE9DmQyILM8Yfu+gsAn9fNZPnOTqBg7/RXnTLXi+zgCxl8+A13/ZH3
         fxiEt/coreCdQYS/fs3pmpcoAEFTQpzCme0kIrno495qr4+iqrYR4ISJzq0yo+QOckIY
         AUtX72auwyWuAs5I8ngUdZh5aj9BOr0N0jAuUUTJy/qAOCQ9hAuz1VP3t9OfamiO1+mf
         M9QQXo5EHNt5dVlfhhZoKMO+Skp/7R0Yr+z7EfIHhOb6g6MDce3xnR3ktmnUppZow6WM
         ODGQ==
X-Gm-Message-State: AOAM531yA6iEneYouMy+alVVl9uM+DI4rBqvGCeziO5rwkezwkRxHP/8
        fGjzmDST2e63lt5+h4j9BLRTpGqujgyKhnUX+B4=
X-Google-Smtp-Source: ABdhPJwSzi/LEIO5Z3FwRtpscS2uHs7ZQ+MojHzel6FS0HeYMn4eDyfYPuL2qIIMRU49mbxdEg9sqNL+YNE3ARpDMXQ=
X-Received: by 2002:a92:b0c:: with SMTP id b12mr5144308ilf.123.1623975663391;
 Thu, 17 Jun 2021 17:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com> <YMopCb5CqOYsl6HR@krava>
 <YMp68Dlqwu+wuHV9@wildebeest.org> <YMsPnaV798ICuMbv@krava> <37f69a50-5b83-22e5-d54b-bea79ad3adec@iogearbox.net>
In-Reply-To: <37f69a50-5b83-22e5-d54b-bea79ad3adec@iogearbox.net>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Thu, 17 Jun 2021 17:20:53 -0700
Message-ID: <CAPGftE88-AszN=ftJGxcYWpS2VLq4ErpJOTemBWeBgzE8-bbZQ@mail.gmail.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@redhat.com>, Mark Wielaard <mark@klomp.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frank Eigler <fche@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 at 04:22, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/17/21 11:02 AM, Jiri Olsa wrote:
> > On Thu, Jun 17, 2021 at 12:28:00AM +0200, Mark Wielaard wrote:
> >> On Wed, Jun 16, 2021 at 06:38:33PM +0200, Jiri Olsa wrote:
> >>>>> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> >>>>> index d636643ddd35..f32c059fbfb4 100644
> >>>>> --- a/tools/bpf/resolve_btfids/main.c
> >>>>> +++ b/tools/bpf/resolve_btfids/main.c
> >>>>> @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> >>>>>           if (sets_patch(obj))
> >>>>>                   return -1;
> >>>>> + /* Set type to ensure endian translation occurs. */
> >>>>> + obj->efile.idlist->d_type = ELF_T_WORD;
> >>>>
> >>>> The change makes sense to me as .BTF_ids contains just a list of
> >>>> u32's.
> >>>>
> >>>> Jiri, could you double check on this?
> >>>
> >>> the comment in ELF_T_WORD declaration suggests the size depends on
> >>> elf's class?
> >>>
> >>>    ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
> >>>
> >>> data in .BTF_ids section are allways u32
> >>>
> >>> I have no idea how is this handled in libelf (perhaps it's ok),
> >>> but just that comment above suggests it could be also 64 bits,
> >>> cc-ing Frank and Mark for more insight
> >>
> >> It is correct to use ELF_T_WORD, which means a 32bit unsigned word.
> >>
> >> The comment is meant to explain that, but is really confusing if you
> >> don't know that Elf32_Word and Elf64_Word are the same thing (a 32bit
> >> unsigned word). This comes from being "too consistent" in defining all
> >> data types for both 32bit and 64bit ELF, even if those types are the
> >> same in both formats...
> >>
> >> Only Elf32_Addr/Elf64_Addr and Elf32_Off/Elf64_Off are different
> >> sizes. But Elf32/Elf_64_Half (16 bit), Elf32/Elf64_Word (32 bit),
> >> Elf32/Elf64_Xword (64 bit) and their Sword/Sxword (signed) variants
> >> are all identical data types in both the Elf32 and Elf64 formats.
> >>
> >> I don't really know why. It seems the original ELF spec was 32bit only
> >> and when introducing the ELF64 format "they" simply duplicated all
> >> data types whether or not those data type were actually different
> >> between the 32 and 64 bit format.
> >
> > nice, thanks for details
> >
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
>
> Tony, could you do a v2 and summarize the remainder of the discussion in
> here for the commit message? Would be good to explicitly document the
> assumptions made and why they work.

Sure, Daniel, I'll update the commit details and resend.

Thanks,
Tony

> Thanks everyone,
> Daniel
