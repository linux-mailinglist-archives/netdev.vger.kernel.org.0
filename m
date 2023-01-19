Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19FF674BEC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjATFPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjATFOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1923D2B2A9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F69B82332
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FA7C433EF;
        Thu, 19 Jan 2023 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674136023;
        bh=0jKgDLn5aq3MZ8zsqc8JEsbQdyOkcPBUObZp2DyL8Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ng9G8tGYTH0m2Xe/cLc1uyfAAC2/M4kznAj87zcs4kio+gwEDkKRAT9fP5/gWups+
         QobLfjy7yxwG1cu2FpAmnvcOsA6DiRlaeN7fFMOhk6JyDJCZ+0CtOq8TQCgTxuS9PD
         DM+yqybG6xIypGH3xpDvvaSebWgz/YmqqDbl7TfU=
Date:   Thu, 19 Jan 2023 14:47:01 +0100
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
Subject: Re: [PATCH net-next v2 1/1] ice: use GNSS subsystem instead of TTY
Message-ID: <Y8lJ1QUkudGM8aR2@kroah.com>
References: <20230119005836.2068818-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119005836.2068818-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 04:58:36PM -0800, Tony Nguyen wrote:
> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> 
> Previously support for GNSS was implemented as a TTY driver, it allowed
> to access GNSS receiver on /dev/ttyGNSS_<bus><func>.
> 
> Use generic GNSS subsystem API instead of implementing own TTY driver.
> The receiver is accessible on /dev/gnss<id>. In case of multiple receivers
> in the OS, correct device can be found by enumerating either:
> - /sys/class/net/<eth port>/device/gnss/
> - /sys/class/gnss/gnss<id>/device/
> 
> Using GNSS subsystem is superior to implementing own TTY driver, as the
> GNSS subsystem was designed solely for this purpose. It also implements
> TTY driver but in a common and defined way.
> 
> >From user perspective, there is no difference in communicating with a
> device, except new path to the device shall be used.

If you can handle the fallout from this, ok, that's on you :)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
