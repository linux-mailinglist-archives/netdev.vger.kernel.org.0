Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA8C600B4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 07:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfGEFtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 01:49:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34681 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfGEFtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 01:49:51 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so16838820iot.1;
        Thu, 04 Jul 2019 22:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JakGTUy1z4qJrH7uY+yQZug041dSFHBKDkBKJNhd5lo=;
        b=Chpje5nZalohIJ840HOxtYineLKC+wOwsIHSiX+U7jX8Ckkz++uOq2Ao/+3WHviblK
         JX5dQMe1PhXp7U95ZYeMaRE/aZvjmyWk79DSKOYepS1SJ7Ez1CVBekFAdL03RaveUmyd
         sV5sXofQHhmIZ3eB1JCB0s2aWtxeuk4Wy3Dg4D0BQSLmqfDYxOKj0+klsDmDigmwFvVs
         +pfyYkbDcsJTGzEl8+KgeLUUD7mgcjL838sadqugS5udwiCTmFCSTQ3QdICHqXi/4IbA
         Ts+wd7ZN2qKCP7UUa6yGPry3neA2kQ1rhCL2HGd19ZOjvUOc3hqcMHSt0UVCt5ZzYOKK
         +4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JakGTUy1z4qJrH7uY+yQZug041dSFHBKDkBKJNhd5lo=;
        b=ubDc8olrhK785QHXO3NFQ5trculja8O6RrFK0fPVC4fyfM7ANiKqiABvX3qObGQC7s
         y+QOL8XJCZmdEd1W7yB/JEFIsbGMIHiWLP1B///jhA29Pd6+O8R2rksgHNkdab7ivjoH
         ZGxCauhuFcXuUuA/63P8dWdNScZJvrGjOkKQb4AhynekHDkc0i4O3CCJJdVxzvVXUfmM
         s4ZiBhVSRjKjC6T5cF8dK+rlPpiq+pbAmujwstea/g6ieiQaWicrLJ9c10wl3W0y7OMr
         Umdt04lI0tlF1m6RXaywau2B2se9Y4bNss69HIsC4EMecSS3g/WGbJQQ2Mj5RFsLbeNS
         eLZQ==
X-Gm-Message-State: APjAAAVJ6NiAvsB8P0kTWfKjmZsqZq5Zu/yOYYwzrgswwHy0VJYMO5GC
        6ToQ+qjNezmgDmpIcylnUTRV5mwZlS/NgTYN7F4=
X-Google-Smtp-Source: APXvYqwFNppfHKc41PYac6pWs4Ylb+sT7vlmntnApJmZF9ffcDRnLKXs8U4kDdexbbTlO8bQ8escAY0w+L/g/9hKsVY=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr853495ioc.97.1562305789790;
 Thu, 04 Jul 2019 22:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190704085646.12406-1-quentin.monnet@netronome.com>
