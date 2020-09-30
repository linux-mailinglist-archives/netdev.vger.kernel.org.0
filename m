Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29A27F303
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgI3UL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:11:29 -0400
Received: from mail.buslov.dev ([199.247.26.29]:41399 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3UL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:11:29 -0400
X-Greylist: delayed 11333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 16:11:28 EDT
Received: from vlad-x1g6.mellanox.com (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 1F14820175;
        Wed, 30 Sep 2020 23:11:27 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1601496687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ulbcfhVZ9M5FC/5jmD6sR6GvotOAxpOk2ENKxYidy1Y=;
        b=Va1/XFrjVJp6sIS656aPW5AS1dvBhTmEqHFmFeRoOKk0Ng9TuioGZaHl+HF2hdlSWY/LX8
        es3VCbBWNMZtg3eOFMwvCVmdNpRICG2woAcDGFsQrfh9UfMTSp4jgXP+WbvOtT+hQCrU8J
        SWfK6+pWNLI7EodjSCgPlQV1jHNpDALwa/ByIsgEcRAO1wJS+N7LsmuPSKnf3fGoFTZXCJ
        rekpZnwvveqwx3RWE+guf++Mpyyw/l+E0WH+pJeJPm+QzpUv4i6bsRAypsHK5CEO4EY+0n
        1A44Y8nUGBdWaBHVXwg392RiRj0n5Qre3nmjMW7abMUptK0t/w5qZKIPMFNL2Q==
References: <20200930073651.31247-1-vladbu@nvidia.com> <20200930073651.31247-3-vladbu@nvidia.com> <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com> <20200930103359.1fa698fd@hermes.local>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RESEND PATCH iproute2-next 2/2] tc: implement support for terse dump
In-reply-to: <20200930103359.1fa698fd@hermes.local>
Message-ID: <87r1qj6n4i.fsf@buslov.dev>
Date:   Wed, 30 Sep 2020 23:11:26 +0300
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 30 Sep 2020 at 20:33, Stephen Hemminger <stephen@networkplumber.org> wrote:
> On Wed, 30 Sep 2020 08:57:20 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
>> On 9/30/20 12:36 AM, Vlad Buslov wrote:
>> > From: Vlad Buslov <vladbu@mellanox.com>
>> > 
>> > Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>> > tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>> > user requested it with following example CLI:
>> >   
>> >> tc -s filter show terse dev ens1f0 ingress  
>> 
>> this should be consistent with ip command which has -br for 'brief'
>> output. so this should be
>> 
>>    tc -s -br filter show dev ens1f0 ingress
>> 
>> Other tc maintainers should weigh in on what data should be presented
>> for this mode.
>
> Current ip brief mode is good, one line per interface. Something similar with tc
> would be best.

Hi Stephen,

My proposed implementation is very simple because it relies on existing
infrastructure that omits printing data that is not included in the
netlink packet. Making terse/brief dump output one line per filter would
require extending every single classifier with either standalone
callback for such print or dedicated block in existing print_op().
Moreover, it would be complicated for me to decide what should be
included in such output for many classifiers that I don't have
experience using.

Do you think complicating implementation like that is worth it?

Regards,
Vlad

