Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96D3281C6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhCAPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236781AbhCAPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:04:56 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A625C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:04:16 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f6so5375870edd.12
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K4OpzeM0uoCAJP3TWREPkk9i3rsA64Mt1QD3mJUaugc=;
        b=ZnkCqhI+7mHQ53lwM6WH60Jgon9tVUrbiDumUC3+4KVrgiFoHpEuT+jtEHj50NQylI
         G1bijP9K3CzrXJB2S6wT4lp+i+xI7hznm8QVPV7ivlGiDOLeSwviReiSW3VhQpSKfse2
         qsR7qNDj+NCswuwia6zEj9HUXkwnTzahpkFicPn5O1uf6+R3h3F5E5+8n8j0mSlTg/ov
         rYL14jIYN1RJoBGkScFqr9NIzu5I8GTEx0VGR+bx00GGD8ui5OS+J+iyGq+KF1QdDj1O
         CO3JlTAds+ZHZaNDzYBWEvdSedKy526cpiORF5EthAYCRkbQurOKNknwHvVQ8HpHVZWx
         X2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4OpzeM0uoCAJP3TWREPkk9i3rsA64Mt1QD3mJUaugc=;
        b=XMs/Z9M70TdVs7nh0rUECCJMa87chCS/V1nI138LD+D9RiU4LATSmRD9QhSviQ73TV
         JVtTCObNikegpiObJ7kJJghMjPvEgri7cf4TvFq7CV0hUlGTAwQr6arCIgLGbh1nfZ29
         OVmxsb/7Yw+iO+EnA+AwXwkvR1ZhObx7TtqEPM0LsH56vtGZBK7n7aMs2kgjZtJT/HON
         6cQHx8T9iVPorja3TiDki98ipKpimrXb3qwcxnljLec0/ZUIol66tCldab3ZkvfDUQ+d
         uYv57O3+vGMI2xFj+bvkl/23cxSvm0sP0Px2tkl1XUDFC5coPGwNqraSCsL2WDsCumz/
         WVUA==
X-Gm-Message-State: AOAM532EuUn0biTN7CAmiKWp0icCShuWcU5v3ye31O7nAMtrMhyLM4zQ
        aZwpKUIZ3Lz8fry3rzdbbXdyHA==
X-Google-Smtp-Source: ABdhPJz7ze/sNsf7HaYXGXCaAkOu7chdPkN8aYq9EWu71wh3POUaX+kAnZ8DNKrehU1y7vOjOXOLFA==
X-Received: by 2002:a05:6402:549:: with SMTP id i9mr7920438edx.379.1614611054980;
        Mon, 01 Mar 2021 07:04:14 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:2f49:5dbe:a18d:8909])
        by smtp.gmail.com with ESMTPSA id bi26sm14188762ejb.120.2021.03.01.07.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 07:04:14 -0800 (PST)
To:     Chuck Lever <chuck.lever@oracle.com>,
        syzbot <syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com>
Cc:     Bruce Fields <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        MPTCP Upstream <mptcp@lists.01.org>
References: <0000000000001d8e2c05bc79e2fd@google.com>
 <974A6057-4DE8-4C9A-A71E-4EC08BD8E81B@oracle.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: possible deadlock in ipv6_sock_mc_close
Message-ID: <26b3858e-6e5e-d782-118b-c4d64e2532f2@tessares.net>
Date:   Mon, 1 Mar 2021 16:04:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <974A6057-4DE8-4C9A-A71E-4EC08BD8E81B@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chuck,

(+ cc: MPTCP list)

On 01/03/2021 15:52, Chuck Lever wrote:
>> On Mar 1, 2021, at 8:49 AM, syzbot <syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com> wrote:

(...)

>> syzbot found the following issue on:

(...)

> Hi, thanks for the report.
> 
> Initial analysis:
> 
> c8e88e3aa738 ("NFSD: Replace READ* macros in nfsd4_decode_layoutget()"
> changes code several layers above the network layer. In addition,
> neither of the stack traces contain NFSD functions. And, repro.c does
> not appear to exercise any filesystem code.
> 
> Therefore the bisect result looks implausible to me. I don't see any
> obvious connection between the lockdep splat and c8e88e3aa738. (If
> someone else does, please let me know where to look).

 From what I can see from the bisect logs, it looks like this issue is 
difficult to reproduce. But it really looks like the issue is on MPTCP 
side and not directly related to your patch.

Thanks to the syzbot team for reporting this!

It doesn't look very simple to fix but we are tracking this on our side: 
https://github.com/multipath-tcp/mptcp_net-next/issues/170

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
