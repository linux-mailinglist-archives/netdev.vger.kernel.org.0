Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEBE5F7952
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJGN6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJGN6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:58:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A50D01A1
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:58:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so2650346wmb.3
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 06:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kBLcC4wcAXGoXok1MAo9c5PgyfgZrA/TXQnPWcRbwwE=;
        b=ISqnUYy9W9nVCOS1Wi8/2q+enJ5H+myrqBmujk1pDJFOcvTgNRlwuufvFQbWgPqRQ8
         9KRXQMbh+n3a8OX/eitDBMTSuXw4OBAbGP9m+VKNEVkmmREmCGUpkD7JA6c3K4VNA8Sh
         2FaUZ4cgJqfMoOK5Tr9zOwW2DJE+BuULpNP1kjL0epxC+vFO2AvsgUyXn0bcPw/ZjeqB
         FikHPxb0X8tLcsmyLYhBRfORSPmd5pPH4MCJPJk26YNMaFeAr1fpW1x+f2O8MnkJR3w1
         kOzy48Zc6rfJUaI6wPx0KP/M589T1fW3+8eaCOsrInP5B3GR281sjI1osKNPFZHASUpX
         7DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBLcC4wcAXGoXok1MAo9c5PgyfgZrA/TXQnPWcRbwwE=;
        b=Aq5TcSq3j43BpFow3SWqrZwDID2Q7JGC7NeX3E01N42zfmTGrODWPLjUaEXx4fTONp
         wMmsK1U8/mkQoZV7bPQglxdeSC80MDdQM5Qp+lJhJXQGQiVEIUfwbcvVdb3RqElJ06BF
         ExPJLUyGS8dLz61Ed+wqbR3kL3hx2wu5dXosVuFpWk4GUNp+Ako8wJYC4fBDd0ohxuif
         pYXiHrtmsp4QtS3+XXDXQuJ0SdZgMXREjGpE2Fl8saf9KPU9RzU0CU7hOjZz3rAShLex
         Mloc6/z/KVH5iMODei/ZhruKvEprf9zcSWeoN8jQbnB8YZ8g4xTsy0cS5lwkseXt/1/S
         0L/w==
X-Gm-Message-State: ACrzQf2j/92utgoPNk/iAgMSSAJABU2YuMi7oHY3VIVNg5r7X0OYg4ej
        Pz+Qnb+L+iZ0PYBohlfUyMs=
X-Google-Smtp-Source: AMsMyM4E6KC8XlVhVJSr8FdBOHqIXDiJgjqwc3xU25PGcDfKTZr8JcD7aL3nB9yTFTZA8qjWIlh9hA==
X-Received: by 2002:a05:600c:4194:b0:3c3:d0ed:2d44 with SMTP id p20-20020a05600c419400b003c3d0ed2d44mr779100wmh.151.1665151123301;
        Fri, 07 Oct 2022 06:58:43 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c34c500b003c409244bb0sm78502wmq.6.2022.10.07.06.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 06:58:42 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
To:     Johannes Berg <johannes@sipsolutions.net>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
 <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
 <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
 <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f9bb2d52-c7f6-5aaa-37e5-59e7a2ff4a8e@gmail.com>
Date:   Fri, 7 Oct 2022 14:58:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2022 14:49, Johannes Berg wrote:
> Unless maybe we printed a warning together with the full string, so the
> user could recover it?
Ooh, I like that.
Would need to net_ratelimit of course, but that should be easy enough.

It's not quite perfect as it'd evaluate the VA_ARGS twice, potentially
 side-effecting, which the original NL_SET_ERR_MSG() took some care to
 avoid, but I think we can live with that.

-ed
