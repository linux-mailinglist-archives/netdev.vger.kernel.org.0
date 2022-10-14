Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB625FE7AB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJNDoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJNDoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:44:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7745B16913B;
        Thu, 13 Oct 2022 20:44:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bj12so7829302ejb.13;
        Thu, 13 Oct 2022 20:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+R5NUP6yX3iFVthsCCThyVprlxQGShQ8UvkgSvdUCo=;
        b=ewXES8QRM2MdPPzG9cFjMVSblGJCW0HjlL1XW/7wEfOx0P7lf+X5X+61R/SsQ/+rXe
         PqF8i5pt1kZoSQ4S3gUNA1GLtJZ7uS6tFVdusnH7xwvGk2fCR76ySCx9xE2O8rg9PGzS
         0fJsjReOGTnG8uFg0qmqXNlX8FCYqep04EgouO1pig7gcaBwMrh6s2gYNOLs5+0kAa9F
         1b3l7/RfxIS5/BszGDrGZzL6ZhpB0Hb2gv6fBmpe5h/NfnLqpvdauNPYUXugQg78IxBf
         hsoGEYjc4T0QFMzg5q668pNq3GfHOSORjNDh4uYOZMZRRnrf+zOUU3uNFT6vlJsR1/q3
         Y2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+R5NUP6yX3iFVthsCCThyVprlxQGShQ8UvkgSvdUCo=;
        b=WLtiv1FofxLxIYm1h1xQ/I88HaaKLRNRLvudhVFYNDGalT+GOdbcuqre2hBmWbWb5f
         M7E/RDZLd2rt/KsUtSbN2s2jV71+UwdWDQZYyN3staoLWrtqy8gDoUqDIXXc66732HGA
         ZwDAsVL+jovjpyYFSR2LSJ1Izv6ZyZd3pRcGby6FyVnlF0OAHYIvlMlZLPeD0bs3zi76
         /SEdK7FD4W9m0wpjg+A4vMqWWFIDiZPmDwZef3pr4zkXhL8S7O6Pi3Ilpgp3KmYD/esq
         2hqNqqLXeRrBDCzohEBaKZGriLPpJ+aa+1jzYnrw4ZJ+VqH2I29BwXdIpeV8SKPloLN8
         UKjg==
X-Gm-Message-State: ACrzQf2/nPHOyJOZss3DDzrYjs1P1dJoiMQwuyFgcG/dyNQyhVglUTFi
        F7FmRcejypOAUZFtZ3Hw6yabjKos4Z1dK9L7U34=
X-Google-Smtp-Source: AMsMyM5GQHPv6oOttnYxWNmzG6/wR9+JxLyeaD+8mDPlfPVYxWEaWWVC6XsXpO0SGEgqaualYHnTSlVI5J6CUInQ01A=
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id
 du1-20020a17090772c100b0078334ce87b9mr2016488ejc.115.1665719039848; Thu, 13
 Oct 2022 20:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <1665399601-29668-1-git-send-email-wangyufen@huawei.com>
 <1665399601-29668-2-git-send-email-wangyufen@huawei.com> <CAEf4BzYzUKUg=V6Bir7s1AKuZF-=HFsjuWBTjTqO8fganjWVDg@mail.gmail.com>
 <fbb13238-d0e2-7b0f-8b7b-e4fb211bcaaf@huawei.com>
