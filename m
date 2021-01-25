Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED6E303015
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbhAYXZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732441AbhAYXZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44ED621D93;
        Mon, 25 Jan 2021 23:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617098;
        bh=VkOmmnHknyr6LM+wL1Y2PgU5vXbAOBOP2SZuqIUbr50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZRs8jnFVXXoIxrEai1DOmf29LQDtaJzA9lLg/XkOBKR6JV9C4pPMGGcNalC79ySyN
         D2c0WX0PHHOgF1z7aW8cPc1oOZLwf+QWJd8rTG3uDFdjO9VCzPbmxlmEU28R4mdPmS
         FucEMI+OyXngC1EM+29A6Cw70N3zQC7fy4g73xgwrve06XX1zfn3jl14/MeDiGMLsr
         tuYkVjiAvx0vccyAFL1CCR9H/nkIj2l5whPCJgLWMlD05mFCmVtmeaTqIAuGfxt+r2
         HVpa35T5GcjJkS8oBQKGTpbEO0oSocGS7nnbakjcHNxRgfrYl5YSMSJYEoCt/Eqq/M
         1xxH6jhV7+2/A==
Date:   Mon, 25 Jan 2021 15:24:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] tg3: improve PCI VPD access
Message-ID: <20210125152457.043f3c91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLiky=a2k6bsi9Zdbv0m+-TCszqYWXLsp79nZTG7QQBijEw@mail.gmail.com>
References: <cb9e9113-0861-3904-87e0-d4c4ab3c8860@gmail.com>
        <CACKFLiky=a2k6bsi9Zdbv0m+-TCszqYWXLsp79nZTG7QQBijEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:09:16 -0800 Michael Chan wrote:
> On Fri, Jan 22, 2021 at 4:08 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >
> > When working on the PCI VPD code I also tested with a Broadcom BCM95719
> > card. tg3 uses internal NVRAM access with this card, so I forced it to
> > PCI VPD mode for testing. PCI VPD access fails
> > (i + PCI_VPD_LRDT_TAG_SIZE + j > len) because only TG3_NVM_VPD_LEN (256)
> > bytes are read, but PCI VPD has 400 bytes on this card.
> >
> > So add a constant TG3_NVM_PCI_VPD_MAX_LEN that defines the maximum
> > PCI VPD size. The actual VPD size is returned by pci_read_vpd().
> > In addition it's not worth looping over pci_read_vpd(). If we miss the
> > 125ms timeout per VPD dword read then definitely something is wrong,
> > and if the tg3 module loading is killed then there's also not much
> > benefit in retrying the VPD read.
> >
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>  
> 
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Applied, thank you!
