Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C020260138
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbgIGRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730682AbgIGRBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 13:01:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F4BC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 10:01:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so16484746wrm.2
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 10:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MRcq04UOJn8K0NnxNF75RCJpBDeKXA2i3d34tYFG4E8=;
        b=TgUoCjHN4oaBnmsxs801CkJCQDsWF2s6qajW+F5ShhU8pWxBMI2wWkl+FdZ7cdfbzh
         +SATGdOFxEMIMX6p02p/h2IPZPqme5O/9RSTKfbRfy0UYoJx23eEX/fK1bjzvZ3/teNW
         q07YeJKxsAK1ekPlsToVqHtYX33B0q4ZaI5hh6T5kzdH7XkNBa6VQeAonw7mmcUEvLLT
         Ccc/VS2YRz7dhhK8OQo0vnX49RFPeKEsSFpvSUfzBggkr3483D0w9hPjWUG2WvLEJr2A
         Aoefr2ZPGX1VZFlVIdwQXjtG+avIoy9lu8347R/B+LjcvnzmKkmkOw2AMUlN+oZD5Spc
         dFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRcq04UOJn8K0NnxNF75RCJpBDeKXA2i3d34tYFG4E8=;
        b=OY2YmDbCeLvxtz+ix1WqpnhCYRw4k1GRojko5KYF7Pq0/JiLpfLoUWbSCybCXPNtVO
         Dxa1/xtIPeyqvcQZGyNu6KXVzcw6YKbwc00Qt6+IpvJ15hA6YUQ3iq+AS3cYztLSEM3K
         q6BPGmaMz5hgCYvGbNp479jz+6jvUt/uvLb6mQTG1sVeCyZJqEsezBAK6t3sRvFWeapI
         H86eElV319FHdQXGZVq6OYHCw2i68pgxeMwBrvyJa6eKKQFYjiVMU2CITUAi4LvV+jGY
         Yp0yCwqetRLDH1KFeoNQid7A7i+Otel/eoEjgavPT5kalSK+KIo2pZD8pBABZhrfyr5E
         LPxg==
X-Gm-Message-State: AOAM530zw59kowauWT8UOknr5TEJZh5SHObnrgIZSxn316HSHdSCcns8
        G0H+ba2a5bVbk1/bplxZQ+axGQ==
X-Google-Smtp-Source: ABdhPJxXhv6ruRhbqy3IpPxbzNKQKsFV0+qsm/yVhoZ/DUmCzf+zTePlfY5dJFLHNAyI5JYQf/5jCg==
X-Received: by 2002:a05:6000:110b:: with SMTP id z11mr23393083wrw.426.1599498103769;
        Mon, 07 Sep 2020 10:01:43 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id x10sm29060894wmi.37.2020.09.07.10.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 10:01:42 -0700 (PDT)
Subject: Re: [PATCH v2 1/6] xfrm/compat: Add 64=>32-bit messages translator
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
References: <20200826014949.644441-1-dima@arista.com>
 <20200826014949.644441-2-dima@arista.com>
 <20200907112411.GK20687@gauss3.secunet.de>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <32b89fd5-2809-ba15-9be4-f30e59decba2@arista.com>
Date:   Mon, 7 Sep 2020 18:01:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907112411.GK20687@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 12:24 PM, Steffen Klassert wrote:
[..]
> One comment on this. Looks like the above is the same in all
> commit messages. Please provide that generic information
> with the patch 0/n and remove it from the other patches.

Yeah, I think I've used to that from x86/core submissions - they prefer
having general information copied from cover-letter to every patch, that
way commits in `git log` or `git show` preserve it.
Probably, one of small differences in style between contributions to
different subsystems. Will do, no problem.

Thanks,
          Dmitry
