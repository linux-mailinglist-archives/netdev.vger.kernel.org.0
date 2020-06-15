Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365911FA3A8
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 00:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgFOWm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 18:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFOWm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 18:42:56 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D4AC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 15:42:55 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b27so17410662qka.4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 15:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Nye8Ql6VwBR67ZCtzVWDrSvlcWgMab2WYMoX+UPnlc=;
        b=qaXAb4IxrBcrc9gqJ9/fOqa2W1jK0dXpXInjtzxJgyvN013WYsRpHJT0D3HYh2HIlh
         AT3seU0O2orQvVyBUj6SrSjmNEJriVri/LQ2vbP4n5qsFM45pmfInf3pNhDYm7wRi2o3
         b30bUuYYIrDqC5qtbJsN1wAinCzKrXBs1W6BfuftsSMsca/wQhAKaxBKNHNB1PAA5B77
         iVnotA6yPT+pvsuVgQPTVFd8zCFSB9tcDHGZg2+iawal6o5Vm8fq0PG7Lta/bZsGDqgU
         /6XgAbAElncUhDSFoqR4O2n77unuHV0ISkuIKYxEKAuHY9PywZb//z3Q+ewZyepRaThr
         Zefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Nye8Ql6VwBR67ZCtzVWDrSvlcWgMab2WYMoX+UPnlc=;
        b=RgtNVLwXxrxMq2Up7Kkm3QSYT0DJNxaVsC6r1hyU0Q4YQQrWi6ikelyZIEe8T9xgh0
         dHsSAG9z45QZwombvpSJpl3cYW+3K2FwhgZN/P8FYSatwBD4OBpdrOuVHbnmMSgZ9aoU
         xkpQMOudxJ/ridUw8fPIoEFIe7aS0hb584iFEosqd1VkiRJNHlx1kVNWXGWk3Z3GgmD+
         5DFS/7tIhKkNwmxQIHnDglbKDKsKVNAGWHUGHtmdV6T08QYWrC82MRDn1KQ74N/g/G3G
         xf+5Z83L30BqSwAzMnlyVYSHWwEfDk+ijAVYzecMltNVPuLyNYoY7bVbVNQO8uHsdb05
         OtIA==
X-Gm-Message-State: AOAM53339utGzdCj2aKSg2C3+zMKVtrznWaocUKO5X2+yu/h+65C2+2+
        i/gWL7+mdu/Yp5BeQ4OubC0JG51B
X-Google-Smtp-Source: ABdhPJwXjujCpOZqp0zrY+MX3d2/9mauk01cHV92jVYy5A5suwUlCW7ON6R1C8cougkJJ9Y+vidGnw==
X-Received: by 2002:a37:64ca:: with SMTP id y193mr17819938qkb.367.1592260974394;
        Mon, 15 Jun 2020 15:42:54 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b48d:5aec:2ff2:2476? ([2601:282:803:7700:b48d:5aec:2ff2:2476])
        by smtp.googlemail.com with ESMTPSA id z3sm11731310qkl.111.2020.06.15.15.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 15:42:53 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW3ZnZXIua2VybmVsLm9yZ+S7o+WPkV1SZTog562U?=
 =?UTF-8?Q?=e5=a4=8d=3a_=5bPATCH=5d_can_current_ECMP_implementation_support_?=
 =?UTF-8?Q?consistent_hashing_for_next_hop=3f?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
 <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
 <b9e0245f58ca44ed80b07a58cd0399be@inspur.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cdbeca15-da70-119b-9f0c-04813cb82766@gmail.com>
Date:   Mon, 15 Jun 2020 16:42:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b9e0245f58ca44ed80b07a58cd0399be@inspur.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 12:56 AM, Yi Yang (杨燚)-云服务集团 wrote:
> My next hops are final real servers but not load balancers, say we sets maximum number of servers to 64, but next hop entry is added or removed dynamically, we are unlikely to know them beforehand. I can't understand how user space can attain consistent distribution without in-kernel consistent hashing, can you show how ip route cmds can attain this?
> 

I do not see how consistent hashing can be done in the kernel without
affecting performance, and a second problem is having it do the right
thing for all use cases. That said, feel free to try to implement it.

> I find routing cache can help fix this issue, if a flow has been routed to a real server, then its route has been cached, so packets in this flow should hit routing cache by fib_lookup, so this can make sure it can be always routed to right server, as far as the result is concerned, it is equivalent to consistent hashing. 
> 

route cache is invalidated anytime there is a change to the FIB.
