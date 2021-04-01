Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97C5350B16
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 02:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhDAATC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 20:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhDAASu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 20:18:50 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8291C061574;
        Wed, 31 Mar 2021 17:18:49 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id w1-20020a4adec10000b02901bc77feac3eso149792oou.3;
        Wed, 31 Mar 2021 17:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=STvPrV5JuwYSv0Aq7r42gqM6RUkqGxJqGQ6E+64EXj4=;
        b=RM6jVIIEk7Xxa/loBbtyN1vB2ZVxU26jXCNJlzK7Q8vT7f+OGdzKxB+vU7i4fnS3Ph
         UcX5/BipdN+8vyHli0Qat3DabIKP+X2vIoDVGxi+s0bjPiF+6LNFnWGoQL0QxvSWS7bN
         Y0rg0QH4jM6vrzSIABbljul7H+CE+N/2pMKK4fpG1ZuSznVidQgVqLDCmaUqBjA8lCMu
         y5TAz0yJgIr01VXqgg/mP0xwEiMEaf8e9zZWM6TA9ghAf8MG1RZi5Rm5EiyAb3ywduDw
         WtTLAFDDIVK+H+SSmgN0VhQ1fGUdVXQ4nbujtY9OoYIcMRs+WkXvZdZ68FIrhDCbalVd
         twUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STvPrV5JuwYSv0Aq7r42gqM6RUkqGxJqGQ6E+64EXj4=;
        b=gnXrpWjpo2oTBpvGXV5KaSOaUWbEaHedPD2wwzOcXsCUzQY9XBDlAgASY2jRMJOqga
         murC+O+FCZIAKjqu36HgpSb5az4kqs/eaYn7D3FMrchzZr57cqftChKJms5E2Cbz8Kv8
         471+7t01y02+lc8BE8lgtgJdhvkjNiE1G6phtbfKL6GH3vSTaO3vC0X2qOnjVtgYVyXm
         PRvJYKZgAkQPgyG6efNn98EkSar537LuOSZjixKbi9G5oTlGkADsByBNJA9Fo248x4ND
         9EY3Sl3Xd3Gv/596l+B8Pv/flrZf00LqzpZwScK04pPTXcMS+OgzowBBp3O0t/M92BRs
         QQkA==
X-Gm-Message-State: AOAM530bbDzSWQ2I8WTX4kZ8fYWYmUFzp7zGtqrc0fUkvKYMK9qpTRpE
        vEgnme//K9LvZrJQZ4HrxqA=
X-Google-Smtp-Source: ABdhPJysuCN0yqHaekb+tpRaqJj6MX/ID2IwE28+v3asEEoFAm5qJeblCcgtMi65c5kGAKg1X2AVyQ==
X-Received: by 2002:a4a:be86:: with SMTP id o6mr4769856oop.70.1617236329008;
        Wed, 31 Mar 2021 17:18:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id w11sm764236ooc.35.2021.03.31.17.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 17:18:48 -0700 (PDT)
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
To:     Norman Maurer <norman.maurer@googlemail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        davem@davemloft.net
References: <20210325195614.800687-1-norman_maurer@apple.com>
 <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
 <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
 <2e667826f183fbef101a62f0ad8ccb4ed253cb75.camel@redhat.com>
 <71BBD1B0-FA0A-493D-A1D2-40E7304B0A35@googlemail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4ba2450c-413a-0417-e805-2486ab562df8@gmail.com>
Date:   Wed, 31 Mar 2021 18:18:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <71BBD1B0-FA0A-493D-A1D2-40E7304B0A35@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 7:10 AM, Norman Maurer wrote:
> Friendly ping… 
> 
> As this missing change was most likely an oversight in the original commit I do think it should go into 5.12 and subsequently stable as well. That’s also the reason why I didn’t send a v2 and changed the commit message / subject for the patch. For me it clearly is a bug and not a new feature.
> 
> 

I agree that it should be added to net

If you do not see it here:
  https://patchwork.kernel.org/project/netdevbpf/list/

you need to re-send and clearly mark it as [PATCH net]. Make sure it has
a Fixes tag.

