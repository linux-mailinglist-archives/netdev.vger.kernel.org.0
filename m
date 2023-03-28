Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B16CC2F0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjC1OuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbjC1Otn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A7ED33D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE76C61804
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E6C4339E;
        Tue, 28 Mar 2023 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680014949;
        bh=+VWbyQBxRxbuoIFyaBdMXRSSVTR3ezzmLyjGexD6PpE=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=Dfw11QL18hd/OBQBiU2/1JyCzkjDO3h/71RtiORTDkPHQFmMcndCKQ8TaHVWGqT0l
         eNxnCkfU3FhTuxyq2ibZ3qqqhJGtXSQHcNzhu/3WfC8/RhEih1JraTKlJLHrNTBBxB
         382dFfoaXkQaTIk5fYDbWTbo+8IGRvTeBqdeGnMhC5ewjCWcYWJPpGnECY6H3CbvF/
         r9RY6RkDH2us1fq/dAboxVodJXJJJwFSuZpSbxzIHkKYp/pGKs0u+eexBXVgREBc1F
         UbQjAZn7eEs0/j4BpDUSdoppBkAugWNecklfgudXFeSuDfEQiOUiKc+9gnOON9cgeu
         ZZAWMx/BaNzFg==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9B85C27C0054;
        Tue, 28 Mar 2023 10:49:07 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 28 Mar 2023 10:49:07 -0400
X-ME-Sender: <xms:Y_4iZMfnZ9A0Ehjv_jdOdGjtyxf5nqSkt8f9t8--emu_efPGZudVgQ>
    <xme:Y_4iZOOV5JvrF-vSLtT0EPa7WiwYuMhta7sZbbFaX0FmGc66706u-81SCyPkoYKGK
    bXQXkncCdUidM_w_18>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehgedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepvdeviefgtedugeevieelvdfgveeuvdfgteegfeeiieejjeffgeeghedu
    gedtveehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghrnhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdekhedujedt
    vdegqddvkeejtddtvdeigedqrghrnhgupeepkhgvrhhnvghlrdhorhhgsegrrhhnuggsrd
    guvg
X-ME-Proxy: <xmx:Y_4iZNgbor1sjUDZlxu9J_xsiBokoL3scJt6wCxBKwtmGpBPSun2kQ>
    <xmx:Y_4iZB9XDaPojiVBvyV2id_QPmyKciyDy0ljBN5Mh9bvxnN_fu-3xA>
    <xmx:Y_4iZIu2y9feZSJe5-sJJRNwxKTqL6UUr3LV0sMsoMO45jOjJmHuMQ>
    <xmx:Y_4iZJkBiclyflKS7ffTpEfQlq0DZAhO-rdVntCbfMNWs6YtaNk5qg>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0D58EB6008F; Tue, 28 Mar 2023 10:49:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-237-g62623e8e3f-fm-20230327.001-g62623e8e
Mime-Version: 1.0
Message-Id: <acd9a75d-4363-4e64-97e7-7b53cbcc9b3b@app.fastmail.com>
In-Reply-To: <ZCL8veyS5xNUMCCt@hoboy.vegasvil.org>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
 <ZCL8veyS5xNUMCCt@hoboy.vegasvil.org>
Date:   Tue, 28 Mar 2023 16:48:45 +0200
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Richard Cochran" <richardcochran@gmail.com>,
        "Tianfei Zhang" <tianfei.zhang@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-fpga@vger.kernel.org,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        "Nicolas Pitre" <nico@fluxnic.net>,
        "Raghavendra Khadatare" <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023, at 16:42, Richard Cochran wrote:
> On Tue, Mar 28, 2023 at 10:24:55AM -0400, Tianfei Zhang wrote:
>
>> v3:
>> - add PTP_1588_CLOCK dependency for PTP_DFL_TOD in Kconfig file.
>> - don't need handle NULL case for ptp_clock_register() after adding
>>   PTP_1588_CLOCK dependency.
>
> Sorry, but this isn't how it is done...
>
>> +config PTP_DFL_TOD
>> +	tristate "FPGA DFL ToD Driver"
>> +	depends on FPGA_DFL
>> +	depends on PTP_1588_CLOCK
>
> Try these commands:
>
>    git grep "depends on PTP_1588_CLOCK_OPTIONAL"
>    git grep "depends on PTP_1588_CLOCK_OPTIONAL" | grep -v OPTIONAL
>
> Driver must depend on PTP_1588_CLOCK_OPTIONAL and then handle the NULL
> case correctly.

I think this one is one of the (few) cases where the 'depends on
PTP_1588_CLOCK' is correct and 'depends on PTP_1588_CLOCK_OPTIONAL'
would be wrong:

Using PTP_1588_CLOCK_OPTIONAL as a dependency for PTP_DFL_TOD would
allow enabling the driver even when PTP_1588_CLOCK is completely
disabled, which would cleanly build but not do anything useful
because the driver only handles PTP and not also networking.

     Arnd
