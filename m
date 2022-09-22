Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030DA5E673A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiIVPgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiIVPgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:36:16 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648A3FB30F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:36:15 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id c6so7057590qvn.6
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=0XDNA9xHJMpQS14lG/g7LpIJFt7UCTCQ1PdBp+r0/7Q=;
        b=BKgT2KqZ8lBlzk2t33WkJT08ESCaxDNZiVk+tPZ2uL1nGnHYc+pU/mjc0Jr7THrewh
         y4wP4NhKKLW7maJAwcjoQvWm+xCCTqrv9QpkPjKt1gwxjFl9tayPZil60bxgvrzwN0FZ
         7iszlYo8GUppXrMqMKB66CXLkGc/iFfLf48QJIox8ce8Hl2m9X7pBPL3aYQeJojc5PKG
         7Rkbl0Z5r89MtFVBRbYXcx5DkQdRlkXUkoqwNLdQSMLrWAdhdR60RIJTTu5QJkG96Bqh
         oSIsKCZbJ8bqMAk6nYJVbK+vPsjLYRhO5iSDJ5YPoGTgJD9eLFGTgmOm9Av+DlNY3Dgk
         lv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0XDNA9xHJMpQS14lG/g7LpIJFt7UCTCQ1PdBp+r0/7Q=;
        b=Cr55edRFAOm4lZsD6hCL93msiPR9KOpR0xu3DsPkHDpJN7gMTwzTaamwUMrd6CDt+P
         sSXWwMkpL/PcWEdjPQ+YHPy90NSWb2mYmL6UF+Hqp1H3+EdQ4VsdbpxDecIUKTjDxPgf
         yYp/ilRTMIdFzNV4w8KybAS9V27xk0VlG5OehvQIWZm+fXJoD8SxUO/okFARSobIbitl
         AZB38EsOGPOFMxD6CPnW7x23j/g3P0MS/c4C5FSZt3MhbNmDraJz7Y1OVFAlDwfFnIcy
         659+SjJPJVLsIWLEnJbT75eI80p0y5MJuv54cC7nW7KtuLF1iQ6wh54zHOJ9OdEoDe2l
         xpcw==
X-Gm-Message-State: ACrzQf0GETmN4gLBXBBB5NH6qqaGkWYb2GKdyO7X2zxjacpatJHKX7AO
        M9+2nAM0tH4r4/A+YesKfwVIvWSVsXg=
X-Google-Smtp-Source: AMsMyM599ykSl/x7Sg0QdqLaolAQiub/WBPSVT60+GUhmz2OIvarS3hPiuoOaYQHKzcPlsHtu76lww==
X-Received: by 2002:a05:6214:2301:b0:498:9f6f:28d with SMTP id gc1-20020a056214230100b004989f6f028dmr3135146qvb.5.1663860974464;
        Thu, 22 Sep 2022 08:36:14 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h7-20020ac85047000000b0035d0520db17sm3429777qtm.49.2022.09.22.08.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:36:13 -0700 (PDT)
Message-ID: <d6413510-0b75-be83-0ff1-f34be6c3974a@gmail.com>
Date:   Thu, 22 Sep 2022 08:36:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local> <Yyu6w8Ovq2/aqzBc@lunn.ch>
 <20220922062405.15837cfe@kernel.org> <20220922082724.7abb328a@hermes.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220922082724.7abb328a@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2022 8:27 AM, Stephen Hemminger wrote:
> On Thu, 22 Sep 2022 06:24:05 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
>> On Thu, 22 Sep 2022 03:30:43 +0200 Andrew Lunn wrote:
>>> Looking at these, none really fit the concept of what the master
>>> interface is.
>>>
>>> slave is also used quite a lot within DSA, but we can probably use
>>> user in place of that, it is already somewhat used as a synonym within
>>> DSA terminology.
>>>
>>> Do you have any more recommendations for something which pairs with
>>> user.
>>
>> cpu-ifc? via?
> 
> I did look at the Switch Abstraction Layer document which
> started at Microsoft for Sonic and is now part of Open Compute.
> 
> Didn't see anything there. The 802 spec uses words like
> aggregator port etc.

Top of the rack switches typically have a built-in DMA controller for 
each user-facing port such that there is not really a management/conduit 
CPU like what DSA supports, that is the whole reason actually why we 
keep having a separation between "pure switchdev" and DSA drivers. If 
you had not attended the talk from Andrew, Vivien and myself back in 
2017 in Montreal, I suggest you watch it now in case it provides some 
inspiration for suggestion appropriate terms:

https://www.youtube.com/watch?v=EK5ZmQOYSpM
-- 
Florian
