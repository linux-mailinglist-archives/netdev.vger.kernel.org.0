Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F420D44E5BF
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhKLLxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 06:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbhKLLxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 06:53:30 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC00C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 03:50:40 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id n15so8186798qta.0
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 03:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2/TsmP0irQc5pIF24MIA4bGIKU/GQK3ahikbGq+EgXc=;
        b=Fipx76WpiLTYcSC0WBbZdKO1q/YrqUSX4H+G39SwDhwpyBx5iCeMKrbzPdV7eumAb7
         ArosKtcUzb+lUmvFnv9t6pxZuOpXXxKMi2Fk9paQgRioW07XWfUDc4YOsOXyHLI/5r/X
         lXQCB8UxKf3Af3qZ/KbVV50/rU/qpzs6BlG7F8Yaytv9VUWSZ5nsVKxoT2IL3cdjNnAu
         nJnMAbCxP8IkVlFstdBX47rFMYLMmwi2QIGcSLTtwQ3nti0UtnBbhWpUQJUDe/TcU8+5
         C8CreSE2HVcmvIa4/NE6FUYIUiinZ1/cQRDki4Y/rL5Cjxj/BrUKo5NE7UBUb+QsHwQs
         CK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2/TsmP0irQc5pIF24MIA4bGIKU/GQK3ahikbGq+EgXc=;
        b=soMcr3lYXQ4lK+Ni721ngX0/yS42fYUb5Vg8xlkjFel9SZNL+iIFVbzUtzWUc9tfac
         hzIxGdleJoNae9P24P0eKRW4QeZZlI1e8uKrUDJ0Yxkxyny/fXWwiK0Haysv8ax/tRl6
         /4RTcJReG+y3c3r2gc1CP1VzGrwM8YuG60m3IN4OWk2d5tJ155XgfLJAlQBU0ZlvWdos
         /ZomLOdlBQ6+k5KRDRqyyromXKG+PLpStW0T5MCN092eWCdfFSzq7g025SfYHVrBzOHQ
         1AKb3y5TAaAU9nfjOPVpS0IXlQ8wsdwiu6/dLtGVvgoqcl92GwzsW624KY9EeDxi3p9o
         EfPg==
X-Gm-Message-State: AOAM533BEAMIjMShSq5uD1i671CDq8v8EZSK1Rfa7y2aFQhpX4aT7p7Y
        P5+sK3ONWlMVYuc9rfyQqfSEIgHYoD2irA==
X-Google-Smtp-Source: ABdhPJy9k0h/jiRu8hp7Gh48VC/GaRjNZ5rfYPf168m08DhdLBT380ZScwJ5g2g4urfqbgwnhySrLw==
X-Received: by 2002:ac8:7d4e:: with SMTP id h14mr15100165qtb.35.1636717839327;
        Fri, 12 Nov 2021 03:50:39 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id v7sm2633611qki.98.2021.11.12.03.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 03:50:38 -0800 (PST)
Message-ID: <63920e68-18ed-f949-dc1a-c1cc2013e772@mojatatu.com>
Date:   Fri, 12 Nov 2021 06:50:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] selftests: forwarding: Fix packet matching in
 mirroring selftests
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, komachi.yoshiki@gmail.com,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
References: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
 <25844618-b63d-251b-f8e1-1f0c045b87f3@mojatatu.com>
 <871r3oc9xq.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <871r3oc9xq.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-10 10:22, Petr Machata wrote:
> 
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> 
>> While it makes sense to look at outer header - every other script
>> out in the wild (including your selftests) assumed inner header.
> 
> It didn't so much make assumptions as happened to work despite being
> buggy. But yeah, fair point.
> 

The problem is before this patch when the tc flower command referenced
an IP address it was for the inner header. With this change the same
command now is implying outer header.

cheers,
jamal
