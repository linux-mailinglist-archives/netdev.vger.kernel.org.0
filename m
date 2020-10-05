Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E93283C88
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgJEQbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgJEQbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:31:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BAAC0613CE;
        Mon,  5 Oct 2020 09:31:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q123so7286876pfb.0;
        Mon, 05 Oct 2020 09:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R9YlX6EHFx6XpkeTPJP/qBg1UOWza/IdabqBeotO5BA=;
        b=u8zTk1rmTsRmGbyzlaYoVkYKtZd+igHJXOUsykswC3bdFY8/rbDimGh3bLfkS1ewv6
         mlN+e/5rCfetbOo8SxyH+Jz5TEdadGodn0ILXwgCuyATw6qyrq1IGw79ea3LEligM5uT
         vTWs4Ix6J5xThuJuqxDuYtaLK1fkVuPl9sOreeLCylkopGJCYm4oy/VuNg2awlZmjHrQ
         JLfcyVJOnYndBN5JFC8xikI6RpL7QBFAKHBCKq2mIAyCuRAQDGj3+gE3lYUUwC+ccLw6
         6xaaYyjNYRB4c2qwIJx4MsCC9hUHdPxwkxsuW17d6GwWuLVnYQHDKZRKYubBIn7qfnsz
         9qsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R9YlX6EHFx6XpkeTPJP/qBg1UOWza/IdabqBeotO5BA=;
        b=f8BEK7E74y8mMrJrWKz0nEGuOEwzL/4x29YLxoLRv/P+g3rXAF18be5uDb+pEKonj5
         Cn4+eHH+5eWSCXLrj85q6L4r+EszlD9hpWshubF1ZLK7cKjn3nkLW2nc5eOw7V3nK3m4
         cvpLE8bISFMblzU6M5wLSqXbnUPJpZgkSz1YgnOdM0BVRJ1x8mt9YwbaPIxbO9/pCRiu
         V32cZPuT9YIY5RdG2nzoftyUasbFX2OKis46s3QjN/e2P2I7MSucG+gTuWDJsyY1Jc9r
         rPkdpKCSnwU/jKAk5ZQVbGIIdM+drRJPUwMVrf7JD89/8yGpuDCbAkOg0/RUJ79kn3Hs
         a6Yw==
X-Gm-Message-State: AOAM532lRcqMUD8NbiS/R1LkzNoJT/jECJFwMoXSIK3chcMSs+0kJ5dh
        t2kT0u1Nq5Zlg0CTqlZ4VPQMRxfRrt8=
X-Google-Smtp-Source: ABdhPJwtP8TfulOrJ+s3ziVm6XlYCok8wFQ2nXsItJxyU8EoSSr//2OZwhtZL/HpAqvDACzcsxLz+Q==
X-Received: by 2002:a63:4951:: with SMTP id y17mr237392pgk.375.1601915460010;
        Mon, 05 Oct 2020 09:31:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id h31sm110056pgh.71.2020.10.05.09.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 09:30:58 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     linux-kernel@vger.kernel.org
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com>
Date:   Mon, 5 Oct 2020 09:30:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 1:04 PM, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
> the route lookup is performed on the right routing table in VRF
> configurations when sending TTL expired icmp errors (useful for
> traceroute).
> 
> It includes tests for both ipv4 and ipv6.
> 
> These fixes address specifically address the code paths involved in
> sending TTL expired icmp errors. As detailed in the individual commit
> messages, those fixes do not address similar icmp errors related to
> network namespaces and unreachable / fragmentation needed messages,
> which appear to use different code paths.
> 
> The main changes since the last round are updates to the selftests.
> 

This looks fine to me. I noticed the IPv6 large packet test case is
failing; the fib6 tracepoint is showing the loopback as the iif which is
wrong:

ping6  8488 [004]   502.015817: fib6:fib6_table_lookup: table 255 oif 0
iif 1 proto 58 ::/0 -> 2001:db8:16:1::1/0 tos 0 scope 0 flags 0 ==> dev
lo gw :: err -113

I will dig into it later this week.
