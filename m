Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3E67F24F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjA0XjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjA0XjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:39:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4402237B57;
        Fri, 27 Jan 2023 15:39:07 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so17762208ejc.4;
        Fri, 27 Jan 2023 15:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OS57Cl1v1ND4yDvQPK9DGvNY074irrM+XZQ4x1tyrxo=;
        b=lRU2TkbyI3bAuFYzYtDuQtseBVDPNqjLBq6bMmSGyNdOdsBLmiLwa2nst7N2MR0RjD
         azJY8SpV2g3zLKVc6gfNmaVd00W4rqVJaczLYnrYL3MFy/WUH5QZwX339HqUY5muok4V
         6ojLt+xHEP2UJI8eM0HJsXZVt5LcIMNMc2pYQhvOXajwW1Ah/PV99LBp4NCGOhMrmsKc
         IWyEdM8wNw6FgPBQK7YzeVw/klCYW+IZfBp3mcha5SroP4pvnqLMvKUGJKa8TTMYlmdm
         NYuIulojrRyQ12/3c3WCynoGyiS0xJEDgw7Gn4MSLc7zpB1v2LiDyKezKcBUYms5G6aU
         +hKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OS57Cl1v1ND4yDvQPK9DGvNY074irrM+XZQ4x1tyrxo=;
        b=LstS4X8HbXz1kiHYDBRh6bAgxpo5wFd2WKexbsnKot4S9AkmdQ8ZtNysP/2CEEXbG0
         lIvWNGje5HOY49Kefcez9ouUMKsIiisUEuktpEGRRDlHRrfnRiU1jSV/p/SMrGxuEnBt
         ooJyjLjkX1jqrFD0/j+RfxUJ4AzXm+35zu3Zy0vf3CxYIY8ifM/GHb3RQN6TG1Oyyzz4
         ZrC4Qyd8FRNQxab4B9WQGHRuolm6wo8vDb2oD3ETrpZ6FRQtNPeQe0jqOhhQYLa7Zxlc
         prRucx2BDqEys57gnrl1VKioyApOCrypTJHilHShULe8o6i/yyyP0uMe5Mq14L30uRyj
         QyWg==
X-Gm-Message-State: AO0yUKVY85WFSPDnV+Uqju4WKodTXNWtKgGmFdgDqzyAz1pfCRsAYgGp
        zgOKBhlhtrP8C8KfuH1WAoTxP7adqVhhdLvzMNs=
X-Google-Smtp-Source: AK7set+iEOmdxvTUlQMzh35XvojPOvTvkl59ca5GGONndB4m9IrJ3m0aYFDTDyHV0cQzXOSCTF41x8omq/wDY1VaSqo=
X-Received: by 2002:a17:906:ce23:b0:882:665:5135 with SMTP id
 sd3-20020a170906ce2300b0088206655135mr94283ejb.265.1674862745558; Fri, 27 Jan
 2023 15:39:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674737592.git.lorenzo@kernel.org> <a7e6e8da5b2ba24f44f0d5b44a234e2bf90220fd.1674737592.git.lorenzo@kernel.org>
In-Reply-To: <a7e6e8da5b2ba24f44f0d5b44a234e2bf90220fd.1674737592.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Jan 2023 15:38:53 -0800
Message-ID: <CAEf4BzYjt3J5_ESMKjRFRh6ROg-CN=QazAZpKd9wnaSxjjKbAg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/8] libbpf: add API to get XDP/XSK supported features
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 4:59 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Extend bpf_xdp_query routine in order to get XDP/XSK supported features
> of netdev over route netlink interface.
> Extend libbpf netlink implementation in order to support netlink_generic
> protocol.
>
> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/libbpf.h  |  3 +-
>  tools/lib/bpf/netlink.c | 99 +++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/nlattr.h  | 12 +++++
>  3 files changed, 113 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 898db26e42e9..29cb7040fa77 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -982,9 +982,10 @@ struct bpf_xdp_query_opts {
>         __u32 hw_prog_id;       /* output */
>         __u32 skb_prog_id;      /* output */
>         __u8 attach_mode;       /* output */
> +       __u64 fflags;           /* output */
>         size_t :0;
>  };
> -#define bpf_xdp_query_opts__last_field attach_mode
> +#define bpf_xdp_query_opts__last_field fflags

is "fflags" an obvious name in this context? I'd expect
"feature_flags", especially that there are already "flags". Is saving
a few characters worth the confusion?


>
>  LIBBPF_API int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags,
>                               const struct bpf_xdp_attach_opts *opts);
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index d2468a04a6c3..674e4d61e67e 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -9,6 +9,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/pkt_cls.h>
>  #include <linux/rtnetlink.h>
> +#include <linux/netdev.h>
>  #include <sys/socket.h>
>  #include <errno.h>
>  #include <time.h>
> @@ -39,6 +40,12 @@ struct xdp_id_md {
>         int ifindex;
>         __u32 flags;
>         struct xdp_link_info info;
> +       __u64 fflags;
> +};
> +
> +struct xdp_features_md {
> +       int ifindex;
> +       __u64 flags;
>  };
>
>  static int libbpf_netlink_open(__u32 *nl_pid, int proto)

[...]

>  int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>  {
>         struct libbpf_nla_req req = {
> @@ -393,6 +460,38 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>         OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
>         OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
>
> +       if (OPTS_HAS(opts, fflags)) {

maybe invert condition, return early, reduce nesting of the following code?

> +               struct xdp_features_md md = {
> +                       .ifindex = ifindex,
> +               };
> +               __u16 id;
> +
> +               err = libbpf_netlink_resolve_genl_family_id("netdev",
> +                                                           sizeof("netdev"),
> +                                                           &id);

nit: if it fits under 100 characters, let's leave it on a single line

> +               if (err < 0)
> +                       return libbpf_err(err);
> +
> +               memset(&req, 0, sizeof(req));
> +               req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
> +               req.nh.nlmsg_flags = NLM_F_REQUEST;
> +               req.nh.nlmsg_type = id;
> +               req.gnl.cmd = NETDEV_CMD_DEV_GET;
> +               req.gnl.version = 2;
> +
> +               err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex,
> +                                sizeof(ifindex));
> +               if (err < 0)
> +                       return err;
> +
> +               err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> +                                              parse_xdp_features, NULL, &md);
> +               if (err)
> +                       return libbpf_err(err);
> +
> +               opts->fflags = md.flags;
> +       }
> +
>         return 0;
>  }
>

[...]
