Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67CF98950E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 02:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHLA1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 20:27:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36340 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLA1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 20:27:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id k18so20942333otr.3
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 17:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eo314xyfOcMRmSITiERW1LwurtLX647OgYVO2/a7s1A=;
        b=fAZGdgoXBuBcrXIf6J9ixhfSviIDW3CggcGXZ29uVkTEEDjLdoADAGgOjyZpunW/xL
         juvimG0kN9US6DK+qY5JLX2s1mJpTZeUhkOQpIq2DRBl/ffQPc+A8vAJ6djpt0t23957
         FCDr1dT4He/rR3DDTE7qHn01PEQFEjfu3g/kTprTgFbmlYGFZKi+uSbWXNSt+zNawRdK
         Uh8tY9x5baEsTfvq8wQEv6sRbPJmUMz6sSwmXnrR16WgReQ7R2B95x7JOkI6AatiLtma
         RyG7ZE7V+SSRxo1ZMST34sIuc4bEUdWQa7v00jfg0mW7DK2vm2AlVZBPt7BkGlnzNAY+
         KrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eo314xyfOcMRmSITiERW1LwurtLX647OgYVO2/a7s1A=;
        b=pr77QYsYvXYCh8gLdHd6zQCn+7ER1+jh0FoejEG74hW9Tsf1EpiUpAi9XawKR0ZvsI
         +ay+2A/g6EK6suCvsk6Fy5W1d+g40p9GHMVdCJ+40tzw7YzFFi0/WbyghOlcbCf9QiC+
         UIN84CSMxoKNCippZxxKaTkd7B5xFutGq6F8U6c9R5hTZRzBtOrnO+3Wj3+sefv28Lhg
         YJQdBMw4A1ojjMEOSUNHIwRORtIWgJHmi1+OeBtoqqGux2przcg7ngz92cgBM4WB1t9R
         m+sq7ace5gRFEwis/T3+yAw1RPpadPcDvlhp7uQcQn3sE8k1fcdl/wrgG53ndE4/0ovd
         LyRQ==
X-Gm-Message-State: APjAAAWI2Ay7kjRyvxBvWfLDiFbTJnRa3j5kqnxsjCq2d78HbU8VB3kA
        1q4+TNuBH1kXlNG3JsOpgRfBbCC79QpXmdAjijI=
X-Google-Smtp-Source: APXvYqyO6SBUDd4bLtblnNZZIi80ScmHMgmeuxdZmXsOR6ywGVzgAfd47B5qNx5joAFWg3jB/r6rI+rI4+3juABEXlQ=
X-Received: by 2002:a02:1981:: with SMTP id b123mr8372728jab.72.1565569627662;
 Sun, 11 Aug 2019 17:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190809133248.19788-1-danieltimlee@gmail.com> <20190809133248.19788-2-danieltimlee@gmail.com>
