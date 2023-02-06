Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1068C9B6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 23:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBFWmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 17:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBFWmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 17:42:44 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CD327D6B;
        Mon,  6 Feb 2023 14:42:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v13so13168312eda.11;
        Mon, 06 Feb 2023 14:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t644cczRQka2x/b5p0VZXCNIcITcyshiEjBHQAnHClY=;
        b=WKv7BijNQKh+zOOhJoiue4NWX7PXRW8jExmIM0aach4T8ONArc8iaqLMVGBECmhiDi
         Jcp8Tyt9jfet3vq3lDnEQwjADVhqXrxOYhcc7CI+TUIpq/hkJSdf/DBrY+aOZbP5FWnF
         0n5IqUDO/6AaoJ5w9tsItrgZmMSkJY1tTt5auZDPzc6NPYqQzOiRG8Rncjbem1OzMSKI
         HU0a2PyHQpp6khPO/CcTP1qEe5u+1NQ2qC3JDFo6qnOJj7lzrRLTpjAgOt3Ip4Co/wpF
         CqG3sY76kjOp8bX70HEbXSH2cU8ofh06afmkQXjCnRBG4MXBpSmPtzF1nkf9aOd8vtK/
         rO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t644cczRQka2x/b5p0VZXCNIcITcyshiEjBHQAnHClY=;
        b=JcL8bmwEMgGI8BPc/MSf5XxOwtQ6w/z9w9l60StUTzLTJMtdQSzENx0t8wzh8/rA76
         HLuKhk+XbyfpP01gQwBKtRhwzsXtidV8tDUUKGvzWXBp4bBrPIq3C2yEjj9tFWI+iIi/
         0Yc5aa3W3dcRDsSY915/07rDWTosQ2NE+54AucmZia8zTtRnEIYwyBOKNK9sft8rLmdV
         6SxVhA831k7bM2vStsfTiziNYlIonjeKbP2jxfb7xTEPE37/fnLvCk4FncrzVmH+5JIL
         hFwVeInkgoGrWQiCgevxHB4UFCCP76nbdiH3fqzh3UNTege6/7GYJ1XSizCPLg00b8tE
         bnaw==
X-Gm-Message-State: AO0yUKUAwcc4xYUZBlCw66IouIjVPl6lb9lG6xZM8csp8FevWdI7wA/T
        vrLdCJkR1w9CCvkzywCqVG1G0yAYaYXMsRWbhz4=
X-Google-Smtp-Source: AK7set+Gk56V+eCjod1Ppqj4lbfZwfjYStQkNcusNNltlahiBgLVkLq2nOS35EReRjYadjf1zLOptLf353isaD3TtEQ=
X-Received: by 2002:a50:9fa8:0:b0:49d:ec5d:28af with SMTP id
 c37-20020a509fa8000000b0049dec5d28afmr33353edf.5.1675723361863; Mon, 06 Feb
 2023 14:42:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675245257.git.lorenzo@kernel.org> <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
In-Reply-To: <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Feb 2023 14:42:29 -0800
Message-ID: <CAEf4BzZS-MSen_1q4eotMe3hdkXUXxpwnfbLqEENzU1ogejxUQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported features
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        hawk@kernel.org, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev, sdf@google.com, gerhard@engleder-embedded.com
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

On Wed, Feb 1, 2023 at 2:25 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
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
>  tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/nlattr.h  | 12 ++++++
>  3 files changed, 110 insertions(+), 1 deletion(-)
>

[...]

> @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>                 .ifinfo.ifi_family = AF_PACKET,
>         };
>         struct xdp_id_md xdp_id = {};
> +       struct xdp_features_md md = {
> +               .ifindex = ifindex,
> +       };
> +       __u16 id;
>         int err;
>
>         if (!OPTS_VALID(opts, bpf_xdp_query_opts))
> @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>         OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
>         OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
>
> +       if (!OPTS_HAS(opts, feature_flags))
> +               return 0;
> +
> +       err = libbpf_netlink_resolve_genl_family_id("netdev", sizeof("netdev"), &id);
> +       if (err < 0)
> +               return libbpf_err(err);
> +
> +       memset(&req, 0, sizeof(req));
> +       req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
> +       req.nh.nlmsg_flags = NLM_F_REQUEST;
> +       req.nh.nlmsg_type = id;
> +       req.gnl.cmd = NETDEV_CMD_DEV_GET;
> +       req.gnl.version = 2;
> +
> +       err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof(ifindex));
> +       if (err < 0)
> +               return err;

just noticed this, we need to use libbpf_err(err) here like in other
error cases to set errno properly. Can you please send a follow up?

> +
> +       err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> +                                      parse_xdp_features, NULL, &md);
> +       if (err)
> +               return libbpf_err(err);
> +
> +       opts->feature_flags = md.flags;
> +
>         return 0;
>  }
>

[...]
