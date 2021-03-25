Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB6348670
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhCYBfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhCYBek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:34:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9B0C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:34:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w3so295981ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G8ps5OwcN6QR08doybv2cmjir2yfFiadbkKaYq0vh5Q=;
        b=ckh1skhlI07SGXQCe9hSoTCLCXzfJjoEboWPYyhWVCtl/65Jmq4nY0yE//PjqA0O+r
         +lMfHfL4F+wEEGbBDqImc/nat+izJF5VFF9hmhRyfFBzm7n2WOORCi+kOb0ScPUSpuiB
         ITCgN7d6U0gy5+m0y/agD8kxzSPdtaFz21fpyU/OeOQUgs7SJ658ZDTE8kKNtfHOjCU3
         V0BUAewBnd8xzMM1D5P7Ss61RhJPtisZogWR8hM5RmV+oLr1hyPvDz+IJmXefFPp7S/M
         FsW3acvDRBnpLKp8Bb7dx/te3u6HVyeRfEFOTCLuAG+z2XUdkeiK5xqomWvdkHKJ+EMf
         Rr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G8ps5OwcN6QR08doybv2cmjir2yfFiadbkKaYq0vh5Q=;
        b=kbPSAq5a3D24YQTcvgGWurSAYtjF7EmSIQ2lUe0pjYSqb7VR28mta6YVSS/WWGLsHC
         7g82mGz2W/SiNg/Xite/PV8XPIbNML8vY8XL+S6NKBCUX6Kx6zhy1HQqD+WC/CWu9wal
         EL8tdSjLvLCPRAQ4GnSVSC+fK2N3dQdJN5yvTZbIioxAogdKmDbvgm0x01rcc5dr6pis
         ca0UwzHRR02tPkYtCB8PaYdXlrQljl2tZ9UA8YRjv6a8FY6Ikg+x0F3k29jfi1l4sCnq
         fCAstxClaFkgqS7DYd7ba5LsXYlZmjaRP8b3PlTvPNOSEqImXlLEuyFPrd0Hyg3GFQkU
         txGg==
X-Gm-Message-State: AOAM531svtJHG5bpicLHtKLCBdh9iqpQwFA0PTQiKaIAEdzcyM1hniS6
        DG44bFQxe61bCY3tNMgEM7k=
X-Google-Smtp-Source: ABdhPJz5dl6HCN21LnIVLIHk++b8IToOhm5k/ajTEDB1FIWaudkCPgqcsIkR7aYOSY+7G5Q13nl7uw==
X-Received: by 2002:a17:906:5d05:: with SMTP id g5mr6662004ejt.489.1616636078455;
        Wed, 24 Mar 2021 18:34:38 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id b12sm1916102eds.94.2021.03.24.18.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 18:34:38 -0700 (PDT)
Date:   Thu, 25 Mar 2021 03:34:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210325013432.muugsogq4mzmalpd@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
 <20210324140317.amzmmngh5lwkcfm4@skbuf>
 <87pmzolhlv.fsf@waldekranz.com>
 <20210324150807.f2amekt2jdcvqhhl@skbuf>
 <87mtuslemq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtuslemq.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 05:07:09PM +0100, Tobias Waldekranz wrote:
> But even if the parser was enabled, it would never get anywhere since
> the Ethertype would look like random garbage. Unless we have the soft
> parser, but then it is not the middle ground anymore :)

Garbage, true, but garbage with enough entropy to allow for some sort of
RFS (ideally you can get the source port field from the DSA tag into the
area covered by the n-tuple on which the master performs hashing). This
is the way in which the switches inside NXP LS1028A and T1040 work.

> I suppose you would like to test for netdev_uses_dsa_and_violates_8023,
> that way you could still do RSS on DSA devices using regular 1Q-tags for
> example. Do we want to add this property to the taggers so that we do
> not degrade performance for any existing users?

Yes, so T1040 is one such example of device that would be negatively
affected by this change. There isn't a good solution to solve all
problems: there will be some Marvell switches which can't operate in
EDSA mode, and there will be some DSA masters that can't parse Marvell
DSA tags. Eventually all possible combinations of workarounds will have
to be implemented. But for now, I think I prefer to see the simplest
one, which has just become the one based on device tree.
