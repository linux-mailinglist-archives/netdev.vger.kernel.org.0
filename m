Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFAA2F56B7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbhANBwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbhANAIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:08:46 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F596C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:08:06 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id q25so4110550oij.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yZg1JgJ9qrwPawojzwQs1iWSvOqOUk9jQ09pjTV9/mU=;
        b=vS38l87FzycdKEMSP5T3KAPg0YnfrAVT9NwHDa3b64MbmdkV1O18nOJKWVBawExOWv
         qHmkHWFQu0UP9OMcQjsnWZ2RgNmOr19BVv8iCDwgY96pF6j6PJmph5RzKKHg44oMGkB6
         3ONILHZKkXk+HFG+retyKsV53DabVt42+SROyMt090oF35L1eVxWgNmEJTyyhHSrANJ1
         6ZcbNmXyUI37qA9AKrJcGcJScLJaSzaILfi9VJY99v00Rh3aezDd5pUIb13UNrH+NXo9
         +XTpnXxr6pTwC6CDT8zVF4NR7mm9CIH1AVenZuCEZDqifk9J/4v9BAx/Kr5zp16mHutM
         vr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZg1JgJ9qrwPawojzwQs1iWSvOqOUk9jQ09pjTV9/mU=;
        b=Gp/NsnMj+HUMQ8uSFB6nq++6u2AdHLO6Qrs8IhssayHrpZ7vH6C+DEOTm6h0cXs1Kc
         YzsRWy7T9otM0e9R6gVYIHljwTgIpERzov3rJMDp7PniuQ8UN7/MNmClCkuJ2EWcu4KV
         +CaulDau/p6lKd86JielghtGBpdgr50s+O2RkMGDb2AHObWyxnCzncO29KtGBk2d6N+f
         FxLtQj5Y3trp53hxvx4QszXZF3VTQCCRaW88eLHxqjGvh29Lwm4KmUoLtErsdamiQxLM
         vXdEyrZRFMsZF0rKvvZZVIYixrbqbHRWLjv/AnDIg624uL4MtEbVzWLIEUPQgpx4qawV
         4T0g==
X-Gm-Message-State: AOAM530KbYBL1H5E40iJaGvAS9gEWpjLUhnt+V8HV/MMWNHfxY9SpMSS
        Yb3ar8s+WubMPhPahWa2Sli2wlsLZrU=
X-Google-Smtp-Source: ABdhPJwoRN2nSh1yqZ6ZT7Gwd8HBQYhVGJzk1dwMGRGxAp7GswWCppTeQ5usLSE9Sdly8h0sDfJfNg==
X-Received: by 2002:a05:6808:3d3:: with SMTP id o19mr1101815oie.164.1610582885780;
        Wed, 13 Jan 2021 16:08:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id z6sm745329ooz.17.2021.01.13.16.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 16:08:05 -0800 (PST)
Subject: Re: [PATCH net-next v3 06/13] selftests: Use separate stdout and
 stderr buffers in nettest
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, schoen@loyalty.org
References: <20210113040040.50813-1-dsahern@kernel.org>
 <20210113040040.50813-7-dsahern@kernel.org>
 <20210113155652.5fd41775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ecc131c9-f60d-5f89-9c1a-3bd77907e822@gmail.com>
Date:   Wed, 13 Jan 2021 17:08:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113155652.5fd41775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/21 4:56 PM, Jakub Kicinski wrote:
>> diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
>> index 685cbe8933de..9114bc823092 100644
>> --- a/tools/testing/selftests/net/nettest.c
>> +++ b/tools/testing/selftests/net/nettest.c
>> @@ -1707,9 +1707,27 @@ static char *random_msg(int len)
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
> So this patch did not change? Did you send the wrong version,
> or am I missing something?
> 

yes, I did. Will send a v4 later.
