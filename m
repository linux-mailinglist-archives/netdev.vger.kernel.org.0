Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDB85B62
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbfHHHPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 03:15:35 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40544 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHHHPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 03:15:35 -0400
Received: by mail-yb1-f194.google.com with SMTP id j6so3377514ybm.7
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 00:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cyMq0TgtB9lz08Wm0cH/3Gne0YN9zIz2WPr4TGO+rtM=;
        b=XqZP+7loYcwZ3he2fSnDYg8FOGnfJX7HhVnMyJgRdZrTKTTTN2sP4YVEXSWQYyzusj
         1sQic/QMCQOgMIeIoy7U2ceAa+xjQKLMm6KzNuQ50v8U8mhIWnVUmbpxdsxbLsJzLh0q
         r22e0jsJoY9Krfm97NKXcS5dsqSqOCRRqaid89VsFZRvXc6LREaT7XsEVBIJgSs5xzaE
         mAUrnDlXgSY5ps+Om4ia2dBnVX3HhiZ98fMFLtZdMcnQB6qUlA7zSveLUq7zpucqIVwE
         JNkmpBQvpoNN7vSBPAgCW/WnPgnfUNSGW4+j7aZIPBL7PZ0bHksEZsCAwYEXwLXfw6Q+
         8bOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cyMq0TgtB9lz08Wm0cH/3Gne0YN9zIz2WPr4TGO+rtM=;
        b=QwlNgCuF9A9BKNVVVRvtEkJWpdEedMVxAA+ueIGc2vENkcAgBEfIisSfVEB3xYWpDj
         dYSwTTzL/7sErp1IaW19DqgHdDVTkyPDAUdDC1xvS+VjoOofAqJLvJmXBo9Mxjnlr96p
         RhyR9iYblfAjl8li/06TTjASA0MKrRuoPjbyKsKa2f1sUBUZf1jY2gqVI2gDQArMvPUY
         v+N3KpKcMvWio55iQkm0DnhFb+zWj82gpcW9r5azkh8jp0A0m9kXwJ85fdQgG3GgyHrX
         3eUrve8FlmGExcFLbZXt5hnnIFFok3FVScpG0c5ZOifT4B45VXEzgbBk3BVaok+K+i9x
         sXdA==
X-Gm-Message-State: APjAAAVz1PDoN2F0q2BqpPwfbD+iqjAbaffCbe/W8hqvv77MPHqHGXy0
        Pzkph0Ejs1G5iTZgRRHwhdCoe8YG9KuJ6l3cMA==
X-Google-Smtp-Source: APXvYqwO0GkfpTvzpCz8z8eNEK0DRPMOq60RVf3DB9TU/yr+XrVP1l1J5wUSCf/yzuzznqSUmhlBmvLQHcGCtkYxHBM=
X-Received: by 2002:a25:938e:: with SMTP id a14mr4829428ybm.333.1565248533402;
 Thu, 08 Aug 2019 00:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-2-danieltimlee@gmail.com>
 <20190807134208.6601fad2@cakuba.netronome.com>
In-Reply-To: <20190807134208.6601fad2@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 8 Aug 2019 07:15:22 +0900
Message-ID: <CAEKGpzj1VKWuWioEmRkNXrgfDdT-KkWZWsrbY+p=yyK8sPctwg@mail.gmail.com>
Subject: Re: [v3,1/4] tools: bpftool: add net attach command to attach XDP on interface
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 5:42 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed,  7 Aug 2019 11:25:06 +0900, Daniel T. Lee wrote:
> > By this commit, using `bpftool net attach`, user can attach XDP prog on
> > interface. New type of enum 'net_attach_type' has been made, as stated at
> > cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> >
> > With 'overwrite' option at argument, attached XDP program could be replaced.
> > Added new helper 'net_parse_dev' to parse the network device at argument.
> >
> > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  tools/bpf/bpftool/net.c | 141 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 130 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 67e99c56bc88..c05a3fac5cac 100644
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
> > +};
> > +
> > +static const char * const attach_type_strings[] = {
> > +     [NET_ATTACH_TYPE_XDP]           = "xdp",
> > +     [NET_ATTACH_TYPE_XDP_GENERIC]   = "xdpgeneric",
> > +     [NET_ATTACH_TYPE_XDP_DRIVER]    = "xdpdrv",
> > +     [NET_ATTACH_TYPE_XDP_OFFLOAD]   = "xdpoffload",
> > +};
> > +
> > +const size_t max_net_attach_type = ARRAY_SIZE(attach_type_strings);
>
> Nit: in practice max_.._type is num_types - 1, so perhaps rename this
> to num_.. or such?
>

I can see at 'map.c', it declares ARRAY_SIZE with '_size' suffix.
         const size_t map_type_name_size = ARRAY_SIZE(map_type_name);

I'll change this variable name 'max_net_attach_type' to 'net_attach_type_size'.

