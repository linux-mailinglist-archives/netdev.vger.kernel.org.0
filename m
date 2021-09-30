Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A641D0AE
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347370AbhI3Alx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347526AbhI3Alw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:41:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46DC06176E
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:40:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id k26so3429003pfi.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yi+V+sFOvpT3hz/FdhWSxXL16FRs62cd+cZfa7Tq0fc=;
        b=jrR1qoEQiX2wdAhCvGwSZXwxOfj3TrpHFl7KMgQ5oKzXZzdn4pYwCgn9YoKurHiT9u
         BBHfGFCTAnErTmp0zZ8RZ+F7nDeNSSffJI3oIHA/+ZBjScIT+NwTuudPdZDvoWmZlIZy
         oSERG0u1A4JwAu3sCKGvsMAWCJI2L1OGBFhbky01PX+M0TfqNMRqgRDVhOHpH1IXx70P
         hIAJwiwfg4o76Q0JbW06OYnl7bOmOHZUGr6TRWfw8mHSrBsvsSN5d1iDD7sunKC7rLYh
         BGIN32loGLunilVCQfGGpDkJYPD7cNdwProM5+qQcuptHT6xBxGqhkhzLPn8xZKYe9e+
         LayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yi+V+sFOvpT3hz/FdhWSxXL16FRs62cd+cZfa7Tq0fc=;
        b=DZO4mF/LaAV3b/2tN1yK7HFMfhbmIV6KHWnaE1bBVftHC1/3wfOxWNZXnyGEa43JrE
         a6yFF6M94eoLfNxPcEiLMvNwDOhXppVLmnrukfulNkPLnOXejiaie1sfGKJSd7OX7KFt
         aStG46uwcHFJBjtch+mBvwdL/0x4x5aqFB65D9TiWw11jk/Q32/Swx/O5Jo9byQ8avli
         CqWS2eWfFVzN+BR7HTLM/1SYnM4k5QLN2Ckbom78ZKHTHxxFd0OuBp9GyUj03sRSEPNr
         wy+DuPft4k1j9doHk9P17BYrpQjp0MHCAeZKnN0FS38lHLTZFbDUGb0I3s6TX986JXbs
         Arhg==
X-Gm-Message-State: AOAM532qmuplKYEZLIRa/2hVNvL7r8b21ZTRreobOG1A14mXBbNOHCnS
        EZpoLNvL1GoEee0sPa00WLzXUhtkQWI=
X-Google-Smtp-Source: ABdhPJx1h+sNSxsjFGtA8TQ4CJeKWkmvTtuNWwK0MvpC76LqKSklbX+VLSAJKrNpN0/nWxnZAgRv+g==
X-Received: by 2002:a65:448a:: with SMTP id l10mr2335535pgq.313.1632962408173;
        Wed, 29 Sep 2021 17:40:08 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i27sm803312pfq.184.2021.09.29.17.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 17:40:07 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
 <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
 <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
 <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
 <8768df9e-f1f6-db25-15d8-cabed2346f32@candelatech.com>
 <b7df0abb-8bdd-6348-a60a-75a66d6a9d91@candelatech.com>
 <c4000c2a-8894-c3f5-9497-82bce4615be1@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aa633585-0f0d-edf2-5659-72a49c1061c6@gmail.com>
Date:   Wed, 29 Sep 2021 17:40:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c4000c2a-8894-c3f5-9497-82bce4615be1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 5:29 PM, Eric Dumazet wrote:
> 
> 
> On 9/29/21 5:04 PM, Ben Greear wrote:
>> On 9/29/21 4:48 PM, Ben Greear wrote:
>>> On 9/29/21 4:42 PM, Eric Dumazet wrote:
>>>>
>>>>
>>>> On 9/29/21 4:28 PM, Eric Dumazet wrote:
>>>>>
>>>>
>>>>>
>>>>> Actually the bug seems to be in pktgen, vs NET_XMIT_CN
>>>>>
>>>>> You probably would hit the same issues with other qdisc also using NET_XMIT_CN
>>>>>
>>>>
>>>> I would try the following patch :
>>>>
>>>> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
>>>> index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..0a2d9534f8d08d1da5dfc68c631f3a07f95c6f77 100644
>>>> --- a/net/core/pktgen.c
>>>> +++ b/net/core/pktgen.c
>>>> @@ -3567,6 +3567,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>>>          case NET_XMIT_DROP:
>>>>          case NET_XMIT_CN:
>>>>                  /* skb has been consumed */
>>>> +               pkt_dev->last_ok = 1;
>>>>                  pkt_dev->errors++;
>>>>                  break;
>>>>          default: /* Drivers are not supposed to return other values! */
>>
>> While patching my variant of pktgen, I took a look at the 'default' case.  I think
>> it should probably go above NET_XMIT_DROP and fallthrough into the consumed pkt path?
>>
>> Although, probably not a big deal since only bugs elsewhere would hit that path, and
>> we don't really know if skb would be consumed in that case or not.
>>
> 
> This is probably dead code after commit
> 
> commit f466dba1832f05006cf6caa9be41fb98d11cb848    pktgen: ndo_start_xmit can return NET_XMIT_xxx values
> 
> So this does not really matter anymore.
> 
> 

Alternative would be the following patch.
NET_XMIT_CN means the packet has been queued for transmit,
but that we might have dropped prior packets.

Probably not a big deal to make the difference in pktgen.

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..5c612cbc74c790f64aff5ce602843378284c7119 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3557,6 +3557,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 
        switch (ret) {
        case NETDEV_TX_OK:
+       case NET_XMIT_CN:
                pkt_dev->last_ok = 1;
                pkt_dev->sofar++;
                pkt_dev->seq_num++;
@@ -3565,8 +3566,8 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
                        goto xmit_more;
                break;
        case NET_XMIT_DROP:
-       case NET_XMIT_CN:
                /* skb has been consumed */
+               pkt_dev->last_ok = 1;
                pkt_dev->errors++;
                break;
        default: /* Drivers are not supposed to return other values! */

