Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECF21B3080
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgDUTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:38:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726056AbgDUTiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587497933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XpzSuVd5V90PhL6BcnqHLDwFt8T6eWsi+nTokkINhMc=;
        b=LvSyDstQ37/zWriQDAJhvrf63yBhbxruIm/+wLmdAFWOPA2H3cY0MV0Gbv0x4atQERVBN9
        YoIzfpBbm74RgIwgtoMgE/GSn+G+Hbw6nuIX135LT0y4MMkX6p0K+2apcFM9H+BgEwMczL
        B+1E3W7NOo6cT8jMHxa8oWydlCQ8uyE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-73FT0mauNcGfEdDowlf4Mg-1; Tue, 21 Apr 2020 15:38:51 -0400
X-MC-Unique: 73FT0mauNcGfEdDowlf4Mg-1
Received: by mail-ed1-f70.google.com with SMTP id y4so5678550edq.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XpzSuVd5V90PhL6BcnqHLDwFt8T6eWsi+nTokkINhMc=;
        b=MmswKt1jtaZRUKtvXPxtAMMIXBYofpFpTbXr8L5lxRRZgwLHwEhBJMjpAmM2PXDeTC
         T7CBsQQS7h4/EhJR1Aymaz8+1I6Hi9Yh+VTyW/ko6x1OsCJ/MjwlDd2RYJyh0ii5w9TN
         jiL4m18Y1oHogwxVt6/0xmNEC8WWZsbLG+sXfvKlunYV6t0h8aRUjoSFoujY3dZXq1BX
         nqREanvOyxEWGAIMtlrTNLxrMNaVGnVuLMOwbFjO7QHjccwfPmwZ4hQRalSPOaMAXvru
         RacFbPANCcRSAWpraDEh4q0DjM6IcEKspktKcE8X9na6w+VtdBoKeuCGp/bmP1UoiJ5Z
         FxUw==
X-Gm-Message-State: AGi0PuaSMsXLPOVVTa3PNroykIUhv84GhDQlPswBlmUTOCEs4YH/fiSx
        9F3BX3TKmhpvYhSWdcKeVtxe9NkbDjxxZd7mzCf8WqrA0VrZ3HVnx4c0XixDc6FMUve5JspcPS9
        OSXqxt/xkgXNraHAubd7PITiNzs3MWJp+
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr19981728edb.53.1587497930361;
        Tue, 21 Apr 2020 12:38:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypLois5vd7B6oePoU4Vt2PhuYIVz5rdLtwqNSUK9+SJn5hoeZ3oZqh9qIPHMaXgGx82nEwi00xDMswYhGIIS+Qs=
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr19981713edb.53.1587497930158;
 Tue, 21 Apr 2020 12:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200421180426.6945-1-jhs@emojatatu.com>
In-Reply-To: <20200421180426.6945-1-jhs@emojatatu.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 21 Apr 2020 21:38:38 +0200
Message-ID: <CAPpH65zGO02uQyWQXXq6Yg_zsZcVZg+4-KWfRo_q3iACHr6s_Q@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is used
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 8:05 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> From: Jamal Hadi Salim <hadi@mojatatu.com>
>
> Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  lib/bpf.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 10cf9bf4..cf636c9e 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1509,12 +1509,12 @@ out:
>  static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>                                 const char *todo)
>  {
> -       char *tmp = NULL;
> +       char tmp[PATH_MAX] = {};
>         char *rem = NULL;
>         char *sub;
>         int ret;
>
> -       ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> +       ret = sprintf(tmp, "%s/../", bpf_get_work_dir(ctx->type));
>         if (ret < 0) {
>                 fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
>                 goto out;
> @@ -1547,7 +1547,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>         ret = 0;
>  out:
>         free(rem);
> -       free(tmp);
>         return ret;
>  }
>
> --
> 2.20.1
>

Hi Jamal,
Are you sure this fixes your issue? I think asprintf could segfault
only if ctx is null, but this case is not addressed in your patch.
I remember that Stephen asked me to use asprintf to avoid allocating
huge buffers on stack; anyway I've no objection to sprintf, if needed.

Andrea

