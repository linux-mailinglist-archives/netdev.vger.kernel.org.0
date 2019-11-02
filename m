Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C6FECD7D
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 06:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKBFhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 01:37:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42215 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 01:37:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id t20so252167qtn.9;
        Fri, 01 Nov 2019 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OG9hLEuv7GQ3E61qmEbOBxWkLP8bIBhb+RsbTM9GkBs=;
        b=R7wf+otcIYqnK1xw5C0XkOBzy2gt2HF/+dnnzWyv9OnU3TZZfdbzAoNKkmPCH1pPEk
         DMZfb+uoSmrFEjGvq/4roEV08iTE4sVyc9MOchHohSvXUc6CFPZ1lcQGfCR5gbJiqEoS
         Dr40tRMhMX9ZCB/iFvPeq2nKS8ydZbUSdQkoBpPy/LffwyZ2LQohlvKlCjoGCQhXMEJF
         bVPgee2ieQqp9c98SwO8Pwqxqdcb70UodkBKPKpw6j7Ay6rNgxn5a+Xq86iVzimMAF83
         FmYt7f7SKKOZBr/+XDnDKRrFixiaJbXXzyjoeLBC970U60VuGNEzrKN9SJOHIcmaQDYH
         vOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OG9hLEuv7GQ3E61qmEbOBxWkLP8bIBhb+RsbTM9GkBs=;
        b=PzV2C6o65CjMR+7A46bH4Bc3y8G8Y+4y/IdLllxjfCjE7AwdqIGd7QmeEFsR7YC4b/
         R6pbW9YpTbPBqMDneT2NI43Xc0H7Ms8Y9O/1xkUTNOrbuKabhW+rPbJ3i+4NNK5LhnjS
         pLi2MMVltZiCQOX/wYx0nYrnjfP6ve1oY+R+Jth40ZTsAlbGpuZqGWvBOKtJJCmPavkn
         S7M78lrjB+CGbvli7XYBspKdI2w7FWaDnwNMbEHu+sXDCJFw71+Lf74LB5UuNn+ckdUW
         /biQ0X+yiexIezQ/7uOFkaCXxrObrsAJuNws/nrzWl+Mr6Wr1ucQ+U6TNUx8+s/OoP5I
         RMUA==
X-Gm-Message-State: APjAAAV4kbJ2y2eUtzdtgeZFLbYdIjRmAonKoeg+ep3TmDg/ReGnpoaD
        WRg9xAj2lnrIl3Zti7G15VKfBpZSMgOZTFApKAU=
X-Google-Smtp-Source: APXvYqy8pJDXvtd6JSPpyihNnGzEGlxXBGh6C1u+QnBfIq6BSUB5+MC74djL5sEuhvL46XWUomOMmUQdeiIMxayoIWY=
X-Received: by 2002:ac8:29c8:: with SMTP id 8mr3304286qtt.117.1572673030267;
 Fri, 01 Nov 2019 22:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191101125707.10043-1-ethercflow@gmail.com>
In-Reply-To: <20191101125707.10043-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Nov 2019 22:36:59 -0700
Message-ID: <CAEf4BzZhNCbASJ+ze4ECddoWLZwr5a=HL7BZ1Zgg+Re=4cyNzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: add new helper get_file_path for mapping
 a file descriptor to a pathname
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 5:57 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
>
> This requirement is mainly discussed here:
>
>   https://github.com/iovisor/bcc/issues/237
>
> v4->v5: addressed Andrii and Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
> - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> - remove fdput from fdget_raw's error path
> - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
> into the buffer or an error code if the path was too long
> - modify the normal path's return value to return copied string lengh
> including NUL
> - update this helper description's Return bits.
>
> v3->v4: addressed Daniel's feedback
> - fix missing fdput()
> - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> - move fd2path's test code to another patch
> - add comment to explain why use fdget_raw instead of fdget
>
> v2->v3: addressed Yonghong's feedback
> - remove unnecessary LOCKDOWN_BPF_READ
> - refactor error handling section for enhanced readability
> - provide a test case in tools/testing/selftests/bpf
>
> v1->v2: addressed Daniel's feedback
> - fix backward compatibility
> - add this helper description
> - fix signed-off name
> ---

See nit below, but I'm fine with the current state as well.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f50bf19f7a05..fc9f577e65f5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -683,6 +683,53 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> +{
> +       struct fd f;
> +       char *p;
> +       int ret = -EBADF;
> +
> +       /* Use fdget_raw instead of fdget to support O_PATH, and
> +        * fdget_raw doesn't have any sleepable code, so it's ok
> +        * to be here.
> +        */
> +       f = fdget_raw(fd);
> +       if (!f.file)
> +               goto error;
> +
> +       /* d_path doesn't have any sleepable code, so it's ok to
> +        * be here. But it uses the current macro to get fs_struct
> +        * (current->fs). So this helper shouldn't be called in
> +        * interrupt context.
> +        */
> +       p = d_path(&f.file->f_path, dst, size);
> +       if (IS_ERR(p)) {
> +               ret = PTR_ERR(p);
> +               fdput(f);
> +               goto error;
> +       }
> +
> +       ret = strlen(p);
> +       memmove(dst, p, ret);
> +       dst[ret++] = '\0';
> +       fdput(f);
> +       goto end;
> +
> +error:
> +       memset(dst, '0', size);
> +end:
> +       return ret;

nit: I'd avoid unnecessary goto end (and end label itself) by having
two explicit returns:

    return 0;
error:
    memset(...);
    return ret;

> +}
> +
> +static const struct bpf_func_proto bpf_get_file_path_proto = {
> +       .func       = bpf_get_file_path,
> +       .gpl_only   = true,
> +       .ret_type   = RET_INTEGER,
> +       .arg1_type  = ARG_PTR_TO_UNINIT_MEM,
> +       .arg2_type  = ARG_CONST_SIZE,
> +       .arg3_type  = ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -735,6 +782,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  #endif
>         case BPF_FUNC_send_signal:
>                 return &bpf_send_signal_proto;
> +       case BPF_FUNC_get_file_path:
> +               return &bpf_get_file_path_proto;

This seems like a rather useful helper not just in tracing context. So
if maintainers are ok with that, maybe you can follow up with patch
that adds it in more BPF program types.

>         default:
>                 return NULL;
>         }

[...]
