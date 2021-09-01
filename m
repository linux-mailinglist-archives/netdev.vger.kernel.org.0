Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E3C3FD156
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbhIACaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbhIACaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:30:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB69C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:29:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q68so1217857pga.9
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4+iwUAqRJPZFhGI73o3Zv3rff4AudFKJDzrL7OGaY4E=;
        b=f/FYv4nlGKVV93m9RtKw1dAEY6TWLMrl1gdpTDwIoaZGuTzDYGLpLplJ0nTnFg4z0l
         qWjPSLFmn0j1FmbPKbnZDbLywcy2IfUGb6BXB411c//Wg6nd7rNObO8L6A9jftLra8En
         AH/SPFUi4jlun+y0UfuR7JRoM4JwF/uxVyVAQp2qKOwnik71mqxC5Yxyci2YzMCKdWOS
         Lc4EanRWSzUVGM6VKKAAIlJnMaLEtqHbggDVo970xWnudeS6AR/DNlxxzVniJWIT5Qrw
         Gvg7+fhnKhY3tp40OLAl99Md/QRi8tXehM/NLDfLSrECGu5lOp3cOCTyk0MeCB/tUioF
         cmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4+iwUAqRJPZFhGI73o3Zv3rff4AudFKJDzrL7OGaY4E=;
        b=Y5M/wVihwlOKhNjpefivWDOPagYd2jNDfOrpUYwkpIzymESHLlwBM+pP2/irgdc9VW
         5vNiKj50iNATckCNmyncvfUOPrL8pw8+V52crkj6ULywUWTVB/dC3x2/v/wBQXr25D7q
         XJD9gG67nDmZ9rMCK/NJnIiTKQa7QlkB8u8VQhiMc4OJq8POcQ7m3P7REjgQTrm+zDu0
         HdfORGDc0vygeg4we4S5Z2HNuDWOe6pWyqUa1Ah7sfqCJmjFb3yvZuo15Yz4ABF2G0Iz
         YAdK+DsuDgUm6gmlklQGpwe8YFJEoN7AyeyVE8VjHObpbuG5O+FRiOb/ZrX8yJmNia0w
         W+4g==
X-Gm-Message-State: AOAM5329njLMj75MbZAEuYY5Ohd8ZrRA1XPOPiRfd9zEiJwI5MgnLj9N
        j9HcyuImONrJYIESZu8Hw1g=
X-Google-Smtp-Source: ABdhPJySz6shuVf4t3xEMCqWs24dszc+b8jf8QFCXAyjmnK9HC6dKXFvDGypo3usRKNNN+ezKdRJrQ==
X-Received: by 2002:a62:1c4e:0:b0:3ee:7c8e:ce6 with SMTP id c75-20020a621c4e000000b003ee7c8e0ce6mr31193091pfc.60.1630463358716;
        Tue, 31 Aug 2021 19:29:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id m64sm22597143pga.55.2021.08.31.19.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 19:29:18 -0700 (PDT)
Subject: Re: Change in behavior for bound vs unbound sockets
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Mike Manning <mmanning@vyatta.att-mail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
 <06425eb5-906a-5805-d293-70d240a1197b@molgen.mpg.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e8ea879b-7075-e79d-5da8-0483e7da21af@gmail.com>
Date:   Tue, 31 Aug 2021 19:29:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <06425eb5-906a-5805-d293-70d240a1197b@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/21 3:12 AM, Paul Menzel wrote:
>> I traced it to one commit (6da5b0f027a8 "net: ensure unbound datagram
>> socket to be chosen when not in a VRF") that makes sure that when not
>> in a VRF, the unbound socket is chosen over the bound socket, if both
>> are available. If I revert this commit and two other commits that
>> made changes on top of this, I can see that packets get sent to the
>> bound socket instead. There's similar commits made for TCP and raw
>> sockets as well, as part of that patch series.
> 
> Commit 6da5b0f027a8 (net: ensure unbound datagram socket to be chosen
> when not in a VRF) was added to Linux 5.0.
> 
>> Is the intention of those commits also meant to affect sockets that
>> are bound to just regular interfaces (and not only VRFs)? If so,
>> since this change breaks a userspace application, is it possible to
>> add a config that reverts to the old behavior, where bound sockets
>> are preferred over unbound sockets?
> If it breaks user space, the old behavior needs to be restored according
> to Linux’ no regression policy. Let’s hope, in the future, there is
> better testing infrastructure and such issues are noticed earlier.

5.0 was 2-1/2 years ago.

Feel free to add tests to tools/testing/selftests/net/fcnal-test.sh to
cover any missing permutations, including what you believe is the
problem here. Both IPv4 and IPv6 should be added for consistency across
protocols.

nettest.c has a lot of the networking APIs, supports udp, tcp, raw, ...
