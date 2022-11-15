Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9238E62AE91
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbiKOWsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiKOWrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:47:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC301F2D7;
        Tue, 15 Nov 2022 14:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA38EB81B7B;
        Tue, 15 Nov 2022 22:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6224EC433C1;
        Tue, 15 Nov 2022 22:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668552451;
        bh=FVtkGAY1agD6x6FvaQ5OTZC8CoIkCE/YUdYT3PiCxOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q43itfk5jx6wMDHpNS2hA6xdTXfvyhAFJQ1cWKro6sRLvNlUHSEjF0GD4F2TP2vD1
         HnMOCHrmlMfCo2j3EudOB+E0nhIopNqURIrE62jDN0AbjkKCvGDLbUTn737pZ3SnTe
         GKhkpYTPkDzWjXLToDbEW3CoHbsBI4QoAqKJmTqnsHrxeIIh9CmGjWYk+GiSURW3t2
         gMKaTRvkQ4oVMsjsbnHelcCdBFJ0gZCmCOdlCGokIg2JpGTmkILp3ot8SIzK9fYgKd
         nDw7dxaat7khQxps7+fhLDz+BMQAkCcuMMEeT0Dxk31CwcxrRrd45scEz9jso+j7QQ
         SJi2/vXlh/7hw==
Date:   Tue, 15 Nov 2022 14:47:26 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/3] can: etas_es58x: export firmware, bootloader and
 hardware versions in sysfs
Message-ID: <Y3QW/ufhuYnHWcli@x130.lan>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221113040108.68249-3-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Nov 13:01, Vincent Mailhol wrote:
>ES58x devices report below information in their usb product info
>string:
>
>  * the firmware version
>  * the bootloader version
>  * the hardware revision
>
>Parse this string, store the results in struct es58x_dev and create
>three new sysfs entries.
>

will this be the /sys/class/net/XXX sysfs  ?

We try to avoid adding device specific entries in there,

Couldn't you just squeeze the firmware and hw version into the 
ethtool->drvinfo->fw_version

something like: 
fw_version: %3u.%3u.%3u (%c.%3u.%3u)

and bootloader into ethtool->drvinfo->erom_version: 
  * @erom_version: Expansion ROM version string; may be an empty string

