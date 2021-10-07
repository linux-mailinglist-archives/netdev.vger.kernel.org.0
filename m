Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69EE425397
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbhJGND3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:03:29 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:35300
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233100AbhJGNDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:03:22 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 958753FFE4
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633611687;
        bh=CWLF3Mwbuv27wfSQ2ZR3naLE1cJ0EA/H/ZCKfT8DDNk=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=ltUNq2q728kxrAGG+8SXOMIjL7Nm9WvqfAgtUYnpucWTYJNZ87SI5nA5rxRd2mxIx
         bzqeKRk6lLcghgo8LhLOVSk9spzAQDeMpN+CJqlVgc1lm/ZPAFk1fNTPbiDxxsSS0K
         8+i+ofTHgXG5NfSta/CSEX5OF9yqD77wjIMp3lTltLttyId5J3ONF8FfpA+Jd43TFy
         idHcZ1gA9qaeM6nut9Tdh/4PEfY9suOlbpwx3VOkSKUVqBJ5CNrNiP/pkZb9FgT/QB
         36Iy1QZOj+kkUU73GIFWsCfnBpquqjPgmUcbVr/SzWEXhCGmM5Jg5y5yvpq0TA+YDs
         /S5iDwO4DvVuw==
Received: by mail-ed1-f70.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso5809939edf.7
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWLF3Mwbuv27wfSQ2ZR3naLE1cJ0EA/H/ZCKfT8DDNk=;
        b=1hFBqaWxv+F3tNy3bh40T5ksLolGMvc87FHYRTsbNgRkqLjEz9813oUsviCwZ3zjKe
         sAjdFh0d6RYhZDdSTNQk4MsMMFOKPDhNVDduHEKRJqDk2KXNJTrQOdYIn/Mrv3R2ipNN
         HnyJJF9GjznKi8OtPLHfjJ/pMkIv/lZXwXWusNA6BAuaXEPrvUaxeOUIxAfLkVJTmSye
         ttHRk8a4PjDsl0Xq0nfCQ4ey+eXooXu4Je+7zmNiD8Uq6eFFvD57MS7AKKCYUiUmpO+z
         XQt3ZYmOfOlCCfz/Z1ivewmfu9qtjChmbfv2l8gaZXHKR7xtz2aIHETXNB22s5iLx7jt
         HIuw==
X-Gm-Message-State: AOAM531L3dm8SHdSxMhsJ8NjqZ9RdXGek0GkFt4XKsElOUI7H4jjJftg
        chZXFkjVOwDuB/2KMrD+Rbwrsm7oXu0MFno18xJe7G37YbWEo2fsYo0ahgCih4qXzeX4uUGhWO5
        cU0aeOlVO1Z3C/yG0ffM6saG77LsyA0cOsg==
X-Received: by 2002:a50:d98d:: with SMTP id w13mr6249814edj.51.1633611687324;
        Thu, 07 Oct 2021 06:01:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsGkLjq/HVHDfN4bAucyZ/pV1jwbbBY9M9ehNU17nvM5neTPUW/YNaP9/xGkH5n1G9eNdJaw==
X-Received: by 2002:a50:d98d:: with SMTP id w13mr6249781edj.51.1633611687059;
        Thu, 07 Oct 2021 06:01:27 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id m23sm2258674eja.6.2021.10.07.06.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 06:01:26 -0700 (PDT)
Subject: Re: [PATCH v2 12/15] nfc: trf7970a: drop unneeded debug prints
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
 <20210913132035.242870-13-krzysztof.kozlowski@canonical.com>
 <20210913165757.GA1309751@animalcreek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <47eae95d-d34c-1fa7-fea9-6e77a130aa97@canonical.com>
Date:   Thu, 7 Oct 2021 15:01:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210913165757.GA1309751@animalcreek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/09/2021 18:57, Mark Greer wrote:
> On Mon, Sep 13, 2021 at 03:20:32PM +0200, Krzysztof Kozlowski wrote:
>> ftrace is a preferred and standard way to debug entering and exiting
>> functions so drop useless debug prints.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  drivers/nfc/trf7970a.c | 8 --------
>>  1 file changed, 8 deletions(-)
>>

Hi Jakub and David,

Some patches from this set were applied, but rest was not. All of them
are however marked as accepted:
https://patchwork.kernel.org/project/netdevbpf/list/?series=545829&state=*

I think something got lost. Could you apply missing ones or maybe I
should rebase and resend?


Best regards,
Krzysztof
