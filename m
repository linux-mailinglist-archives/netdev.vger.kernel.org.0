Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB42B0E76
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgKLTsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKLTsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:48:05 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0486620759;
        Thu, 12 Nov 2020 19:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605210484;
        bh=5hBLZAE0jY9iYZ0QKc7+eWnhy+5YTQg+eZTIRYX65S0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hrN564CmZsZ93faLUPiCa8AEs1iMNmIAy15vfRlXhIt2GBYlGpwEgYU/vfJ67yJwE
         H5in5sP/ic4E71FA3b8famJH8s0cRKrQwCZuLBlPnJQDwLQetQu3+7FJXfwANUN/uV
         Vdk2hYXP5mV+YyVYjmOpsL+ik0MGAoTydU4H6Ixo=
Message-ID: <e7a0df7c16d72f0d565521c76cd4f30142d57ccb.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 07/13] octeontx2-af: Add debugfs entry to
 dump the MCAM rules
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Date:   Thu, 12 Nov 2020 11:48:00 -0800
In-Reply-To: <20201111071404.29620-8-naveenm@marvell.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
         <20201111071404.29620-8-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-11 at 12:43 +0530, Naveen Mamindlapalli wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Add debugfs support to dump the MCAM rules installed using
> NPC_INSTALL_FLOW mbox message. Debugfs file can display mcam
> entry, counter if any, flow type and counter hits.
> 
> Ethtool will dump the ntuple flows related to the PF only.
> The debugfs file gives systemwide view of the MCAM rules
> installed by all the PF's.
> 
> Below is the example output when the debugfs file is read:
> ~ # mount -t debugfs none /sys/kernel/debug
> ~ # cat /sys/kernel/debug/octeontx2/npc/mcam_rules
> 
> 	Installed by: PF1
> 	direction: RX
>         mcam entry: 227
> 	udp source port 23 mask 0xffff
> 	Forward to: PF1 VF0
>         action: Direct to queue 0
> 	enabled: yes
>         counter: 1
>         hits: 0
> 

I don't want to block this series or anything, but you might want to
use devlink dpipe interface for this:

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-dpipe.html

As a future patch of course.

Thanks,
Saeed.

