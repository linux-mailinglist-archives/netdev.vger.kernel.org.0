Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07113672CB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245270AbhDUSqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhDUSqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:46:46 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFABC06174A;
        Wed, 21 Apr 2021 11:46:12 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 10so20834151pfl.1;
        Wed, 21 Apr 2021 11:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WUIJpBKatwUmZf28HiE78wEq3gCHO70hNUHTcM+ZXj0=;
        b=EAg97X4b+W9iZfzikmPN8z2/tQpKMEj0ylxmQz8EBjIvBR3Mc8N8iDuOZMxaMFhCpY
         OhWPUas+sD+P0sbt0iuzrhsetEhG8ibkw/lwOFyIo9AA5nmow/tfU5eNrtgz6spk9rsf
         c5fOKAeqpWVqnx4kOMkryjLvVA7YcoDPZXqE2bjr+Kf9OF4ao6bFGX3fDgqV3AVJELFH
         D1ViDqGF66WUr+qV7VT17vSSBsyVdkNyQ0vkZtP1JCOpVpnQ9qnL2MsAvxxCpvl1JTvr
         rCiIyRe5Z5p65rCM7g62JVm5RKhjY5rQ4svzNfoeOMXA8kGAWZagp5Sn/0srXdrTQ1wX
         vGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WUIJpBKatwUmZf28HiE78wEq3gCHO70hNUHTcM+ZXj0=;
        b=ORd0h6cujXTyEdOHQ72+HOgokAoLV+SOPppcTyHvXHhnNT0RuPu2U8upFaX0/KkqFT
         oq8d4N4yztYdZyX1G1aHXnGcwpSNMKPeO/FMe5o1N01hiFawdsmsuNAMtgEkO/QzzSvj
         YcMq54PkhzkKtpYHoV5UNs8DyFbfZP4aFZD0qq2/MK/lNXE8SKKD6W5y3Y2V/LkkjVvD
         tTvkN3zgwRJ9xFdtSNSBXvtUxCrA6yWFeHaNJ7+HqsSH8x99NrZmkTp3pYhy9LXc2e4K
         remjUaMTr3nzIjvUsyRQBw0PXeg/428jPTSEbow01o2WJby0fv7fO4m4OXYhwIkSLm4+
         8xng==
X-Gm-Message-State: AOAM533N8dYj8g+hIAGnSiWiUywpDCBgZOsNkN1s5VMmTzvuVYP9UAdd
        idBpQVfMOwMWwXmrakiL9wg=
X-Google-Smtp-Source: ABdhPJw9BfbIHIlw9KVhuaVCbxNvnrxuRUS2mnJqfblzKlXo4vyU2neRZKTuXiJplTdBxSwKJ6UXNQ==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr13027988pju.91.1619030772339;
        Wed, 21 Apr 2021 11:46:12 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l35sm130470pgm.10.2021.04.21.11.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 11:46:11 -0700 (PDT)
Date:   Wed, 21 Apr 2021 21:46:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, andrew@lunn.ch,
        davem@davemloft.net, idosch@idosch.org, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org, nikolay@nvidia.com,
        roopa@nvidia.com, vladimir.oltean@nxp.com,
        linux-next@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: net: bridge: propagate error code and extack from
 br_mc_disabled_update
Message-ID: <20210421184600.qzsx6obwifcfsshq@skbuf>
References: <20210414192257.1954575-1-olteanv@gmail.com>
 <20210421181808.5210-1-borntraeger@de.ibm.com>
 <cfc19833-01ec-08ea-881d-4101780d1d86@de.ibm.com>
 <3993fbf8-b409-f88f-c573-bf5b8f418a88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3993fbf8-b409-f88f-c573-bf5b8f418a88@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:37:25AM -0700, Florian Fainelli wrote:
> On 4/21/2021 11:35 AM, Christian Borntraeger wrote:
> > On 21.04.21 20:18, Christian Borntraeger wrote:
> >> Whatever version landed in next, according to bisect this broke
> >> libvirt/kvms use of bridges:
> >>
> >>
> >> # virsh start s31128001
> >> error: Failed to start domain 's31128001'
> >> error: Unable to add bridge virbr1 port vnet0: Operation not supported
> >>
> >> # grep vnet0 /var/log/libvirt/libvirtd.log
> >>
> >> 2021-04-21 07:43:09.453+0000: 2460: info : virNetDevTapCreate:240 :
> >> created device: 'vnet0'
> >> 2021-04-21 07:43:09.453+0000: 2460: debug :
> >> virNetDevSetMACInternal:287 : SIOCSIFHWADDR vnet0
> >> MAC=fe:bb:83:28:01:02 - Success
> >> 2021-04-21 07:43:09.453+0000: 2460: error : virNetDevBridgeAddPort:633
> >> : Unable to add bridge virbr1 port vnet0: Operation not supported
> >> 2021-04-21 07:43:09.466+0000: 2543: debug : udevHandleOneDevice:1695 :
> >> udev action: 'add': /sys/devices/virtual/net/vnet0
> >>
> >> Christian
> >>
> > 
> > For reference:
> > 
> > ae1ea84b33dab45c7b6c1754231ebda5959b504c is the first bad commit
> > commit ae1ea84b33dab45c7b6c1754231ebda5959b504c
> > Author: Florian Fainelli <f.fainelli@gmail.com>
> > Date:   Wed Apr 14 22:22:57 2021 +0300
> > 
> >    net: bridge: propagate error code and extack from br_mc_disabled_update
> >       Some Ethernet switches might only be able to support disabling
> > multicast
> >    snooping globally, which is an issue for example when several bridges
> >    span the same physical device and request contradictory settings.
> >       Propagate the return value of br_mc_disabled_update() such that this
> >    limitation is transmitted correctly to user-space.
> >       Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >    Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >    Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
> > net/bridge/br_netlink.c   |  4 +++-
> > net/bridge/br_private.h   |  3 ++-
> > net/bridge/br_sysfs_br.c  |  8 +-------
> > 4 files changed, 27 insertions(+), 16 deletions(-)
> > 
> > not sure if it matters this is on s390.
> > A simple reproducer is virt-install, e.g.
> > virt-install --name test --disk size=12 --memory=2048 --vcpus=2
> > --location
> > http://ports.ubuntu.com/ubuntu-ports/dists/bionic/main/installer-s390x/
> 
> Thanks, I will kick off a reproducer and let you know.
> -- 
> Florian

Hey, you guys are moving fast, faster than it took me to open my email client...

Sorry for the breakage, Christian, I've just sent a patch with what I
think is wrong, could you give it a try?

Thanks!
