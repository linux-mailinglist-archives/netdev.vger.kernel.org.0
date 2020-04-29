Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC721BE8A2
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgD2Uga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgD2Ug3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:36:29 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB873C03C1AE;
        Wed, 29 Apr 2020 13:36:29 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n143so3491511qkn.8;
        Wed, 29 Apr 2020 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wa1e1Y92lYvZrPhLeN+VLU3x02Trx+J7qlyl+rZbDUU=;
        b=mvj52mA/xDeZyh4CUMZzSUOlhh19TXjFKAujr/Pw2bcSm8jhF4MIsrYlxLBJIDBzQF
         ECoRb6zvSZCVB8YCU4e3EMg6CmDBAOS2tKiII9yKK/LsUKzqajpRY5VF2hPsi7/vOeML
         ZFhnWJ49pRJjcT+fn91yKO2K/9/KpFnNnN0+b9PpJYCk+ttzf5+UNyr4vd12VSSCaD6N
         2erVi5RMOMMhfJRe6n/bSJn2OpxxkNo739fHiC/v8Pjoim5Ga1KNMjBOVNckG2MtxzlB
         pJq5vuOQuTItE3xdT2BjknUqo9/pftJwNz1vZMAH5U5GF6oy+3PeoK1YZDnFvJAGFt7D
         UPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wa1e1Y92lYvZrPhLeN+VLU3x02Trx+J7qlyl+rZbDUU=;
        b=bgd1bliqVNiWbfuZVyHYOGyJYPJERHwhiYKrudvrfV+Bp7NMW91v9nKsOd6qPt2DqV
         5Z/zP551kd+/qUFLY+4WmwhNJ76WtW5VQXgD7dbeQpeYjsEc3ox+0YXgcffw8JrtG3T2
         KyolbeUe4RBBbzZz5yD+fEXrpyIbgmCoDHBDMWN9hgsvIhZxVztA3oAm7DMcgNeby12/
         QkiojcIGa+Y2HLuYeKgJeInnT93Jveuo9rLrQAbIVC/b8VWWWtp63NV8paiPpbhl+UYI
         hIuUNBdsVxKKIS0dri5vWIfEmeFRAUpqkoMMeRVxDt8HCkUDAvGTetsptX08WbJaIZZd
         kysA==
X-Gm-Message-State: AGi0PubTN+iansZ/kxNO6M6+YzBwmuhhU1QxthCWx3gPivvDM268T0qu
        euQl28x+IQ7JbAkY9xtsAAYc6wGt7DtYAdJrERU=
X-Google-Smtp-Source: APiQypK+ScNFRjviccmciq+hSgbQJQz0BvntvfGNdmkmNvKb+9q8VMEfGiSIBuE7+efgCn20i36lQOb2Fo5ytWh9By8=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr338783qkg.36.1588192588839;
 Wed, 29 Apr 2020 13:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200429132217.1294289-1-arnd@arndb.de>
In-Reply-To: <20200429132217.1294289-1-arnd@arndb.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 13:36:17 -0700
Message-ID: <CAEf4Bzahz15mGQC21Hr9dfCE6uDrgWvARr2_0f0i592keW3orQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix unused variable warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 6:23 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Hiding the only using of bpf_link_type_strs[] in an #ifdef causes
> an unused-variable warning:
>
> kernel/bpf/syscall.c:2280:20: error: 'bpf_link_type_strs' defined but not used [-Werror=unused-variable]
>  2280 | static const char *bpf_link_type_strs[] = {
>
> Move the definition into the same #ifdef.
>
> Fixes: f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks for the fix, LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 3cea7602de78..5e86d8749e6e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2274,6 +2274,7 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
>         return 0;
>  }
>
> +#ifdef CONFIG_PROC_FS
>  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
>  #define BPF_MAP_TYPE(_id, _ops)
>  #define BPF_LINK_TYPE(_id, _name) [_id] = #_name,
> @@ -2285,7 +2286,6 @@ static const char *bpf_link_type_strs[] = {
>  #undef BPF_MAP_TYPE
>  #undef BPF_LINK_TYPE
>
> -#ifdef CONFIG_PROC_FS
>  static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  {
>         const struct bpf_link *link = filp->private_data;
> --
> 2.26.0
>
