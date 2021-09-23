Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65C0416380
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbhIWQnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhIWQnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 12:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D209960F43;
        Thu, 23 Sep 2021 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632415307;
        bh=0KCkvdVdsQWQcz6xIIQYhb7Di42uLLfxxG9VTJnTRXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CgM2mQVsg4NbJx4XE5G1AhUqxl+c6ZU+Pn+CcD6mM7qn3TwJqJYjzVoe7OlL3oSlf
         tFf0MgPdh4aieRSUKc594u8QTBBmOfweCOMVrrLaSfp/VaTzarub535X8NW5IYysYe
         m/tR438rzumOsvd32w86wKv4WeNz5du0dxvt7yLUmvi+UdDZ6iDokFTnfZxWnDIpNN
         w1KzdHxzl8ZhdORTedHZPRZ1xsT5MVFOu5y+0MIOOYZR2HXW5ofq1ELEKxjx3I80PL
         rygFnCqdD4NRbQ/73gGOX1EBirP9g72JvD2zc0LvFn2E+LZHnwPOZzhTXYF3ONnvbf
         YlKUo47Vtg7OA==
Date:   Thu, 23 Sep 2021 09:41:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Message-ID: <20210923094146.0caaf4e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <TYCPR01MB66084980E50015D3C3F1F43CBAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
        <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <TYCPR01MB66084980E50015D3C3F1F43CBAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 16:29:44 +0000 Min Li wrote:
> > On Wed, 22 Sep 2021 09:57:14 -0400 min.li.xe@renesas.com wrote:  
> > > From: Min Li <min.li.xe@renesas.com>
> > >
> > > rsmu (Renesas Synchronization Management Unit ) driver is located in
> > > drivers/mfd and responsible for creating multiple devices including
> > > clockmatrix phc, which will then use the exposed regmap and mutex
> > > handle to access i2c/spi bus.  
> > 
> > Does not build on 32 bit. You need to use division helpers.  
> 
> Hi Jakub
> 
> I did build it through 32 bit arm and didn't get the problem.
> 
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-

We're testing x86, maybe arm32 can handle 64bit divisions natively?

ERROR: modpost: "__divdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!
ERROR: modpost: "__udivdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!
