Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71226DAAF7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbjDGJe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbjDGJeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:34:36 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2606C976D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:34:35 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p203so48462030ybb.13
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680860074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDvY2PEzUQHmwqfcjqgL5Ene+Xf0S6GJNxE7UBfLO9I=;
        b=GnKXVZXCdw74DwQVW4N5PH8bIE9XCq66spKW3zLO0ySMOB9NhkvzZNuV5JNwG3/i8u
         914pNLozB49t1Wwt6jvmWCbyAQ/AAl4tY0QuvXGk4wtfan8LjWE4yJ7Bw8kADmvNXKRx
         24aQDdIBrdq1VA0P6ziKzA28C4cKI6XQlixLPA3800Hq0e4uEnsATHK39n3sWLy2sZWD
         SE8MqBaDyidVcfgDj2jghBDtVtBoOgAdoFjk8j8v2vFMt3IILdTxbKYrFsKum0giSX3v
         JXTohe/SVlZtFObtoib4f+W7YJ6NN8MJ4wWd55HjYg4rFRRu5tjC/a3u+hxJ1QhiGZ1U
         NB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680860074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDvY2PEzUQHmwqfcjqgL5Ene+Xf0S6GJNxE7UBfLO9I=;
        b=yNJVvCj0PqCjlGt7BG9B6p65fNdMgWUIGhtANfBsUr/jGA5pVJSs6o0r8CIcS5JbiY
         kxjTpt28Pqwtr+r9f66bHvCVv+9p7LhuFJ8LbAgEDISzXAJzFugZvACaWMIdIfpG849D
         iiePmPryxNB3zhObsUOpUKaz1+VwUP+4fDoHL38TPhn1QAj8vyHwiXwZnJYYe70WzxzP
         irZ9UOPpeKqVRrTZ4Nr7j/ciddE7r3UF9iUmULVjTuqemlcuGix25tsBWkxr3QWR0Fs/
         xABw0STxJTcOqkcgg4LIwtc5rQoLDUO3tz+D0wY602TNLpQPgnJjWVSNwKa/XZRpEgq+
         ltWA==
X-Gm-Message-State: AAQBX9csgrrva8VkKybPZEfwAoKxJpsFiBwoJmS4IOA4V8KxQvVpF+rM
        apnXcPCftto9Yh8kwu0q3G6bQRGwI6G+qhyHZUx44A==
X-Google-Smtp-Source: AKy350a8gtPQ8qPHTwa921+FwiU5nN4y7ar3QpDpDc9OANwgtaOkHHqpv/ys1qxCwRyuJ913wvDuORTBXd/8OzGndZw=
X-Received: by 2002:a25:df41:0:b0:b8c:4ed:8133 with SMTP id
 w62-20020a25df41000000b00b8c04ed8133mr1513442ybg.4.1680860074126; Fri, 07 Apr
 2023 02:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230407061228.1035431-1-liuhangbin@gmail.com>
In-Reply-To: <20230407061228.1035431-1-liuhangbin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 7 Apr 2023 11:34:23 +0200
Message-ID: <CANn89iL_7CYs1kAY8SsUJLFoSZXe1rXAd3HJY-9dziehTfTkaQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] bonding: add software tx timestamping support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, Liang Li <liali@redhat.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 8:12=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> w=
rote:
>
> Currently, bonding only obtain the timestamp (ts) information of
> the active slave, which is available only for modes 1, 5, and 6.
> For other modes, bonding only has software rx timestamping support.
>
> However, some users who use modes such as LACP also want tx timestamp
> support. To address this issue, let's check the ts information of each
> slave. If all slaves support tx timestamping, we can enable tx
> timestamping support for the bond.
>
> Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/net_tstamp.h |  3 +++
>  2 files changed, 40 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
> index 00646aa315c3..994efc777a77 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5686,9 +5686,13 @@ static int bond_ethtool_get_ts_info(struct net_dev=
ice *bond_dev,
>                                     struct ethtool_ts_info *info)
>  {
>         struct bonding *bond =3D netdev_priv(bond_dev);
> +       struct ethtool_ts_info ts_info;
>         const struct ethtool_ops *ops;
>         struct net_device *real_dev;
>         struct phy_device *phydev;
> +       bool soft_support =3D false;
> +       struct list_head *iter;
> +       struct slave *slave;
>         int ret =3D 0;
>
>         rcu_read_lock();
> @@ -5707,10 +5711,41 @@ static int bond_ethtool_get_ts_info(struct net_de=
vice *bond_dev,
>                         ret =3D ops->get_ts_info(real_dev, info);
>                         goto out;
>                 }
> +       } else {
> +               /* Check if all slaves support software rx/tx timestampin=
g */
> +               rcu_read_lock();
> +               bond_for_each_slave_rcu(bond, slave, iter) {
> +                       ret =3D -1;
> +                       dev_hold(slave->dev);

You are holding rcu_read_lock() during the loop, so there is no need
for this dev_hold() / dev_put() dance.

And if this was needed, we kindly ask for new dev_hold()/dev_put()
added in networking code to
instead use netdev_hold / netdev_put(), we have spent enough time
tracking hold/put bugs.

Thanks.


> +                       ops =3D slave->dev->ethtool_ops;
> +                       phydev =3D slave->dev->phydev;
> +
> +                       if (phy_has_tsinfo(phydev))
> +                               ret =3D phy_ts_info(phydev, &ts_info);
> +                       else if (ops->get_ts_info)
> +                               ret =3D ops->get_ts_info(slave->dev, &ts_=
info);
> +
> +                       if (!ret && (ts_info.so_timestamping & SOF_TIMEST=
AMPING_SOFTRXTX) =3D=3D \
> +                                   SOF_TIMESTAMPING_SOFTRXTX) {
> +                               dev_put(slave->dev);
> +                               soft_support =3D true;
> +                               continue;
> +                       }
> +
> +                       soft_support =3D false;
> +                       dev_put(slave->dev);
> +                       break;
> +               }
> +               rcu_read_unlock();
