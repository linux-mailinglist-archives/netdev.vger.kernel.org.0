Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D206C2A8879
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbgKEU7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732265AbgKEU7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:59:31 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A611C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 12:59:31 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CRwqx735lzQkKv;
        Thu,  5 Nov 2020 21:59:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604609964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R4j3+zEcuhUOiDtJ6pNyNrUUKZfNv+1CgkW+NK5D070=;
        b=nPLucI1eAstHNJ51uh5/mMM0J6R8SlTCrk8JFbtCzm6IcxoXBxBxCMB0wQp8pWvVDtAFXe
        qYY1Bk5DQLZS/g2qOrrQSV6G5pI9Gm1bxvMQ6wGe5juQjqx+O+Xd5JT8OWFxb2omtMEv/W
        RSNdp2dKTmrPXHFQQVn4LWVL5Z5BoDG0EHCAi89ENYBY+B6C4dpjUdevKKQyKuGrcoVAMt
        NZ/FcLQfjfZqXbbCk9i+gWIuQcgGgDplLgXapl99uTY/RLMCYrB2GCVPZJ6p10PNQDOBpn
        mi7AQH54GAVW1SK1EbJ7m13sR7FQP/u4Nza8f32s50JlIXqFU54VHe+tLvp6sg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id iXlKwk3xcVDM; Thu,  5 Nov 2020 21:59:22 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org> <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com> <87o8kihyy9.fsf@nvidia.com> <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com> <20201102063752.GE5429@unreal> <87h7q7iclr.fsf@nvidia.com> <20201103062406.GH5429@unreal> <874km6i28j.fsf@nvidia.com> <20201104081528.GL5429@unreal>
From:   Petr Machata <me@pmachata.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
In-reply-to: <20201104081528.GL5429@unreal>
Date:   Thu, 05 Nov 2020 21:59:19 +0100
Message-ID: <87y2jfh654.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.87 / 15.00 / 15.00
X-Rspamd-Queue-Id: D0A3514AF
X-Rspamd-UID: b70b70
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Leon Romanovsky <leon@kernel.org> writes:

> On Tue, Nov 03, 2020 at 10:01:32PM +0100, Petr Machata wrote:
>>
>> Leon Romanovsky <leon@kernel.org> writes:
>>
>> > On Tue, Nov 03, 2020 at 12:05:20AM +0100, Petr Machata wrote:
>> >>
>> >> Leon Romanovsky <leon@kernel.org> writes:
>> >>
>> >> > On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
>> >> >
>> >> >> yes, the rdma utils are using generic function names. The rdma version
>> >> >> should be renamed; perhaps rd_print_on_off. That seems to be once common
>> >> >> prefix. Added Leon.
>> >> >
>> >> > I made fast experiment and the output for the code proposed here and existed
>> >> > in the RDMAtool - result the same. So the good thing will be to delete the
>> >> > function from the RDMA after print_on_off_bool() will be improved.
>> >>
>> >> The RDMAtool uses literal "on" and "off" as values in JSON, not
>> >> booleans. Moving over to print_on_off_bool() would be a breaking change,
>> >> which is problematic especially in JSON output.
>> >
>> > Nothing prohibits us from adding extra parameter to this new
>> > function/json logic/json type that will control JSON behavior. Personally,
>> > I don't think that json and stdout outputs should be different, e.g. 1/0 for
>> > the json and on/off for the stdout.
>>
>> Emitting on/off in JSON as true booleans (true / false, not 1 / 0) does
>> make sense. It's programmatically-consumed interface, the values should
>> be of the right type.
>
> As long as you don't need to use those fields to "set .." after that.
>>
>> On the other hand, having a FP output use literal "on" and "off" makes
>> sense as well. It's an obvious reference to the command line, you can
>> actually cut'n'paste it back to shell and it will do the right thing.
>
> Maybe it is not so bad to change RDMAtool to general function, this
> on/of print is not widely use yet

OK, if you think the API breakage is acceptable, I'll roll this into the
patchset.

> just need to decide what is the right one.

Yeah, it's kinda fuzzy. Where JSON has an obvious type to use, use it:
arrays should probably be arrays, numbers should probably be numbers.
I'm not so sure about enums, but I guess represent them as strings? As
numbers they will not be more meaningful or easy to consume, and it does
not make sense to do arithmetic on enums.

On/off toggles could be considered enums. But they are also booleans.
Representing on as true and off as false is straightforward and from
this perspective booleans are the obvious type to use.

>> Many places in iproute2 do do this dual output, and ideally all new
>> instances would behave this way as well. So no toggles, please.
>
> Good example why all utilities in iproute2 are better to use same
> input/output code and any attempt to make custom variants should be
> banned.

Yes, I have a clean-up patch that converts these custom on/off helpers
to the new central one. I'll send this together with other refactorings
of this sort after this patch set.
