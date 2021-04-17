Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3033631D0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhDQSaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbhDQSaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:30:20 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBB1C061574;
        Sat, 17 Apr 2021 11:29:53 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id d15so19193334qkc.9;
        Sat, 17 Apr 2021 11:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n55pdEuyvRot9EGscePhvs8MONc424RNPjUKuPjJvuk=;
        b=Tl3TeJOTi7czS6J/XHJFRBhWWjaulDh8YRiXbtjYKsDQURZUtdKha+NU8ahIZ6KnWj
         nYoQsGq/ToCX2i9NttTbVir/rqB5t5A9nSbxTnPliuZSnqEpabnOz68QIIpppzoXHVab
         SOxKS6b5xV8YG7q+tchfWo+5AAytrI1tWrYmoDRLTRQyCe1N94br+Vr8IyDVd9nA4qz3
         WxAtV4aNuIBLtIJ1v1Q96xwcyuiOYM/I6R1IkaigJi3DrJrZyw/kG0ke8E7Nvq0xQpvZ
         aLkPm0KXotlGLG/Rc+YulMw7zOXa/gfBW+hP4hoKVM+DldzPHPgeTaQbQmdD06zpgUQQ
         iVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n55pdEuyvRot9EGscePhvs8MONc424RNPjUKuPjJvuk=;
        b=GblngnwyjeYoPMXKCDN04YzV7b/X+WK/BFgm3OkCE3NKv5lya7pq5IUfRPVy5ztT8J
         d20ufbqZgvyoV1nMG9N84N8fXugFgSSUIKMsSnet57Za07GACGq9xaYDhdC2lcGGPchj
         u/fQASVLNi6u/xTXFxPRqSF+d4jTMVZlrVLIn+MlHW9B6DnEkcI0gLGMook2GsFJ0Afq
         qYKJI3BGS5tuPd2M+PyoY6MyS27yZ8zEHPy2CG0ZvW/Mo/l/dVa3pdElK+kdAiIxMC8M
         08Iy3QQE4e9Ay6sfuKd8flUzrU+yPP2cv+cm+H3SaZXAeqzdVGbFCn+lpXEBtlQ8YLEJ
         zizg==
X-Gm-Message-State: AOAM532wIwT5/SQdJA/7X7mOWCC3+jbYo1unAakTX6TJEuTBLnxs2TOH
        +Cyf1Cs1eQmqbn7wP4JaPRJI7atNGGA=
X-Google-Smtp-Source: ABdhPJw7fWkDQOkH38Di0oMGWac3KVXW3r0HtLirWNDl1SRn4stESdbRJgPBoY4F0jcnE78gHNB1cQ==
X-Received: by 2002:a37:45c7:: with SMTP id s190mr4950487qka.111.1618684192734;
        Sat, 17 Apr 2021 11:29:52 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:1b53])
        by smtp.gmail.com with ESMTPSA id f185sm6614506qke.61.2021.04.17.11.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 11:29:52 -0700 (PDT)
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
 <90baba5d-53a1-c7b1-495d-5902e9b04a72@gmail.com>
 <202103101254.1DBEE1082@keescook>
Message-ID: <4eb49b08-09bb-d1d2-d2bc-efcd5f7406fe@gmail.com>
Date:   Sat, 17 Apr 2021 14:29:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <202103101254.1DBEE1082@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 3:59 PM, Kees Cook wrote:
> On Wed, Mar 10, 2021 at 02:51:24PM -0500, Jes Sorensen wrote:
>> On 3/10/21 2:45 PM, Kees Cook wrote:
>>> On Wed, Mar 10, 2021 at 02:31:57PM -0500, Jes Sorensen wrote:
>>>> On 3/10/21 2:14 PM, Kees Cook wrote:
>>>>> Hm, this conversation looks like a miscommunication, mainly? I see
>>>>> Gustavo, as requested by many others[1], replacing the fallthrough
>>>>> comments with the "fallthrough" statement. (This is more than just a
>>>>> "Clang doesn't parse comments" issue.)
>>>>>
>>>>> This could be a tree-wide patch and not bother you, but Greg KH has
>>>>> generally advised us to send these changes broken out. Anyway, this
>>>>> change still needs to land, so what would be the preferred path? I think
>>>>> Gustavo could just carry it for Linus to merge without bothering you if
>>>>> that'd be preferred?
>>>>
>>>> I'll respond with the same I did last time, fallthrough is not C and
>>>> it's ugly.
>>>
>>> I understand your point of view, but this is not the consensus[1] of
>>> the community. "fallthrough" is a macro, using the GCC fallthrough
>>> attribute, with the expectation that we can move to the C17/C18
>>> "[[fallthrough]]" statement once it is finalized by the C standards
>>> body.
>>
>> I don't know who decided on that, but I still disagree. It's an ugly and
>> pointless change that serves little purpose. We shouldn't have allowed
>> the ugly /* fall-through */ comments in either, but at least they didn't
>> mess with the code. I guess when you give someone an inch, they take a mile.
>>
>> Last time this came up, the discussion was that clang refused to fix
>> their brokenness and therefore this nonsense was being pushed into the
>> kernel. It's still a pointless argument, if clang can't fix it's crap,
>> then stop using it.
>>
>> As Kalle correctly pointed out, none of the previous comments to this
>> were addressed, the patches were just reposted as fact. Not exactly a
>> nice way to go about it either.
> 
> Do you mean changing the commit log to re-justify these changes? I
> guess that could be done, but based on the thread, it didn't seem to
> be needed. The change is happening to match the coding style consensus
> reached to give the kernel the flexibility to move from a gcc extension
> to the final C standards committee results without having to do treewide
> commits again (i.e. via the macro).

No, I am questioning why Gustavo continues to push this nonsense that
serves no purpose whatsoever. In addition he has consistently ignored
comments and just keep reposting it. But I guess that is how it works,
ignore feedback, repost junk, repeat.

Jes

