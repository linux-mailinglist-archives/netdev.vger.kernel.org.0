Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7745A22F920
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgG0TeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgG0TeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:34:02 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F5EC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:34:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so10465163pgm.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G+yrc+cVbzQoTZS+SoWNHS42n6iVKX0uFx0J3n39B3o=;
        b=EuviHLhTNnp17mhILpyY0PD/ArV9WA2PFUAz/KAl/ecmI/HDjv/Mn61H4p2HiMr2Kp
         woUTCVz1lajkVYUY6dJnu95xxjCSoGnqU7Jys5RN31C1h65/9axaHn6jzNwDJHiB/ETZ
         qfeCaH8UBEzhNdRCooD8ZSNHoUseVUJA2fe2DCL8P/ptjgfd/VHcT5bDhn0RG4zkeDaV
         w+FBcBMUSKRTFRM4Bifbn2pyrJGkKONQHvn26B8/WtlBtLXEsO6yiNj2jYeatqffM52k
         EDyiQ/4hdWEm/Vo/+iUtaqCsuoKwZHYXVNCwPWPf2yRCcPitGeSpUy57yjb+Y8A8JaW1
         TyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G+yrc+cVbzQoTZS+SoWNHS42n6iVKX0uFx0J3n39B3o=;
        b=RslfzvtWEKvVXpJxmAEr7bQPAmCnbNXPg5NnicL6b6wW4wMrzJ8SImqDu4Oz5Th2BB
         iWwO3CRk4gD77l0Ipmd0e7FUUbjRZo2z3n2eM18v6BB+OZpKhFaHcPrKFhIvIvYY5Gea
         idZ9sg0LOaHMKzkxYOjfxmT8039f8ditX64z6Q+nf2FTqA9bB42UXkKSoqbvyPXaL0Zy
         uX/6Sr9A2HNkMBfqjqAKy9ssuRlEF9i/Vb5ZnmzbPPKgtkWol2m56BTWp6P0V28PTpms
         UBZjHz5f8WOYHwE3a7y98rELXfIlVS2bEYGwm3mqSkXKW44Hw1ILfko8eoeqEyQfe0Bc
         UQgQ==
X-Gm-Message-State: AOAM533KCA2WaRY7NZGE0CClz0DZ8jdEGNVG0Ith5rzCNAAlp2bk/49i
        2SpW2WeKH0Q2cwXjs/HS29YupAu4
X-Google-Smtp-Source: ABdhPJwc0uqYRR5L7qo92VtSCIJh1eGmm5PWkf15sjVzrWxCavFP8xM3fL2hhMvqUtl2U/N5bSA5SA==
X-Received: by 2002:a63:e23:: with SMTP id d35mr15121719pgl.435.1595878441507;
        Mon, 27 Jul 2020 12:34:01 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p19sm15085935pgj.74.2020.07.27.12.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 12:34:00 -0700 (PDT)
Subject: Re: [PATCH net 4/4] selftests/net: tcp_mmap: fix clang warning for
 target arch PowerPC
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
References: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
 <20200727162531.4089654-5-tannerlove.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <09186bcf-eb8a-7424-6901-789914e61848@gmail.com>
Date:   Mon, 27 Jul 2020 12:33:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200727162531.4089654-5-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/20 9:25 AM, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> When size_t maps to unsigned int (e.g. on 32-bit powerpc), then the
> comparison with 1<<35 is always true. Clang 9 threw:
> warning: result of comparison of constant 34359738368 with \
> expression of type 'size_t' (aka 'unsigned int') is always true \
> [-Wtautological-constant-out-of-range-compare]
>         while (total < FILE_SZ) {
> 
> Tested: make -C tools/testing/selftests TARGETS="net" run_tests
> 
> Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

