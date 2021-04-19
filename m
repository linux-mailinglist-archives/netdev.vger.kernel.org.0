Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3948364126
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhDSL7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 07:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhDSL7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 07:59:23 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1A7C06174A;
        Mon, 19 Apr 2021 04:58:53 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id x27so16716357qvd.2;
        Mon, 19 Apr 2021 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=15zVT2UKm+VlfsojhkxZJMUdshbQNnSfP0LTzZVVl1Y=;
        b=lAdoGVL5wDt9qKeKlTBXNXjJ32FilGVCE2lZmtvHPorG7CBWImNKQkAI+3PJHqVu+B
         2XPff882PO3P4aF+MiU/m1Vj45905Z4D8NssoOl5CNyQjBlkJE4wK8UpYtGSH24JZWyY
         aURG2VrVaBhbiKKSMCwWlJlIDfJir1X9qCwqizldg095+ZuCxMmwF/AUowfFWpUxxRI9
         JcuzEwO+WeCLfa7Q6n8oXqzixhr1iX4MvgWN4HUyf+ovuvfBf9XAnXalQ+SoHo96eYtw
         XCKmJJZ6IsEnhMTFW6so/iVNVPi6loysWnEbIKgY9WxYc27kkw4vNDQ58iw3ldXYxzkK
         TLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=15zVT2UKm+VlfsojhkxZJMUdshbQNnSfP0LTzZVVl1Y=;
        b=mWNhrDi2hxfUdlBgTwyz7J1VK5IyTI3qQE8S89J4OCclGXn1diiaVb994ZaYF8fknb
         d0JrDXUghMAkrBQrJjzPLkAi7Q0irwYi3h07takOEqVnoxEFNd7TyNNGD+yIdzni8/g1
         +Fw+EMxPO2t3N6lnpdMV3bJulku6sEE7L3ha4rLWNIDCaVqjAANrdTbeF14Zwjv6rMTM
         04HeKmsz/e4L+12rVd8oFM60/GW1gdKp6WYuSFG3F/07eP65eC2hJ6t7fMl51uApdfa2
         O4CdUuduPBTJye1bs73jh6XxLHwMJk1bgzsk8AeNMaifbSb+iaw+Ew4KHJfpkElv8w5t
         wPyQ==
X-Gm-Message-State: AOAM530b6fnJ+5gi+cQzzkVNm0eIDOtCmpRCh6S5YnasmnHoVfoMi9r9
        1IWL2qdVUC/j4DmBgXIqpCdpsJE6xH8=
X-Google-Smtp-Source: ABdhPJx0gZ9G6CRVmsp8P1cCtFJ+4RBhx9SY6MwGt2+oL7pMtgC3th0Pl9QpnEXlETUPXij9TJF42A==
X-Received: by 2002:a05:6214:1484:: with SMTP id bn4mr20789676qvb.33.1618833532775;
        Mon, 19 Apr 2021 04:58:52 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:1b53])
        by smtp.gmail.com with ESMTPSA id q26sm3440298qtr.7.2021.04.19.04.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 04:58:52 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
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
 <90baba5d-53a1-c7b1-495d-5902e9b04a72@gmail.com>
 <202103101254.1DBEE1082@keescook>
 <4eb49b08-09bb-d1d2-d2bc-efcd5f7406fe@gmail.com>
 <dc53ec8c-76e1-e487-26ae-6b34afde9ca2@embeddedor.com>
Message-ID: <03028798-d42c-d864-8c88-94bb43da42e5@gmail.com>
Date:   Mon, 19 Apr 2021 07:58:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <dc53ec8c-76e1-e487-26ae-6b34afde9ca2@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/21 3:24 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 4/17/21 13:29, Jes Sorensen wrote:
>> On 3/10/21 3:59 PM, Kees Cook wrote:
>>> On Wed, Mar 10, 2021 at 02:51:24PM -0500, Jes Sorensen wrote:
>>>> On 3/10/21 2:45 PM, Kees Cook wrote:
>>>>> On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
>>>>>> On 3/10/21 2:14 PM, Kees Cook wrote:
>>>>>>> Hm, this conversation looks like a miscommunication, mainly? I see
>>>>>>> Gustavo, as requested by many others[1], replacing the fallthrough
>>>>>>> comments with the "fallthrough" statement. (This is more than just a
>>>>>>> "Clang doesn't parse comments" issue.)
>>>>>>>
>>>>>>> This could be a tree-wide patch and not bother you, but Greg KH has
>>>>>>> generally advised us to send these changes broken out. Anyway, this
>>>>>>> change still needs to land, so what would be the preferred path? I think
>>>>>>> Gustavo could just carry it for Linus to merge without bothering you if
>>>>>>> that'd be preferred?
>>>>>>
>>>>>> I'll respond with the same I did last time, fallthrough is not C and
>>>>>> it's ugly.
>>>>>
>>>>> I understand your point of view, but this is not the consensus[1] of
>>>>> the community. "fallthrough" is a macro, using the GCC fallthrough
>>>>> attribute, with the expectation that we can move to the C17/C18
>>>>> "[[fallthrough]]" statement once it is finalized by the C standards
>>>>> body.
>>>>
>>>> I don't know who decided on that, but I still disagree. It's an ugly and
>>>> pointless change that serves little purpose. We shouldn't have allowed
>>>> the ugly /* fall-through */ comments in either, but at least they didn't
>>>> mess with the code. I guess when you give someone an inch, they take a mile.
>>>>
>>>> Last time this came up, the discussion was that clang refused to fix
>>>> their brokenness and therefore this nonsense was being pushed into the
>>>> kernel. It's still a pointless argument, if clang can't fix it's crap,
>>>> then stop using it.
>>>>
>>>> As Kalle correctly pointed out, none of the previous comments to this
>>>> were addressed, the patches were just reposted as fact. Not exactly a
>>>> nice way to go about it either.
>>>
>>> Do you mean changing the commit log to re-justify these changes? I
>>> guess that could be done, but based on the thread, it didn't seem to
>>> be needed. The change is happening to match the coding style consensus
>>> reached to give the kernel the flexibility to move from a gcc extension
>>> to the final C standards committee results without having to do treewide
>>> commits again (i.e. via the macro).
>>
>> No, I am questioning why Gustavo continues to push this nonsense that
>> serves no purpose whatsoever. In addition he has consistently ignored
>> comments and just keep reposting it. But I guess that is how it works,
>> ignore feedback, repost junk, repeat.
> 
> I was asking for feedback here[1] and here[2] after people (you and Kalle)
> commented on this patch. How is that ignoring people? And -again- why
> people ignored my requests for feedback in this conversation? It's a mystery
> to me, honestly.

All you did was post a pointer to the fact that some other people
couldn't be bothered speaking out against the patch, and let it go in.
You haven't addressed any of the original concerns raised.

The big mistake here was of course to allow the pointless /* fallthrough
*/ changes to go in in the first place.

Jes
