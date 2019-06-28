Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D535A5AF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfF1UJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:09:17 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36821 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfF1UJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:09:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so7764835qtl.3;
        Fri, 28 Jun 2019 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FyTaUdxwvS4YL4FRppN1PSDIR/mPVeV2VIGogxobDY=;
        b=CQycETFc7WEA0BW5TIXsdix4eLdJ9fgk6s/1M/CDT8h6lPrF2tnlgRqmqluyzTy6rs
         sZoYd/fIpd+ECNuyW2MsDvNsTsDfTGbvq+uHV01krUkIPRU0XPL8x1K3kr/z1ZiOx40I
         DHvw77IuBRpFoSMNYOW59jz708Kt+6NDSJUQJpZwRH/vyfKGaFYciIsD7om/5KxSx8MB
         Gm0zUEIbOM/eC2Nvfx9PZL464vFRPaNUqkKvc+XFhqUPpOMPxOPbrxBQH+YRuRLjrnhY
         vmsSEcuG4+ZOyH2BcxXJ1PLPKPeqTjN9fEUfbVAZaWbQn4RCmszVp9g2yT4VxJbXO5Bi
         0SHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FyTaUdxwvS4YL4FRppN1PSDIR/mPVeV2VIGogxobDY=;
        b=Y43jhETOTTrLQjcmnhNop2oXXO/0YdDFVclZVqomv9HHRrAa9i3Pd21bRRrQ+qZhjM
         RRLLT+YwMjq+jYyuuObk2s9IBAFbBHSq8RlIJ4IljO6VvWRvzOAGzkSbODkJ0PkUSJXH
         OU+GW6BaAWLAyc51o0RisAlIJSoVUx1CfS40znwEBWvS31Skvz6g9CgeO/3cJOlO0J1T
         SgZsKC07Q62FJFH0mx+64hHW1UU2zRtRwghIK9+0A/y+PwsV2W8tCGu8ppb+ZoSXArxS
         O30fKqfTo7AGjGL+7xucSDs5AebOgDxkD5Tk30eqOOAyeaNKYzhKsUfRNeh9lJvAQ7iO
         vIYg==
X-Gm-Message-State: APjAAAUAUh2Lmo6CGVb7nJvMPrhIBFwXA3XdX0cdH9GVcIMa5tR619js
        nrNX5myd6JO+5uyOIABFAVrUF4FWOjwL0m/6OWI=
X-Google-Smtp-Source: APXvYqzD+eX9Pln/tSUI/X3EzIzc4t36Oa4ljvecJZEhdgIhERaTBB2e948tHvPAzjSPHGyxMYsu09icxSlNcp3ra3g=
X-Received: by 2002:a0c:9695:: with SMTP id a21mr10150082qvd.24.1561752556411;
 Fri, 28 Jun 2019 13:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-5-andriin@fb.com>
 <CAPhsuW6UMdHidpmgRzM0sZaGc5gZAnT1B7vCJVt-MrLCMjOdig@mail.gmail.com> <CAEf4Bzbo4r9=VZ2kYaOsZa7HHvjXeEw4uWXhpjcUDvazOcKrzw@mail.gmail.com>
