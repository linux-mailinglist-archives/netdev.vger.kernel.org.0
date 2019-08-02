Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638AC7EC97
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 08:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733156AbfHBG0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 02:26:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43836 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732523AbfHBG0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 02:26:03 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so149794954ios.10
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 23:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cN+AWRk8YQN49KMh4y3/O9OoZs5JVSFjMFFwJaSf5X0=;
        b=sXSlJ+1JR8XW2vM9h09ziEnFtWttnGrByFCJHv4n8TJJ5Ml+bpWmQyeGBdMgG3sx8Z
         /QWSvK0ELJrmB8KPIrjFwf5ts7jQaB0vmlE7TCrBfKKiWuSzxYt85wAYR+LdNqua7wIv
         0TbBbFRMPLJZJE3z4nDXwtyyXkvAZZ1eFjo3fFpw+YR4Sdcld4mDTvNc3ubwN1hS4N9O
         h7wBdZ4SPzPL37us6gum4IdcuRLmBhq3D+4oQW+DcCKmX8Xr8scwYyU2Crq07cSq4AII
         jnPLT1XS/JuYUhv0+Gao1Rin4fuvK79k7ef7Jn9Y0qvZqN5byvz99k4mVTcUVQOFjuoO
         sXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cN+AWRk8YQN49KMh4y3/O9OoZs5JVSFjMFFwJaSf5X0=;
        b=fWSBDG5qOaWDF3BqVvXrQIiS4mSOezQOh/x4ksyJNaputNelir9llvuuGkaNIg8Ikz
         iJf7RPmTLxI9J5KlgVvj5+8sR90bJFMON2awa8CCdMQX9UWoRRKT/oRSrdgoCjaWQor0
         Qchjhc76S/6P2deAYrwTLfQ3O9jSgkj1aryUmexvKsmjnhDWQAIvNwcL2Yu3fiBy0o6A
         IOt4PQm7tCWhgyTB6u3DR5mR93BIs46AGnh146RSvCsqzRsQZk4Uo7WttgpqcTc6O+lF
         lQYM89ue012lHDY5T17iIlXUb+hE2+YPlZ/bacsHGxoGayDcoXKd4VGKbIBzgl0bgYyV
         opjg==
X-Gm-Message-State: APjAAAVKX5k3pqhNykxdAa7xM+18BSRwvwUOhXy8qdo0Je/Ki+xTxBDr
        lNJNdkDoySdKI7Tw9o3c0hCeev1ICMy2/IULcfc=
X-Google-Smtp-Source: APXvYqxlDHo4WP5CyhTmVl+RwhvZt2TztxCmn6ZwQ2CD1DAgRy0dtjD1FzBCHSyCczxXlS0o7rZ31EcVmNaElNRTVHQ=
X-Received: by 2002:a5d:9d58:: with SMTP id k24mr120401823iok.116.1564727162421;
 Thu, 01 Aug 2019 23:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com> <20190801081133.13200-3-danieltimlee@gmail.com>
In-Reply-To: <20190801081133.13200-3-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 1 Aug 2019 23:25:26 -0700
Message-ID: <CAH3MdRX_OCnN82GESHBD+-wZvZqo7fba0ExDyqTh_3_tfRR1Nw@mail.gmail.com>
Subject: Re: [v2,2/2] tools: bpftool: add net detach command to detach XDP on interface
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 2:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> By this commit, using `bpftool net detach`, the attached XDP prog can
> be detached. Detaching the BPF prog will be done through libbpf
> 'bpf_set_link_xdp_fd' with the progfd set to -1.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>   - command 'unload' changed to 'detach' for the consistency
>
>  tools/bpf/bpftool/net.c | 55 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index f3b57660b303..2ae9a613b05c 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -281,6 +281,31 @@ static int parse_attach_args(int argc, char **argv, int *progfd,
>         return 0;
>  }
>
> +static int parse_detach_args(int argc, char **argv,
> +                            enum net_attach_type *attach_type, int *ifindex)
> +{
> +       if (!REQ_ARGS(2))
> +               return -EINVAL;
> +
> +       *attach_type = parse_attach_type(*argv);
> +       if (*attach_type == __MAX_NET_ATTACH_TYPE) {
> +               p_err("invalid net attach/detach type");
> +               return -EINVAL;
> +       }
> +
> +       NEXT_ARG();
> +       if (!REQ_ARGS(1))
> +               return -EINVAL;
> +
> +       *ifindex = if_nametoindex(*argv);
> +       if (!*ifindex) {
> +               p_err("Invalid ifname");
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
>                                 int *ifindex)
>  {
> @@ -323,6 +348,31 @@ static int do_attach(int argc, char **argv)
>         return 0;
>  }
>
> +static int do_detach(int argc, char **argv)
> +{
> +       enum net_attach_type attach_type;
> +       int err, progfd, ifindex;
> +
> +       err = parse_detach_args(argc, argv, &attach_type, &ifindex);
> +       if (err)
> +               return err;
> +
> +       /* to detach xdp prog */
> +       progfd = -1;
> +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> +               err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);

Similar to previous patch, parameters no need to be pointer.

> +
> +       if (err < 0) {
> +               p_err("link set %s failed", attach_type_strings[attach_type]);
> +               return -1;

Maybe "return err"?

> +       }
> +
> +       if (json_output)
> +               jsonw_null(json_wtr);
> +
> +       return 0;
> +}
> +
>  static int do_show(int argc, char **argv)
>  {
>         struct bpf_attach_info attach_info = {};
> @@ -406,6 +456,7 @@ static int do_help(int argc, char **argv)
>         fprintf(stderr,
>                 "Usage: %s %s { show | list } [dev <devname>]\n"
>                 "       %s %s attach PROG LOAD_TYPE <devname>\n"
> +               "       %s %s detach LOAD_TYPE <devname>\n"
>                 "       %s %s help\n"
>                 "\n"
>                 "       " HELP_SPEC_PROGRAM "\n"
> @@ -415,7 +466,8 @@ static int do_help(int argc, char **argv)
>                 "      to dump program attachments. For program types\n"
>                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
>                 "      consult iproute2.\n",
> -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> +               bin_name, argv[-2]);
>
>         return 0;
>  }
> @@ -424,6 +476,7 @@ static const struct cmd cmds[] = {
>         { "show",       do_show },
>         { "list",       do_show },
>         { "attach",     do_attach },
> +       { "detach",     do_detach },
>         { "help",       do_help },
>         { 0 }
>  };
> --
> 2.20.1
>
