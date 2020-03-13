Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3580F184407
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgCMJrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:47:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgCMJrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 05:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=owOPiunMIkWsfod4tnAl8VA0j1fimAzydoG8uLc2/7c=; b=uPkshxTCiRfKdwCswjvl2dJz4S
        AB+JUe3UM/Gj+pvKXCJSOxII+Bt7iRvDlZmqMHL3Au3OZ0fnGHVrMLb6aRPLMy24VJ0ToEJXXNx77
        lA4iBdL+uaB+BZezoqEJ5sxpYXuglbkH+i6HiYPVd3d4fxIz3rBi4bfnF8V9fcvRixkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jCguY-00041g-BT; Fri, 13 Mar 2020 10:47:22 +0100
Date:   Fri, 13 Mar 2020 10:47:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: Information on DSA driver initialization
Message-ID: <20200313094722.GC14553@lunn.ch>
References: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
 <20200305225115.GC25183@lunn.ch>
 <CAOK2joHQRaBaW0_xexZLTp432ByvC6uhgJvjsY8t3HNyL9GUwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOK2joHQRaBaW0_xexZLTp432ByvC6uhgJvjsY8t3HNyL9GUwg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 06:38:24PM -0400, Sriram Chadalavada wrote:
> Hi Andrew,
>    Thank you for your response.
> 
>   Yes. There are patches applied.  I did scatter printks/pr_info but
> don't see anything yet from the Marvell 6176 switch without
> CONFIG_NET_DSA_LEGACY enabled.

CONFIG_NET_DSA_LEGACY is dead. Don't use it. Use the new binding.

> 
>     One question I have is if CONFIG_NET_DSA_LEGACY is NOT selected,
> what in the 4.19 kernel takes over the function of dsa_probe function
> in net/dsa/legacy.c and mv88e6xxx_drv_probe in
> drivers/net/dsa/mv88e6xxx/chip.c ?

When the mdio bus is registered, the mdio driver calls
of_mdiobus_register() passing a DT node for the bus. The bus is walked
and devices instantiated.

    Andrew
