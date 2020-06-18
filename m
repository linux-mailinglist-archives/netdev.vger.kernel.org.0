Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E81FEEAF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 11:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgFRJbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 05:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgFRJbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 05:31:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6F8C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 02:31:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ne5so2275867pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 02:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DzxmerU97oT6v2amuGEClNWoK6S9GT7VzDYB3K5pcdE=;
        b=NbbE554q8QtZumzHxzZb4jDApE4L+4UKfAx2JPiOrUowRgu7KfshoN6mktKA4/cpF3
         0n1sd0dfKyUD+AzIwhZAslX1dDa0x52S+Mkqo8KH8eSjU4JI+VQmZfz1K3ZZHU1Mlz7O
         lUTADke+tXhq8HIZ+PIcjxz2EwLN2UwK1PdUXnw1IAGPr6RUlij9Y3dS8ZjyzeBoZ+iP
         7tdqeCcRssksDSi/OiAGB/ab7+Cdx3jFQp1y9kFzWkCvK+2QFQ8mntsQp9nPibcwoyM0
         w4JJ4+WtFcEf2PyiTwi5ThT9skvfr7cBb7/5PuqZiKsXVU9HLzOpFtWL4OwqZUTje023
         BNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DzxmerU97oT6v2amuGEClNWoK6S9GT7VzDYB3K5pcdE=;
        b=smiDNWOV/xAwaVtEAPs59hvTDVwANbNCM6hP/dNzBTLh9RPMRniyHTcIUibinwlcD9
         HtF7fNou2aFkaG/ZzgHMH2q30jNwiT36OiTQJyV8SurTofhUV3Qq55RNdEn8Vmj6kmE3
         icftNKMfuHkC8ppGVDr+Tg+yyaYOkykhgre/tki17Lzc53K5XT7lL/WkTOCcoJfaxcR7
         DMG22sJudqxSz5Map2QlT9bYOySMxZf6RmmVAC/Q2FQgK0FGBylLpE31QCpjtE3XaI7z
         w11gMsZAHlBQ4mVEt8uw1/leEAuxirUa2aG8pyZgxIz1wSKij19mRPCgHIwhI4gSs+CS
         f9/Q==
X-Gm-Message-State: AOAM531BvEgIxlEhtTEIVIymdbhazLl0P4COsdBMw3IJo7Rc0HMZw/w+
        Wmc389X6quqEfktZQkNg+f0=
X-Google-Smtp-Source: ABdhPJzT16M5yXAzG5fYv3HYcs8FGohD7Z/hTZw12Y4yWdhCw/6wuz+hFyCPLK4xbNJaZnH7iCwdMA==
X-Received: by 2002:a17:90a:bf07:: with SMTP id c7mr3335175pjs.233.1592472702742;
        Thu, 18 Jun 2020 02:31:42 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm2197510pfn.177.2020.06.18.02.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 02:31:41 -0700 (PDT)
Date:   Thu, 18 Jun 2020 17:31:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Lucas Bates <lucasb@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, lucien.xin@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net] tc-testing: fix geneve options match in tunnel_key
 unit tests
Message-ID: <20200618093131.GW102436@dhcp-12-153.nay.redhat.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
 <4c1589d4d2866cdfebf12bb32434210532b3b884.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c1589d4d2866cdfebf12bb32434210532b3b884.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:53:51AM +0200, Davide Caratti wrote:
> On Thu, 2020-06-18 at 16:37 +0800, Hangbin Liu wrote:
> > tc action print "geneve_opts" instead of "geneve_opt".
> > Fix the typo, or we will unable to match correct action output.
> > 
> 
> hello Hangbin,
> 
> > Fixes: cba54f9cf4ec ("tc-testing: add geneve options in tunnel_key unit tests")
> 
> this Fixes: tag is suspicious, when a tdc test is added I would expect to
> see it passing. If I well read the code, the problem has been introduced
> in iproute2, with commit 
> 
> commit f72c3ad00f3b7869e90840d0098a83cb88224892
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Mon Apr 27 18:27:48 2020 +0800
> 
>     tc: m_tunnel_key: add options support for vxlan
>     
> 
> that did:
> 
> [...]
> 
> static void tunnel_key_print_geneve_options(const char *name,
> -                                           struct rtattr *attr)
> +static void tunnel_key_print_geneve_options(struct rtattr *attr)
>  {
>         struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1];
>         struct rtattr *i = RTA_DATA(attr);
>         int ii, data_len = 0, offset = 0;
>         int rem = RTA_PAYLOAD(attr);
> +       char *name = "geneve_opts";
>         char strbuf[rem * 2 + 1];
>         char data[rem * 2 + 1];
>         uint8_t data_r[rem];
> @@ -421,7 +464,7 @@ static void tunnel_key_print_geneve_options(const char *name,
>  
>         open_json_array(PRINT_JSON, name);
>         print_nl();
> -       print_string(PRINT_FP, name, "\t%s ", "geneve_opt");
> +       print_string(PRINT_FP, name, "\t%s ", name);

Ah, yes, you are right.
>  
> 
> (just speculating, because I didn't try older versions of iproute2). But if my
> hypothesis is correct, then the fix should be done in iproute2, WDYT?

If you and Stephen are both agree. I'm OK to fix it on iproute2.

Thanks
Hangbin
