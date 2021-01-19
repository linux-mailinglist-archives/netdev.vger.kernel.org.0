Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7192FAE2E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404425AbhASAnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404393AbhASAms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 19:42:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548A2C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 16:42:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a10so9491137ejg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 16:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rtKyuBaH4bpBbe/YRAPdlL7NwIbp8grFREGPbCYV3lw=;
        b=UTUhXVqJkXSKeCNOiXFCdtPqey46i1S0AAkrDDPEsPZ3rF6SAoV1/LpXIiCJiL6yTj
         9ppVGhZzDafXnWegTga+PdCFELdMsk91Uk4ZD9lK4KSTavVHaKNPgJP72To4I2ZGMLKJ
         fydhMXNey6XyQjzc0Jd7X9PzNdq/zPRwZdUTsyMx/YssC8HtdgEdmSwZgy6/xgj5rAJG
         kDQYlGV8q0RpFgK/5Iwk1GkyGuebc9WiUQeoMq0r9ATw3RQlMb9QXDgjgFvm8Q+8GQVp
         8BK+1umvcl0ClCmjrcAHnGXH7i+WHSBq7bWVrUFH3BJO8AnCoYpPpv7SM/p65qNaAzip
         PNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtKyuBaH4bpBbe/YRAPdlL7NwIbp8grFREGPbCYV3lw=;
        b=mQ0hcK3UGcqGZogZnWGKWeZP2RmiraZSAKdb6JDBP3JhXXTow23VrTcg3nsMSFVel3
         fw/36oMORPWSMvtK3kxiK7BNuN90xim0YmmajR7mT2sxftLZji17sVlbFa+eANAqTFAQ
         NB2NHSwnGYYE/ah7+YJWBXWg1kG0Y0Dfa4zBiQVwJvLN+DhUmXUVpTXPxKNXGVmXQVG0
         UKM7WFm5NYt+D6neIKc1tpk25/kER0OLcfZZwkQXCXODYzzhdLEU5FLMMxKykfKJ/H8Q
         rT8Mbyz3AGJjpO/fxMW/OpxRuVrDg9ynIfxqpeiW9yAJACDDuNq1TgutKq4TQxWKCkKP
         +91Q==
X-Gm-Message-State: AOAM530RmD9dOA3kchTYm/vTDxm646eUrWB0a2GvotN6pECuiylqOEjP
        fRp62pbrOlh+EdaX0sY7Nx8=
X-Google-Smtp-Source: ABdhPJzl3i6CWX7e06mDOZxTu54+ChvPVESI4Qtopjo3HTY9K3/d7cSWTD7NnCDhkX6O2w8HSR/bvA==
X-Received: by 2002:a17:906:5254:: with SMTP id y20mr1358863ejm.174.1611016922876;
        Mon, 18 Jan 2021 16:42:02 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11546629edv.93.2021.01.18.16.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 16:42:02 -0800 (PST)
Date:   Tue, 19 Jan 2021 02:42:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, netdev@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210119004200.eocv274y2qbemp63@skbuf>
References: <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf>
 <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
 <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
 <20210118220616.ql2i3uigyz6tiuhz@skbuf>
 <32107e93-341f-aff8-a357-dd03e69d3839@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32107e93-341f-aff8-a357-dd03e69d3839@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 12:42:04AM +0200, Nikolay Aleksandrov wrote:
> No, it shouldn't be a problem to change that. We should be careful about the
> way it's changed though because reporting it for all ports might become a scale
> issue with 4k vlans, and also today you can't add the same mac for multiple ports.
> Perhaps the best way is to report it for the bridge itself, while still allowing
> such entries to be added/deleted by user-space.

I think what Tobias is trying to achieve is:
(a) offload the locally terminated FDB addresses through switchdev, in a
    way that is not "poisoned", i.e. the driver should not be forced to
    recognize these entries based on the is_local flag. This includes
    the ports MAC addresses which are currently notified as is_local and
    with fdb->dst = source brport (not NULL).
(b) remain compatible with the mistakes of the past, i.e. DSA and
    probably other switchdev users will have to remain oblivious of the
    is_local flag. So we will still have to accept "bridge fdb add
    00:01:02:03:04:05 dev swp0 master local", and it will have to keep
    incorrectly installing a front-facing static FDB entry on swp0
    instead of a local/permanent one.

In terms of implementation, this would mean that for added_by_user
entries, we keep the existing notifications broken as they are.
Whereas for !added_by_user, we replace them as much as possible with
"fdb->dst == NULL" entries (i.e. for br0).

I haven't looked closely at the code, and I hope that this will not
happen, but maybe some of these addresses will inevitably have to be
duplicated with is_local addresses that were previously notified. In
that case I'm thinking there must be some hackery to always offload the
addresses in this order: first the is_local address, then the br0
address, to allow the bad entry to be overwritten with the good one.

Finally, we should modify the bridge manpage to say "we know that the
local|permanent flag is added by default, but it's deprecated so pls
don't use it anymore, just use fdb on br0".

How does this sound?
