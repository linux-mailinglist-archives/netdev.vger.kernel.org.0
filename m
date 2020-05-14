Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E101D3C0B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgENTHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730172AbgENTHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 15:07:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B30DE20675;
        Thu, 14 May 2020 19:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589483222;
        bh=irWnRS322CZRu2W1HUFNbUrlKs55jy0E9s1AXY8lweQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IGohLao3b2vEs2hafuvKCCkeiVY8fhkU0Ao52lE1vxyC61AIRPP7O1hqJtMTlosuq
         RDwJGQ+lnh82G329CWzhDIPvQGBB+/NM5m8Ee2CenNYj6gwQtrFwJGG0UXfn7b9lPA
         mgBTO8WsW83gPTZcY5OCTIRHyFM/FI1NC+OZltBQ=
Date:   Thu, 14 May 2020 12:06:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>
Subject: Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw error
 handling
Message-ID: <20200514120659.6f64f6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 12:57:16 +0300 Igor Russkikh wrote:
> FastLinQ devices as a complex systems may observe various hardware
> level error conditions, both severe and recoverable.
> 
> Driver is able to detect and report this, but so far it only did
> trace/dmesg based reporting.
> 
> Here we implement an extended hw error detection, service task
> handler captures a dump for the later analysis.
> 
> I also resubmit a patch from Denis Bolotin on tx timeout handler,
> addressing David's comment regarding recovery procedure as an extra
> reaction on this event.
> 
> v2:
> 
> Removing the patch with ethtool dump and udev magic. Its quite isolated,
> I'm working on devlink based logic for this separately.
> 
> v1:
> 
> https://patchwork.ozlabs.org/project/netdev/cover/cover.1588758463.git.irusskikh@marvell.com/

I'm not 100% happy that the debug data gets reported to the management
FW before the devlink health code is in place. For the Linux community,
I think, having standard Linux interfaces implemented first is the
priority.
