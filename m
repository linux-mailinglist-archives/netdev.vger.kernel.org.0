Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE702FF87B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbhAUXL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAUXLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:11:17 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069C9C061756;
        Thu, 21 Jan 2021 15:10:37 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id b11so3697536ybj.9;
        Thu, 21 Jan 2021 15:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFFyp0an9z6ceYvBlREfDntyLx+f2WYNnkvqDcimax8=;
        b=OOIpVw0bE3O1Vq0ocNiUGrrpTs2RhI/CWZ33OFW1vmL7qqs7RDUmcLdQnjsqRZLVTK
         brlQCK2K1/nMhQUIvwB4e9B1EudfArJJY8Y3qRxFjIvu0IAwZdSb5i2IeeQC7dRM+14x
         CXP5AFRM7cqGKDOEDCKmCFmCmn/MnFPJ0x/FWa3JxS7akK5Vu3Iq5mvjDr0oJnoc3hg/
         p28ZtCyQQ0vh8yYluFoMergI9dWbRTrPnS6Od6qxUXVYTcWIB4+3XQyTJ/aJGbxq3vRn
         n9d12osem3p6B0nlZGY425Io4eOuqbdSE5F6KFWQ+vXf2rM31nMgMBUf+i9YUPlvoYsl
         0f8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFFyp0an9z6ceYvBlREfDntyLx+f2WYNnkvqDcimax8=;
        b=AYb1/w+U1N/nLMd4PStrdx5s/vznG2C/U1I1zOOgSED/qT1DCANjij6NOuXB0mZuD0
         Cgd8UNXJ46xctjYmQ4JtshiVx/MEFwphxfNSyHX3esujMyDKqogavjsmOYIbzWeQyPrC
         8jqHCsv3nFyIchPgdplGxgLdvalxCiwSwgZLTzPvOtDadcT+u1ZlWMrghcN2e28UNoBE
         eb5Diate4/O86NsJ4jcjUZlWggqJgQrh/BZMab9D9LVpCHPcYUvo7tonLXWVOrRQQPr9
         D2lomE3jKMZA90KRGA6T/Hf8tWJ48tmtuGeLdIkXJDo+5lB6jL2Y27Q5EiKZZb7cXSdz
         Nn2g==
X-Gm-Message-State: AOAM532WVV2jCHNNv/fW39F6Bs4nkE7D5AoD0RzFBmmTQRo3hJjgRap5
        oojjS5rqY3yxCYVf/Eh8h2g8wz/K1oWSUafpqFY=
X-Google-Smtp-Source: ABdhPJxfhRYoc3vLG8+s7Id7lMX+MJciTJQ/oIDC+EPjZXW4ghHrOJU9GHpJuAnPsA8+0rzATqEslleQhBFISRr98kE=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr2434566yba.260.1611270636310;
 Thu, 21 Jan 2021 15:10:36 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-2-jolsa@kernel.org>
In-Reply-To: <20210121202203.9346-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 15:10:25 -0800
Message-ID: <CAEf4BzY5CSNjoe19V4GAbFM1N4o4jM38G6yahAhr5bAaDVcYxA@mail.gmail.com>
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

On Thu, Jan 21, 2021 at 12:24 PM Jiri Olsa <jolsa@kernel.org> wrote:
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
> index 7b667647420f..9e0fdca3ae04 100644
> --- a/dutil.c
> +++ b/dutil.c
> @@ -179,13 +179,17 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  {
>         Elf_Scn *sec = NULL;
>         size_t cnt = 1;
> +       size_t str_idx;
> +
> +       if (elf_getshdrstrndx(elf, &str_idx))
> +               return NULL;
>
>         while ((sec = elf_nextscn(elf, sec)) != NULL) {
>                 char *str;
>
>                 gelf_getshdr(sec, shp);
> -               str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> -               if (!strcmp(name, str)) {
> +               str = elf_strptr(elf, str_idx, shp->sh_name);
> +               if (str && !strcmp(name, str)) {

if (!str) would be an error? should we bail out here?

>                         if (index)
>                                 *index = cnt;
>                         break;
> --
> 2.27.0
>