> > +static enum net_attach_type parse_attach_type(const char *str)
> > +{
> > +     enum net_attach_type type;
> > +
> > +     for (type = 0; type < max_net_attach_type; type++) {
> > +             if (attach_type_strings[type] &&
> > +                is_prefix(str, attach_type_strings[type]))
>
>                    ^
> this is misaligned by one space
>
> Please try checkpatch with the --strict option to catch these.
>

I didn't know checkpatch has strict option.
Thanks for letting me know!

> > +                     return type;
> > +     }
> > +
> > +     return max_net_attach_type;
> > +}
> > +
> >  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
> >  {
> >       struct bpf_netdev_t *netinfo = cookie;
> > @@ -223,6 +252,97 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
> >       return 0;
> >  }
> >
> > +static int net_parse_dev(int *argc, char ***argv)
> > +{
> > +     int ifindex;
> > +
> > +     if (is_prefix(**argv, "dev")) {
> > +             NEXT_ARGP();
> > +
> > +             ifindex = if_nametoindex(**argv);
> > +             if (!ifindex)
> > +                     p_err("invalid devname %s", **argv);
> > +
> > +             NEXT_ARGP();
> > +     } else {
> > +             p_err("expected 'dev', got: '%s'?", **argv);
> > +             return -1;
> > +     }
> > +
> > +     return ifindex;
> > +}
> > +
> > +static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
> > +                             int ifindex, bool overwrite)
> > +{
> > +     __u32 flags = 0;
> > +
> > +     if (!overwrite)
> > +             flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > +     if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> > +             flags |= XDP_FLAGS_SKB_MODE;
> > +     if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> > +             flags |= XDP_FLAGS_DRV_MODE;
> > +     if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> > +             flags |= XDP_FLAGS_HW_MODE;
> > +
> > +     return bpf_set_link_xdp_fd(ifindex, progfd, flags);
> > +}
> > +
> > +static int do_attach(int argc, char **argv)
> > +{
> > +     enum net_attach_type attach_type;
> > +     int progfd, ifindex, err = 0;
> > +     bool overwrite = false;
> > +
> > +     /* parse attach args */
> > +     if (!REQ_ARGS(5))
> > +             return -EINVAL;
> > +
> > +     attach_type = parse_attach_type(*argv);
> > +     if (attach_type == max_net_attach_type) {
> > +             p_err("invalid net attach/detach type");
>
> worth adding the type to the error message so that user know which part
> of command line was wrong:
>
>         p_err("invalid net attach/detach type '%s'", *argv);
>

It sounds reasonable.
I'll update the error message.


> > +             return -EINVAL;
> > +     }
> > +
> > +     NEXT_ARG();
>
> nit: the new line should be before NEXT_ARG(), IOV NEXT_ARG() belongs
> to the code which consumed the argument
>

I'm not sure I'm following.
Are you saying that, at here the newline shouldn't be necessary?

> > +     progfd = prog_parse_fd(&argc, &argv);
> > +     if (progfd < 0)
> > +             return -EINVAL;
> > +
> > +     ifindex = net_parse_dev(&argc, &argv);
> > +     if (ifindex < 1) {
> > +             close(progfd);
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (argc) {
> > +             if (is_prefix(*argv, "overwrite")) {
> > +                     overwrite = true;
> > +             } else {
> > +                     p_err("expected 'overwrite', got: '%s'?", *argv);
> > +                     close(progfd);
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     /* attach xdp prog */
> > +     if (is_prefix("xdp", attach_type_strings[attach_type]))
>
> I'm still unclear on why this if is needed
>

Just an code structure that shows extensibility for other attachment types.
Well, for now there's no other type than XDP, so it's not necessary.

> > +             err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> > +                                        overwrite);
> > +
> > +     if (err < 0) {
> > +             p_err("interface %s attach failed",
> > +                   attach_type_strings[attach_type]);
>
> Please add the error string, like:
>
>                 p_err("interface %s attach failed: %s",
>                       attach_type_strings[attach_type], strerror(errno));
>
>

Oh. Didn't think of propagate errno to error message.
I'll update it right away.

> > +             return err;
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
> > @@ -231,17 +351,10 @@ static int do_show(int argc, char **argv)
> >       unsigned int nl_pid;
> >       char err_buf[256];
> >
> > -     if (argc == 2) {
> > -             if (strcmp(argv[0], "dev") != 0)
> > -                     usage();
> > -             filter_idx = if_nametoindex(argv[1]);
> > -             if (filter_idx == 0) {
> > -                     fprintf(stderr, "invalid dev name %s\n", argv[1]);
> > -                     return -1;
> > -             }
> > -     } else if (argc != 0) {
> > +     if (argc == 2)
> > +             filter_idx = net_parse_dev(&argc, &argv);
>
> You should check filter_idx is not negative here, no?
>

You're right.
I'll update it.

> > +     else if (argc != 0)
> >               usage();
> > -     }
> >
> >       ret = query_flow_dissector(&attach_info);
> >       if (ret)

Thank you for your assistance.
