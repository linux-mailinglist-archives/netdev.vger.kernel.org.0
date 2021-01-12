Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE872F2436
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391727AbhALAZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404268AbhALAVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 19:21:39 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C282C061575
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:20:59 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l200so537507oig.9
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kNqltu1OF1hMLrUr3D3bv/ySnEJldW6xz9ogdhiNQ5E=;
        b=RSMcpgnYQfFSELcgPUds6AOjXrYRDYDYypuze9oK3hjdMgBV6bXxGtXN/ZMmJ/U+Kg
         ScKWthBwUbPxhPlSA6jLjxI3RvZSggwDAlOZu/mhtH+Tycdvu9afi+FBzp2ujKVMQSVk
         Gq64+GIhftKiepY2894VAkrbUy7z98JewpIm8Cdw6y2LoW2glik3cPhMGY0pfSTe9eDr
         Ic3Bww2UkiBPsRCcD6/rLea1bhZHwZ6EmZ/2bSSLbZRFwFnmv9AYqixuqbkxkmpnanFO
         4N8da6yyFWaGSbMo7LBP0rUlghKimTGtnLtqxbbF/sVrMWAqHGWkkL5OelnHwcTBQ4dh
         kyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNqltu1OF1hMLrUr3D3bv/ySnEJldW6xz9ogdhiNQ5E=;
        b=c18pC/h1F8jkUhvoMH7YERRyKQU5RO3zJcI1vTW5Bp7mgRz75UHyEOvNqWu2Hq0fsR
         oT7D+nlhlRGwdhRFAh4DaDeesu6IUD8t3edwvQyLq+XXGJnAA1Gw1FFdYCiwaBz/tOXX
         TbTSmnoajl99IG3UgLMD7riIv9ZMePfU2rbG9cDIRv7EQK3g0DgCHX9SHVcDVn4QNzuU
         nXNq1+4HWIMV5Rw5XGnofrtgcOjKpUsgEO6+hAGlfO5Jf+RmHqwNX77V3gBliSEcp3Tg
         RiA6FfUergfoK5QtfTNV1st8FnaYChoTq2AW14TVsPkY0nSt/d72Kof7t67yYoiN447f
         QJOg==
X-Gm-Message-State: AOAM5313g4IQ1DDHjpD8KxHUNDPQ/nQJUFebE+zRwFpJDPyfjj81D7ZR
        vzIj/j9OCyly7CkemQi4+yLjI2P7NrM=
X-Google-Smtp-Source: ABdhPJx8Nhqd37awE21j0dN1vAMZhwiu/oIslGDfs5lNaPFOCA2YGl1501jQM1wjtjjQ8IswdP5+Jw==
X-Received: by 2002:aca:5fd6:: with SMTP id t205mr814096oib.13.1610410858782;
        Mon, 11 Jan 2021 16:20:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id z3sm251947ooj.26.2021.01.11.16.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 16:20:58 -0800 (PST)
Subject: Re: [PATCH net-next v2 06/11] selftests: Use separate stdout and
 stderr buffers in nettest
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, schoen@loyalty.org
References: <20210110001852.35653-1-dsahern@kernel.org>
 <20210110001852.35653-7-dsahern@kernel.org>
 <20210111161546.1310e9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45473342-cba7-c489-2cd4-738eb7424dc8@gmail.com>
Date:   Mon, 11 Jan 2021 17:20:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111161546.1310e9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 5:15 PM, Jakub Kicinski wrote:
>> diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
>> index 0e4196027d63..13c74774e357 100644
>> --- a/tools/testing/selftests/net/nettest.c
>> +++ b/tools/testing/selftests/net/nettest.c
>> @@ -1705,9 +1705,27 @@ static char *random_msg(int len)
>>  
>>  static int ipc_child(int fd, struct sock_args *args)
>>  {
>> +	char *outbuf, *errbuf;
>> +	int rc;
>> +
>> +	outbuf = malloc(4096);
>> +	errbuf = malloc(4096);
>> +	if (!outbuf || !errbuf) {
>> +		fprintf(stderr, "server: Failed to allocate buffers for stdout and stderr\n");
>> +		return 1;
> 
> that's a memleak, rc = 1, goto free; ?
> 
> Also there's a few uses of fprintf(stderr, .. instead of log_error()
> is there a reason for it?
> 
> I don't think this is a big deal, I'll apply unless you object in time.
> 

good catch. I found a bug in patch 5 as well. I'll fix and re-send.
