Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06002656EEB
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiL0UgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 15:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiL0UeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 15:34:03 -0500
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AA465DB;
        Tue, 27 Dec 2022 12:33:48 -0800 (PST)
Received: by mail-vs1-f46.google.com with SMTP id k4so9572932vsc.4;
        Tue, 27 Dec 2022 12:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPzbbgu9k+12axNhvSl4/wTiUsXQwmOMXV5hrHa+tmc=;
        b=vhjZ9ZffOV8YqoKwWuHeBgGEBJABvlZSvNg+12Y2uFUEARAtjIWRQh9WtXofGM+wWa
         4SaJsil0sEoiVSxMU6kx01KmAXimWwM3/S2ZEQbA7yE4bvS/cArh+d3WzoU+uy5qm1wX
         sWVAHICjFc2UIO3RQndLuY5T1ujGlbHvqHKGZ3YqdCTg6tdlbbvgSNOnAuT0bjhcXk2l
         nEUjnc81NwfNEZVyJGoamOKA41B/FpCzC4ZhpkUG54KdXmxgRpRDApBGkdt42fcwphOR
         2HU90O6EIc7/omfsL17gqZeqP5j7cQSTbFgSWtZ7P5MvxLcKGi1GEnfDPr40GNEry4kj
         EI0A==
X-Gm-Message-State: AFqh2krFRAeZGLx7QlCbg84tdmdArM3OVtjDb8lfx5qaNhvojYBZTzNx
        v5NgrYGRj2ynE9X0tXU/7QA=
X-Google-Smtp-Source: AMrXdXtSdeUM8rPjnrF/YFyecb7nI6FgtSLrjMGJ0+kBLUb4ndndRYgWqw1HDIynYZTSX1aSOXzihQ==
X-Received: by 2002:a05:6102:830:b0:3c8:2851:c2df with SMTP id k16-20020a056102083000b003c82851c2dfmr2364703vsb.16.1672173226955;
        Tue, 27 Dec 2022 12:33:46 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:13c8])
        by smtp.gmail.com with ESMTPSA id o5-20020a05620a2a0500b006fc2f74ad12sm10111442qkp.92.2022.12.27.12.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 12:33:46 -0800 (PST)
Date:   Tue, 27 Dec 2022 14:33:50 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
Message-ID: <Y6tWrtltKfAlo0rT@maniforge.lan>
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-8-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220222043.3348718-8-sdf@google.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 02:20:33PM -0800, Stanislav Fomichev wrote:

Hey Stanislav,

[...]

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index aad12a179e54..b41d18490595 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
>  struct udp_tunnel_nic;
>  struct bpf_prog;
>  struct xdp_buff;
> +struct xdp_md;
>  
>  void synchronize_net(void);
>  void netdev_set_default_ethtool_ops(struct net_device *dev,
> @@ -1618,6 +1619,11 @@ struct net_device_ops {
>  						  bool cycles);
>  };
>  
> +struct xdp_metadata_ops {
> +	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
> +	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
> +};
> +
>  /**
>   * enum netdev_priv_flags - &struct net_device priv_flags
>   *
> @@ -2050,6 +2056,7 @@ struct net_device {
>  	unsigned int		flags;
>  	unsigned long long	priv_flags;
>  	const struct net_device_ops *netdev_ops;
> +	const struct xdp_metadata_ops *xdp_metadata_ops;

You need to document this field above the struct, or the docs build will
complain:

  SPHINX  htmldocs -->
  <redacted>
  make[2]: Nothing to be done for 'html'.
  Using sphinx_rtd_theme theme
  source directory: networking
  ./include/linux/netdevice.h:2371: warning: Function parameter or
  member 'xdp_metadata_ops' not described in 'net_device'

>  	int			ifindex;
>  	unsigned short		gflags;
>  	unsigned short		hard_header_len;

Thanks,
David
