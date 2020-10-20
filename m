Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED726293378
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390996AbgJTDMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgJTDMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:12:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5656FC0613CE;
        Mon, 19 Oct 2020 20:12:47 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z5so896754iob.1;
        Mon, 19 Oct 2020 20:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GxvQGZoYmIMTnn71Z7et99BXyWneaN3uEqCTAR40K3U=;
        b=SGuw9d0N2S+8DnkFub4spS+FTzgv93qLyn3BQSHNB4cAnSkMi/6HC75AvhFSsCRV/6
         CQtajHqm99jictGiwA67FKDFwbmJLUWqVUwvZZEnXjNRcivUGdX4tT/jvzIDdTchhUlw
         HBEgiRQXeL4wQg49ERqnN6yxO/k+FRLarw2pUI1l+6FmuDLwGrSKgfpA+pGSxfeGy9MC
         Da+giqA7zYnberUWsdY6UpCeBu0SR18ShjvJsSixDtSMB2nn8CG4Q0vaThVjGjGhxyT7
         7U0M755wR8hFjNKi9Ac8yFCxNAaZCVsJfoluKenVs9MlS9XaKbjcDQbq1QXonPMNSgtY
         7LKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GxvQGZoYmIMTnn71Z7et99BXyWneaN3uEqCTAR40K3U=;
        b=iS7R0NKBz4bYNl5orGwu0OhwkhHvLb0KHsb14qVBSi4nxLA531CpGZBiueRCA3ok+R
         pRH9ES3xgh87NOTTs3eUuJYIJrc/Or3HcHZahHR2T/8gL1rD0soRMBCiv1dT4QfIkYyH
         oPkK67SqsCfp9VczDHdy1QHtFYEHHYG5KJ9P5bYFv8p4bRllTavgGRzBi4BUwn1qQzH1
         d8ByAkIIAKe/l9Y9iuYqOVBgsYveuMgjQG97JlntGVmoEoQ8WbCeOWZqpFd+7FVRyQai
         tsii+FvLsFNbIgxUMTVnhTO6ifdZvAz28bT9i+Pm8T/BuXYTJVBip3IyS79MOFlYTbpe
         +d+g==
X-Gm-Message-State: AOAM530qdvfSS9eI8jTw2jwxnOBPIUnExOJd2aIPfdA0X3fIsNuSSzeM
        XhC8GRLcqlE5QI/xpZDd19Im/MHrB1I=
X-Google-Smtp-Source: ABdhPJzRVApPWE5OEPALgT5Yat592X3DS5SzlTtfaEGGw8ac3jA8nQpBTEXgF9gIJf+gh0+ltp6FUw==
X-Received: by 2002:a6b:1497:: with SMTP id 145mr670294iou.202.1603163566600;
        Mon, 19 Oct 2020 20:12:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id z9sm511206iln.87.2020.10.19.20.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 20:12:46 -0700 (PDT)
Subject: Re: [PATCH bpf 1/2] bpf_redirect_neigh: Support supplying the nexthop
 as a helper parameter
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160312349392.7917.6673239142315191801.stgit@toke.dk>
 <160312349501.7917.13131363910387009253.stgit@toke.dk>
 <3785e450-313f-c6f0-2742-716c10b6f8a4@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e4188697-4467-61fe-72c4-cc387ea9a727@gmail.com>
Date:   Mon, 19 Oct 2020 21:12:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <3785e450-313f-c6f0-2742-716c10b6f8a4@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 12:23 PM, Daniel Borkmann wrote:
> Looks good to me, thanks! I'll wait till David gets a chance as well to
> review.
> One thing that would have made sense to me (probably worth a v2) is to
> keep the
> fib lookup flag you had back then, meaning sth like BPF_FIB_SKIP_NEIGH
> which
> would then return a BPF_FIB_LKUP_RET_NO_NEIGH before doing the neigh
> lookup inside
> the bpf_ipv{4,6}_fib_lookup() so that programs can just unconditionally
> use the
> combination of bpf_fib_lookup(skb, [...], BPF_FIB_SKIP_NEIGH) with the
> bpf_redirect_neigh([...]) extension in that case and not do this
> bpf_redirect()
> vs bpf_redirect_neigh() dance as you have in the selftest in patch 2/2.

That puts the overhead on bpf_ipv{4,6}_fib_lookup. The existiong helpers
return BPF_FIB_LKUP_RET_NO_NEIGH which is the key to the bpf program to
call the bpf_redirect_neigh - making the program deal with the overhead
as needed on failures.
