Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218723DDDAD
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhHBQ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhHBQ2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:28:55 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C40C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 09:28:44 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n16so18166047oij.2
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X+ikg5mma2UnTxY8OzKT3WPb6qY8RfLC9Ye3qorM+FM=;
        b=XfS79OKkBy67nazYNPzxCgq3xX9TJV0GdOirMXGVHGDbVF1P8A9NiI2nCL613i+45P
         SHgccPmhvrwQFiYLg9ZebTuAOq6/VSZMwcZV0SDsPyx+pVm5KIly9W6lvah7SAmZKv7a
         OEqfn/tTjjbv2+8GhG/1hxS1p8lHnqrEf13wOrgXwpgyBIdOVWH5m0EZcjC+THEuUvmU
         7UYYJpPnqxENpIQUw+I+eFvwIM4AuQksucct/7jf/lupv058InEqH3bXQmzZm7/MMccD
         kkPKPkRUGeY/9EYB49hjv0JX5tI29hOtCdKklP2I5HyN24e3Kqqjy48KDBk/lHHhiu4o
         +fOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X+ikg5mma2UnTxY8OzKT3WPb6qY8RfLC9Ye3qorM+FM=;
        b=JSFiXMkKwE10xcN99vbHuqQVpXtJtc664V4bx7MfKly+RlutBtEYyGISdY+7ikVeUG
         ov+T2qMFLScOwOro2T6ng2bZ4iNc3Xs+vCHA6tv6CRhCJGMGKZBAQa3pSt5+WioqlUtg
         MZ6Jv4fpQBj030rnDKg48Tnh1Ty6S3ZrWrRwwF4HtM1vgl4+C7HrDfd1X4+GPCWZVD/8
         Hp812QrinA1vhAq7ARSyu7sTUcy1GMjkx4542L2Ntl/mgTf8YNpmeL2wsUdZ1lPmt8Yu
         rt9oE6ckItbKNlXZq0MQzBjkdw6ZiFu0xU3N32vMo2ploaT9Id3uTcz/tUH8WfCWWJtj
         Fh3Q==
X-Gm-Message-State: AOAM531/+6p0wgoRRavvyaQSTyMunmse/e6Ht+dS50ac5meOOGDZqA2C
        m0BRb6Ym2qOlzrkmNiPt17o=
X-Google-Smtp-Source: ABdhPJz7EqAO3FTP71/zR/pooxOb+l9Y8IrNP1rq86FpzjUy/cvz/Sowrai80tY9aajx1rV6tsmboQ==
X-Received: by 2002:aca:c402:: with SMTP id u2mr11113812oif.121.1627921724034;
        Mon, 02 Aug 2021 09:28:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id s16sm1961081otg.51.2021.08.02.09.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:28:43 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc/skbmod: Introduce SKBMOD_F_ECN option
To:     Peilin Ye <yepeilin.cs@gmail.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7433f9d1-8a5b-5d9a-da16-815c67bcbe0a@gmail.com>
Date:   Mon, 2 Aug 2021 10:28:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721232053.39077-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 5:20 PM, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Recently we added SKBMOD_F_ECN option support to the kernel; support it in
> the tc-skbmod(8) front end, and update its man page accordingly.
> 
> The 2 least significant bits of the Traffic Class field in IPv4 and IPv6
> headers are used to represent different ECN states [1]:
> 
> 	0b00: "Non ECN-Capable Transport", Non-ECT
> 	0b10: "ECN Capable Transport", ECT(0)
> 	0b01: "ECN Capable Transport", ECT(1)
> 	0b11: "Congestion Encountered", CE
> 
> This new option, "ecn", marks ECT(0) and ECT(1) IPv{4,6} packets as CE,
> which is useful for ECN-based rate limiting.  For example:
> 
> 	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
> 		u32 match ip protocol 1 0xff flowid 1:2 \
> 		action skbmod \
> 		ecn
> 
> The updated tc-skbmod SYNOPSIS looks like the following:
> 
> 	tc ... action skbmod { set SETTABLE | swap SWAPPABLE | ecn } ...
> 
> Only one of "set", "swap" or "ecn" shall be used in a single tc-skbmod
> command.  Trying to use more than one of them at a time is considered
> undefined behavior; pipe multiple tc-skbmod commands together instead.
> "set" and "swap" only affect Ethernet packets, while "ecn" only affects
> IP packets.
> 
> Depends on kernel patch "net/sched: act_skbmod: Add SKBMOD_F_ECN option
> support", as well as iproute2 patch "tc/skbmod: Remove misinformation
> about the swap action".
> 
> [1] https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> Hi all,
> 
> The corresponding kernel patch is here, which is currently pending
> for review:
> https://lore.kernel.org/netdev/f5c5a81d6674a8f4838684ac52ed66da83f92499.1626899889.git.peilin.ye@bytedance.com/T/#u
> 
> It also depends on this iproute2 patch, which is also pending:
> https://lore.kernel.org/netdev/20210720192145.20166-1-yepeilin.cs@gmail.com/
> 
> Thanks,
> Peilin Ye
> 

man page update has conflicts; please rebase.
Thanks,

