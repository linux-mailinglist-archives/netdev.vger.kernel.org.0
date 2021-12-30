Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77349482046
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbhL3UcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbhL3UcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:32:10 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875E9C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:32:10 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g26so56549312lfv.11
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9oBKFS6U8XYMkmeZbXOhmYGSMO7eik4dk4Gn2iDWcAY=;
        b=LNVqYXut4WvKJ6rS6ipyULcnn0P87A25z3fBm8gDTW0lzTHu/Kiit7YgCkkU2xUHeS
         xIAavVi59qVVcraDMZbnT7fPIAILIHel/WBU7MSAftz1/TmrcxB1sA+rMvVBuBa0wcny
         EKuiHtMUZDWeltkQuRSxO7GHKRZkgf/KZKFQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9oBKFS6U8XYMkmeZbXOhmYGSMO7eik4dk4Gn2iDWcAY=;
        b=3hWGNa/Rh5dTSdLznFEeVEoiR3OLvdwm1nFw4lPlIo3CUgY5gv3lkwngfx4Y/Hlhjr
         76bAmifGXqnS4aj64rmObL4gWcr4HdttqOhw0GjbonlJrS0BuhWD3F08UmVupDWTNk8U
         2ql+sNDIR1tgxLw0JvAQrGqZbVTU+NJrm88uJls2Qh+XVYbNco/NFJn/fgdKoIStLYCA
         W9P7xYoQk9EhW/4QcpaPJmAh3eHEFluAPYUYEhUgDM5CA1Jnv++Oz3MpGLhfs/wTE+dM
         JoPOAOyaluwXLN+BUS3iDDEeBUXK5js/1ooF3zjEkeR/TELudm5Oi/Q7uq+ksqqX1hZv
         5h1A==
X-Gm-Message-State: AOAM531nsAdlsiiJgJzHZ+6x5FWH/9RtW6iFPsLeQ8XEHfSN8IgfLdZy
        8aGsf/iJ87r16UNoDHx879b64UAYzb+/UF6k9/+DZixTelc=
X-Google-Smtp-Source: ABdhPJxOF9aa3xBGI5xAWlJ2nXCjTqIa+io4WFdn8I8ugry5FuBLkqnf0Ro9ECEsFooj4129LBLxWdv56gTS7GPtXhI=
X-Received: by 2002:a05:6512:3093:: with SMTP id z19mr20992146lfd.670.1640896328434;
 Thu, 30 Dec 2021 12:32:08 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <20211230122806.26b30fe8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230122806.26b30fe8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:31:56 -0800
Message-ID: <CAOkoqZndMpzpn542SgOECxNfQNXEYYTT3BnSb+k7+iM9s=NSWg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Dec 2021 08:39:05 -0800 Dimitris Michailidis wrote:
> > +static const char mac_rx_stat_names[][ETH_GSTRING_LEN] = {
> > +     "mac_rx_octets_total",
> > +     "mac_rx_octets_ok",
> > +     "mac_rx_frames_total",
> > +     "mac_rx_frames_ok",
> > +     "mac_rx_VLAN_frames_ok",
> > +     "mac_rx_unicast_frames",
> > +     "mac_rx_multicast_frames",
> > +     "mac_rx_broadcast_frames",
> > +     "mac_rx_frames_64",
> > +     "mac_rx_frames_65_127",
> > +     "mac_rx_frames_128_255",
> > +     "mac_rx_frames_256_511",
> > +     "mac_rx_frames_512_1023",
> > +     "mac_rx_frames_1024_1518",
> > +     "mac_rx_frames_1519_max",
> > +     "mac_rx_drop_events",
> > +     "mac_rx_errors",
> > +     "mac_rx_FCS_errors",
> > +     "mac_rx_alignment_errors",
> > +     "mac_rx_frame_too_long_errors",
> > +     "mac_rx_in_range_length_errors",
> > +     "mac_rx_undersize_frames",
> > +     "mac_rx_oversize_frames",
> > +     "mac_rx_jabbers",
> > +     "mac_rx_fragments",
> > +     "mac_rx_control_frames",
> > +     "mac_rx_pause",
>
> > +     "mac_rx_CBFCPAUSE15",
> > +     "mac_fec_correctable_errors",
> > +     "mac_fec_uncorrectable_errors",
>
> Please drop all the stats which are reported via the structured API.
> It's a new driver, users are better off using the standard API than
> grepping for yet another unique, driver-specific string.

Will do.
