Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57142E8BBF
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhACKtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbhACKtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 05:49:02 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814C9C061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 02:48:21 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D7wT34ztXzQkm6;
        Sun,  3 Jan 2021 11:47:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609670870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M6soEWJDbmDU3LmoKtlSYOyt8Rwc7c70eCwv+BMXWVg=;
        b=jV89QKRjS7Urelwcf89WtTQEfj7hdnZdRANgTcn6O97y3JhadmsUaKBM9IeeRLSGZL2dxZ
        jTXUg9GIYjEnQhXXWrzdQDpotzaK7bC98H/1QattYWV8EfXrnQeLZvJycbfO4QQ0LBx91e
        bwqtVFevTGocaBjrUfnsLJkHykhhZhblAWy20MQESC81RKFA/c7LMxwxn8xzBLEXz6+29x
        mhBWxw49Ng6k9o8DpoNcE3j+QkiJB5wKdy9nqXz9JKMD59druYa0NK7a0AFodvw8OGRybr
        D3ooT+6CXh+Aa5J+WJiMJ6F4U6yXjn4Cj+kA7rQUJOP6ZiE/DY7RhynwDHkoEA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id v-yqqcVZZbYp; Sun,  3 Jan 2021 11:47:48 +0100 (CET)
References: <cover.1609543363.git.me@pmachata.org>
 <61a95beac0ea7f2979ffd5ba5f4a08f000cc091a.1609543363.git.me@pmachata.org>
 <20210102093423.2033de6a@hermes.local>
From:   Petr Machata <me@pmachata.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/3] dcb: Set values with RTM_SETDCB type
In-reply-to: <20210102093423.2033de6a@hermes.local>
Date:   Sun, 03 Jan 2021 11:47:46 +0100
Message-ID: <87h7nywb3h.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.07 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9DC721848
X-Rspamd-UID: d023ad
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Sat,  2 Jan 2021 00:25:50 +0100
> Petr Machata <me@pmachata.org> wrote:
>
>> dcb currently sends all netlink messages with a type RTM_GETDCB, even the
>> set ones. Change to the appropriate type.
>> 
>> Signed-off-by: Petr Machata <me@pmachata.org>
>> ---
>>  dcb/dcb.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/dcb/dcb.c b/dcb/dcb.c
>> index adec57476e1d..f5c62790e27e 100644
>> --- a/dcb/dcb.c
>> +++ b/dcb/dcb.c
>> @@ -177,7 +177,7 @@ int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *da
>>  	struct nlattr *nest;
>>  	int ret;
>>  
>> -	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_SET);
>> +	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, DCB_CMD_IEEE_SET);
>>  
>>  	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
>>  	mnl_attr_put(nlh, attr, data_len, data);
>
> Should I add fixes tag to this?

Ha, I forgot that Fixes: tags are a thing in iproute2. Sorry about that,
I'll resend.
