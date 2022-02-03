Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126434A89D8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352796AbiBCRVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352719AbiBCRVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:21:53 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD80C061714;
        Thu,  3 Feb 2022 09:21:53 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id y17so2703629ilm.1;
        Thu, 03 Feb 2022 09:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fFiRtUQz8mzsXkavc5dwIZud5JylJ6yzf1bEGSiDhRA=;
        b=HI7crcQ9rIzZ6QW+5aIeNsaQy2eaWZo5wRRFLIIhiAq1LhvpIRviVvgyc0yl7GoOqT
         Lbsl1aSK4ZgPLo9SM6/P3oCBj/T/KKLLdEhR8lP5S7m23VEdn1+nkYyq3SQqG88pcPQQ
         uRqTNQO7NwUOlWVAkprEz1HiiluKGgmpVlDvF2AtQTpBly0e7iApczjXqBnJMapjaaiD
         BpJ6nNm3oaX0IK498japVZ/LeKIRHzrsaI1j8hWR6nRX2GpuZ9e7Klk2WwIFZU7lC+6p
         GXgEowmuEuuld7vpKGjjnE2/Sy+ZwzhB7g49I5ecDNb3ibVlJ9P0SfSu8PKyW/9oDYU9
         UnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fFiRtUQz8mzsXkavc5dwIZud5JylJ6yzf1bEGSiDhRA=;
        b=oSKdL+QKiPxM5lULv0mK4dtcWEnuuwLDrDoiW1b0q4A9XS56JQnOB5FSzwFM9GwfNh
         HpYxy+lc7JRX7A+cLnOVwWeBTGhEY0w/bG/ILe0o7uSTSVA1F0fBJs/cBInWpdeEIhW6
         uFl8H1i+XkTMCetcZJ4I1WG2yrXS3az6r/KTt+edjn7bOMfidIYt9EOmjmWsmZeki2eT
         TmcXp28bTCbVDINoZGqEolg78TJm8k66mLAZIiGlW4cudf74eKgGG7aK4qEsnBDqAP3b
         pIYvNKImkLBnuAxE8l7wKWoCFOkzOrn9tNNDd5Yq1pFsK5GozXVrXM30itpeI8U5iyGv
         Qrjg==
X-Gm-Message-State: AOAM531pkowDEWIKij81ARSbyQSGG7z9Qi8zGZX/P+1ucxHWS5HeQnQB
        Ms4JsWVfw7qeZdg8W6s6Tecp4MjJ+NV+Sc+2D+I=
X-Google-Smtp-Source: ABdhPJzBceWc0zIbsMQ0nTHtq7s0kmVc9CVGccTb/eNZQUaPrvrP8vA6e4gtarzdjfJhDvtD92c+/qbm7NEDlQ2ASAs=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr20959771ili.239.1643908912657;
 Thu, 03 Feb 2022 09:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-3-mauricio@kinvolk.io>
 <CAEf4BzY3_GZD8C754nb5P_+btFEsmK5QHC-qoHqJqAdSMNKcsQ@mail.gmail.com> <CAHap4zsAk_HxoWsrAtwt0SmvMOHrinpvA76p87gcj4LZ5+OA3w@mail.gmail.com>
