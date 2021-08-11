Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0803E985D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhHKTKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhHKTKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:10:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAAFC0613D3;
        Wed, 11 Aug 2021 12:09:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id k9so5289983edr.10;
        Wed, 11 Aug 2021 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W1z9wlbpNj+qS2ENH9OLcLWtfXZ7e4t/ziztlj9T5ZM=;
        b=aWK92ZZsdHMiy5eJTgZW6Ey00F8/qlix9+mlvDycVBPJLis1JQ74CE4akL0VYd64cO
         LJzR5f8t1yBxRq/Bs9SrG2F+PSNKBg/h2CDoU3qjkbOUPXncLcLQqrT9L0SuXW9RHsle
         iifbwXcPpQ2YlLS7JjM/f9jZNl0VTaxw1Ti3wCP8ne/AhswzkzT4m1jXqwERNa7rgVc2
         ULShRw2XuxmCN10koUdxIzh2ElZ1OAFwjyfXJ2C+1gAl3vftMPzSRuB4XekBg+oPmZar
         lUGtcN9VxFVi/S2O2dXj12nxL8x4e41zf1TtQSmpE8ExHk66buhhWxJt6ij0A/C84VRg
         d49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W1z9wlbpNj+qS2ENH9OLcLWtfXZ7e4t/ziztlj9T5ZM=;
        b=UIQa/zc0idalzZBA4V0rAZWvjEl9fuv1RN3tg6CG6cB03XijWhXM20jefGI3BkTNIE
         RuNekHYnkZ5i7AlmzwCGI9JNCVs2TalTZhI5sXFpIITk1IYHNWDg6fj5pOri4m60I387
         2Knwqj1doEgWSZpbbpYm5Qx2IUS+qfLAmTIBOWexEDn2w+g91uSCuTgsxSKg7uOdr9TN
         d2mYUCStwVAGp3m5FyfNOINLcOzav01308HlVuOHh02wssa16N0uvxYzy7+HUKQPI1ew
         TABs0/3BLUV0xUkECM5zecfdIzcpZUBjRA1WhKXXSFF0RmKFX/WVm+6Wc7I+gN04bYpW
         83sg==
X-Gm-Message-State: AOAM5307JSspVUVDVh+zBWzB6ZRSlSzcgOtCpzf2E3nPXglhbqnT+IA6
        ljtRikgmDOtOar+xhwhh/VK/XGa7a+1/7STaOTA=
X-Google-Smtp-Source: ABdhPJzj8fDfXd6w0gPzUGLjzQekJ7vBDvkmKpwZquuLDTzWJzAtekZHJL3rgB9wVpFtwxxucleWqQ==
X-Received: by 2002:a05:6402:148:: with SMTP id s8mr513425edu.298.1628708975001;
        Wed, 11 Aug 2021 12:09:35 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:48ac:8fee:19a2:adc6? ([2a04:241e:502:1d80:48ac:8fee:19a2:adc6])
        by smtp.gmail.com with ESMTPSA id l9sm59895edt.55.2021.08.11.12.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 12:09:34 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv2 9/9] selftests: Initial TCP-AO support for fcnal-test
To:     David Ahern <dsahern@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1628544649.git.cdleonard@gmail.com>
 <3f6d654c1c36f489b471e2892c9231d6fa8fad7a.1628544649.git.cdleonard@gmail.com>
 <57493709-02c0-d77b-0b82-121894b58a49@gmail.com>
Message-ID: <f7625876-3ee0-53ba-a45a-a5d38edfd2bf@gmail.com>
Date:   Wed, 11 Aug 2021 22:09:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <57493709-02c0-d77b-0b82-121894b58a49@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2021 16:46, David Ahern wrote:
> On 8/9/21 3:35 PM, Leonard Crestez wrote:
>> Just test that a correct password is required.
>>
> 
> This test suite needs to be comprehensive that the UAPI works as
> designed and fails when it should - cleanly and with an extack message
> as to why some config option fails. Tests should cover the datapath -
> that it works properly when it should and fails cleanly when it should
> not. If addresses are involved in the configuration, then the tests need
> to be written for non VRFs, with VRFs and default VRF since addresses
> are relative.
> 
> Also, in tree test suites are best for the maintenance of this code
> going forward.

I can try to integrate my python test suite into kselftest. It's not a 
very orthodox choice but a rewrite in C would be much larger.

--
Regards,
Leonard
