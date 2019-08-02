Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6017C7EC90
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 08:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfHBGX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 02:23:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46158 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731905AbfHBGXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 02:23:55 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so36507405iol.13
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 23:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3+XBRtJ2L1B+8XkgC3Rm6qjFF/htXgFTbp8SIldPcxg=;
        b=oz5WfnX7kiIilMAN7455w/pfEKmeI8exsxaXURt7eOOUR6G5iNjIxfe2XV8m4R2iMw
         TN/T8QjMPWmAVrEVTr+dJ7Hr8GpDITIkzYz7lcx2w19l4jtYzO5xWMKEXsEh8tZfbMcQ
         XkGW7U5rUAmFCaJ2uQxt2Rq4OTLSUll3kiPElx+BAiM1RPKmv2x6Kojt5N6Gnx6eIqEY
         MgkWYSacVvKdjlbK6h9MrtOS3yi8sJZv1tOt+kx+pKv7rQHQ1B02ohTOLSdTldcg/DKs
         pshfWhOSVTHKF3m+bwYEdCz9ezM9yVtEMLtRf1mUWA+UMT2HW7kge81xwSATIBckiwPK
         p1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3+XBRtJ2L1B+8XkgC3Rm6qjFF/htXgFTbp8SIldPcxg=;
        b=tR4zIVX9BeJApsv9q35prB9eobyqFbQDoKMirgZI931bYHumY48MspimJ76vurptWU
         Q9Jr8jFNZwErKr5aVFWdKrPxDZ/n78P0WDiS+A7If52bWQUrtRad+mh4A896PgDo0k4s
         fuHfpr0+PJbzw0j9GpihQSv0/qaQzrzSJomXD2lqvqkaBIR4bJ3mqhdgyJHyCvRoMp8G
         8cCUVoyvFbgH2crdy7uas6jpGbUZmW5i2BIMYjemRoj0dEogrLfXdQd1FMexpH3RuVvL
         HJnhU7wBOm2gvaWfCFUlWJKWSJZlaZyuMs0wbGIcmFvRlFxruz3GNWiInXHWj2jpjlBl
         zl1w==
X-Gm-Message-State: APjAAAXp8p2HP9c3uVFknUjfWXofqAXXs/Y153VxTJzeaRB9IX+cAWYd
        M7Yvy7xisvvYJEuRgo+lO/iW1Az7tDIf5B3lq1o=
X-Google-Smtp-Source: APXvYqyZ5ialozV/AwIpyq3D3adAdiFb+p7RGS/GATK40hf5ZoS+Wil57fMgbS0LGhIC4bafFdpLC8pPBRLkD5WPnB0=
X-Received: by 2002:a02:ce35:: with SMTP id v21mr46533772jar.108.1564727034766;
 Thu, 01 Aug 2019 23:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com> <20190801081133.13200-2-danieltimlee@gmail.com>
In-Reply-To: <20190801081133.13200-2-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 1 Aug 2019 23:23:18 -0700
Message-ID: <CAH3MdRXkr5oD=yTr8qevFMLBuLyv1v-E7BLme8n2FA8+uPe6sg@mail.gmail.com>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP on interface
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
> By this commit, using `bpftool net attach`, user can attach XDP prog on
> interface. New type of enum 'net_attach_type' has been made, as stated at
> cover-letter, the meaning of 'attach' is, prog will be attached on interface.
>
> BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>   - command 'load' changed to 'attach' for the consistency
>   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'
>
>  tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 106 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 67e99c56bc88..f3b57660b303 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -55,6 +55,35 @@ struct bpf_attach_info {
>         __u32 flow_dissector_id;
>  };
>
> +enum net_attach_type {
> +       NET_ATTACH_TYPE_XDP,
> +       NET_ATTACH_TYPE_XDP_GENERIC,
> +       NET_ATTACH_TYPE_XDP_DRIVER,
> +       NET_ATTACH_TYPE_XDP_OFFLOAD,
> +       __MAX_NET_ATTACH_TYPE
> +};
> +
> +static const char * const attach_type_strings[] = {
> +       [NET_ATTACH_TYPE_XDP] = "xdp",
> +       [NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
> +       [NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
> +       [NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
> +       [__MAX_NET_ATTACH_TYPE] = NULL,
> +};
> +
> +static enum net_attach_type parse_attach_type(const char *str)
> +{
> +       enum net_attach_type type;
> +
> +       for (type = 0; type < __MAX_NET_ATTACH_TYPE; type++) {
> +               if (attach_type_strings[type] &&
> +                  is_prefix(str, attach_type_strings[type]))
> +                       return type;
> +       }
> +
> +       return __MAX_NET_ATTACH_TYPE;
> +}
> +
>  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
>  {
>         struct bpf_netdev_t *netinfo = cookie;
> @@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
>         return 0;
>  }
>
> +static int parse_attach_args(int argc, char **argv, int *progfd,
> +                            enum net_attach_type *attach_type, int *ifindex)
> +{
> +       if (!REQ_ARGS(3))
> +               return -EINVAL;
> +
> +       *progfd = prog_parse_fd(&argc, &argv);
> +       if (*progfd < 0)
> +               return *progfd;
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

Do you want to use the full function name "invalid if_nametoindex" here?

> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> +                               int *ifindex)

You can just use plain int as the argument type here.

> +{
> +       __u32 flags;
> +       int err;
> +
> +       flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +       if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> +               flags |= XDP_FLAGS_SKB_MODE;
> +       if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> +               flags |= XDP_FLAGS_DRV_MODE;
> +       if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> +               flags |= XDP_FLAGS_HW_MODE;
> +
> +       err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> +
> +       return err;

Just do "return bpf_set_link_xdp_fd(...)" and you do not need variable err.

> +}
> +
> +static int do_attach(int argc, char **argv)
> +{
> +       enum net_attach_type attach_type;
> +       int err, progfd, ifindex;
> +
> +       err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> +       if (err)
> +               return err;
> +
> +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> +               err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
> +
> +       if (err < 0) {
> +               p_err("link set %s failed", attach_type_strings[attach_type]);
> +               return -1;
> +       }

The above "if (err < 0)" can be true only under the above "if (is_prefix(..))"
conditions. But compiler may optimize this. So I think current form is okay.
But could you change the return value to "return err" instead of "return -1"?

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
> @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
>
>         fprintf(stderr,
>                 "Usage: %s %s { show | list } [dev <devname>]\n"
> +               "       %s %s attach PROG LOAD_TYPE <devname>\n"
>                 "       %s %s help\n"
> +               "\n"
> +               "       " HELP_SPEC_PROGRAM "\n"
> +               "       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
>                 "Note: Only xdp and tc attachments are supported now.\n"
>                 "      For progs attached to cgroups, use \"bpftool cgroup\"\n"
>                 "      to dump program attachments. For program types\n"
>                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
>                 "      consult iproute2.\n",
> -               bin_name, argv[-2], bin_name, argv[-2]);
> +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
>
>         return 0;
>  }
> @@ -319,6 +423,7 @@ static int do_help(int argc, char **argv)
>  static const struct cmd cmds[] = {
>         { "show",       do_show },
>         { "list",       do_show },
> +       { "attach",     do_attach },
>         { "help",       do_help },
>         { 0 }
>  };
> --
> 2.20.1
>
