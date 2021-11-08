Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA4F448183
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhKHOYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235534AbhKHOYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:24:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F490C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 06:21:48 -0800 (PST)
Subject: Re: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636381305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJTwkzJ4qB0w0zmGfeACIoD0LCtFOPfbF6VW8j+bL04=;
        b=fvAqKciZEoDVPp6/rqIQ492SSAc+hQhjpJvTE45I1Ud/TWnHl0pBfzK77tMA6rwEuXF41Q
        5j1Gu1r2tz+R0HA7j4I96nI2TfkkO0fZIUMMmQWauc3ThTPQI6uxNTJImJA7f6B+uNyQjB
        oXyP2kzsKI7TcJ8w5FJy0Wv/0H2exiDJ1q4vQTBqeQj3vg5D7DksMiFDQPqcqiN8iGs6ac
        33vk7S8zLRnlheE9FHM53nUoX1gBlzL1hIM5n20WDQL9Wqh1Ya06IpOW0Z35Xdll2Qgrdp
        q+KkbeCrcgVTzxQePU2QZwx4B7uz8eDMHhEMQkYCxxatR+9MRX403oLmhMYQMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636381305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJTwkzJ4qB0w0zmGfeACIoD0LCtFOPfbF6VW8j+bL04=;
        b=3M1JBo0nlc8tEo/+Fjk0kYZTX9C5t7u5xrKun6npBiWqUOmajPnQtEf6ai38a+8MxL/y0n
        Y7tb2DzDNFtVeUCQ==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
References: <20211105153648.8337-1-bage@linutronix.de>
 <YYV40/2N+2j02V/f@lunn.ch>
From:   Bastian Germann <bage@linutronix.de>
Message-ID: <b4379bb7-0529-39d7-1ec7-9dc2bf834aaf@linutronix.de>
Date:   Mon, 8 Nov 2021 15:21:45 +0100
MIME-Version: 1.0
In-Reply-To: <YYV40/2N+2j02V/f@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 05.11.21 um 19:32 schrieb Andrew Lunn:
> What PHY driver are you using this with? phy_start_aneg() generally
> does not return errors, except for -EIO/-TIMEDOUT because
> communication with the PHY has failed. All parameter validation should
> of already happened before the call to phy_start_aneg(). So i'm
> wondering if the PHY driver is doing something wrong.

I am modifying broadcom phy and will make sure that I will end up nut having
error checks in the wrong place.
