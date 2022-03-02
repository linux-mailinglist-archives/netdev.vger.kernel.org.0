Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6104C9B04
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiCBCLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiCBCLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:11:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0C1A6451;
        Tue,  1 Mar 2022 18:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB739B81BEA;
        Wed,  2 Mar 2022 02:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38280C340EE;
        Wed,  2 Mar 2022 02:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187060;
        bh=3NWrbzzJf3bmqtTz+6kp11IuUZCM+DUEgK1dpfqoK0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CC5nTmJoJw0BceCNVu/c0ulePTM3ULAc0ByCAPN8mfXo2jF4Hozo3hEzWWtS9rJfT
         ZFRB0nUy+EOMV9H7n/GQoJFKvhlMe+JTzbMClbXtNKueXd1xql5NStErdUMc6zr/mR
         x/1qE9C0DZdZsV8fPqmiVWaEypyfQTW/kOwjof0cqA/ffbF2rIhowTjOF0pSj8ZQpU
         +gHArPTjIugz5NQ6Wh6mmWsgFIYfLdF/IARVaaO7HINHD48FPO6qcCANR7LCvMXGg/
         5yWKupqGUSzLECwPuY9I1G4LlcRpjt3gkSSARTTVHGN2Af6JOzs5BYQH7hiPNPvvmC
         8qteVMAvguiqw==
Date:   Tue, 1 Mar 2022 18:10:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, lihong.yang@intel.com,
        Jocelyn Falempe <jfalempe@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ice: use msleep instead of mdelay
Message-ID: <20220301181059.27021dbb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <370e9909d8e00d4a1c8abcd405c321fc41646478.1646146125.git.jtoppins@redhat.com>
References: <370e9909d8e00d4a1c8abcd405c321fc41646478.1646146125.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Mar 2022 09:48:45 -0500 Jonathan Toppins wrote:
> Use msleep for long delays instead of spinning in the driver.

You should add the justification for why sleeping / scheduling out 
is okay in these particular spots to the commit message.
