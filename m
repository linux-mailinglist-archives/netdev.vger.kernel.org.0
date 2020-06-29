Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E06920D2D9
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgF2Sw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729811AbgF2Sww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A52C030F12;
        Mon, 29 Jun 2020 09:23:11 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 422C622F00;
        Mon, 29 Jun 2020 18:23:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593447787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X18uV1euoyAr2LBLs5EZ6JIf3ILwv/cAekPE3bunnnY=;
        b=FX+Q+Kq9mgGQO43EUJ7QgOHxnwIyR7cj6O+Z5kdqFf2q+28H+jsC3RQbTT/EAMAvA35c75
        UmAkVEDS+V4CpGVqtJ5J0N+KoRtTiutk9CKsM7inGwUPKXaWtOr7Z5czNYAJaP1do3F0SS
        4iCb2lASXK3mstjI+DiAmDggAlgbJ4E=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Jun 2020 18:23:07 +0200
From:   Michael Walle <michael@walle.cc>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org,
        dl-linux-imx <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
In-Reply-To: <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <9dc13a697c246a5c7c53bdd89df7d3c7@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> I've cleaned up the patches a bit, can you test this branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=flexcan

This is working, but as Joakim already said, CAN-FD ISO mode is missing.
It defaults to non-ISO mode, which is even worse, IMHO.

But I've also noticed a difference between the original patch and the
one in that branch. When FD mode is enabled the original patch checks
the priv->can.controlmode [1], the patch in the branch looks at
priv->can.ctrlmode_supported instead [2], is that correct?

-michael

[1] 
https://lore.kernel.org/netdev/20190712075926.7357-4-qiangqing.zhang@nxp.com/
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/tree/drivers/net/can/flexcan.c?h=flexcan&id=5f097cd65cb2b42b88e6e1eb186f6a8f0c90559b#n1341