In-Reply-To: <CAEf4Bzbo4r9=VZ2kYaOsZa7HHvjXeEw4uWXhpjcUDvazOcKrzw@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:09:05 -0700
Message-ID: <CAPhsuW4xbehq0SQdj_GwJcH++AWAqkYPg6GY3h6rSWMHUwBVFw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 12:59 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jun 28, 2019 at 12:46 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > Add ability to attach to kernel and user probes and retprobes.
> > > Implementation depends on perf event support for kprobes/uprobes.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c   | 213 +++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/libbpf.h   |   7 ++
> > >  tools/lib/bpf/libbpf.map |   2 +
> > >  3 files changed, 222 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 606705f878ba..65d2fef41003 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4016,6 +4016,219 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > >         return (struct bpf_link *)link;
> > >  }
> > >
> > > +static int parse_uint(const char *buf)
> > > +{
> > > +       int ret;
> > > +
> > > +       errno = 0;
> > > +       ret = (int)strtol(buf, NULL, 10);
> > > +       if (errno) {
> > > +               ret = -errno;
> > > +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > > +               return ret;
> > > +       }
> > > +       if (ret < 0) {
> > > +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > > +               return -EINVAL;
> > > +       }
> > > +       return ret;
> > > +}
> > > +
> > > +static int parse_uint_from_file(const char* file)
> > > +{
> > > +       char buf[STRERR_BUFSIZE];
> > > +       int fd, ret;
> > > +
> > > +       fd = open(file, O_RDONLY);
> > > +       if (fd < 0) {
> > > +               ret = -errno;
> > > +               pr_debug("failed to open '%s': %s\n", file,
> > > +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > +               return ret;
> > > +       }
> > > +       ret = read(fd, buf, sizeof(buf));
> > > +       ret = ret < 0 ? -errno : ret;
> > > +       close(fd);
> > > +       if (ret < 0) {
> > > +               pr_debug("failed to read '%s': %s\n", file,
> > > +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > +               return ret;
> > > +       }
> > > +       if (ret == 0 || ret >= sizeof(buf)) {
> > > +               buf[sizeof(buf) - 1] = 0;
> > > +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > > +               return -EINVAL;
> > > +       }
> > > +       return parse_uint(buf);
> > > +}
> > > +
> > > +static int determine_kprobe_perf_type(void)
> > > +{
> > > +       const char *file = "/sys/bus/event_source/devices/kprobe/type";
> > > +       return parse_uint_from_file(file);
> > > +}
> > > +
> > > +static int determine_uprobe_perf_type(void)
> > > +{
> > > +       const char *file = "/sys/bus/event_source/devices/uprobe/type";
> > > +       return parse_uint_from_file(file);
> > > +}
> > > +
> > > +static int parse_config_from_file(const char *file)
> > > +{
> > > +       char buf[STRERR_BUFSIZE];
> > > +       int fd, ret;
> > > +
> > > +       fd = open(file, O_RDONLY);
> > > +       if (fd < 0) {
> > > +               ret = -errno;
> > > +               pr_debug("failed to open '%s': %s\n", file,
> > > +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > +               return ret;
> > > +       }
> > > +       ret = read(fd, buf, sizeof(buf));
> > > +       ret = ret < 0 ? -errno : ret;
> > > +       close(fd);
> > > +       if (ret < 0) {
> > > +               pr_debug("failed to read '%s': %s\n", file,
> > > +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > +               return ret;
> > > +       }
> > > +       if (ret == 0 || ret >= sizeof(buf)) {
> > > +               buf[sizeof(buf) - 1] = 0;
> > > +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > > +               return -EINVAL;
> > > +       }
> > > +       if (strncmp(buf, "config:", 7)) {
> > > +               pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> > > +               return -EINVAL;
> > > +       }
> > > +       return parse_uint(buf + 7);
> > > +}
> > > +
> > > +static int determine_kprobe_retprobe_bit(void)
> > > +{
> > > +       const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> > > +       return parse_config_from_file(file);
> > > +}
> > > +
> > > +static int determine_uprobe_retprobe_bit(void)
> > > +{
> > > +       const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> > > +       return parse_config_from_file(file);
> > > +}
> >
> > Can we do the above with fscanf? Would that be easier?
>
> It would be less code, but also less strict semantics. E.g., fscanf
> would happily leave out any garbage after number (e.g., 123blablabla,
> would still parse). Also, from brief googling, fscanf doesn't handle
> overflows well.
>
> So I guess I'd vote for this more verbose, but also more strict
> checking, unless you insist on fscanf.

I don't think we need to worry about kernel giving garbage in sysfs.
Most common error gonna be the file doesn't exist. Error messages
like "Failed to parse <filename>" would be sufficient.

Let's keep it simpler.

>
> >
> > > +
> > > +static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
> > > +                                uint64_t offset, int pid)
> > > +{
> > > +       struct perf_event_attr attr = {};
> > > +       char errmsg[STRERR_BUFSIZE];
> > > +       int type, pfd, err;
> > > +
> > > +       type = uprobe ? determine_uprobe_perf_type()
> > > +                     : determine_kprobe_perf_type();
> > > +       if (type < 0) {
> > > +               pr_warning("failed to determine %s perf type: %s\n",
> > > +                          uprobe ? "uprobe" : "kprobe",
> > > +                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > > +               return type;
> > > +       }
> > > +       if (retprobe) {
> > > +               int bit = uprobe ? determine_uprobe_retprobe_bit()
> > > +                                : determine_kprobe_retprobe_bit();
> > > +
> > > +               if (bit < 0) {
> > > +                       pr_warning("failed to determine %s retprobe bit: %s\n",
> > > +                                  uprobe ? "uprobe" : "kprobe",
> > > +                                  libbpf_strerror_r(bit, errmsg,
> > > +                                                    sizeof(errmsg)));
> > > +                       return bit;
> > > +               }
> > > +               attr.config |= 1 << bit;
> > > +       }
> > > +       attr.size = sizeof(attr);
> > > +       attr.type = type;
> > > +       attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> > > +       attr.config2 = offset;                 /* kprobe_addr or probe_offset */
> > > +
> > > +       /* pid filter is meaningful only for uprobes */
> > > +       pfd = syscall(__NR_perf_event_open, &attr,
> > > +                     pid < 0 ? -1 : pid /* pid */,
> > > +                     pid == -1 ? 0 : -1 /* cpu */,
> > > +                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > > +       if (pfd < 0) {
> > > +               err = -errno;
> > > +               pr_warning("%s perf_event_open() failed: %s\n",
> > > +                          uprobe ? "uprobe" : "kprobe",
> > > +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> >
> > We have another warning in bpf_program__attach_[k|u]probe(). I guess
> > we can remove this one here.
>
> This points specifically to perf_event_open() failing versus other
> possible failures. Messages in attach_{k,u}probe won't have that, they
> will repeat more generic "failed to attach" message. Believe me, if
> something goes wrong in libbpf, I'd rather have too much logging than
> too little :)
>

Fair enough. Let's be verbose here. :)

Song
