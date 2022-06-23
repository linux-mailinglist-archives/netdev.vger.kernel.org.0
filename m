Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B05557668
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiFWJOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiFWJO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:14:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC6345792
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:14:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ej4so23627744edb.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=HCimRm6+HdXtaHe5ibmshBW11+8uKUW4YlEAhRCYc/U=;
        b=tJQy7sazjr2a6Xtx/PdeZLdOnf+/gB3Sotmey0ZaqRFyNbFSnm2+MYxjGZVH86Hg7p
         FFSlHMBWw3CUbMAUL4QFGmPtR0AxJYdZpO2/iv1Mgq3RPyGc754vqw6vKsgYCDWAXZov
         3+DumCu9CPdWRUi0HFHZ491uuF1JWUHvr7+Tc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=HCimRm6+HdXtaHe5ibmshBW11+8uKUW4YlEAhRCYc/U=;
        b=rPijyd9l0fechlCDrcl3qP4frzW2dVZu27zD5ylixgFWlpfUPRQaPn8uQs/0zaKGO3
         4oAthJIxJuYQKUEi9oAz1CGQiBoeWm6AMm0PB3mK1yu6O0W3CtQVckFHC7NMGvyZshdX
         H0gkwpDOgV8IEVxnqDfyAocBLe07RMknWbLUcnqgzacBqLGw2X9Aa56TLbragpV0ykMG
         vNeetxVuTiMxYp7PDXzmuUHTA6q29cNof/I3Y8ehQTZr9QX6ivLwmUfSsg9pPjIjkiEC
         cjK9N/O6IFOtBdXCmP0CUMN3zbUaqfLwNaV9LZiWCVgjHpLNSOo60Fm8fLyqFTVb3ly9
         DY3Q==
X-Gm-Message-State: AJIora+GGGBxfYCHulprwPjd+xkbQ84Hu87b0cM+Tr9mlHNcmvhLWEZY
        4hla6m0vBcVS6G8LbWeEqM4S2A==
X-Google-Smtp-Source: AGRyM1sD4qy7S2trmGAuuU+F6lXoWRjq+qaqRCtptZ0biB6gT3AwokqeV0ERg1Zi5YacPLNxifhfmQ==
X-Received: by 2002:a05:6402:1bc1:b0:435:67ef:2f41 with SMTP id ch1-20020a0564021bc100b0043567ef2f41mr9543583edb.85.1655975665678;
        Thu, 23 Jun 2022 02:14:25 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id y4-20020aa7ccc4000000b004316f94ec4esm16912880edt.66.2022.06.23.02.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:14:25 -0700 (PDT)
References: <20220620191353.1184629-2-kuba@kernel.org>
 <20220622172407.411411-1-jakub@cloudflare.com>
 <62b3fd46af42c_70b1d2086a@john.notmuch>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, borisp@nvidia.com, cong.wang@bytedance.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net] selftests/bpf: Test sockmap update when socket has ULP
Date:   Thu, 23 Jun 2022 11:12:57 +0200
In-reply-to: <62b3fd46af42c_70b1d2086a@john.notmuch>
Message-ID: <87bkuj4u8f.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:42 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> Cover the scenario when we cannot insert a socket into the sockmap, because
>> it has it is using ULP. Failed insert should not have any effect on the ULP
>> state. This is a regression test.
>> 
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> Thanks, looks good. One small nit.
>
>>  
>> +#include <netinet/tcp.h>
>>  #include "test_progs.h"
>>  
>>  #define MAX_TEST_NAME 80
>> @@ -92,9 +93,78 @@ static void test_sockmap_ktls_disconnect_after_delete(int family, int map)
>>  	close(srv);
>>  }
>>  
>> +static void test_sockmap_ktls_update_fails_when_sock_has_ulp(int family, int map)
>> +{
>> +	struct sockaddr_storage addr = {};
>> +	socklen_t len = sizeof(addr);
>> +	struct sockaddr_in6 *v6;
>> +	struct sockaddr_in *v4;
>> +	int err, s, zero = 0;
>> +
>> +	s = socket(family, SOCK_STREAM, 0);
>> +	if (!ASSERT_GE(s, 0, "socket"))
>> +		return;
>> +
>> +	switch (family) {
>> +	case AF_INET:
>> +		v4 = (struct sockaddr_in *)&addr;
>> +		v4->sin_family = AF_INET;
>> +		break;
>> +	case AF_INET6:
>> +		v6 = (struct sockaddr_in6 *)&addr;
>> +		v6->sin6_family = AF_INET6;
>>k+		break;
>> +	default:
>> +		PRINT_FAIL("unsupported socket family %d", family);
>
> Probably want goto close here right?

Ah, thanks. Sent v2. I hope we can borrow a trick from systemd's book
and adapt __attribute__((cleanup(f))) in the future.

[...]
