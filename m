Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303FF445758
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhKDQlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhKDQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:41:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB5BC061714;
        Thu,  4 Nov 2021 09:38:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so5894464pgc.6;
        Thu, 04 Nov 2021 09:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XdJVrf9pNAl7BlZCVazZHbi0TUrSpMei3Pt6/bMN1co=;
        b=pgRUxQKGU0e/5ENng9OIGIRQURz0UEq5MLJxMdiwhh69EldcGsquum8f49E9ymKT4r
         6L7+rEFf4LFQPNKNLnOm8f5SLf75idGpWxPSnEUfet2MByu9jsX5tzs8aWaAqDCsOA+F
         BXQXoyL2nSFvX9L3I9+U19ZxOZkNW3LvC/CDd0OiJUobAqOcLaM6seX6FAGMfI37F12N
         WY86q3Yc7LVC0H1UtLpxW+7iNY1XO0pNRpIRo/cVUZjYYHXVFvGFwrASywo9ubThKJDA
         DoWkgzurtwpqEajVfzL/2N6SJIbQI2G4ROAvB2BSw8X7TmG82F2l0rNgR3RGWTFAdqUz
         Aczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdJVrf9pNAl7BlZCVazZHbi0TUrSpMei3Pt6/bMN1co=;
        b=xXn7EkbHBFnT0OX9CK25SV80MHJdcd3CCT9YQaCXmn/Ghz2Q/jMVQvC0nUDMQ1EM59
         M0ltIau52V2ntK11jiUfhvyps+hflZW18AGp9HVrwKkvaFj5EVvI4LdE1meWdIbdUjW+
         iepCRGpQmLsqELsRTzQjqWpo4sK3grhQg8yc74vc3TmGNvANsRsp7ZBA/6Ynq7FCjPzJ
         kwyGsJMlMLGnDHx5jkP+U+UO2N+iIm/QIKsYyM3yChPOs+/6dudsobic9t19rprIFPUR
         iG9AzBJzNNj+AXBydhuwJjseXmoT4mPxs8FqqwbdgVUT3sPX62DKSffo/KR6XQq0DwyZ
         Jqrw==
X-Gm-Message-State: AOAM5321lml1SOiJt4rWO8RuEzbllxY/871gTtRPXyMwUxtbxbiKNfzX
        BxsWbctQmlKWZy+5yqGDMtqdycpR78Y=
X-Google-Smtp-Source: ABdhPJxADAWi9XYzDZQndcrS9mjUOymjMRreIKNJMzS5ob/wZJZPyXUyNO+ICpn+Kxych4PVcho7qA==
X-Received: by 2002:aa7:9250:0:b0:44c:27d1:7f0f with SMTP id 16-20020aa79250000000b0044c27d17f0fmr52275236pfp.41.1636043908403;
        Thu, 04 Nov 2021 09:38:28 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e7sm4200753pgk.90.2021.11.04.09.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 09:38:27 -0700 (PDT)
Subject: Re: [PATCH] tcp: Use BIT() for OPTION_* constants
To:     David Laight <David.Laight@ACULAB.COM>,
        'Eric Dumazet' <eric.dumazet@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Wei Wang <weiwan@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cde3385c115ddf64fe14725f57d88a2a089f23e1.1635977622.git.cdleonard@gmail.com>
 <e869d690-939a-a5a5-1a8c-fe4b550b69ab@gmail.com>
 <0b48f1ae32ba49f38dcfe11f912c4ace@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <60a45fd0-7055-e2ca-8254-1ccbc3fb7370@gmail.com>
Date:   Thu, 4 Nov 2021 09:38:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0b48f1ae32ba49f38dcfe11f912c4ace@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 2:17 AM, David Laight wrote:
> From: Eric Dumazet
>> Sent: 03 November 2021 22:50
>>
>> On 11/3/21 3:17 PM, Leonard Crestez wrote:
>>> Extending these flags using the existing (1 << x) pattern triggers
>>> complaints from checkpatch. Instead of ignoring checkpatch modify the
>>> existing values to use BIT(x) style in a separate commit.
>>>
>>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>>>
>>
>> Yes, I guess checkpatch does not know that we currently use at most 16 bits :)
>>
>> u16 options = opts->options;
>>
>> Anyway, this seems fine.
> 
> Doesn't BIT() have a nasty habit of generating 64bit constants
> that just cause a different set of issues when inverted?
> It may be safe here - but who knows.

BIT() does not use/force 64bit constants, plain "unsigned long" ones.

Really this patch looks a nop to me.
