Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF723B0644
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFVN53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhFVN52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:57:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC75C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:55:11 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h23so265237pjv.2
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gh2xqpJa2scb+NGucdvnVsDKUGPBzXNYE9N+f4ajjQE=;
        b=FRjsQNyroK7mu9xxYrawlWx5IcFFI7qMNFHLL3HgAkHbdCK1mj07wC8wrr8cIalkX2
         uy077V3j0UJwlFSZrXkdo/TnCEEkF925m7bcMuFsJJ7uDFILl2Stmy5+7DNAm/SeG8Un
         +8rzg91Q0mgKBi1aY8VFbnhNNGd+LP92iNoHQZcOMAB7JqomGd7AKRT7JIj3T/2gtzkw
         8HPj7FJgrlqUBY1dimVrbAYsYZoxwsInHM5WuUNrsW/dCmU8S0MfwH5OHupx9GZFNwU6
         7hxtewceisIfvf7ME7bd05FndHV3/Ow/LqcQre8tqpdCLazo/1xSZKt50prokomdOHWm
         5WGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gh2xqpJa2scb+NGucdvnVsDKUGPBzXNYE9N+f4ajjQE=;
        b=KRqz9Kwib4we34HX0trKN9lOtqyE6MnTgCIpP+y/NEIkKb3Kc/kgF3+xbR5h1dwCZe
         vhpsQ/DEk5jD/oX30jPcpNl+ZWK50QqID5pvFKofAQ9ipnN1LKv6gaC9iHx2HhTChlmw
         yULCVu9h0WbvU6iycAzqy2q6OR4JXQKDmUL7G1rpM1zmK2avaLBHi+DwTmaIEdLRcUoU
         TiO5OR35XUCBJg23QuiF3KpMZopJo0gH2R5369Yrocc+VdjVzxFRMUd7wJAbn7M3qjL/
         hzpE407uiCla9FNWKnAM0fKFNaTG+HX7IumOqvCCiuCaicwi+ru/EaTQvRkyDNUY9JPk
         ZY9Q==
X-Gm-Message-State: AOAM530AvHH9kH0d1K/hJ9T38w6SM7R/PU6dh3/PQpp3HclHgKKjJoDA
        p+BsRzCnzrh7ox7W8NNEAMgjLzBbvPgoi37CsWHfbw==
X-Google-Smtp-Source: ABdhPJzBTGdLH1cZ2Dusiw+5HjZgSyJq2npsIe72p2JLVtooA8qGSgt3Bg2fe4uQeVik6SgLbHWXZDveOI8xQdlomPY=
X-Received: by 2002:a17:90b:1bc4:: with SMTP id oa4mr4124756pjb.18.1624370111320;
 Tue, 22 Jun 2021 06:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com> <20210621225100.21005-9-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-9-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 16:04:04 +0200
