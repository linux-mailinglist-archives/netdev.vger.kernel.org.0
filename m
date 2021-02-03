Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2330D72F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhBCKP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhBCKPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 05:15:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CADC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 02:14:39 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id i8so18281438ejc.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YvaUREMMOUrsGjDZnwqu5uqyxK8p8EFT8uOJX2t2HbQ=;
        b=jKEYQHCnyYrs+8/0xh+oVkiOEsueT6IN5Z2HUdIE/s8pPIuUyPoa8BIF8OJbZzvXg0
         bVFhP6m+TbJWIDGKAcd8xlFvfXJvM2ayLi42DOejbxy0cL7P7+Wopjf3gokMSjRrYl3a
         s7hWjSG79aBYkmnG8gHKvLbFOqaV9buOUBOthMwkBaHiX0web1XqK35Nr7w3LzpeJESm
         0T9C/iMYF5m7/AyDcOkeVQnadb2RrKH2ZPZYSQj+pkFSVpUaxl4/9oi7RlZd5UWLo4cj
         my9N3ot7nMXgreIwizlqQM6+WldYE2NNT3F9F0n7Qlu9N8QsBJJwykso7K2LLHJ8KokG
         SQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YvaUREMMOUrsGjDZnwqu5uqyxK8p8EFT8uOJX2t2HbQ=;
        b=bL/+p1JGAQ69Asi3k5fi85lP/YEcXSmkkHE/P87/7h2VIufy/RNBDQTcZGS3ZgkoyJ
         BfI2Y3HsiXrVW5gaVz/zDA3daolRhJdF1se5iv1GJb+zE3c9Ox1kr39DeTU9NVNDpSDo
         kUPNhCuf0LJGI6fQ4OnMBxEFQtXLIr7bYVzca1Az4LDLk/4AuJ7PSFqVfNattXx+DVsz
         lKauYiJIKLTTpiLFKQhZnRSgZ+mMxFw8lgQaMQE3cy16gL5cJ/ZkhJZVYV/GKY0XHI4W
         TBolIciERUxlfTiBSXGvUVOCUma5oqEXdQZPMpJXCkcPVEHnBxV0poFG9sC0CdFhQB8X
         fj6w==
X-Gm-Message-State: AOAM531RR11YsGe1PD74q1sOLDhAv0ixDkeIg5QdahYmF8tSEDQPEuti
        k2HnPrM8Me6eoKRYaXuoVok=
X-Google-Smtp-Source: ABdhPJzc+pntH+BeDCNOFxJqchdovb6tnggH6LQxKp6GxGM7bMmkXn8IYh0PAFjvsLIypN1WMjNNtg==
X-Received: by 2002:a17:906:3781:: with SMTP id n1mr2427081ejc.296.1612347277904;
        Wed, 03 Feb 2021 02:14:37 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e7sm792986ejb.19.2021.02.03.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 02:14:37 -0800 (PST)
Date:   Wed, 3 Feb 2021 12:14:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next 7/7] net: dsa: mv88e6xxx: Request assisted
 learning on CPU port
Message-ID: <20210203101436.xpukhaiseak6wvbe@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210201062439.15244-1-dqfext@gmail.com>
 <8735yd5wnt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735yd5wnt.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:27:02AM +0100, Tobias Waldekranz wrote:
> On Mon, Feb 01, 2021 at 14:24, DENG Qingfang <dqfext@gmail.com> wrote:
> > I've tested your patch series on kernel 5.4 and found that it only works
> > when VLAN filtering is enabled.
> > After some debugging, I noticed DSA will add static entries to ATU 0 if
> > VLAN filtering is disabled, regardless of default_pvid of the bridge,
> > which is also the ATU# used by the bridge.
> By default, a bridge will use a default PVID of 1, even when VLAN
> filtering is disabled (nbp_vlan_init). Yet it will assign all packets to
> VLAN 0 on ingress (br_handle_frame_finish->br_allowed_ingress).
>
> The switch OTOH, will use the PVID of the port for all packets when
> 802.1Q is disabled, thus assigning all packets to VLAN 1 when VLAN
> filtering is disabled.
>
> Andrew, Vladimir: Should mv88e6xxx always set the PVID to 0 when VLAN
> filtering is disabled?

For Ocelot/Felix, after trying to fight with some other fallout caused
by a mismatch between hardware pvid and bridge pvid when vlan_filtering=0:
https://patchwork.ozlabs.org/project/netdev/patch/20201015173355.564934-1-vladimir.oltean@nxp.com/
I did this and lived happily ever after:

  commit 75e5a554c87fd48f67d1674cfd34e47e3b454fb3
  Author: Vladimir Oltean <vladimir.oltean@nxp.com>
  Date:   Sat Oct 31 12:29:10 2020 +0200

      net: mscc: ocelot: use the pvid of zero when bridged with vlan_filtering=0

      Currently, mscc_ocelot ports configure pvid=0 in standalone mode, and
      inherit the pvid from the bridge when one is present.

      When the bridge has vlan_filtering=0, the software semantics are that
      packets should be received regardless of whether there's a pvid
      configured on the ingress port or not. However, ocelot does not observe
      those semantics today.

      Moreover, changing the PVID is also a problem with vlan_filtering=0.
      We are privately remapping the VID of FDB, MDB entries to the port's
      PVID when those are VLAN-unaware (i.e. when the VID of these entries
      comes to us as 0). But we have no logic of adjusting that remapping when
      the user changes the pvid and vlan_filtering is 0. So stale entries
      would be left behind, and untagged traffic will stop matching on them.

      And even if we were to solve that, there's an even bigger problem. If
      swp0 has pvid 1, and swp1 has pvid 2, and both are under a vlan_filtering=0
      bridge, they should be able to forward traffic between one another.
      However, with ocelot they wouldn't do that.

      The simplest way of fixing this is to never configure the pvid based on
      what the bridge is asking for, when vlan_filtering is 0. Only if there
      was a VLAN that the bridge couldn't mangle, that we could use as pvid....
      So, turns out, there's 0 just for that. And for a reason: IEEE
      802.1Q-2018, page 247, Table 9-2-Reserved VID values says:

              The null VID. Indicates that the tag header contains only
              priority information; no VID is present in the frame.
              This VID value shall not be configured as a PVID or a member
              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              of a VID Set, or configured in any FDB entry, or used in any
              Management operation.

      So, aren't we doing exactly what 802.1Q says not to? Well, in a way, but
      what we're doing here is just driver-level bookkeeping, all for the
      better. The fact that we're using a pvid of 0 is not observable behavior
      from the outside world: the network stack does not see the classified
      VLAN that the switch uses, in vlan_filtering=0 mode. And we're also more
      consistent with the standalone mode now.

      And now that we use the pvid of 0 in this mode, there's another advantage:
      we don't need to perform any VID remapping for FDB and MDB entries either,
      we can just use the VID of 0 that the bridge is passing to us.

      The only gotcha is that every time we change the vlan_filtering setting,
      we need to reapply the pvid (either to 0, or to the value from the bridge).
      A small side-effect visible in the patch is that ocelot_port_set_pvid
      needs to be moved above ocelot_port_vlan_filtering, so that it can be
      called from there without forward-declarations.

      Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
      Signed-off-by: Jakub Kicinski <kuba@kernel.org>
