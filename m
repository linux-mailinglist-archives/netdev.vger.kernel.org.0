Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B128B6A49CC
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjB0Scl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjB0Scf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:32:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65762449B;
        Mon, 27 Feb 2023 10:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77A19B80CA7;
        Mon, 27 Feb 2023 18:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAB5C4339C;
        Mon, 27 Feb 2023 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677522751;
        bh=TRYkcK6dGjq95G4Hqar17zQJsonjNZbS83j5jQWF9xU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rLx+SYB13VzG7b8YfE/9dIKS0w68O7VHFGIv1Wyhkrq21VkwVuWDGLYkD0mBOdNBP
         NeUvZ2t/v9vigy6OtEQCLuK8Gj7DU8y+g6BYtdXQbyE8RVV1TudkaRFP0Leu7xaDUZ
         tFPY9tNiVRBFsZqIyFmpEAjW1Gaa41iJe71W8azwttyg7UOqYj9mb4BAIJkvtQicI2
         gtJXMkIFJ/GvkL/MxrPm/5UG++cFg9eNw8n/neXanZkhlnL3rg048ETYWMwDlXtEDi
         Zj7YSW55AalqizmdCg3ObuoKMeoosZTLLTviP3d+dDOf95cL9khS5yAPrcA0Ozq/HJ
         T6RNRpDyFfNZQ==
Date:   Mon, 27 Feb 2023 10:32:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kalle Valo <kvalo@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
Message-ID: <20230227103229.5aed4714@kernel.org>
In-Reply-To: <121c0039-5f0c-7c4e-5b07-9193ed547079@lwfinger.net>
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
        <dff29d82-9c4b-1933-c1c1-a3becf2a0f1f@lwfinger.net>
        <CAHk-=whwDRefJJq0K8bXXSNY3-Zy8=Z3ZiKYh2mOOvfT-MqNhA@mail.gmail.com>
        <121c0039-5f0c-7c4e-5b07-9193ed547079@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Feb 2023 20:09:51 -0600 Larry Finger wrote:
> In case Qt really needs to know what network it is on, what is a better way to 
> detect if the network is on a Wifi device?

Presupposing lack of love for netlink - /sys/class/net/$ifc/uevent
will have DEVTYPE=wlan.
