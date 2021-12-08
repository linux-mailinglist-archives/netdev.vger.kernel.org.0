Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEDB46CC4D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhLHEYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:24:38 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60428 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbhLHEYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:24:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6417ECE1F98
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EB2C00446;
        Wed,  8 Dec 2021 04:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638937263;
        bh=cQVgvHDHPYJ56anN/8+yMuzVmF9obIn6/LddtUoqZX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DBlhztBI3vRhDIAIIYVEhesl9bCL1Pr1/phh7U07zOPv8knMr8TMCAVPztIfJtPys
         2D9ubWrx10u8w4Z7neWobqDbFkvrhTBxnMXJCNI6ZJbrRvhV46a29GYF7gXkEpXv0s
         QQKO4A5Xl4qkKWXA5Qm7eSeH77HjU9dzA3uZy5v7LH9UnYib/9eEYpzns9j//tcWCC
         IY0vXYJhrTumz+0Qmr5C/oAVZYm0XxUSKb/LfsoKJdzl3+HwrrGWdfFIhxOAgzc7CU
         cc54ATSj1PyOIUwWzZchl99WKt3Qy5YCJGUe4ACd7El5JTzlZR/oqXxC91AYWFeDPl
         Md80L5T32cmNA==
Date:   Tue, 7 Dec 2021 20:21:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Message-ID: <20211207202101.3a3a93b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e2fd429a489545e7a521283600cb7caa@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
        <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
        <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e2fd429a489545e7a521283600cb7caa@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 07:28:02 +0000 Hayes Wang wrote:
> Jakub Kicinski <kuba@kernel.org>
> > Ah, I've only spotted the enable/disable knob in the patch.
> > If you're exchanging arbitrary binary data with the FW we
> > can't help you. It's not going to fly upstream.   
> 
> How is it that we only provide certain basic settings,
> such as IPv4 address, IPv6 address, and so on? Then,
> they are not the arbitrary binary data.
> 
> Could devlink param be used for more than 4 bytes settings?
> At least the IPv6 address is longer.

We can add a new devlink sub-command and driver callback in that case.

> Besides, we need the information of SMBIOS which could
> be 4K ~ 8K bytes data. Is there any way we could transmit
> it to firmware?

Is structure of that data defined by some DMTF standard?
