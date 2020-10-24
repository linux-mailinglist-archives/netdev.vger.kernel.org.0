Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573D5297E76
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 22:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764442AbgJXUdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 16:33:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764434AbgJXUdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 16:33:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWQE9-003JvX-TV; Sat, 24 Oct 2020 22:33:25 +0200
Date:   Sat, 24 Oct 2020 22:33:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tom Rix <trix@redhat.com>
Cc:     Xu Yilun <yilun.xu@intel.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        mdf@kernel.org, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 4/6] ethernet: m10-retimer: add support for retimers
 on Intel MAX 10 BMC
Message-ID: <20201024203325.GM745568@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-5-git-send-email-yilun.xu@intel.com>
 <dbc77c18-8076-bcfd-b4f7-03e62dc46a97@redhat.com>
 <20201024163950.GJ745568@lunn.ch>
 <a4415cfa-b43b-8606-e944-edeb00de06fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4415cfa-b43b-8606-e944-edeb00de06fc@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 10:36:36AM -0700, Tom Rix wrote:
> 
> On 10/24/20 9:39 AM, Andrew Lunn wrote:
> > On Sat, Oct 24, 2020 at 08:03:51AM -0700, Tom Rix wrote:
> >> On 10/23/20 1:45 AM, Xu Yilun wrote:
> >>> This driver supports the ethernet retimers (Parkvale) for the Intel PAC
> >>> (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> >> Parkvale is a code name, it would be better if the public name was used.
> >>
> >> As this is a physical chip that could be used on other cards,
> >>
> >> I think the generic parts should be split out of intel-m10-bmc-retimer.c
> >>
> >> into a separate file, maybe retimer-c827.c
> > This driver is not really a driver for the Parkvale. That driver is
> > hidden away in the BMC. So we need to be a bit careful with the name,
> > leaving it available for when somebody writes a real Linux driver for
> > retimer.
> 
> Then the parkvale verbage should be removed.
> 
> And the doc ascii diagram be updated with a
> 
> +---------+
> 
> |  BMC    |
> 
> | retimer |
> 
> +---------+

Yes, i would like to get a better understanding of what the BMC is
actually doing, particularly the SFP. Given my current limited
understanding of the driver architecture, i'm not sure it is flexiable
enough to handle other cards where Linux is controlling the SFPs, the
retimer, the host side PCS of the Arria 10, etc. Once Linux is driving
all that, you need phylink, not phylib. The proposed phylib
driver/mdio bus driver actually looks like a hack.

   Andrew
