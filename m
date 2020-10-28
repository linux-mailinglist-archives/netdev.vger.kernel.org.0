Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2C29DAC7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbgJ1XbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgJ1XJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:09:02 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B93AC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:09:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so1280737eji.4
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v9x1AtXCKY8Ud73Ha9gZtFYT61mTg3zoDlCCO1o0Irc=;
        b=PDOPHi/qRQrzU25oEZYw1DYqZv8AjqM25M1yauTnI/k79txow4No0xgbsHggbDCVw0
         /cKF8ghvWl7F35g9AvN7BqDgCf6lINPTNvgTG1tFojAT209UNgdsPdX6R30mRfZRsWf/
         8VMEkFwBO+e6QOSjikiOpywVZcC/j+JzsBGD01eZPWO9i0fUqzdofu07mJBeiKgUGCsV
         vW0fKQPcEoWAH2Dcs1z/e6EaupTVrqigvZUIHu797aCpdBaRfyhMlkr0uEpTJFLk11FG
         OKroy4OECGQyG4dvKRi2O3pNoZdIIAh9ax5ZENBvCYRGt5bY5p3PIMXHmS0FM920QBim
         JPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v9x1AtXCKY8Ud73Ha9gZtFYT61mTg3zoDlCCO1o0Irc=;
        b=BMwVbN89q0C+ybc8t6ZvvjXZ+ZllByaEVZGS0OnoST7jn2j+3z1hIU+u0vrE59NfI5
         mH5rulKX9hKM6m/quDa9Czskm9z/QhUsxLTLNsl735XRIPT0mJJ5MbXL55WwoGeXNDB9
         2So5nj5qGQMUvvgD7GvJXVC4ev0pw6gtwwlQKuK2SjDFqpCcZ3INtJeMEVPDZ4gCDrIA
         2H7mjHMveAXOS9jUmYfJ2C3/GcL/mnEru20POrVQTMaLR+NKHKRK4L4ttSt5jTHJ0yOq
         wYg/OQ6RMJfu6ZqSlwyGWkTXtjuY6BKU/kx8QJEga/BTeerHyLEhyW5IjE1+vmTsx3aK
         VmFA==
X-Gm-Message-State: AOAM530eDjit00NdxqUY/kQnEYmp0ULlpQoKA1CZNRVrjXJgqY+aRAiT
        OFUMfcY2OaGdXPZjZSS8czE=
X-Google-Smtp-Source: ABdhPJzE8OhhGWVTIlOqJBBuqp0EsUh+1S5Jz/0YaEe/5r89FHI+WsR1shA0ZO4p6DF4tUMuPiQpGw==
X-Received: by 2002:a17:906:11d5:: with SMTP id o21mr1373643eja.401.1603926539949;
        Wed, 28 Oct 2020 16:08:59 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id gb6sm462291ejc.21.2020.10.28.16.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 16:08:59 -0700 (PDT)
Date:   Thu, 29 Oct 2020 01:08:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets
 from lag devices
Message-ID: <20201028230858.5rgzbgdnxo2boqnd@skbuf>
References: <20201028181824.3dccguch7d5iij2r@skbuf>
 <C6OVPVXHQ5OA.21IJYAHUW1SW4@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6OVPVXHQ5OA.21IJYAHUW1SW4@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:31:58PM +0100, Tobias Waldekranz wrote:
> The thing is, unlike L2 where the hardware will add new neighbors to
> its FDB autonomously, every entry in the hardware FIB is under the
> strict control of the CPU. So I think you can avoid much of this
> headache simply by determining if a given L3 nexthop/neighbor is
> "foreign" to the switch or not, and then just skip offloading for
> those entries.
> 
> You miss out on the hardware acceleration of replacing the L2 header
> of course. But my guess would be that once you have payed the tax of
> receiving the buffer via the NIC driver, allocated an skb, and called
> netif_rx() etc. the routing operation will be a rounding error. At
> least on smaller devices where the FIB is typically quite small.

Right, but in that case, there is less of an argument to have something
like DSA injecting directly into an upper device's RX path, if only
mv88e6xxx with bonding is ever going to use that.
