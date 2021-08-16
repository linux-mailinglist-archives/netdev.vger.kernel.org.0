Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985823ED8D6
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhHPOVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhHPOVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:21:14 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912FFC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:20:42 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id u7so18716570ilk.7
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZdY43BmHwJ9DyNYh0fm/33Z4sEPUAt4Lp4aZlFW1GTk=;
        b=eclCU0gxGJ3rxKvqWVcfExuXe7lG5b3uPcljlc9N5eaKWxp3O4DgzJa1xgfoiZp2Az
         EAJWZwTWrirfCayp/2mXEsJ+vswEQSV6XiC9NmuG4LrAG+FcUKXftg9fCH9yBDKJWgl1
         SMCUDHb7FViztLkSYQshvDE8Aikyx324o3E1w+pS9Vyh3DINjDIcElcfKyV2I9G6G4M/
         HeshVGxdytNlFQbnopKzyhc9w6+FZ9p3/hEOVCm91bMcikEfog7syCAKG2M2JiyqvNsj
         WaCSosue24Ry73Sa4Hu7WvirxhSOWw451pds+kbUL5EoNGeS5R+XR9OFbxBKokTUYkF/
         YqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZdY43BmHwJ9DyNYh0fm/33Z4sEPUAt4Lp4aZlFW1GTk=;
        b=JLuTaHHxWWmeXFuoQeaqbLhAZ8/152S13eiScpKVuJYP9Ewb6V38pJmTMiZcFesaVe
         qOjqDNTmMyk15c7oEmVQrvZ3TAR6OOXBAqbZ1Jv6uicqYxSL4hk0E2zFtuYs5dOQEPvh
         ywxSxrYH2SxpANxvpfHlThn5YIt8eH3kPNyvhTEceOBseRAXQDowhOYtzxZA4LYLB/YC
         PhXF9ZSFCdmwqpmcHSq3p2IclmqseBJ4dplFOtUDn6taWS7W6HOOgDknh7EzqyDQlhA0
         T8kntIy72N/WkgW6C3k5CeUi3PaVj7ux9R5tVUu9+iPoKU2KK2Q1Rs+2qQEgUHMsJ/qn
         iPOw==
X-Gm-Message-State: AOAM532CU4X/4upy2oAyoqF1kN40eEc7Wybw1EjRGsYB25dsEE6PdW1x
        EVU9LmeQ2h5DhlbXDPdeiMc4ew==
X-Google-Smtp-Source: ABdhPJyqIUq3/7V4EUpMofpmG76jXAnX2+YGuEtx4CO99U4aCIZdMUQE/GkjTd8ViUAifPPJu+RSiA==
X-Received: by 2002:a05:6e02:2145:: with SMTP id d5mr858660ilv.23.1629123641680;
        Mon, 16 Aug 2021 07:20:41 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id m26sm3210997ioj.54.2021.08.16.07.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 07:20:41 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] net: ipa: ensure hardware has power in
 ipa_start_xmit()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210812195035.2816276-1-elder@linaro.org>
 <20210812195035.2816276-5-elder@linaro.org>
 <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a9e82cc-c09e-62e8-4671-8f16d4f6a35b@linaro.org>
 <20210816071543.39a44815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b6b1ca41-36de-bcb1-30ca-6e8d8bfcc5a9@linaro.org>
Date:   Mon, 16 Aug 2021 09:20:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816071543.39a44815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 9:15 AM, Jakub Kicinski wrote:
> On Fri, 13 Aug 2021 21:25:23 -0500 Alex Elder wrote:
>>> This is racy, what if the pm work gets scheduled on another CPU and
>>> calls wake right here (i.e. before you call netif_stop_queue())?
>>> The queue may never get woken up?
>>
>> I haven't been seeing this happen but I think you may be right.
>>
>> I did think about this race, but I think I was relying on the
>> PM work queue to somehow avoid the problem.  I need to think
>> about this again after a good night's sleep.  I might need
>> to add an atomic flag or something.
> 
> Maybe add a spin lock?  Seems like the whole wake up path will be
> expensive enough for a spin lock to be in the noise. You can always
> add complexity later.

Exactly what I just decided after trying to work out a
clever way without using a spinlock...  I'll be sending
out a fix today.  Thanks.

					-Alex

