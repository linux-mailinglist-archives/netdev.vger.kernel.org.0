Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFB6421EFA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhJEGqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231816AbhJEGqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:46:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75CA261165;
        Tue,  5 Oct 2021 06:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633416261;
        bh=cXUDZv200Bhhq7gsR76VWgnrwqp0ABdauVK7hmqot5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZV5n+9UvZODI6hqY+hb84xZZ1gka6VxdbbUQjl/0NAUqSzWU7FrBtKsWVpAkb0irz
         V8vqf+Kaa2+NvGcLcV5IQbzHRf1XRZ0WnY97LaQ7AwSDXBd/kpmrzPVe4o70wgrxNY
         1JOlhmTWHZ964BV2Q0fLJw6wiy7KiwOZnkTdV6+c=
Date:   Tue, 5 Oct 2021 08:44:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Message-ID: <YVv0Q4ARfh/ebof5@kroah.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-14-Jerome.Pouiller@silabs.com>
 <87fstlkr1m.fsf@codeaurora.org>
 <2873071.CAOYYqaKbK@pc-42>
 <20211001161316.w3cwsigacznjbowl@pali>
 <87tuhwf19w.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tuhwf19w.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 09:12:27AM +0300, Kalle Valo wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Friday 01 October 2021 17:17:52 Jérôme Pouiller wrote:
> >> On Friday 1 October 2021 11:55:33 CEST Kalle Valo wrote:
> >> > CAUTION: This email originated from outside of the organization.
> >> > Do not click links or open attachments unless you recognize the
> >> > sender and know the content is safe.
> >> > 
> >> > 
> >> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >> > 
> >> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > >
> >> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > 
> >> > [...]
> >> > 
> >> > > --- /dev/null
> >> > > +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> >> > > @@ -0,0 +1,49 @@
> >> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> >> > > +/*
> >> > > + * Implementation of the host-to-chip MIBs of the hardware API.
> >> > > + *
> >> > > + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> >> > > + * Copyright (c) 2010, ST-Ericsson
> >> > > + * Copyright (C) 2010, ST-Ericsson SA
> >> > > + */
> >> > > +#ifndef WFX_HIF_TX_MIB_H
> >> > > +#define WFX_HIF_TX_MIB_H
> >> > > +
> >> > > +struct wfx_vif;
> >> > > +struct sk_buff;
> >> > > +
> >> > > +int hif_set_output_power(struct wfx_vif *wvif, int val);
> >> > > +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> >> > > +                              unsigned int dtim_interval,
> >> > > +                              unsigned int listen_interval);
> >> > > +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> >> > > +                             int rssi_thold, int rssi_hyst);
> >> > > +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> >> > > +                        struct hif_mib_extended_count_table *arg);
> >> > > +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> >> > > +int hif_set_rx_filter(struct wfx_vif *wvif,
> >> > > +                   bool filter_bssid, bool fwd_probe_req);
> >> > > +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl_len,
> >> > > +                             const struct hif_ie_table_entry *tbl);
> >> > > +int hif_beacon_filter_control(struct wfx_vif *wvif,
> >> > > +                           int enable, int beacon_count);
> >> > > +int hif_set_operational_mode(struct wfx_dev *wdev, enum
> >> > > hif_op_power_mode mode);
> >> > > +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_buff *skb,
> >> > > +                        u8 frame_type, int init_rate);
> >> > > +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool required);
> >> > > +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> >> > > +                          u8 tx_tid_policy, u8 rx_tid_policy);
> >> > > +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_density,
> >> > > +                          bool greenfield, bool short_preamble);
> >> > > +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> >> > > +                              int policy_index, u8 *rates);
> >> > > +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> >> > > +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __be32 *addr);
> >> > > +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> >> > > +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long val);
> >> > > +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable);
> >> > > +int hif_slot_time(struct wfx_vif *wvif, int val);
> >> > > +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> >> > > +int hif_rts_threshold(struct wfx_vif *wvif, int val);
> >> > 
> >> > "wfx_" prefix missing from quite a few functions.
> >> 
> >> I didn't know it was mandatory to prefix all the functions with the
> >> same prefix.
> 
> I don't know either if this is mandatory or not, for example I do not
> have any recollection what Linus and other maintainers think of this. I
> just personally think it's good practise to use driver prefix ("wfx_")
> in all non-static functions.
> 
> Any opinions from others? Greg?

For static functions, pick what you want.

For global functions, like this, use a common prefix that indicates the
driver as you are now playing in the global namespace of a 30 million
line project.

> >> With the rule of 80-columns, I think I will have to change a bunch of
> >> code :( .
> >
> > I think that new drivers can use 100 characters per line.
> 
> That's my understanding as well.

Yes, that's fine.

thanks,

greg k-h
