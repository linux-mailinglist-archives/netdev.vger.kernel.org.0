Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE55A760
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfF1XFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:05:47 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39073 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:05:47 -0400
Received: by mail-lf1-f65.google.com with SMTP id p24so4972614lfo.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sPUicluoxi7PmWwcoxTyuD1lpqtIzHr2fbeIzcyxlg=;
        b=LRXFanHjoU2xcv1X0KP2eXASm7z1hUw4HwZ9awsgjNI0gHWOP4kum3Ig0UpKxESOuw
         iXedOAmnRqOJmi+tV5W11meCFcEeoYZVWnm0Z3MTd/NCaE+iOggstWg0BAY//70ZCobv
         1Kp08aanSSrZlxAxHma89H+2/yBa/rPCRn81g2zT36Mum81gNwAJTf/bMPHX+S2f8dfy
         T6mOcPFaJ1JfYXHv3Vj3UMggNxVvWRqz7wxfOYK/HdtDJm3hSTDL1sNvBMi545xf4r0P
         eJMSb3RG78/QAul6xAFxPLBKDZBdkcm2xMg0DJSq3MOrGcSfbNl0AtQ5OuTK06ypIH2J
         rlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sPUicluoxi7PmWwcoxTyuD1lpqtIzHr2fbeIzcyxlg=;
        b=tJSVO/PBkwlqG3ULNNZpYDdCNblk8cdLGbp7o2sK211QDBtoGzzP8/ySXnDP5YOVqN
         cbkDX7cv3wPXJ7kzui4zznaCH0m3/XS9lqxIg0Jv/beu4cFeDo7IV0mziCOEanajxW6a
         I/n+IS5BZFhMYsy3jT1b/DesPcb0hALoHS5FcuNHgI1MrQPWP/HG9qjPoLkhKIv+V27u
         +BDdSyrkC2AyIAO3Sx+PDWxvrkRLV24+OaB1RyNANQtXlzB0RYocvR3L4pnufKxiwTXE
         fUyZJk5tKRbUJ5xENNtCYgvhL+kkwiCiEuGNrmbCht1QIm2eLzsl8OpsTmV7mBARhRiA
         aeiA==
X-Gm-Message-State: APjAAAWQFRX7GL63IjaUlTjYcYkeL6XDADV+nJj+4P0uEv0nVcmLPQbJ
        r/I1BWNhcQjKg6TFOiZ5g5wm4K0RjjOrg6gYKTo4Gg==
X-Google-Smtp-Source: APXvYqxxmL4o3mQ1nhvKTdZbERxlO12aKIYMjfY5bxhRdIV9JX/bC+iLb31gPXSAz9QCb/hBn8aNR6D8hRUd49znT/g=
X-Received: by 2002:a19:9156:: with SMTP id y22mr5965859lfj.43.1561763144657;
 Fri, 28 Jun 2019 16:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190628175633.143501-1-csully@google.com> <20190628175633.143501-5-csully@google.com>
 <20190628111052.26b7c0e2@hermes.lan>
In-Reply-To: <20190628111052.26b7c0e2@hermes.lan>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 16:05:33 -0700
Message-ID: <CAH_-1qz3cKSMbNYUZwa=tEM1=5QSF86GrSgDwbpu9-qoMwHXww@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] gve: Add ethtool support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:11 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 28 Jun 2019 10:56:33 -0700
> Catherine Sullivan <csully@google.com> wrote:
>
> > +static void
> > +gve_get_ethtool_stats(struct net_device *netdev,
> > +                   struct ethtool_stats *stats, u64 *data)
> > +{
> > +     struct gve_priv *priv = netdev_priv(netdev);
> > +     u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
> > +     int ring;
> > +     int i;
> > +
> > +     ASSERT_RTNL();
> > +
> > +     for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> > +          ring < priv->rx_cfg.num_queues; ring++) {
> > +             if (priv->rx) {
> > +                     rx_pkts += priv->rx[ring].rpackets;
> > +                     rx_bytes += priv->rx[ring].rbytes;
> > +             }
> > +     }
> > +     for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> > +          ring < priv->tx_cfg.num_queues; ring++) {
> > +             if (priv->tx) {
> > +                     tx_pkts += priv->tx[ring].pkt_done;
> > +                     tx_bytes += priv->tx[ring].bytes_done;
> > +             }
> > +     }
> > +     memset(data, 0, GVE_MAIN_STATS_LEN * sizeof(*data));
>
> memset here is unnecessary since ethtool_get_stats allocates
> and zeros the memory already.

Ah, thanks, removed in v3.
