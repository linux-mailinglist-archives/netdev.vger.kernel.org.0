Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5815650BF36
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiDVSCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiDVR63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09ADE1CC5;
        Fri, 22 Apr 2022 10:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9CA260C4F;
        Fri, 22 Apr 2022 17:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE67C385A0;
        Fri, 22 Apr 2022 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650649710;
        bh=5eG88j23VfpqEXG5LElKEOANPUif8PLVVEOgW3NWPM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JFxldeSwtEKgk9Lc8kRCQDX6OUJaNJqjczwvWjMV4j3OqtctIRIdLWhgVFbHcrF3q
         6RV2w/ktTedzqZubriC/58H3Vdm9JiPVMTZntT5U6PsWNK7vp6Lf1pJVILEyJGxmS+
         qbW6cqz9aSs5BypgxKnfiub0ZMs/SwHrot2cRn1CQZuR4f0sF4Z4oMH0Z+a459fUj/
         AqyDYdPlcTk4kUXYFN7XRqxWUhAFDdRXCLT5AegHPef/SkanQTZdABcipo326XcIeu
         cDK0+ZCKSi/1Lz6pPb+mOUQxdS1svIyOTdYSc7OWhpV+sUpJYcDte2V/RzhDmTOY++
         fOwXTN8nCbK0w==
Date:   Fri, 22 Apr 2022 10:48:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Chas Williams <3chas3@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/7] Remove unused SLOW_DOWN_IO
Message-ID: <20220422104828.75c726d0@kernel.org>
In-Reply-To: <20220415190817.842864-1-helgaas@kernel.org>
References: <20220415190817.842864-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 14:08:10 -0500 Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Only alpha, ia64, powerpc, and sh define SLOW_DOWN_IO, and there are no
> actual uses of it.  The few references to it are in situations that are
> themselves unused.  Remove them all.
> 
> It should be safe to apply these independently and in any order.  The only
> place SLOW_DOWN_IO is used at all is the lmc_var.h definition of DELAY,
> which is itself never used.

Hi Bojrn! Would you mind reposting just patches 1 and 3 for networking?
LMC got removed in net-next (commit a5b116a0fa90 ("net: wan: remove the
lanmedia (lmc) driver")) so the entire series fails to apply and therefore 
defeats all of our patch handling scripts :S
