Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B24331270
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCHPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCHPou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 10:44:50 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D709C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 07:44:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p8so21267700ejb.10
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 07:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1R1pDlUe3V84VT4yo5K+kL3oars7gghoMvLNVDFRBs=;
        b=dYaZ9Ij45EI7IQq0KYqRRabkV13AK7Bbi5Oq9KR+5UB4cGhzEodHEaRct2IjppeEL3
         sSaKfEcoXN/F6hhovG8J2giaSyFZyYV41kaiEtF+JlROwzv2/piLZWJmjNvvX9Kj97p2
         m89AL/4CKLNjTAV8AeFG247Fuj/dNX0KlCWs6A3P0F+xd7q2ckxbA3qUXDYbT65jqd3L
         BKXgXdFGZgcHBi/3HLEM9ISHt+5baaaMRiVKmQQGDVk/VWOs+lR5SQ00ra/2Sk0EEpiM
         9wIMblcG3aKrTb7t4nFotTJLoiheyoWph0XjsvhjHgr6sZG4/D2Cy/4Fqz8NWQIvHuws
         Ah8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J1R1pDlUe3V84VT4yo5K+kL3oars7gghoMvLNVDFRBs=;
        b=nEtdaJqI/Acewp4RA2QvJL4qfjJX3fdPNGLB2cnmRHXfj9IapTWHjygXvLjq86ZXMP
         CJgezCv1XRBcTLZUYe38c86Ns41zsxB3ci+CQsENyBh+WR1IMABecy2RmPcjB5o7gKn6
         Dl2+AVZKj5QYHzuvvYCspXF91DQ4P47ai3qhiaaHpMpdy8AYVeNKhAjzyRcP1g6Ga2vl
         xChY7AzWpbCMeixLlRvBPdw0rDDPazKB1s1JDp0dVcijmCkTQXD3+cr4IXhRymZobslZ
         0YAcueKDnuDQx7rfTXIvciCJ69KOPLfT93b3j2lGhanKr4/3J5AC/sgeR3WyluWgux5n
         1gvg==
X-Gm-Message-State: AOAM532IdiDQlfsY7wIpa/6yruWmKu+fC8p4czrsmj/1Z8/kZXqgoIbf
        5AS5EWpe7UPgGX3MhxzaLXs=
X-Google-Smtp-Source: ABdhPJwj+CDXqGp09VdsxxSuP93EQQdQB1TYPxmWOZDJIPfmgc+7uwzo+Q9NDHab8mOOOBck40eq7Q==
X-Received: by 2002:a17:906:aada:: with SMTP id kt26mr15320137ejb.137.1615218288694;
        Mon, 08 Mar 2021 07:44:48 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id i6sm6899233ejz.95.2021.03.08.07.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:44:47 -0800 (PST)
Date:   Mon, 8 Mar 2021 17:44:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked
 interfaces
Message-ID: <20210308154446.ceqp56bh65bsarlt@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
 <20210308150405.3694678-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308150405.3694678-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 04:04:04PM +0100, Tobias Waldekranz wrote:
> The dsa_slave_vlan_rx_{add,kill}_vid ndos are required for hardware
> that can not control VLAN filtering per port, rather it is a device
> global setting, in order to support VLAN uppers on non-bridged ports.
> 
> For hardware that can control VLAN filtering per port, it is perfectly
> fine to fallback to software VLANs in this scenario. So, make sure
> that this "error" does not leave the DSA layer as vlan_add_vid does
> not know the meaning of it.
> 
> The blamed commit removed this exemption by not advertising the
> feature if the driver did not implement VLAN offloading. But as we
> know see, the assumption that if a driver supports VLAN offloading, it
> will always use it, does not hold in certain edge cases.
> 
> Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

So these NDOs exist for drivers that need the 'rx-vlan-filter: on'
feature in ethtool -k, which can be due to any of the following reasons:
1. vlan_filtering_is_global = true, some ports are under a VLAN-aware
   bridge while others are standalone (this is what you described)
2. Hellcreek. This driver needs it because in standalone mode, it uses
   unique VLANs per port to ensure separation. For separation of untagged
   traffic, it uses different PVIDs for each port, and for separation of
   VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
   on two ports.
3. the ports that are under a VLAN-aware bridge should also set this
   feature, for 8021q uppers having a VID not claimed by the bridge.
   In this case, the driver will essentially not even know that the VID
   is coming from the 8021q layer and not the bridge.

If a driver does not fall under any of the above 3 categories, there is
no reason why it should advertise the 'rx-vlan-filter' feature, therefore
no reason why it should implement these NDOs, and return -EOPNOTSUPP.

We are essentially saying the same thing, except what I propose is to
better manage the 'rx-vlan-filter' feature of the DSA net devices. After
your patches, the network stack still thinks that mv88e6xxx ports in
standalone mode have VLAN filtering enabled, which they don't. That
might be confusing. Not only that, but any other driver that is
VLAN-unaware in standalone mode will similarly have to ignore VLANs
coming from the 8021q layer, which may add uselessly add to their
complexity. Let me prepare an alternative patch series and let's see how
they compare against each other.

As far as I see, mv88e6xxx needs to treat the VLAN NDOs in case 3 only,
and DSA will do that without any sort of driver-level awareness. It's
all the other cases (standalone ports mode) that are bothering you.
