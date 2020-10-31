Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150EE2A1AAF
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgJaVYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgJaVYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 17:24:22 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50DBC0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 14:24:21 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CNsd02KMXzQlLT;
        Sat, 31 Oct 2020 22:24:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604179458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ZPjXl/gn9uhFiNxnlWFqzUkB2Ohqr2ZoUe7fx5+sSA=;
        b=SxeweGZCgJyKzUHMBN4SJuEaKyh93LIB+n4DPZLeEOMzbXfyMo78Dvb+33X0Y9jkkP1sHH
        5BLs2fkCp/WjN57dtY9kQXe8yZTHQ4gx/xuUkSuY4hyH3dQXqpDwBGtrJ7bOjD7OXiXFJb
        88jLD06nRpXGLgZMGYYAw9xMflOcLI7DS/cHvuIkJyI6vlRdgyLFqOZ315IIhslOTx6EzB
        sny1wrhBL6GL80WJzF/w0oQomv+9plT2xKvqmNmnJzw5AqRMShcxN1pUJ/nam2sOudo1+J
        kBOUNrEkfgpagYGMQ4T/QboY5qAHV7fGuG43t+a+r+MkYUx85LsysKmf645vag==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id TulGZY4_-MFD; Sat, 31 Oct 2020 22:24:17 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org> <20201030090532.33af6a3f@hermes.local>
From:   Petr Machata <me@pmachata.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        "Roman Mashak" <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
In-reply-to: <20201030090532.33af6a3f@hermes.local>
Date:   Sat, 31 Oct 2020 22:24:14 +0100
Message-ID: <87lffmhywx.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.16 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4AFF717E6
X-Rspamd-UID: 7b1870
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Fri, 30 Oct 2020 13:29:50 +0100
> Petr Machata <me@pmachata.org> wrote:
>
>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
>> +{
>> +	if (is_json_context())
>> +		print_bool(PRINT_JSON, flag, NULL, val);
>> +	else
>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
>> +}
>
> Please use print_string(PRINT_FP for non json case.
> I am use fprintf(fp as indicator for code that has not been already
> converted to JSON.
>
> And passing the FILE *fp is also indication of old code.
> Original iproute2 passed it around but it was always stdout.

Ack, will fix.
