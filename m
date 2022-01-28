Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0FF49F082
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 02:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345041AbiA1B1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 20:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345053AbiA1B1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 20:27:04 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B8BC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:27:04 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id v6so1210611vsp.11
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PttnHobxbrNXm7CRPT8hxk8WeppawPWcyPhV5DsSOLA=;
        b=qBDlMYS14e4kUT2cmx33e5dDZEL8k7RkraLxlfpBlXePm7UDaQrjeezim0DO7ndDy3
         ZXauKtE4aP9LfAvT7/vGhv+W9YAG9MfK8eOppGqHqSs2R3bGpvUoBmPzhWWOO8JXu64K
         hyCh8BELE4UktPLN5MW9TCCmn4DHu4sQ2tbAiV2z+g/EEsuDOqb+dQZLCpskYdKeeOkb
         qMxIsVWe+L7NJhFmJw6EaUZlYAcS8BPgY9lXpKy+WRy0VaqEHuCGaNKkb90sdU4AvzAJ
         7zaJvPJYXduUtgBuNZQUiHW2TIleybn4GhSosXAgXCEdETp8GorN7ta10Y5e51HiRQRj
         EQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PttnHobxbrNXm7CRPT8hxk8WeppawPWcyPhV5DsSOLA=;
        b=z0mQSoemjkBqGFDPcRUt7Buc5inhBT1J+vl8KuDl3RbAgID+gbkwpbV3C0tSKRO1Pk
         PvhTmUKWDInoRFcrFU4N7mJzmaABTVV+8nT8obvT/FPmAvjKpOBG+TmlB/vtEj83aMEd
         6Ez1sIUqzlP3tlQR/jFhYwRWRQ/x3/L3TijE9uT/XYuYkiF0W5193vDTBzPxdmC6qip8
         BfUZ1U/YlisTKAN0fYYEVfRcOrswm3ztpWCukGJCR1oWFKWJ+LgztuxuYkwHM032MojW
         dT9DtVLC87LqeNt3rB7MCf1pA5aiD5kEGRAp2t0A+4Ev1hkd0GpX3jMQeGL3vpifpRMl
         xK0A==
X-Gm-Message-State: AOAM531ZDeHeoDLc4bon+HlO/ApFumkwB5kMcNw6Iy8+dka94EmP7H3R
        zV2p6S1SYDE3T7S/U0JHdj5nVpWFBRPjCUrvD1ZmWdfOgCDrWg==
X-Google-Smtp-Source: ABdhPJz5pqAI4AAVdIJKudD5rF5gDHzbOLpMZaERpng0omVk/OxKL02I9gaYXj7tUX/1mg/9gBayxwGa0dtd+1So6Yw=
X-Received: by 2002:a05:6102:6d1:: with SMTP id m17mr1695436vsg.51.1643333222361;
 Thu, 27 Jan 2022 17:27:02 -0800 (PST)
MIME-Version: 1.0
References: <20220127002605.4049593-1-maheshb@google.com> <25026.1643327669@famine>
In-Reply-To: <25026.1643327669@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 27 Jan 2022 17:26:36 -0800
Message-ID: <CAF2d9jgJ7NWQaUAbB-hOhCk7BSwj+ApwWZLDVG3_-zhqCgnvzw@mail.gmail.com>
Subject: Re: [PATCH next] bonding: pair enable_port with slave_arr_updates
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 3:54 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Mahesh Bandewar <maheshb@google.com> wrote:
>
> >When 803.2ad mode enables a participating port, it should update
> >the slave-array. I have observed that the member links are participating
> >and are part of the active aggregator while the traffic is egressing via
> >only one member link (in a case where two links are participating). Via
> >krpobes I discovered that that slave-arr has only one link added while
> >the other participating link wasn't part of the slave-arr.
> >
> >I couldn't see what caused that situation but the simple code-walk
> >through provided me hints that the enable_port wasn't always associated
> >with the slave-array update.
> >
> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> >---
> > drivers/net/bonding/bond_3ad.c | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
> >index 6006c2e8fa2b..f20bbc18a03f 100644
> >--- a/drivers/net/bonding/bond_3ad.c
> >+++ b/drivers/net/bonding/bond_3ad.c
> >@@ -1024,6 +1024,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
> >
> >                                       __enable_port(port);
> >                               }
> >+                              /* Slave array needs update */
> >+                              *update_slave_arr = true;
> >                       }
>
>         Shouldn't this be in the same block as the __enable_port() call?
absolutely! It's inefficient to have outside of that if-clause and
would unnecessarily update slave-arr when it's not even needed. My
bad, I'll fix it in v2

> If I'm reading the code correctly, as written this will trigger an
> update of the array on every pass of the state machine (every 100ms) if
> any port is in COLLECTING_DISTRIBUTING state, which is the usual case.
>
> >                       break;
> >               default:
> >@@ -1779,6 +1781,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
> >                            port = port->next_port_in_aggregator) {
> >                               __enable_port(port);
> >                       }
> >+                      /* Slave array needs update. */
> >+                      *update_slave_arr = true;
> >               }
>
>         I suspect this change would only affect your issue if the port
> in question was failing to partner (i.e., the peer wasn't running LACP
> or there was some failure in the LACP negotiation).  If the ports in
> your test were in the same aggregator, that shouldn't be the case, as I
> believe unpartnered ports are always individual (not in an aggregator).
The condition seems to manifest randomly on some machines and not
always. All links are part of the same aggregator but some transient
situation does break the bond and almost always it reforms but
occasionally it gets into this state I mentioned.

My primary motive behind this fix/patch is to update the slave-arr
when LACP state is changing (for whatever reasons). Enabling port
seems to be an event which must be associated with updating the array
and found these two locations in the code where there is a chance that
update_array may not happen when a port gets enabled.

>
>         Do you have a test?
>
I'm not sure what triggers it and hence I don't have the exact repro
steps / test.

>         -J
>
> >       }
> >
> >--
> >2.35.0.rc0.227.g00780c9af4-goog
> >
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
