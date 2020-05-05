Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D571C4EF6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgEEHUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:20:21 -0400
Received: from mout.web.de ([212.227.17.12]:45029 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgEEHUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588663195;
        bh=X+SAFhkAhDTiWhZqmgIoNWzzFt36lQh4mpygcLeqLmU=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=T50hVvrUOZ5uuzOp/AXzB+Iiqyu+DdMcb/iB6QQr4s4+M0FDiMhzYpqIp06wkJ/t5
         7itmakzb5DLfby7kPA+4vuAYv2zpY/6jGsjhvDtsgxvDamVwDv/1Rpoq7qAgFdMgka
         wmk0egwRs2AoiBXPOuBlvTfHZA3ubJ2iRn1zBLII=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LsQPU-1j7v0N2xCa-011wH4; Tue, 05
 May 2020 09:19:55 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Richardson <jonathan.richardson@broadcom.com>,
        =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        Ray Jui <ray.jui@broadcom.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH] net: broadcom: fix a mistake about ioremap resource
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f3208af6-80ad-223f-3490-30561996afff@web.de>
Date:   Tue, 5 May 2020 09:19:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:MiCNwKnM1T3qQS3UhuK+MQ9Zf2s0oRnF1BZ9LdeNJuII/4A1gF5
 mmNwYTQP1duSESSl55UPGXE3q0+FknRm24fPjFeBifl9bVfjgU5TBCCLODE8+kOPpkKWeg+
 boU+2nPVpSGv2WcOgyniAIaw0TVaHB7GNg3isbj2Dehthc+Ms7OO/NIxD4l0/01+K9xajFa
 LXwz/KEKoSPJhgUFs5/JA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:v4l4VSINtnY=:+wHm4Yhuu4HoTDA54tbRMW
 4oG331Jir9cs25kR5NY84PytQPS+uvtFt0xcXFPaiU3uAnkmyYUYW7NyCUSE4sylWXBMVw1FG
 fHID/PzzmEDs5FuZgtEqyN/99eeEEFAG113BvmYCFl+xq9DTFwZgBUjfXpypOLNAzRttsLX2Q
 gm8ezU/E9yi575HftGWV44G9fnZkoFoFVQeHzxgTvx4U+4zsSbhZxw+7FaakKZBQKW1RGTlbB
 v0/cZQ0Eokseesrf9nW7J9JgDCxGZ1BwBS2sLAHYNZBZVw2peO7rrl5QcLwaE9nIdOkevOw4k
 4v8HxgZkzr0IdGB53546lKWovC5jnGMRCq6A5PkWHlRsr6jU1d8X/dVtMfAK+w62c7iPWgucQ
 kna5gd7gSTKoZj0Ml4J82+vkd8Q+EJ2r7GUwoVAEmZ5lkC2cAKfYEmj7qa53T3ttgrHAPMNZZ
 zSiJJAl1fRYPAvwrhQwrPkrnh7kxFI9DaFIj1y7hV5K0MZi1KiKoKRKPnt0VaI25uU4nEnOMv
 3saqEbZIwm9gi2mnCkOLH7MElANjJ1hH4ZQsRqfoEzBUkmHgOh2d72BmkA76RXnZjcATbbJO8
 29fI0Ph8ErdtMdLKMIArbr256PZ2etehXy0gD/T81eZk5HzDwIGZZ/hI8IFmqH1fIfrrSYj5u
 Oh+EivxprsWfmwzNw511CLy5MH+2WL5Oaf1+2KCo17R3Y6Qg/7Sh1BpD/PCa7lKj9zsivS+B3
 k9bvdDYA9DQvzlQO2a8EIvhQ0TYsvHC0A2wJpVNQpXNzRrnlQCx/R/2jSJphIqDnApKmQA/Nf
 i/UgAxaGFVO2SFK+HcrlZdH7ARXza+pdpaWserwKanmOTzG/lZxzCuXfBV69DZ5BtgczfQW0k
 EvVpjP54hhp92FEbM0MklYsjabmJXoc2PfUZhfEtiyeDJ0WjyztfCLM2Ic0SbSXcQ1nki3C1L
 ele9/XqE0WUsejRv752jfRqJHLMQ/l8FWqlXNUW74kIRse48KgkyMp/Zr67WM8QyzCAY3otJA
 As3vwFWOzpEfixeT399FrevQm5s8hU0Y2vvPLzAFDKWC94WDxls7mJva8cNK3IO+0bchfDsZH
 E31GGqHbys0qoaNjwLRPqEwEAWCavBG0JnCRMheBQMSU4QevwyZHLGfUpX7PQrd/04PaipGad
 E6wM9NfaKWD75Z1b0MLCNN0IXUvXpR5vfhP2bKTDzKU7Or4Vfuy75r5QD+9TeoqePHaLX7kcq
 UgBa81plkDWFeWV9H
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Commit d7a5502b0bb8b ("net: broadcom: convert to
> devm_platform_ioremap_resource_byname()") will broke this driver.
> idm_base and nicpm_base were optional, after this change, they are
> mandatory. it will probe fails with -22 when the dtb doesn't have them
> defined. so revert part of this commit and make idm_base and nicpm_base
> as optional.

I hope that other contributors can convince you to improve also this
commit message considerably.
Would you like to fix the spelling besides other wording weaknesses?

Regards,
Markus
