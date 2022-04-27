Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A80D511FF3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiD0P6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiD0P63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91C737BD;
        Wed, 27 Apr 2022 08:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 950EC61B0C;
        Wed, 27 Apr 2022 15:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C325CC385AC;
        Wed, 27 Apr 2022 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074904;
        bh=Piko2fouUlHnnl1uG5umbKhIYMeTrewPG6CLc18H38o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SRtRFUxFKtCdBTtyse0uGH/a7eJz+F73+BB1OV8HvPvfXjks7MS3J/ViyoWllU5jk
         uHVJ6aVDQlgc+v+gsNDzYoCnj8uxFX4anMZlCDL+j7Pj3m+frmrGn3t3ji69RH/wKG
         0JIpTJJ87NqotwhpZg2ulvrAAWJngXByonMKI2j1WddU+bhAAsDfme51MbXliUwEy3
         GB6wcD3wH1GcVrDmA+574OsOdDHiWLklmzq2buYznqINMy6N5TrTkGH1Dl3XjA25uz
         dnnlFDTupCxHYfRimfwJ5p5piFR0wfqYv8I5woNuP5FJKFOiI6uK33G6ITjcf3Tpdl
         MuCMWly4yRyUQ==
Date:   Wed, 27 Apr 2022 08:55:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220427085502.719366ad@kernel.org>
In-Reply-To: <OS3PR01MB6593BE917485C87E32D1E5FDBAFA9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
        <20220426142150.47b057a3@kernel.org>
        <OS3PR01MB6593BE917485C87E32D1E5FDBAFA9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
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

On Wed, 27 Apr 2022 14:32:03 +0000 Min Li wrote:
> > On Tue, 26 Apr 2022 15:32:53 -0400 Min Li wrote:  
> > > Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY for  
> > gettime  
> > > and settime exclusively  
> > 
> > Does not build on 32 bit.
> >   
> 
> Hi Jakub
> 
> I compiled with arm-linux-gnueabi-
> 
> By 32 bit, did you mean x86?

Yup! I think arm does not have the 64b division problems x86 has.
We hit the dreaded 

ERROR: modpost: "__divdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!
ERROR: modpost: "__udivdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!

on 32b x86 builds. Sorry for lack of clarity.
