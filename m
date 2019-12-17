Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24D81229C7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLQLVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:21:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfLQLVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 06:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z5d7ttAQmg9NPpPdL8a9T+/K/2VIeDMQQma3/Qf1p6o=; b=K/uNbt6R8eE3UsPrU1Fwkh+/5W
        SANFn4pfrnh8hQ1mBVzAhOQTeYooFqOUcQysbC5yBBT+9Q2iV3lPsyb9BE6f4GFq4jXQTe4qxjs6q
        AkrFkwXWbmRQNxr2BFpV311IPZs1MRuDNmjNfQyy+CCtM1SY8D3fZMj54KFbprLsNzdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihAuo-0007Ua-2t; Tue, 17 Dec 2019 12:21:22 +0100
Date:   Tue, 17 Dec 2019 12:21:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     netdev@vger.kernel.org, "Kwok, WingMan" <w-kwok2@ti.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com
Subject: Re: RSTP with switchdev question
Message-ID: <20191217112122.GB17965@lunn.ch>
References: <c234beeb-5511-f33c-1232-638e9c9a3ac2@ti.com>
 <7ca19413-1ac5-946c-c4d0-3d9d5d88e634@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca19413-1ac5-946c-c4d0-3d9d5d88e634@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 11:55:05AM -0500, Murali Karicheri wrote:
> + switchdev/DSA experts

Hi Murali

I did not reply before because this is a pure switchdev issue. DSA
does things differently. The kernel FDB and the switches FDB are not
kept in sync. With DSA, when a port changes state, we flush the switch
FDB. For STP, that seems to be sufficient. There have been reports for
RSTP this might not be enough, but that conversation did not go very
far.

I've no idea how this is supposed to work with a pure switchdev
driver. Often, to answer a question like this, you need to take a step
backwards. How is this supposed to work for a machine with two e1000e
cards and a plain software bridge? What ever APIs user space RSTP is
using in a pure software case should be used in a switchdev setup as
well, but extra plumbing in the kernel might be required, and it
sounds like it may be missing...

      Andrew
