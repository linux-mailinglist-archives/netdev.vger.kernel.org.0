Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AE36BB665
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjCOOph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjCOOpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:45:34 -0400
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 07:45:26 PDT
Received: from pb-smtp21.pobox.com (pb-smtp21.pobox.com [173.228.157.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29167EA20;
        Wed, 15 Mar 2023 07:45:26 -0700 (PDT)
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 384A91D921D;
        Wed, 15 Mar 2023 10:38:06 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
        :to:cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=8Ds3JLlU3ZJmZmiZUtD6R+cBbPOkpvU3DsMgfb
        GlsxE=; b=STdy0djzpt9M+ifpcPtYKAY9lP0RddDLxgwwopGzN51qlZ91b6msJG
        K+9atvhSo1ACXR6Xww21ywHUhq0HUCPzKlFNbH5dvhM6/b8Xl1IdE91GFN7UOfCL
        t56gF2HUskyDJMOZf0ZfRs7c4CUnS1HGiqsuPz9pf9SaOZvQudnEc=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 30FE81D921C;
        Wed, 15 Mar 2023 10:38:06 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=8Ds3JLlU3ZJmZmiZUtD6R+cBbPOkpvU3DsMgfbGlsxE=; b=MXktN4i/RMHxvZz5Rv608tCPS5wznBuQh7QgEypXw1REwmwmVBmIfoO75kbtXX/P4SwZIVxmgEtKJWo8nd3ZpqCPqOElgfi15FI86Kn+AQ+q8gIwh0xvYP/0mER9GJTQ+5vzUjMezfDbveJOUsLcbYpQhpWve81esQZ0TIiNPZE=
Received: from yoda.home (unknown [96.21.170.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 03A0C1D9217;
        Wed, 15 Mar 2023 10:38:01 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 766006B15AE;
        Wed, 15 Mar 2023 10:37:58 -0400 (EDT)
Date:   Wed, 15 Mar 2023 10:37:58 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc:     Richard Cochran <richardcochran@gmail.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
In-Reply-To: <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
Message-ID: <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
References: <20230313030239.886816-1-tianfei.zhang@intel.com> <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org> <ZBBQpwGhXK/YYGCB@smile.fi.intel.com> <ZBDPKA7968sWd0+P@hoboy.vegasvil.org> <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: FC851F90-C33E-11ED-BF80-B31D44D1D7AA-78420484!pb-smtp21.pobox.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023, Andy Shevchenko wrote:

> +Cc: Nicolas
> 
> On Tue, Mar 14, 2023 at 12:46:48PM -0700, Richard Cochran wrote:
> > On Tue, Mar 14, 2023 at 12:47:03PM +0200, Andy Shevchenko wrote:
> > > The semantics of the above is similar to gpiod_get_optional() and since NULL
> > > is a valid return in such cases, the PTP has to handle this transparently to
> > > the user. Otherwise it's badly designed API which has to be fixed.
> > 
> > Does it now?  Whatever.
> > 
> > > TL;DR: If I'm mistaken, I would like to know why.
> > 
> > git log.  git blame.
> > 
> > Get to know the tools of trade.
> 
> So, the culprit seems the commit d1cbfd771ce8 ("ptp_clock: Allow for it
> to be optional") which did it half way.
> 
> Now I would like to know why the good idea got bad implementation.
> 
> Nicolas?

I'd be happy to help but as presented I simply don't know what you're 
talking about. Please give me more context.


Nicolas
