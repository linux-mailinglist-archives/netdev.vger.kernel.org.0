Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEB66F2933
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjD3OXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3OXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:23:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A882219AF
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dymMybca8boswqxCuAI2r4PFI4UFx4kh4T03HVL2XX4=; b=LF/qNSAESbCDvRJAbM8moQdFjH
        DKe9a7GHdkiGCXbjaTaJRmu97gg91Qv4UCnCRHTUlzSlUViTVLDNIdfFw6CzuGrJ1H6T1lyWPepAb
        Mwn4HXXa+HKDUd7qj5QWyYkBeVki2aYc3c3T7I9RB/4kU+vRQaTFfF2pJMJiee8QDHIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pt7xR-00BYTG-Qs; Sun, 30 Apr 2023 16:23:21 +0200
Date:   Sun, 30 Apr 2023 16:23:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ron Eggler <ron.eggler@mistywest.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Unable to TX data on VSC8531
Message-ID: <73139af8-03a7-4788-bbf1-f76b963acb37@lunn.ch>
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 07:08:21AM -0700, Ron Eggler wrote:
> Hi,
> 
> I've posted here previously about the bring up of two network interfaces on
> an embedded platform that is using two the Microsemi VSC8531 PHYs. (previous
> thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner Kallweit &
> Andrew Lunn).
> I'm able to seemingly fully access & operate the network interfaces through
> ifconfig (and the ip commands) and I set the ip address to match my /24
> network. However, while it looks like I can receive & see traffic on the
> line with tcpdump

So receive definitely works?

It is a long shot, but a couple of decades ago, i had a board where
the PHY came up in loopback mode. All transmits never went out the
cable, they just came straight back again.

When running tcpdump during transmit, do you see each packet twice?

Please run mii-tool on the interface. e.g. for my device:

mii-tool -vv enp2s0:
Using SIOCGMIIPHY=0x8947
enp2s0:: no link
  registers for MII PHY 0: 
    1040 79c9 001c c800 0de1 0000 0064 0000
    0000 0200 0000 0000 0000 0000 0000 2000
    0000 0000 ffff 0000 0000 0400 0f00 0f00
    319b 0053 1002 80d9 84ca 0000 0000 0000
  product info: vendor 00:e0:4c or 00:07:32, model 0 rev 0
  basic mode:   autonegotiation enabled
  basic status: no link
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control


	Andrew
