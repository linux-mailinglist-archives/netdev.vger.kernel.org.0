Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3956C2326
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCTUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCTUxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:53:13 -0400
Received: from pb-smtp2.pobox.com (pb-smtp2.pobox.com [64.147.108.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1B02ED5B;
        Mon, 20 Mar 2023 13:53:12 -0700 (PDT)
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id D2DAC18E2B7;
        Mon, 20 Mar 2023 16:53:09 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
        :to:cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=6m4N6/SmwXQWF7Pmy6L/LEeqvAD9uuUrYSrmRh
        lA9/k=; b=VxWJeKq4YEMhHAVmuAYmqX0/8B+iltVzs9c9pu0OsXNsfKxsE2tN2D
        lNHLXmrvHlEg46K4UrfpXeVCHOQ6hx8Mg0osIo7AtWloAnK0lOGFFzhkEigBgN7F
        DZ2Ox/+U9ofx2WrXse3u0rw/JDAxjJ6ekAoJp/gSL/RmN1cVyovsI=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id A1FA018E2B6;
        Mon, 20 Mar 2023 16:53:09 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=6m4N6/SmwXQWF7Pmy6L/LEeqvAD9uuUrYSrmRhlA9/k=; b=nJDnXhQylgAjMaB1k7Met3KPdKS+pvjVnhROZ4PsyOnICygf030V2791zdWv/fncZWY2sEvUJKV9fSJEZgXrN3Bp4zL4bg1ukLH/cYvszmAoNk6xcxOGFAssQn+3/fr3cOsPKLNX5N4umtiZpof8Frc2iQIB7oaP7FnrEKzJJd0=
Received: from yoda.home (unknown [96.21.170.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id B8A8C18E2B5;
        Mon, 20 Mar 2023 16:53:08 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 6EB676C48F6;
        Mon, 20 Mar 2023 16:53:07 -0400 (EDT)
Date:   Mon, 20 Mar 2023 16:53:07 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Richard Cochran <richardcochran@gmail.com>
cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
In-Reply-To: <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
Message-ID: <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
References: <20230313030239.886816-1-tianfei.zhang@intel.com> <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org> <ZBBQpwGhXK/YYGCB@smile.fi.intel.com> <ZBDPKA7968sWd0+P@hoboy.vegasvil.org> <ZBHPTz8yH57N1g8J@smile.fi.intel.com> <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com> <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg> <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 3843A936-C761-11ED-930F-307A8E0A682E-78420484!pb-smtp2.pobox.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023, Richard Cochran wrote:

> On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:
> 
> > Alternatively the above commit can be reverted if no one else 
> > cares. I personally gave up on the idea of a slimmed down Linux kernel a 
> > while ago.
> 
> Does this mean I can restore the posix clocks back into the core
> unconditionally?

This only means _I_ no longer care. I'm not speaking for others (e.g. 
OpenWRT or the like) who might still rely on splitting it out.
Maybe Andy wants to "fix" it?


Nicolas
