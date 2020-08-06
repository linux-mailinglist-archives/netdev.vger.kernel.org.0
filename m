Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B723D597
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgHFCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFCuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:50:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8BAC061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 19:50:51 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e16so4524883ilc.12
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 19:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ba5a8RMGW+dH7ZI7DCohfRAlEqw3Gq1l9IgmeX/1T54=;
        b=RsQ7vm+/eS1OWeHqF7FpP0o0QgIUQTBZLL7a27Iqk4sn489tmiSOssWQhKOPa9gReZ
         wIO5eMAZTOtOAqMhOEBomtXc/TxzX3/HAo/nFcWeH951Z7/LFbQYAKderCUHo+rlz8oE
         INENxzqfyaOGFlAtJAmALOklo1fvJ8UcgYW1/ovKd1k5WZyfaexqCSh5E+CVeA2s/3UV
         hjgBKJSxIh6mjwn3Z6dmgjzCmru3evZ/QXoZcdT4lIEU4W631MSrgWk9Y7TNTY0DEXzU
         4ytuh6anAAE+ulZypGH/k5+2nMtxUJhMR+XRTayZkP/gk8qNFcyAuMre2Tus5tYRhID+
         ixrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ba5a8RMGW+dH7ZI7DCohfRAlEqw3Gq1l9IgmeX/1T54=;
        b=t5KJvXSh7L+LQ4HYnu2O0ce2Vdo11EJjmTIi6EraIYIYyq0mAVi2BBX/F1TecWzIDa
         PkX/TBt38MPSJpNzMF5HzaOswfgyERSndBXEZyJp3+fbAr+lU+3PkUmIWua5NnAnQLhG
         YUahwUvEtzs8CgpvQPr2BvufCdLFrjDMl4ztse/zkp/xJaDnFCNiFcdnjdWhN7/nvIXN
         XgR22ORROOMWIWa6AZKDivGHcRQ++XxPLkYXJXv1wrogsU635H5tyDs1PBgk4NpDWyi+
         xbPa4tb6UPSGqhw1hiVfAGLllctJ4JFWK7EZ1pZmlrHZtEsWrIPb5kGNU4Ge+baujgqk
         919w==
X-Gm-Message-State: AOAM532sHH+8+uXJwuQvU3/yUMpphHVn3Uxt8V9JFGnMttx2NWlmKQ20
        4ZcptK/74geW/DjKAlnCqKJfdJ0VY21Tn+mXaSduQA==
X-Google-Smtp-Source: ABdhPJwHK7pIr50Jj5ekKwMoUoJfRm0KJLKA9SDlhqNZQRn8yah4970DwuiNCBv3pS2V4LNICqKcb6geOIcKTAi0rmw=
X-Received: by 2002:a05:6e02:c1:: with SMTP id r1mr7447055ilq.34.1596682249109;
 Wed, 05 Aug 2020 19:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
In-Reply-To: <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Thu, 6 Aug 2020 11:49:56 +0900
Message-ID: <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien.xin@gmai=
l.com>:
>
> This is to add an ip_dev_find like function for ipv6, used to find
> the dev by saddr.
>
> It will be used by TIPC protocol. So also export it.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/addrconf.h |  2 ++
>  net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
>
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index 8418b7d..ba3f6c15 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *addr=
,
>
>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev)=
;
>
> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr =
*addr);
> +

How do we handle link-local addresses?

--yoshfuji

>  struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net,
>                                      const struct in6_addr *addr,
>                                      struct net_device *dev, int strict);
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 840bfdb..857d6f9 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1983,6 +1983,45 @@ int ipv6_chk_prefix(const struct in6_addr *addr, s=
truct net_device *dev)
>  }
>  EXPORT_SYMBOL(ipv6_chk_prefix);
>
> +/**
> + * ipv6_dev_find - find the first device with a given source address.
> + * @net: the net namespace
> + * @addr: the source address
> + *
> + * The caller should be protected by RCU, or RTNL.
> + */
> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr =
*addr)
> +{
> +       unsigned int hash =3D inet6_addr_hash(net, addr);
> +       struct inet6_ifaddr *ifp, *result =3D NULL;
> +       struct net_device *dev =3D NULL;
> +
> +       rcu_read_lock();
> +       hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
> +               if (net_eq(dev_net(ifp->idev->dev), net) &&
> +                   ipv6_addr_equal(&ifp->addr, addr)) {
> +                       result =3D ifp;
> +                       break;
> +               }
> +       }
> +
> +       if (!result) {
> +               struct rt6_info *rt;
> +
> +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> +               if (rt) {
> +                       dev =3D rt->dst.dev;
> +                       ip6_rt_put(rt);
> +               }
> +       } else {
> +               dev =3D result->idev->dev;
> +       }
> +       rcu_read_unlock();
> +
> +       return dev;
> +}
> +EXPORT_SYMBOL(ipv6_dev_find);
> +
>  struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6_a=
ddr *addr,
>                                      struct net_device *dev, int strict)
>  {
> --
> 2.1.0
>
