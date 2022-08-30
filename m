Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10515A5C16
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiH3GsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH3GsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:48:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C05F9BC;
        Mon, 29 Aug 2022 23:48:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q3so6968383pjg.3;
        Mon, 29 Aug 2022 23:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=2aS+r6wBK2+PSFlnqjheNWbHldCaQpTeaw4a46KMjuY=;
        b=Ec33OGxGF5muwLz9d5fYWvaXj8xKc/P3EUrO9wXigYQz1+9rKaJMM7TFHm+3VEYr2M
         ugFiXyff0U78kzi1mcYpzJ3LHuquSeRyi37b6sWqQpIgGGZyKSYgGw7fxqJ15Plq/FpF
         mJCN1i/Ru/LkzdIdMX1Z8F3RPw2io63rk63qDJKmJMb1iLKvn83Iz/TRa8g4IDzBh5k6
         6Wp2wFNBXbtWGyaFdIbakIPB0mpVz/szIaL/B+c7KTUCv9WbwQGi60AuonSI/H6PK/XG
         OyXgcWWhwtX08IQTaDSwFZsKcVnnErb/ucBIJcBblgeWZxP5EFQyEz9kLdxFSPJ6VccE
         gpwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=2aS+r6wBK2+PSFlnqjheNWbHldCaQpTeaw4a46KMjuY=;
        b=S2eSKrcOUEmIxTa54alUtt+lyuqv7H0BhlPc7ufxihP8Ky7ePD+Zsw0hM5WTx8wSzg
         K1DP7NS1WuuZks01I7RnRDF8Oge7wtUmGOi3pz51p0gQ5NKVzBDYoL+PHyT8BbkoPxx5
         whhDF88AcKcGbREnIQtu5jEAdwYgh7SZqoDTLyfi22f9yQ8vxMMFfuksbQNMWJelmMQK
         Hf99mvoBFHofvCcOI9pQCjbpuqsKs786ZqHM4U73qpVl6vCgGB8InXZPTjxFIjvf+0y+
         BzNri6KtJNE5IpRTfaUsq8Kp5cHRAouZnpd4c0OuMQidO6MTwWAvWg65lWICnMPUjT6C
         b3Qw==
X-Gm-Message-State: ACgBeo3c5uoBN/TazTfGLklXL+J4bHjVGWa+H1/h97z5RGd9q9N9dujz
        7GocND56FE8wOdpSELITjPo=
X-Google-Smtp-Source: AA6agR4y+h3j8Zxspgln0iqljpUhmCF3YrxmMLFKGWzuqj8ctfETOHMFax9+eFwP7FgoHlLeuKKZiw==
X-Received: by 2002:a17:90b:1644:b0:1fb:ab0c:c5bf with SMTP id il4-20020a17090b164400b001fbab0cc5bfmr22200885pjb.27.1661842083872;
        Mon, 29 Aug 2022 23:48:03 -0700 (PDT)
Received: from [192.168.0.131] (198-27-223-25.fiber.dynamic.sonic.net. [198.27.223.25])
        by smtp.gmail.com with ESMTPSA id 142-20020a621594000000b00534bb955b36sm8475723pfv.29.2022.08.29.23.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 23:48:03 -0700 (PDT)
Message-ID: <f53dfd70-f8b3-8401-3f5a-d738b2f242e1@gmail.com>
Date:   Mon, 29 Aug 2022 23:48:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: possible deadlock in rfcomm_sk_state_change
Content-Language: en-US
To:     Jiacheng Xu <578001344xu@gmail.com>
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, David Miller <davem@davemloft.net>,
        luiz.dentz@gmail.com, Paolo Abeni <pabeni@redhat.com>
References: <CAO4S-me4hoy0W6GASU3tOFF16+eaotxPbw+kqyc6vuxtxJyDZg@mail.gmail.com>
 <CAO4S-mfTNEKCs8ZQcT09wDzxX8MfidmbTVzaFMD3oG4i7Ytynw@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
In-Reply-To: <CAO4S-mfTNEKCs8ZQcT09wDzxX8MfidmbTVzaFMD3oG4i7Ytynw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+cc Bluetooth and Networking maintainers

Hi Jiacheng,

On 28/8/22 04:03, Jiacheng Xu wrote:
> Hi,
> 
> I believe the deadlock is more than possible but actually real.
> I got a poc that could stably trigger the deadlock.
> 
> poc: https://drive.google.com/file/d/1PjqvMtHsrrGM1MIRGKl_zJGR-teAMMQy/view?usp=sharing
> 
> Description/Root cause:
> In rfcomm_sock_shutdown(), lock_sock() is called when releasing and
> shutting down socket.
> However, lock_sock() has to be called once more when the sk_state is
> changed because the
> lock is not always held when rfcomm_sk_state_change() is called. One
> such call stack is:
> 
>    rfcomm_sock_shutdown():
>      lock_sock();
>      __rfcomm_sock_close():
>        rfcomm_dlc_close():
>          __rfcomm_dlc_close():
>            rfcomm_dlc_lock();
>            rfcomm_sk_state_change():
>              lock_sock();
> 
> Besides the recursive deadlock, there is also an
> issue of a lock hierarchy inversion between rfcomm_dlc_lock() and
> lock_sock() if the socket is locked in rfcomm_sk_state_change().


Thanks for the poc and for following the trail all the way to the root 
cause - this was a known issue and I didn't realize the patch wasn't 
applied.

>  > Reference: 
https://lore.kernel.org/all/20211004180734.434511-1-desmondcheongzx@gmail.com/
> 

Fwiw, I tested the patch again with syzbot. It still applies cleanly to 
the head of bluetooth-next and seems to address the root cause.

Any thoughts from the maintainers on this issue and the proposed fix?

Best,
Desmond
