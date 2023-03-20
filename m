Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725486C143A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCTOAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjCTN75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:59:57 -0400
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Mar 2023 06:59:45 PDT
Received: from pb-smtp1.pobox.com (pb-smtp1.pobox.com [64.147.108.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018B113505;
        Mon, 20 Mar 2023 06:59:44 -0700 (PDT)
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 53A5C18C5B8;
        Mon, 20 Mar 2023 09:43:32 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
        :to:cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=8WqPf8azPw1LdaVLhachWnBqIWRZmkRgYIXr7n
        BOEVI=; b=mwAXUP+vw1gFjyfea+hAmsVYwaDZqKnmTUGqltfpOBZg23LkRPyj1E
        NNgUz2Nm4vzaIWs1GoQPFF/Yy3qtKWPBUU0Vsp1dnExonNA71EHY01v3rq2FQ6cd
        qnTrv0VKt5Id6O5JwaYXGcX6Mrw1qN6k/UYW48uVQJCmj4MePGFxc=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 4990D18C5B7;
        Mon, 20 Mar 2023 09:43:32 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=8WqPf8azPw1LdaVLhachWnBqIWRZmkRgYIXr7nBOEVI=; b=gtXr8MBEDJO4uccNonSi075UIrgrLbaVTCSMr2gNKrxEvd3H2jIsQ8g57SS3jeQrx59ljm/s3vj2dYa7ileHM3fKtDJYZuydKggReM9ztjAsS1EOOXPcL/I9BZ25QBPoeOf8W7rxbpNLZufNEjPYaj5Ry/w8j5R7+IfCqPk8ORo=
Received: from yoda.home (unknown [96.21.170.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id AE26F18C5B6;
        Mon, 20 Mar 2023 09:43:31 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 94C296C31B7;
        Mon, 20 Mar 2023 09:43:30 -0400 (EDT)
Date:   Mon, 20 Mar 2023 09:43:30 -0400 (EDT)
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
In-Reply-To: <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
Message-ID: <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
References: <20230313030239.886816-1-tianfei.zhang@intel.com> <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org> <ZBBQpwGhXK/YYGCB@smile.fi.intel.com> <ZBDPKA7968sWd0+P@hoboy.vegasvil.org> <ZBHPTz8yH57N1g8J@smile.fi.intel.com> <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 33EE8612-C725-11ED-B5B2-B449C2D8090B-78420484!pb-smtp1.pobox.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023, Andy Shevchenko wrote:

> On Wed, Mar 15, 2023 at 10:37:58AM -0400, Nicolas Pitre wrote:
> > On Wed, 15 Mar 2023, Andy Shevchenko wrote:
> > > On Tue, Mar 14, 2023 at 12:46:48PM -0700, Richard Cochran wrote:
> > > > On Tue, Mar 14, 2023 at 12:47:03PM +0200, Andy Shevchenko wrote:
> > > > > The semantics of the above is similar to gpiod_get_optional() and since NULL
> > > > > is a valid return in such cases, the PTP has to handle this transparently to
> > > > > the user. Otherwise it's badly designed API which has to be fixed.
> > > > 
> > > > Does it now?  Whatever.
> > > > 
> > > > > TL;DR: If I'm mistaken, I would like to know why.
> > > > 
> > > > git log.  git blame.
> > > > 
> > > > Get to know the tools of trade.
> > > 
> > > So, the culprit seems the commit d1cbfd771ce8 ("ptp_clock: Allow for it
> > > to be optional") which did it half way.
> > > 
> > > Now I would like to know why the good idea got bad implementation.
> > > 
> > > Nicolas?
> > 
> > I'd be happy to help but as presented I simply don't know what you're 
> > talking about. Please give me more context.
> 
> When your change introduced the optionality of the above mentioned API,
> i.e. ptp_clock_register(), the function started returning NULL, which
> is fine. What's not in my opinion is to ask individual drivers to handle it.
> That said, if we take a look at gpiod_*_optional() or clk_*_optional()
> we may notice that they handle NULL as a valid parameter (object) to their
> respective APIs and individual drivers shouldn't take care about that.
> 
> Why PTP is so special?

To my knowledge it is not.

The current arrangement has apparently worked well for more than 6 
years. If you see a better way you're welcome to submit patches as 
usual.

Alternatively the above commit can be reverted if no one else 
cares. I personally gave up on the idea of a slimmed down Linux kernel a 
while ago.


Nicolas
