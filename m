Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2341F1E8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhJAQPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhJAQPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 12:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C46619E7;
        Fri,  1 Oct 2021 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633104799;
        bh=mMEfl2DznOLS6As2JE8WI2CMTaAzNlFeLwPjlOMFh+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qtGKYpJVkWBpyfyIyf10q2LSp6HasZDVzScNFobfxXXMug+wL9eZareCzYk+rZb9q
         Bp31Pex6eOAkyzHPX38/nYND0zavBfBuQLf5X9pR5y+icTLrveqPNhRfrkZb8ZooIy
         /GTrNaYJiAxzqVgrk2dLPgxp1qkD1n+MiEWkz86PNnnm1Nod5545kqh8TzCw1pT547
         wyIwuckD3T+tChy8asdoEfjyBw0Eu6Q/JJEE+KZNz+n9SrB93B+iHQWSLLXQYcPJzj
         SL6prBx77BEXuIGdSRsDzZusFqGJFTqCSVyMR7/Pi4GIUPXm88fjSm0HJ1kcj8vGLD
         kcEeoJ2NLE7tQ==
Received: by pali.im (Postfix)
        id 4384A821; Fri,  1 Oct 2021 18:13:16 +0200 (CEST)
Date:   Fri, 1 Oct 2021 18:13:16 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Message-ID: <20211001161316.w3cwsigacznjbowl@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-14-Jerome.Pouiller@silabs.com>
 <87fstlkr1m.fsf@codeaurora.org>
 <2873071.CAOYYqaKbK@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2873071.CAOYYqaKbK@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 01 October 2021 17:17:52 Jérôme Pouiller wrote:
> On Friday 1 October 2021 11:55:33 CEST Kalle Valo wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > 
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > 
> > [...]
> > 
> > > --- /dev/null
> > > +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> > > @@ -0,0 +1,49 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * Implementation of the host-to-chip MIBs of the hardware API.
> > > + *
> > > + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> > > + * Copyright (c) 2010, ST-Ericsson
> > > + * Copyright (C) 2010, ST-Ericsson SA
> > > + */
> > > +#ifndef WFX_HIF_TX_MIB_H
> > > +#define WFX_HIF_TX_MIB_H
> > > +
> > > +struct wfx_vif;
> > > +struct sk_buff;
> > > +
> > > +int hif_set_output_power(struct wfx_vif *wvif, int val);
> > > +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> > > +                              unsigned int dtim_interval,
> > > +                              unsigned int listen_interval);
> > > +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> > > +                             int rssi_thold, int rssi_hyst);
> > > +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> > > +                        struct hif_mib_extended_count_table *arg);
> > > +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> > > +int hif_set_rx_filter(struct wfx_vif *wvif,
> > > +                   bool filter_bssid, bool fwd_probe_req);
> > > +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl_len,
> > > +                             const struct hif_ie_table_entry *tbl);
> > > +int hif_beacon_filter_control(struct wfx_vif *wvif,
> > > +                           int enable, int beacon_count);
> > > +int hif_set_operational_mode(struct wfx_dev *wdev, enum hif_op_power_mode mode);
> > > +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_buff *skb,
> > > +                        u8 frame_type, int init_rate);
> > > +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool required);
> > > +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> > > +                          u8 tx_tid_policy, u8 rx_tid_policy);
> > > +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_density,
> > > +                          bool greenfield, bool short_preamble);
> > > +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> > > +                              int policy_index, u8 *rates);
> > > +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> > > +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __be32 *addr);
> > > +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> > > +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long val);
> > > +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable);
> > > +int hif_slot_time(struct wfx_vif *wvif, int val);
> > > +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> > > +int hif_rts_threshold(struct wfx_vif *wvif, int val);
> > 
> > "wfx_" prefix missing from quite a few functions.
> 
> I didn't know it was mandatory to prefix all the functions with the
> same prefix. With the rule of 80-columns, I think I will have to change
> a bunch of code :( .

I think that new drivers can use 100 characters per line.
