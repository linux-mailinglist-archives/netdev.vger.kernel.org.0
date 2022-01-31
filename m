Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7C84A476A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378041AbiAaMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377988AbiAaMlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:41:39 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69D1C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:41:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id p15so42646591ejc.7
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uOMDqM7nFHBhMqUx1OOBgYD4V9GViIpEqxbn5gfAz2s=;
        b=LNNtcyJFL1OOqiEf0ymER4Lytjbai2AVh6Ymh34CIAwDGhYcFsoS8UUxHmoAb/ztRO
         nXUKqt0oSWOt96edT4TCJjA+IS1n1Q72nu7xgX9Pjm0YwYwsTNLIAnwKFIKqwsx/Z8W1
         h4VAYhifPza9ZZAyTJvVHIF8H23myhgwvLX559EozC18WRw8+ABziI7rrC07qm/tTpi6
         byh+9xwLnxHwlu0v6UNBGXw57pwzP9Y0V1amZ4QJ8bYf90QQfFzea73F/qAusH3mEy9H
         DMYdIzYDVJv37J4MvUQcmHCcOqfAVdWEa6J0YVPO1Pzr4Hv1cUss7IL0Gnc3P18YT8nQ
         bYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uOMDqM7nFHBhMqUx1OOBgYD4V9GViIpEqxbn5gfAz2s=;
        b=hG1qH7VgpUPYTwMhRWvR2zGjWKjSFowIYr4CLeNodasS5XkatfTgsUEMv4tUbN/wQU
         iaaEwFoeiGidpZO8XxI2mXSL90GLw+GhPOuavpXJNRgPBEYJY9fCxyZjCEO5eRpDTR5z
         cGndb3h5eB3IIboITR0opIE3aQ8HQdabZF5Bp8zCtkGPFrV2IjWXy9EggMf/N9tV0Zq4
         HhIXbsXrLSAWY6rv38ee9qFd8KhRUZO4CN8lnLvIfUNcJOjHDDZ7rkehvJsjH4G9GjPB
         0gzU0vOWuPToi79v7hNgqC8SwzOUxXZ38rHoGSSugBBGaUd4k+OaN586ZLCY/eNDcpym
         2SPA==
X-Gm-Message-State: AOAM531upfFpxArcShWh0hqcAceEK/KLq24uQH6zHij9KAwz0sNts7SM
        U30pvkv8UKTbW8w6MROK/DQ=
X-Google-Smtp-Source: ABdhPJysp81o5zSm4ibeDfPldlz3rwa2yD+W1sPRtGPwjbQbxH7Vo14uopiNgEDnTdTlgkc7g3oW5A==
X-Received: by 2002:a17:907:3f26:: with SMTP id hq38mr1687590ejc.431.1643632896845;
        Mon, 31 Jan 2022 04:41:36 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id q10sm13451582ejn.3.2022.01.31.04.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 04:41:36 -0800 (PST)
Date:   Mon, 31 Jan 2022 14:41:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 1/5] ptp: unregister virtual clocks when
 unregistering physical clock.
Message-ID: <20220131124135.62khcaehujxrlhbf@skbuf>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-2-mlichvar@redhat.com>
 <87czkcn33p.fsf@intel.com>
 <Yfe0+N2cMJaWNbo7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfe0+N2cMJaWNbo7@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 31, 2022 at 11:07:52AM +0100, Miroslav Lichvar wrote:
> On Thu, Jan 27, 2022 at 03:58:02PM -0800, Vinicius Costa Gomes wrote:
> > Miroslav Lichvar <mlichvar@redhat.com> writes:
> > 
> > > When unregistering a physical clock which has some virtual clocks,
> > > unregister the virtual clocks with it.
> 
> > I am not against this change, but I think this problem was discussed
> > before and the suggestions were to fix it differently:
> > 
> > https://lore.kernel.org/all/20210807144332.szyazdfl42abwzmd@skbuf/
> 
> Is a linked device supposed to be unregistered automatically before
> the parent? The referenced document mentions only suspending
> and resuming, nothing about unregistering.
> 
> I tried
> 
> 	device_link_add(parent, &ptp->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
> 
> and also with no flags specified, but it didn't seem to do anything
> for the vclock. It was still oopsing.
> 
> Any hints?
> 
> -- 
> Miroslav Lichvar
> 

First of all, I was wrong about the device hierarchy created by the PTP
subsystem, and as such, device links won't work.

When you unbind a physical PTP clock, what you actually unbind is the
driver from its parent device (the parent->parent, i.e. what is passed
as "parent" to the parent's ptp_clock_register call).

But since the PTP subsystem doesn't register its devices with the device
hierarchy (of device_register(), it only calls the first half:
device_initialize(), it doesn't call device_add), so the dev->kobj
doesn't get added to the devices_kset. The documentation says:

| The earliest point in time when device links can be added is after
| device_add() has been called for the supplier and device_initialize()
| has been called for the consumer.

Furthermore, PTP devices don't have a driver bound to them, with probe()
and remove() callbacks. The only driver is that of the parent of the
physical PHC. So no driver for the vclock => no hook to call
ptp_vclock_unregister() from, even if a device link from ptp->dev to
parent->parent can be added.

So your solution appears to be the correct one given the structure - call
unregister_vclock() manually.

Secondly, you got the arguments in reverse: the consumer is the first
argument, and that is &ptp->dev, and the supplier is "parent".
