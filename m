Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B44082C0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 04:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhIMCHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 22:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhIMCHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 22:07:44 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B91AC061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:06:29 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso11275820otv.3
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oyW4PMnzUNTlFzcpzqja9Tg/7sxKJSWnMnu37FZNUas=;
        b=KP+mTdAzNA7jRbyxrS5TDWPvX2BFXdMHXnwekz5tY2knAEp/P8FxaIC2irfJR9YrY3
         BpI7p3WyLKGYzQwOofE5dmuP9CnkhYv09akb+N7VqUsQe/w8EAh7os1VXRHX5ZHFY4r9
         ByODXy2OOj4isQvNhyD1ohqqOC/ZygGOfgi8ELFRWyjcCnedOxiORUo0al9eLJpLxt2D
         hrWnI/Rxc4rwcTPWk1eI6xytMLuk1jer+a3hIZ0dBE8dFn6ZTmjHt6PrQ8Fxer5zfKuq
         MJwpC87ktnHh0GNIoBc2mTLwLc9Aej3qdPko/bIOOaz6FKGvO3/hu0Er1QI8+ns5pqem
         TqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oyW4PMnzUNTlFzcpzqja9Tg/7sxKJSWnMnu37FZNUas=;
        b=46F79rs7oBr6lKDuiSc4aCR5QNvTg1qFdGJ8Q6ADkj6dBFV4/i4qMd6lHqz/ycFt/r
         hFENCC4j4x6P96OWISMcup3wTJyR5HzQ5cm8g/k2esasjk+qnh8Ne4ulIZyBNYF+nWIj
         URVD2ZMeIGOIJjRbPDwUJg+4xu1ga8CTUNsW1bWVSXBYihEbRP8fbIiJNkLt3bkjs9hg
         2mVVGF8JglIU6jsFDZTpWEpKDYa3o3gUue204aqW9XkMxTu1uNKPt66jkOemjJYymg/b
         VX2Xcu6+cxswXukMWiG5dQS9Cy0IqYzW/FSszGZaLSSBI8AGLPIRJkoUHa0LCSwYIhXS
         gFQw==
X-Gm-Message-State: AOAM5302mIQNSiGAdmKyNsLVqamyXBeHXSAC4KExwf7BkfU2neOKmuAc
        d3/UfJv9v722CPISoP/Ns08n+10It0k=
X-Google-Smtp-Source: ABdhPJxphtsssupc6xUJvxy5P1APND0gwkdNa9rjb5u2ek3UOjA4tTOXbhNCI1mh2mnljHMtAt/cZw==
X-Received: by 2002:a9d:12e2:: with SMTP id g89mr8001468otg.112.1631498787783;
        Sun, 12 Sep 2021 19:06:27 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a5c0:7e4b:65a3:3ba6? ([2600:1700:dfe0:49f0:a5c0:7e4b:65a3:3ba6])
        by smtp.gmail.com with ESMTPSA id u15sm1512067oon.35.2021.09.12.19.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 19:06:27 -0700 (PDT)
Message-ID: <763e2236-31f9-8947-22d1-cf0b48d8a81a@gmail.com>
Date:   Sun, 12 Sep 2021 19:06:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
 <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
 <20210912163341.zlhsgq3uvkro3bem@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912163341.zlhsgq3uvkro3bem@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 9:33 AM, Vladimir Oltean wrote:
> On Sun, Sep 12, 2021 at 09:24:53AM -0700, Florian Fainelli wrote:
>>
>>
>> On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
>>> On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>> Did you post this as a RFC for a particular reason, or just to give
>>>> reviewers some time?
>>>
>>> Both.
>>>
>>> In principle there's nothing wrong with what this patch does, only
>>> perhaps maybe something with what it doesn't do.
>>>
>>> We keep saying that a network interface should be ready to pass traffic
>>> as soon as it's registered, but that "walk dst->ports linearly when
>>> calling dsa_port_setup" might not really live up to that promise.
>>
>> That promise most definitively existed back when Lennert wrote this code and
>> we had an array of ports and the switch drivers brought up their port in
>> their ->setup() method, nowadays, not so sure anymore because of the
>> .port_enable() as much as the list.
>>
>> This is making me wonder whether the occasional messages I am seeing on
>> system suspend from __dev_queue_xmit: Virtual device %s asks to queue
>> packet! might have something to do with that and/or the inappropriate
>> ordering between suspending the switch and the DSA master.
> 
> Sorry, I have never tested the suspend/resume code path, mostly because
> I don't know what would the easiest way be to wake up my systems from
> suspend. If you could give me some pointers there I would be glad to
> look into it.

If your systems support suspend/resume just do:

echo mem > /sys/power/state
or
echo standby > /sys/power/state

if they don't, then maybe a x86 VM with dsa_loop may precipitate the 
problem, but since it uses DSA_TAG_PROTO_NONE, I doubt it, we would need 
to pass traffic on the DSA devices for this warning to show up.
-- 
Florian
