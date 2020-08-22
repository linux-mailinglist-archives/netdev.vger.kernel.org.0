Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD424E4A2
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHVCQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgHVCQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 22:16:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09934C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:16:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m34so1836368pgl.11
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5oalbzA9dBTbCqq5PhoY63nft9pchxGNH6TAmAZOz7g=;
        b=2MnfzptS5xbFezD0n2TBkA5p2qVSAxaqWRN7T9xskZ42WVY4pwmYo62emAIFL5+mIV
         2b4WBYkqH6kpuQh+KnmIlERPmvQOLsq6Fu2QfBqH27gtru+VKMATRLgqpEvRA1CtWG0T
         gZubPSIy9+OCBRRg3dtypRxSQ9inGHKnauRUtuiec+fIBAzt/uEuZA5UWTC8b322y85g
         ttUXcLd0CAOrljV+X7tVY4RYF3Nz9MzfJIv+bVE/1hdwHAq0E1fexSovXuMMNUbaa3bt
         KBaSY1/w+GcAM/SaY51rNw1SD28jM85IN3yYUZLKK9Ru29xF47VkIAg1hVtPxF/QWy3T
         1Knw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5oalbzA9dBTbCqq5PhoY63nft9pchxGNH6TAmAZOz7g=;
        b=brOiRvnH0DQyGtZU3l4/kWh4NOcfdqw3P/HekWtr4Q2i+bSq3h3cHaAGBztTMV9j/y
         QAfVCHGFt7aBBGDViZS4TgGeEhDztEVR/5+W4e/lAGKGaZHYmaLTqFT0nbDzgVN2JLtw
         CR+Oc5zQQLt6k+l6zNjSJXJxLc0r35id6xbZ7tvrI5tMqQ4LXsFYavTxbRWwNzbr0iQW
         Frqs8yCSyxnHfKqlBK8A0P/dpB9IYruEGEbHlPJN1HHse/nDpT/9HXkHNfqhuJSV5FQR
         qnVZ/ivBN4gHYMWE+yi8mDW4SIKFXcxwWTrOEQDrSAqCdS6KjBS0tZNn6JEmpUv0VHH+
         arig==
X-Gm-Message-State: AOAM532G6MybG+jlK6Ssa/BfTOO/fFVFakKQKSbUAWJy6Fy6Yjy0NLCf
        ds+fJXPDiKBjUudB+hnNoABSAA==
X-Google-Smtp-Source: ABdhPJwx6CnL9+4DrUVZjMSYcWXJ2Tz/5q5/KlZbX/rmuQZWvRcEWS7hzKo/RpRRXAxyKnGS3XXNgA==
X-Received: by 2002:a63:7802:: with SMTP id t2mr4305706pgc.421.1598062594423;
        Fri, 21 Aug 2020 19:16:34 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id js19sm3108248pjb.33.2020.08.21.19.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 19:16:33 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
To:     Luke Hsiao <lukehsiao@google.com>
Cc:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <9abca73b-de63-f69d-caff-ae3ed24854de@kernel.dk>
 <20200822020442.2677358-1-luke.w.hsiao@gmail.com>
 <20200822020442.2677358-2-luke.w.hsiao@gmail.com>
 <8a2dcf9a-7ccd-f28d-deb4-bda0a4a7a387@kernel.dk>
 <CADFWnLxQL5_1_E7Pa8tG4aBhY45sOY_PK1ct0kHs1uUbJSKS-A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
Date:   Fri, 21 Aug 2020 20:16:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADFWnLxQL5_1_E7Pa8tG4aBhY45sOY_PK1ct0kHs1uUbJSKS-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 8:13 PM, Luke Hsiao wrote:
> Hi Jens,
> 
> On Fri, Aug 21, 2020 at 7:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/21/20 8:04 PM, Luke Hsiao wrote:
>>>
>> Sorry, one more minor thing to fix up:
>>
>>> @@ -4932,6 +4934,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>>>               mask |= POLLIN | POLLRDNORM;
>>>       if (def->pollout)
>>>               mask |= POLLOUT | POLLWRNORM;
>>> +
>>> +     /* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
>>> +     if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
>>> +             mask &= ~POLLIN;
>>> +
>>
>> Don't pass in the sqe here, but use req->sr_msg.msg_flags for this check. This
>> is actually really important, as you don't want to re-read anything from the
>> sqe.
>>
>> I'm actually surprised this one got past Jann :-)
> 
> Got it, I will make the change and send v3. In Jann's defense, he
> reviewed the previous commit, but not this one :). Thanks for your
> detailed feedback.

Ah right you are, I guess it was the previous patch that had his
review! Thanks for taking care of this.

-- 
Jens Axboe

