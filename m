Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E692960CF84
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiJYOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiJYOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:48:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754118F243;
        Tue, 25 Oct 2022 07:48:50 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id jb18so4844235wmb.4;
        Tue, 25 Oct 2022 07:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBcBe5YIMobauGuiBqXg3xuJUSAXxBckHePPz8bMkq0=;
        b=neJJukcaAU9DMTXji0kQbuXURWqCNLs008Urjce3hHte2aBdxkFpGVyhSKanqpCMud
         xBThGlSNNeKg8TiHAHrswQ1uY6eD/72I9TcqDASFLbvHJKec3ThNTBDSvJB3XZEPowIB
         WOJPWshkVHnpVsL+y0dI77rMwik1eNMAX41y153UY/wjC7tXAfGwUHv+odYTn/7OB4d8
         7uk0CClDDyp7RUAc8yeglbc1+pnzZZWRs7/RuxfLnC14K/zdEaGu5f8HyvhfTNiwGjuw
         W4qegVf0oqUXfDhrN8YWCEbxBZRXOBov++rITcw1d4LVjmVAOykHce8CCTfAcyAiYyOy
         SQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBcBe5YIMobauGuiBqXg3xuJUSAXxBckHePPz8bMkq0=;
        b=skIr9xgs0DD/6VLHZWIm5RZhzaD+fHSwgCskDHkfX/30dh8lAAVTC06DiYHe+7Matm
         b1QtVrPhj4+KxIKnVvV8/kV7CKd4yww+K1ISAqaIKgSZ8fuU30axXcUjh+49XViwhwaA
         2cWbEaL3wadEvrdyjE0kk5nsKRBiaNa401LkICafGAJqKdNAmhNpsETk3S1Vtar/PbNf
         mJBoZZ9At7GYfR2M9b4LAh2ZvzgZ37Iuk43+6eRSIa/Aw22jQmnNQLH+iuAJ+5BqPIDE
         VBKSAdUF207n5DVosseYC3pBm5D5ilA61CYj0BAU+B2TQeJ8Z0iO7VomUkuHataYd1f1
         klPw==
X-Gm-Message-State: ACrzQf1dRL3VF+ms4eI/O36aAU0aHqLPnbn/IRD1Om6/JUraK02VelGq
        Ua+VgqtdbTD6two8DNG2jJ8=
X-Google-Smtp-Source: AMsMyM4Warv7e/nkFGSBwFdI4/idn9nJJhu51VnhptuON0H+u165dTjQECcyEa13HCuTXkURt7s3qQ==
X-Received: by 2002:a05:600c:a47:b0:3a6:5848:4bde with SMTP id c7-20020a05600c0a4700b003a658484bdemr46389632wmq.189.1666709328932;
        Tue, 25 Oct 2022 07:48:48 -0700 (PDT)
Received: from [10.1.2.99] (wifi-guest-gw.tecnico.ulisboa.pt. [193.136.152.65])
        by smtp.gmail.com with ESMTPSA id b9-20020a5d45c9000000b00236488f62d6sm2653927wrs.79.2022.10.25.07.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:48:48 -0700 (PDT)
Message-ID: <63b0e654-5c2c-2061-44b5-3d1b2645ad19@gmail.com>
Date:   Tue, 25 Oct 2022 15:47:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] net: also flag accepted sockets supporting msghdr
 originated zerocopy
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <cover.1666704904.git.metze@samba.org>
 <8c1ce5e77d3ec52c94d8bd1269ea1bb900c42019.1666704904.git.metze@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8c1ce5e77d3ec52c94d8bd1269ea1bb900c42019.1666704904.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/22 14:36, Stefan Metzmacher wrote:
> Without this only the client initiated tcp sockets have SOCK_SUPPORT_ZC.
> The listening socket on the server also has it, but the accepted
> connections didn't, which meant IORING_OP_SEND[MSG]_ZC will always
> fails with -EOPNOTSUPP.

Jakub pointed out a bunch of places yesterday that we have to
consider. I'll pick it up and resend with the rest. Thanks


> Fixes: e993ffe3da4b ("net: flag sockets supporting msghdr originated zerocopy")
> Cc: <stable@vger.kernel.org> # 6.0
> CC: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> CC: Jens Axboe <axboe@kernel.dk>
> Link: https://lore.kernel.org/io-uring/20221024141503.22b4e251@kernel.org/T/#m38aa19b0b825758fb97860a38ad13122051f9dda
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   net/ipv4/af_inet.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 3dd02396517d..4728087c42a5 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -754,6 +754,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
>   		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
>   		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
>   
> +	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
> +		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
>   	sock_graft(sk2, newsock);
>   
>   	newsock->state = SS_CONNECTED;

-- 
Pavel Begunkov
