Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA8242002
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHKS5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 14:57:38 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A189C06174A;
        Tue, 11 Aug 2020 11:57:38 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id u28so1728064ooe.12;
        Tue, 11 Aug 2020 11:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0q6pcldhorcj6nNNaBM6YAkqvTbJCDXZHgFjgiyBoRw=;
        b=ghGOWq7PofyXLECDilGEwXF2TBqFOkBuirhuIoCCgn4iKoIymRa5RsaIlny/qqQcjZ
         8OU0sfhfrIBWFFEDhrpmLJ5to5p2ByEZ82qhALHarDo0rMjQhsh1W6DmhXY/7gN+0RjR
         RWVSBVi8uPj98ooMOHWZuW7UFgBV2xuRRQsXLX9Qx3qkW+ZabRJEa9xVcHaQEymDf07e
         Phdg9weTFi6+e3B0AaE3HgSrR/Yh6ageVHO5Xt5PtitOHSQ0o+u2r/3AikpJcWD7sxSK
         aYtilSKf/Eg/jvXRD7n5x4BX6iz2lkB7UtiMX9g/g0+qeHhVYSACN+lO99OP1nKtSKVg
         FTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0q6pcldhorcj6nNNaBM6YAkqvTbJCDXZHgFjgiyBoRw=;
        b=IUef4AQkTWaWlKOCfhryvYlTI/JKPHbxqJYO74y6MfyciHRoT9hheKJ/M9074zQgJ0
         9hjWf1TSo8vaQLaG3xvprn2AMsqSqUkp7H3ZD4an3rNJ9LdKKRIUU7mePQoPcNseBjdm
         POEhEoo4npdFRn4Xn6k/XDQaBObfFbC/ZDuumDtOkf0RXxhvjxgCXn3c2vK7s5K9gYG2
         hcgMONmkNgK7KL0O3vZXggtZtsQO0UiHekJnPTAGd2q0OTGHmX01WDLj0b0zJaNtNAb/
         25f9PBP80S7zXOn6LhLHTwEIg4PCeH03f0uf54BRUTpRnj4TY+06NWQ7yyF9UHOKMQPp
         1X6A==
X-Gm-Message-State: AOAM5311CqVOIVYSwNbkTJZF3/KGw7EvoWsO1Sz9xMoC+sGRCjKvfZPV
        ybWkxAjQU+t5wtamX0gm90KWM8RI
X-Google-Smtp-Source: ABdhPJzw3VfZCGfIDhpuRrVdMzhFukEAzvXDQ9hQJEq7pXE3fXjEgAzni89v4AYbR/+6juo15wfUmQ==
X-Received: by 2002:a4a:9e41:: with SMTP id w1mr6546787ook.87.1597172257572;
        Tue, 11 Aug 2020 11:57:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:1c6:4d6a:d533:5f8b])
        by smtp.googlemail.com with ESMTPSA id u17sm4482256oiv.14.2020.08.11.11.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 11:57:36 -0700 (PDT)
Subject: Re: [PATCH] selftests: Add VRF icmp error route lookup test
To:     David Miller <davem@davemloft.net>, mjeanson@efficios.com
Cc:     dsahern@kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, netdev@vger.kernel.org
References: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
 <20200806185121.19688-1-mjeanson@efficios.com>
 <20200811.102856.864544731521589077.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f43a9397-c506-9270-b423-efaf6f520a80@gmail.com>
Date:   Tue, 11 Aug 2020 12:57:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811.102856.864544731521589077.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 11:28 AM, David Miller wrote:
> From: Michael Jeanson <mjeanson@efficios.com>
> Date: Thu,  6 Aug 2020 14:51:21 -0400
> 
>> The objective is to check that the incoming vrf routing table is selected
>> to send an ICMP error back to the source when the ttl of a packet reaches 1
>> while it is forwarded between different vrfs.
>>
>> The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
>> output of the command to check that a ttl expired error is received.
>>
>> [This may be flaky, I'm open to suggestions of a more robust approch.]
>>
>> The second test runs traceroute from h1 to h2 and parses the output to
>> check for a hop on r1.
>>
>> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
> 
> This patch does not apply cleanly to the current net tree.
> 

It is also out of context since the tests fail on current net and net-next.

The tests along with the patches that fix the problem should be sent
together.
