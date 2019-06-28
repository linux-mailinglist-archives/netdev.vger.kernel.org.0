Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B65A5F3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfF1Uez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:34:55 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36436 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbfF1Uey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:34:54 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so6040101qkl.3;
        Fri, 28 Jun 2019 13:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIU0F+PgwUXXTEAgm0K90b16wtfjCcFDmmc/i2KN5ls=;
        b=R3xFzJP7MioIMEvCFY401qjMpaG/hPDr5F2kh4mSEUutu81lfwYMxYbm5JpydgUl3s
         IDbDkb00qacTE3JebdlvQjkCxTIQXnp3mYNVRxesKdX0wQ5+US5XmT1Za488346GOCWN
         BKI+dVcKGL1Hrq0WJO43CfcLF79vsY4ayIwp4ojahH0QfmUDk2uRLDWujkBiQLCYRX0N
         ro1Eyrlp28bDKz3j8tiHkPXeQFg0WPR0Vjj5TDb7On3smGX2MQ9xU/olo9vwceNRCaP4
         3B4uZJMi9oO8mIuNYSnDoFVymoJ6h23d8IcTVF9V8QQ+yWCnL1gik03qjewz/y3W/Tfx
         EpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIU0F+PgwUXXTEAgm0K90b16wtfjCcFDmmc/i2KN5ls=;
        b=a3t+iBpqvUF/EJ+oYFsm+ahuaOptiR4rRUZd7KLcEcndOlFQ3QAKR9m3QkUfMgmtQ7
         x6Ig0q92XO8eO0icDUA86EstOXx2ktsu6Mftgy+vJ3ZDQ0+n00S8qy7ykOsrZ9Sl04Kb
         V2iu5CpxK9Yo75w2N6drVvGsD6J2Vdrw0rRWqMDN0vqMA5O83DVZoUOsPTuRAYzX/NGw
         WrZmoikyfbwGxIxyV3aN5BvQROYZhlG/yZMcisDW0fguIo7W3PWJws4dKFNrrquUDum0
         KGxHc+MBpu3pvHjUcK8HsNID2gFxMoNZhDJ4IRC310BfYR3j8FNjeds8IT9PR1m7vg+g
         wdug==
X-Gm-Message-State: APjAAAV6nvfyp0b97SUhwpYo7KeTPK22zrEwvBmkVfyDk2yJESALqW+h
        MrB0SumFSevkR5sLV8BO/4Goda6Ng6p1zbCftP8=
X-Google-Smtp-Source: APXvYqxI8sW+rgEr61vFpV7SS4PAWdokEnGxLBgsnR/eXIiDb9TMZxY0IasPXcdRt5EZyqlEJhnbq0YD5Brsj0Pmgxk=
X-Received: by 2002:a37:a643:: with SMTP id p64mr10689815qke.36.1561754093718;
 Fri, 28 Jun 2019 13:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-5-andriin@fb.com>
 <CAPhsuW6UMdHidpmgRzM0sZaGc5gZAnT1B7vCJVt-MrLCMjOdig@mail.gmail.com>
 <CAEf4Bzbo4r9=VZ2kYaOsZa7HHvjXeEw4uWXhpjcUDvazOcKrzw@mail.gmail.com> <CAPhsuW4xbehq0SQdj_GwJcH++AWAqkYPg6GY3h6rSWMHUwBVFw@mail.gmail.com>
In-Reply-To: <CAPhsuW4xbehq0SQdj_GwJcH++AWAqkYPg6GY3h6rSWMHUwBVFw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 13:34:42 -0700
Message-ID: <CAEf4Bzb00Q8GA7Nr_4KjUAUHaWWap8JRCzX60X4c6+YAbFPFCA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Song Liu <liu.song.a23@gmail.com>
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

