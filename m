Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AAD3E99A9
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhHKU0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKU0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:26:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E69C061765;
        Wed, 11 Aug 2021 13:26:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r6so4813090wrt.4;
        Wed, 11 Aug 2021 13:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PUymzAPy9+RGPI1MfFiOxLUq7b/PCMvHPop/Ne0C+2E=;
        b=B+11Xijs+LVrqBYXLRUgRkfmi6+Rwmin9BX04XpS9E8lubzunip13nCr105W8osWyZ
         6OmV3xCdoGPh0ei4S4Q6K04Po/FMfg9bx4NMdxzuwcKqKucaYDyH+tCfYNJgf/cRYR9A
         J1V0UVYNP03hFQ0qzr0bVPQcYzfuEzzjOwYHDoAjVXahLyv54H4+ysnGCZhtKzl8z6lj
         sS51+3UxkWOv8Mf+haxXIyge3QI9CrajCmuoh6Hq5FtpkAlA8EvLCcNEwIt7WhVgzBv7
         MBR73AkS6WXuVOwrmuRh+aGgJFreGlskxDGNO1U9y5ZNYf9aPGSweeqD5LfhUl4q1xQo
         cvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PUymzAPy9+RGPI1MfFiOxLUq7b/PCMvHPop/Ne0C+2E=;
        b=VrGz8ITATuLYKsWn3by3mG2Wmk3lctQVyq+zuKZ9acnWE4l0zYFA+GEiKVpofD249A
         MCUbvk9hC90OjrjfDwHTSQWIp7BzKkIGa/qduKnlGKlEQRiAaWb5cuBIV8zhoJK4hPWk
         h7xwm7lEGXv99kMny6tzUmQJUMMuPXBO8267xOnOchAn51A9DLiAm0JxHVRrkKxoeXLy
         k/Fqb4oK4ri1JoMENTx/yz5PW5MY1icaUEf+c+FBhyB0cWJKq4dBwZoyczPuI+OAgaDv
         Y5sD08epkJJZ5l3+JPlL9bzalP0ZGkCvQxpPRMYB5sLeaKUYADcp1jyW1wNt/voePbW6
         A/xQ==
X-Gm-Message-State: AOAM532xoyH31snb0MU1V6ostwVvJuqEuTnF0J9OYBfE6xndXuxbS3ca
        oLYCaZ5aYs7Jz80gu8mJvLs=
X-Google-Smtp-Source: ABdhPJy/+AnDqNaO4uAXA+X6qBPIet5kjOOJkclBQSBvY1/sj9UTtmzIjdj1SHtJAZOZFaN9EfDGFQ==
X-Received: by 2002:a05:6000:128e:: with SMTP id f14mr238461wrx.167.1628713570994;
        Wed, 11 Aug 2021 13:26:10 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id p4sm422859wrq.81.2021.08.11.13.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 13:26:10 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
 <8d656f85-6f66-6c40-c4af-b05c6639b9ab@gmail.com>
 <18235a42-72ad-8471-c940-c70b476cf0e0@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <2b392d8d-ee6d-01d1-a308-cf65ff527952@gmail.com>
Date:   Wed, 11 Aug 2021 21:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <18235a42-72ad-8471-c940-c70b476cf0e0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 8:11 PM, Leonard Crestez wrote:
> On 11.08.2021 16:42, David Ahern wrote:
[..]
>>
>> any proposed simplification needs to be well explained and how it
>> relates to the RFC spec.
> 
> The local_id only exists between userspace and kernel so it's not really
> covered by the RFC.
> 
> There are objections to this and it seems to be unhelpful for userspace
> zo I will replace it with match by binding.
> 
> BTW: another somewhat dubious simplification is that I offloaded the RFC
> requirement to never add overlapping keys to userspace. So if userspace
> adds keys with same recvid that match the same TCP 4-tuple then
> connections will just start failing.
> 
> It's arguably fine to allow userspace misconfiguration to cause failures.

I think it's fine. But worth documenting. Also, keep in mind that
someone in userspace with his funny ideas might start relying on such
behavior in future.

Thanks,
        Dmitry