In-Reply-To: <CAHap4zsAk_HxoWsrAtwt0SmvMOHrinpvA76p87gcj4LZ5+OA3w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Feb 2022 09:21:41 -0800
Message-ID: <CAEf4BzYz6fFF-vUWPKaaZ=47-OM9mmr0fjBdTCPdwTth5pi-Mw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/9] bpftool: Add gen min_core_btf command
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:07 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Wed, Feb 2, 2022 at 12:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk=
.io> wrote:
> > >
> > > This command is implemented under the "gen" command in bpftool and th=
e
> > > syntax is the following:
> > >
> > > $ bpftool gen min_core_btf INPUT OUTPUT OBJECT(S)
> > >
> > > INPUT can be either a single BTF file or a folder containing BTF file=
s,
> > > when it's a folder, a BTF file is generated for each BTF file contain=
ed
> > > in this folder. OUTPUT is the file (or folder) where generated files =
are
> > > stored and OBJECT(S) is the list of bpf objects we want to generate t=
he
> > > BTF file(s) for (each generated BTF file contains all the types neede=
d
> > > by all the objects).
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  tools/bpf/bpftool/bash-completion/bpftool |   6 +-
> > >  tools/bpf/bpftool/gen.c                   | 112 ++++++++++++++++++++=
+-
> > >  2 files changed, 114 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bp=
ftool/bash-completion/bpftool
> > > index 493753a4962e..958e1fd71b5c 100644
> > > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > > @@ -1003,9 +1003,13 @@ _bpftool()
> > >                              ;;
> > >                      esac
> > >                      ;;
> > > +                min_core_btf)
> > > +                    _filedir
> > > +                    return 0
> > > +                    ;;
> > >                  *)
> > >                      [[ $prev =3D=3D $object ]] && \
> > > -                        COMPREPLY=3D( $( compgen -W 'object skeleton=
 help' -- "$cur" ) )
> > > +                        COMPREPLY=3D( $( compgen -W 'object skeleton=
 help min_core_btf' -- "$cur" ) )
> > >                      ;;
> > >              esac
> > >              ;;
> > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > index 8f78c27d41f0..7db31b0f265f 100644
> > > --- a/tools/bpf/bpftool/gen.c
> > > +++ b/tools/bpf/bpftool/gen.c
> > > @@ -5,6 +5,7 @@
> > >  #define _GNU_SOURCE
> > >  #endif
> > >  #include <ctype.h>
> > > +#include <dirent.h>
> > >  #include <errno.h>
> > >  #include <fcntl.h>
> > >  #include <linux/err.h>
> > > @@ -1084,6 +1085,7 @@ static int do_help(int argc, char **argv)
> > >         fprintf(stderr,
> > >                 "Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPU=
T_FILE...]\n"
> > >                 "       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
> > > +               "       %1$s %2$s min_core_btf INPUT OUTPUT OBJECT(S)=
\n"
> >
> > OBJECTS(S) should be OBJECT... for this "CLI notation", no?
>
> Updated it to be "min_core_btf INPUT OUTPUT OBJECT [OBJECT...]" like
> the "bpftool object" command.
>
> >
> > >                 "       %1$s %2$s help\n"
> > >                 "\n"
> > >                 "       " HELP_SPEC_OPTIONS " |\n"
> > > @@ -1094,10 +1096,114 @@ static int do_help(int argc, char **argv)
> > >         return 0;
> > >  }
> > >
> > > +/* Create BTF file for a set of BPF objects */
> > > +static int btfgen(const char *src_btf, const char *dst_btf, const ch=
ar *objspaths[])
> > > +{
> > > +       return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static int do_min_core_btf(int argc, char **argv)
> > > +{
> > > +       char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
> > > +       bool input_is_file, output_is_file =3D true;
> > > +       const char *input, *output;
> > > +       const char **objs =3D NULL;
> > > +       struct dirent *dir;
> > > +       struct stat st;
> > > +       DIR *d =3D NULL;
> > > +       int i, err;
> > > +
> > > +       if (!REQ_ARGS(3)) {
> > > +               usage();
> > > +               return -1;
> > > +       }
> > > +
> > > +       input =3D GET_ARG();
> > > +       if (stat(input, &st) < 0) {
> > > +               p_err("failed to stat %s: %s", input, strerror(errno)=
);
> > > +               return -errno;
> > > +       }
> > > +
> > > +       if ((st.st_mode & S_IFMT) !=3D S_IFDIR && (st.st_mode & S_IFM=
T) !=3D S_IFREG) {
> > > +               p_err("file type not valid: %s", input);
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       input_is_file =3D (st.st_mode & S_IFMT) =3D=3D S_IFREG;
> >
> > move before if and use input_is_file in the if itself instead of
> > duplicating all the S_IFREG flags?
> >
> > > +
> > > +       output =3D GET_ARG();
> > > +       if (stat(output, &st) =3D=3D 0 && (st.st_mode & S_IFMT) =3D=
=3D S_IFDIR)
> > > +               output_is_file =3D false;
> >
> > if stat() succeeds but it's neither directory or file, should be an
> > error, right?
> >
> > > +
> > > +       objs =3D (const char **) malloc((argc + 1) * sizeof(*objs));
> >
> > calloc() seems to be better suited for this (and zero-intialization is
> > nice for safety and to avoid objs[argc] =3D NULL after the loop below)
> >
>
> You're right!
>
> > > +       if (!objs) {
> > > +               p_err("failed to allocate array for object names");
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       i =3D 0;
> > > +       while (argc > 0)
> > > +               objs[i++] =3D GET_ARG();
> >
> > for (i =3D 0; i < argc; i++) ?
>
> GET_ARG() does argc--. I see this loop is usually written as while
> (argc) in bpftool.

Ah, I missed GET_ARG()'s side effect.

>
> >
> > > +
> > > +       objs[i] =3D NULL;
> > > +
> > > +       /* single BTF file */
> > > +       if (input_is_file) {
> > > +               p_info("Processing source BTF file: %s", input);
> > > +
> > > +               if (output_is_file) {
> > > +                       err =3D btfgen(input, output, objs);
> > > +                       goto out;
> > > +               }
> > > +               snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s",=
 output,
> > > +                        basename(input));
> > > +               err =3D btfgen(input, dst_btf_path, objs);
> > > +               goto out;
> > > +       }
> > > +
> > > +       if (output_is_file) {
> > > +               p_err("can't have just one file as output");
> > > +               err =3D -EINVAL;
> > > +               goto out;
> > > +       }
> > > +
> > > +       /* directory with BTF files */
> > > +       d =3D opendir(input);
> > > +       if (!d) {
> > > +               p_err("error opening input dir: %s", strerror(errno))=
;
> > > +               err =3D -errno;
> > > +               goto out;
> > > +       }
> > > +
> > > +       while ((dir =3D readdir(d)) !=3D NULL) {
> > > +               if (dir->d_type !=3D DT_REG)
> > > +                       continue;
> > > +
> > > +               if (strncmp(dir->d_name + strlen(dir->d_name) - 4, ".=
btf", 4))
> > > +                       continue;
> >
> > this whole handling of input directory feels a bit icky, tbh... maybe
> > we should require explicit listing of input files always. In CLI
> > invocation those could be separated by "keywords", something like
> > this:
> >
> > bpftool gen min_core_btf <output> inputs <file1> <file2> .... objects
> > <obj1> <obj2> ...
> >
> > a bit of a downside is that you can't have a file named "inputs" or
> > "objects", but that seems extremely unlikely? Quentin, any opinion as
> > well?
> >
> > I'm mainly off put by a bit random ".btf" naming convention, the
> > DT_REG skipping, etc.
> >
> > Another cleaner alternative from POV of bpftool (but might be less
> > convenient for users) is to use @file convention to specify a file
> > that contains a list of files. So
> >
> > bpftool gen min_core_btf <output> @btf_filelist.txt @obj_filelist.txt
> >
> > would take lists of inputs and outputs from respective files?
> >
> >
> > But actually, let's take a step back again. Why should there be
> > multiple inputs and outputs?
>
> We're thinking about the use case when there are multiple source BTF
> files in a folder and we want to generate a BTF for each one of them,
> by supporting input and output folders we're able to avoid executing
> bpftool multiple times. I agree that it complicates the implementation
> and that the same can be done by using a script to run bpftool
> multiple times, hence let's remove it. If we find out later on that
> this is really important we can implement it.

Yeah, I figured you have this use case, but I think it's better to
keep the interface simple. If that becomes a big performance problem,
we can always extend it later.

>
>
> > I can see why multiple objects are
> > mandatory (you have an application that has multiple BPF objects used
> > internally). But processing single vmlinux BTF at a time seems
> > absolutely fine. I don't buy that CO-RE relo processing is that slow
> > to require optimized batch processing.
> >
> > I might have asked this before, sorry, but the duration between each
> > iteration of btfgen is pretty long and I'm losing the context.
> >
> > > +
> > > +               snprintf(src_btf_path, sizeof(src_btf_path), "%s%s", =
input, dir->d_name);
> > > +               snprintf(dst_btf_path, sizeof(dst_btf_path), "%s%s", =
output, dir->d_name);
> > > +
> > > +               p_info("Processing source BTF file: %s", src_btf_path=
);
> > > +
> > > +               err =3D btfgen(src_btf_path, dst_btf_path, objs);
> > > +               if (err)
> > > +                       goto out;
> > > +       }
> > > +
> > > +out:
> > > +       free(objs);
> > > +       if (d)
> > > +               closedir(d);
> > > +       return err;
> > > +}
> > > +
> > >  static const struct cmd cmds[] =3D {
> > > -       { "object",     do_object },
> > > -       { "skeleton",   do_skeleton },
> > > -       { "help",       do_help },
> > > +       { "object",             do_object },
> > > +       { "skeleton",           do_skeleton },
> > > +       { "min_core_btf",       do_min_core_btf},
> > > +       { "help",               do_help },
> > >         { 0 }
> > >  };
> > >
> > > --
> > > 2.25.1
> > >
