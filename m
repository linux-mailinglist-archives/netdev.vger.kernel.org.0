Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334424DA796
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353025AbiCPBxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353046AbiCPBwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A894A5E173
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A410B818CF
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D125BC340E8;
        Wed, 16 Mar 2022 01:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647395496;
        bh=qWiZ7MgEidk3rQ7iE08d9K3sxnTtctClBLr9W0F3PKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I4ehLbmDyGBZpfV9L4rZzcDC8wAt6yhMO7LZWgXv/iKtyPz95dxcdir0pPMFSzplt
         INO6+og+1ZsJl+FSBhI1tBKmxvbCcKRGauVIoM0MskTyLpUHKUy6Y9aFhje5MsUO0/
         /jYx38gkldHoGpYQ4vndVLenPnW/GR2QwBJDfZlIkKYEGRwh1cioT+CixWX/SiLuh+
         GBNXcRz6XFdVTd1jHCC561rpbjwmq/464PvQEjZjQUq7U/yii+hpBEYzCI7Dr8K2k6
         h3OpPHvdkWhlBWgK0geIXM4agc4okoWOg4emoVjRMr+HFSmYMMwoyipCyikyl2orGE
         iU+xW3QlCO9FQ==
Date:   Tue, 15 Mar 2022 18:51:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315203748.1892-1-socketcan@hartkopp.net>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 21:37:48 +0100 Oliver Hartkopp wrote:
> Syzbot created an environment that lead to a state machine status that
> can not be reached with a compliant CAN ID address configuration.
> The provided address information consisted of CAN ID 0x6000001 and 0xC28001
> which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> 
> Sanitize the SFF/EFF CAN ID values before performing the address checks.
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

CC Marc, please make sure you CC maintainers.
