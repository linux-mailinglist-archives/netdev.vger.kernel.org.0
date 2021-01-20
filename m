Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADD72FC663
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbhATBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbhATBXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 20:23:51 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CD2C061573;
        Tue, 19 Jan 2021 17:23:11 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p185so6732798ybg.8;
        Tue, 19 Jan 2021 17:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aB5Or3lI/qRSS51C0pnoSQ5oKzBYbujWPgstkZELdzc=;
        b=nUo0RPzs4UZN3xplRgxSRNcEG4O2fOa+m3P0tm6toHW/drXs6XA9kQ2F9OhEhEQfQS
         71bIJkWG2A9Nyv1ZqdsI9fiKGEiL5QZH6d+cU96DMUlCKra6+Wd0lqlRc8M0SLf3Zx9J
         XrxL0K8lTYsvZRVwlGXeMf7dWzjst0rC1TM7H9pQwe2IxThCjtGIqUPcQqxgQxQgYlzf
         h3M1NmSC5Q55o1gC4vo3pfixMngLsbWIBNX2AiHvnwnAUYREYj0bZqjMbSV7rVytC9gC
         pCZS+PYPihvTa8Ce4r+Ui/20GFmt+KIucSCpp1Lzt0i+fqnJgfkkQ8+NVO3BD9iCc3XI
         /Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aB5Or3lI/qRSS51C0pnoSQ5oKzBYbujWPgstkZELdzc=;
        b=AR9scsC41kTTNdIT2Iu9KzRQ+EBR2QjFY5zHYnIjAYUNQm5j+awda5fkgslwMJXo9s
         RHbjv6vM3tJXmXs1rfhb4uGgqaqhIOdgWrRtudtWu3THDKjY4mK0JUUH0yldOnuYlzp1
         lOZ6j3p6f8ZLNcufm4ciWnmLyKQKfw5/UABaA8vPgqo7Cwnck2HcQwdXAjV4XirYreON
         JSKn/2wNkv3HyDwbHFEte1w3l/AHZ5iTgL/OTHP7qj0IpfWCnzQ7dt/sX98b8SLgeUud
         c5MBDrAmka+e4ZgimTCNPPUSCEYnlhkVM+bABqv3+sT3Iu3mPnKl1/BFbi/Ybx2Srr9l
         2B7A==
X-Gm-Message-State: AOAM532yyqd8B7OcoQPlZR6HFBxuEmBKbusaryqzHY6Q6n9sxIjVhbQ4
        dLTSAjASWr1OB45I5eQ5NxJert59Tl8jubeGGEc=
X-Google-Smtp-Source: ABdhPJyip/5H2uffx15cFVwjuNyjEmFH1RNGvII/8jaSthBZ1cgbXvygTsqcrsluYwIoAaH179cExlx8SzTBIvAKK9s=
X-Received: by 2002:a25:9882:: with SMTP id l2mr9371267ybo.425.1611105790757;
 Tue, 19 Jan 2021 17:23:10 -0800 (PST)
MIME-Version: 1.0
References: <20210119221220.1745061-1-jolsa@kernel.org> <20210119221220.1745061-2-jolsa@kernel.org>
In-Reply-To: <20210119221220.1745061-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Jan 2021 17:23:00 -0800
Message-ID: <CAEf4BzYjTu-NbEQcgCXmKormPuQUQip+Qr4Qzr3X3VXPSwreBQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 2:16 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> In case the elf's header e_shstrndx contains SHN_XINDEX,
> we need to call elf_getshdrstrndx to get the proper
> string table index.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  dutil.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/dutil.c b/dutil.c
> index 7b667647420f..321f4be6669e 100644
> --- a/dutil.c
> +++ b/dutil.c
> @@ -179,13 +179,17 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  {
>         Elf_Scn *sec = NULL;
>         size_t cnt = 1;
> +       size_t shstrndx = ep->e_shstrndx;
> +
> +       if (shstrndx == SHN_XINDEX && elf_getshdrstrndx(elf, &shstrndx))
> +               return NULL;
>

see comment for patch #3, no need for SHN_XINDEX checks,
elf_getshdrstrndx() handles this transparently

>         while ((sec = elf_nextscn(elf, sec)) != NULL) {
>                 char *str;
>
>                 gelf_getshdr(sec, shp);
> -               str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> -               if (!strcmp(name, str)) {
> +               str = elf_strptr(elf, shstrndx, shp->sh_name);
> +               if (str && !strcmp(name, str)) {
>                         if (index)
>                                 *index = cnt;
>                         break;
> --
> 2.27.0
>
