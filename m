Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E9D5B029
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfF3OzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 10:55:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF3OzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 10:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3RQc2vDk7oGHJcXz+P0JiRVzu/2ruLp74Dulou2oOkQ=; b=vdkFtMkd8yW5yNSmqASYQiXo6V
        EqECtPR7FujB3LSezuI/fYtk4/T2n78WIbmUadLSRchvPF8tqI5rPLiosGNIrPvqXu74PB7xYA37P
        rxncYcoXxN/qHfMjdb3ywUMyzicMP+63pgQj1jwGsKmcF7GFFzkF1IVx+rzVr24MBk08=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhbEV-0001ZA-5E; Sun, 30 Jun 2019 16:55:11 +0200
Date:   Sun, 30 Jun 2019 16:55:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Karsten Wiborg <karsten.wiborg@web.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
Message-ID: <20190630145511.GA5330@lunn.ch>
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 02:40:14PM +0200, Karsten Wiborg wrote:
> Hi Heiner,
> 
> On 30/06/2019 11:12, Heiner Kallweit wrote:
> > Indeed the MAC is missing:
> > [    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
> > 00:00:00:00:00:00, XID 541, IRQ 126
> >
> > This works with RTL8168h in other systems, so I'd say you should
> > check with the vendor. Maybe it's a BIOS issue.
> Tested some more. Found out that the Realtek-supplied r8168-8.046.00 is
> buggy (compilation bugged out, see one of my last mails). I just
> succeeded in compiling r8168-8.047.00, which ran straight out of the
> box. So the NIC is fine and not defect.
> 
> I do agree with you: I definitely would prefer an opensource driver but
> the r8169 simply didn't work.
> 
> In regard of my success with r8168-8.047.00, do you still think it might
> be a BIOS-issue?

Hi Karsten

What MAC address do you get with the vendor driver? Is it the same MAC
address every time you reboot, or does it look random.

The BIOS is expected to program the MAC address into the hardware. It
could be that the vendor driver is checking if the MAC address is
valid, and if not, picking a random MAC address. The mainline driver
does not do this.

       Andrew
