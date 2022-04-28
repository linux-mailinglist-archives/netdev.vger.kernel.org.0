Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88A5512AC5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 07:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiD1FGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 01:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiD1FGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 01:06:15 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855C73616F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 22:03:01 -0700 (PDT)
Received: (qmail 46695 invoked by uid 89); 28 Apr 2022 05:02:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 28 Apr 2022 05:02:59 -0000
Date:   Wed, 27 Apr 2022 22:02:57 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220428050257.wfo55kbjv3ytgq5i@bsd-mbp>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220427144025.GA23991@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427144025.GA23991@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 07:40:25AM -0700, Richard Cochran wrote:
> On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:
> 
> > +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
> > +				  s64 delta_ns)
> > +{
> > +	struct timespec64 ts;
> > +	int err;
> > +
> > +	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
> > +	if (!err) {
> > +		timespec64_add_ns(&ts, delta_ns);
> 
> When delta_ns is negative, this takes a long time to complete.

Hmm, just looked up the function signature - addend is u64, sigh.  Will
fix in next patch.

Thanks for pointing that out!
--
Jonathan