Message-ID: <CAMZdPi-6Fpft80Vis-NR4grfcyfdH9DTs9BHfE-J+-6_c+2dJw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/10] wwan: core: support default netdev creation
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Most, if not each WWAN device driver will create a netdev for the
> default data channel. Therefore, add an option for the WWAN netdev ops
> registration function to create a default netdev for the WWAN device.
>
> A WWAN device driver should pass a default data channel link id to the
> ops registering function to request the creation of a default netdev, or
> a special value WWAN_NO_DEFAULT_LINK to inform the WWAN core that the
> default netdev should not be created.
>
> For now, only wwan_hwsim utilize the default link creation option. Other
> drivers will be reworked next.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> CC: M Chetan Kumar <m.chetan.kumar@intel.com>
> CC: Intel Corporation <linuxwwan@intel.com>
> ---
>
> v1 -> v2:
>  * fix a comment style '/**' -> '/*' to avoid confusion with kernel-doc
>
>  drivers/net/mhi/net.c                 |  3 +-
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c |  3 +-
>  drivers/net/wwan/wwan_core.c          | 75 ++++++++++++++++++++++++++-
>  drivers/net/wwan/wwan_hwsim.c         |  2 +-
>  include/linux/wwan.h                  |  8 ++-
>  5 files changed, 86 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> index ffd1c01b3f35..f36ca5c0dfe9 100644
> --- a/drivers/net/mhi/net.c
> +++ b/drivers/net/mhi/net.c
> @@ -397,7 +397,8 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>         struct net_device *ndev;
>         int err;
>
> -       err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev);
> +       err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
> +                               WWAN_NO_DEFAULT_LINK);
>         if (err)
>                 return err;
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index bee9b278223d..adb2bd40a404 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -317,7 +317,8 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
>         ipc_wwan->dev = dev;
>         ipc_wwan->ipc_imem = ipc_imem;
>
> -       if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan)) {
> +       if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
> +                             WWAN_NO_DEFAULT_LINK)) {
>                 kfree(ipc_wwan);
>                 return NULL;
>         }
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index b634a0ba1196..ef6ec641d877 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -903,17 +903,81 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
>         .policy = wwan_rtnl_policy,
>  };
>
> +static void wwan_create_default_link(struct wwan_device *wwandev,
> +                                    u32 def_link_id)
> +{
> +       struct nlattr *tb[IFLA_MAX + 1], *linkinfo[IFLA_INFO_MAX + 1];
> +       struct nlattr *data[IFLA_WWAN_MAX + 1];
> +       struct net_device *dev;
> +       struct nlmsghdr *nlh;
> +       struct sk_buff *msg;
> +
> +       /* Forge attributes required to create a WWAN netdev. We first
> +        * build a netlink message and then parse it. This looks
> +        * odd, but such approach is less error prone.
> +        */
> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +       if (WARN_ON(!msg))
> +               return;
> +       nlh = nlmsg_put(msg, 0, 0, RTM_NEWLINK, 0, 0);
> +       if (WARN_ON(!nlh))
> +               goto free_attrs;
> +
> +       if (nla_put_string(msg, IFLA_PARENT_DEV_NAME, dev_name(&wwandev->dev)))
> +               goto free_attrs;
> +       tb[IFLA_LINKINFO] = nla_nest_start(msg, IFLA_LINKINFO);
> +       if (!tb[IFLA_LINKINFO])
> +               goto free_attrs;
> +       linkinfo[IFLA_INFO_DATA] = nla_nest_start(msg, IFLA_INFO_DATA);
> +       if (!linkinfo[IFLA_INFO_DATA])
> +               goto free_attrs;
> +       if (nla_put_u32(msg, IFLA_WWAN_LINK_ID, def_link_id))
> +               goto free_attrs;
> +       nla_nest_end(msg, linkinfo[IFLA_INFO_DATA]);
> +       nla_nest_end(msg, tb[IFLA_LINKINFO]);
> +
> +       nlmsg_end(msg, nlh);
> +
> +       /* The next three parsing calls can not fail */
> +       nlmsg_parse_deprecated(nlh, 0, tb, IFLA_MAX, NULL, NULL);
> +       nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX, tb[IFLA_LINKINFO],
> +                                   NULL, NULL);
> +       nla_parse_nested_deprecated(data, IFLA_WWAN_MAX,
> +                                   linkinfo[IFLA_INFO_DATA], NULL, NULL);
> +
> +       rtnl_lock();
> +
> +       dev = rtnl_create_link(&init_net, "wwan%d", NET_NAME_ENUM,
> +                              &wwan_rtnl_link_ops, tb, NULL);

That can be a bit confusing since the same naming convention as for
the WWAN devices is used, so you can end with something like a wwan0
netdev being a link of wwan1 dev. Maybe something like ('%s.%d',
dev_name(&wwandev->dev), link_id) to have e.g. wwan1.0 for link 0 of
the wwan1 device. Or alternatively, the specific wwan driver to
specify the default name to use.

Regards,
Loic
