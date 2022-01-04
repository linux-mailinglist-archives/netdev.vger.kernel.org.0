Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA24484A51
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiADWEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiADWEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 17:04:02 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE1EC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 14:04:02 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso49015605otf.0
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 14:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDOuWR/josy3iovqtnSrNbs4zamus5HY4QfvxNCE70k=;
        b=hMn4HHmV4EEVtfQjKlttAzExs6YdQ5L1rf02ZyDmkfN2v7PXCXgcaCrISqCiMbGUms
         A6/1fBSRYYSUyichNz3LsoAL/lr+wy/zqNRQPk8ZivOibNsp0Z3WPr1H2t8w/ula1gri
         bOFRKKD86H4ohG+1tK9Wfy2ST7ruqZRgIwKiO+ANwFDJuDK52uwd1oCqU6IaDOkmbcfp
         oEV+YbwVxTG73dK5N3d8BCAaVzBYenyKd3D8KAlCli+5MQQJe6XcgSnEjMglVVUYZlRC
         Pw6aByQRS0sC4c50hozga2XwZItcehBxyfXELsGKI7manuqyGANFtHPb52hn19n0yfoJ
         CriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDOuWR/josy3iovqtnSrNbs4zamus5HY4QfvxNCE70k=;
        b=sUWMm95JHg8G8a/2TFPefbmVQD8Sjf4ldWZbouoajb0dmfUfMsV57dHt7V3suq6NFu
         ppNH4TtEwU7dwDdzkfApMvRJgQdY3EOZAttIGdfo8t9cjJOOccniAEi3CvmzsDqtszKp
         3M6T5AY/9aOfWsYQhwLsfsSs1GfRNJe22gsS/jQgUTiZ+05wWDH/smiBDzXhSF5qZu7A
         EwH+lcQkW/A7cBrXc6B6Cljwsc4EQh/qzN7XICTUiCl6yPjTV7GHw2I/Lbkav2BIuX6+
         x+SI9NOpNjTbDWrVrdxUVxzfXPuKM2V2jlAxcJqft9ZQtbQBy/I3VhMN/0AG8AFMPoE2
         FTcQ==
X-Gm-Message-State: AOAM533DqWFNj9Hqpfmj96J1aQ74sFnXQFrKI6NZ1KrtoJxU00skUx/4
        wEXmEFerA9dCzLfZ35fV/lmZSkLLtNFMPrpA28uoDQ2RUQ==
X-Google-Smtp-Source: ABdhPJyITpWC2hCF+2afmd6UP7BvcuOfLHH5VxxqN0nOrigZ8qYnPQmH4nq6xkWhIpu4WNilAFyeRcbtUrIhGCYu34c=
X-Received: by 2002:a05:6830:22ef:: with SMTP id t15mr35511354otc.69.1641333841265;
 Tue, 04 Jan 2022 14:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com> <20220104171413.2293847-9-vladimir.oltean@nxp.com>
In-Reply-To: <20220104171413.2293847-9-vladimir.oltean@nxp.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 4 Jan 2022 16:03:56 -0600
Message-ID: <CAFSKS=N-31qNir6xmj1u2ZR2qjERiqg5qyEtsRebc0ihjr5FRg@mail.gmail.com>
Subject: Re: [PATCH net-next 08/15] net: dsa: remove cross-chip support for HSR
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 11:14 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> The cross-chip notifiers for HSR are bypass operations, meaning that
> even though all switches in a tree are notified, only the switch
> specified in the info structure is targeted.
>
> We can eliminate the unnecessary complexity by deleting the cross-chip
> notifier logic and calling the ds->ops straight from port.c.
>
> Cc: George McCollister <george.mccollister@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa_priv.h |  2 --
>  net/dsa/port.c     | 20 ++++++--------------
>  net/dsa/switch.c   | 24 ------------------------
>  3 files changed, 6 insertions(+), 40 deletions(-)
>
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 54c23479b9ba..b3386d408fc6 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -25,8 +25,6 @@ enum {
>         DSA_NOTIFIER_FDB_DEL,
>         DSA_NOTIFIER_HOST_FDB_ADD,
>         DSA_NOTIFIER_HOST_FDB_DEL,
> -       DSA_NOTIFIER_HSR_JOIN,
> -       DSA_NOTIFIER_HSR_LEAVE,
>         DSA_NOTIFIER_LAG_CHANGE,
>         DSA_NOTIFIER_LAG_JOIN,
>         DSA_NOTIFIER_LAG_LEAVE,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 5c72f890c6a2..9e7c421c47b9 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1317,16 +1317,12 @@ EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
>
>  int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
>  {
> -       struct dsa_notifier_hsr_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .hsr = hsr,
> -       };
> +       struct dsa_switch *ds = dp->ds;
>         int err;
>
>         dp->hsr_dev = hsr;
>
> -       err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_JOIN, &info);
> +       err = ds->ops->port_hsr_join(ds, dp->index, hsr);
>         if (err)
>                 dp->hsr_dev = NULL;
>
> @@ -1335,20 +1331,16 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
>
>  void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
>  {
> -       struct dsa_notifier_hsr_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .hsr = hsr,
> -       };
> +       struct dsa_switch *ds = dp->ds;
>         int err;
>
>         dp->hsr_dev = NULL;
>
> -       err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_LEAVE, &info);
> +       err = ds->ops->port_hsr_leave(ds, dp->index, hsr);
>         if (err)
>                 dev_err(dp->ds->dev,
> -                       "port %d failed to notify DSA_NOTIFIER_HSR_LEAVE: %pe\n",
> -                       dp->index, ERR_PTR(err));
> +                       "port %d failed to leave HSR %s: %pe\n",
> +                       dp->index, hsr->name, ERR_PTR(err));
>  }
>
>  int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index a164ec02b4e9..e3c7d2627a61 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -437,24 +437,6 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
>         return dsa_port_do_fdb_del(dp, info->addr, info->vid);
>  }
>
> -static int dsa_switch_hsr_join(struct dsa_switch *ds,
> -                              struct dsa_notifier_hsr_info *info)
> -{
> -       if (ds->index == info->sw_index && ds->ops->port_hsr_join)
> -               return ds->ops->port_hsr_join(ds, info->port, info->hsr);
> -
> -       return -EOPNOTSUPP;
> -}
> -
> -static int dsa_switch_hsr_leave(struct dsa_switch *ds,
> -                               struct dsa_notifier_hsr_info *info)
> -{
> -       if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
> -               return ds->ops->port_hsr_leave(ds, info->port, info->hsr);
> -
> -       return -EOPNOTSUPP;
> -}
> -
>  static int dsa_switch_lag_change(struct dsa_switch *ds,
>                                  struct dsa_notifier_lag_info *info)
>  {
> @@ -729,12 +711,6 @@ static int dsa_switch_event(struct notifier_block *nb,
>         case DSA_NOTIFIER_HOST_FDB_DEL:
>                 err = dsa_switch_host_fdb_del(ds, info);
>                 break;
> -       case DSA_NOTIFIER_HSR_JOIN:
> -               err = dsa_switch_hsr_join(ds, info);
> -               break;
> -       case DSA_NOTIFIER_HSR_LEAVE:
> -               err = dsa_switch_hsr_leave(ds, info);
> -               break;
>         case DSA_NOTIFIER_LAG_CHANGE:
>                 err = dsa_switch_lag_change(ds, info);
>                 break;
> --
> 2.25.1
>

Looks good.

Reviewed-by: George McCollister <george.mccollister@gmail.com>
