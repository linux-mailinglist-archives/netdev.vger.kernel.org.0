Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E38188C84
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgCQRvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQRvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 13:51:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1429E20714;
        Tue, 17 Mar 2020 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584467465;
        bh=xvPCNY+zaZxajEth4P4TqsYdHhJ/7PSIGpyNtNc8Pvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YlNcMexgd4DyP1Qyzaayvya0/l1uUbBk2OInC9tpztoc3Gh9/2Qi9VRrzCKSkvUDI
         YbEYuW7i+yQyGKzQjn7OjLEw/pojqRnr6Sb1mi9wRSvKqv5JHabPNyS0PzMtdv+Ljq
         Sug603aYLq9gSpo6ZKmEe4z9cXEOrUaecequ/z1M=
Date:   Tue, 17 Mar 2020 10:51:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 08/11] bnxt_en: Add partno and serialno to
 devlink info_get cb
Message-ID: <20200317105103.2e46da90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584458246-29370-2-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458246-29370-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 20:47:23 +0530 Vasundhara Volam wrote:
> Add part number and serial number info from the vital product data
> to info_get command via devlink tool.
> 
> Some of the broadcom devices support both PCI extended config space
> for device serial number and VPD serial number. With this patch, both
> the information will be displayed via info_get cb.
> 
> Update bnxt.rst documentation as well.
> 
> Example display:
> 
> $ devlink dev info pci/0000:3b:00.1
> pci/0000:3b:00.1:
>   driver bnxt_en
>   serial_number B0-26-28-FF-FE-C8-85-20
>   versions:
>       fixed:
>         board.id BCM957508-P2100G
>         asic.id 1750
>         asic.rev 1
>         vpd.serialno P2100pm01920A0032CQ

This looks like it's a concatenation of multiple things. Isn't it?

>       running:
>         drv.spec 1.10.1.12
>         hw.addr b0:26:28:c8:85:21
>         hw.mh_base_addr b0:26:28:c8:85:20
>         fw 216.0.286.0
>         fw.psid 0.0.6
>         fw.app 216.0.251.0
> 
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
