Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9384A14CA98
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgA2MPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:15:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgA2MPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:15:14 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0FEB14B8C98C;
        Wed, 29 Jan 2020 04:15:12 -0800 (PST)
Date:   Wed, 29 Jan 2020 13:15:11 +0100 (CET)
Message-Id: <20200129.131511.287823999185152451.davem@davemloft.net>
To:     ivecera@redhat.com
Cc:     poros@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net] phy: avoid unnecessary link-up delay in polling
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129130622.1b8b6e43@cera.brq.redhat.com>
References: <20200129101308.74185-1-poros@redhat.com>
        <20200129130622.1b8b6e43@cera.brq.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 04:15:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Wed, 29 Jan 2020 13:06:22 +0100

> On Wed, 29 Jan 2020 11:13:08 +0100
> Petr Oros <poros@redhat.com> wrote:
> 
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 6a5056e0ae7757..d5f4804c34d597 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
>>  
>>  	/* The link state is latched low so that momentary link
>>  	 * drops can be detected. Do not double-read the status
>> -	 * in polling mode to detect such short link drops.
>> +	 * in polling mode to detect such short link drops except
>> +	 * the link was already down.
>>  	 */
>> -	if (!phy_polling_mode(phydev)) {
>> +	if (!phy_polling_mode(pihydev) || !phydev->link) {
>                                ^
> Please remove the extra 'i' ----

How could this have ever been even build tested, let alone functionally
tested? :-/

