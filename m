Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80F7363210
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhDQTt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:49:27 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.218]:28668 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236718AbhDQTt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 15:49:27 -0400
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2021 15:49:27 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 34BA4781E
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 14:24:46 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id XqYglEPR9L7DmXqYglOyCM; Sat, 17 Apr 2021 14:24:46 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nLSkpOd3XZR5r0muN1xJlaF3Fg92tAYTugf+ZrPQVoY=; b=Z5epnxU9ICDFvitytMG2lKf3Y4
        p+b/tVrNwo1UlSAunOo78zK+k4Vdf7JadbNPgxps+8hrhLYjbeNBalWprQ2OMp6tpmtjpmQOYhh96
        9y/9YjzjLPbHCZ/e/CMrAQvGh+SffkRvZTbKkob00i+JaEyeUZMPmjHfFVsshxhcc1pTQx1727enL
        o1OChDoxsaDDSV3r7N6wrC/vT9M3nLL7ClD6PFBzY8dZ67tb/gbp9x1IfxZSG/8AG4SuTza4gEkrb
        mS45FCNO4iLpvvIWgYRibk1CeYMgGVW1QU0VJNprPEW6T0EZiTApHCL1jWvWuy1lt8lU8Ncsi7eG5
        K9Qen0+A==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49852 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lXqYc-000FWD-Ll; Sat, 17 Apr 2021 14:24:42 -0500
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Jes Sorensen <jes.sorensen@gmail.com>,
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
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <dc53ec8c-76e1-e487-26ae-6b34afde9ca2@embeddedor.com>
Date:   Sat, 17 Apr 2021 14:24:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4eb49b08-09bb-d1d2-d2bc-efcd5f7406fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lXqYc-000FWD-Ll
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49852
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/21 13:29, Jes Sorensen wrote:
> On 3/10/21 3:59 PM, Kees Cook wrote:
>> On Wed, Mar 10, 2021 at 02:51:24PM -0500, Jes Sorensen wrote:
>>> On 3/10/21 2:45 PM, Kees Cook wrote:
>>>> On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
>>>>> On 3/10/21 2:14 PM, Kees Cook wrote:
>>>>>> Hm, this conversation looks like a miscommunication, mainly? I see
>>>>>> Gustavo, as requested by many others[1], replacing the fallthrough
>>>>>> comments with the "fallthrough" statement. (This is more than just a
>>>>>> "Clang doesn't parse comments" issue.)
>>>>>>
>>>>>> This could be a tree-wide patch and not bother you, but Greg KH has
>>>>>> generally advised us to send these changes broken out. Anyway, this
>>>>>> change still needs to land, so what would be the preferred path? I think
>>>>>> Gustavo could just carry it for Linus to merge without bothering you if
>>>>>> that'd be preferred?
>>>>>
>>>>> I'll respond with the same I did last time, fallthrough is not C and
>>>>> it's ugly.
>>>>
>>>> I understand your point of view, but this is not the consensus[1] of
>>>> the community. "fallthrough" is a macro, using the GCC fallthrough
>>>> attribute, with the expectation that we can move to the C17/C18
>>>> "[[fallthrough]]" statement once it is finalized by the C standards
>>>> body.
>>>
>>> I don't know who decided on that, but I still disagree. It's an ugly and
>>> pointless change that serves little purpose. We shouldn't have allowed
>>> the ugly /* fall-through */ comments in either, but at least they didn't
>>> mess with the code. I guess when you give someone an inch, they take a mile.
>>>
>>> Last time this came up, the discussion was that clang refused to fix
>>> their brokenness and therefore this nonsense was being pushed into the
>>> kernel. It's still a pointless argument, if clang can't fix it's crap,
>>> then stop using it.
>>>
>>> As Kalle correctly pointed out, none of the previous comments to this
>>> were addressed, the patches were just reposted as fact. Not exactly a
>>> nice way to go about it either.
>>
>> Do you mean changing the commit log to re-justify these changes? I
>> guess that could be done, but based on the thread, it didn't seem to
>> be needed. The change is happening to match the coding style consensus
>> reached to give the kernel the flexibility to move from a gcc extension
>> to the final C standards committee results without having to do treewide
>> commits again (i.e. via the macro).
> 
> No, I am questioning why Gustavo continues to push this nonsense that
> serves no purpose whatsoever. In addition he has consistently ignored
> comments and just keep reposting it. But I guess that is how it works,
> ignore feedback, repost junk, repeat.

I was asking for feedback here[1] and here[2] after people (you and Kalle)
commented on this patch. How is that ignoring people? And -again- why
people ignored my requests for feedback in this conversation? It's a mystery
to me, honestly.

Thanks
--
Gustavo

[1] https://lore.kernel.org/lkml/20201124160906.GB17735@embeddedor/
[2] https://lore.kernel.org/lkml/e10b2a6a-d91a-9783-ddbe-ea2c10a1539a@embeddedor.com/
