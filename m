Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC24EEDF6
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbiDANUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346265AbiDANUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:20:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DB1527E8
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=jpqQygaBCAUEGKFvz2G5xMnERn9VrPbFcWpgC5YH//A=; b=gt
        0YnBkwxOKTGcnXDBxpcESF31GDy26VoLP0j8mEC40IuGhZe/CdSwArDiJVy63HtcuNbsSe5FeI9R1
        vH1phiTdof4DKlip69137c6Mt+tonOf4fqU0NTGHKCweg3D3+CfB60zke/ij4qfn3j4oxG5jR+joy
        Lfv2CETmKoeYHHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naHAp-00Dfy6-LX; Fri, 01 Apr 2022 15:18:43 +0200
Date:   Fri, 1 Apr 2022 15:18:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>,
        Danie du Toit <danie.dutoit@corigine.com>
Subject: Re: [PATCH net] nfp: do not use driver_data to index device info
Message-ID: <Ykb7s+uysncYGb0t@lunn.ch>
References: <20220401111936.92777-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401111936.92777-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 01:19:36PM +0200, Simon Horman wrote:
> From: Niklas Söderlund <niklas.soderlund@corigine.com>
> 
> When adding support for multiple chips the struct pci_device_id
> driver_data field was used to hold a index to lookup chip device
> specific information from a table. This works but creates a regressions
> for users who uses /sys/bus/pci/drivers/nfp_netvf/new_id.
> 
> For example, before the change writing "19ee 6003" to new_id was
> sufficient but after one needs to write enough fields to be able to also
> match on the driver_data field, "19ee 6003 19ee ffffffff ffffffff 0 1".
> 
> The usage of driver_data field was only a convenience and in the belief
> the driver_data field was private to the driver and not exposed in
> anyway to users. Changing the device info lookup to a function that
> translates from struct pci_device_id device field instead works just as
> well and removes the user facing regression.
> 
> As a bonus the enum and table with lookup information can be moved out
> from a shared header file to the only file where it's used.
> 
> Reported-by: Danie du Toit <danie.dutoit@corigine.com>
> Fixes: e900db704c8512bc ("nfp: parametrize QCP offset/size using dev_info")
> Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>

Hi Simon

This is missing your own Signed-off-by:

     Andrew
