Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408B42A5648
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgKCVBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbgKCVBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:01:41 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DCDC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 13:01:40 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CQhzQ3cNlzQl9v;
        Tue,  3 Nov 2020 22:01:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604437296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cNJcSYX21alSBZ027Kkc/qhi+X7jzJygZREuFOLSVVI=;
        b=Gsyguqz/S73UVHxU6Ufwt+eqFnliBwbzI0XkvacpwbenN9wPuPfXJcZRA2K8+yFELYsqNB
        2PhqBfiTOGhBZ9HRsR8zLLFM4ImgO/wBbqEU683grOYkTrrU8IgzZD4QdxL5k9RU4Fuy3P
        1u7LZ+zOpVD5Bq8yDHbGCeSsw92Ml7zmtP4YNmAd4ORBhSVdWmyDFpFic03ycpFY/cd0F+
        mII7wuWVY/8EkQTDWNcaYhnUcJOZper9b2FiwTKurSsjQhxnoJLzbNdNql4VvbYSYfi0Tp
        nIM/gDz2wFe2K1XNu3GusjTOcDLRo6d1wTbSOcmGEhDGDyVuhjcb8vK0IIk1Dw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id z3FDXKkYkpWO; Tue,  3 Nov 2020 22:01:35 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org> <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com> <87o8kihyy9.fsf@nvidia.com> <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com> <20201102063752.GE5429@unreal> <87h7q7iclr.fsf@nvidia.com> <20201103062406.GH5429@unreal>
From:   Petr Machata <me@pmachata.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
In-reply-to: <20201103062406.GH5429@unreal>
Date:   Tue, 03 Nov 2020 22:01:32 +0100
Message-ID: <874km6i28j.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: 222BB17E8
X-Rspamd-UID: 069eb6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Leon Romanovsky <leon@kernel.org> writes:

> On Tue, Nov 03, 2020 at 12:05:20AM +0100, Petr Machata wrote:
>>
>> Leon Romanovsky <leon@kernel.org> writes:
>>
>> > On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
>> >
>> >> yes, the rdma utils are using generic function names. The rdma version
>> >> should be renamed; perhaps rd_print_on_off. That seems to be once common
>> >> prefix. Added Leon.
>> >
>> > I made fast experiment and the output for the code proposed here and existed
>> > in the RDMAtool - result the same. So the good thing will be to delete the
>> > function from the RDMA after print_on_off_bool() will be improved.
>>
>> The RDMAtool uses literal "on" and "off" as values in JSON, not
>> booleans. Moving over to print_on_off_bool() would be a breaking change,
>> which is problematic especially in JSON output.
>
> Nothing prohibits us from adding extra parameter to this new
> function/json logic/json type that will control JSON behavior. Personally,
> I don't think that json and stdout outputs should be different, e.g. 1/0 for
> the json and on/off for the stdout.

Emitting on/off in JSON as true booleans (true / false, not 1 / 0) does
make sense. It's programmatically-consumed interface, the values should
be of the right type.

On the other hand, having a FP output use literal "on" and "off" makes
sense as well. It's an obvious reference to the command line, you can
actually cut'n'paste it back to shell and it will do the right thing.

Many places in iproute2 do do this dual output, and ideally all new
instances would behave this way as well. So no toggles, please.

>> I think the current function does handle JSON context, what else do
>> you have in mind?
>
> It handles, but does it twice, first time for is_json_context() and
> second time inside print_bool.

Gotcha.