In-Reply-To: <20190809133248.19788-2-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Sun, 11 Aug 2019 17:26:31 -0700
Message-ID: <CAH3MdRVJ5Z8FVF8XW8Ha-MwRAnO2mbmMDFb_s3cPswqq7MfsMQ@mail.gmail.com>
Subject: Re: [v4,1/4] tools: bpftool: add net attach command to attach XDP on interface
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 6:35 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> By this commit, using `bpftool net attach`, user can attach XDP prog on
> interface. New type of enum 'net_attach_type' has been made, as stated at
> cover-letter, the meaning of 'attach' is, prog will be attached on interface.
>
> With 'overwrite' option at argument, attached XDP program could be replaced.
> Added new helper 'net_parse_dev' to parse the network device at argument.
>
> BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  tools/bpf/bpftool/net.c | 136 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 129 insertions(+), 7 deletions(-)
>
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 67e99c56bc88..74cc346c36cd 100644
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
> +};
> +
> +static const char * const attach_type_strings[] = {
> +       [NET_ATTACH_TYPE_XDP]           = "xdp",
> +       [NET_ATTACH_TYPE_XDP_GENERIC]   = "xdpgeneric",
> +       [NET_ATTACH_TYPE_XDP_DRIVER]    = "xdpdrv",
> +       [NET_ATTACH_TYPE_XDP_OFFLOAD]   = "xdpoffload",
> +};
> +
> +const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
> +
> +static enum net_attach_type parse_attach_type(const char *str)
> +{
> +       enum net_attach_type type;
> +
> +       for (type = 0; type < net_attach_type_size; type++) {
> +               if (attach_type_strings[type] &&
> +                   is_prefix(str, attach_type_strings[type]))
> +                       return type;
> +       }
> +
> +       return net_attach_type_size;
> +}
> +
>  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
>  {
>         struct bpf_netdev_t *netinfo = cookie;
> @@ -223,6 +252,97 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
>         return 0;
>  }
>
> +static int net_parse_dev(int *argc, char ***argv)
> +{
> +       int ifindex;
> +
> +       if (is_prefix(**argv, "dev")) {
> +               NEXT_ARGP();
> +
> +               ifindex = if_nametoindex(**argv);
> +               if (!ifindex)
> +                       p_err("invalid devname %s", **argv);
> +
> +               NEXT_ARGP();
> +       } else {
> +               p_err("expected 'dev', got: '%s'?", **argv);
> +               return -1;
> +       }
> +
> +       return ifindex;
> +}
> +
> +static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
> +                               int ifindex, bool overwrite)
> +{
> +       __u32 flags = 0;
> +
> +       if (!overwrite)
> +               flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +       if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> +               flags |= XDP_FLAGS_SKB_MODE;
> +       if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> +               flags |= XDP_FLAGS_DRV_MODE;
> +       if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> +               flags |= XDP_FLAGS_HW_MODE;
> +
> +       return bpf_set_link_xdp_fd(ifindex, progfd, flags);
> +}
> +
> +static int do_attach(int argc, char **argv)
> +{
> +       enum net_attach_type attach_type;
> +       int progfd, ifindex, err = 0;
> +       bool overwrite = false;
> +
> +       /* parse attach args */
> +       if (!REQ_ARGS(5))
> +               return -EINVAL;
> +
> +       attach_type = parse_attach_type(*argv);
> +       if (attach_type == net_attach_type_size) {
> +               p_err("invalid net attach/detach type: %s", *argv);
> +               return -EINVAL;
> +       }
> +       NEXT_ARG();
> +
> +       progfd = prog_parse_fd(&argc, &argv);
> +       if (progfd < 0)
> +               return -EINVAL;
> +
> +       ifindex = net_parse_dev(&argc, &argv);
> +       if (ifindex < 1) {
> +               close(progfd);
> +               return -EINVAL;
> +       }
> +
> +       if (argc) {
> +               if (is_prefix(*argv, "overwrite")) {
> +                       overwrite = true;
> +               } else {
> +                       p_err("expected 'overwrite', got: '%s'?", *argv);
> +                       close(progfd);
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       /* attach xdp prog */
> +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> +               err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> +                                          overwrite);
> +
> +       if (err < 0) {
> +               p_err("interface %s attach failed: %s",
> +                     attach_type_strings[attach_type], strerror(errno));
> +               return err;
> +       }

I tried the below example,

-bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example
dev v1
-bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
Kernel error message: XDP program already attached
Error: interface xdp attach failed: Success
-bash-4.4$

It printed out "Success" as errno here is 0.
The errno is encoded in variable err. Function bpf_set_link_xdp_fd()
uses netlink interface to do setting. The syscall may be find (errno = 0)
but the netlink msg may contain error code, which is returned with err.

So the above strerror(errno) should be strerror(-err).
libbpf API libbpf_strerror_r() accepts positive or negative err code which
you could use as well here.

With this issue fixed. You can add:
Acked-by: Yonghong Song <yhs@fb.com>

> +
> +       if (json_output)
> +               jsonw_null(json_wtr);
> +
> +       return 0;
> +}
> +
[...]
