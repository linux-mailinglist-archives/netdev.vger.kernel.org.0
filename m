Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD22CDA6E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgLCPxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731074AbgLCPxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:53:50 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7185C061A52
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 07:53:10 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id t18so2176026otk.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 07:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t+MHhpR3MUZs/FfNVU/5dfimiVU/ToUCwwwcpj4hCug=;
        b=HpP0EXSCKYMwSWNnloCY8VCWjcHGOcxK/xG2ovUV1+zYLRwTr2XvEE2t/zNpUY7vii
         1tAcIdIlC8b9CoRGsLbHf1d7+H/AFC4RZt0z04P4h9bdTAZfNAAsIkm6D1EtITJ0hIjH
         qMuKQcBAURGjG0pjoErrOUlgWAhlE+FmvPte/94+gOjMm6bXinMnfRWHO3fcvW56fB/+
         t/sJxhUxPICt9rkwcCf4DN1KAc5TJ7DEnG9MmUgEDKV7C2pGF6Tc0cKzMqRBAJwJHUkS
         YQVDmG6jQvhODA6900M22Q48VLlcfYcTA1PWHxh/mfVNEty0ENPgwqVsA0BXedWa3/VH
         nv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t+MHhpR3MUZs/FfNVU/5dfimiVU/ToUCwwwcpj4hCug=;
        b=DOwN02P9XR0u8gTDdprZD3THpwGriW8sEA0jqaswDHx2daHm+U2vvOEoyXLkJGd1Co
         99gnrgzyjptnwbpLHc4DX9HzhixyZIlrNwbgpYLnhWkl1IFMkKgAVZXNC7vtskKTfKaY
         Al0Pj+zArflepBhe4kHTGnRxoL5QLh7GgjynI9y5WICBdcWPWSbmbV3ei1PCtK9/6xDw
         9QBQk7cJ6Tw7W1+ZTdDRM7aNYCExmT1VaMFE8UFiWP05rnGe1b/xGnYsORZeDmdHbDht
         ekt+nTH3FE29bLH8ucBFR+PhXLI2zZ+i/7B1cmKPm46RRNWUgkjzo/pxknHqfporVGDZ
         VkmQ==
X-Gm-Message-State: AOAM532BK/IHGcGOIVu2EbdD6Am8lG2m1/deIKbWlM+4wSvy0JlAQgSC
        1tF5H0MTExUWUeCy7tZriJ6NMO526yo=
X-Google-Smtp-Source: ABdhPJzAAqo8J+IbDQDv+RppIOh69M9ot1IE0rCuui7aHrZqeZHeCvBzthFAC4u050XlmN4ZiMiqqA==
X-Received: by 2002:a9d:4806:: with SMTP id c6mr2516988otf.66.1607010790073;
        Thu, 03 Dec 2020 07:53:10 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id 186sm287883oof.16.2020.12.03.07.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 07:53:09 -0800 (PST)
Subject: Re: VRF NS for lladdr sent on the wrong interface
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20201124002345.GA42222@ubuntu>
 <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
 <20201201190055.GA16436@ICIPI.localdomain>
 <70557d4f-cf35-ddba-391c-c66aa8ca242a@gmail.com>
 <20201203130109.GA26743@vmserver>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <efe9d882-10b4-d3ec-f345-7a5338d2d5c1@gmail.com>
Date:   Thu, 3 Dec 2020 08:53:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203130109.GA26743@vmserver>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 6:01 AM, Stephen Suryaputra wrote:
> The tests in fcnal-test.sh passed. There are two failures that are
> expected, I think. Attached is the output.

I'll take a look at the failures.

> 
> If you agree that my patch is the right solution, I can send the patch
> out for review.

I think so, just trying to understand why that change was not needed
until now. Go ahead a send as a proper patch. Please add the commands
for this use case to fcnal-test.sh. There is a catch-all 'use_cases'
section. You can add it as a another one. Do the ping in both directions
after initial configuration and again after cycling the netdev -- shows
success after the route table re-ordering.
