Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87762E85BD
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 22:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAAVfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 16:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbhAAVfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 16:35:23 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD144C0613C1
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 13:34:42 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D6ywH5gjyzQlWy;
        Fri,  1 Jan 2021 22:34:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609536878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0sodwRofq4F03pPVSgJMxZN3RB0aVh1P+ISKctlYYtY=;
        b=dSTiMnYAbXlhz2TRvE34kJi0sIniBeMFxti6Yc6ZgWoY6zO88pleF3psBnHfr9Mph17K5p
        J8Irtfj/idORUzAxfn0LH+beBWtK5UFnsJ2srh38X8oBaP+7s1LJsAQAgYJJfjiS+mlJxr
        rsn3kEYD3fTLlpZ0/urKpZbBiZEQd3+QYogv1/DCWk9kx/r/xRXcNuEwZ2M45ASu3LXtnh
        mpBX25w2eISOJHTW/TzwjX6PCTLlAKB7Dk4wB3XJYIcrD5jpXiTiArbAR826DTb+K8TDEQ
        Y5Amj7a+3wKJFGTTCc7vAGhGZHcbDm2smLoEA0AePL6XgUg6vIjh9QntC3mlJA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id igyBA93KewRd; Fri,  1 Jan 2021 22:34:36 +0100 (CET)
References: <cover.1608746691.git.me@pmachata.org>
 <9a23b6698bd8f223f7789149e8196712d5d624ae.1608746691.git.me@pmachata.org>
 <8ae5ec88-937e-2e05-b0f2-a99c72e74a06@gmail.com>
From:   Petr Machata <me@pmachata.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next 7/9] dcb: Support -n to suppress
 translation to nice names
In-reply-to: <8ae5ec88-937e-2e05-b0f2-a99c72e74a06@gmail.com>
Date:   Fri, 01 Jan 2021 22:34:35 +0100
Message-ID: <87mtxswdck.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.87 / 15.00 / 15.00
X-Rspamd-Queue-Id: A01401722
X-Rspamd-UID: e5763a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 12/23/20 11:25 AM, Petr Machata wrote:
>> diff --git a/dcb/dcb.c b/dcb/dcb.c
>> index a59b63ac9159..e6cda7337924 100644
>> --- a/dcb/dcb.c
>> +++ b/dcb/dcb.c
>> @@ -467,7 +467,8 @@ static void dcb_help(void)
>>  		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
>>  		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
>>  		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
>> -		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
>> +		"                  | -n | --no-nice-names | -p | --pretty\n"
>
>
> iproute2 commands really should have a consistent user interface.
> Unfortunately -N and -n are inconsistent with the newer commands like
> devlink. dcb has not been released yet so time to fix this.
>
> devlink is the only one using the horribly named 'no-nice-names', and we
> should avoid propagating that to dcb. At a minimum it should be
> 'numeric' which is consistent with the others.
>
> My preference is also to have dcb follow ip and tc (vs ss) with '-n' to
> mean -netns and -N' to mean numeric.

Agreed on all counts.
