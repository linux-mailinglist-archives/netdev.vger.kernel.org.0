Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6751C645646
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiLGJQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiLGJQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:16:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560A92CE15
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED6F6B8013C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306DAC433D6;
        Wed,  7 Dec 2022 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670404550;
        bh=tiCuLh7ePXtppm4S+qJKNHvU9LhjpIATWhzzO5cPyBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEjqXpEUHXluvV5T7OLvwgsMDjvGcyJllfUT5dlW/dj0aeS44TA2kbZIoO4PDP0Sj
         S4om1ac9Ox7R56/56voZwJDJYw4wNT3laYn8odk4W+vkX+UVtw2dqBUJjXSbNcJAS4
         n82lS0cN1Upmip0720rKxzW2Vl9OASCP3h+Wqkl2ezxvNbYS+N/IBGN0WWo5woDKZ6
         0HqC6yu1RAnIPMyhZ9vTH9o5bDnhcsnDwzONQYw/GNWINFHr9SDX2TRwFRXP/oNpP4
         r90rCUK7GWwf+P3/xPP5eLr5/7sloBmnCKfHfcTyKTxUR8YqOglOYrKZ9MdJoKYPRc
         3j3tLIgqAFskQ==
Date:   Wed, 7 Dec 2022 11:15:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, karol.kolacinski@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ice: Fix potential memory leak in
 ice_gnss_tty_write()
Message-ID: <Y5BZwvttqgR2HBvF@unreal>
References: <20221207085502.124810-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207085502.124810-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 08:55:02AM +0000, Yuan Can wrote:
> The ice_gnss_tty_write() return directly if the write_buf alloc failed,
> leaking the cmd_buf.
> 
> Fix by free cmd_buf if write_buf alloc failed.
> 
> Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
