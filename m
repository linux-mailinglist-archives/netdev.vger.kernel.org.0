Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DE24CAADB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiCBQza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiCBQz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:55:29 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 08:54:43 PST
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CE355BDD
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:54:42 -0800 (PST)
Received: (qmail 99897 invoked by uid 89); 2 Mar 2022 16:48:02 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 2 Mar 2022 16:48:02 -0000
Date:   Wed, 2 Mar 2022 08:48:00 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
Message-ID: <20220302164800.fdfnmutc7f7zb3ek@bsd-mbp.dhcp.thefacebook.com>
References: <20220228203957.367371-1-jonathan.lemon@gmail.com>
 <20220301182153.6a1a8e89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301182153.6a1a8e89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 06:21:53PM -0800, Jakub Kicinski wrote:
> On Mon, 28 Feb 2022 12:39:57 -0800 Jonathan Lemon wrote:
> > In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
> > ns adjustment was written to the FPGA register, so the clock could
> > accurately perform adjustments.
> > 
> > However, the adjtime() call passes in a s64, while the clock adjustment
> > registers use a s32.  When trying to perform adjustments with a large
> > value (37 sec), things fail.
> > 
> > Examine the incoming delta, and if larger than 1 sec, use the original
> > (coarse) adjustment method.  If smaller than 1 sec, then allow the
> > FPGA to fold in the changes over a 1 second window.
> > 
> > Fixes: 6d59d4fa1789 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> This one's tagged for net-next - do you intend for it to go to net-next,
> or is that a typo?

I build and test net-next, so that was my target.
-- 
Jonathan
