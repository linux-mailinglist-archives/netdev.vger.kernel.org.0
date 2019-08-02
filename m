Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84A7EBC9
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 07:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbfHBFCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 01:02:43 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36455 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfHBFCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 01:02:42 -0400
Received: by mail-yw1-f68.google.com with SMTP id x67so25563081ywd.3
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 22:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtLuOXmOKY8Ph70sEx3DZQ1o16q5o0LyFQqzmIXTLvQ=;
        b=l1H9CFcE60qp4Z7pv6mVoBxPlMXSs1rk1x1LL4hkib/VcLvQqrjX0OjFnN5Sn4G3f+
         C6B8lb2DpQj/R5OGqoNFEluijtpOGpHnNMHkSOWndHp5IP2wWIjzFUhEbLqwJplhP2r/
         LpXdl3M0vMtK8JvU6HYblKsvcOBqJzKgMJ3Se8S5UH/BxhECAsZcIMlRUy6A0wY1kxvh
         fmxnvU8HC59hIeE8iWoc2c+rhbXtL93jUNheo/wKYqOl2w7LFXAZTQVGFaZUaNZxKdLO
         OlO17v84GX48drIrvuuGKE3OGgg76kVl/Mzh/47RMnindfeYSWzJzYxE0ggVyRp6PoYQ
         60zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtLuOXmOKY8Ph70sEx3DZQ1o16q5o0LyFQqzmIXTLvQ=;
        b=pt62gYTqc5xtRWYSae4d5B2twyl8x/FU7yCw18CdujJfqphC9E07co3MGhHjL7FZVJ
         zR+k6jyinTC3rBXnSXlxJ5nWSX8yhjDGgJ4TpLgRJzO75r2lxDmDbe86B3VCY+DDqPG6
         xaz1fBvXf0USiFgnNFyxWK/B2TDB2Ld/wigf48jStQP8Iu0T4OxEiRt61Fv4mj7K291l
         EFRGpGBMxacGb3Q254ApbJ9D5xjBfuwnF5pf2oM53oyy4rPukJWsr17ocpOywZSkEIgB
         CfAiqFaHA8OoYpdm6FTjde28H9bFmHI8dnGYJaIZ6ZcHluai81oJvzCXjeUnlvXRzG5U
         yjRA==
X-Gm-Message-State: APjAAAWUUabRh2m8qI1qPd2d7w5WRHx6s/BtXi6RK6+RYvO+HqGWmvSa
        +s4btxRRa+avoVGjyWPOweGwObjyPnh2rf06og==
X-Google-Smtp-Source: APXvYqx8fsl41DHgKDVXxNvCurMI0zt/MmYk2jnevzPyGslttT9i97y6fqakpY9C3J5FgADljbSqpcZn+I5yipDqDiE=
X-Received: by 2002:a81:4fd4:: with SMTP id d203mr77376492ywb.166.1564722160989;
 Thu, 01 Aug 2019 22:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com>
 <20190801081133.13200-2-danieltimlee@gmail.com> <20190801163638.71700f6d@cakuba.netronome.com>
