Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E035425B561
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBUjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBUja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:39:30 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D9C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 13:39:29 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g128so312781iof.11
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 13:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0/DFXVf+DtluyWiKDq5364UTjTXsCmzA+jWBSv8Sa6A=;
        b=cOIXAkXDb0D0p7BSxFEek+45xnqE2Qwej/97K9IxVHCTwNooieOimxuuwtUmgR+OZx
         n+tStnPZPpoJJlyc7GtxmhK8PMogkfklv0PSACa624ztvC85ENPRrBBlL3RvbezGPU2+
         m4vAHz8mzzPZPX1GelLtdA5KBNMBk7TGZVhNvzBAZQ4ezgaAPOdbcE/mcTB9rS2DUxOw
         o9Ru+X481bezFLW/t5mKCCd6qN5VPhnuCKs60v3DjqJbHOiFAhDT37YqKEe3tVp7r48P
         uBf8juzi0zGiLak13X9UrshDsHXAVTzbEFW/QHDQaCTguRqKMiMSqVME3LbzYUy+36nL
         Qd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0/DFXVf+DtluyWiKDq5364UTjTXsCmzA+jWBSv8Sa6A=;
        b=VH6IY0ByZBtXQE+EgrZqnQrZf+fKijFlh2hTpDQsnhxdW02DTJMIpvicv7ESraO2OW
         bnul5fp02TcGTpwveiokGLta4Nw3pDmSr9jfwe7nXMgu8buH7gMq/GHHjOYaSBg6hnlv
         TWV6Ow8Ddw/TjeekldvZ4GOWRFhA1tys91iUjz7tTK92elHju6RRYe+M2LsxfB3+vhvK
         3Ue5IufSDpuR0B/aHPWH8m77nkD0gcOwit3Cl+EB25y0OqcGM+m6Dox9Rn/j7alv8nJD
         BHBFb7xJUSUXa4FmDYao4Ad2JtK/QmhsVvzx7qKhByKGiEsxL5iVwFgqwVpdoxKp73o8
         abDw==
X-Gm-Message-State: AOAM530s4TlNW/k7CIdUXjem+O06+oGF/yC58+sxqdIkckpewaIO//jr
        KcqvJiJHe48ndByNkxkfNWfsXUQqy8lreqtjkjJVNA==
X-Google-Smtp-Source: ABdhPJxbF59dthdiSeyGjV7UANmJc2ZYGlRkswDfGlLFjCUfPNWMLhSf6zKFdPfJlLIuWuXF7nS6F0PDk7fSWZPhlkw=
X-Received: by 2002:a02:a047:: with SMTP id f7mr4930086jah.31.1599079168877;
 Wed, 02 Sep 2020 13:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
 <20200901215149.2685117-6-awogbemila@google.com> <20200901174558.1745ad28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901174558.1745ad28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 2 Sep 2020 13:39:18 -0700
Message-ID: <CAL9ddJff2CKBfzSP8Mx-9PiS6APPMRHB72YAiwER7f4TLNFR+w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  1 Sep 2020 14:51:45 -0700 David Awogbemila wrote:
>
> > @@ -297,6 +317,22 @@ static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
> >       clear_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS, &priv->service_task_flags);
> >  }
> >
> > +static inline bool gve_get_do_report_stats(struct gve_priv *priv)
> > +{
> > +     return test_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS,
> > +                     &priv->service_task_flags);
> > +}
> > +
> > +static inline void gve_set_do_report_stats(struct gve_priv *priv)
> > +{
> > +     set_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
> > +}
> > +
> > +static inline void gve_clear_do_report_stats(struct gve_priv *priv)
> > +{
> > +     clear_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
> > +}
> > +
> >  static inline bool gve_get_admin_queue_ok(struct gve_priv *priv)
> >  {
> >       return test_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
> > @@ -357,6 +393,21 @@ static inline void gve_clear_napi_enabled(struct gve_priv *priv)
> >       clear_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
> >  }
> >
> > +static inline bool gve_get_report_stats(struct gve_priv *priv)
> > +{
> > +     return test_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> > +}
> > +
> > +static inline void gve_set_report_stats(struct gve_priv *priv)
>
> Please remove the unused helpers.
Thanks, I'll fix this.

