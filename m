Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351A658FD6D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiHKNdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKNdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:33:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8268991D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660224828; x=1691760828;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=acZ2shlc7xRBGvoHapEtZGHQJCcl0d/dd3+Ta0fBD0s=;
  b=BC2NejokLzhdvEqvu/P+cQurNAHmOj3W64J89edKGvIoVMa5/0tsdmse
   vBQq6Hpjm+4N69c7VI6RXqayk3Lxhq+ENrCaG7N5Sru6Ib8jgZE/oMZ+I
   g9Zeoolfhmn4xhNgYm/buaQA955zEtSJre2T8j5yWwB+wlt+9OsmlBfb7
   2ItMKtqlCjr2dU/xZWiAsjCFiHNb46cSM/idz3ZwRe8e1dGCIdgF0Wc0J
   W6TteK6c8EVGPEXD1uU7FSoaIpifdXrUqPT9HXRIeGHiaKWLpQIV3gwok
   hHfBv3yqscAYrO2P0RxbAGIyDKC6U1F3IvFzdvIXZzUyZHJQS1hSUFfSi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="355347915"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="355347915"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 06:33:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="665374342"
Received: from jmhiguer-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.17.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 06:33:46 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
Date:   Thu, 11 Aug 2022 10:33:43 -0300
Message-ID: <87tu6i6h1k.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

Ferenc Fejes <ferenc.fejes@ericsson.com> writes:

> Hi Vinicius!
>
> On Tue, 2022-07-19 at 09:40 +0200, Fejes Ferenc wrote:
>> Hi Vinicius!
>> 
>> On Mon, 2022-07-18 at 11:46 -0300, Vinicius Costa Gomes wrote:
>> > Hi Ferenc,
>> > 
>> > Ferenc Fejes <ferenc.fejes@ericsson.com> writes:
>> > 
>> > > (Ctrl+Enter'd by mistake)
>> > > 
>> > > My question here: is there anything I can quickly try to avoid
>> > > that
>> > > behavior? Even when I send only a few (like 10) packets but on
>> > > fast
>> > > rate (5us between packets) I get missing TX HW timestamps. The
>> > > receive
>> > > side looks much more roboust, I cannot noticed missing HW
>> > > timestamps
>> > > there.
>> > 
>> > There's a limitation in the i225/i226 in the number of "in flight"
>> > TX
>> > timestamps they are able to handle. The hardware has 4 sets of
>> > registers
>> > to handle timestamps.
>> > 
>> > There's an aditional issue that the driver as it is right now, only
>> > uses
>> > one set of those registers.
>> > 
>> > I have one only briefly tested series that enables the driver to
>> > use
>> > the
>> > full set of TX timestamp registers. Another reason that it was not
>> > proposed yet is that I still have to benchmark it and see what is
>> > the
>> > performance impact.
>> 
>> Thank you for the quick reply! I'm glad you already have this series
>> right off the bat. I'll be back when we done with a quick testing,
>> hopefully sooner than later.
>
> Sorry for the late reply. I had time for a few tests, with the patch.
> For my tests it looks much better. I send a packet in every 500us with
> isochron-send, TX SW and HW timestamping enabled and for 10000 packets
> I see zero lost timestamp. Even for 100000 packets only a few dropped
> HW timestamps visible.
>
> With iperf TCP test line-rate achiveable just like without the patch.
>

That's very good to know.

>> > 
>> > If you are feeling adventurous and feel like helping test it, here
>> > is
>> > the link:
>> > 
>> > https%3A%2F%2Fgithub.com%2Fvcgomes%2Fnet-next%2Ftree%2Figc-
>> > multiple-tstamp-timers-lock-new
>> > 
>
> Is there any test in partucular you interested in? My testbed is
> configured so I can do some.
>

The only thing I am worried about is, if in the "dropped" HW timestamps
case, if all the timestamp slots are indeed full, or if there's any bug
and we missed one timestamp.

Can you verify that for for every dropped HW timestamp in your
application, can you see that 'tx_hwtstamp_skipped' (from 'ethtool -S')
increases everytime the drop happens? Seeing if 'tx_hwtstamp_timeouts'
also increases would be useful as well.

If for every drop there's one 'tx_hwtstamp_skipped' increment, then it
means that the driver is doing its best, and the workload is requesting
more timestamps than the system is able to handle.

If only 'tx_hwtstamp_timeouts' increases then it's possible that there
could be a bug hiding still.

>> > 
>> > Cheers,
>> 
>> Best,
>> Ferenc
>
> Best,
> Ferenc
>

Cheers,
-- 
Vinicius
