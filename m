Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED3A334853
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCJTvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhCJTv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:51:27 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D26C061760;
        Wed, 10 Mar 2021 11:51:27 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id f124so18168635qkj.5;
        Wed, 10 Mar 2021 11:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/C7GWxSTHOrMXjLv3K6DdP1HM9usBSoqglJ2xAKrJAw=;
        b=L0KvdLxCoEQElMJZz6PU6a9RImQBS825Tyx6NkMi2i9PlfDhssX8c585ur209ceoyh
         euyQCR8PZmween/6Ns5SeOpTgplrTbGIn/OW5ZubeANybU1rOGG9VMyXAebDNERDjdN8
         BVz6/efrIhZjGKWx6XW6lCCoQYl+2vXfYbTqSfoybGCnfxO9paomrr2TO+Yj43SLWj7A
         Jze+p1IEnZUEeeIZz4RVD1dTHcJPjcO15cU6GxNIDiOVCvTL/o55DBrvx+7D65+Rorkr
         8L7+HFaYhXhH8gb5EmjkRm2y571mnnl+UUW0hX611WnQbblGRANXIsfbhLGleBHW7oSM
         oPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/C7GWxSTHOrMXjLv3K6DdP1HM9usBSoqglJ2xAKrJAw=;
        b=YPDsVPv7dzgW/VXtAkHQRwMPYeko33Tb6IsSQxej4qE6OmZgdaupQO/FbWSXpqFIsw
         AZo9atzW2af80/71P2Ctmf9MbDovdK36AdKRaqq6SEhjjO7UZ10k+lfVwohXKgogAq+Z
         JlmZrtO2LGYNqsghaBuhw5L0UZNEigLbZsW0SvbWc7dyGx4cect0nebPaXH4GOn88n6f
         PzutVWZKfTjosRh9oT2jyy1o6AcGSAUGtO5NLw+wypl6UOJ+3N95Bd3LeLMlxdYvLTc0
         5EAL/5JFxT1Bzx4uZAsscoFaUfLXmTC4WOi0Q36d5KyCI8qet2gR9z/6FRZmb8wj+7A5
         RHLQ==
X-Gm-Message-State: AOAM532zk7kotN3jCYXjF7IqtpoLpG2iTZe83pAAbSSFkfYzMaHXq5r/
        t2AJDbcYjEzxi5L8sSYli5LchzlNMig=
X-Google-Smtp-Source: ABdhPJwovicBj4M9Go1I6VcZEcM3Lh4qaX3/OZDBmt4HxXxrYRMJPEINq4YrvDGOwz5at6g0FGiG4Q==
X-Received: by 2002:a37:660e:: with SMTP id a14mr4189602qkc.35.1615405886317;
        Wed, 10 Mar 2021 11:51:26 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:d0a0])
        by smtp.gmail.com with ESMTPSA id l5sm192318qtj.21.2021.03.10.11.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 11:51:25 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Kees Cook <keescook@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org> <202103101107.BE8B6AF2@keescook>
 <2e425bd8-2722-b8a8-3745-4a3f77771906@gmail.com>
 <202103101141.92165AE@keescook>
Message-ID: <90baba5d-53a1-c7b1-495d-5902e9b04a72@gmail.com>
Date:   Wed, 10 Mar 2021 14:51:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <202103101141.92165AE@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:45 PM, Kees Cook wrote:
> On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
>> On 3/10/21 2:14 PM, Kees Cook wrote:
>>> Hm, this conversation looks like a miscommunication, mainly? I see
>>> Gustavo, as requested by many others[1], replacing the fallthrough
>>> comments with the "fallthrough" statement. (This is more than just a
>>> "Clang doesn't parse comments" issue.)
>>>
>>> This could be a tree-wide patch and not bother you, but Greg KH has
>>> generally advised us to send these changes broken out. Anyway, this
>>> change still needs to land, so what would be the preferred path? I think
>>> Gustavo could just carry it for Linus to merge without bothering you if
>>> that'd be preferred?
>>
>> I'll respond with the same I did last time, fallthrough is not C and
>> it's ugly.
> 
> I understand your point of view, but this is not the consensus[1] of
> the community. "fallthrough" is a macro, using the GCC fallthrough
> attribute, with the expectation that we can move to the C17/C18
> "[[fallthrough]]" statement once it is finalized by the C standards
> body.

I don't know who decided on that, but I still disagree. It's an ugly and
pointless change that serves little purpose. We shouldn't have allowed
the ugly /* fall-through */ comments in either, but at least they didn't
mess with the code. I guess when you give someone an inch, they take a mile.

Last time this came up, the discussion was that clang refused to fix
their brokenness and therefore this nonsense was being pushed into the
kernel. It's still a pointless argument, if clang can't fix it's crap,
then stop using it.

As Kalle correctly pointed out, none of the previous comments to this
were addressed, the patches were just reposted as fact. Not exactly a
nice way to go about it either.

Jes
