Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CCF2CA5A4
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgLAOah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388950AbgLAOag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:30:36 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D0CC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 06:29:56 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so4555926lfh.2
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 06:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=9RtNQlvj1ZVFEMuk4AQGWn1PMpFSINxwqQviDrNovd8=;
        b=S9y1TwNR4v7+tzAMVOU+4Nn2+iiGL9fmyCEh08mcuTILh309aaRHK02Ww8PHZiGqNK
         Bv0ACToI/+F41ChD9f9xSPseXC/7wPHCAFkAYLvrkcqYVG2e8bzDp/pNo/IuaLWLcjjz
         7X13BtUECpXUvx4GDVZ//D+P5crh1jw/lNNThPlO8EYVl5Vhq/aIpBHCTcZkfnqYr8ds
         IKFESn2DQiw0VmJsUWv5Ou9wuzlNq6PohDslCDejiZ8tplQonxPTCw0aMorpDv5Yr89q
         FCxdaQwTe8gOPMTJCo3raLK4ywGcgMdEqkfxPpAlrBCfJjjbOeWDp3UA/K7TuxcdYCdv
         zR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9RtNQlvj1ZVFEMuk4AQGWn1PMpFSINxwqQviDrNovd8=;
        b=dI9D8SbDLEliP8C9By5rxKfpkL1s60PwT9Hah+AtfsxBzu/eSKZHqSw+8gpMjuN523
         ZWs+tioanht6P57w28el/antxlUTgN6fmVGt0H/gO/ZPwph8FTxsu/4s96gKcurODbqW
         kBwY555xNdhwyvD1yQ0SgqVJtufbPXxwhe+nEk7KrdW4hB+UtvIXqUpIeYuG0zSbDeF/
         fSXl/3/vT69dMF2b+RTFMnlX0VS2dKTC7c+TKbdm2zTf+N33Dfq4X5RO0TvazjyV6l2G
         5N1tUwi07Pm6jZpvbh4M490VOxpOz81MDyhfqNB0SzUt/zFA8ShzFbUx+OwXEWVG3yfj
         Fnow==
X-Gm-Message-State: AOAM531UUkDlcoB1J/PhD79fKN5LE15QC2N6mQJZyJOB7ZtG8NO3hx/S
        zgnn7uvf/DoY92P9eTshtPNkgMwhDUTBduYQ
X-Google-Smtp-Source: ABdhPJwFXCZ0ZeyRjbZnfd6XzahJHIgEE39vCjPIbXqEKTNIVzLOfv8963dAFUs+yJVMrYk9TvBjLw==
X-Received: by 2002:a19:505:: with SMTP id 5mr1245495lff.578.1606832994447;
        Tue, 01 Dec 2020 06:29:54 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id f25sm216791lfc.234.2020.12.01.06.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 06:29:53 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201201140354.lnhwx3ix2ogtnngy@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com> <20201130140610.4018-3-tobias@waldekranz.com> <20201201140354.lnhwx3ix2ogtnngy@skbuf>
Date:   Tue, 01 Dec 2020 15:29:53 +0100
Message-ID: <871rg98uqm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
>> When a LAG joins a bridge, the DSA subsystem will treat that as each
>> individual port joining the bridge. The driver may look at the port's
>> LAG pointer to see if it is associated with any LAG, if that is
>> required. This is analogue to how switchdev events are replicated out
>> to all lower devices when reaching e.g. a LAG.
>
> Agree with the principle. But doesn't that mean that this code:
>
> static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
> 					      unsigned long event, void *ptr)
> {
> 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> 	int err;
>
> 	switch (event) {
> 	case SWITCHDEV_PORT_OBJ_ADD:
> 		err = switchdev_handle_port_obj_add(dev, ptr,
> 						    dsa_slave_dev_check,
> 						    dsa_slave_port_obj_add);
> 		return notifier_from_errno(err);
> 	case SWITCHDEV_PORT_OBJ_DEL:
> 		err = switchdev_handle_port_obj_del(dev, ptr,
> 						    dsa_slave_dev_check,
> 						    dsa_slave_port_obj_del);
> 		return notifier_from_errno(err);
> 	case SWITCHDEV_PORT_ATTR_SET:
> 		err = switchdev_handle_port_attr_set(dev, ptr,
> 						     dsa_slave_dev_check,
> 						     dsa_slave_port_attr_set);
> 		return notifier_from_errno(err);
> 	}
>
> 	return NOTIFY_DONE;
> }
>
> should be replaced with something that also reacts to the case where
> "dev" is a LAG? Like, for example, I imagine that a VLAN installed on a
> bridge port that is a LAG should be propagated to the switch ports
> beneath that LAG. Similarly for all bridge attributes.

That is exactly what switchdev_handle_* does, no? It is this exact
behavior that my statement about switchdev event replication references.

> As for FDB and MDB addresses, I think they should be propagated towards
> a "logical port" corresponding to the LAG upper. I don't know how the
> mv88e6xxx handles this.

mv88e6xxx differentiates between multicast and unicast entries. So MDB
entries fit very well with the obj_add/del+replication. Unicast entries
will have use "lagX" as its destination, so in that case we need a new
dsa op along the lines of "lag_fdb_add/del".
