Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0C72A1AB0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgJaVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgJaVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 17:25:22 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023D6C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 14:25:21 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CNsf72zpgzQl91;
        Sat, 31 Oct 2020 22:25:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604179517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QPhZF+gJlsHsXQyrcIOlG+zHFRoaTvHJRQqVNKLsDH0=;
        b=qUqBAhLL0q+u5Qpzy6+eu5PWJDESU2aXaw0RtV3+EeD0AEAxlV3GS497J+bV93F6UKO2i7
        3CEXLVpznm7znzxxlOAs02792+gqWVqD0bWlhK3Q+V0MNAw8uzbicq+FnIbtYNEOAa+1+4
        iTxFEdpTpZbRQL+I35wfTld7owWwznnmvBMOmhkSca4IyUJGZtI2+E+cYln9xibkpQpAF2
        OtADBmST9Og7rcvmrIhl/KjS/VXCKiB9RH1kuQKEdi9NeBjlRziBSNvs+hCk2UnSVgwdsU
        WZVQErADZ74fmm/fnGbYA6pTmBMXS2y0D1s5voTCixXLDk9inuOMlqJChfxXzw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id oyQ0ikZmgXnY; Sat, 31 Oct 2020 22:25:16 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <194ae677df465086d6cd1d7962c07d790e6d049d.1604059429.git.me@pmachata.org> <a814a899-f811-d634-2f0c-8e3240bfcfa4@gmail.com>
From:   Petr Machata <me@pmachata.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 02/11] lib: Add parse_one_of(), parse_on_off()
In-reply-to: <a814a899-f811-d634-2f0c-8e3240bfcfa4@gmail.com>
Date:   Sat, 31 Oct 2020 22:25:14 +0100
Message-ID: <87k0v6hyv9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.34 / 15.00 / 15.00
X-Rspamd-Queue-Id: 566D117EC
X-Rspamd-UID: 2754ee
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 10/30/20 6:29 AM, Petr Machata wrote:
>> +int parse_on_off(const char *msg, const char *realval, int *p_err)
>> +{
>> +	static const char * const values_on_off[] = { "off", "on" };
>> +
>> +	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
>> +}
>> 
>
> This has weird semantics to me. You have a buried array of strings and
> returning the index of the one that matches. Let's use a 'bool' return
> for parse_on_off that makes it clear that the string is 'off' = false or
> 'on' = true.

Agreed, it should return bool.
