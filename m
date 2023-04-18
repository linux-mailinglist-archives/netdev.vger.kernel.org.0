Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE06E6D78
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 22:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDRU0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 16:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjDRU0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 16:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34960B759;
        Tue, 18 Apr 2023 13:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4FB762CC2;
        Tue, 18 Apr 2023 20:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D46C433EF;
        Tue, 18 Apr 2023 20:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681849585;
        bh=1WjHlIcHtPNjZY/Sewerb1tSQrMe01/xeT4UdqgsLl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=IH+5grsdebNkBYsU/+25BrWNDiWGllDG9h12eODx09CRTMyI8Ok9DNDH7iByDzYvc
         ngGh0AFGpUt+L6WanOW8dyeaqqz6yb8T/LXShpI0AOKAjbybuouy0po9RLxwtXE/z5
         +uVo9z8ZEWBkLx4kB4eN6UwEHwmDn76wL4TZFzRJRrKsku0ll2YUScO3gYbCHPzDMg
         U4vx6tf449ettYyfGw3AEUSbh5H37hJDH4Xxr+gHAkEWhS35rbilaLfdZ/NlwfBgvJ
         sXP7RQlZPOtndOTkDrFPYlO2wDA+3PV9JLcfSGtafWHldYcWmbDFgLU4WxpQn47ZV4
         9u6tAtmbjNlPQ==
Date:   Tue, 18 Apr 2023 15:26:23 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bjorn@helgaas.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Message-ID: <20230418202623.GA151923@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e068d1a-101e-b3b6-9f8f-f2208433cc29@candelatech.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 11:18:58AM -0700, Ben Greear wrote:
> The CC list in this email is huge, and the dmesg is also large.  I'm going to send the file directly to Bjorn.
> Please let me know if anyone wants to see it, or if I should just reply-all and paste it in...

Thanks, I got the dmesg log and attached it to this bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=217352

I tried to match the earlydump up with the lspci from
https://lore.kernel.org/r/4ff1397e-1d78-bc59-f577-e69024c4c4f3@candelatech.com
but it doesn't seem to match.  Could they be from different systems or
different configs?

Could I trouble you to collect the "sudo lspci -vvxxx" output to match
the pci=earlydump log?  (Or just collect both from the same system)

Bjorn
