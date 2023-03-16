Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD56BDA6C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCPUwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCPUwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:52:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61E16E68B;
        Thu, 16 Mar 2023 13:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E495CCE1EB3;
        Thu, 16 Mar 2023 20:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD46C433EF;
        Thu, 16 Mar 2023 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678999959;
        bh=RqbnUWeY+HYBi3rHUEQbPvSQ2IN0wd86FyHyKmwfTM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHQHY0t842wTFvilHYo/g5r2sWYVsM1iTPo5+znFm1Mxharke9JAcHQ2zLGaCg4c5
         7LeHdVjNTTOhiAzo4/Lqdlttt6KUBgl34owX4vKVCa4c9Rq47usaHN6/jcAd+df+hs
         2HEwFnaS5zF0rMdG20On0cUDvPoALqlBF94cBgajJDfh+rBQ8Qqml7hCIi6+q3SIAf
         4kznm6Ig7SjzG9vDJsafF5DQqUNZr23/KlruFAeRh4W8zPKysEQ9PF/GK3rIq8mlfM
         N+5e/xPE7Q2B3mIr/wUj6BUEFqyevoPNSuhMt0ly/0ENQ0hMMnYugQKWNrM6LuGk9e
         JnRNO8Tz63Q5w==
Date:   Thu, 16 Mar 2023 13:52:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: smsc95xx: Limit packet length to skb->len
Message-ID: <20230316135237.3052d98c@kernel.org>
In-Reply-To: <20230316101954.75836-1-szymon.heidrich@gmail.com>
References: <20230315212425.12cb48ca@kernel.org>
        <20230316101954.75836-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 11:19:54 +0100 Szymon Heidrich wrote:
> Packet length retrieved from descriptor may be larger than
> the actual socket buffer length. In such case the cloned
> skb passed up the network stack will leak kernel memory contents.
> 
> Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
