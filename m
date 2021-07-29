Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D243DA940
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG2Qlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:41:46 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57824 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhG2Qlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:41:46 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 009E9200DF9A;
        Thu, 29 Jul 2021 18:41:40 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 009E9200DF9A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627576901;
        bh=zp4IrndI4fd0M6N87EXqbAlH/3eq+qrstDJ4Cpb7Rdk=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=mfGByGbCrkBWnc8IGFsB8let7WZr065J5sPFiQ9Asql5+aTIXP8xrMaiulcxkF8Gt
         7dZU0e6unOaydlGvqkRd+8MiuraAoWOp+mv53LyW9wwmJZG+xysEQhkdbullfnasYJ
         jqR5amepXF1+s9Yko2H+SYQUUtBXnsOKBZY72nbCnGlGHC5sniguDUlD+/9YCeymFs
         zjdqISlHGnSlEtTVqA5X8P1V8EFdxTsVyGTFe9gUu1NE9GonAkKt2o/PPk/NaQU9X4
         IGxhYcJOm5vA00ZWMP9Ykm/22klz4zribA46J1/1tjB1E5NnK8GC/1Mc3gkKx+Z/Nv
         YYjxLFmp3bJ8A==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id EC27D6008D60B;
        Thu, 29 Jul 2021 18:41:40 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CTqS4xJ-W1jr; Thu, 29 Jul 2021 18:41:40 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id D49AB6008D451;
        Thu, 29 Jul 2021 18:41:40 +0200 (CEST)
Date:   Thu, 29 Jul 2021 18:41:40 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Message-ID: <1693729071.28416702.1627576900833.JavaMail.zimbra@uliege.be>
In-Reply-To: <6c6b379e-cf9e-d6a8-c009-3e1dbbafb257@gmail.com>
References: <20210724172108.26524-1-justin.iurman@uliege.be> <20210724172108.26524-2-justin.iurman@uliege.be> <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com> <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be> <6c6b379e-cf9e-d6a8-c009-3e1dbbafb257@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: Add, show, link, remove IOAM namespaces and schemas
Thread-Index: wEXOj5cnzXU8kjq/9XgmEh7QMFDitw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>> +static void print_schema(struct rtattr *attrs[])
>>>> +{
>>>> +	__u8 data[IOAM6_MAX_SCHEMA_DATA_LEN + 1];
>>>> +	int len;
>>>> +
>>>> +	print_uint(PRINT_ANY, "schema", "schema %u",
>>>> +		   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
>>>> +
>>>> +	if (attrs[IOAM6_ATTR_NS_ID])
>>>> +		print_uint(PRINT_ANY, "namespace", " [namespace %u]",
>>>> +			   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
>>>> +
>>>> +	len = RTA_PAYLOAD(attrs[IOAM6_ATTR_SC_DATA]);
>>>> +	memcpy(data, RTA_DATA(attrs[IOAM6_ATTR_SC_DATA]), len);
>>>> +	data[len] = '\0';
>>>> +
>>>> +	print_string(PRINT_ANY, "data", ", data \"%s\"", (const char *)data);
>>>
>>> The attribute descriptions shows this as binary data, not a string.
>> 
>> Indeed. Maybe should I print it as hex... What do you think is more appropriate
>> for this?
> 
> ./tc/em_meta.c has print_binary() but it is not json aware.
> 
> devlink has pr_out_binary_value which is close. You could probably take
> this one and generalize it.

Right, I'll take a look.

>>>> +int do_ioam6(int argc, char **argv)
>>>> +{
>>>> +	bool maybe_wide = false;
>>>> +
>>>> +	if (argc < 1 || matches(*argv, "help") == 0)
>>>> +		usage();
>>>> +
>>>> +	memset(&opts, 0, sizeof(opts));
>>>> +
>>>> +	if (matches(*argv, "namespace") == 0) {
>>>
>>> matches has been shown to be quite frail. Convenient for shorthand
>>> typing commands, but frail in the big picture. We should stop using it -
>>> especially for new commands.
>> 
>> Sure. What do you suggest as an alternative?
>> 
> 
> full strcmp.

I see. But, in that case, I'm wondering if it wouldn't be better to directly modify "matches" internally so that we keep consistency between modules without changing everything.

Thoughts?
