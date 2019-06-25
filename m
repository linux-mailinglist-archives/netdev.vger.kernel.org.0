Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8CA55626
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbfFYRqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:46:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34218 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbfFYRqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:46:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so13341611qkt.1;
        Tue, 25 Jun 2019 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vix286Y/fbmyQgkdzbS1ZRKTLuRz2xBroRyOC9U4nk=;
        b=Gusl3Shlfh6fUy4u3/UQhaQiTcta5CF9mKk1rHiIAEYDRvWyeoVn2s7qk/Sj7Z22yg
         xKlYrqtrNXwLEik+TD5jEFlYI/fbGx9yccMOflL0o/sejWw8pN9g5pO6+MT5epWYTOoL
         q6WDGxtz/tVbYwb1CFMBxpc6tbYX8kmsJeFaqdEpbqS2MQtNr7Hr3JLH0mVeqSwPKleU
         TSbN33DcSOPG/7BPQLKyI74W0qKOwXjcb8a6NbvzNu+abDAsq1bhEOKceS3aIQzHjCji
         aHho4Zf1hn7vr/Rn30AKw+RXiAtJJHkP1nK9z1MAh/PErPqNJ2cA2uRzbrCMo51DXZ1/
         EXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vix286Y/fbmyQgkdzbS1ZRKTLuRz2xBroRyOC9U4nk=;
        b=DOEuttDv/BkExhFVkyPJ/c7odx8PWysaxNp5uIgts2M+t0OO76MyuD+6eHkp6vQTjZ
         oBd6j/kUxn/eY/xHjVawyb1/Cg0J33AaqpAM08LZku0athzcZCcSdw9GlWoQmrTOi3Hk
         YUei/vxdk94DkLUVW5diuCZ3Q4OCw+d0LhDBtYhf4q0EVpk+OnVEaSEAdX16hvmryvZe
         z5P0hzodv6mUr0SOUptlEUZN943nXkQSRkl3fJsYOQC+Z3lT+MKDK8bNaQ13/dDq9TdX
         79mhTZTDmHI0U9cBg1QQkD5NnzxMIxh3UHWQ71bZnjU/OAuV699Sq0YbAVfRWBECBvj9
         nR0w==
X-Gm-Message-State: APjAAAWpWHUCn+VIFKdY1tt38mV7ehoK9Mlq/hx7g6ZiRViagdkL4jjp
        ief3U2QEJbESb8QxOX/kj10dOlD2sgmKBJaGqKg=
X-Google-Smtp-Source: APXvYqyQ2XggdBL8o8om2OczPjzRsLoVDlu5QWSpKbDYcRWr1lfOkN2wiawE9FwCf07FmF4ukRojruWUgMye6+m2tIU=
X-Received: by 2002:ae9:d803:: with SMTP id u3mr23500045qkf.437.1561484760462;
 Tue, 25 Jun 2019 10:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190625141142.2378-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625141142.2378-1-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Jun 2019 10:45:49 -0700
Message-ID: <CAEf4BzbOHXEfV9FSNsovWfRvke6imzJoh_=2F3o=No+TX3TAww@mail.gmail.com>
Subject: Re: [PATCH net-next] tools: lib: bpf: libbpf: fix max() type
 mistmatch for 32bit
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 7:12 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> It fixes build error for 32bit coused by type mistmatch

typo: coused -> caused, mistmatch -> mismatch

> size_t/unsigned long.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>
> Based on net-next/master

libbpf changes should be based against bpf-next. Indicate that also
with [PATCH bpf-next] subject prefix.

Also, there is no need to have this long "tools: lib: bpf: libbpf:"
prefix, it's not supposed to be a repeat of file path. Use just
"libbpf: " to indicate it's libbpf-related changes.


>
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4259c9f0cfe7..d03016a559e2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -778,7 +778,7 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
>         if (obj->nr_maps < obj->maps_cap)
>                 return &obj->maps[obj->nr_maps++];
>
> -       new_cap = max(4ul, obj->maps_cap * 3 / 2);
> +       new_cap = max((size_t)4, obj->maps_cap * 3 / 2);

The fix itself works, thanks!

>         new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
>         if (!new_maps) {
>                 pr_warning("alloc maps for object failed\n");
> --
> 2.17.1
>
