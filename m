Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2294825A3
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 20:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhLaT10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 14:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhLaT1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 14:27:25 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9FAC061574;
        Fri, 31 Dec 2021 11:27:24 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v7so57258260wrv.12;
        Fri, 31 Dec 2021 11:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qm//CCvSZhhAyMJiVwLJsA5O+pIcy0ON3NGd+6daj8I=;
        b=NdkAcUyFpbV/pCYiiMGbRnTZdchrB5+9Vlh1TTrjVdMFMERdIo0bPOiLA9qMfOMYcG
         VDM1+LXQ0/WLKG4Jk12xctM5UKOkIILHxXbfkRpbub9BKaSnFtmhIp2xxsgsFLxY/GoG
         qD89/hb/DykEN4bclctzQR6tikasjYnud1pq8QVjgdfEX9h5Dohrw+T9HuurC7A945Zd
         zbZ5IASxcZ30qRSkEsRfWeGkGnnwuriJw+XC89KGaurql/HmUlgom5lVobt7EYEk94Qf
         3kzKF+MxRXBJyyrFKN8mXaWm/oDhDnqZLtWXecHJ7zlW7ZjB/HLzsDG96rMxjsqf192w
         VznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qm//CCvSZhhAyMJiVwLJsA5O+pIcy0ON3NGd+6daj8I=;
        b=b2SNBLlnnilr9yk72TkuSbmZXuWgirN2AFm9JTAG4eo9YU5/z/J9ux7f4+3ZRnFltW
         8Stoz3usqr9lxclh0x56IhAvk1GaCyITom/4ti4AVAWf9r8hucUiGMX79sY8cRyxAQ6V
         7piQ/4aJINkchFuSHu24O4q5feoBO/YEa8tPKkwJTxHA/016Mgwuw/aZsReavmYwKgbT
         B2r6COlDKHUodyekW423UFIC7r2TVY+E5WN4JHqVonj6wlEqCRcmi2VY6JL3JsDoWZ9y
         8YQsmqizVxrsqgTZ3f+sJ6Y9AAHOlGnEBjTCAPY5sa4SS3J3/Lr3KFVg4FenqygFPfHk
         yfhQ==
X-Gm-Message-State: AOAM5331savUS8rAn/yEfuQXqusDuQ1XQHkbUNgl5sGMo1kA41QUhv0I
        vFodQykH90CRdrjk0QE4MKKrz7AQI+Srs9LhGEH2sutWvnI=
X-Google-Smtp-Source: ABdhPJxhyb5Hc+/IrcPvoUpXtTAEsXA3e/2gae0d4byRMf+Aq5LuT6moGYOB1H8xqvJlFDr0n7U7qWxaLN7I4TvBzJ8=
X-Received: by 2002:a5d:588c:: with SMTP id n12mr30515862wrf.56.1640978843312;
 Fri, 31 Dec 2021 11:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