In-Reply-To: <fbb13238-d0e2-7b0f-8b7b-e4fb211bcaaf@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Oct 2022 20:43:47 -0700
Message-ID: <CAEf4BzaP=H_+1Yf8ou2zzmu=h2FtDQh4wSSMgabBrPr_jK7SjA@mail.gmail.com>
Subject: Re: [bpf-next v8 1/3] bpftool: Add autoattach for bpf prog load|loadall
To:     wangyufen <wangyufen@huawei.com>
Cc:     quentin@isovalent.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 7:24 PM wangyufen <wangyufen@huawei.com> wrote:
>
>
> =E5=9C=A8 2022/10/14 3:47, Andrii Nakryiko =E5=86=99=E9=81=93:
> > On Mon, Oct 10, 2022 at 3:40 AM Wang Yufen <wangyufen@huawei.com> wrote=
:
> >> Add autoattach optional to support one-step load-attach-pin_link.
> >>
> >> For example,
> >>     $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
> >>
> >>     $ bpftool link
> >>     26: tracing  name test1  tag f0da7d0058c00236  gpl
> >>          loaded_at 2022-09-09T21:39:49+0800  uid 0
> >>          xlated 88B  jited 55B  memlock 4096B  map_ids 3
> >>          btf_id 55
> >>     28: kprobe  name test3  tag 002ef1bef0723833  gpl
> >>          loaded_at 2022-09-09T21:39:49+0800  uid 0
> >>          xlated 88B  jited 56B  memlock 4096B  map_ids 3
> >>          btf_id 55
> >>     57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
> >>          loaded_at 2022-09-09T21:41:32+0800  uid 0
> >>          xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
> >>          btf_id 82
> >>
> >>     $ bpftool link
> >>     1: tracing  prog 26
> >>          prog_type tracing  attach_type trace_fentry
> >>     3: perf_event  prog 28
> >>     10: perf_event  prog 57
> >>
> >> The autoattach optional can support tracepoints, k(ret)probes,
> >> u(ret)probes.
> >>
> >> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> >> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> >> ---
> >>   tools/bpf/bpftool/prog.c | 78 ++++++++++++++++++++++++++++++++++++++=
++++++++--
> >>   1 file changed, 76 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> >> index c81362a..8f3afce 100644
> >> --- a/tools/bpf/bpftool/prog.c
> >> +++ b/tools/bpf/bpftool/prog.c
> >> @@ -1453,6 +1453,69 @@ static int do_run(int argc, char **argv)
> >>          return ret;
> >>   }
> >>
> >> +static int
> >> +auto_attach_program(struct bpf_program *prog, const char *path)
> >> +{
> >> +       struct bpf_link *link;
> >> +       int err;
> >> +
> >> +       link =3D bpf_program__attach(prog);
> >> +       if (!link) {
> >> +               p_info("Program %s does not support autoattach, fallin=
g back to pinning",
> >> +                      bpf_program__name(prog));
> >> +               return bpf_obj_pin(bpf_program__fd(prog), path);
> >> +       }
> >> +       err =3D bpf_link__pin(link, path);
> >> +       if (err) {
> >> +               bpf_link__destroy(link);
> >> +               return err;
> >> +       }
> > leaking link here, destroy it unconditionally. If pinning succeeded,
> > you don't need to hold link's FD open anymore.
>
> I got it, will change. Thanks=EF=BC=81
>
> >
> >> +       return 0;
> >> +}
> >> +
> >> +static int pathname_concat(const char *path, const char *name, char *=
buf)
> > why you didn't do the same as in libbpf? Pass buffer size explicitly
> > instead of assuming PATH_MAX
>
> The pathname_concat function is invoked only in one place and is not a
> general function here. So, not modified. Or, can I change the "pathname_c=
oncat"
> of libbpf to "LIBBPF_API int libbpf_pathname_concat" and use the
> libbpf_pathname_concat directly?

no need to reuse libbpf's helper, but I do think it's cleaner to
specify not just buffer pointer, but also it's size, just like you do
with any other string buffer API (like snprintf)

