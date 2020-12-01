Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE42CB08D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgLAW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgLAW5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:57:25 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C61DC0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 14:56:45 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4ClyBn2YmwzQlY1;
        Tue,  1 Dec 2020 23:56:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606863375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JbWodcegzCFLtMlbJcXm0RIQ99to91lAQQ1gbskD3VY=;
        b=apnK3bostEMx0tP95b842n1xu8TxoKLGub8RjxeWs7H6zGTY3/+RoC0T5yLSG8c6ALkMSr
        9rO8eTKp6t2GvJFWSLf2Y8JGh8QqBJkaV6jgpdl/FpfvtIM8wcF9rXeLwjWe1G+3fD5v9X
        H4B51XshQd6gnVUftOwyXqWiVMegpyUkIcSytj2u4p/mNa9rPZC6S1hXimkhnL9WY0DLKT
        OgU8ub6mSHcX1cG2yg5UoGM3x8dbBdDHd54UoFPkyN0CKTRiNoAdDvsZB/2hIdKBubWp2A
        aPmIa+qRQEx7D6vvBdMFaBHKzNkIsf+UuJQ+T+K2SrKB924rK8yPqU0f/zv1wQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id 3TkYeFcKNxeA; Tue,  1 Dec 2020 23:56:13 +0100 (CET)
References: <cover.1606774951.git.me@pmachata.org> <f2dd583ef64b64b95571b317c94802ff155ebc5d.1606774951.git.me@pmachata.org> <20201130163547.23a06e79@hermes.local>
From:   Petr Machata <me@pmachata.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, Po.Liu@nxp.com, toke@toke.dk,
        dave.taht@gmail.com, edumazet@google.com, tahiliani@nitk.edu.in,
        vtlam@google.com, leon@kernel.org
Subject: Re: [PATCH iproute2-next 2/6] lib: Move print_rate() from tc here; modernize
In-reply-to: <20201130163547.23a06e79@hermes.local>
Date:   Tue, 01 Dec 2020 23:56:11 +0100
Message-ID: <87h7p5nnjo.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.31 / 15.00 / 15.00
X-Rspamd-Queue-Id: 498FB180E
X-Rspamd-UID: bbe91d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

>> +int print_color_rate(bool use_iec, enum output_type t, enum color_attr color,
>> +		     const char *key, const char *fmt, unsigned long long rate);
>> +
>> +static inline int print_rate(bool use_iec, enum output_type t,
>> +			     const char *key, const char *fmt,
>> +			     unsigned long long rate)
>> +{
>> +	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
>> +}
>> +
>
> Overall this looks good, but is there any case where color output
> makes sense for this field? If not then why do all the color wrappers.

All the print_X functions in json_print comes with a print_color_X
flavor as well, even the ones where all clients just use the plain
output. (Notably the recently added on_off. Colors were even one of the
arguments in favor of putting that one to json_print, despite nobody
actually using them for on/off.)
