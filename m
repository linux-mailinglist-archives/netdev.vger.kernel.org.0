Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63F524A40F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHSQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgHSQZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:25:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D100E2067C;
        Wed, 19 Aug 2020 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597854353;
        bh=1GN23RM47/uiFPYCDNfEw1ChgK+WbXJt6mi9J1+KPZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SxfRbhaD6loD67guEjRdG/gEbK5t1IYqiheAx7Qiei6ixQTBNhlqM3EhHADw91Dqf
         pRhjWVgYopv3svG6+Cu1s2EDZ8sQjcPnYxnQQtIPaGdN2secPCEcV74u0Q+UXBFew2
         NFB7WRaVPUh4P6iCqrGPrJ9ikZD+IcQFaSaYm4Yw=
Date:   Wed, 19 Aug 2020 09:25:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200819092551.6d94de03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819151815.GA2575@nanopsycho.orion>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
        <1597657072-3130-2-git-send-email-moshe@mellanox.com>
        <20200817163612.GA2627@nanopsycho>
        <3ed1115e-8b44-b398-55f2-cee94ef426fd@nvidia.com>
        <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
        <20200819124616.GA2314@nanopsycho.orion>
        <fc0d7c2f-afb5-c2e7-e44b-2ab5d21d8465@nvidia.com>
        <20200819151815.GA2575@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 17:18:15 +0200 Jiri Pirko wrote:
>>>> I will add counters on which reload were done. reload_down()/up() can return
>>>> which actions were actually done and devlink will show counters.  
>>> Why a counter? Just return what was done over netlink reply.  
>>
>> Such counters can be useful for debugging, telling which reload actions were
>> done on this dev from the point it was up.  
> 
> Not sure why this is any different from other commands...

Good question, perhaps because reset is more "dangerous"? The question
of "what reset this NIC" does come up in practice. With live activation
in the mix, knowing if the NIC FW was live activated will be very
useful for dissecting failures, I'd imagine.