>
>
> >
> >> +{
> >> +       int len;
> >> +
> >> +       len =3D snprintf(buf, PATH_MAX, "%s/%s", path, name);
> >> +       if (len < 0)
> >> +               return -EINVAL;
> >> +       if (len >=3D PATH_MAX)
> >> +               return -ENAMETOOLONG;
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int
> >> +auto_attach_programs(struct bpf_object *obj, const char *path)
> >> +{
> >> +       struct bpf_program *prog;
> >> +       char buf[PATH_MAX];
> >> +       int err;
> >> +
> >> +       bpf_object__for_each_program(prog, obj) {
> >> +               err =3D pathname_concat(path, bpf_program__name(prog),=
 buf);
> >> +               if (err)
> >> +                       goto err_unpin_programs;
> >> +
> >> +               err =3D auto_attach_program(prog, buf);
> >> +               if (err)
> >> +                       goto err_unpin_programs;
> >> +       }
> >> +
> >> +       return 0;
> >> +
> >> +err_unpin_programs:
> >> +       while ((prog =3D bpf_object__prev_program(obj, prog))) {
> >> +               if (pathname_concat(path, bpf_program__name(prog), buf=
))
> >> +                       continue;
> >> +
> >> +               bpf_program__unpin(prog, buf);
> >> +       }
> >> +
> >> +       return err;
> >> +}
> >> +
> >>   static int load_with_options(int argc, char **argv, bool first_prog_=
only)
> >>   {
> >>          enum bpf_prog_type common_prog_type =3D BPF_PROG_TYPE_UNSPEC;
> >> @@ -1464,6 +1527,7 @@ static int load_with_options(int argc, char **ar=
gv, bool first_prog_only)
> >>          struct bpf_program *prog =3D NULL, *pos;
> >>          unsigned int old_map_fds =3D 0;
> >>          const char *pinmaps =3D NULL;
> >> +       bool auto_attach =3D false;
> >>          struct bpf_object *obj;
> >>          struct bpf_map *map;
> >>          const char *pinfile;
> >> @@ -1583,6 +1647,9 @@ static int load_with_options(int argc, char **ar=
gv, bool first_prog_only)
> >>                                  goto err_free_reuse_maps;
> >>
> >>                          pinmaps =3D GET_ARG();
> >> +               } else if (is_prefix(*argv, "autoattach")) {
> >> +                       auto_attach =3D true;
> >> +                       NEXT_ARG();
> >>                  } else {
> >>                          p_err("expected no more arguments, 'type', 'm=
ap' or 'dev', got: '%s'?",
> >>                                *argv);
> >> @@ -1692,14 +1759,20 @@ static int load_with_options(int argc, char **=
argv, bool first_prog_only)
> >>                          goto err_close_obj;
> >>                  }
> >>
> >> -               err =3D bpf_obj_pin(bpf_program__fd(prog), pinfile);
> >> +               if (auto_attach)
> >> +                       err =3D auto_attach_program(prog, pinfile);
> >> +               else
> >> +                       err =3D bpf_obj_pin(bpf_program__fd(prog), pin=
file);
> >>                  if (err) {
> >>                          p_err("failed to pin program %s",
> >>                                bpf_program__section_name(prog));
> >>                          goto err_close_obj;
> >>                  }
> >>          } else {
> >> -               err =3D bpf_object__pin_programs(obj, pinfile);
> >> +               if (auto_attach)
> >> +                       err =3D auto_attach_programs(obj, pinfile);
> >> +               else
> >> +                       err =3D bpf_object__pin_programs(obj, pinfile)=
;
> >>                  if (err) {
> >>                          p_err("failed to pin all programs");
> >>                          goto err_close_obj;
> >> @@ -2338,6 +2411,7 @@ static int do_help(int argc, char **argv)
> >>                  "                         [type TYPE] [dev NAME] \\\n=
"
> >>                  "                         [map { idx IDX | name NAME =
} MAP]\\\n"
> >>                  "                         [pinmaps MAP_DIR]\n"
> >> +               "                         [autoattach]\n"
> >>                  "       %1$s %2$s attach PROG ATTACH_TYPE [MAP]\n"
> >>                  "       %1$s %2$s detach PROG ATTACH_TYPE [MAP]\n"
> >>                  "       %1$s %2$s run PROG \\\n"
> >> --
> >> 1.8.3.1
> >>
