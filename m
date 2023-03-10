Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60BA6B36A5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCJG3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCJG3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:29:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143EF98870;
        Thu,  9 Mar 2023 22:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C68C5B82144;
        Fri, 10 Mar 2023 06:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27508C433D2;
        Fri, 10 Mar 2023 06:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678429745;
        bh=wxoHnqj6usYq7SUznyfPafcPyI+F4fVBd0DujJ9QAUA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QyUQ29LQE9vmftXjtp+JZGXHDv5spJUHtEZkIILId9qoj3fdDMFnq7PufzEv9rALB
         jVesJ0g4irS1j4IOwMveXFvbCWaDrNcqAdUbwwJSZdjNtF+ReDy1XZKlabvxVBlDIo
         r48V/BF+9RDXGJDAzXYjTsbH12t510Pt5Szpuabu4Xoqk/dhINnLuoHgHk5CUoRR72
         5nfOye7WllKoEsZKuZqdUuz0u61ugNvNhTKk9bl/i86mN/4yByfltrgQnAxMEscn3P
         igXM+XdZovCTrMOvmabaTVd0WZ+vKTjlO9fwXA0AFrkGTXGOSzOiSZQKiuw+bBeesR
         g836LMYowVShg==
Date:   Thu, 9 Mar 2023 22:29:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 net 2/2] net: asix: init mdiobus from one function
Message-ID: <20230309222904.195e889d@kernel.org>
In-Reply-To: <20230309221646.75f97f21@kernel.org>
References: <20230308202159.2419227-1-grundler@chromium.org>
        <20230308202159.2419227-2-grundler@chromium.org>
        <ZAnBCQsv7tTBIUP1@nanopsycho>
        <CANEJEGuK-=tTBXG6FpC4aBb7KbsNZng2-Rmi0k6BJJ7An=Pyxw@mail.gmail.com>
        <07dd1c76-68a1-4c2f-98fe-7c25118eaff9@lunn.ch>
        <CANEJEGurX3Kr30Dv5_LzxN+shYuWXxxbEJG1MOgOOhpAq1WzLA@mail.gmail.com>
        <20230309221646.75f97f21@kernel.org>
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

On Thu, 9 Mar 2023 22:16:46 -0800 Jakub Kicinski wrote:
>  I'll take patch 1 in now,

Sorry, I need to take that back.

Don't the error paths in ax88772_bind() need to be updated to call
ax88772_mdio_unregister() now?
