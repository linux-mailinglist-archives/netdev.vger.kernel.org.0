Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A94D0AC3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343701AbiCGWO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343689AbiCGWO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EA65714B
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D404A61021
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03778C340E9;
        Mon,  7 Mar 2022 22:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646691240;
        bh=rRV2eMgod/EtX7+LSTAFQBX1oLGoRhPQe1bwvzy73TA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UG5wZuz2Wru7QmA38qja+IzeAK0n8/mWkE9/eHrGSGs4fsIFPX1T1192w5j0kmWKm
         ShwBPemf1wzbsscBV3gotFuDvhqarXd1SoYp9TYPnAf6YHdIgqjuXVKErowtGjJu0E
         yU24tLJO0b6PwjiIOToij4i52EJJxRdaqjsqybm2Afv8pEoNgMXnO7YCdQQVot6r69
         nCflasngs9qJv3hu+SB1n4RJVCxdKu8RqziPXWUotLfWcTwiKX4tlGXkq0kHSulYKC
         fM+4D4TavxO+5b51yNgHgexPT8IKDHCDb6iHBH5df4EU8xzC8GSsETEpVVPzG7OUKl
         MXaHUCMKJ2Ehg==
Date:   Mon, 7 Mar 2022 14:13:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 3/9] bnxt_en: parse result field when NVRAM
 package install fails
Message-ID: <20220307141358.4d52462e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1646470482-13763-4-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
        <1646470482-13763-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Mar 2022 03:54:36 -0500 Michael Chan wrote:
> From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> 
> Instead of always returning -ENOPKG, decode the firmware error
> code further when the HWRM_NVM_INSTALL_UPDATE firmware call fails.
> Return a more suitable error code to userspace and log an error
> in dmesg.

devlink fw flashing allows for the msg to be reported directly 
to the user, that's more friendly than having to scan logs.