>
> > +{
> > +     set_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> > +}
> > +
> > +static inline void gve_clear_report_stats(struct gve_priv *priv)
> > +{
> > +     clear_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> > +}
>
> > @@ -353,6 +377,54 @@ static int gve_set_tunable(struct net_device *netdev,
> >       }
> >  }
> >
> > +static u32 gve_get_priv_flags(struct net_device *netdev)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +     u32 i, ret_flags = 0;
> > +
> > +     for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
>
> Please remove this pointless loop.
Thanks, I'll fix this.

>
> > +             if (priv->ethtool_flags & BIT(i))
> > +                     ret_flags |= BIT(i);
> > +     }
> > +     return ret_flags;
> > +}
> > +
> > +static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +     u64 ori_flags, new_flags;
> > +     u32 i;
> > +
> > +     ori_flags = READ_ONCE(priv->ethtool_flags);
> > +     new_flags = ori_flags;
> > +
> > +     for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
>
> Ditto.
Thanks, I'll fix this.

>
> > +             if (flags & BIT(i))
> > +                     new_flags |= BIT(i);
> > +             else
> > +                     new_flags &= ~(BIT(i));
> > +             priv->ethtool_flags = new_flags;
> > +             /* set report-stats */
> > +             if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
> > +                     /* update the stats when user turns report-stats on */
> > +                     if (flags & BIT(i))
> > +                             gve_handle_report_stats(priv);
> > +                     /* zero off gve stats when report-stats turned off */
> > +                     if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
> > +                             int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> > +                                     priv->tx_cfg.num_queues;
> > +                             int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> > +                                     priv->rx_cfg.num_queues;
>
> new line here
Thanks, I'll fix this.

>
> > +                             memset(priv->stats_report->stats, 0,
> > +                                    (tx_stats_num + rx_stats_num) *
> > +                                    sizeof(struct stats));
> > +                     }
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
>
>
> > +static int gve_alloc_stats_report(struct gve_priv *priv)
> > +{
> > +     int tx_stats_num, rx_stats_num;
> > +
> > +     tx_stats_num = (GVE_TX_STATS_REPORT_NUM) *
> > +                    priv->tx_cfg.num_queues;
> > +     rx_stats_num = (GVE_RX_STATS_REPORT_NUM) *
> > +                    priv->rx_cfg.num_queues;
> > +     priv->stats_report_len = sizeof(struct gve_stats_report) +
> > +                              (tx_stats_num + rx_stats_num) *
> > +                              sizeof(struct stats);
> > +     priv->stats_report =
> > +             dma_alloc_coherent(&priv->pdev->dev, priv->stats_report_len,
> > +                                &priv->stats_report_bus, GFP_KERNEL);
> > +     if (!priv->stats_report)
> > +             return -ENOMEM;
> > +     /* Set up timer for periodic task */
> > +     timer_setup(&priv->service_timer, gve_service_timer, 0);
> > +     priv->service_timer_period = GVE_SERVICE_TIMER_PERIOD;
> > +     /* Start the service task timer */
> > +     mod_timer(&priv->service_timer,
> > +               round_jiffies(jiffies +
> > +               msecs_to_jiffies(priv->service_timer_period)));
> > +     return 0;
> > +}
>
> > @@ -1173,6 +1315,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       priv->db_bar2 = db_bar;
> >       priv->service_task_flags = 0x0;
> >       priv->state_flags = 0x0;
> > +     priv->ethtool_flags = 0x0;
> >       priv->dma_mask = dma_mask;
>
> You allocate the memory and start the timer even tho the priv flag
> defaults to off?
That's correct. But the allocated space is still written to by the NIC
and those stats would still be available to the guest/driver.
