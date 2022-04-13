Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852544FEBF6
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiDMAmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiDMAmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:42:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D21D2F3AA;
        Tue, 12 Apr 2022 17:40:22 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so537420plg.5;
        Tue, 12 Apr 2022 17:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/92LxhgayvHQvotqD8rQ/NN3OrGtKvHLLNbz2KJJ8r4=;
        b=ScmEhe7fx7Btt1PUSZYo6TkOwvlgP63j7wVNDbUWBJtwnfJVWYvKpsnfKAdqO1fuuI
         hRQuWXclHQRLwFkdVIRgL3HxIOYS5hOKfXUfYDaW/UtwtCv/e/JBhCG+Qri3Ksp1u3V+
         upWGG5v51f8IIP+XlooMMQrE0BqgatrVNuf9d3KeWsf7xbpWdG1Lrq2gkIS+QIruOV2R
         /fJmigwSuMTjxmA4qOh6kYFkRtQBlDpOuqshSDmkz4ofYqSfR3Ar2htRoxQQHr11xIiR
         Nbjr6rUsdWusAfRnwI0VZ/OFaQOx0G/Zwy+EWXSE53gi+2+953NPQ25p68JekGcv2Wqg
         wtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/92LxhgayvHQvotqD8rQ/NN3OrGtKvHLLNbz2KJJ8r4=;
        b=wYtk4kNsSy1D4x46H9iNq+EF56rByqp008oUpFI3X1hnDWwE7Bkj9BuM/SPRONzwUK
         ZhVpMFx1iUPA+ofWshmjClg7erHfsp/IGsVbRkfRuQchlU7I5IjLBPS8XuKXmRVpk3K0
         r+wQ4mRG3cDh8Ee6TRJ+DKSlFRVYdWzBrKJohbyH128aTZWPIj1FE/Tr5tvQIAHn4eLh
         MpFHoYXMhiNI/qc9zDwVVx8ZjL1+pOqe3n8lSrXiNw5e+s94SXkiBMJZrHQktrhLIVHX
         Zhi+6uCSs3A7A8bNmjIFswFyh8fZim6XYRv0bUfcDiUB2rjbQBN88MuySThDz0sNKgAL
         AvLA==
X-Gm-Message-State: AOAM532sfbC4wdkcFncRHPXUAnkp4IdeDlRXNfkLPTMniGVqXGdX8oau
        YHi72uKQ6vhNghwVQxhkpTLbXSQ+RoY=
X-Google-Smtp-Source: ABdhPJwN12D43bsbdfH0KERhaaYgz1uFhGNwk4AO/9kUBmjP/y6QT27Z2q38fpOigiuKdF03AHlVQQ==
X-Received: by 2002:a17:90b:1d86:b0:1cb:9dee:a5a with SMTP id pf6-20020a17090b1d8600b001cb9dee0a5amr7908584pjb.195.1649810422036;
        Tue, 12 Apr 2022 17:40:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78009000000b004fde2dd78b0sm34221507pfi.109.2022.04.12.17.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 17:40:21 -0700 (PDT)
Message-ID: <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
Date:   Tue, 12 Apr 2022 17:40:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com
References: <20220412202613.234896-1-axboe@kernel.dk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220412202613.234896-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/12/22 13:26, Jens Axboe wrote:
> Hi,
>
> If we accept a connection directly, eg without installing a file
> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> we have a socket for recv/send that we can fully serialize access to.
>
> With that in mind, we can feasibly skip locking on the socket for TCP
> in that case. Some of the testing I've done has shown as much as 15%
> of overhead in the lock_sock/release_sock part, with this change then
> we see none.
>
> Comments welcome!
>
How BH handlers (including TCP timers) and io_uring are going to run 
safely ?

Even if a tcp socket had one user, (private fd opened by a non 
multi-threaded

program), we would still to use the spinlock.


Maybe I am missing something, but so far your patches make no sense to me.


