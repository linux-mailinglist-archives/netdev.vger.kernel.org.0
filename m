Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1396858568F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbiG2VjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiG2VjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:39:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72228C167;
        Fri, 29 Jul 2022 14:39:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so6406015pjf.5;
        Fri, 29 Jul 2022 14:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WnRP1Qmx7DLp9Emge7i8rbnU/Bakd2dX4zv0Y7gFqS8=;
        b=fJ6ErbnyBsgFoQ+ADGyX8lDMvVgvmIjoceH8G7PVMF2/fVd4jA7xwzguSdOwl6gM9W
         15rxzuNrf/hZWcVu98Feoxrp7UnTbthBd11DVHakl+E8x2vMTv5vV2UGZh1qB7N7vu3M
         Ta2ItKQsLpo68OQIHmYt/Mza5Ia+JyQ7VMH/ZxPzvjZKxeY3CGFHCqKPiyIoXqdcSNea
         XlgCCQiGTpKbh/YCyE/E9J9gCPheXxAYnsxuF3hIbRav87SgdXEuHGWc+9SDUSs/L4do
         U6ecm+JOUjS6u9HirU4uQTidyr9FGdccHhJVwSYI+vmaNuS6iFhcyZOjAqejql5JLkz7
         RNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WnRP1Qmx7DLp9Emge7i8rbnU/Bakd2dX4zv0Y7gFqS8=;
        b=1/oa4jV4TdGZhBRtTlNc0XV81Jd1WrSUHmC2R9jVpmuUVLF/1natm5kgPNgoA6D+km
         Pmd7Hq5sSBJL2arONvzEYjgGR/tq8GfF+HEkP/dyjeytTqr1jIF7rQCUeuCLgBAuDC5X
         RzQJ723o/R6SUXaFZ0EU5HZRk6BRp7lmlMglCF7AzmCTkslQmjg4fzDW1F8e7N03f7jo
         ETL/Aea/+mgTUTIFIwN5q4R83FFQGedFDnk8yhW+5IaBJRUyOQQylSKiJrB//h63Mq81
         ew6nqnccbL2nsHoWqHWK2Kjx7NRG3GNNPl5QflHijKojsiV+wF1QwT+WvkrxWyWPvpxx
         fR/w==
X-Gm-Message-State: ACgBeo1BuqSMvrpLMuRBv5TNATsNLTUCbisMXjPzn1buNEFoRFVsGRq4
        FcmqrVTBNnUKeiZ+g6AU6HE=
X-Google-Smtp-Source: AA6agR60eQKaTJ50xM66Mfu8Ovd0HgorgZWcafYXVjy2+Xa2f/7a6wN3OIGVA9cBvEEu2Qv6HZBokw==
X-Received: by 2002:a17:902:cf09:b0:16d:6a06:f994 with SMTP id i9-20020a170902cf0900b0016d6a06f994mr5711925plg.62.1659130753270;
        Fri, 29 Jul 2022 14:39:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id md14-20020a17090b23ce00b001f29ba338c1sm14983002pjb.2.2022.07.29.14.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:39:12 -0700 (PDT)
Message-ID: <65a5c169-7666-9879-9476-feddab37e645@gmail.com>
Date:   Fri, 29 Jul 2022 14:39:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 09/14] net: dsa: qca8k: move set age/MTU/port
 enable/disable functions to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-10-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-10-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 04:35, Christian Marangi wrote:
> The same set age, MTU and port enable/disable function are used by
> driver based on qca8k family switch.
> Move them to common code to make them accessible also by other drivers.
> While at it also drop unnecessary qca8k_priv cast for void pointers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
