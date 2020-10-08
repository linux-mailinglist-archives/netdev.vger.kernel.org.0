Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C507287787
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgJHPeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730829AbgJHPeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:34:21 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA89C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 08:34:21 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 578DA1F899;
        Thu,  8 Oct 2020 18:34:18 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1602171258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZbJzGaSt7Q5vG7X+TSWASf20jSkfNeqX/MMqXL7sNg=;
        b=UoKT5ynSPvn/IORj0YgJEcVaIxcL2Cjv7bGXpM8KNF607GGIcRrY4AlEV/90SX6jJov8NA
        dNaNw1pczQQ1ZUeBWfX4xeLWu1wZqgAoahm8EK9rLPt7wnOyfDNA+Ce8bG04Hjx6Q0WNQ2
        7uVJ08zijtyv3c7SNVyJDje8O7LPROIbk5sCkpXsu4ahusQ/WosutsSnZbT4OzqXgDlfJf
        lFnC1JIVMzUcePT3MfN3LVQrb+NaHCfGBV+wR0rpaLQJKetDojH/nxutwZ4wWcrU18t/qz
        bs0gGk79nWqfSACz9UBnVOtCLFl0O6UwWaWpzjc686jbchgjLW51Wh55VG04kQ==
References: <20200930165924.16404-1-vladbu@nvidia.com> <20200930165924.16404-3-vladbu@nvidia.com> <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com> <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
In-reply-to: <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com>
Date:   Thu, 08 Oct 2020 18:34:17 +0300
Message-ID: <87imbk20li.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 08 Oct 2020 at 15:58, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-07 9:40 p.m., David Ahern wrote:
>> On 9/30/20 9:59 AM, Vlad Buslov wrote:
>>> From: Vlad Buslov <vladbu@mellanox.com>
>>>
>>> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>>> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>>> user requested it with following example CLI (-br for 'brief'):
>>>
>>>> tc -s -br filter show dev ens1f0 ingress
>>>
>>> In terse mode dump only outputs essential data needed to identify the
>>> filter and action (handle, cookie, etc.) and stats, if requested by the
>>> user. The intention is to significantly improve rule dump rate by omitting
>>> all static data that do not change after rule is created.
>>>
>>
>> I really want to get agreement from other heavy tc users about what the
>> right information is for a brief mode.
>
> Vlad, would have been helpful in your commit log to show both
> terse vs no terse (or at least the terse output). Cant tell short
> of patching and testing. Having said that:
> The differentiation via TCA_DUMP_FLAGS_TERSE in the request
> is in my opinion sufficient to accept the patch.
> Also, assuming you have tested with outstanding tc tests for the
> first patch i think it looks reasoan

Hi Jamal,

The existing terse dump tdc tests will have to be changed according with
new iproute2 tc syntax for brief(terse) output.

Regards,
Vlad

