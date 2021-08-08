Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDED53E3C1E
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 19:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhHHR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhHHR75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 13:59:57 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A621C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 10:59:37 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id n16so20330565oij.2
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 10:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J+8tSVMedm0jUWEKSny9LUROzSxyADX+GqoqIC+vdNo=;
        b=FAWwZdpmG5Ze9IHerKIuz+KPVv1G4gEWlcoBjPsnP8UtOF6qjQcugwHF3mxX18PJLL
         O4x7XAUh/+TeVt2IZ3Fbcm6XxTlptX+kGjr418bNSP486j0ZlRSCu1rGodcoG+Oz3Vk/
         o0qp/pGTJrrSyd0xH36MPP7+Hgm9GoP3CsboEE6RRnuby5kqUXiVgT6AnHxTANaaR9fH
         Senvo4p7BYl5fgDr1k44RxXMrDeuvNL54v+IC0mRD/XJE5s1lcMoex+BplykWWceQAjX
         +L5fkKy2pzlQbZoMBS4BkZYuu0G4nvGhVOva2dgkIgB1Z5dWm+18F1qX7kXp/CTnL9KR
         Zf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J+8tSVMedm0jUWEKSny9LUROzSxyADX+GqoqIC+vdNo=;
        b=hz2QceGNAK/PMyNrBJ88Uh38Y9AOIN21QYz0AKj+GIHGw4YNTUbA6FQVE5OVM9nQx4
         leD5zk7leaXF/qPi408x5CGPKY+yGD4G3jxDy9padTZkE20NX2DiOvx2aVYi1kgbsgqg
         o5FANN4KXyIZLBA84vRadggEidgsk18IlO0phEWVDZBSqEu7899LJH/TRHEB+LiS07gx
         0RUPQv2ACRvVY48Iz43sJgjQoofpWe/WOpqEKq8AOVtw+psqzNR0wNmUC2RKOOXz93CA
         6uV2JpgXujD89A/JhLCS2lOFBirZdKIeyxnFLKKGOQ8Lkyc4UG6/M/gzQXufGF5lI0+L
         v47A==
X-Gm-Message-State: AOAM532yQN+szrVKwoqik+7WpoS6VWqVUfto91TAkrcAPWpU9LxpayBa
        DxsyxaX1ZJVSClID7VyElw8=
X-Google-Smtp-Source: ABdhPJzHOTycqyRFWT1C/LyF5/Kx6/wI3XsA2vn+Css38c75Gz+PfUq2MowhQnN+QP9I5VGjA27IGQ==
X-Received: by 2002:aca:d841:: with SMTP id p62mr11212569oig.108.1628445577051;
        Sun, 08 Aug 2021 10:59:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id s12sm264909otk.21.2021.08.08.10.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 10:59:36 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] tc/skbmod: Introduce SKBMOD_F_ECN option
To:     Peilin Ye <yepeilin.cs@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
 <20210804181516.11921-1-yepeilin.cs@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b29c5a1e-4255-5c6d-1e3f-9d9758c4ca67@gmail.com>
Date:   Sun, 8 Aug 2021 11:59:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804181516.11921-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 12:15 PM, Peilin Ye wrote:
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
> Hi David,
> 
>> I just merged main into next. Please fix up this patch and re-send. In
>> the future, just ask for a merge in cases like this.
> 
> Ah, I see; thanks!
> Peilin Ye
> 
> Change since v2:
>     - re-rebased on iproute2-next (David)
> 
>  man/man8/tc-skbmod.8 | 38 +++++++++++++++++++++++++++++---------
>  tc/m_skbmod.c        |  8 +++++++-
>  2 files changed, 36 insertions(+), 10 deletions(-)
> 

applied to iproute2-next.

