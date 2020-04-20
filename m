Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC11B0CAC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgDTNbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:31:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50686 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDTNbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 09:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bTtcioAVktBgcUTfi+bs1vdsWqSYfUDLbtTIZdRCNz8=; b=C7umDL1g3lTk+Vwd6Q6R0TWE8u
        q7btrSM81MUhI7cA63GDWG6lBHEUvpaDoh5aKxalnyyfYBVroMKB0Jz+Xt1OLMaCdTaevIGn4k8GH
        wz8y9FMWVXo4VBUod7x34sn1aIm9rZklz06PbBUXAraOLvFVIah0Y70QY21SQ0Mv3x3Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQWW0-003pci-00; Mon, 20 Apr 2020 15:31:12 +0200
Date:   Mon, 20 Apr 2020 15:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC PATCH net-next] net: bridge: fix client roaming from DSA
 user port
Message-ID: <20200420133111.GL785713@lunn.ch>
References: <20200419161946.19984-1-dqfext@gmail.com>
 <20200419164251.GM836632@lunn.ch>
 <CALW65jYmcZJoP_i5=bgeWpcibzOmEPne3mHyBngE5bTiOZreDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYmcZJoP_i5=bgeWpcibzOmEPne3mHyBngE5bTiOZreDw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When a client moves from a hardware port (e.g. sw0p1) to a software port (wlan0)
> or another hardware port that belongs to a different switch (sw1p1),
> that MAC entry
> in sw0's MAC table should be deleted, or replaced with the CPU port as
> destination,
> by DSA. Otherwise the client is unable to talk to other hosts on sw0 because sw0
> still thinks the client is on sw0p1.

The MAC address needs to move, no argument there. But what are the
mechanisms which cause this. Is learning sufficient, or does DSA need
to take an active role?

Forget about DSA for the moment. How does this work for two normal
bridges? Is the flow of unicast packets sufficient? Does it requires a
broadcast packet from the device after it moves?

	  Andrew
