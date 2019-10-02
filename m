Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CEC882E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfJBMTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:19:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfJBMTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 08:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8+XPirIFL3wwh4Sm8SBX/JjgmXIT7ID1SFOfDdOf4ko=; b=wX5DeKY20a17K09XNjGbiXyNsc
        /QGMlJpufLlCZqV2oOUdpI+pnX7Z4MwOytJ9c0MPZ8X1uNKZP96Kd3jPPUJK4OSMlvuPpQsGp+cam
        1iZWELF3gAorRaMD6AMi7gMXc3lxjQmOKcSEGJafjS1X0X0+AXo6auaGqyYDQ4RgOrUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iFdbA-0005La-Cr; Wed, 02 Oct 2019 14:19:16 +0200
Date:   Wed, 2 Oct 2019 14:19:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Denis Odintsov <d.odintsov@traviangames.com>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "h.feurstein@gmail.com" <h.feurstein@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Message-ID: <20191002121916.GB20028@lunn.ch>
References: <DE1D3FAD-959D-4A56-8C68-F713D44A1FED@traviangames.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE1D3FAD-959D-4A56-8C68-F713D44A1FED@traviangames.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 11:57:30AM +0000, Denis Odintsov wrote:
> Hello,
> 
> Hope you are doing fine, I have a report regarding Marvell DSA after 7fb5a711545d7d25fe9726a9ad277474dd83bd06<https://github.com/torvalds/linux/commit/7fb5a711545d7d25fe9726a9ad277474dd83bd06> patch.
> 
> Thing is that after this commit:
> https://github.com/torvalds/linux/commit/7fb5a711545d7d25fe9726a9ad277474dd83bd06
> on linux 5.3 DSA stopped working properly for me.
> I'm using Clearfog GT 8k board, with 88E6141 switch and bridge config where all lanN interfaces are bridged together and ip is assigned to the bridge.
> 
> It stopped working properly in the matter that everything fires up from the board point of view, interfaces are there, all is good, but there are never any packet registered as RX on lanN interfaces in counters. Packets are always TX'ed and 0 as RX. But! This is where weird starts, the actual link is negotiated fine (I have 100Mb clients, and interfaces have correct speed and duplex, meaning they actually handshake with the other end). Even more, if I would set ip lanN interface itself with ip address, the networks somehow work, meaning a client, if set ip manually, can kind of ping the router, but with huge volatile times, like >300ms round trip. And still not a single RX packet on the interface shown in the counter.
> 
> So this is really weird behaviour, and the most sad part in that is that while on 5.3 with this patch reverted everything start to work fine, the trick doesn't work for 5.4 anymore.

Hi Denis

Could you give us the call stack when mv88e6xxx_adjust_link() is used
in 5.3. A WARN_ON(1) should do that.

We are probably missing a use case where it is used, but we did not
expect it to be used. The call stack should help us find that use
case.

Thanks
	Andrew
