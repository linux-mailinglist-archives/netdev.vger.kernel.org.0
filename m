Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20253778F4
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhEIWLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:11:08 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55423C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:10:04 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id t4-20020a05683014c4b02902ed26dd7a60so2615047otq.7
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=358iE4wossBES3Y3am8wyFYse5OYRINX1v0J5nqe1Xw=;
        b=grsFI0SH7R10mC9Xi8oaJHUtY1MVVx3i8lhgXy7Rws3ZtQat/6izyXpkhK2KwWtjD2
         xsT9+4y7VB4OVNkR1X4Evas7M5fSpqgT5UtrPjhCDedY5fLJA8CqmkC7MSkX2FNIqoFm
         oBT653+Xipf80WcBuE00Bi58AJmjgAm9UOWgRh9yV4h8+jhPKsSvYLb8tCtgd510BxBl
         mc+4VfCahrulYDP56lEBl8Vp2mAF2ch8FE54wqVpYM66PEDRsupR1bAG1cH5Tw/NUcsg
         jCpsESLQtd3MUSvkk/2pnigIBKdc8/KbaJQJzcwqgOnIrjju7uZnr5OnS1+NiAEXapmj
         TRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=358iE4wossBES3Y3am8wyFYse5OYRINX1v0J5nqe1Xw=;
        b=tabfZFnm8fcLh2+t6xAPE76Rpbri+0WWhzNvpwpLYcGQo/DP8se7+/hAUxnCiiZEig
         3jkPxtcKigGFh7zWAwP3EOxObfI3E3doKMFe1qD1IlEyVn+PJdOZt3oGw9GOaKt1y4JS
         RGbQjS3ugK3oL17AZbWG3m7+vEHPE9sbCUDVLmfJbK++fqz1uYuMzdDVPaX1xrybmdNZ
         8aIy1UE/Zzx/FWPolPBBNxwjQyADAzFxFuizOCNkOIv6YDhu8d24mGKaOp3jfi9ApfWP
         +5qejpBaHdkM30FFQBV7wX7zP+Flq52WGP23FECRpPlGKkho1M0mGAIQmZW41CdeSnAX
         siTQ==
X-Gm-Message-State: AOAM5312b2gP/weuF609qwQX3CqqV7B3xTBY1IHYsj3djgZf06BAGlUe
        ZQsmqoMhuctkAxa6ETNEzWwycEJX3C8=
X-Google-Smtp-Source: ABdhPJxA+JEnmlcFNUtdOM1v28qI3VC3j55qrr3WYDc2oUIsT5xZqL/jJxUzHdKC/rZZ5Gn8OADrJA==
X-Received: by 2002:a9d:449:: with SMTP id 67mr18123780otc.333.1620598203716;
        Sun, 09 May 2021 15:10:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id g9sm2305130oop.30.2021.05.09.15.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:10:03 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/2] tipc: bail out if algname is abnormally long
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <cover.1619886329.git.aclaudi@redhat.com>
 <0615f30dc0e11d25d61b48a65dfcb9e9f1136188.1619886329.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <64d07b61-738c-d429-96d5-1067d62ada32@gmail.com>
Date:   Sun, 9 May 2021 16:10:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0615f30dc0e11d25d61b48a65dfcb9e9f1136188.1619886329.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 10:32 AM, Andrea Claudi wrote:
> tipc segfaults when called with an abnormally long algname:
> 
> $ tipc node set key 0x1234 algname supercalifragilistichespiralidososupercalifragilistichespiralidoso
> *** buffer overflow detected ***: terminated
> 
> Fix this returning an error if provided algname is longer than
> TIPC_AEAD_ALG_NAME.
> 
> Fixes: 24bee3bf9752 ("tipc: add new commands to set TIPC AEAD key")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  tipc/node.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

applied both, thanks.

