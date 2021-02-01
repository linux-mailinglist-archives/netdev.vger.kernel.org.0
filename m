Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8540230AF96
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhBASjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhBASjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:39:03 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AEEC0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:38:20 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u8so13379891ior.13
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 10:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vR0B9VlMvNtAZhaGiDDVhMV/Qg/talwAAAGPTlNsNtk=;
        b=ClQyNUKzXM47JsEx0o5ozMu+l0YAQEH4Cul5XFHJbMBLm64Z5h9Ivl0gkQigST+UzP
         DA7uHTnknG+BPG4YRRJp4V36JvOJ+zyx6K2Qg+AGDf2iClTPYYQdQvgE2siKg3SuGqc4
         tJZ6gri3JHv7onV/u46t0pd+rGwlHNS7eyUhAMNoD53/cTlSO2blo1a8/GkaMwYgJaNu
         LUu5eEI9eQ++TDpcy2arFsWzxxXYBF7sPFFh4GhDT0TN7jT725maFb3AufQquEtbFLOk
         uVztoPtN0phKAr0VoUXUSar2ad3eoC8KSiNG4Q/ap37/DqjqxTZx+MgowNsj6XvZeGHD
         EXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vR0B9VlMvNtAZhaGiDDVhMV/Qg/talwAAAGPTlNsNtk=;
        b=DpwQXqGS/8Q45EGWxvg9rODOw003Pzu6v5Dhts5Z/wZRe7a8zSTfyQmNIcN2okh8dz
         xXVPfw8Q3xyVAeDnLj1yQh/rnGf1um35C46k8XspeitKs5iYrCZ8Z5drENXH2RaiPaNb
         F0WW7YhI+M8Qw0f62Bkx6uNy95V6LxjDvtQUP34jInEumLjVME5zUMVcSc3gv3zODhFP
         PSI9B37AgICtM6wns3wPhDKk/U9EAAo1DNA7LvwJHBFi5BYaQ4pIsj/rokxsOAeHDVO1
         zk9NH2fgXldmb1x+Qf0xG3SZw1YS1XjtVI4GBygvnkLyCOPU7hlRoQs/VaTtG2sw9dp3
         lG+g==
X-Gm-Message-State: AOAM530UNM8KcE3ledt5tWa28Zacv1p5YG1o+pEDxjO/uJuczojpDgFa
        1BrlM/lK8uusLbruH/M5dOmoFg==
X-Google-Smtp-Source: ABdhPJwntFOgORy4jVi4QQK3FXqa3bciAQsugPOFGhLws6tZemaqRuZEXu7iDm3Bv0EH5BdUpL3PZg==
X-Received: by 2002:a05:6602:2c4e:: with SMTP id x14mr13314766iov.58.1612204700152;
        Mon, 01 Feb 2021 10:38:20 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o131sm1751789ila.5.2021.02.01.10.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 10:38:19 -0800 (PST)
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210129202019.2099259-1-elder@linaro.org>
 <20210129202019.2099259-10-elder@linaro.org>
 <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
 <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
 <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
 <67f4aa5a-4a60-41e6-a049-0ff93fb87b66@linaro.org>
 <CAF=yD-+ABnhRmcHq=1T7PVz8VUVjqC073bjTa89GUt1rA3KVUw@mail.gmail.com>
 <a1b12c17-5d65-ce29-3d4f-e09de4fdcf3f@linaro.org>
 <CAF=yD-JSpz5OAp3DtW+1K_w1NZsLLxbrviZRQ5j7=qyJFpZAQg@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <1aa6778a-6aff-e72f-ca98-74ce952c1e56@linaro.org>
Date:   Mon, 1 Feb 2021 12:38:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JSpz5OAp3DtW+1K_w1NZsLLxbrviZRQ5j7=qyJFpZAQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 8:47 AM, Willem de Bruijn wrote:
>> - I will begin some long testing later today without
>>     this last patch applied
>>       --> But I think testing without the IRQ ordering
>>          patch would be more promising, and I'd like
>>          to hear your opinion on that
> Either test depends on whether you find it worthwhile to more
> specifically identify the root cause. If not, no need to run the tests
> on my behalf. I understand that these are time consuming.

I *would* like to really understand the root cause.
And a month ago I would have absolutely gone through
a bisect process so I could narrow it down.

But at this point I'm content to have it fixed (fingers
crossed) and am more interested in putting all this
behind me.  It's taken a lot of time and attention.

And even though this represents a real bug, at least
for now I am content to keep all this work in net-next
rather than isolate the specific problem and try to
back-port it (without all the other 20+ commits that
preceded these) to the net branch.

So although I see the value in identifying the specific
root cause, I'm not going to do that unless/until it
becomes clear it *must* be done (to back-port to net).

					-Alex
