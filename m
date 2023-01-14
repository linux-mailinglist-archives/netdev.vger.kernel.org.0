Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAE666A9C6
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 08:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjANHD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 02:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjANHDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 02:03:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEB546BD
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 23:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41F93601CD
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDB1C433EF;
        Sat, 14 Jan 2023 07:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673679801;
        bh=uzKzNeCSUPjGdV4cbGi8BSZG3BEaTcsPhqSgI1zs/Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DiDqCSdme0TN5+gQKjWoN9BFOvad1c/0EUgbHla0SKnV1Gy/HBJ09CwOXK4FuGzw4
         AgdCWKkUAZwuVWaz8P2X1lSN6rnTrzLr1ElsnPctGKgWf5VdB2XWE+6H7KSVncytvi
         ebk5wQVEdhbl5OEGpkaJ5m8e9BSVm1TKRFmUDnAw=
Date:   Sat, 14 Jan 2023 08:03:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, johan@kernel.org, jirislaby@kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Message-ID: <Y8JTsxcUsZHG2AHU@kroah.com>
References: <20230113214852.970949-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113214852.970949-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 01:48:52PM -0800, Tony Nguyen wrote:
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

You are saying what you are doing, but not anything about _why_ this
change is the correct one.

You are also breaking a user/kernel api here, how is existing users
going to handle the tty device node going away?  What userspace tools
are going to break and how are you going to handle that?

While overall I like the idea here, you aren't really providing any
justification for it at all.

thanks,

greg k-h
