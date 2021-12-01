Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762DC464630
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhLAFAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhLAFAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:00:48 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C150FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 20:57:28 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m24so16720226pls.10
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 20:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6KTAD3sKpyDKo+5liOLZ7i1RU7H5kwdnRvVAzdbwkHM=;
        b=XgQlPIGfPfnxQSra78j+1431qtCkVJzPVcATzoqpGhy1mR8IniulOt7m/Gqm6pJUYL
         +/ZZty9xWNWWMswXyRcKN3Eoxn7nqSN1o9Sd+yoBFOGkdw9q0xryoyW6XcAUcDTJnvAh
         689jO3rB7vqASjnwDnnh8kqbr3ohQ09VmnGWPN0hQ8b3VLRNtvSdxZnuNeCl3OhYPunO
         RHQq7OTDfKnEV+HwA1hI2yp08Fb/jDRraKoumjTR9/JSJHp6lavQ52Y0WxlH+m0BJ/C2
         Gb7iOxMtFs1wEoaL/IdLXeuPzSX6tFF+OXk3bkzSeUrnm8z+x8LF8QdOoAOS0vZwXf2E
         Ednw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6KTAD3sKpyDKo+5liOLZ7i1RU7H5kwdnRvVAzdbwkHM=;
        b=RxXj2Ep54ceMNc1iEsSlNaT6/UUYS+tC0dfLHGBUfrEPcUW9Z1sp+gm7cWdUjU64sE
         HonwcmPFO47cTgv7x5PNbOwW4oXnEMLCYmr1kVr5T2ekpySuqmQo09MFhfn2Jy3VUjJJ
         aa+GXD+HFd+0Sq64AESNTDqtK8tl1kthC6lr1j58G9izH9u/vjWP0x+QNEWGt6iO5B+j
         6QH/yIi6vhSNCn4ACbAcbmnQJgZ52KdPJZ1zh2NrTrKXpswaOieJdfZYzaXMUZAaqu5u
         Iwh8lvi8+wCO4ukMlpU1JW18VHMN6UUH8tZyObYV+edaXIW7q2mIEYGdpQJmSRPFu3jy
         Kr7Q==
X-Gm-Message-State: AOAM533+b/l6EN7hinJChPtNNjyddN0SF6djRQXGfyWF4gziraHPNqdR
        Rri6F+qw7j0pjzhomAKC7CI=
X-Google-Smtp-Source: ABdhPJwinjOchqi5+vheQ4O7VWdw/xHMefVxgYLNwraOloKlLuXZj12kVTyvMT/3Uz1oDp+crHA27A==
X-Received: by 2002:a17:902:b411:b0:143:6fe8:c60e with SMTP id x17-20020a170902b41100b001436fe8c60emr4558479plr.41.1638334648231;
        Tue, 30 Nov 2021 20:57:28 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g20sm25531389pfj.12.2021.11.30.20.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:57:27 -0800 (PST)
Date:   Wed, 1 Dec 2021 12:57:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <YacAstl+brTqgAu8@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
 <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 07:19:56AM -0800, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 15:09:32 +0800 Hangbin Liu wrote:
> > We have VLAN PTP support(via get_ts_info) on kernel, and bond support(by
> > getting active interface via netlink message) on userspace tool linuxptp.
> > But there are always some users who want to use PTP with VLAN over bond,
> > which is not able to do with the current implementation.
> > 
> > This patch passed get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
> > with bond mode active-backup/tlb/alb. With this users could get kernel native
> > bond or VLAN over bond PTP support.
> > 
> > Test with ptp4l and it works with VLAN over bond after this patch:
> > ]# ptp4l -m -i bond0.23
> > ptp4l[53377.141]: selected /dev/ptp4 as PTP clock
> > ptp4l[53377.142]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
> > ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> > ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> > ptp4l[53384.127]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
> > ptp4l[53384.127]: selected local clock e41d2d.fffe.123db0 as best master
> > ptp4l[53384.127]: port 1: assuming the grand master role
> 
> Does the Ethernet spec say something about PTP over bond/LACP?

bond_option_active_slave_get_rcu() only supports bond mode active-backup/tlb/alb.
With LACP mode _no_ active interface returns and we will use software
timestamping.

But you remind me that we should return -EOPNOTSUPP when there is no real_dev
for bond_eth_ioctl(). I will send a fixup later.

> 
> What happens during failover? Presumably the user space daemon will
> start getting HW stamps based on a different PHC than it's disciplining?

linuxptp will switch to new active interface's PHC device when there is a
bonding failover by filtering netlink message on pure bond.

But for VLAN over bond I need to figure out how to get the bond failover
message on VLAN interface and update the new PHC device.

Thanks
Hangbin
