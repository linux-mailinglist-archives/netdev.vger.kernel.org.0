Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C96251C91
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgHYPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgHYPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:46:25 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A30DC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:46:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id v2so10816320ilq.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8pd0lIdar1HoHw3zM8Xt7g5Sad99SNJEdAg6hIY5+5M=;
        b=bHvsbJ9wwWV6ElqG8xlfVgnVxmwkGQSSEODT0SY72riN7kpkvWwyhwBcsTKhATws74
         l3TAmqljW1vLssUzF2peNkVulPd8FgSLEz/960Xo9T1f9On2d4TAGeIIpIU+zgoXNmID
         o6RcS2O0j4UUgCeHNwdeqlfvkRC3GO9rnW25fK6v0Plq3utD1w3h2M2R2rTfJ63fWjMx
         yGEmhwTGP08d1pw7RoQ5RZPbmchNpVMl7mjViYx19MmhUPb0FidhOGADcFNIqfQtIVJ4
         zmsFsXQrgzvSGOLFZx1WUV1pnG7PZIXwOdZLK9QpqkiU0xNrClEyszxShUF5+lWH8fDK
         awKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pd0lIdar1HoHw3zM8Xt7g5Sad99SNJEdAg6hIY5+5M=;
        b=h73KAjHZu79nncy4emD9JaU0CQ+e03/IW3WRckGl1zV8rLFXyzc6VMjYujsrXMY08Q
         F0AFmMc4sEbTE3Vk0yfAm0aDIhWjAq2HYOE65Z7XFBD5Z0T6+KAKgYhC2weYEPQwe5UG
         zsDF/otqQjzHyARor9omiVKBZc1OaGulTByA6SlEWBqIhUihjisGoe2PzF2BA+Ni40Xh
         vhOM0ND1d8Ld/3gsRc9CRxsxeDke4aEVBF17yQVKvlYK9RVgfHEQo9PGYutz7KAxyiXi
         j8aZTYja0BWgPUiF55SaudgD+D9hl0P1Y/mepWlIi9T9wT+J6Z4ZOUL/FeSkoNngmh2s
         YQ+A==
X-Gm-Message-State: AOAM530TY7CZEKEe2k2rHOcaKSCy5a1HfEu67v/6hbv/QZstlkbtPb/E
        xRR+WSt/AQKteQTmUfGBsRYasvFCXGzaS2t7347uCg==
X-Google-Smtp-Source: ABdhPJxVjiSkBrF4WWO7o4BESm9r8sEKP9YfXjg/rfIsDWHybfBg3E6MnURkHhSUL2mUKgrof1IE28NBD8+AmxYwceE=
X-Received: by 2002:a92:de43:: with SMTP id e3mr9091755ilr.124.1598370383351;
 Tue, 25 Aug 2020 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-6-awogbemila@google.com> <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 25 Aug 2020 08:46:12 -0700
Message-ID: <CAL9ddJcDYcn+p33nKicmp7yHm6PnZ9iXnghO4AYHNmtCFCe2eQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 8:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 18 Aug 2020 12:44:04 -0700 David Awogbemila wrote:
> > From: Kuo Zhao <kuozhao@google.com>
> >
> > Changes:
> > - Add a new flag in service_task_flags. Check both this flag and
> > ethtool flag when handle report stats. Update the stats when user turns
> > ethtool flag on.
> >
> > - In order to expose the NIC stats to the guest even when the ethtool flag
> > is off, share the address and length of report at setup. When the
> > ethtool flag turned off, zero off the gve stats instead of detaching the
> > report. Only detach the report in free_stats_report.
> >
> > - Adds the NIC stats to ethtool stats. These stats are always
> > exposed to guest no matter the report stats flag is turned
> > on or off.
> >
> > - Update gve stats once every 20 seconds.
> >
> > - Add a field for the interval of updating stats report to the AQ
> > command. It will be exposed to USPS so that USPS can use the same
> > interval to update its stats in the report.
> >
> > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > Signed-off-by: Kuo Zhao <kuozhao@google.com>
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
>
> This patch is quite hard to parse, please work on improving its
> readability. Perhaps start by splitting changes to the stats from
> hypervisor from the stats to hypervisor.
Alright, I will split the patch as suggested.

>
> > +enum gve_stat_names {
> > +     // stats from gve
> > +     TX_WAKE_CNT                     = 1,
> > +     TX_STOP_CNT                     = 2,
> > +     TX_FRAMES_SENT                  = 3,
> > +     TX_BYTES_SENT                   = 4,
> > +     TX_LAST_COMPLETION_PROCESSED    = 5,
> > +     RX_NEXT_EXPECTED_SEQUENCE       = 6,
> > +     RX_BUFFERS_POSTED               = 7,
>
> Just out of curiosity - what's the use for the stats reported by VM to
> the hypervisor?
These stats are not used in the driver but are useful when looking at
the virtual NIC to investigate stuck queues and performance.

>
> > +     // stats from NIC
> > +     RX_QUEUE_DROP_CNT               = 65,
> > +     RX_NO_BUFFERS_POSTED            = 66,
> > +     RX_DROPS_PACKET_OVER_MRU        = 67,
> > +     RX_DROPS_INVALID_CHECKSUM       = 68,
>
> Most of these look like a perfect match for members of struct
> rtnl_link_stats64. Please use the standard stats to report the errors,
> wherever possible.
These stats are based on the NIC stats format which don't exactly
match rtnl_link_stats64.
I'll add some clarification in the description and within the comments.

>
> > +};
> > +
> >  union gve_adminq_command {
> >       struct {
> >               __be32 opcode;
>
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
> > +                             memset(priv->stats_report->stats, 0,
> > +                                    (tx_stats_num + rx_stats_num) *
> > +                                    sizeof(struct stats));
>
> I don't quite get why you need the knob to disable some statistics.
> Please remove or explain this in the cover letter. Looks unnecessary.
We use this to give the guest the option of disabling stats reporting
through ethtool set-priv-flags. I'll update the cover letter.

>
> > +                     }
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
>
> > @@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
> >               dev_info(&priv->pdev->dev, "Device requested reset.\n");
> >               gve_set_do_reset(priv);
> >       }
> > +     if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> > +             dev_info(&priv->pdev->dev, "Device report stats on.\n");
>
> How often is this printed?
Stats reporting is disabled by default. But when enabled, this would
only get printed whenever the virtual NIC detects
an issue and triggers a report-stats request.
