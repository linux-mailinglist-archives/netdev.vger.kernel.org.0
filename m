Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BED3A39F3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFKCzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFKCzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:55:12 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5EC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:53:01 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id s23so4362961oiw.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KApcPjkt1VOLM33a7921YejbrgANfOQNEqTW7oqDR+Q=;
        b=HGJHlqh5jrg+bhgXZ2Ahv+Mu4mHm29URagYkXFysIzXjla7zqbMMw/ghtsEqHHp8kh
         +kGpXZqGTPHN97vT50+BHrEDFjK5QK+wd5fdKLeXO+Mm6PkUHRGyy0w1cOROuvGax5M5
         LaVyzwdD2j5XJA62hZes6acKNT1QKXRHdQhuy4I7jGQQIbavw4eiaW7je5RYyHLnKbsW
         wEZIvnJSE6i15DrRn2RoeFxx1ePq8QNsLamf2Z+DLuQ8KQFyStoVxWimc/pBtyqFuRTc
         WLzFJ1/s80aVf9cBWRd5EExs1yEEDLAyeZbyqtmwZMOgPrFlOL2TXI7gY+gwSFFiBZID
         cDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KApcPjkt1VOLM33a7921YejbrgANfOQNEqTW7oqDR+Q=;
        b=iMrjlfb2GUQgY4+bkkrUsOjZyI7IUjiayO/pmnUD//b3iJ9Xc9nc3PErmiXh51GPiR
         ZSkijXJXoCjrBDaHeuLWp1POHvQ8I6yhziSimz52vpD+ZsK3kq6J8I8hPMguv3Up+Sr/
         sGZ0xm/ZVJMxfukyZ6R10RDR2twVuIdUViuF3xkh6yMWe5iUGhW/nnIOnc2N2ausPC2C
         ownoiWrdYTFy6VeuN2w2uPSfun/5aXILOxfyo9wJzvEc6SPEpWLSLhHYlmlkK24ObB8i
         NCrp8dT/AyOEqkM8MS8xofJuGm9RfXdYtLkbAlgc1TGexqvsI3AKJYD7PT9dXzjqo7N4
         6C9g==
X-Gm-Message-State: AOAM5327NsUQ7t0ae53QfGVU4yd9tHsBSsf40BMwJuJjjB7orKH/djno
        MlMLX8AkRszJfDSWChiKElM=
X-Google-Smtp-Source: ABdhPJzgX7kiC6oDVk9rQm+1KHZ279AKMCmNLqWaPdx/q6cIw7jWMrrViYS95sLq3IJNH+uzJRwEhw==
X-Received: by 2002:aca:4d46:: with SMTP id a67mr961507oib.52.1623379981414;
        Thu, 10 Jun 2021 19:53:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id l8sm911672ooo.13.2021.06.10.19.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:53:01 -0700 (PDT)
Subject: Re: [PATCH RESEND iproute2 net-next 3/4] devlink: Add port func rate
 support
To:     dlinkin@nvidia.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        stephen@networkplumber.org, vladbu@nvidia.com, parav@nvidia.com,
        huyn@nvidia.com
References: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
 <1623151354-30930-4-git-send-email-dlinkin@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <503b179f-5831-46a3-f8f8-3271e3b796e6@gmail.com>
Date:   Thu, 10 Jun 2021 20:52:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623151354-30930-4-git-send-email-dlinkin@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one needs to be rebased. Must be Parav's patch that created a conflict.
