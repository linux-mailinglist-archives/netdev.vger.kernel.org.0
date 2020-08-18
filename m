Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24262480F2
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgHRIxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgHRIxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:53:43 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4452C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 01:53:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a14so14623526edx.7
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 01:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mHF4zMI29UO10Mj9/Ydsz2ziK6CMU5g7KzRQjpFViqw=;
        b=n55k/bhVIn/wHUFomF1QppSs32c4DjkfwMcj47fHTU6Jx/+3TFATHC8CFbogMXt/cp
         w//TszWurFo7qea67IFpC6tTcqdZGH5pbqGlh0mOnpng/kTEUjC5HusMWVEX/nrOvKRW
         qbttgjj/oQmYDqUADo6Au05xknCSCfrNi0WOJFWeHR3XMVcntgEmR3wCSqvzvBmM9cME
         Tr+Wshmv/nKNbcHq7KSZLnHe7hRGqteldMBzt5FQFG/azlZlQEzDbIcit53sQo3PQHhj
         NnTr2o4trmLFwjHMtg/srVTd7XcOt/f+ONu6IiuwWsMlLLb6BTg68nuDAFdIA2VUk8Uq
         nlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mHF4zMI29UO10Mj9/Ydsz2ziK6CMU5g7KzRQjpFViqw=;
        b=lF2O5MPT9B+wpEX5GMfIHZBWLpdO8ETBdSSyqVoQ0QPLn0OxQheFDMCJCjJL7fPYr4
         YFv+JkJwA7H8ZMwfEvNea8g6/NaqK1j55w4Ul+NtOZnIMIS2b5eGdxHOXvhzumkhR6Xv
         V+WDbeOzbdnjHJTP6gNBSk+R262Co9q1mEIShFnk1z7Ctho3TsgxJbAh7TGZ61qGmFOX
         LQ/KfqgX7yi/R4/vPHvHaWHuSssPTshZ1x6nIM8iAqyz9ogC+T0vy7DA44IkE0UzLdfr
         ye+5Ka8PMexHVSDPJOqL2tOw7UQXK2jF8zxCqpAwSDRT9Tp6WWxZKsvikJdZrRUGnpUk
         344g==
X-Gm-Message-State: AOAM532mI6d93zBz1gkzLsreEawErLmpiJ+Y2NJ8w/wf1APGZvMjQXZT
        EHOhMAuceTkd6vCo0R6xkm6c+A==
X-Google-Smtp-Source: ABdhPJzasmal4qJ7f+qgaB/C0apGIWri1z1j0MVO7WIGJa1Or7TfWWUH4EDJnEHwP8gAFAl2cgZhzg==
X-Received: by 2002:a50:c449:: with SMTP id w9mr19421239edf.65.1597740819656;
        Tue, 18 Aug 2020 01:53:39 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:a03f:5a32:bd00:41f1:972d:5bac:bf85])
        by smtp.gmail.com with ESMTPSA id b7sm16250219ejp.65.2020.08.18.01.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 01:53:38 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] netlink: consistently use NLA_POLICY_EXACT_LEN()
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
References: <20200818081733.10892-1-johannes@sipsolutions.net>
 <20200818101633.14eac4aad20c.I3e27f5d489fc497b5d134488b8f3a72b5e3405c8@changeid>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <306aeca4-3f9f-14b1-783d-1a0abac3f04f@tessares.net>
Date:   Tue, 18 Aug 2020 10:53:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818101633.14eac4aad20c.I3e27f5d489fc497b5d134488b8f3a72b5e3405c8@changeid>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On 18/08/2020 10:17, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Change places that open-code NLA_POLICY_EXACT_LEN() to
> use the macro instead, giving us flexibility in how we
> handle the details of the macro.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mptcp/pm_netlink.c          |  4 ++--

Thank you for looking at that!

For MPTCP code:

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
