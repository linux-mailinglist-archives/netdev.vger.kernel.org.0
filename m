Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4A6A26D3
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 03:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBYChD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 21:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYChC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 21:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB94068690
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 571AD618F4
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 02:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F942C433EF;
        Sat, 25 Feb 2023 02:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677292620;
        bh=ubfuAtAsFNJIO9GBD/YjYHj6r/N9KPvDBiTSJvT7AHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcAPynrulwrfC+6fJm/KbH8tQBaQDKCD2Rf4wbF1ilkgS5L6DuWJS+ctcMPKlRgqd
         HVxepdFu70+3jJhqQdEd6wTYB8cD/v8ksYDbUZM7IeCfSZpOXIDeGM0FvDFcgmtOXR
         juC/JsYmMDBxiFiIYuR2vnZxpZC+cQZs3mYgG+BikjU0q9olW8CDeNa9i2J/d13yuG
         YHMUf7SlagH7f1EJdBMkwRweJslWYtulJwPyfSJcFWpThGCePkPe+fKHHCRwdHurC0
         JHudO2Ne2YnzeErzFoPGzTWdcEMaU58Q/yVM2SEBloZV26vZz24fXMhLG1J3ah8gGj
         e/AzgGWhW/Hiw==
Date:   Fri, 24 Feb 2023 18:36:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Assign XPS map to correct queue index
Message-ID: <20230224183659.2a7bfeea@kernel.org>
In-Reply-To: <20230223153944.44969-1-nnac123@linux.ibm.com>
References: <20230223153944.44969-1-nnac123@linux.ibm.com>
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

On Thu, 23 Feb 2023 09:39:44 -0600 Nick Child wrote:
> When setting the XPS map value for TX queues, use the index of the
> transmit queue.
> Previously, the function was passing the index of the loop that iterates
> over all queues (RX and TX). This was causing invalid XPS map values.
> 
> Fixes: 6831582937bd ("ibmvnic: Toggle between queue types in affinity mapping")
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>

Applied, thanks!

> I am a little surprised that __netif_set_xps_queue() did not complain that some
> index values were greater than the number of tx queues. Though maybe the function
> assumes that the developers are wise enough :)
> 
> Should __netif_set_xps_queue() have a check that index < dev->num_tx_queues?

Seems reasonable. Let's wait for the merge window to be over and feel
free to send a patch.