In-Reply-To: <20190704085646.12406-1-quentin.monnet@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 4 Jul 2019 22:49:13 -0700
Message-ID: <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: add "prog run" subcommand to
 test-run programs
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 1:58 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Add a new "bpftool prog run" subcommand to run a loaded program on input
> data (and possibly with input context) passed by the user.
>
> Print output data (and output context if relevant) into a file or into
> the console. Print return value and duration for the test run into the
> console.
>
> A "repeat" argument can be passed to run the program several times in a
> row.
>
> The command does not perform any kind of verification based on program
> type (Is this program type allowed to use an input context?) or on data
> consistency (Can I work with empty input data?), this is left to the
> kernel.
>
> Example invocation:
>
>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
>             pinned /sys/fs/bpf/sample_ret0 \
>             data_in - data_out - repeat 5
>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
>     Return value: 0, duration (average): 260ns
>
> When one of data_in or ctx_in is "-", bpftool reads from standard input,
> in binary format. Other formats (JSON, hexdump) might be supported (via
> an optional command line keyword like "data_fmt_in") in the future if
> relevant, but this would require doing more parsing in bpftool.
>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  .../bpftool/Documentation/bpftool-prog.rst    |  34 ++
>  tools/bpf/bpftool/bash-completion/bpftool     |  28 +-
>  tools/bpf/bpftool/main.c                      |  29 ++
>  tools/bpf/bpftool/main.h                      |   1 +
>  tools/bpf/bpftool/prog.c                      | 348 +++++++++++++++++-
>  tools/include/linux/sizes.h                   |  48 +++
>  6 files changed, 485 insertions(+), 3 deletions(-)
>  create mode 100644 tools/include/linux/sizes.h
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index 1df637f85f94..7a374b3c851d 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -29,6 +29,7 @@ PROG COMMANDS
>  |      **bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |      **bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |      **bpftool** **prog tracelog**
> +|      **bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
>  |      **bpftool** **prog help**
>  |
>  |      *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
> @@ -146,6 +147,39 @@ DESCRIPTION
>                   streaming data from BPF programs to user space, one can use
>                   perf events (see also **bpftool-map**\ (8)).
>
> +       **bpftool prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
> +                 Run BPF program *PROG* in the kernel testing infrastructure
> +                 for BPF, meaning that the program works on the data and
> +                 context provided by the user, and not on actual packets or
> +                 monitored functions etc. Return value and duration for the
> +                 test run are printed out to the console.
> +
> +                 Input data is read from the *FILE* passed with **data_in**.
> +                 If this *FILE* is "**-**", input data is read from standard
> +                 input. Input context, if any, is read from *FILE* passed with
> +                 **ctx_in**. Again, "**-**" can be used to read from standard
> +                 input, but only if standard input is not already in use for
> +                 input data. If a *FILE* is passed with **data_out**, output
> +                 data is written to that file. Similarly, output context is
> +                 written to the *FILE* passed with **ctx_out**. For both
> +                 output flows, "**-**" can be used to print to the standard
> +                 output (as plain text, or JSON if relevant option was
> +                 passed). If output keywords are omitted, output data and
> +                 context are discarded. Keywords **data_size_out** and
> +                 **ctx_size_out** are used to pass the size (in bytes) for the
> +                 output buffers to the kernel, although the default of 32 kB
> +                 should be more than enough for most cases.
> +
> +                 Keyword **repeat** is used to indicate the number of
> +                 consecutive runs to perform. Note that output data and
> +                 context printed to files correspond to the last of those
> +                 runs. The duration printed out at the end of the runs is an
> +                 average over all runs performed by the command.
> +
> +                 Not all program types support test run. Among those which do,
> +                 not all of them can take the **ctx_in**/**ctx_out**
> +                 arguments. bpftool does not perform checks on program types.
> +
>         **bpftool prog help**
>                   Print short help message.
>
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index ba37095e1f62..965a8658cca3 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -408,10 +408,34 @@ _bpftool()
>                  tracelog)
>                      return 0
>                      ;;
> +                run)
> +                    if [[ ${#words[@]} -lt 5 ]]; then
> +                        _filedir
> +                        return 0
> +                    fi
> +                    case $prev in
> +                        id)
> +                            _bpftool_get_prog_ids
> +                            return 0
> +                            ;;
> +                        data_in|data_out|ctx_in|ctx_out)
> +                            _filedir
> +                            return 0
> +                            ;;
> +                        repeat|data_size_out|ctx_size_out)
> +                            return 0
> +                            ;;
> +                        *)
> +                            _bpftool_once_attr 'data_in data_out data_size_out \
> +                                ctx_in ctx_out ctx_size_out repeat'
> +                            return 0
> +                            ;;
> +                    esac
> +                    ;;
>                  *)
>                      [[ $prev == $object ]] && \
> -                        COMPREPLY=( $( compgen -W 'dump help pin attach detach load \
> -                            show list tracelog' -- "$cur" ) )
> +                        COMPREPLY=( $( compgen -W 'dump help pin attach detach \
> +                            load show list tracelog run' -- "$cur" ) )
>                      ;;
>              esac
>              ;;
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 4879f6395c7e..e916ff25697f 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -117,6 +117,35 @@ bool is_prefix(const char *pfx, const char *str)
>         return !memcmp(str, pfx, strlen(pfx));
>  }
>
> +/* Last argument MUST be NULL pointer */
> +int detect_common_prefix(const char *arg, ...)
> +{
> +       unsigned int count = 0;
> +       const char *ref;
> +       char msg[256];
> +       va_list ap;
> +
> +       snprintf(msg, sizeof(msg), "ambiguous prefix: '%s' could be '", arg);
> +       va_start(ap, arg);
> +       while ((ref = va_arg(ap, const char *))) {
> +               if (!is_prefix(arg, ref))
> +                       continue;
> +               count++;
> +               if (count > 1)
> +                       strncat(msg, "' or '", sizeof(msg) - strlen(msg) - 1);
> +               strncat(msg, ref, sizeof(msg) - strlen(msg) - 1);
> +       }
> +       va_end(ap);
> +       strncat(msg, "'", sizeof(msg) - strlen(msg) - 1);
> +
> +       if (count >= 2) {
> +               p_err(msg);
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
>  void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep)
>  {
>         unsigned char *data = arg;
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 9c5d9c80f71e..3ef0d9051e10 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -101,6 +101,7 @@ void p_err(const char *fmt, ...);
>  void p_info(const char *fmt, ...);
>
>  bool is_prefix(const char *pfx, const char *str);
> +int detect_common_prefix(const char *arg, ...);
>  void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
>  void usage(void) __noreturn;
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 9b0db5d14e31..8dcbaa0a8ab1 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -15,6 +15,7 @@
>  #include <sys/stat.h>
>
>  #include <linux/err.h>
> +#include <linux/sizes.h>
>
>  #include <bpf.h>
>  #include <btf.h>
> @@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
>         return 0;
>  }
>
> +static int check_single_stdin(char *file_in, char *other_file_in)
> +{
> +       if (file_in && other_file_in &&
> +           !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
> +               p_err("cannot use standard input for both data_in and ctx_in");

The error message says data_in and ctx_in.
Maybe the input parameter should be file_data_in and file_ctx_in?

> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int get_run_data(const char *fname, void **data_ptr, unsigned int *size)
> +{
> +       size_t block_size = 256;
> +       size_t buf_size = block_size;
> +       size_t nb_read = 0;
> +       void *tmp;
> +       FILE *f;
> +
> +       if (!fname) {
> +               *data_ptr = NULL;
> +               *size = 0;
> +               return 0;
> +       }
> +
> +       if (!strcmp(fname, "-"))
> +               f = stdin;
> +       else
> +               f = fopen(fname, "r");
> +       if (!f) {
> +               p_err("failed to open %s: %s", fname, strerror(errno));
> +               return -1;
> +       }
> +
> +       *data_ptr = malloc(block_size);
> +       if (!*data_ptr) {
> +               p_err("failed to allocate memory for data_in/ctx_in: %s",
> +                     strerror(errno));
> +               goto err_fclose;
> +       }
> +
> +       while ((nb_read += fread(*data_ptr + nb_read, 1, block_size, f))) {
> +               if (feof(f))
> +                       break;
> +               if (ferror(f)) {
> +                       p_err("failed to read data_in/ctx_in from %s: %s",
> +                             fname, strerror(errno));
> +                       goto err_free;
> +               }
> +               if (nb_read > buf_size - block_size) {
> +                       if (buf_size == UINT32_MAX) {
> +                               p_err("data_in/ctx_in is too long (max: %d)",
> +                                     UINT32_MAX);
> +                               goto err_free;
> +                       }
> +                       /* No space for fread()-ing next chunk; realloc() */
> +                       buf_size *= 2;
> +                       tmp = realloc(*data_ptr, buf_size);
> +                       if (!tmp) {
> +                               p_err("failed to reallocate data_in/ctx_in: %s",
> +                                     strerror(errno));
> +                               goto err_free;
> +                       }
> +                       *data_ptr = tmp;
> +               }
> +       }
> +       if (f != stdin)
> +               fclose(f);
> +
> +       *size = nb_read;
> +       return 0;
> +
> +err_free:
> +       free(*data_ptr);
> +       *data_ptr = NULL;
> +err_fclose:
> +       if (f != stdin)
> +               fclose(f);
> +       return -1;
> +}
> +
> +static void hex_print(void *data, unsigned int size, FILE *f)
> +{
> +       size_t i, j;
> +       char c;
> +
> +       for (i = 0; i < size; i += 16) {
> +               /* Row offset */
> +               fprintf(f, "%07zx\t", i);
> +
> +               /* Hexadecimal values */
> +               for (j = i; j < i + 16 && j < size; j++)
> +                       fprintf(f, "%02x%s", *(uint8_t *)(data + j),
> +                               j % 2 ? " " : "");
> +               for (; j < i + 16; j++)
> +                       fprintf(f, "  %s", j % 2 ? " " : "");
> +
> +               /* ASCII values (if relevant), '.' otherwise */
> +               fprintf(f, "| ");
> +               for (j = i; j < i + 16 && j < size; j++) {
> +                       c = *(char *)(data + j);
> +                       if (c < ' ' || c > '~')
> +                               c = '.';
> +                       fprintf(f, "%c%s", c, j == i + 7 ? " " : "");
> +               }
> +
> +               fprintf(f, "\n");
> +       }
> +}
> +
> +static int
> +print_run_output(void *data, unsigned int size, const char *fname,
> +                const char *json_key)
> +{
> +       size_t nb_written;
> +       FILE *f;
> +
> +       if (!fname)
> +               return 0;
> +
> +       if (!strcmp(fname, "-")) {
> +               f = stdout;
> +               if (json_output) {
> +                       jsonw_name(json_wtr, json_key);
> +                       print_data_json(data, size);
> +               } else {
> +                       hex_print(data, size, f);
> +               }
> +               return 0;
> +       }
> +
> +       f = fopen(fname, "w");
> +       if (!f) {
> +               p_err("failed to open %s: %s", fname, strerror(errno));
> +               return -1;
> +       }
> +
> +       nb_written = fwrite(data, 1, size, f);
> +       fclose(f);
> +       if (nb_written != size) {
> +               p_err("failed to write output data/ctx: %s", strerror(errno));
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int alloc_run_data(void **data_ptr, unsigned int size_out)
> +{
> +       *data_ptr = calloc(size_out, 1);
> +       if (!*data_ptr) {
> +               p_err("failed to allocate memory for output data/ctx: %s",
> +                     strerror(errno));
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int do_run(int argc, char **argv)
> +{
> +       char *data_fname_in = NULL, *data_fname_out = NULL;
> +       char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
> +       struct bpf_prog_test_run_attr test_attr = {0};
> +       const unsigned int default_size = SZ_32K;
> +       void *data_in = NULL, *data_out = NULL;
> +       void *ctx_in = NULL, *ctx_out = NULL;
> +       unsigned int repeat = 1;
> +       int fd, err;
> +
> +       if (!REQ_ARGS(4))
> +               return -1;
> +
> +       fd = prog_parse_fd(&argc, &argv);
> +       if (fd < 0)
> +               return -1;
> +
> +       while (argc) {
> +               if (detect_common_prefix(*argv, "data_in", "data_out",
> +                                        "data_size_out", NULL))
> +                       return -1;
> +               if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
> +                                        "ctx_size_out", NULL))
> +                       return -1;
> +
> +               if (is_prefix(*argv, "data_in")) {
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       data_fname_in = GET_ARG();
> +                       if (check_single_stdin(data_fname_in, ctx_fname_in))
> +                               return -1;
> +               } else if (is_prefix(*argv, "data_out")) {

Here, we all use is_prefix() to match "data_in", "data_out",
"data_size_out" etc.
That means users can use "data_i" instead of "data_in" as below
   ... | ./bpftool prog run id 283 data_i - data_out - repeat 5
is this expected?

> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       data_fname_out = GET_ARG();
> +               } else if (is_prefix(*argv, "data_size_out")) {
> +                       char *endptr;
> +
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       test_attr.data_size_out = strtoul(*argv, &endptr, 0);
> +                       if (*endptr) {
> +                               p_err("can't parse %s as output data size",
> +                                     *argv);
> +                               return -1;
> +                       }
> +                       NEXT_ARG();
> +               } else if (is_prefix(*argv, "ctx_in")) {
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       ctx_fname_in = GET_ARG();
> +                       if (check_single_stdin(ctx_fname_in, data_fname_in))
> +                               return -1;
> +               } else if (is_prefix(*argv, "ctx_out")) {
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       ctx_fname_out = GET_ARG();
> +               } else if (is_prefix(*argv, "ctx_size_out")) {
> +                       char *endptr;
> +
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       test_attr.ctx_size_out = strtoul(*argv, &endptr, 0);
> +                       if (*endptr) {
> +                               p_err("can't parse %s as output context size",
> +                                     *argv);
> +                               return -1;
> +                       }
> +                       NEXT_ARG();
> +               } else if (is_prefix(*argv, "repeat")) {
> +                       char *endptr;
> +
> +                       NEXT_ARG();
> +                       if (!REQ_ARGS(1))
> +                               return -1;
> +
> +                       repeat = strtoul(*argv, &endptr, 0);
> +                       if (*endptr) {
> +                               p_err("can't parse %s as repeat number",
> +                                     *argv);
> +                               return -1;
> +                       }
> +                       NEXT_ARG();
> +               } else {
> +                       p_err("expected no more arguments, 'data_in', 'data_out', 'data_size_out', 'ctx_in', 'ctx_out', 'ctx_size_out' or 'repeat', got: '%s'?",
> +                             *argv);
> +                       return -1;
> +               }
> +       }
> +
[...]
