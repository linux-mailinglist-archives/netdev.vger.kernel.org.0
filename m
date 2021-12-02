Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E4F465C6A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344481AbhLBDI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355167AbhLBDIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:08:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5806FC061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:04:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so2220774pjj.0
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=N8Q9LatQNkEUaKMkktpA1dj63bcptt1xGy+BBnrLKnY=;
        b=O6x+8YERO4hJsN2pde+7ap4wxxuaXvc91LSJUfieNo9R45vUw9IRtMT3ARWBI9isPt
         51dwggIM2EjIRGfxb4YGpp0lhgJu8lj573c91gCY25oyhRTZ/XqZkQEMfAm9sohqICHp
         20cIuc6kd5EqPOpuyM7JnNXBvrBTbDSrT6zmcHxr60ufepmsErIAIbloZxlQdp1uC30N
         sssbFY3chP/dvAv7MBooM3ly8nPMfPX7mg3jTjnc+Abjtd4L+9FJAEiCZQIm1xf5zPH4
         +NxA95YG/MsBMgxsKEc7p7iHhbKu4Ek4ia5ZvDm+KazyH8I+JId4k1zkBvM4OmWnnbdI
         zVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=N8Q9LatQNkEUaKMkktpA1dj63bcptt1xGy+BBnrLKnY=;
        b=alCHtKk6DjmDP3aKUiOy9nGeKsLymjAWfYKDEyariXcOGk3bcXhBuFYRWEc3CGFikV
         txxgVCADYTFcxp3B++6qvSAeppjZUlN0B2h7St+4rNUCKAi/MnIKVi+ligkfv9NSnZIB
         dU1/e0U1FcYSj8X3wEdko4pfgXsPosu5h7pinzBSClQbrCfRFir8C8k6pGWWeC5rf0oa
         HQzj7hMbdewfsriD2do0zor+LF5ejKbMCJYFWKU2NEbjCG6hB9ZAJ9IQFLy4qbyKWE0a
         0AViMlapyyn6A7TK8YHG0xiCq5215Bt/fax4rQIDG7xuOR893O/q4FilVfOtycXqdmrB
         EDrA==
X-Gm-Message-State: AOAM5328G+BSAlR1NswDWsGgvwLL5wjVYchfJzf9AdMeqHKc1KUj5kUh
        7SSgqOgVfM5xSSbJV6UYSAI=
X-Google-Smtp-Source: ABdhPJw4AqktwaeJ4t3e/cvVlYCh2JnaJRoJNzdSr98PijWlr+lvUGBsjaXqRH8xfYILdaM5rXRADw==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr2790178pjb.222.1638414286951;
        Wed, 01 Dec 2021 19:04:46 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm1187743pfl.41.2021.12.01.19.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:04:46 -0800 (PST)
Date:   Thu, 2 Dec 2021 11:04:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <Yag3yI4cNnUK2Yjy@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
 <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YacAstl+brTqgAu8@Laptop-X1>
 <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 07:11:18AM -0800, Jakub Kicinski wrote:
> > > Does the Ethernet spec say something about PTP over bond/LACP?  
> > 
> > bond_option_active_slave_get_rcu() only supports bond mode active-backup/tlb/alb.
> > With LACP mode _no_ active interface returns and we will use software
> > timestamping.
> 
> I understand that, I was asking about guidance from LACP as there is 
> no IEEE standard for the other modes to my knowledge.

Oh, I checked IEEE 8021AX, this is only one paragraph mentioned PTP

8. Frame distribution and collection algorithms
8.2 Per-service frame distribution
8.2.1 Goals and objectives
Distributing frames to physical links by service ID, as defined in 8.2,
provides the following:

b) Bidirectional congruity: Providing a means for the two ends of an Aggregation Group to use the
same physical link in both directions for a given service ensures that a failed link or a link
experiencing an excessive error rate will affect the fewest possible number of services and in general
provide support for protocols that have strict symmetry requirements on their transmit and receive
paths, e.g., Precision Time Protocol (PTP) in IEEE Std 1588 ™ -2008.

But I didn't find any valuable information from it.

> 
> > But you remind me that we should return -EOPNOTSUPP when there is no real_dev
> > for bond_eth_ioctl(). I will send a fixup later.
> > 
> > > What happens during failover? Presumably the user space daemon will
> > > start getting HW stamps based on a different PHC than it's disciplining?  
> > 
> > linuxptp will switch to new active interface's PHC device when there is a
> > bonding failover by filtering netlink message on pure bond.
> > 
> > But for VLAN over bond I need to figure out how to get the bond failover
> > message on VLAN interface and update the new PHC device.
> 
> Yeah, there should be some form of well understood indication in the
> uAPI telling the user space daemon that the PHC may get swapped on the
> interface, and a reliable notification which indicates PHC change.
> There is a number of user space daemons out there, fixing linuxptp does
> not mean other user space won't be broken/surprised/angry.

This is a RFE, I don't think this patch will affect the current user space as
the new topology is not supported before. i.e. no user space tool will configure
PTP based on bond or vlan over bond. And even the user space use other ways to
get bond's active interface, e.g. via netlink message. It still not affected
and could keep using the old way. So I think this patch should be safe.

Did I miss any thing?
> 
> What notification is linuxptp listening on, SETLINK?

Currently, I send RTM_GETLINK message on bond and listening on
RTM_NEWLINK message to get IFLA_LINKINFO info.

But for the new VLAN over bond topology. I haven't figure out a good solution.
Maybe I can just check the active interface status. When it get down,
do get_ts_info once again to get the new active interface on the VLAN over
bond interface. I need some testing.

Hangbin
