Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2E83A20A8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhFIXWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 351DA613EA;
        Wed,  9 Jun 2021 23:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623280836;
        bh=Iqdd5M4M7EtRVepzlnqCfEtpxl5wcylP1LowaP5LcOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=HaHU4Kuq+35kCUGf97dmvchdiFfXdaF7NfwycGu1Ywj6X44jLHG3s6etLZVFLMPji
         PQPetFAnL11kfEQk1T10Ar7KFs6+TDvtgQM0oiBONNSKj2XTV6UQAKe/6fe2DNY3Yh
         KDvhxCunDUXJerQPMqTbTL2j9WpJvf7u8r95zqkMAYGDLumBH+czs0i7FAOQB/7pY5
         ImOwAPBiGBiSVRmLHTiZ2FEO7EdHA+XulNyljOPsooErjVXvly42j3HrYXqbmRONVi
         sjznhZswIRDAbBt9CCXvYZkeiGgk5fTInZRLaRyZiOzGgAACGwoIdI5jTrHg+JPrTK
         xhJyEaDlC5Zfg==
Date:   Wed, 9 Jun 2021 18:20:34 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-pci@vger.kernel.org,
        richardcochran@gmail.com, hch@infradead.org,
        netdev@vger.kernel.org, bhelgaas@google.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
Message-ID: <20210609232034.GA2681266@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0n2vdqv.fsf@vcostago-mobl2.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 04:07:20PM -0700, Vinicius Costa Gomes wrote:
> Hi Paul,
> 
> >> 
> >>> Regarding my comment, I did not mean returning an error but the log
> >>> *level* of the message. So, `dmesg --level err` would show that message.
> >>> But if there are PCI controllers not supporting that, it’s not an error,
> >>> but a warning at most. So, I’d use:
> >>>
> >>> 	dev_warn(&pdev->dev, "PTM not supported by PCI bus/controller
> >>> (pci_enable_ptm() failed)\n");
> >> 
> >> I will use you suggestion for the message, but I think that warn is a
> >> bit too much, info or notice seem to be better.
> >
> > I do not know, if modern PCI(e)(?) controllers normally support PTM or 
> > not. If recent controllers should support it, then a warning would be 
> > warranted, otherwise a notice.
> 
> From the Intel side, it seems that it's been supported for a few years.
> So, fair enough, let's go with a warn.

I'm not sure about this.  I think "warning" messages interrupt distro
graphical boot scenarios and cause user complaints.  In this case,
there is nothing broken and the user can do nothing about it; it's
merely a piece of missing optional functionality.  So I think "info"
is a more appropriate level.

Bjorn
