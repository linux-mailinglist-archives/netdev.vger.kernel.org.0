Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F092B4074
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgKPKHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbgKPKHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:07:30 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C26C0613CF;
        Mon, 16 Nov 2020 02:07:28 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id cw8so23545386ejb.8;
        Mon, 16 Nov 2020 02:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3ytn+xR4Wqrq6s6KVKS0bfZiRDyQ/EDjgPh7wuvbPGo=;
        b=jcFZaj+E7g6U4TgnvxRrmnaokOVRTNjg4kpYZOeOOUidcuVvWMt3ILDEpSMZ8+RGYi
         /s+kiiINJhnv4SRkx0H7VGWjua+c7+BgTYtVSTJ3IIDxMm3UzpFCeLXDcIEXku7YnV/X
         RcDSWUzvR2D4e7/OMBRgL6dnfNaB25oDRRnIBJ5ujmjran8n0FF3n51EO1kn8Jv9KUqe
         /b9Cry4XoikyIRPmH1s4fFV4MGLgKbwED7+mwnY4WNKyckHabIFDKsaN3b/uVhnD+h+j
         cQG9fm9zf7M+JdMrLnsmoRmJeflJyNfGFsYom1w/lCJnCV6dMQGPG3iNCyDy9qZ3NXci
         F6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3ytn+xR4Wqrq6s6KVKS0bfZiRDyQ/EDjgPh7wuvbPGo=;
        b=HLjq8oUjeutAUSf2SD93eMCGzoz4Lo4BZYHKfaNgpLcJetVrV5kBsHpBjeB7kJybUf
         x87s0bTrDADopNhdKU0VaSUgw8dwn/yXCqKmpaf2ix66+ABD8qH2nwMQVKciTJkUgOKy
         UrYASc4svKu2eTj7H5jXGJra2WcXH01Txd8+vwszXdkoBLcRnLBar9t7dlPS3KEt6OwY
         uihn8DTo8xiYwdc4BIAwd4ust2LTq4Hs8Q8lnmfL0AoqgP1/pd2xTwTZcLwH2B1Yn5zP
         uR8jlYVlT3wo1N6uI5j6LEDXfoC/L8XjG2zFcNyQeGsxUsR1oC18dGlexu8JSVRGtJHE
         hSTw==
X-Gm-Message-State: AOAM530roYS/VIhBPZZC7NBMH9Q4jkca2fpjc2zgQO7XsFzlh+9teZ+a
        xt8hC7amy3bKJkkWHhZ5NsA=
X-Google-Smtp-Source: ABdhPJy/ljo7nJGfwcf16vGDX++ahiQAVvnET+E6xXGlz4OXBZSW9+xdvI3AjpbAlxyoH1JMIrHWSA==
X-Received: by 2002:a17:906:f1d8:: with SMTP id gx24mr13520138ejb.73.1605521246847;
        Mon, 16 Nov 2020 02:07:26 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h25sm2698868edq.15.2020.11.16.02.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 02:07:26 -0800 (PST)
Date:   Mon, 16 Nov 2020 12:07:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/11] net: dsa: microchip: split ksz_common.h
Message-ID: <20201116100724.gbdb4cv2unv4n6zd@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112230254.v6bzsud3jlcmsjm2@skbuf>
 <5328227.AyQhSCNoNJ@n95hx1g2>
 <21145167.0O08aVLsga@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21145167.0O08aVLsga@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:21:14AM +0100, Christian Eggers wrote:
> On Friday, 13 November 2020, 17:56:34 CET, Christian Eggers wrote:
> > On Friday, 13 November 2020, 00:02:54 CET, Vladimir Oltean wrote:
> > > On Thu, Nov 12, 2020 at 04:35:29PM +0100, Christian Eggers wrote:
> > > > Parts of ksz_common.h (struct ksz_device) will be required in
> > > > net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
> > > > file.
> > > >
> > > > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > > > ---
> > >
> > > I had to skip ahead to see what you're going to use struct ksz_port and
> > >
> > > struct ksz_device for. It looks like you need:
> > >     struct ksz_port::tstamp_rx_latency_ns
> > >     struct ksz_device::ptp_clock_lock
> > >     struct ksz_device::ptp_clock_time
> > >
> > > Not more.
> I have tried to put these members into separate structs:
>
> include/linux/dsa/ksz_common.h:
> struct ksz_port_ptp_shared {
>         u16 tstamp_rx_latency_ns;   /* rx delay from wire to tstamp unit */
> };
>
> struct ksz_device_ptp_shared {
>         spinlock_t ptp_clock_lock; /* for ptp_clock_time */
>         /* approximated current time, read once per second from hardware */
>         struct timespec64 ptp_clock_time;
> };
>
> drivers/net/dsa/microchip/ksz_common.h:
> ...
> #include <linux/dsa/ksz_common.h>
> ...
> struct ksz_port {
> ...
> #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
>         struct ksz_port_ptp_shared ptp_shared;  /* shared with tag_ksz.c */
>         u16 tstamp_tx_latency_ns;       /* tx delay from tstamp unit to wire */
>         struct hwtstamp_config tstamp_config;
>         struct sk_buff *tstamp_tx_xdelay_skb;
>         unsigned long tstamp_state;
> #endif
> };
> ...
> struct ksz_device {
> ...
> #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
>         struct ptp_clock *ptp_clock;
>         struct ptp_clock_info ptp_caps;
>         struct mutex ptp_mutex;
>         struct ksz_device_ptp_shared ptp_shared;   /* shared with tag_ksz.c */
> #endif
> };
>
> The problem with such technique is, that I still need to dereference
> struct ksz_device in tag_ksz.c:
>
> static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
>                                   struct net_device *dev, unsigned int port)
> {
> ...
>         struct dsa_switch *ds = dev->dsa_ptr->ds;
>         struct ksz_device *ksz = ds->priv;
>         struct ksz_port *prt = &ksz->ports[port];
> ...
> }
>
> As struct dsa_switch::priv is already occupied by the pointer to
> struct ksz_device, I see no way accessing the ptp specific device/port
> information in tag_ksz.c.

There is a dp->priv that you could use to hold a reference to your
PTP-specific substructure (struct ksz_port_ptp_shared) of
struct ksz_port.

Then, in that PTP-specific per-port substructure, you could hold another
pointer to a common struct ksz_device_ptp_shared.
