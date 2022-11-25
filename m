Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5362D639135
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiKYVo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYVo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:44:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF3B3D92B;
        Fri, 25 Nov 2022 13:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hYAG56+zJm4XQvfRDhNeFug+RP2UD1TPvSMqSSM2GXw=; b=Q/46qfVvmSUXF8RJZpdUcsUm0h
        omZ+iGg/bSlJKefdLaN1aicOdvobGqIoaV9bAZ4gz/TIOhMbc5mYc52oWhcqeKfhaMSNFY0bAmuSD
        9GvpbJX72g6DJ+VN6c7LJEDtl1Xx7ydJ500Mqbp6JKBsqk+CP5Rn8AOapVbGqEYQOwx0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oygU4-003SvS-DY; Fri, 25 Nov 2022 22:43:44 +0100
Date:   Fri, 25 Nov 2022 22:43:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Message-ID: <Y4E3EOTXTE0PuY6B@lunn.ch>
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125041206.1883833-2-xiaolei.wang@windriver.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 12:12:06PM +0800, Xiaolei Wang wrote:
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspend and resume, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
>   WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>   Modules linked in:
>   CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>   Hardware name: Freescale i.MX6 SoloX (Device Tree)
>   Workqueue: events_power_efficient phy_state_machine
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x68/0x90
>   dump_stack_lvl from __warn+0xb4/0x24c
>   __warn from warn_slowpath_fmt+0x5c/0xd8
>   warn_slowpath_fmt from phy_error+0x20/0x68
>   phy_error from phy_state_machine+0x22c/0x23c
>   phy_state_machine from process_one_work+0x288/0x744
>   process_one_work from worker_thread+0x3c/0x500
>   worker_thread from kthread+0xf0/0x114
>   kthread from ret_from_fork+0x14/0x28
>   Exception stack(0xf0951fb0 to 0xf0951ff8)
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>

This needs Florians review, since for v1 he thinks it will cause
regressions.

	Andrew
