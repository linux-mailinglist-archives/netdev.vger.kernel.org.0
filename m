Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF338052
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfFFWKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:10:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43338 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfFFWKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:10:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so67787qka.10;
        Thu, 06 Jun 2019 15:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LujXWjuLgI657/H1Fpj9VSTX/GDsMHq5xxa6QyLxtM=;
        b=NF11yP/kQAqzPK1Mx8mCL87pJdeMImMGwblZDS6MqWLhG8JDKNcAEYvPWmdlgTdZEn
         wEWl28Kpx0hRQ8ioDr782uhuEwJhBX3weW1X/CwzdsrmwHxIObNYEIH2nMd7Zpg5fGmF
         p2U4s+WpPx4T0L1HP85YT+Fx8wnzOMJN/GwtqLT0J6nh69NOcW+aju3fRZRiScD+cxgK
         jGV5IgsgbCZwIt3CcV8KYIe+7VCQZYK/FOtoVffwPE2lZCIQWJK2WFsH6KU2jXptFtFT
         VrxxshSnZkA761sqqlNC2ZY4mz3rpeeVFuvVVXVh7InJOj2OWhkGtIB+zS4jO6NJKYBg
         FvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LujXWjuLgI657/H1Fpj9VSTX/GDsMHq5xxa6QyLxtM=;
        b=a/Wxg9ykbuePe7qWEWhx6JZjZEJ4kXpzyVUHy5wJqPEOMD0Wsq+bfiqdl9U/OQNjgO
         4yFfi3nVGCdNHgZdIly1tJ2kcPT2qNN1J9dHSsyg/Q89l16M79CEv3asv3Y4OP2wVAJT
         zvnt7TrxrjCFnRc5A94c8Z74vROaPyCVkKyRtacSPDeY+7SMR9f+3ERqNzB19dhVSg0t
         K97Fv9J1E+fovoj27NJRIGf5ysOYetliWyW1Z69IP4NdUKpjTr51tAQaAneJCtLDiREn
         KnvL7Oc9k6oRkqxuH8xtLWXAtCeLcuSEOTdS23k21IV9g9EdCcG8qbevIxEQHAI9dbCb
         39Cw==
X-Gm-Message-State: APjAAAXLQTXa4BkdyRheM+GPue6dL7PVyQ2MJN5mepO+vPqYw9PfgUBh
        aaewA82I5Ci38wA1NZEaqGRhYRTOsjEhZOOcPJo=
X-Google-Smtp-Source: APXvYqzxPf6nE6QalwodBsIk4/iScixDIzdNN8Cp2oFXpMrDuy7t3CVTUaMm1bXNbH1h39TncE/oDQ6bCP8Gx2rMGIk=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr40647458qkn.247.1559859030590;
 Thu, 06 Jun 2019 15:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190606193927.2489147-1-hechaol@fb.com> <20190606193927.2489147-2-hechaol@fb.com>
In-Reply-To: <20190606193927.2489147-2-hechaol@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jun 2019 15:10:19 -0700
Message-ID: <CAEf4Bza5EyUoEmo-mwQup7Zc_X5zM6p+LROVd04nJ-sjv588Mg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: add a new API libbpf_num_possible_cpus()
To:     Hechao Li <hechaol@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 1:17 PM Hechao Li <hechaol@fb.com> wrote:
>
> Adding a new API libbpf_num_possible_cpus() that helps user with
> per-CPU map operations.
>
> Signed-off-by: Hechao Li <hechaol@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 57 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   | 16 +++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 74 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ba89d9727137..06497c8a3372 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3827,3 +3827,60 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
>                                              desc->array_offset, addr);
>         }
>  }
> +
> +int libbpf_num_possible_cpus(void)
> +{
> +       static const char *fcpu = "/sys/devices/system/cpu/possible";
> +       int len = 0, n = 0, il = 0, ir = 0;
> +       unsigned int start = 0, end = 0;
> +       static int cpus;
> +       char buf[128];
> +       int error = 0;
> +       int fd = -1;
> +
> +       if (cpus > 0)
> +               return cpus;
> +
> +       fd = open(fcpu, O_RDONLY);
> +       if (fd < 0) {
> +               error = errno;
> +               pr_warning("Failed to open file %s: %s\n",
> +                          fcpu, strerror(error));
> +               return -error;
> +       }
> +       len = read(fd, buf, sizeof(buf));
> +       close(fd);
> +       if (len <= 0) {
> +               error = errno;

As Martin mentioned, you should handle len == 0 case separately, as
errno will be wrong in that case (read doesn't change errno in that
case). So something like:

error = len ? errno : EINVAL;

> +               pr_warning("Failed to read # of possible cpus from %s: %s\n",
> +                          fcpu, strerror(error));
> +               return -error;
> +       }
> +       if (len == sizeof(buf)) {
> +               pr_warning("File %s size overflow\n", fcpu);
> +               return -EOVERFLOW;
> +       }
> +       buf[len] = '\0';
> +
> +       for (ir = 0, cpus = 0; ir <= len; ir++) {
> +               /* Each sub string separated by ',' has format \d+-\d+ or \d+ */
> +               if (buf[ir] == ',' || buf[ir] == '\0') {
> +                       buf[ir] = '\0';
> +                       n = sscanf(&buf[il], "%u-%u", &start, &end);
> +                       if (n <= 0) {
> +                               pr_warning("Failed to get # CPUs from %s\n",
> +                                          &buf[il]);
> +                               return -EINVAL;
> +                       } else if (n == 1) {
> +                               end = start;
> +                       }
> +                       cpus += end - start + 1;
> +                       il = ir + 1;
> +               }
> +       }
> +       if (cpus <= 0) {
> +               pr_warning("Invalid #CPUs %d from %s\n", cpus, fcpu);
> +               return -EINVAL;
> +       }
> +       return cpus;
> +}
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 1af0d48178c8..f5e82eb2e5d4 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -454,6 +454,22 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_linear *info_linear);
>  LIBBPF_API void
>  bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
>
> +/*
> + * A helper function to get the number of possible CPUs before looking up
> + * per-CPU maps. Negative errno is returned on failure.
> + *
> + * Example usage:
> + *
> + *     int ncpus = libbpf_num_possible_cpus();
> + *     if (ncpus <= 0) {
> + *          // error handling
> + *     }
> + *     long values[ncpus];
> + *     bpf_map_lookup_elem(per_cpu_map_fd, key, values);
> + *
> + */
> +LIBBPF_API int libbpf_num_possible_cpus(void);
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 46dcda89df21..2c6d835620d2 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -172,4 +172,5 @@ LIBBPF_0.0.4 {
>                 btf_dump__new;
>                 btf__parse_elf;
>                 bpf_object__load_xattr;
> +               libbpf_num_possible_cpus;
>  } LIBBPF_0.0.3;
> --
> 2.17.1
>
