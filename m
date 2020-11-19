Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF32B9A36
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgKSR4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgKSR4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:56:50 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3735C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:56:49 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id p8so7407037wrx.5
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qW8/m9wt1an7LRw7bO85qP5rUEdxBv3m4pQ1jAHQ+0Q=;
        b=p4nFR19lRi5gdzZmmfG5QDRGQGQFoGItC2GqzByMxMn5rDonvwPfjYd2qaM7vrGCPH
         Ye/sgu2wJBV2w5c/VoVNSJWQAg9TH2K1498+ii7t8VUeAR2JAfwV49i5iDkNeR1igCKr
         mfbOkWLtlFYW0htabz7zzf2Ta3tIX37mtaOoriqT21Q9XbN5MS0yxjSDc7elYZyYlXyI
         pkHnRzzgW6FPcaRhAWfHCN6dKf3RL7QWtoTVnEKvVHupZsQzt5EdJNdfHC8aquD36wn5
         VpxRBahmWH5k2gR8x2Wu3tHxINvzt08U7ivAoXMe61j/awvM6UfVa4Mfwt3uqAfFilIG
         0/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qW8/m9wt1an7LRw7bO85qP5rUEdxBv3m4pQ1jAHQ+0Q=;
        b=f80LduNmRU+2DYE9TEwdPEzrmCFmgF0d6dgx1o2KZGuTVopO9T2WkKejpq+ErdCno2
         w909lwRe03X1ZMx56rWfPYVf93hiDpHSAXFpGFDnUFovxYT1J0e9CGxesN1Q/yBJmT+A
         8V2c7cOyJHWzPGwdX6x+rrmR6obICASuA9XMBscn5M1VCCGFRBti3izFhDRlGnKv3gHf
         wN+NwBktXGgmNVo/nP+LrBQ3BPiorK0wogRShGC2pp3aeDxfcJGrGJ4zjPdi66ryqXEf
         d7yQeYFuxoWlv66BaBCQodBPVii1NnEuE0N+erTrqrR50+aQS1eFETjJ9qjh3oyeYTDk
         l5Zw==
X-Gm-Message-State: AOAM530UkGbSFCku/oR6yCqpFpV0VK+ODwV/NQegvFXrjcNHUfXzWIqf
        u51YSNRx+J3lHfm5Msa7XkcTTAvwqwo=
X-Google-Smtp-Source: ABdhPJwQnCn5O8IEzo9WwGkpGmwsHTtpCLEgyTMiWWu27ZqatJTAWzFDYSCH0c8wy5Ors1D+8pPzCg==
X-Received: by 2002:adf:8143:: with SMTP id 61mr11402879wrm.318.1605808606463;
        Thu, 19 Nov 2020 09:56:46 -0800 (PST)
Received: from [192.168.8.114] ([37.171.129.101])
        by smtp.gmail.com with ESMTPSA id c62sm840188wme.22.2020.11.19.09.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 09:56:45 -0800 (PST)
Subject: Re: Flow label persistence
To:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CALx6S353fPF=x4=yr4=a4zYCKVLfCRbFhEKr14A1mBRug7AfaA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1a40fa35-6ef0-5b42-3505-b23763309165@gmail.com>
Date:   Thu, 19 Nov 2020 18:56:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CALx6S353fPF=x4=yr4=a4zYCKVLfCRbFhEKr14A1mBRug7AfaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/20 4:49 PM, Tom Herbert wrote:
> HI,
> 
> A potential issue came up on v6ops list in IETF that Linux stack
> changes the flow label for a connection at every RTO, this is the
> feature where we change the txhash on a failing connection to try to
> find a route (the flow label is derived from the txhash). The problem
> with changing the flow label for a connection is that it may cause
> problems when stateful middleboxes are in the path, for instance if a
> flow label change causes packets for a connection to take a different
> route they might be forwarded to a different stateful firewall that
> didn't see the 3WHS so don't have any flow state and hence drop the
> packets.
> 
> I was under the assumption that we had a sysctl that would enable
> changing the txhash for a connection and the default was off so that
> flow labels would be persistent for the life of the connection.
> Looking at the code now, I don't see that safety net, it looks like
> the defauly behavior allows changing the hash. Am I missing something?
> 
> Thanks,
> Tom
> 


"Stateful middleboxes" using flowlabels to identify a flow instead of the
standard 4-tuple are broken.

No sysctl addition/change can possibly help, since it wont appear magically
on billions of linux hosts.

Your question is a bit ironic, since historically you wrote the
first change for this stuff, without a sysctl.

commit 265f94ff54d62503663d9c788ba1f082e448f8b8
Author: Tom Herbert <tom@herbertland.com>
Date:   Tue Jul 28 16:02:06 2015 -0700

    net: Recompute sk_txhash on negative routing advice
    
    When a connection is failing a transport protocol calls
    dst_negative_advice to try to get a better route. This patch includes
    changing the sk_txhash in that function. This provides a rudimentary
    method to try to find a different path in the network since sk_txhash
    affects ECMP on the local host and through the network (via flow labels
    or UDP source port in encapsulation).
    
    Signed-off-by: Tom Herbert <tom@herbertland.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