On Fri, Jun 28, 2019 at 1:09 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Fri, Jun 28, 2019 at 12:59 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jun 28, 2019 at 12:46 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > >
> > > On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > Add ability to attach to kernel and user probes and retprobes.
> > > > Implementation depends on perf event support for kprobes/uprobes.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c   | 213 +++++++++++++++++++++++++++++++++++++++
> > > >  tools/lib/bpf/libbpf.h   |   7 ++
> > > >  tools/lib/bpf/libbpf.map |   2 +
> > > >  3 files changed, 222 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 606705f878ba..65d2fef41003 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -4016,6 +4016,219 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> > > >         return (struct bpf_link *)link;
> > > >  }
> > > >
> > > > +static int parse_uint(const char *buf)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       errno = 0;
> > > > +       ret = (int)strtol(buf, NULL, 10);
> > > > +       if (errno) {
> > > > +               ret = -errno;
> > > > +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > > > +               return ret;
> > > > +       }
> > > > +       if (ret < 0) {
> > > > +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +       return ret;
> > > > +}
> > > > +
> > > > +static int parse_uint_from_file(const char* file)
> > > > +{
> > > > +       char buf[STRERR_BUFSIZE];
> > > > +       int fd, ret;
> > > > +
> > > > +       fd = open(file, O_RDONLY);
> > > > +       if (fd < 0) {
> > > > +               ret = -errno;
> > > > +               pr_debug("failed to open '%s': %s\n", file,
> > > > +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > > +               return ret;
> > > > +       }
> > > > +       ret = read(fd, buf, sizeof(buf));
> > > > +       ret = ret < 0 ? -errno : ret;
> > > > +       close(fd);
> > > > +       if (ret < 0) {
> > > > +               pr_debug("failed to read '%s': %s\n", file,
> > > > +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > > +               return ret;
> > > > +       }
> > > > +       if (ret == 0 || ret >= sizeof(buf)) {
> > > > +               buf[sizeof(buf) - 1] = 0;
> > > > +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +       return parse_uint(buf);
> > > > +}
> > > > +
> > > > +static int determine_kprobe_perf_type(void)
> > > > +{
> > > > +       const char *file = "/sys/bus/event_source/devices/kprobe/type";
> > > > +       return parse_uint_from_file(file);
> > > > +}
> > > > +
> > > > +static int determine_uprobe_perf_type(void)
> > > > +{
> > > > +       const char *file = "/sys/bus/event_source/devices/uprobe/type";
> > > > +       return parse_uint_from_file(file);
> > > > +}
> > > > +
> > > > +static int parse_config_from_file(const char *file)
> > > > +{
> > > > +       char buf[STRERR_BUFSIZE];
> > > > +       int fd, ret;
> > > > +
> > > > +       fd = open(file, O_RDONLY);
> > > > +       if (fd < 0) {
> > > > +               ret = -errno;
> > > > +               pr_debug("failed to open '%s': %s\n", file,
> > > > +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > > +               return ret;
> > > > +       }
> > > > +       ret = read(fd, buf, sizeof(buf));
> > > > +       ret = ret < 0 ? -errno : ret;
> > > > +       close(fd);
> > > > +       if (ret < 0) {
> > > > +               pr_debug("failed to read '%s': %s\n", file,
> > > > +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> > > > +               return ret;
> > > > +       }
> > > > +       if (ret == 0 || ret >= sizeof(buf)) {
> > > > +               buf[sizeof(buf) - 1] = 0;
> > > > +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +       if (strncmp(buf, "config:", 7)) {
> > > > +               pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +       return parse_uint(buf + 7);
> > > > +}
> > > > +
> > > > +static int determine_kprobe_retprobe_bit(void)
> > > > +{
> > > > +       const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> > > > +       return parse_config_from_file(file);
> > > > +}
> > > > +
> > > > +static int determine_uprobe_retprobe_bit(void)
> > > > +{
> > > > +       const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> > > > +       return parse_config_from_file(file);
> > > > +}
> > >
> > > Can we do the above with fscanf? Would that be easier?
> >
> > It would be less code, but also less strict semantics. E.g., fscanf
> > would happily leave out any garbage after number (e.g., 123blablabla,
> > would still parse). Also, from brief googling, fscanf doesn't handle
> > overflows well.
> >
> > So I guess I'd vote for this more verbose, but also more strict
> > checking, unless you insist on fscanf.
>
> I don't think we need to worry about kernel giving garbage in sysfs.
> Most common error gonna be the file doesn't exist. Error messages
> like "Failed to parse <filename>" would be sufficient.
>
> Let's keep it simpler.

Ok, will switch to fscanf.

>
> >
> > >
> > > > +
> > > > +static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
> > > > +                                uint64_t offset, int pid)
> > > > +{
> > > > +       struct perf_event_attr attr = {};
> > > > +       char errmsg[STRERR_BUFSIZE];
> > > > +       int type, pfd, err;
> > > > +
> > > > +       type = uprobe ? determine_uprobe_perf_type()
> > > > +                     : determine_kprobe_perf_type();
> > > > +       if (type < 0) {
> > > > +               pr_warning("failed to determine %s perf type: %s\n",
> > > > +                          uprobe ? "uprobe" : "kprobe",
> > > > +                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > > > +               return type;
> > > > +       }
> > > > +       if (retprobe) {
> > > > +               int bit = uprobe ? determine_uprobe_retprobe_bit()
> > > > +                                : determine_kprobe_retprobe_bit();
> > > > +
> > > > +               if (bit < 0) {
> > > > +                       pr_warning("failed to determine %s retprobe bit: %s\n",
> > > > +                                  uprobe ? "uprobe" : "kprobe",
> > > > +                                  libbpf_strerror_r(bit, errmsg,
> > > > +                                                    sizeof(errmsg)));
> > > > +                       return bit;
> > > > +               }
> > > > +               attr.config |= 1 << bit;
> > > > +       }
> > > > +       attr.size = sizeof(attr);
> > > > +       attr.type = type;
> > > > +       attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> > > > +       attr.config2 = offset;                 /* kprobe_addr or probe_offset */
> > > > +
> > > > +       /* pid filter is meaningful only for uprobes */
> > > > +       pfd = syscall(__NR_perf_event_open, &attr,
> > > > +                     pid < 0 ? -1 : pid /* pid */,
> > > > +                     pid == -1 ? 0 : -1 /* cpu */,
> > > > +                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > > > +       if (pfd < 0) {
> > > > +               err = -errno;
> > > > +               pr_warning("%s perf_event_open() failed: %s\n",
> > > > +                          uprobe ? "uprobe" : "kprobe",
> > > > +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > >
> > > We have another warning in bpf_program__attach_[k|u]probe(). I guess
> > > we can remove this one here.
> >
> > This points specifically to perf_event_open() failing versus other
> > possible failures. Messages in attach_{k,u}probe won't have that, they
> > will repeat more generic "failed to attach" message. Believe me, if
> > something goes wrong in libbpf, I'd rather have too much logging than
> > too little :)
> >
>
> Fair enough. Let's be verbose here. :)
>
> Song
