Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3093FCEE3
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNTrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:47:21 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:37950 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:47:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47DX7T1bp2zVF;
        Thu, 14 Nov 2019 20:47:16 +0100 (CET)
Date:   Thu, 14 Nov 2019 21:47:15 +0200
From:   Adrian Bunk <bunk@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: dp83867: Why does ti,fifo-depth set only TX, and why is it
 mandatory?
Message-ID: <20191114194715.GA29047@localhost>
References: <20191114162431.GA21979@localhost>
 <190bd4d3-4bbd-3684-da31-2335b7c34c2a@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <190bd4d3-4bbd-3684-da31-2335b7c34c2a@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 11:53:36AM -0600, Dan Murphy wrote:
> Adrian

Hi Dan,

>...
> > 2. Why is it a mandatory property?
> > Perhaps I am missing something obvious, but why can't the driver either
> > leave the value untouched or set the maximum when nothing is configured?
> 
> When the driver was originally written it was written only for RGMII
> interfaces as that is the MII that the data sheet references and does not
> reference SGMII.  We did not have SGMII samples available at that time.
> According to the HW guys setting the FIFO depth is required for RGMII
> interfaces.

My reading of the datasheets is that it isn't needed at all for RGMII,
only for SGMII and gigabit GMII.

Which makes it weird that it is only written in the RGMII case where it
is documented to be disabled.

And there is a documented default value so writing shouldn't be mandatory
in any case.

Perhaps I am looking at the wrong datasheets or there's a hardware errata?

> When SGMII support was added in commit
> 507ddd5c0d47ad869f361c71d700ffe7f12d1dd6

That's adding 6-wire mode support, the version of the driver I use with 
SGMII in 4.14 is much older and not far from the original submission.

Is there anything that might be missing for SGMII you are aware of?

> the rx fifo-depth DT property
> should have been added and both tx and rx should have been made optional. 
> We should probably deprecate the ti,fifo-depth in favor of the standard
> rx-fifo-depth and tx-fifo-depth common properties.
> 
> Dan

Thanks
Adrian
