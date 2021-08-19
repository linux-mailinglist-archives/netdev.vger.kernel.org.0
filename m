Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6433F2229
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhHSVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhHSVQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 17:16:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB69C061575;
        Thu, 19 Aug 2021 14:16:09 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id h9so13700223ljq.8;
        Thu, 19 Aug 2021 14:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uytEJVRyC2uWavwHxEqi0WXXKYJf8M3RDhpUCKnDzi0=;
        b=WYkSz/WNjiXCha46YOYpQn0p6ZpUSWEHLNTeiJIUkxEWdYdGuZ+Wh419mv9vccYV/h
         FyedsTU3w0GCbR8iBf/EUKHw96kq20JQjSbZN2Wh6sRiKz2eEoj+U2BDD+Ehcz6TSL6Y
         Zrfqx1VCNeR199zw19esCUobFXx0RYnWJOCbyGYJ54U9/oH0OKIdoyq5nWMsO7HqBf8h
         gK2olpJP3nPMJJpKYY1eIPvTzyiDZUrs4L2EfMXFEv5Jdh/SVApIv2RkR5k2cXGCTlBb
         W1egsuyVAP2X5VrRoaVAfllAj9iH4C86MRtu0OWQRTbx+ynO/zJ5kvl6lfL+XmpBpUjR
         T3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uytEJVRyC2uWavwHxEqi0WXXKYJf8M3RDhpUCKnDzi0=;
        b=t6la1b+nTkxI2uhIPq8njLHhbvGLhINnBDA5pMBrRi0x0m10z9RgUFHELArx8o7S83
         f6R1GjP6Nv/JIlMWCL0g5jFqKXoD8GoKbFKVL34L4fNMCW+ENiaY8osaDw/Cv3prloMJ
         44fWumRej85avvuYcqMcaScTguVO1AbloKj08lSlYIvTgyjmTpLCOpcNtfj33shrwnFI
         orXbiPFLMd+UJN6InBQDSkisD+TkEmNTNqbgpYVaGzU20Ts7xM48AmNlr5/yWHUAyuS7
         XElakTO5qMwUhsDzUDgWHz2l5JIQq8Qeh3tp0X2YQF0fh5vVrj840OerZsS/xHt8mObo
         DZ/w==
X-Gm-Message-State: AOAM533U2TtbZOeZ8trs412/x6YgYq4dU+fwk/L5kExJAAe65+7xIUfC
        pMw98KnSUIeB1/c9hYwqFhE=
X-Google-Smtp-Source: ABdhPJxEvTVzyrJevph0BkZVC5UD6cSCi4pXljssbkKeZB70HDvIeSeaxeAcGu2J8CKz/9IxZV2gog==
X-Received: by 2002:a05:651c:2006:: with SMTP id s6mr13078281ljo.171.1629407768120;
        Thu, 19 Aug 2021 14:16:08 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id c11sm360080ljr.1.2021.08.19.14.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 14:16:07 -0700 (PDT)
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
 <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
 <CAFcO6XMTiEmAfVJ4rwdeB6QQ7s3B-1hx3LJpa-StCb-WJwasPg@mail.gmail.com>
 <763a3f4d-9edc-bb0d-539c-c97309a4975d@gmail.com>
 <20210819140233.5f8d8cd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <e24737f1-5793-805a-5979-ec564ab1db13@gmail.com>
Date:   Fri, 20 Aug 2021 00:16:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819140233.5f8d8cd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/21 12:02 AM, Jakub Kicinski wrote:
> On Thu, 19 Aug 2021 23:24:39 +0300 Pavel Skripkin wrote:
>> On 8/19/21 11:06 PM, butt3rflyh4ck wrote:
>> > Yes, this bug can be triggered without your change. The reason why I
>> > point to your commit is to make it easier for everyone to understand
>> > this bug.
>> 
>> As I understand, purpose of Fixes: tag is to point to commit where the 
>> bug was introduced. I could be wrong, so it's up to maintainer to decide 
>> is this Fixes: tag is needed or not :)
> 
> You're right thanks for pointing that out. May it should actually be:
> 
> Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing") ?
> 

Yes, this is correct one. I guess, patch author has chosen 194ccc88297a, 
because my commit has same Fixes: tag (wrong one, btw).


With regards,
Pavel Skripkin
