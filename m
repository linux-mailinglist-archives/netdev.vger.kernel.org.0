Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427D1194D86
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCZXvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZXvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 19:51:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE9420719;
        Thu, 26 Mar 2020 23:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585266702;
        bh=xvs3J/Q3U56ufpWe2nNulhSZHmwnqdMsJLW24ny5dnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ECsPpRypgoIwypNaf98MZ++R/UYzxdswFKFKXsg5cf2IYXatZ95AvM0HsCX8lvrtU
         SYHSFvNS6LSwfPDocGDSyqphmk+bn5F4xXsp8KpNZTtdLATNJsTzdEsuo4pdAYIgN8
         x5+UxHC8UPL+87wyNJW/oKAyjeNB1b7oppGNx3v4=
Date:   Thu, 26 Mar 2020 16:51:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 1/5] devlink: Add macro for "fw.api" to
 info_get cb.
Message-ID: <20200326165139.4568f60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <582ed17d-8776-2f83-413c-37cf132c5e59@intel.com>
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200326134025.2c2c94f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLimJORgp2kmRLgZHWLY9E1DsbD8CSf+=9A-_DQhQG8kbqg@mail.gmail.com>
        <582ed17d-8776-2f83-413c-37cf132c5e59@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 16:39:31 -0700 Jacob Keller wrote:
> On 3/26/2020 4:09 PM, Michael Chan wrote:
> > On Thu, Mar 26, 2020 at 1:40 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> >>
> >> On Thu, 26 Mar 2020 17:32:34 +0530 Vasundhara Volam wrote:  
> >>> Add definition and documentation for the new generic info "fw.api".
> >>> "fw.api" specifies the version of the software interfaces between
> >>> driver and overall firmware.
> >>>
> >>> Cc: Jakub Kicinski <kuba@kernel.org>
> >>> Cc: Jacob Keller <jacob.e.keller@intel.com>
> >>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> >>> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >>> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >>> ---
> >>> v1->v2: Rename macro to "fw.api" from "drv.spec".  
> >>
> >> I suggested "fw.mgmt.api", like Intel has. What else those this API
> >> number covers beyond management? Do you negotiated descriptor formats
> >> for the datapath?  
> > 
> > To us, "management" firmware usually means firmware such as IPMI that
> > interfaces with the BMC.  Here, we're trying to convey the API between
> > the driver and the main firmware.  Yes, this main firmware also
> > "manages" things such as rings, MAC, the physical port, etc.  But
> > again, we want to distinguish it from the platform management type of
> > firmware.
> >   
> 
> Documentation for "fw.mgmt":
> 
> fw.mgmt
> -------
> 
> Control unit firmware version. This firmware is responsible for house
> keeping tasks, PHY control etc. but not the packet-by-packet data path
> operation.
> 
> To me, platform management would need a new name, as the term "fw.mgmt"
> has already been used by multiple drivers.

Right, we already have:

fw.ncsi                                                                         
-------                                                                         
                                                                                
Version of the software responsible for supporting/handling the                 
Network Controller Sideband Interface.


Maybe something more broad is needed there, but let's keep mgmt's
meaning. I know this may not fit existing vendor nomenclature, but
that's kind of the point, we're trying to have common Linux naming..