In-Reply-To: <20190801163638.71700f6d@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 2 Aug 2019 14:02:29 +0900
Message-ID: <CAEKGpzhsjMuf+DtN3pDVYMxJa5o2e=-3AeWbHFiFoMoXCkgsNg@mail.gmail.com>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP on interface
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 8:36 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu,  1 Aug 2019 17:11:32 +0900, Daniel T. Lee wrote:
> > By this commit, using `bpftool net attach`, user can attach XDP prog on
> > interface. New type of enum 'net_attach_type' has been made, as stated at
> > cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> >
> > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >   - command 'load' changed to 'attach' for the consistency
> >   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'
> >
> >  tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 106 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 67e99c56bc88..f3b57660b303 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -55,6 +55,35 @@ struct bpf_attach_info {
> >       __u32 flow_dissector_id;
> >  };
> >
> > +enum net_attach_type {
> > +     NET_ATTACH_TYPE_XDP,
> > +     NET_ATTACH_TYPE_XDP_GENERIC,
> > +     NET_ATTACH_TYPE_XDP_DRIVER,
> > +     NET_ATTACH_TYPE_XDP_OFFLOAD,
> > +     __MAX_NET_ATTACH_TYPE
> > +};
> > +
> > +static const char * const attach_type_strings[] = {
> > +     [NET_ATTACH_TYPE_XDP] = "xdp",
> > +     [NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
> > +     [NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
> > +     [NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
> > +     [__MAX_NET_ATTACH_TYPE] = NULL,
>
> Not sure if the terminator is necessary,
> ARRAY_SIZE(attach_type_strings) should suffice?

Yes, ARRAY_SIZE is fine though. But I was just trying to make below
'parse_attach_type' consistent with 'parse_attach_type' from the 'prog.c'.
At 'prog.c', It has same terminator at 'attach_type_strings'.

Should I change it or keep it?

> > +};
> > +
> > +static enum net_attach_type parse_attach_type(const char *str)
> > +{
> > +     enum net_attach_type type;
> > +
> > +     for (type = 0; type < __MAX_NET_ATTACH_TYPE; type++) {
> > +             if (attach_type_strings[type] &&
> > +                is_prefix(str, attach_type_strings[type]))
> > +                     return type;
> > +     }
> > +
> > +     return __MAX_NET_ATTACH_TYPE;
> > +}
> > +
> >  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
> >  {
> >       struct bpf_netdev_t *netinfo = cookie;
> > @@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
> >       return 0;
> >  }
> >
> > +static int parse_attach_args(int argc, char **argv, int *progfd,
> > +                          enum net_attach_type *attach_type, int *ifindex)
> > +{
> > +     if (!REQ_ARGS(3))
> > +             return -EINVAL;
> > +
> > +     *progfd = prog_parse_fd(&argc, &argv);
> > +     if (*progfd < 0)
> > +             return *progfd;
> > +
> > +     *attach_type = parse_attach_type(*argv);
> > +     if (*attach_type == __MAX_NET_ATTACH_TYPE) {
> > +             p_err("invalid net attach/detach type");
> > +             return -EINVAL;
>
> You should close the progfd on error paths.

I will add 'close(*progfd);' at next version of patch.

>
> > +     }
>
> Hm. I'm not too sure about the ordering of arguments, type should
> probably be right after attach.
>
> If we ever add tc attach support or some other hook, that's more
> fundamental part of the command than the program. So I think:
>
> bpftool net attach xdp id xyz dev ethN

I think it is more reasonable than current format.
I'll change the argument order as attach type comes in first.

> > +     NEXT_ARG();
> > +     if (!REQ_ARGS(1))
> > +             return -EINVAL;
>
> Error message needed here.
>

Actually it provides error message like:
Error: 'xdp' needs at least 1 arguments, 0 found

are you suggesting that any additional error message is necessary?

> > +     *ifindex = if_nametoindex(*argv);
> > +     if (!*ifindex) {
> > +             p_err("Invalid ifname");
>
> "ifname" is not mentioned in help, it'd be best to keep this error
> message consistent with bpftool prog load.

I will change it to a 'devname', since the word is mentioned in help.

> > +             return -EINVAL;
> > +     }
>
> Please require the dev keyword before the interface name.
> That'll make it feel closer to prog load syntax.

If adding the dev keyword before interface name, will it be too long to type in?
and also `bpftool prog` use extra keyword (such as dev) when it is
optional keyword.

       bpftool prog dump jited  PROG [{ file FILE | opcodes | linum }]
       bpftool prog pin   PROG FILE
       bpftool prog { load | loadall } OBJ  PATH \

as you can see here, FILE uses optional keyword 'file' when the
argument is optional.

       bpftool prog { load | loadall } OBJ  PATH \
                         [type TYPE] [dev NAME] \
                         [map { idx IDX | name NAME } MAP]\
                         [pinmaps MAP_DIR]

Yes, bpftool prog load has dev keyword with it,

but first, like previous, the argument is optional so i think it is
unnecessary to use optional keyword 'dev'.
and secondly, 'bpftool net attach' isn't really related to 'bpftool prog load'.

At previous version patch, I was using word 'load' instead of
'attach', since XDP program is not
considered as 'BPF_PROG_ATTACH', so it might give a confusion. However
by the last patch discussion,
word 'load' has been replaced to 'attach'.

Keeping the consistency is very important, but I was just wandering
about making command
similar to 'bpftool prog load' syntax.

>
> > +     return 0;
> > +}
> > +
> > +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> > +                             int *ifindex)
> > +{
> > +     __u32 flags;
> > +     int err;
> > +
> > +     flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
>
> Please add this as an option so that user can decide whether overwrite
> is allowed or not.

Adding force flag to bpftool seems necessary.
I will add an optional argument for this.

> > +     if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> > +             flags |= XDP_FLAGS_SKB_MODE;
> > +     if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> > +             flags |= XDP_FLAGS_DRV_MODE;
> > +     if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> > +             flags |= XDP_FLAGS_HW_MODE;
> > +
> > +     err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> > +
> > +     return err;
>
> no need for the err variable here.

My apologies, but I'm not sure why err variable isn't needed at here.
AFAIK, 'bpf_set_link_xdp_fd' from libbpf returns the netlink_recv result,
and in order to propagate error, err variable is necessary, I guess?

> > +}
> > +
> > +static int do_attach(int argc, char **argv)
> > +{
> > +     enum net_attach_type attach_type;
> > +     int err, progfd, ifindex;
> > +
> > +     err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> > +     if (err)
> > +             return err;
>
> Probably not the best idea to move this out into a helper.

Again, just trying to make consistent with 'prog.c'.

But clearly it has differences with do_attach/detach from 'prog.c'.
From it, it uses the same parse logic 'parse_attach_detach_args' since
the two command 'bpftool prog attach/detach' uses the same argument format.

However, in here, 'bpftool net' attach and detach requires different number of
argument, so function for parse argument has been defined separately.
The situation is little bit different, but keeping argument parse logic as an
helper, I think it's better in terms of consistency.


About the moving parse logic to a helper, I was trying to keep command
entry (do_attach)
as simple as possible. Parse all the argument in command entry will
make function longer
and might make harder to understand what it does.

And I'm not pretty sure that argument parse logic will stays the same
after other attachment
type comes in. What I mean is, the argument count or type might be
added and to fulfill
all that specific cases, the code might grow larger.

So for the consistency, simplicity and extensibility, I prefer to keep
it as a helper.

> > +     if (is_prefix("xdp", attach_type_strings[attach_type]))
> > +             err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
>
> Hm. We either need an error to be reported if it's not xdp or since we
> only accept XDP now perhaps the if() is superfluous?

Well, if the attach_type isn't xdp, the error will be occurred from
the argument parse,
Will it be necessary to reinforce with error logic to make it more secure?

> > +     if (err < 0) {
> > +             p_err("link set %s failed", attach_type_strings[attach_type]);
>
> "link set"?  So you are familiar with iproute2 syntax! :)

Well at first, to avoid confusion about using a command for end-user,
I referenced iproute2 and tried to keep similar message form with it.

But through the discussion about iproute2 and bpftool, it would be better not to
use word such as 'link set'. Maybe "interface %s attach failed" would be better
for clear understanding.

I will fix it at next version of patch.

> > +             return -1;
> > +     }
> > +
> > +     if (json_output)
> > +             jsonw_null(json_wtr);
> > +
> > +     return 0;
> > +}
> > +
> >  static int do_show(int argc, char **argv)
> >  {
> >       struct bpf_attach_info attach_info = {};
> > @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
> >
> >       fprintf(stderr,
> >               "Usage: %s %s { show | list } [dev <devname>]\n"
> > +             "       %s %s attach PROG LOAD_TYPE <devname>\n"
> >               "       %s %s help\n"
> > +             "\n"
> > +             "       " HELP_SPEC_PROGRAM "\n"
> > +             "       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
>
> ATTACH_TYPE now?
>
> Perhaps a new line before the "Note"?

My bad.
Will change it right away.

> >               "Note: Only xdp and tc attachments are supported now.\n"
> >               "      For progs attached to cgroups, use \"bpftool cgroup\"\n"
> >               "      to dump program attachments. For program types\n"
> >               "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> >               "      consult iproute2.\n",
> > -             bin_name, argv[-2], bin_name, argv[-2]);
> > +             bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> >
> >       return 0;
> >  }
> > @@ -319,6 +423,7 @@ static int do_help(int argc, char **argv)
> >  static const struct cmd cmds[] = {
> >       { "show",       do_show },
> >       { "list",       do_show },
> > +     { "attach",     do_attach },
> >       { "help",       do_help },
> >       { 0 }
> >  };
>

Thanks for the detailed review! :)
