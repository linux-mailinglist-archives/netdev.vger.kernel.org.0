Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5366DB801
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 03:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjDHBdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 21:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDHBdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 21:33:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4968D113CB;
        Fri,  7 Apr 2023 18:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADCE864872;
        Sat,  8 Apr 2023 01:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5885C433D2;
        Sat,  8 Apr 2023 01:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680917592;
        bh=Yr29bLblMMqpSP/0qtaO2BQyCduJAqsFlOcCVtbTMWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lCjwYoZDktIRWhat7yIW44x8WOkGg1Zo6SH635BASi/8IteFMVdBm3OxrJjgBwrtz
         KGcZbzFnRQ2miF+uJ7vmOO2PnpdcZ0rh0+8+iDZ+nKTzG8h8ZEeAm4a9xO8RUZhNVQ
         UTzHLYzdi4axmG0ZoRRGwsaY0rgqMuQFt3ms5TSSxQ3YmV47VAR+v/ZqXg72BAqo8b
         CsZA/Ztx/hq27X+EWztsKvptVf4YgA3eb+HmczDmxjZF9MddLvaGjp9zIiyGcZPFU/
         LxzZ5wWO2WFCwogWeY/8+hu1/q/MHe0dUVAdMueHrtwCB4bpy4PmOcf8h88Rs0B65Z
         w+aZgRk5ehaYw==
Date:   Fri, 7 Apr 2023 18:33:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: bluetooth 2023-04-07
Message-ID: <20230407183310.3bfc4044@kernel.org>
In-Reply-To: <20230407193201.3430140-1-luiz.dentz@gmail.com>
References: <20230407193201.3430140-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Apr 2023 12:32:01 -0700 Luiz Augusto von Dentz wrote:
> The following changes since commit b9881d9a761a7e078c394ff8e30e1659d74f898f:
> 
>   Merge branch 'bonding-ns-validation-fixes' (2023-04-07 08:47:20 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-04-07
> 
> for you to fetch changes up to 501455403627300b45e33d41e0730f862618449b:
> 
>   Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp} (2023-04-07 12:18:09 -0700)
> 
> ----------------------------------------------------------------
> bluetooth pull request for net:
> 
>  - Fix not setting Dath Path for broadcast sink
>  - Fix not cleaning up on LE Connection failure
>  - SCO: Fix possible circular locking dependency
>  - L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
>  - Fix race condition in hidp_session_thread
>  - btbcm: Fix logic error in forming the board name
>  - btbcm: Fix use after free in btsdio_remove

Looks like we got a Fixes tag issue (Fixes: Fixes: 8e8b92ee60de... )
and clang is not on-board:

net/bluetooth/hci_conn.c:1214:7: warning: variable 'params' is uninitialized when used here [-Wuninitialized]
            (params && params->explicit_connect))
             ^~~~~~
net/bluetooth/hci_conn.c:1203:32: note: initialize the variable 'params' to silence this warning
        struct hci_conn_params *params;
                                      ^
