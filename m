Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAB2143CAD
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAUMWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:22:20 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:56712
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728655AbgAUMWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:22:20 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id DD2552115F;
        Tue, 21 Jan 2020 12:22:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Jan 2020 13:22:10 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     David Miller <davem@davemloft.net>
Cc:     kubakici@wp.pl, khc@pm.waw.pl, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] wan/hdlc_x25: make lapb params configurable
Organization: TDT AG
In-Reply-To: <20200121.120147.1198296072172480771.davem@davemloft.net>
References: <20200121060034.30554-1-ms@dev.tdt.de>
 <20200121.114152.532453946458399573.davem@davemloft.net>
 <20200121.120147.1198296072172480771.davem@davemloft.net>
Message-ID: <19b3ce4b4bdc5f97d38e7880ec40c1ab@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-21 12:01, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 21 Jan 2020 11:41:52 +0100 (CET)
> 
>> From: Martin Schiller <ms@dev.tdt.de>
>> Date: Tue, 21 Jan 2020 07:00:33 +0100
>> 
>>> This enables you to configure mode (DTE/DCE), Modulo, Window, T1, T2, 
>>> N2 via
>>> sethdlc (which needs to be patched as well).
>>> 
>>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
>> 
>> Applied to net-next.
> 
> I seriously wonder how much you tested this code, because the compiler 
> warned
> me about:
> 
> diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
> index 63c9aeed9a34..c84536b03aa8 100644
> --- a/drivers/net/wan/hdlc_x25.c
> +++ b/drivers/net/wan/hdlc_x25.c
> @@ -253,7 +253,7 @@ static int x25_ioctl(struct net_device *dev,
> struct ifreq *ifr)
>  			return -EBUSY;
> 
>  		/* backward compatibility */
> -		if (ifr->ifr_settings.size = 0) {
> +		if (ifr->ifr_settings.size == 0) {
>  			new_settings.dce = 0;
>  			new_settings.modulo = 8;
>  			new_settings.window = 7;
> 
> I'll commit that fix, but this is truly careless especially since the 
> compiler
> warns about it.

I really want to apologize for that. I am currently working with
several branches of different kernel versions (mainly 4.19) and I
have overlooked this error when porting the latest changes.
