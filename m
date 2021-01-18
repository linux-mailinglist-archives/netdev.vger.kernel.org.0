Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768AA2FAD13
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbhARWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbhARWG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:06:59 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CAFC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:06:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f1so5131390edr.12
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NpA9RihFjhvKbW/47lgjYirSmMFWRoPYWcif1Oj3zz8=;
        b=l7EH8664Wg59NtjEuTYf1xJMC03A50axxK5T5KH0I/qGHEKkpIbyzIveHS1RFb88YR
         K5CkBWFDnrjhp3D6DnrlwGr9Zxb6/GQL/u/hYCFaZr9QXk6VT7VonRCbF1rZxNypKhME
         8hRAYisbGMzT4CbQ590pqK6xHjCCLudTuHCvs27drIwi/DE8Iyj80o4zBt4d1HotjlFG
         h4UcdnN1sdx00d+MXK+bIotssATy8v/Y93AXRZtBPZ2OQFp7RbNwIzl7TTcT7wycf9UO
         DnxmQx7gezrdwVFkcALIFyAR30x1zRXEuwKMoMhi41pliM+wj9Qx9CIznJiX+RkbXV9F
         Q9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NpA9RihFjhvKbW/47lgjYirSmMFWRoPYWcif1Oj3zz8=;
        b=sck128sEyaBVUh7w9pyXGjoM0xJBotrVEknvxXkYuFELk6A5fm1xpcTru1TeMIxkkQ
         4UVVY8vqUrdEg7GptUcY/p0bH/tZCnKgMRA1wizU9rvLGuDSPkZtHPd2v0eLwELqFnOE
         FX99joPlBo08eUslz5Y1tvHzCvikyXXW1nuQ/ZNn15ExDOQAxrU6qLHojn2wCSOzz2Bw
         utXoficEade6Z4UJFuKiIcCRk1p7I9BWVUO7J6J8w06QjZ5n9yyXllUEptwV1KxSvUq0
         FA3bZutueYy9j/wmXge+P6znP55L7FFW8z/OkDtSc7B4TOYfL20r5drCcp7hBMyp9vax
         KGCQ==
X-Gm-Message-State: AOAM533/SlnQPJt0ZIe2sPYHSvXdTx4FlXBvCsbjq9FYVue0mWa/CnXn
        3ZbD6q3yWqNzrFIizVt2DaY=
X-Google-Smtp-Source: ABdhPJwZnOL1xsGHftAa5+kYJ5Rk39ErccE2Uf+nJJfyRPQG0tB8X+ttZOFpA58W+ene+Na982bDDg==
X-Received: by 2002:aa7:d64b:: with SMTP id v11mr1085764edr.16.1611007577593;
        Mon, 18 Jan 2021 14:06:17 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m9sm11372640edd.18.2021.01.18.14.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 14:06:17 -0800 (PST)
Date:   Tue, 19 Jan 2021 00:06:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, netdev@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118220616.ql2i3uigyz6tiuhz@skbuf>
References: <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf>
 <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf>
 <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
 <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 11:53:18PM +0200, Nikolay Aleksandrov wrote:
> On 18/01/2021 23:50, Vladimir Oltean wrote:
> > On Mon, Jan 18, 2021 at 11:39:27PM +0200, Nikolay Aleksandrov wrote:
> >> Apologies for the multiple emails, but wanted to leave an example:
> >>
> >> 00:11:22:33:44:55 dev ens16 master bridge permanent
> >>
> >> This must always exist and user-space must be able to create it, which
> >> might be against what you want to achieve (no BR_FDB_LOCAL entries with
> >> fdb->dst != NULL).
> >
> > Can you give me an example of why it would matter that fdb->dst in this
> > case is set to ens16?
> >
>
> Can you dump it as "dev ens16" without it? :)
> Or alternatively can you send a notification with "dev ens16" without it?
>
> I'm in favor of removing it, but it is risky since some script somewhere might
> be searching for it, or some user-space daemon might expect to see a notification
> for such entries and react on it.

If "dev ens16" makes no difference to the forwarding and/or termination
path of the bridge, just to user space reporting, then keeping
appearances is a bit pointless.

For example, DSA switch interfaces inherit by default the MAC address of
the host interface. Having multiple net devices with the same MAC
address works because either they are in different L2 domains (case in
which the MAC addresses should still be unique per domain), or they are
in the same L2 domain, under the same bridge (case in which it is the
bridge who should do IP neighbour resolution etc).
Having that said, let there be these commands:

$ ip link add br0 type bridge
$ ip link set swp0 master br0
$ ip link set swp1 master br0
$ ip link set swp2 master br0
$ ip link set swp3 master br0
$ bridge fdb | grep permanent
00:04:9f:05:de:0a dev swp0 vlan 1 master br0 permanent
00:04:9f:05:de:0a dev swp0 master br0 permanent

And these:

$ ip link add br0 type bridge
$ ip link set swp3 master br0
$ ip link set swp2 master br0
$ ip link set swp1 master br0
$ ip link set swp0 master br0
$ bridge fdb | grep permanent
00:04:9f:05:de:0a dev swp0 vlan 1 master br0 permanent
00:04:9f:05:de:0a dev swp0 master br0 permanent
00:04:9f:05:de:0a dev swp3 vlan 1 master br0 permanent
00:04:9f:05:de:0a dev swp3 master br0 permanent

Preserving the reporting for permanent/local FDB entries added by user
is one thing. But do we need to also preserve this behavior (i.e. report
the first unique MAC address of an interface that joins the bridge as a
permanent/local address on that brport, but not on the others, and not
on br0)? If yes, then I'm afraid there's nothing we can do.
