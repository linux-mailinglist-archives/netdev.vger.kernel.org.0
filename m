Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350D725249A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHZAGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgHZAGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:06:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6FFC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:06:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b16so354717ioj.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8WuSojHpOzpgfIZSYshIB733tK8qLGE1bW7tqxgWJ8=;
        b=Nd/xVN0cY9Y+k1qy56Hy4rXbhsQB3aPEE3VpdY1zYIaSy2sk5nwks4jPhAUZLem2UV
         UMZof1kpa/VhCaytB/AThF2S8yJ8jN4ahRtBi4Z/V8/HF2cwABG04xJKKPUtBXgjqGN1
         iNPp6LQ0GDY0kL367GYZ+D2ito4mIGCQKNp867SlfUP9zlnLnlHG/9PVihMhfqrjpgJL
         vk6mqSLdbV9PwqXKHMT4q3IS0cBo49cjtljVb5oe6w+9018glJKiqimyQU5ocGF/xV4B
         wZnGC0W97QZu/LQYk2sXs0Obn87oYipGF5pQ1u/dkgMUwgSf4lYnfVHM50l//GQdgRSG
         yBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8WuSojHpOzpgfIZSYshIB733tK8qLGE1bW7tqxgWJ8=;
        b=LCEQwFhhjR8Ho7CFPUkBZip9EKe9LUIby1QdcX4pYSAn1R68a3D5QyP1aeuqg9gCNX
         4G6cmK0utw/vMaIyn35UaduEfCLXjQgzRYav7XFS8iFGphFLtFuK6l4TeNryyjH9zBF0
         9FUMWpBWPcN2qiRbyOROJYacpOuE+d1amC1XMxW673UQjFFLBN+qVfFgrffLGPCvT9gY
         X4B/uuPnHFUK7jQdPL/NF383bKhPVIL4SVFhmtnRytZbpv/1kShxbfU4lwDNtl35Qr1y
         yNZCRAQGxUPXpsyPTIIzyN8Kae1E2dQu1TFAPfiRp8zZhvT+p+YEizTAiCnUxad6fwIj
         hnhQ==
X-Gm-Message-State: AOAM533mtRcPRvA4n5s3Uw8qbsV3LACmjUfNYCR36wHZamONYyZwS3x6
        9JDNWHWpVXKsbKeN/QzbqHvF/Z50nFM1U0l9YvaOfQ==
X-Google-Smtp-Source: ABdhPJxmtR6wpjSYm7tmXXemGVajvr7vtzO4hDw+S2iNJEgicmNXKkOOdSAcrEJ5xL7DVWd+hvrQKvGZwpJ89nJ7wnk=
X-Received: by 2002:a6b:6204:: with SMTP id f4mr10848585iog.56.1598400397807;
 Tue, 25 Aug 2020 17:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-6-awogbemila@google.com> <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAL9ddJcDYcn+p33nKicmp7yHm6PnZ9iXnghO4AYHNmtCFCe2eQ@mail.gmail.com> <20200825094635.715db5c0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200825094635.715db5c0@kicinski-fedora-PC1C0HJN>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 25 Aug 2020 17:06:27 -0700
Message-ID: <CAL9ddJfOWzO1v2FJAtb+qVAazR9Tb3CV8kH8V0_xA-GPgoAKXQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yangchun Fu <yangchun@google.com>, netdev@vger.kernel.org,
        Kuo Zhao <kuozhao@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 9:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 25 Aug 2020 08:46:12 -0700 David Awogbemila wrote:
> > > > +     // stats from NIC
> > > > +     RX_QUEUE_DROP_CNT               = 65,
> > > > +     RX_NO_BUFFERS_POSTED            = 66,
> > > > +     RX_DROPS_PACKET_OVER_MRU        = 67,
> > > > +     RX_DROPS_INVALID_CHECKSUM       = 68,
> > >
> > > Most of these look like a perfect match for members of struct
> > > rtnl_link_stats64. Please use the standard stats to report the errors,
> > > wherever possible.
> > These stats are based on the NIC stats format which don't exactly
> > match rtnl_link_stats64.
> > I'll add some clarification in the description and within the comments.
>
> You must report standard stats. Don't be lazy and just dump everything
> in ethtool -S and expect the user to figure out the meaning of your
> strings.
Apologies for responding a week later, I'll try to respond more quickly.
I could use some help figuring out the use of rtnl_link_stats64 here.
These 4 stats are per-queue stats written by the NIC. It looks like
rtnl_link_stats64 is meant to sum stats for the entire device? Is the
requirement here simply to use the member names in rtnl_link_stats64
when reporting stats via ethtool? Thanks.

>
> > > > +static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
> > > > +{
> > > > +     struct gve_priv *priv = netdev_priv(netdev);
> > > > +     u64 ori_flags, new_flags;
> > > > +     u32 i;
> > > > +
> > > > +     ori_flags = READ_ONCE(priv->ethtool_flags);
> > > > +     new_flags = ori_flags;
> > > > +
> > > > +     for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
> > > > +             if (flags & BIT(i))
> > > > +                     new_flags |= BIT(i);
> > > > +             else
> > > > +                     new_flags &= ~(BIT(i));
> > > > +             priv->ethtool_flags = new_flags;
> > > > +             /* set report-stats */
> > > > +             if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
> > > > +                     /* update the stats when user turns report-stats on */
> > > > +                     if (flags & BIT(i))
> > > > +                             gve_handle_report_stats(priv);
> > > > +                     /* zero off gve stats when report-stats turned off */
> > > > +                     if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
> > > > +                             int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> > > > +                                     priv->tx_cfg.num_queues;
> > > > +                             int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> > > > +                                     priv->rx_cfg.num_queues;
> > > > +                             memset(priv->stats_report->stats, 0,
> > > > +                                    (tx_stats_num + rx_stats_num) *
> > > > +                                    sizeof(struct stats));
> > >
> > > I don't quite get why you need the knob to disable some statistics.
> > > Please remove or explain this in the cover letter. Looks unnecessary.
> > We use this to give the guest the option of disabling stats reporting
> > through ethtool set-priv-flags. I'll update the cover letter.
>
> I asked you why you reply a week later with "I want to give user the
> option. I'll update the cover letter." :/ That's quite painful for the
> reviewer. Please just provide the justification.
I apologize for the pain; it certainly wasn't intended :) .
Just to clarify, stats will always be available to the user via ethtool.
This is only giving users the option of disabling the reporting of
stats from the driver to the virtual NIC should the user decide they
do not want to share driver stats with Google as a matter of privacy.

>
> > > > @@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
> > > >               dev_info(&priv->pdev->dev, "Device requested reset.\n");
> > > >               gve_set_do_reset(priv);
> > > >       }
> > > > +     if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> > > > +             dev_info(&priv->pdev->dev, "Device report stats on.\n");
> > >
> > > How often is this printed?
> > Stats reporting is disabled by default. But when enabled, this would
> > only get printed whenever the virtual NIC detects
> > an issue and triggers a report-stats request.
>
> What kind of issue? Something serious? Packet drops?
Sorry, to correct myself, this would get printed only at the moments
when the device switches report-stats on, not on every stats report.
After that, it would not get printed until it is switched off and then
on again, so rarely.
It would get switched on if there is a networking issue such as packet
drops and help us investigate a stuck queue for example.
