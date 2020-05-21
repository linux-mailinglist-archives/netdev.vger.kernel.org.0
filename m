Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745A21DD9AF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgEUVvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgEUVvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 17:51:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5552072C;
        Thu, 21 May 2020 21:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590097875;
        bh=Tn/RzU+kLeLCtb5gZw3sJC47x0UfDCvIjzHXHSfoO/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mU7WdpX0Hccl4shDvyQ2a+gCVCcVT+MrJoUhrdLVbcqBNJluXKDCG4k23VfafNBms
         fjTd92fXqKS/uEdPIn16y/i4wDL2xlFegFrU+ye6lfGLcdKbXKK0ag4Ep/rBlv96vv
         GHBu9x/oDPIqx/Sno3Y67vzc4Ep2TG5t/iPJu/xo=
Date:   Thu, 21 May 2020 14:51:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
Subject: Re: devlink interface for asynchronous event/messages from
 firmware?
Message-ID: <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
        <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
        <20200521205213.GA1093714@splinter>
        <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 13:59:32 -0700 Jacob Keller wrote:
> >> So the ice firmware can optionally send diagnostic debug messages via
> >> its control queue. The current solutions we've used internally
> >> essentially hex-dump the binary contents to the kernel log, and then
> >> these get scraped and converted into a useful format for human consumption.
> >>
> >> I'm not 100% of the format, but I know it's based on a decoding file
> >> that is specific to a given firmware image, and thus attempting to tie
> >> this into the driver is problematic.  
> > 
> > You explained how it works, but not why it's needed :)  
> 
> Well, the reason we want it is to be able to read the debug/diagnostics
> data in order to debug issues that might be related to firmware or
> software mis-use of firmware interfaces.
> 
> By having it be a separate interface rather than trying to scrape from
> the kernel message buffer, it becomes something we can have as a
> possibility for debugging in the field.

For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?

Right Ido?