In-Reply-To: <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Fri, 31 Dec 2021 14:27:12 -0500
Message-ID: <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Nicolas Schodet <nico@ni.fr.eu.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 30 Dec 2021 at 14:47, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Wed, 29 Dec 2021 at 09:45, Nicolas Schodet <nico@ni.fr.eu.org> wrote:
> >
> > Hi,
> >
> > * Alexander Aring <alex.aring@gmail.com> [2021-12-29 09:30]:
> > > Hi,
> > > On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > ...
> > > > +{
> > > > +       bool promiscuous_on = mac802154_check_promiscuous(local);
> > > > +       int ret;
> > > > +
> > > > +       if ((state && promiscuous_on) || (!state && !promiscuous_on))
> > > > +               return 0;
> > > > +
> > > > +       ret = drv_set_promiscuous_mode(local, state);
> > > > +       if (ret)
> > > > +               pr_err("Failed to %s promiscuous mode for SW scanning",
> > > > +                      state ? "set" : "reset");
> > > The semantic of promiscuous mode on the driver layer is to turn off
> > > ack response, address filtering and crc checking. Some transceivers
> > > don't allow a more fine tuning on what to enable/disable. I think we
> > > should at least do the checksum checking per software then?
> > > Sure there is a possible tune up for more "powerful" transceivers then...
> >
> > In this case, the driver could change the (flags &
> > IEEE802154_HW_RX_DROP_BAD_CKSUM) bit dynamically to signal it does not
> > check the checksum anymore. Would it work?
>
> I think that would work, although the intention of the hw->flags is to
> define what the hardware is supposed to support as not changing those
> values dynamically during runtime so mac will care about it. However
> we don't expose those flags to the userspace, so far I know. We can
> still introduce two separated flags if necessary in future.
>
> Why do we need promiscuous mode at all? Why is it necessary for a
> scan? What of "ack response, address filtering and crc checking" you
> want to disable and why?
>

I see now why promiscuous mode is necessary here. The actual
promiscuous mode setting for the driver is not the same as promiscuous
mode in 802.15.4 spec. For until now it was there for running a
sniffer device only.
As the 802.15.4 spec defines some "filtering levels" I came up with a
draft so we can define which filtering level should be done on the
hardware.

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 72978fb72a3a..3839ed3f8f0d 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -130,6 +130,48 @@ enum ieee802154_hw_flags {
 #define IEEE802154_HW_OMIT_CKSUM       (IEEE802154_HW_TX_OMIT_CKSUM | \
                                         IEEE802154_HW_RX_OMIT_CKSUM)

+/**
+ * enum ieee802154_filter_mode - hardware filter mode that a driver
will pass to
+ *                              pass to mac802154.
+ *
+ * @IEEE802154_FILTER_MODE_0: No MFR filtering at all.
+ *
+ * @IEEE802154_FILTER_MODE_1: IEEE802154_FILTER_MODE_1 with a bad FCS filter.
+ *
+ * @IEEE802154_FILTER_MODE_2: Same as IEEE802154_FILTER_MODE_1, known as
+ *                           802.15.4 promiscuous mode, sets
+ *                           mib.PromiscuousMode.
+ *
+ * @IEEE802154_FILTER_MODE_3_SCAN: Same as IEEE802154_FILTER_MODE_2 without
+ *                                set mib.PromiscuousMode.
+ *
+ * @IEEE802154_FILTER_MODE_3_NO_SCAN:
+ *     IEEE802154_FILTER_MODE_3_SCAN with MFR additional filter on:
+ *
+ *     - No reserved value in frame type
+ *     - No reserved value in frame version
+ *     - Match mib.PanId or broadcast
+ *     - Destination address field:
+ *       - Match mib.ShortAddress or broadcast
+ *       - Match mib.ExtendedAddress or GroupRxMode is true
+ *       - ImplicitBroadcast is true and destination address field/destination
+ *         panid is not included.
+ *       - Device is coordinator only source address present in data
+ *         frame/command frame and source panid matches mib.PanId
+ *       - Device is coordinator only source address present in multipurpose
+ *         frame and destination panid matches macPanId
+ *     - Beacon frames source panid matches mib.PanId. If mib.PanId is
+ *       broadcast it should always be accepted.
+ *
+ */
+enum ieee802154_filter_mode {
+       IEEE802154_FILTER_MODE_0,
+       IEEE802154_FILTER_MODE_1,
+       IEEE802154_FILTER_MODE_2,
+       IEEE802154_FILTER_MODE_3_SCAN,
+       IEEE802154_FILTER_MODE_3_NO_SCAN,
+};
+
 /* struct ieee802154_ops - callbacks from mac802154 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -249,7 +291,7 @@ struct ieee802154_ops {
        int             (*set_frame_retries)(struct ieee802154_hw *hw,
                                             s8 retries);
        int             (*set_promiscuous_mode)(struct ieee802154_hw *hw,
-                                               const bool on);
+                                               enum
ieee802154_filter_mode mode);
        int             (*enter_scan_mode)(struct ieee802154_hw *hw,
                                           struct
cfg802154_scan_request *request);
        int             (*exit_scan_mode)(struct ieee802154_hw *hw);

---

In your case it will be IEEE802154_FILTER_MODE_3_SCAN mode, for a
sniffer we probably want as default IEEE802154_FILTER_MODE_0, as
"promiscuous mode" currently is.

- Alex
