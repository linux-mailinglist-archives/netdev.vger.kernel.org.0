Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9365D65CCD7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 07:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjADGLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 01:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjADGLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 01:11:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203A212D00
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 22:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D06615AC
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6B8C433F0;
        Wed,  4 Jan 2023 06:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672812712;
        bh=NoyzzzWqWIG1J9mKIsxznuUcgjy93Jtr5/WE6RXU6eE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZLWf+zmuK8xaZtygPj092xGalQ3umtoTUcces2doOntge+rLhNHpb1peS+seRjOi
         g064w2rYDgTEdNO7J9hsLpLwEhxKfGBtuZ9QjlynwPNz6gcAWkxDxRS19woFCTdv2O
         onUaKr1Mqj8v7OrO5rceNgM5mmjtR5ZpNJ7EsUcs=
Date:   Wed, 4 Jan 2023 07:11:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        johan@kernel.org, jirislaby@kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [RFC PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Message-ID: <Y7UYpQq/DBCNcKiL@kroah.com>
References: <20221215231047.3595649-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215231047.3595649-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 03:10:47PM -0800, Tony Nguyen wrote:
> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> 
> Previously support for GNSS was implemented as a TTY driver, it allowed
> to access GNSS receiver on /dev/ttyGNSS_<bus><func>.
> 
> Use generic GNSS subsystem API instead of implementing own TTY driver.
> The receiver is accessible on /dev/gnss<id>. In case of multiple
> receivers in the OS, correct device can be found by enumerating either:
> - /sys/class/net/<eth port>/device/gnss/
> - /sys/class/gnss/gnss<id>/device/
> 
> User expecting onboard GNSS receiver support is required to enable
> CONFIG_GNSS=y/m in kernel config.
> 
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> ---
> Based on feedback from:
> https://lore.kernel.org/netdev/20220829220049.333434-4-anthony.l.nguyen@intel.com/

Why is this "RFC"?  What is left to be done to it to warrant that
marking?

thanks,

greg k-h
