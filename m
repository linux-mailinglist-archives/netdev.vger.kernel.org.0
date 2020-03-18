Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A104918A37E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCRUKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCRUKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:10:24 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8EB52071C;
        Wed, 18 Mar 2020 20:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584562224;
        bh=L4UcU6rGA8u7H02UHdMiCWGu/RokzBDim33dQ/4zFn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z8fRksUV587fuYprwqZO5c2UCuJX97wGDFqL0g3FcUz3IDlYlStGcW7vkxCWbHxUt
         yTyVHyq1TistDS6cmytBhuEKGFEfUvHAJT1zsanaz+yu67i5cx97v312BhvqI5aN62
         E4sXmwMsuHAp45f+U1XqP0ZVpbhcKVKBE5xSBiXw=
Date:   Wed, 18 Mar 2020 13:10:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 05/11] bnxt_en: Add hw addr and multihost base
 hw addr to devlink info_get cb.
Message-ID: <20200318131022.396714d2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAACQVJrSv+sB6=TT_6G6nzDA4F6xppQnSb2wMm-z=0k+wucA3w@mail.gmail.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458082-29207-6-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200317104745.41ad47d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAACQVJrSv+sB6=TT_6G6nzDA4F6xppQnSb2wMm-z=0k+wucA3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 09:46:46 +0530 Vasundhara Volam wrote:
> On Tue, Mar 17, 2020 at 11:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 17 Mar 2020 20:44:42 +0530 Vasundhara Volam wrote:  
> > > In most of the scenarios, device serial number is not supported. So
> > > MAC address is used for proper asset tracking by cloud customers. In
> > > case of multihost NICs, base MAC address is unique for entire NIC and
> > > this can be used for asset tracking. Add the multihost base MAC address
> > > and interface MAC address information to info_get command.
> > >
> > > Also update bnxt.rst documentation file.
> > >
> > > Example display:
> > >
> > > $ devlink dev info pci/0000:3b:00.1
> > > pci/0000:3b:00.1:
> > >   driver bnxt_en
> > >   serial_number B0-26-28-FF-FE-C8-85-20
> > >   versions:
> > >       fixed:
> > >         asic.id 1750
> > >         asic.rev 1
> > >       running:
> > >         drv.spec 1.10.1.12
> > >         hw.addr b0:26:28:c8:85:21
> > >         hw.mh_base_addr b0:26:28:c8:85:20
> > >         fw 216.0.286.0
> > >         fw.psid 0.0.6
> > >         fw.app 216.0.251.0
> > >
> > > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>  
> >
> > Nack.
> >
> > Make a proper serial number for the device, the point of common
> > Linux interfaces is to abstract differences between vendors. You
> > basically say "Broadcom is special, we will use our own identifier".  
> I thought only couple of vendors support multi-host NICs, so made this
> macro as vendor specific. If it will be widely used, I will make it a generic
> macro.

There is no use for the "base address" other than to identify the
device. Which is what serial numbers are for. If the "base address"
is unique, just put it in the serial number field.

Or. You actually don't have to do that because if I look at your commit
message - it's already the exact same value. Sigh.

> > Also how is this a running version if it's supposed to be used for
> > asset management.  
> My mistake, will fix it to fixed version.
